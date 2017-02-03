import defold.Go;

class Connector extends defold.support.Script<{}> {
    override function init(_) {
        Go.set_scale(0.18);				// render scaled down
        Go.set(".", "position.z", 1);	// put on top
    }
}
