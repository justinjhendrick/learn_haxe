package;

class Util {

    // A modulo that properly handles negative numbers
    // for example -2 mod 6 = 4
    public static function modulo(n : Int, d : Int) : Int {
        var r = n % d;
        if(r < 0) r += d;
        return r;
    }

    // round a float towards greater absolute value
    public static function round_up(n : Float) : Int {
        if (n == 0.0) {
            return 0;
        } else if (n > 0.0) {
            return Std.int(n) + 1;
        } else {
            return Std.int(n) - 1;
        }
    }
}
