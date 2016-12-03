import haxe.remoting.HttpAsyncConnection;

class Client {
  public static function main(score : Int, name : String) {
    var cnx = HttpAsyncConnection
        .urlConnect("http://www.hendrick.family/justin/games/snake/server/index.php");
    cnx.setErrorHandler( function(err) trace('Error: $err') );
    cnx.Server.handle_score.call([score, name], function(data) trace('Result: $data'));
  }
}
