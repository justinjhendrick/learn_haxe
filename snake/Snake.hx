class Snake {
    // measured in tiles
    var length : Int;

    var dir : Direction;

    // position of the snake's head measured in tiles
    // 0, 0 is top left
    var head_x : Int;
    var head_y : Int;
    var tail_x : Int;
    var tail_y : Int;

    public function new(_length, _dir, _head_x, _head_y) {
        length = _length;
        dir = _dir;
        head_x = _head_x;
        head_y = _head_y;
    }

    // move one step in direction 'dir'
    public function move(tiles : Array<Array<Tile>>)
        : Field.GameResult {
        var new_head_y = head_y;
        var new_head_x = head_x;
        switch(dir) {
            case UP: new_head_y = head_y - 1;
            case DOWN: new_head_y = head_y + 1;
            case LEFT: new_head_x = head_x - 1;
            case RIGHT: new_head_x = head_x + 1;
        }

        var next_tile = tiles[new_head_x][new_head_y];
        if (Std.is(next_tile, Tile.EmptyTile)) {
            // move the snake's head forward
            tiles[new_head_x][new_head_y] = new Tile.SnakeTile();
            // don't forget to maintain snake pointers in the tiles
            cast(tiles[head_x][head_y], Tile.SnakeTile)
                .set_next_snake(new_head_x, new_head_y);

            // move the snake's tail forward
            tiles[tail_x][tail_y] = new Tile.EmptyTile();
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
