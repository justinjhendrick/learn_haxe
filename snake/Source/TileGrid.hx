package;

import haxe.ds.Vector;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.geom.Rectangle;

typedef IntPoint = {x : Int, y : Int};

// A grid of tiles that hold the state of the snake and apple
// The path of the snake is held in the Tiles. SnakeTiles have
// pointers to the next snake segment towards the head
class TileGrid extends Sprite {

    private var num_tiles_x : Int;
    private var num_tiles_y : Int;

    var apple_x : Int;
    var apple_y : Int;

    // background image
    var grid_sprite : Sprite;
    var grid : Bitmap;

    var tiles : Vector<Vector<Tile>>;

    public function new(_num_tiles_x, _num_tiles_y) {
        super();

        num_tiles_x = _num_tiles_x;
        num_tiles_y = _num_tiles_y;

        // create grid in a bitmap one time for performance
        grid_sprite = new Sprite();
        create_grid_bitmap(null);
        this.addChild(grid_sprite);

        // fill grid with empty tiles
        tiles = new Vector<Vector<Tile>>(num_tiles_x);
        for (x in 0...num_tiles_x) {
            var column = new Vector<Tile>(num_tiles_y);
            for (y in 0...num_tiles_y) {
                var t = new Tile.EmptyTile(x, y);
                this.addChild(t);
                column[y] = t;
            }
            tiles[x] = column;
        }
    }

    // put tile into the grid. Use tile.tx and tile.ty
    // to place it. Maintain the display list
    public function write(tile : Tile) {
        this.removeChild(tiles[tile.tx][tile.ty]);
        this.addChild(tile);
        tiles[tile.tx][tile.ty] = tile;
    }

    public function read(x, y) : Tile {
        return tiles[x][y];
    }

    public function create_grid_bitmap(e : Event) {
        var w = Tile.tile_width * this.num_tiles_x + 1;
        var h = Tile.tile_height * this.num_tiles_y + 1;
        
        var gridData:BitmapData = new BitmapData(
                Util.round_up(w), Util.round_up(h), false, 0x000000);
        
        var hLine:Rectangle = new Rectangle(0, 0, gridData.width, 1);
        var vLine:Rectangle = new Rectangle(0, 0, 1, gridData.height);
        
        while(vLine.x < gridData.width) {
            gridData.fillRect(vLine, 0x444444);
            vLine.x += Tile.tile_width;
        }
        while(hLine.y < gridData.height) {
            gridData.fillRect(hLine, 0x444444);
            hLine.y += Tile.tile_height;
        }
        
        // remove old grid (in case of resize)
        if (grid != null) {
            grid_sprite.removeChild(grid);
        }

        // add new grid
        grid = new Bitmap(gridData);
        grid_sprite.addChild(grid);
        grid_sprite.x = 0;
        grid_sprite.y = 0;
    }

    // choose a random non-snake position
    function random_coords(s : Snake) : IntPoint {
        // index into the list of all non-snake tiles
        var rand_index = Std.random(num_tiles_x * num_tiles_y - s.length);

        // list all non-snake tiles by iterating
        // through tiles by columns and skipping the snake tiles
        // until rand_index is reached
        var i = 0;
        for (x in 0 ... num_tiles_x) {
            for (y in 0 ... num_tiles_y) {
                if (!Std.is(tiles[x][y], Tile.SnakeTile)) {
                    if (i == rand_index) {
                        return {x : x, y : y};
                    }
                    i += 1;
                } 
            }
        }

        // Snake fills entire screen?
        // game over I guess?
        return {x : 0, y : 0};
    }

    // place the apple on a random tile that does not
    // intersect the snake
    public function place_apple(s : Snake) {
        var p = random_coords(s);
        apple_x = p.x;
        apple_y = p.y;
        var apple = new Tile.AppleTile(p.x, p.y);
        this.write(apple);
    }

    // redraw (but don't move) the apple
    // this is necessary when the stage is resized.
    public function redraw_apple(e : Event) {
        var new_apple = new Tile.AppleTile(apple_x, apple_y);
        this.write(new_apple);
    }
}
