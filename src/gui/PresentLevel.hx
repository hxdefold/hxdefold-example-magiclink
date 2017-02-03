package gui;

using defold.Gui; // also apply gui methods as static extension to GuiNode
import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Message;

class PresentLevel extends defold.support.GuiScript<{}> {
    public static var ShowMessage(default,never) = new Message<{level:Int}>("show");

    override function init(_) Msg.post("#", Messages.hide);

    override function on_message<T>(_, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.hide:
                Msg.post("#", GoMessages.disable);
            case ShowMessage:
                var n = Gui.get_node("message");
                n.set_text("Level " + message.level);
                Msg.post("#", GoMessages.enable);
        }
    }
}
