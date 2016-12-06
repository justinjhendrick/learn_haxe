import haxe.remoting.HttpAsyncConnection; 
import haxe.Http;

typedef ScoreEntry = {score : Int, name : String};

// handle the client side of communication with the server
class Client {
    private static var serverUrl =
        "http://www.hendrick.family/justin/games/snake/server/";

    // send score and trigger callback on updated list of hi scores
    public static function send_score(
            score : Int, name : String, callback : String -> Void) {
        var cnx = HttpAsyncConnection.urlConnect(serverUrl + "index.php");
        cnx.setErrorHandler(function(err) trace('Error: $err'));
        cnx.Server.handle_score.call([score, name], callback);
    }

    // call callback with scores from the server
    public static function get_scores(callback : String -> Void) {
        var http = new Http(serverUrl + Server.hi_score_file);
        http.onData = callback;
        http.request();
    }
}
