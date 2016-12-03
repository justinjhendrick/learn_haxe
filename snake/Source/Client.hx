import haxe.remoting.HttpAsyncConnection; 
import haxe.Http;

typedef ScoreEntry = {score : Int, name : String};

class Client {
    private static var serverUrl =
        "http://www.hendrick.family/justin/games/snake/server/";

    public static function send_score(
            score : Int, name : String, callback : String -> Void) {
        var cnx = HttpAsyncConnection
            .urlConnect(serverUrl + "index.php");
        cnx.setErrorHandler( function(err) trace('Error: $err') );
        cnx.Server.handle_score .call([score, name], callback);
    }

    public static function get_scores_raw(callback : String -> Void) {
        var http = new Http(serverUrl + Server.hi_score_file);
        http.onData = callback;
        http.request();
    }
}
