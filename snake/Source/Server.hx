#if php
class Server {
    var hi_score_file : String = "hi_scores.txt";

    function new() {}
    function handle_scort(score : Int, name : String) {
        trace('server got $score, $name');
        var exists = sys.FileSystem.exists(hi_score_file);
        var hi_score : Int;
        var hi_scorer_name : String;
        if (exists) {
            var content = sys.io.File.getContent(hi_score_file);
            var score_name = content.split(",");
            hi_score = Std.parseInt(score_name[0]);
            hi_scorer_name = score_name[1];
        } else {
            hi_score = -1;
        }

        if (!exists || score > hi_score) {
            hi_scorer_name = name;
            hi_score = score;

            sys.io.File.write(hi_score_file)
                .writeString(Std.string(hi_score) + hi_scorer_name);
        }
    }
  
    static function main() {
        var ctx = new haxe.remoting.Context();
        ctx.addObject("Server", new Server());
    
        if(haxe.remoting.HttpConnection.handleRequest(ctx)) {
            return;
        }
    
        // handle normal request
        trace("This is a remoting server !");
    } 
}
#end
