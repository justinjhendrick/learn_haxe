package;

import openfl.Lib;
import openfl.display.Shape;
import openfl.display.Stage;
import openfl.events.Event;

// The screen is filled with tiles
// they can be empty, snake, or apple
class Tile extends Shape {

    // these values are kept up to date with the stage size
    // use them to calculate play area dimensions
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
        var w = (Lib.current.stage.stageWidth - 2)/ Field.WIDTH;
        var h = (Lib.current.stage.stageHeight - 2) / Field.HEIGHT;

        // keep tiles square
        var min_dim = Math.min(w, h);
        tile_width = Std.int(min_dim);
        tile_height = Std.int(min_dim);
    }
}

class EmptyTile extends Tile {
    public function new(_x, _y) {
        super(_x, _y);
        //draw();
    }

    //function draw() {
    //}
}

class SnakeTile extends Tile {

    // pointer to the next snake segment
    // (towards the head)
    var next_snake_x : Int;
    var next_snake_y : Int;

    var COLOR = 0x0000ff;

    public function new(_x, _y) {
        super(_x, _y);
        draw();
    }

    // draws a segment of the snake at the tile position (xpos, ypos)
    function draw() {
        this.graphics.beginFill(COLOR);
        this.graphics.drawRect(1, 1, Tile.tile_width - 1, Tile.tile_height - 1);
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
        this.graphics.drawCircle(radius + 1, radius + 1, radius - 1);
        this.graphics.endFill();
    }
}
