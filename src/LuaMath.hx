// this one is here because math.random signature don't support m,n in haxe 3.4
// externs (was fixed after the release)
@:native("_G.math")
extern class LuaMath {
    static function random(?m:Float, ?n:Float):Float;
}
