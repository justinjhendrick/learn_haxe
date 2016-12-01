package;

class Util {
    public static function Modulo(n : Int, d : Int) : Int {
        var r = n % d;
        if(r < 0) r += d;
        return r;
    }
}
