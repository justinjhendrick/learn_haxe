
enum GameResult {
    CONTINUE;
    GAME_OVER;
}

class Field {
    var snake : Snake;
    
    // size measured in tiles
    static inline var WIDTH = 40;
    static inline var HEIGHT = 40;

    var tiles : Array<Array<Tile>> =
        [for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile.EmptyTile()]];

    function new() {
    }

    static function main() {
        var field = new Field();
        field.play();
    }

    function play() {
        snake = new Snake(3, RIGHT, 3, 0);
    }

}
