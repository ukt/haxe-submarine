package;

import app.App;
import lime.app.Application;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.utils.Log;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.media.Sound;
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
import world.entity.NavigationPerson;

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
		trace("Hello World");
		//Application.current.
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		App.instance.initialize();
		App.instance.world.addEntity(new NavigationPerson());
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
		var map:Map<Int, Int> = new Map();
		var array:Array<Int> = new Array();
		for (i in 1...10000000){
			map.set(i, i + 1);
			array.push(i + 1);
		}
		var size = 0;
		var curTime:Float = Date.now().getTime();
		for (i in map){
			size++;
		}
		trace("MapLoop: " + (Date.now().getTime() - curTime));
		curTime = Date.now().getTime();
		for (i in array){
			size++;
		}
		trace("ArrLoop: " + (Date.now().getTime() - curTime));
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
