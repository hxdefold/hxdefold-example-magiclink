import Defold.hash;
import defold.Go;
import defold.Factory;
import defold.Msg;
import defold.Vmath;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;

private typedef BoardData = {
    @property(0) var timer:Float;

    /**
        Contains the board structure
    **/
    var board:Array<Array<BlockData>>;

    /**
        List of all blocks. Used for easy filtering on selection.
    **/
    var blocks:Array<BlockData>;

    /**
        Current selection chain
    **/
    var chain:Array<BlockData>;

    /**
        Connector elements to mark the selection chain
    **/
    var connectors:Array<Hash>;

    /**
        Number of magic blocks on the board
    **/
    var num_magic:Int;

    /**
        Number of drops you have available
    **/
    var drops:Int;

    /**
        Drag touch input
    **/
    var dragging:Bool;

    var neighbors:Array<BlockData>;

}

private typedef BlockData = {
    var id:Hash;
    var color:Hash;
    var x:Int;
    var y:Int;
    @:optional var region:Int;
    @:optional var neighbors:Int;
}

class Board extends defold.support.Script<BoardData> {
    // instead of original hash("removing") which is value of another type
    // we're using this marker block instance (should be faster too)
    static var REMOVING_BLOCK:BlockData = {id: null, color: null, x: -1, y: -1};

    /** Distance between block centers **/
    static inline var blocksize = 80;

    /** Left and right edge. **/
    static inline var edge = 40;

    /** Bottom edge. **/
    static inline var bottom_edge = 50;

    /** Number of columns **/
    static inline var boardwidth = 7;

    /** Number of rows **/
    static inline var boardheight = 9;

    /** Center offset for connector gfx since there's shadow below in the block img **/
    static var centeroff = Vmath.vector3(8, -8, 0);

    /** The number of blocks dropped on a "drop" **/
    static inline var dropamount = 3;

    static var colors = [hash("orange"), hash("pink"), hash("blue"), hash("yellow"), hash("green")];

    /**
        INIT
    **/
    override function init(self:BoardData) {
        self.board = [];
        self.blocks = [];
        self.chain = [];
        self.connectors = [];
        self.num_magic = 3;
        self.drops = 1;
        self.dragging = false;
    }

    /**
        Build a list of blocks in 1 dimension for easy filtering.
    **/
    static function build_blocklist(self:BoardData) {
        self.blocks = [];
        for (x in 0...self.board.length) {
            var col = self.board[x];
            for (y in 0...col.length) {
                var b = col[y];
                if (b != null)
                    self.blocks.push({id: b.id, color: b.color, x: b.x, y: b.y});
            }
        }
    }

    /**
        Build list of all current magic blocks.
    **/
    static function magic_blocks(self:BoardData):Array<BlockData> {
        var magic = [];
        for (x in 0...boardwidth) {
            for (y in 0...boardheight) {
                var block = self.board[x][y];
                if (block != null && block.color == hash("magic"))
                    magic.push(block);
            }
        }
        return magic;
    }

    /**
        Count the number of connected regions among the magic blocks.
    **/
    static function count_magic_regions(blocks:Array<BlockData>):Int {
        var maxr = 0;
        for (m in blocks) {
            if (m.region > maxr)
                maxr = m.region;
        }
        return maxr;
    }

    /**
        Filter out adjacent magic blocks
    **/
    static function adjacent_magic_blocks(blocks:Array<BlockData>, block:BlockData):Array<BlockData> {
        return blocks.filter(function(e)
            return (block.x == e.x && Math.abs(block.y - e.y) == 1)
                || (block.y == e.y && Math.abs(block.x - e.x) == 1)
        );
    }

    /**
        Spread region to neighbors
    **/
    static function mark_neighbors(blocks:Array<BlockData>, block:BlockData, region:Int) {
        var neighbors = adjacent_magic_blocks(blocks, block);
        for (m in neighbors) {
            if (m.region == null) {
                m.region = region;
                mark_neighbors(blocks, m, region);
            }
        }
    }

    /**
        Mark all magic block regions
    **/
    static function mark_magic_regions(self) {
        var m_blocks = magic_blocks(self);

        // 1. Clear all region marks and count neighbors
        for (m in m_blocks) {
            m.region = null;
            m.neighbors = adjacent_magic_blocks(m_blocks, m).length;
        }

        // 2. Assign regions and spread them
        var region = 1;
        for (m in m_blocks) {
            if (m.region == null) {
                m.region = region;
                mark_neighbors(m_blocks, m, region);
                region++;
            }
        }

        return m_blocks;
    }

