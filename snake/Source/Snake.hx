package;

class Snake {
    // measured in tiles
    var length : Int;
    var delta_x : Int;
    var delta_y : Int;

    // position of the snake's head measured in tiles
    // 0, 0 is top left
    var head_x : Int;
    var head_y : Int;

    var tail_x : Int;
    var tail_y : Int;

    // create a new snake and fill in the tiles it occupies with SnakeTiles
    public function new(_length, dir, _head_x, _head_y,
                        tiles : Array<Array<Tile>>) {
        length = _length;
        head_x = _head_x;
        head_y = _head_y;

        switch(dir) {
            case UP:    delta_x = 0;  delta_y = -1;
            case DOWN:  delta_x = 0;  delta_y = 1;
            case LEFT:  delta_x = -1; delta_y = 0;
            case RIGHT: delta_x = 1;  delta_y = 0;
        }
        tail_x = head_x - (length - 1) * delta_x;
        tail_y = head_y - (length - 1) * delta_y;

        // iterate from the head to the tail
        // filling in the tiles
        for (i in 0 ... length) {
            var x = head_x - i * delta_x;
            var y = head_y - i * delta_y;
            var st = new Tile.SnakeTile();

            // set the next snake pointer (except for the head)
            if (i != 0) {
                st.set_next_snake(x + delta_x, y + delta_y);
            }

            tiles[x][y] = st;
        }
    }

    // move one step in direction 'dir'
    public function move(tiles : Array<Array<Tile>>)
        : Field.GameResult {
        var new_head_y = head_y + delta_y;
        var new_head_x = head_x + delta_x;

        var next_tile = tiles[new_head_x][new_head_y];
        if (Std.is(next_tile, Tile.EmptyTile)) {
            // move the snake's head forward
            tiles[new_head_x][new_head_y] = new Tile.SnakeTile();
            // don't forget to maintain snake pointers in the tiles
            cast(tiles[head_x][head_y], Tile.SnakeTile)
                .set_next_snake(new_head_x, new_head_y);

            // move the snake's tail forward
            var old_tail = cast(tiles[tail_x][tail_y], Tile.SnakeTile);
            tiles[tail_x][tail_y] = new Tile.EmptyTile();
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
