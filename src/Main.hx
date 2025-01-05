import h2d.Scene;
import h2d.Text;
import hxd.App;
import hscript.Parser;
import hscript.Interp;

class Main extends App {
    var scene:Scene;
    var interpreter:Interp;
    var parser:Parser;
    
    override function init() {
        scene = s2d;
        
        // Initialize HScript
        parser = new Parser();
        interpreter = new Interp();
        
        // Expose Heaps functionality to HScript
        interpreter.variables.set("Scene", Scene);
        interpreter.variables.set("Text", Text);
        interpreter.variables.set("scene", scene);
        
        // Load and execute user script
        loadUserScript();
    }
    
    function loadUserScript() {
        // Load index.hx content using haxe.Http
        var request = new haxe.Http("index.hx");
        request.onData = function(data:String) {
            try {
                var program = parser.parseString(data);
                interpreter.execute(program);
            } catch(e:Dynamic) {
                var errorText = new h2d.Text(getFont(), scene);
                errorText.text = 'Error executing script: $e';
                errorText.textColor = 0xFF0000;
            }
        };
        request.onError = function(error) {
            var errorText = new h2d.Text(getFont(), scene);
            errorText.text = 'Error loading script: $error';
            errorText.textColor = 0xFF0000;
        };
        request.request();
    }

    function getFont() {
        return hxd.res.DefaultFont.get();
    }

    static function main() {
        new Main();
    }
}