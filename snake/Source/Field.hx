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

    // init is called on the first frame.
    // This can't be done in new() because
    // Sprites created before the first frame
    // don't get drawn (and I don't know why)
    public function init() {
        tile_grid = new TileGrid(WIDTH, HEIGHT);
        main_sprite.addChild(tile_grid);

        scoreboard = new Scoreboard(null);

        main_sprite.stage.addEventListener(
                Event.RESIZE, tile_grid.create_grid_bitmap);
        main_sprite.stage.addEventListener(
                Event.RESIZE, tile_grid.redraw_apple);
        snake = new Snake(3, Snake.Direction.RIGHT, 3, 0, tile_grid);
        tile_grid.place_apple(snake);
    }

    var first_frame = true;
    public function every_frame() {
        if (!game_over) {
            if (first_frame) {
                init();
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
            init_game_over();
            first_game_over_frame = false;
        }
    }

    // display game over text and maintain hi score list
    function init_game_over() {
        var score = snake.length;

        // create the game over screen
        var is_hi_score = scoreboard.is_new_hi_score(score);
        var game_over_screen = new GameOverScreen(is_hi_score);
        game_over_screen.x = Tile.tile_width * Field.WIDTH / 2 -
            game_over_screen.width_px / 2;
        game_over_screen.y = Tile.tile_height * Field.HEIGHT / 2 -
            game_over_screen.height_px / 2;
        main_sprite.addChild(game_over_screen);

        // send the scores if this is a new hi score
        // also update the scoreboard
        if (is_hi_score) {
            Client.score = score;
            Client.response_callback = scoreboard.display;
            // make input fields visible
            scoreboard.request_player_name();
            // html form submission will trigger Client.send_score
        }
    }
}
