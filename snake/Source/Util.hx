package;

class Util {
    public static function modulo(n : Int, d : Int) : Int {
        var r = n % d;
        if(r < 0) r += d;
        return r;
    }

    public static function round_up(n : Float) : Int {
        return Std.int(n) + 1;
    }
}
