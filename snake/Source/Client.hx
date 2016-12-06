import haxe.remoting.HttpAsyncConnection; 
import haxe.Http;
#if js
import js.html.InputElement;
#end

typedef ScoreEntry = {score : Int, name : String};

// handle the client side of communication with the server
class Client {
    static var serverUrl =
        "http://www.hendrick.family/justin/games/snake/server/";
    public static var score : Int;
    public static var response_callback : String -> Void;

    // send score and trigger callback on updated list of hi scores
    // this function is called by html form submissionf
    @:expose
    public static function send_score() {
        #if js
        var doc = js.Browser.window.document;
        var input_elem = cast(doc.getElementById("name_input"), InputElement);
        var name = input_elem.value;

        var cnx = HttpAsyncConnection.urlConnect(serverUrl + "index.php");
        cnx.setErrorHandler(function(err) trace('Error: $err'));
        cnx.Server.handle_score.call([score, name], response_callback);

        #else trace("hi scores not yet supported on this platform");
        #end
    }

    // call callback with scores from the server
    public static function get_scores(callback : String -> Void) {
        var http = new Http(serverUrl + Server.hi_score_file);
        http.onData = callback;
        http.request();
    }
}
