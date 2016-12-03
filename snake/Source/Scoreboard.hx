package;

import openfl.text.TextField;

class Scoreboard extends TextField {
    var BORDER_PX = 20;

    public function new() {
        super();
        Client.get_scores_raw(function(s : String) {
            trace('got scores $s');
            this.x = Tile.tile_width * Field.WIDTH + BORDER_PX;
            this.y = 0;
            this.htmlText = "<h1>High Scores</h1>\n";
            if (s != null) {
                this.htmlText += "<pre>" + s + "</ pre>";
            }
            this.textColor = 0xffffff;
        });
    }
}
