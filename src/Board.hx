import Defold.hash;
using defold.Gui; // also apply gui methods as static extension to GuiNode
import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Message;
import defold.types.Hash;
import defold.support.ScriptOnInputAction;

class Board extends defold.support.GuiScript<{}> {

    override function init(_) {
        Msg.post("#", Messages.Show);
        Msg.post("/restart#gui", Messages.Hide);
        Msg.post("/level_complete#gui", Messages.Hide);
    }

    override function on_message<T>(_, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.Hide:
                Msg.post("#", GoMessages.disable);
            case Messages.Show:
                Msg.post("#", GoMessages.enable);
            case Messages.SetDropCounter:
                var n = Gui.get_node("drop_counter");
                n.set_text(message.drops + " x");
        }
    }

    override function on_input(_, action_id:Hash, action:ScriptOnInputAction) {
        if (action_id == hash("touch") && action.pressed) {
            var restart = Gui.get_node("restart");
            var drop = Gui.get_node("drop");

            if (restart.pick_node(action.x, action.y)) {
                // Show the restart dialog box.
                Msg.post("/restart#gui", Messages.Show);
                Msg.post("#", Messages.Hide);
            } else if (drop.pick_node(action.x, action.y)) {
                Msg.post("/board#script", Messages.Drop);
            }
        }
        return false;
    }
}
