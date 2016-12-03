package;

class Server {
    public static var hi_score_file = "hi_scores.txt";
    public static var delim = ", ";

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
    function handle_score(score : Int, name : String) {
        trace('server got $score, $name');
        var exists = sys.FileSystem.exists(hi_score_file);
        var hi_score : Int;
        var hi_scorer_name : String;
        if (exists) {
            var content = sys.io.File.getContent(hi_score_file);
            var top = parse_hi_scores(content)[0];
            hi_score = top.score;
            hi_scorer_name = top.name;
        } else {
            hi_score = -1;
        }

        if (!exists || score > hi_score) {
            hi_scorer_name = name;
            hi_score = score;

            sys.io.File.write(hi_score_file)
                .writeString(Std.string(hi_score) + delim + hi_scorer_name);
        }
    }
  
    static function main() {
        var ctx = new haxe.remoting.Context();
        ctx.addObject("Server", new Server());
    
        if(haxe.remoting.HttpConnection.handleRequest(ctx)) {
            trace('handleRequest returned true');
            return;
        }
    
        // handle normal request
        trace("This is a remoting server !");
    } 
    #end
}
