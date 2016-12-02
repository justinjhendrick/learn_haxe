package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;

enum GameResult {
    CONTINUE;
    GAME_OVER;
}

class Field {
    var snake : Snake;
    var tile_grid : TileGrid;
    var main_sprite : Sprite;
    var game_over = false;

    // size measured in tiles
    public static inline var WIDTH = 30;
    public static inline var HEIGHT = 30;

    public function new(_main_sprite : Sprite) {
        main_sprite = _main_sprite;
    }

    var first_frame = true;
    public function every_frame() {
        if (!game_over) {
            if (first_frame) {
                tile_grid = new TileGrid(WIDTH, HEIGHT);
                main_sprite.addChild(tile_grid);
                main_sprite.stage.addEventListener(
                        Event.RESIZE, tile_grid.create_grid_bitmap);
                main_sprite.stage.addEventListener(
                        Event.RESIZE, tile_grid.redraw_apple);
                snake = new Snake(3, Snake.Direction.RIGHT, 3, 0, tile_grid);
                tile_grid.place_apple(snake);
                first_frame = false;
            }

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
            var result : Field.GameResult = snake.move(tile_grid);
            if (result == Field.GameResult.GAME_OVER) {
                game_over = true;
            }
        } else {
            Client.main(snake.length, "Justin");
            // TODO display Game Over screen?
            // TODO highscore calculation
        }
    }
}
