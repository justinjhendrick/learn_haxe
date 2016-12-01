package;

import openfl.display.Sprite;

enum GameResult {
    CONTINUE;
    GAME_OVER;
}

class Field {
    var snake : Snake;
    var tile_grid : TileGrid;

    // size measured in tiles
    public static inline var WIDTH = 40;
    public static inline var HEIGHT = 40;

    public function new(main_sprite : Sprite) {
        tile_grid = new TileGrid(WIDTH, HEIGHT, main_sprite);
        snake = new Snake(3, Snake.Direction.RIGHT, 3, 0, tile_grid);
    }

    public function every_frame() {
        // read input
        snake.move(tile_grid);
        trace('frame');
    }
}
