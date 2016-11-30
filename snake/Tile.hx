// The screen is filled with tiles
// they can be empty, snake, or apple

class Tile {
}

class EmptyTile extends Tile {
    public function new() {
    }
    public function draw() {
    }
}

class SnakeTile extends Tile {
    var next_snake_x : Int;
    var next_snake_y : Int;

    public function new() {
    }
    public function draw() {
    }
    public function set_next_snake(x, y) {
        next_snake_x = x;
        next_snake_y = y;
    }
}

class AppleTile extends Tile {
    public function new() {
    }
    public function draw() {
    }
}
