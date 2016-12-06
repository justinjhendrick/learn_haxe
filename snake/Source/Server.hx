package;

class Server {
    public static var hi_score_file = "hi_scores.txt";
    public static var delim = ", "; // between score and name
    public static var entry_delim = "\n"; // between entries

    public static function parse_hi_scores(txt : String) 
        : Array<Client.ScoreEntry> {
        var result = [];
        for (s in txt.split("\n")) {
            var score_name = s.split(delim);
            var score = Std.parseInt(score_name[0]);
            var scorer_name = score_name[1];
            result.push({score : score, name : scorer_name});
        }
        return result;
    }

    #if php
    function new() { }

    // server side code to handle a score and name coming from the client and
    // maintain hi_scores.txt.
    // TODO: make threadsafe
    // TODO: store more than one hi score
    function handle_score(score : Int, name : String) : String {
        // NOTE: do not use trace() here.
        // It triggers the error handler on the client side
        var exists = sys.FileSystem.exists(hi_score_file);
        var hi_score : Int;
        var hi_scorer_name : String;
        var old_scores : String = null;
        if (exists) {
            old_scores = sys.io.File.getContent(hi_score_file);
            var top = parse_hi_scores(old_scores)[0];
            hi_score = top.score;
            hi_scorer_name = top.name;
        } else {
            hi_score = -1;
        }

        if (!exists || score > hi_score) {
            // no prev hi score file or new hi score
            // create new hi score file
            hi_scorer_name = name;
            hi_score = score;

            var new_hi_scores = Std.string(hi_score) + delim + hi_scorer_name;
            sys.io.File.write(hi_score_file).writeString(new_hi_scores);
            return new_hi_scores;
        } else if (old_scores != null) {
            // no update. send old scores
            return old_scores;
        } else {
            return null;
        }
    }
  
    static function main() {
        var ctx = new haxe.remoting.Context();
        ctx.addObject("Server", new Server());
    
        if(haxe.remoting.HttpConnection.handleRequest(ctx)) {
            return;
        }
    } 
    #end
}
