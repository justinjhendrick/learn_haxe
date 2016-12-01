package;

import openfl.display.Sprite;

enum GameResult {
    CONTINUE;
    GAME_OVER;
}

class Field {
    var snake : Snake;
    
    // size measured in tiles
    public static inline var WIDTH = 40;
    public static inline var HEIGHT = 40;

    var tiles : Array<Array<Tile>> =
        [for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile.EmptyTile()]];

    public function new() {
        snake = new Snake(3, Snake.Direction.RIGHT, 3, 0, tiles);
    }

    public function every_frame() {
        // read input
        snake.move(tiles);
        trace('frame');
    }

    public function addTiles(s : Sprite) {
        for (x in 0 ... WIDTH) {
            for (y in 0 ... HEIGHT) {
                s.addChild(tiles[x][y]);
            }
        }
    }
}
