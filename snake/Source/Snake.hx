package;

class Snake {
    // measured in tiles
    var length : Int;

    var dir : Direction;
    var delta_x : Int;
    var delta_y : Int;

    // position of the snake's head measured in tiles
    // 0, 0 is top left
    var head_x : Int;
    var head_y : Int;

    var tail_x : Int;
    var tail_y : Int;

    // create a new snake and fill in the tiles it occupies with SnakeTiles
    public function new(_length, _dir, _head_x, _head_y, tiles : TileGrid) {
        length = _length;
        head_x = _head_x;
        head_y = _head_y;
        dir = _dir;

        set_dir(dir);

        tail_x = head_x - (length - 1) * delta_x;
        tail_y = head_y - (length - 1) * delta_y;

        // iterate from the head to the tail
        // filling in the tiles
        for (i in 0 ... length) {
            var x = head_x - i * delta_x;
            var y = head_y - i * delta_y;
            var st = new Tile.SnakeTile(x, y);

            // set the next snake pointer (except for the head)
            if (i != 0) {
                st.set_next_snake(x + delta_x, y + delta_y);
            }

            tiles.write(st);
        }
    }

    static function opposites(d1, d2) : Bool {
        return d1 == UP    && d2 == DOWN  ||
               d1 == DOWN  && d2 == UP    ||
               d1 == LEFT  && d2 == RIGHT ||
               d1 == RIGHT && d2 == LEFT;
    }

    public function set_dir(new_dir : Direction) {
        if (!opposites(dir, new_dir)) {
            dir = new_dir;
            switch(dir) {
                case UP:    delta_x = 0;  delta_y = -1;
                case DOWN:  delta_x = 0;  delta_y = 1;
                case LEFT:  delta_x = -1; delta_y = 0;
                case RIGHT: delta_x = 1;  delta_y = 0;
            }
        }
    }

    // move one step in direction 'dir'
    public function move(tiles : TileGrid)
        : Field.GameResult {
        var new_head_y = Util.Modulo(head_y + delta_y, Field.WIDTH);
        var new_head_x = Util.Modulo(head_x + delta_x, Field.HEIGHT);

        var next_tile = tiles.read(new_head_x, new_head_y);
        if (Std.is(next_tile, Tile.EmptyTile)) {
            // move the snake's head forward
            tiles.write(new Tile.SnakeTile(new_head_x, new_head_y));
            // don't forget to maintain snake pointers in the tiles
            cast(tiles.read(head_x, head_y), Tile.SnakeTile)
                .set_next_snake(new_head_x, new_head_y);

            // move the snake's tail forward
            var old_tail = cast(tiles.read(tail_x, tail_y), Tile.SnakeTile);
            tiles.write(new Tile.EmptyTile(tail_x, tail_y));
            tail_x = old_tail.get_next_snake_x();
            tail_y = old_tail.get_next_snake_y();
        } else if (Std.is(next_tile, Tile.SnakeTile)) {
            // the snake has run into itself
            return Field.GameResult.GAME_OVER;
        } else if (Std.is(next_tile, Tile.AppleTile)) {
            // the snake has found an apple
            // grow the snake forward
            // place a new apple
            //   (don't forget to make sure the apple isn't in the snake)
            // TODO
        } else {
            throw "error: unknown tile type";
        }
        head_x = new_head_x;
        head_y = new_head_y;
        return Field.GameResult.CONTINUE;
    }
}

enum Direction {
    UP;
    DOWN;
    LEFT;
    RIGHT;
}
