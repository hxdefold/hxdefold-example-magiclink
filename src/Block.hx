import Defold.hash;
import defold.Factory;
import defold.Go;
import defold.Msg;
import defold.Sprite;
import defold.Vmath;
import defold.types.Hash;
import defold.types.Message;

private typedef BlockData = {
    @property("none") var color:Hash;
    var fx1:Null<Hash>;
    var fx2:Null<Hash>;
    var cover:Null<Hash>;
}

class Block extends defold.support.Script<BlockData> {
    override function init(self:BlockData) {
        Go.set_scale(0.18); // render scaled down

        self.fx1 = null;
        self.fx2 = null;
        Msg.post("#cover", GoMessages.disable);

        if (self.color != null)
            Msg.post("#sprite", SpriteMessages.play_animation, {id: self.color});
        else
            Msg.post("#sprite", GoMessages.disable);
    }

    override function final_(self:BlockData) {
        if (self.fx1 != null)
            Go.delete(self.fx1);
        if (self.fx2 != null)
            Go.delete(self.fx2);
        if (self.cover != null)
            Go.delete(self.cover);
    }

    override function on_message<T>(self:BlockData, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.make_magic:
                self.color = hash("magic");
                Msg.post("#cover", GoMessages.enable);
                Msg.post("#sprite", GoMessages.enable);
                Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("magic-sphere_layer1")});

                var hleft = hash("left");   // these extra vars are needed since the magic lua.Table.create is bugged
                var hright = hash("right"); // because of the analyzer extracts its argument expressions into a local var
                self.fx1 = Factory.create("#fxfactory", Vmath.vector3(0, 0, 0), null, lua.Table.create({direction: hleft}));
                self.fx2 = Factory.create("#fxfactory", Vmath.vector3(0, 0, 0), null, lua.Table.create({direction: hright}));

                Msg.post(self.fx1, GoMessages.set_parent, {parent_id: Go.get_id(), keep_world_transform: 0});
                Msg.post(self.fx2, GoMessages.set_parent, {parent_id: Go.get_id(), keep_world_transform: 0});

                Go.set(self.fx1, "position.z", 0.01);
                Go.set(self.fx1, "scale", 1);
                Go.set(self.fx2, "position.z", 0.02);
                Go.set(self.fx2, "scale", 1);
            case Messages.lights_on | Messages.lights_off:
                Msg.post(self.fx1, message_id);
                Msg.post(self.fx2, message_id);
        }
    }
}
