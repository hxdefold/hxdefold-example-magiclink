import Defold.hash;
using defold.Gui; // also apply gui methods as static extension to GuiNode
import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Hash;
import defold.types.Message;
import defold.support.ScriptOnInputAction;

class Restart extends defold.support.GuiScript<{}> {
    override function on_message<T>(_, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.hide:
                Msg.post("#", GoMessages.disable);
                Msg.post(".", GoMessages.release_input_focus);
            case Messages.show:
                Msg.post("#", GoMessages.enable);
                Msg.post(".", GoMessages.acquire_input_focus);
        }
    }

    override function on_input(_, action_id:Hash, action:ScriptOnInputAction) {
        if (action_id == hash("touch") && action.pressed) {
            var yes = Gui.get_node("yes");
            var no = Gui.get_node("no");
            var quit = Gui.get_node("quit");

            if (no.pick_node(action.x, action.y)) {
                Msg.post("#", Messages.hide);
                Msg.post("/board#gui", Messages.show);
            } else if (yes.pick_node(action.x, action.y)) {
                Msg.post("board:/board#script", Messages.restart_level);
                Msg.post("/board#gui", Messages.show);
                Msg.post("#", Messages.hide);
            } else if (quit.pick_node(action.x, action.y)) {
                Msg.post("main:/main#script", Messages.to_main_menu);
                Msg.post("#", Messages.hide);
            }
        }
        // Consume all input until we're gone.
        return true;
    }
}
