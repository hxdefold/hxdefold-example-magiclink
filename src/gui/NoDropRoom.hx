package gui;

import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Message;

typedef NoDropRoomData = {t:Float}

class NoDropRoom extends defold.support.GuiScript<NoDropRoomData> {
    override function init(self:NoDropRoomData) {
        Msg.post("#", Messages.hide);
        self.t = 0;
    }
    override function update(self:NoDropRoomData, dt:Float) {
        if (self.t < 0)
            Msg.post("#", Messages.hide);
        else
            self.t -= dt;
    }

    override function on_message<T>(self:NoDropRoomData, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.hide:
                Msg.post("#", GoMessages.disable);
            case Messages.show:
                self.t = 1;
                Msg.post("#", GoMessages.enable);
        }
    }
}
