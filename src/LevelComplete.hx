import Defold.hash;
using defold.Gui; // also apply gui methods as static extension to GuiNode
import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Message;
import defold.types.Hash;
import defold.support.ScriptOnInputAction;

class LevelComplete extends defold.support.GuiScript<{}> {

    override function init(_) {
        Msg.post("#", Messages.Hide);
    }

    override function on_message<T>(_, message_id:Message<T>, _, _) {
        switch (message_id) {
            case Messages.Hide:
                Msg.post("#", GoMessages.disable);
                Msg.post(".", GoMessages.release_input_focus);
            case Messages.Show:
                Msg.post("#", GoMessages.enable);
                Msg.post(".", GoMessages.acquire_input_focus);
        }
    }

    override function on_input(_, action_id:Hash, action:ScriptOnInputAction) {
        if (action_id == hash("touch") && action.pressed) {
            var continueButton = Gui.get_node("continue");
            if (continueButton.pick_node(action.x, action.y)) {
                Msg.post("board#script", Messages.NextLevel);
                Msg.post("#", Messages.Hide);
            }
        }
        // Consume all input until we're gone.
        return true;
    }
}
