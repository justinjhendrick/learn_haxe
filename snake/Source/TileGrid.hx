package;

import openfl.display.Sprite;
import haxe.ds.Vector;

// a grid of tiles that makes all tiles children of the main sprite
class TileGrid {

    var width : Int;
    var height : Int;
    var main_sprite : Sprite;

    var tiles : Vector<Vector<Tile>>;

    public function new(_width, _height, _main_sprite : Sprite) {
        width = _width;
        height = _height;
        main_sprite = _main_sprite;

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
}
