package;
// The screen is filled with tiles
// they can be empty, snake, or apple

import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

class Tile extends Sprite {
    static var tile_width : Float;
    static var tile_height : Float;

    public function new() {
        super();
    }
    public static function compute_tile_size(event : Event) {
        tile_width = Lib.current.stage.stageWidth / Field.WIDTH;
        tile_height = Lib.current.stage.stageWidth / Field.HEIGHT;
    }
}

class EmptyTile extends Tile {
    public function new() {
        super();
    }
}

class SnakeTile extends Tile {
    var next_snake_x : Int;
    var next_snake_y : Int;
    var COLOR = 0xff00ff;

    // draws a segment of the snake at the tile position (xpos, ypos)
    public function new() {
        super();
        draw();
    }

    function draw() {
        this.graphics.beginFill(COLOR);
        this.graphics.drawRect(0, 0, Tile.tile_width, Tile.tile_height);
        this.graphics.endFill();
    }

    // snake tiles point to the next piece of the snake foward
    // use this function to point this tile to the next one.
    public function set_next_snake(x, y) {
        next_snake_x = x;
        next_snake_y = y;
    }

    public function get_next_snake_x() : Int {
        return next_snake_x;
    }
    public function get_next_snake_y() : Int {
        return next_snake_y;
    }
}

class AppleTile extends Tile {
    var COLOR = 0x00ffff;

    public function new() {
        super();
        draw();
    }

    public function draw() {
        this.graphics.beginFill(COLOR);
        var radius = Math.min(Tile.tile_width / 2, Tile.tile_height / 2);
        this.graphics.drawCircle(0, 0, radius);
        this.graphics.endFill();
    }
}
