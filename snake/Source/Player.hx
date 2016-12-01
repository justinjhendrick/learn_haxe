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
    PAUSE;
}

class Player {
    // add to the back, read from the front
    static var input_queue : List<KeyboardEvent> = new List<KeyboardEvent>();

    // triggered by KEY_DOWN events
    public static function key_down(e : KeyboardEvent) {
        var kc = e.keyCode;
        trace('got $kc');
        input_queue.add(e);
    }

    public static function get_input() : Input {
        var key_event = input_queue.pop();
        if (key_event == null) {
            return NONE;
        }
        switch(key_event.keyCode) {
            case Keyboard.UP | Keyboard.W: return UP;
            case Keyboard.DOWN | Keyboard.S: return DOWN;
            case Keyboard.LEFT | Keyboard.A: return LEFT;
            case Keyboard.RIGHT | Keyboard.D: return RIGHT;
            case Keyboard.SPACE | Keyboard.P: return PAUSE;
            default: return NONE;
        }
        return NONE;
    }
}