    /**
        Set hightlight for all magic blocks
    **/
    static function highlight_magic(blocks:Array<BlockData>) {
        for (m in blocks) {
            if (m.neighbors > 0)
                Msg.post(m.id, Messages.lights_on);
            else
                Msg.post(m.id, Messages.lights_off);
        }
    }

    /**
        Clear the board
    **/
    static function clear_board(self:BoardData) {
        for (col in self.board) {
            for (i in 0...col.length) {
                if (col[i] != null) {
                    Go.delete(col[i].id);
                    col[i] = null;
                }
            }
        }
    }

    /**
        Returns a list of neighbor blocks of the same color as the
        block on x, y
    **/
    static function same_color_neighbors(self:BoardData, x:Int, y:Int) {
        return self.blocks.filter(function(v)
            return (v.id != self.board[x][y].id) &&
                   (v.x == x || v.x == x - 1 || v.x == x + 1) &&
                   (v.y == y || v.y == y - 1 || v.y == y + 1) &&
                   (v.color == self.board[x][y].color)
        );
    }

    /**
        Remove the currently selected block-chain
    **/
    static function remove_chain(self:BoardData) {
        // Delete all chained blocks
        for (c in self.chain) {
            self.board[c.x][c.y] = REMOVING_BLOCK;
            Go.delete(c.id);
        }
        self.chain = [];
    }

    /**
        Set removed blocks to null
    **/
    static function nilremoved(self:BoardData) {
        for (col in self.board) {
            for (i in 0...col.length) {
                if (col[i] == REMOVING_BLOCK)
                    col[i] = null;
            }
        }
    }

    /**
        Does the block exist in the list of blocks?
    **/
    static function in_blocklist(blocks:Array<BlockData>, block:Hash):Bool {
        for (b in blocks)
            if (b.id == block)
                return true;
        return false;
    }

    /**
        Find spots for a drop.
    **/
    static function dropspots(self:BoardData):Array<{x:Int,y:Int}> {
        var spots = [];
        for (x in 0...boardwidth) {
            for (y in 0...boardheight) {
                if (self.board[x][y] == null) {
                    spots.push({x: x, y: y});
                    break;
                }
            }
        }
        // If more than dropamount, randomly remove a slot until dropamount
        for (c in 1...spots.length - dropamount)
            spots.splice(Std.random(spots.length), 1);
        return spots;
    }

    /**
        Perform the drop
    **/
    static function drop(self:BoardData, spots:Array<{x:Int,y:Int}>) {
        for (s in spots) {
            var pos = Vmath.vector3();
            pos.x = edge + blocksize / 2 + blocksize * s.x;
            pos.y = 1000;
            var c = colors[Std.random(colors.length)];  // Pick a random color
            var id = Factory.create("#blockfactory", pos, null, lua.Table.create({color: c}));
            Go.animate(id, "position.y", PLAYBACK_ONCE_FORWARD, bottom_edge + blocksize / 2 + blocksize * s.y, EASING_OUTBOUNCE, 0.5);
            // Calc new z
            Go.set(id, "position.z", s.x * -0.1 + s.y * 0.01);

            self.board[s.x][s.y] = { id: id, color: c,  x: s.x, y: s.y };
        }

        // Rebuild blocklist
        build_blocklist(self);
    }

    // just a debug function to print out the board
    static function printBoard(self:BoardData, ?caption:String) {
        if (caption != null)
            trace(caption);

        for (y in 0...boardheight) {
            var r = [];
            for (x in 0...boardwidth) {
                var cell = self.board[x][boardheight-y-1];
                r.push(if (cell == null) " " else if (cell.color == hash("magic")) "*" else "x");
            }
            trace(r.join(" "));
        }
    }

    /**
        Apply shift-down logic to all blocks.
    **/
    static function slide_board(self:BoardData) {
        // Slide all remaining blocks down into blank spots.
        // Going column by column makes this easy.
        for (x in 0...boardwidth) {
            var dy = 0;
            for (y in 0...boardheight) {
                if (self.board[x][y] != null) {
                    if (dy > 0) {
                        // Move down dy steps
                        self.board[x][y - dy] = self.board[x][y];
                        self.board[x][y] = null;
                        // Calc new position
                        self.board[x][y - dy].y = self.board[x][y - dy].y - dy;
                        Go.animate(self.board[x][y-dy].id, "position.y", PLAYBACK_ONCE_FORWARD, bottom_edge + blocksize / 2 + blocksize * (y - dy), EASING_OUTBOUNCE, 0.3);
                        // Calc new z
                        Go.set(self.board[x][y-dy].id, "position.z", x * -0.1 + (y-dy) * 0.01);
                    }
                } else {
                    dy++;
                }
            }
        }
        // blocklist needs updating
        build_blocklist(self);
    }

