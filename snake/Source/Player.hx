package;

import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.ui.Keyboard;

enum Input {
    NONE;
    UP;
    DOWN;
    LEFT;
    RIGHT;
}

class Player {
    // add to the back, read from the front
    static var input_queue : List<KeyboardEvent> = new List<KeyboardEvent>();

    // triggered by KEY_DOWN events
    public static function key_down(e : KeyboardEvent) {
        input_queue.add(e);
    }

    public static function get_input() : Input {
        var key_event = input_queue.pop();
        if (key_event == null) {
            return NONE;
        }
        switch(key_event.keyCode) {
            case Keyboard.UP: return UP;
            case Keyboard.DOWN: return DOWN;
            case Keyboard.LEFT: return LEFT;
            case Keyboard.RIGHT: return RIGHT;
            default: return NONE;
        }
        return NONE;
    }
}
