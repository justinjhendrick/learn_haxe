package;

import haxe.ds.Vector;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.geom.Rectangle;

typedef IntPoint = {x : Int, y : Int};

// a grid of tiles that makes all tiles children of the main sprite
class TileGrid {

    var width : Int;
    var height : Int;
    var main_sprite : Sprite;

    var apple_x : Int;
    var apple_y : Int;

    var grid_sprite : Sprite;
    var grid : Bitmap;

    var tiles : Vector<Vector<Tile>>;

    public function new(_width, _height, _main_sprite : Sprite) {
        width = _width;
        height = _height;
        main_sprite = _main_sprite;

        // create grid in a bitmap one time for performance
        grid_sprite = new Sprite();
        create_grid_bitmap(null);
        main_sprite.stage.addEventListener(Event.RESIZE, create_grid_bitmap);
        main_sprite.stage.addEventListener(Event.RESIZE, redraw_apple);
        main_sprite.addChild(grid_sprite);

        // fill grid with empty tiles
        tiles = new Vector<Vector<Tile>>(width);
        for (x in 0...width) {
            var column = new Vector<Tile>(height);
            for (y in 0...height) {
                var t = new Tile.EmptyTile(x, y);
                main_sprite.addChild(t);
                column[y] = t;
            }
            tiles[x] = column;
        }
    }

    public function write(tile : Tile) {
        main_sprite.removeChild(tiles[tile.tx][tile.ty]);
        main_sprite.addChild(tile);
        tiles[tile.tx][tile.ty] = tile;
    }

    public function read(x, y) : Tile {
        return tiles[x][y];
    }

    public function create_grid_bitmap(e : Event) {
        var w = Tile.tile_width * this.width + 1;
        var h = Tile.tile_height * this.height + 1;
        
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
        
        // remove old grid
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
        var rand_index = Std.random(width * height - s.length);
        var i = 0;
        for (x in 0 ... width) {
            for (y in 0 ... height) {
                if (!Std.is(tiles[x][y], Tile.SnakeTile)) {
                    if (i == rand_index) {
                        return {x : x, y : y};
                    }
                    i += 1;
                } 
            }
        }
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

    public function redraw_apple(e : Event) {
        var new_apple = new Tile.AppleTile(apple_x, apple_y);
        this.write(new_apple);
    }
}
