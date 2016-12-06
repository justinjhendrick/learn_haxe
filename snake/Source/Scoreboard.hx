package;

import openfl.text.TextField;
import haxe.Timer;

// A class to display (and cache) the hi score list from
// the server.
// Automatically refreshes itself.
class Scoreboard extends TextField {
    var BORDER_PX = 20;
    var cached : Array<Client.ScoreEntry>;

    // new(null) will retrieve from server
    // new(string) will update with string data
    public function new(new_scores : String) {
        super();
        if (new_scores == null) {
            // go get it from server
            Client.get_scores(create_text_box);
        } else {
            // use provided data
            create_text_box(new_scores);
        }

        // create a timer to refresh the scoreboard
        // on a regular basis
        var interval_ms = 60 * 1000;
        var refresh_timer = new Timer(interval_ms);
        refresh_timer.run = function() {
            Client.get_scores(create_text_box);
        }
    }

    function create_text_box(s : String) {
        trace('got scores $s');
        this.x = Tile.tile_width * Field.WIDTH + BORDER_PX;
        this.y = 0;
        this.htmlText = "<h1>High Scores</h1>\n";
        if (s != null) {
            cached = Server.parse_hi_scores(s);
            this.htmlText += "<pre>" + s + "</ pre>";
        }
        this.textColor = 0xffffff;
    }

    // true if current score is highest (as of last download from server).
    public function is_new_hi_score(score : Int) : Bool {
        if (cached == null) {
            return true;
        }
        var top = cached[0].score;
        return score > top;
    }

}
