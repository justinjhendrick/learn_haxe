package;

import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.display.Sprite;
import openfl.events.TextEvent;

class GameOverScreen extends Sprite {
    var title : TextField;

    public var width_px = 120;
    public var height_px = 40;

    // create a new Game Over Screen.
    // The user of this class must choose where the screen is by setting x and y
    public function new(new_hi : Bool, score : Int) {
        super();

        title = new TextField();
        title.x = 0;
        title.y = 0;

        title.textColor = 0xffffff;
        title.selectable = true;
        if (new_hi) {
            title.htmlText = '<h1>$score, New High Score!</h1>';
        } else {
            title.htmlText = "<h1>Game Over</h1>";
        }
        this.addChild(title);
        draw();
    }

    function draw() {
        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, width_px, 30);
        graphics.endFill();
    }
}
