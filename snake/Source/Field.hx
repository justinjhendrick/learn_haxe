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
        switch(Player.get_input()) {
            case Player.Input.UP: snake.set_dir(Snake.Direction.UP);
            case Player.Input.DOWN: snake.set_dir(Snake.Direction.DOWN);
            case Player.Input.LEFT: snake.set_dir(Snake.Direction.LEFT);
            case Player.Input.RIGHT: snake.set_dir(Snake.Direction.RIGHT);
            case Player.Input.PAUSE: // TODO
            case Player.Input.NONE: // do nothing
        }

        // move the snake
        snake.move(tile_grid);
    }
}
