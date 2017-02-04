import Defold.hash;
import defold.Go;
import defold.Msg;
import defold.types.Message;
import defold.types.Hash;

typedef MagicFxData = {
    @property("left") var direction:Hash;
}

class MagicFx extends defold.support.Script<MagicFxData> {
    override function init(self:MagicFxData) {
        Msg.post("#", Messages.lights_off);
        if (self.direction == hash("left")) {
            Go.set(".", GoProperties.euler.z, 0);
            Go.animate(".", GoProperties.euler.z, PLAYBACK_LOOP_FORWARD, 360, EASING_LINEAR, 5 + Math.random());
        } else {
            Go.set(".", GoProperties.euler.z, 0);
            Go.animate(".", GoProperties.euler.z, PLAYBACK_LOOP_FORWARD, -360, EASING_LINEAR, 4 + Math.random());
        }
    }

    override function on_message<T>(self:MagicFxData, message_id:Message<T>, message:T, _) {
        switch (message_id) {
            case Messages.lights_on:
                Msg.post("#light", GoMessages.enable);
            case Messages.lights_off:
                Msg.post("#light", GoMessages.disable);
        }
    }
}
