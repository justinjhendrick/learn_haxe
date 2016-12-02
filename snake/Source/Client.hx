class Client {
  public static function main(score : Int, name : String) {
    var cnx = haxe.remoting.HttpAsyncConnection.urlConnect("http://localhost/");
    cnx.setErrorHandler( function(err) trace('Error: $err') );
    cnx.Server.handle_score.call([score, name], function(data) trace('Result: $data'));
  }
}
