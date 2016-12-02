package;

import haxe.ds.Vector;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.geom.Rectangle;

// a grid of tiles that makes all tiles children of the main sprite
class TileGrid {

    var width : Int;
    var height : Int;
    var main_sprite : Sprite;

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
}
