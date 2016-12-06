package;

import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.display.Sprite;
import openfl.events.TextEvent;

class GameOverScreen extends Sprite {
    var title : TextField;
    var input : TextField;

    public var width_px = 100;
    public var height_px = 50;

    // this function will be called when the
    // user presses enter in the text box
    var input_callback : String -> Void;

    // create a new Game Over Screen.
    // The user of this class must choose where the screen is by setting x and y
    // if new_hi is false, input_callback should be null
    public function new(new_hi : Bool) {
        super();
        this.addEventListener(TextEvent.TEXT_INPUT, wait_for_enter);

        title = new TextField();
        title.x = 0;
        title.y = 0;

        title.textColor = 0xffffff;
        title.selectable = true;
        if (new_hi) {
            title.htmlText = "<h1>New High Score!</h1>";

            input = new TextField();
            input.type = TextFieldType.INPUT;
            //input.selectable = true;
            //input.multiline = false;

            input.border = true;
            input.borderColor = 0xff0000;

            input.x = 0;
            input.y = 30;
            input.height = this.height_px - input.y;
            input.width = this.width_px;

            input.background = true;
            input.backgroundColor = 0xffffff;
            input.textColor = 0x000000;
            input.text = "enter your name";

            this.addChild(input);
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

    // wait for the enter key, then trigger callback with entered text
    function wait_for_enter(e : TextEvent) {
        // get last character
        if (e != null && e.type == TextEvent.TEXT_INPUT &&
                e.text != null && e.text != "") {
            trace(e.text);
            // if it's return, call the callback
            var c = e.text.charAt(e.text.length - 1);
            if (c == "\r" || c == "\n") {
                input_callback(e.text.substring(0, e.text.length - 1));
            }
        }
    }

    public function set_callback(_input_callback : String -> Void) {
        input_callback = _input_callback;
    }
}
