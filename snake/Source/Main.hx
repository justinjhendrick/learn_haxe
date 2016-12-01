package;

import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;

class Main extends Sprite {
    var field : Field;
	
	public function new () {
		super();
        field = new Field(this);
        
        addEventListener(Event.ENTER_FRAME, every_frame);
        addEventListener(KeyboardEvent.KEY_DOWN, Player.key_down);

        Tile.compute_tile_size(null);
        Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;
        addEventListener(Event.RESIZE, Tile.compute_tile_size);
	}

    function every_frame(event : Event) {
        field.every_frame();
    }
}