    static function build_board(self:BoardData) {
        lua.Math.randomseed(lua.Os.time());
        var pos = Vmath.vector3();
        for (x in 0...boardwidth) {
            pos.x = edge + blocksize / 2 + blocksize * x;
            self.board[x] = [];
            for (y in 0...boardheight) {
                pos.y = bottom_edge + blocksize / 2 + blocksize * y;
                // Calc z
                pos.z = x * -0.1 + y * 0.01;
                var c = colors[Std.random(colors.length)]; // Pick a random color
                var id = Factory.create("#blockfactory", pos, null, lua.Table.create({color: c}));
                self.board[x][y] = {id: id, color: c, x: x, y: y};
            }
        }

        //  Distribute magic blocks.
        var y = 0;
        var step = Std.int(boardheight / self.num_magic);
        while (y < boardheight) {
            var set = false;
            while (!set) {
                var rand_y = Std.int(LuaMath.random(Math.floor(y), Math.min(boardheight - 1, Math.floor(y + boardheight / self.num_magic))));
                var rand_x = Std.int(LuaMath.random(0, boardwidth - 1));
                if (self.board[rand_x][rand_y].color != hash("magic")) {
                    Msg.post(self.board[rand_x][rand_y].id, Messages.make_magic);
                    self.board[rand_x][rand_y].color = hash("magic");
                    set = true;
                }
            }
            y += step;
        }

        // Build 1d list that we can easily filter.
        build_blocklist(self);

        var magic_blocks = mark_magic_regions(self);
        if (count_magic_regions(magic_blocks) == 1) {
            // Win from start. Make new board.
            clear_board(self);
            build_board(self);
        }
        highlight_magic(magic_blocks);
    }


    /**
        Apply the shifting logic to magic blocks. Only slide to positions
        marked for removal with REMOVING_BLOCK
    **/
    static function slide_magic_blocks(self:BoardData) {
        // Slide all magic blocks to the side that should slide first.
        // This works best going row by row!
        for (y in 0...boardheight) {
            var row_m = [];
            // Build list of magic blocks on this row.
            for (x in 0...boardwidth) {
                if (self.board[x][y] != null && self.board[x][y] != REMOVING_BLOCK && self.board[x][y].color == hash("magic"))
                    row_m.push(self.board[x][y]);
            }

            var mc = row_m.length + 1;
            // Go through list, slide and remove if possible. Reiterate until the list does not shrink.
            while (row_m.length < mc) {
                mc = row_m.length;
                for (i in 0...row_m.length) {
                    var x = row_m[i].x;
                    if (y > 0 && self.board[x][y-1] == REMOVING_BLOCK) {
                        // Hole below, do nothing.
                        row_m[i] = null;
                    } else if (x > 0 && self.board[x-1][y] == REMOVING_BLOCK) {
                        // Hole to the left! Slide magic block there
                        self.board[x-1][y] = self.board[x][y];
                        self.board[x-1][y].x = x - 1;
                        Go.animate(self.board[x][y].id, "position.x", PLAYBACK_ONCE_FORWARD, edge + blocksize / 2 + blocksize * (x - 1), EASING_OUTBOUNCE, 0.3);
                        // Calc new z
                        Go.set(self.board[x][y].id, "position.z", (x - 1) * -0.1 + y * 0.01);
                        self.board[x][y] = REMOVING_BLOCK; // Will be nilled later
                        row_m[i] = null;
                    } else if (x < boardwidth - 1 && self.board[x + 1][y] == REMOVING_BLOCK) {
                        // Hole to the right. Slide magic block there
                        self.board[x+1][y] = self.board[x][y];
                        self.board[x+1][y].x = x + 1;
                        Go.animate(self.board[x+1][y].id, "position.x", PLAYBACK_ONCE_FORWARD, edge + blocksize / 2 + blocksize * (x + 1), EASING_OUTBOUNCE, 0.3);
                        // Calc new z
                        Go.set(self.board[x+1][y].id, "position.z", (x + 1) * -0.1 + y * 0.01);
                        self.board[x][y] = REMOVING_BLOCK; // Will be nilled later
                        row_m[i] = null;
                    }
                }
            }
        }
    }

