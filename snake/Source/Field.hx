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
    var first_game_over_frame = false;

    var scoreboard : Scoreboard;

    // size measured in tiles
    public static inline var WIDTH = 30;
    public static inline var HEIGHT = 30;

    public function new(_main_sprite : Sprite) {
        main_sprite = _main_sprite;
    }

    var first_frame = true;
    var frame_number = 0;
    public function every_frame() {
        if (!game_over) {
            if (first_frame) {
                tile_grid = new TileGrid(WIDTH, HEIGHT);
                main_sprite.addChild(tile_grid);

                scoreboard = new Scoreboard(null);
                main_sprite.addChild(scoreboard);

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
                first_game_over_frame = true;
            }
        } else if (first_game_over_frame) {
            Client.send_score(snake.length, "Justin", reset_scoreboard);
            first_game_over_frame = false;
            // TODO display Game Over screen
            // if score > cached score
            //   ask for name
            //   send score and name
        }
            
        if (frame_number % 1250 == 0) {
            // redraw scoreboard once per minute
            reset_scoreboard(null);
        }
        frame_number += 1;
    }

    // redraw the scoreboard with new data
    // reset(null) gets from server
    // reset(string) uses string data
    function reset_scoreboard(new_scores : String) {
        main_sprite.removeChild(scoreboard);
        scoreboard = new Scoreboard(new_scores);
        main_sprite.addChild(scoreboard);
    }
}
