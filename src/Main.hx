package;

import app.App;
import game.entity.HitAreaDrawer;
import lime.app.Application;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.utils.Log;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.media.Sound;
import game.entity.Mine;
import tests.EntityMasksTest;
import tests.WorldTest;
import world.ColliderImpl;
//import js.html.Gamepad;
import lime.ui.GamepadButton;
import metrics.FPSStatistics;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.ui.GameInput;
import openfl.ui.GameInputDevice;
import world.World;
import game.entity.NavigationPerson;

/**
 * ...
 * @author loka
 */
class Main extends Sprite 
{
	public static var fps:FPSStatistics;
	public static var logs:TextField;
	public function new() 
	{
		super();
		runTests();
		trace("Hello World");
		//Application.current.
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		App.instance.initialize();
		App.instance.world.useCollider(new ColliderImpl());
		App.instance.world.addEntity(new NavigationPerson());
		//App.instance.world.addEntity(new Mine(new Point(100, 100)));
		//App.instance.world.addEntity(new Mine(new Point(100, 200)));
		//App.instance.world.addEntity(new Mine(new Point(200, 200)));
		//App.instance.world.addEntity(new Mine(new Point(200, 100)));
		for (i in 1...5){
			for (j in 1...5){
				App.instance.world.addEntity(new Mine(new Point(i * 100, j * 100), 100 * (5-i)));
			}
		}
		App.instance.world.addEntity(new HitAreaDrawer());
		App.instance.world.start();
		fps = new FPSStatistics(10,10,0xffffff);
		Lib.current.stage.addChild(fps);
		logs = new TextField();
		logs.textColor = 0xffffff;
		logs.text = "Hello, World 1";
		logs.width = stage.stageWidth;
		logs.height = stage.stageHeight;
		Lib.current.stage.addChild(logs);
		Log.info("Hello World");
	}
	
	function runTests() 
	{
		var r = new haxe.unit.TestRunner();
		r.add(new WorldTest());
		r.add(new EntityMasksTest());
		// add other TestCases here

		// finally, run the tests
		r.run();
	}
		/*new GameInput ().addEventListener (GameInputDevice.DEVICE_ADDED, function (event) {

  trace ("Connected Device: " + event.device.name);

  for (i in 0...event.device.numControls) {

    var control = event.device.getControlAt (i);

    control.addEventListener (Event.CHANGE, function (event) {
      trace ("Control " + control.id + ": " + control.value);
    });

  }

  event.device.enabled = true;

});
	}
*/
}