    override function on_message<T>(self:BoardData, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.start_level:
                self.num_magic = message.difficulty + 1;
                build_board(self);

                Msg.post("#gui", Messages.set_drop_counter, {drops: self.drops});

                Msg.post("present_level#gui", gui.PresentLevel.ShowMessage, {level: message.difficulty});
                // Wait some...
                Go.animate("#", "timer", PLAYBACK_ONCE_FORWARD, 1, EASING_LINEAR, 2, 0, function(_, _, _) {
                    Msg.post("present_level#gui", Messages.hide);
                    Msg.post(".", GoMessages.acquire_input_focus);
                });

            case Messages.restart_level:
                clear_board(self);
                build_board(self);
                self.drops = 1;
                Msg.post("#gui", Messages.set_drop_counter, {drops: self.drops});
                Msg.post(".", GoMessages.acquire_input_focus);

            case Messages.level_completed:
                // turn off input
                Msg.post(".", GoMessages.release_input_focus);

                // Animate the magic!
                for (m in magic_blocks(self)) {
                    Go.set_scale(0.17, m.id);
                    Go.animate(m.id, "scale", PLAYBACK_LOOP_PINGPONG, 0.19, EASING_INSINE, 0.5, 0);
                }

                // Show completion screen
                Msg.post("level_complete#gui", Messages.show);

            case Messages.next_level:
                clear_board(self);
                self.drops++;
                // Difficulty level is number of magic blocks - 1
                Msg.post("#", Messages.start_level, {difficulty: self.num_magic});

            case Messages.drop:
                var s = dropspots(self);
                if (s.length == 0) {
                    // Can't perform drop
                    Msg.post("no_drop_room#gui", Messages.show);
                } else if (self.drops > 0) {
                    // Do the drop
                    drop(self, s);
                    self.drops--;
                    Msg.post("#gui", Messages.set_drop_counter, {drops: self.drops});
                }
        }
    }

    override function on_input(self:BoardData, action_id:Hash, action:ScriptOnInputAction) {
        if (action_id != hash("touch"))
            return false;
        if (action.value == 1) {
            // What block was touched or dragged over?
            var x = Math.floor((action.x - edge) / blocksize);
            var y = Math.floor((action.y - edge) / blocksize);

            if (x < 0 || x >= boardwidth || y < 0 || y >= boardheight || self.board[x][y] == null) {
                // outside board.
                return false;
            }

            // If trying to manipulate magic blocks, ignore.
            if (self.board[x][y].color == hash("magic"))
                return false;

            if (action.pressed) {
                self.neighbors = same_color_neighbors(self, x, y);
                self.chain = [self.board[x][y]];

                // Mark block.
                var p = Go.get_position(self.board[x][y].id);
                self.connectors.push(Factory.create("#connectorfactory", p + centeroff));

                self.dragging = true;
            } else if (self.dragging) {
                // then drag
                if (in_blocklist(self.neighbors, self.board[x][y].id) && !in_blocklist(self.chain, self.board[x][y].id)) {
                    // dragging over a same-colored neighbor
                    self.chain.push(self.board[x][y]);
                    self.neighbors = same_color_neighbors(self, x, y);

                    // Mark block.
                    var p = Go.get_position(self.board[x][y].id);
                    var id = Factory.create("#connectorfactory", p + centeroff);
                    self.connectors.push(id);
                }
            }
        } else if (action.released) {
            // Player released touch.
            self.dragging = false;

            if (self.chain.length > 1) {
                // There is a chain of blocks. Remove it from board and refill board.
                remove_chain(self);
                slide_magic_blocks(self);
                nilremoved(self);
                // Slide remaining blocks down.
                slide_board(self);

                var magic_blocks = mark_magic_regions(self);
                // Highlight adjacent magic blocks.
                if (count_magic_regions(magic_blocks) == 1) {
                    // Win!
                    Msg.post("#", Messages.level_completed);
                }
                highlight_magic(magic_blocks);
            }
            // Empty chain of connector graphics.
            for (c in self.connectors)
                Go.delete(c);
            self.connectors = [];
        }
        return false;
    }

    override function on_reload(_) {
        // Msg.post("#", Messages.level_completed);

        // Add reload-handling code here
        // Remove this function if not needed
    }
}
