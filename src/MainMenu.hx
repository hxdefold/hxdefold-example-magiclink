import Defold.hash;
using defold.Gui; // also apply gui methods as static extension to GuiNode
import defold.Go.GoMessages;
import defold.Msg;
import defold.types.Hash;
import defold.support.ScriptOnInputAction;
import defold.Vmath;

// this one is here because math.random signature don't support m,n in haxe 3.4
// externs (was fixed after the release)
@:native("_G.math")
extern class LuaMath {
    static function random(?m:Float, ?n:Float):Float;
}

class MainMenu extends defold.support.GuiScript<{}> {

    override function init(_) {
        Msg.post(".", GoMessages.acquire_input_focus);

        var bs = ["brick1", "brick2", "brick3", "brick4", "brick5", "brick6"];
        for (b in bs) {
            var n = Gui.get_node(b);
            var rt = (LuaMath.random() * 3) + 1;
            var a = LuaMath.random(-45, 45);
            n.set_color(Vmath.vector4(1, 1, 1, 0));
            n.animate("position.y", -100 - LuaMath.random(0, 50), EASING_INSINE, 1 + rt, 0, null, PLAYBACK_LOOP_FORWARD);
            n.animate("color.w", 1, EASING_INSINE, 1 + rt, 0, null, PLAYBACK_LOOP_FORWARD);
            n.animate("rotation.z", a, EASING_INSINE, 1 + rt, 0, null, PLAYBACK_LOOP_FORWARD);
        }

        Gui.get_node("start").animate("color.x", 1, EASING_INOUTSINE, 1, 0, null, PLAYBACK_LOOP_PINGPONG);
    }

    override function on_input<T>(_, action_id:Hash, action:ScriptOnInputAction) {
        if (action_id == hash("touch") && action.pressed) {
            var start = Gui.get_node("start");
            if (start.pick_node(action.x, action.y))
                Msg.post("/main#script", Messages.StartGame);
        }
        return false;
    }
}
