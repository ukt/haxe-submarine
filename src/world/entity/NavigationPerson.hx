package world.entity;

import gamepad.GamePadEvent;
import gamepad.JoystickWrapper;
import haxe.Constraints.Function;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.GameInputEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.ui.GameInput;
import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;
import world.World;

/**
 * ...
 * @author loka
 */
class NavigationPerson implements Entity 
{
	public var _deployTorpeds:Bool = false;
	public var deployTorpeds(get, set):Bool;
	function set_deployTorpeds(val:Bool):Bool{
		_deployTorpeds = val;
		return val;
	};
	function get_deployTorpeds():Bool{
		return _deployTorpeds;
	};
	var uia:Bitmap;
	private var _floatP:Float = 0.0079;
	private var _bulletTimeOffset:Float = 100;
	private var _currentBulletTimeOffset:Float = 0;
	var device:GameInputDevice;
	var myDevice:GameInputDevice;
	var gameInput:GameInput;
	var originalSpeed = 100;
	var speed = 100;
	var axis:Point = new Point(0.001,0.001);
	var world:World;
	var isXChanges:Bool = false;
	var position:Point = new Point(200, 100);
	var vectorOfMoving:Point = new Point(0.001,0.001);

	//var actions:Array<Function> = new Array();
	public function new() 
	{
		
		gameInput = new GameInput();
		gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
		gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, controllerRemoved);
		gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE, controllerProblem);
		var touch:Point = new Point(0, 0);
		var context:NavigationPerson = this;

		Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, function(e:TouchEvent):Void{
			context.deployTorpeds = true;
			var scrollX = e.localX < touch.x ? touch.x : (Lib.current.stage.stageWidth - touch.x);
			var scrollY = e.localY < touch.y ? touch.y : (Lib.current.stage.stageHeight - touch.y);
			var scrollXPos = e.localX < touch.x ? e.localX / scrollX : (e.localX - touch.x) / scrollX;
			var scrollYPos = e.localY < touch.y ? e.localY / scrollY : (e.localY - touch.y) / scrollY;
			var valueX = scrollXPos*(e.localX < touch.x ?-1:1);
			var valueY = scrollYPos*(e.localY < touch.y ?-1:1);
	
			isXChanges = (context.axis.x > 0 && valueX < 0) || (context.axis.x < 0 && valueX > 0);

			context.axis.x = valueX;
			context.axis.y = valueY;
			Main.fps.values.set("e.localX", e.localX);
			Main.fps.values.set("e.localY", e.localY);
			Main.fps.values.set("context.axis.x", context.axis.x);
			Main.fps.values.set("context.axis.y", context.axis.y);
			context.vectorOfMoving = context.axis.clone();
			context.vectorOfMoving.normalize(1);
			
		});
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, function(e:TouchEvent):Void{
			context.deployTorpeds = true;
			touch.x = e.localX;
			touch.y = e.localY;
			Main.fps.values.set("touch.x", touch.x);
			Main.fps.values.set("touch.y", touch.y);
		});
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, function(e:TouchEvent):Void{
			context.deployTorpeds = false;
		});
		
		Joystick.onConnect.add (function (joystick) {

		  Main.fps.values.set("Joystick", "Connected Joystick: " + joystick.name);

		  joystick.onAxisMove.add (function (axis:Int, value:Float) {
			Main.fps.values.set("Joystick", "Moved Axis " + axis + ": " + value);
			Main.fps.values.set("Joystick", axis + "::" + value);
			if (Math.abs(value) < 0.0079){
				value = 0.0000000000001 * (context.axis.x > 0 ? 1 : -1);
			}
			switch(axis){
				case 0/*, "LEFT_X"*/:
					isXChanges = (context.axis.x > 0 && value < 0) || (context.axis.x < 0 && value > 0);
					context.axis.x = value;
				case 1/*"LEFT_Y"*/:
					context.axis.y = value;
				}
				context.vectorOfMoving = context.axis.clone();
				context.vectorOfMoving.normalize(1);
		  });

		  joystick.onButtonDown.add (function (button:Int) {
			Main.fps.values.set("Joystick", "Pressed Button: " + button);
			switch(button) {
				case 1/*"B"*/:
					context.speed = context.originalSpeed*2;
				case 0/*"A"*/:
					context.deployTorpeds = true;
			}
		  });

		  joystick.onButtonUp.add (function (button:Int) {
			Main.fps.values.set("Joystick", "Released Button: " + button);
			switch(button){
				case 1/*"B"*/:
					context.speed = context.originalSpeed;
				case 0/*"A"*/:
					context.deployTorpeds = false;
			}
		  });

		  joystick.onDisconnect.add (function () {
			Main.fps.values.set("Joystick", "Disconnected Joystick");
		  });

		  joystick.onHatMove.add (function (hat:Int, position:JoystickHatPosition) {
			Main.fps.values.set("Joystick", "Moved Hat " + hat + ": " + position);
		  });

		  joystick.onTrackballMove.add (function (trackball:Int, value:Float, value2:Float) {
			Main.fps.values.set("Joystick", "Moved Trackball " + trackball + ": " + value);
		  });

		});
	}
	
	private function controllerRemoved(e:GameInputEvent):Void {
		trace("controllerRemoved");
	}
	private function controllerProblem(e:GameInputEvent):Void {
		trace("controllerProblem");
	}
	private function controllerAdded(e:GameInputEvent):Void 
	{
		//put code here to handle when a device is added
		trace(GameInput.numDevices);//tells you how many gamepads are plugged in
		myDevice = GameInput.getDeviceAt(0);
		trace(myDevice.numControls);//tells you how many gamepads are plugged in
		myDevice.enabled = true;
	}
	
	/* INTERFACE world.entity.Entity */
	public function draw():Void 
	{
		uia.x = position.x + (axis.x < 0?0:uia.width);
		uia.y = position.y;
		if(isXChanges){
			if (axis.x < 0){
				uia.scaleX = 1;
			} else {
				uia.scaleX = -1;
				//uia.x = uia.x + uia.width;
			}
			isXChanges = false;
		}
	}
	
	
	public function update(dt:Float):Void {
		var distance = (speed * (dt / 1000)) * axis.length;
		position = GameMath.movePointByVector(position, vectorOfMoving, distance);
		controlBulletsDeploy(dt);
	}
	
	public function initialize(world:World):Void {
		this.world = world;
		gameInput = new GameInput();
		gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
		vectorOfMoving.normalize(1);
		
		uia = new Bitmap();
		var bitmapData = openfl.Assets.getBitmapData("img/submarine.png");
		uia.bitmapData = bitmapData;
		uia.cacheAsBitmap = true;
		Lib.current.stage.addChild(uia);
	}
	
	public function dispose():Void {
		
	}
	
	function getActiveControls():Array<GameInputControl> {
		var result:Array<GameInputControl> = new Array();
		var floatP:Float = 0.0079;

		for (i in 0 ... myDevice.numControls){
				var control:GameInputControl = myDevice.getControlAt(i);
				if (control.value >= floatP || control.value <= -floatP) 	{
					result.push(control);
				}
		}
		return result;
	}
	
	function controlBulletsDeploy(dt:Float):Void {
		_currentBulletTimeOffset -= dt;
		if (_currentBulletTimeOffset < 0 && deployTorpeds){
			var startPos = new Point(
				position.x + (axis.x<0?0+25:uia.width-25), 
				position.y + uia.height * .75
			);
			var bulletVector = vectorOfMoving.clone();
			if (axis.length < .1){
				bulletVector = new Point(axis.x>0?1:-1, 0);
			}
			world.addEntity(new Bullet(startPos, bulletVector, 100));
			_currentBulletTimeOffset = _bulletTimeOffset;
		}
	}
	
}