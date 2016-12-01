package;
// The screen is filled with tiles
// they can be empty, snake, or apple

import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;

class Tile extends Sprite {
    public static var tile_width : Float;
    public static var tile_height : Float;

    // coords measured in tiles
    public var tx : Int;
    public var ty : Int;

    public function new(_x, _y) {
        super();
        tx = _x;
        ty = _y;
        // measured in pixels
        this.x = _x * tile_width;
        this.y = _y * tile_height;
    }
    public static function compute_tile_size(event : Event) {
        tile_width = Lib.current.stage.stageWidth / Field.WIDTH;
        tile_height = Lib.current.stage.stageHeight / Field.HEIGHT;
    }
}

class EmptyTile extends Tile {
    var COLOR = 0x000000;
    public function new(_x, _y) {
        super(_x, _y);
        draw();
    }

    function draw() {
    }
}

class SnakeTile extends Tile {
    var next_snake_x : Int;
    var next_snake_y : Int;
    var COLOR = 0x0000ff;

    // draws a segment of the snake at the tile position (xpos, ypos)
    public function new(_x, _y) {
        super(_x, _y);
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
    var COLOR = 0xff0000;

    public function new(_x, _y) {
        super(_x, _y);
        draw();
    }

    public function draw() {
        this.graphics.beginFill(COLOR);
        var radius = Math.min(Tile.tile_width / 2, Tile.tile_height / 2);
        this.graphics.drawCircle(0, 0, radius);
        this.graphics.endFill();
    }
}
