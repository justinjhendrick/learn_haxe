package;

import openfl.text.TextField;
import haxe.Timer;

// A class to display (and cache) the hi score list from
// the server.
// Automatically refreshes itself.
class Scoreboard {
    var BORDER_PX = 20;
    var cached : Array<Client.ScoreEntry>;

    // new(null) will retrieve from server
    // new(string) will update with string data
    public function new(new_scores : String) {
        if (new_scores == null) {
            // go get it from server
            Client.get_scores(display);
        } else {
            // use provided data
            display(new_scores);
        }

        // create a timer to refresh the scoreboard
        // on a regular basis
        var interval_ms = 60 * 1000;
        var refresh_timer = new Timer(interval_ms);
        refresh_timer.run = function() {
            Client.get_scores(display);
        }
    }

    public function display(s : String) {
        trace('got scores $s');

        #if html5
        var doc = js.Browser.window.document;
        var hi_scores : js.html.Element  = doc.getElementById("hi_scores");
        if (s != null) {
            hi_scores.innerText = s;
        }
        #else trace("hi scores not yet supported on this platform"
        #end
    }

    // true if current score is highest (as of last download from server).
    public function is_new_hi_score(score : Int) : Bool {
        if (cached == null) {
            return true;
        }
        var top = cached[0].score;
        return score > top;
    }

    public function request_player_name() {
        #if html5
        // make form visible
        var doc = js.Browser.window.document;
        var input_form = doc.getElementById("name_form");
        input_form.removeAttribute("hidden");

        // set form action to send_score
        input_form.setAttribute("action", "javascript:Client.send_score()");
        #end
    }

}
