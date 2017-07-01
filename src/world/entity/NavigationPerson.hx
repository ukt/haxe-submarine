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
		if (deployTorpeds){
			//_currentBulletTimeOffset = _bulletTimeOffset;
		}
		return val;
	};
	function get_deployTorpeds():Bool{
		return _deployTorpeds;
	};
	//var uia:BitmapData;
	var uia:Bitmap;
	private var _x:Float = 200;
	private var _y:Float = 100;
	private var _floatP:Float = 0.0079;
	private var _bulletTimeOffset:Float = 500;
	private var _currentBulletTimeOffset:Float = 0;
	var device:GameInputDevice;
	var myDevice:GameInputDevice;
	var gameInput:GameInput;
	var originalSpeed = 100;
	var speed = 100;
	var vectorOfMoving:Point = new Point(0.001,0.001);
	var axis:Point = new Point(0.001,0.001);
	var world:World;
	var isXChanges:Bool = false;
	//var actions:Array<Function> = new Array();
	public function new() 
	{
		uia = new Bitmap();
		var bitmapData = openfl.Assets.getBitmapData("img/submarine.png");
		var bitmap:Bitmap = new Bitmap();
		uia.bitmapData = bitmapData;
		uia.cacheAsBitmap = true;
		Lib.current.stage.addChild(uia);
		//new GameInputDevice();
		
		gameInput = new GameInput();
		gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
		//trace(GameInput.numDevices);//tells you how many gamepads are plugged in
		//myDevice = GameInput.getDeviceAt(0);
		//trace(myDevice.numControls);//tells you how many gamepads are plugged in
		//myDevice.enabled = true;
		//gameInput.
		gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, controllerRemoved);
		gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE, controllerProblem);
		var context:NavigationPerson = this;
		var joystick = new JoystickWrapper();
		joystick.addListener(GamePadEvent.H_THUMB_STICK_1, function(value:Float, status:Bool) {
			
		});
		//trace("Joystick.devices: " + Lambda.count(Joystick.devices));
		Joystick.onConnect.add (function (joystick) {

		  Main.fps.values.set("Joystick", "Connected Joystick: " + joystick.name);

		  joystick.onAxisMove.add (function (axis:Int, value:Float) {
			Main.fps.values.set("Joystick", "Moved Axis " + axis + ": " + value);
			Main.fps.values.set("Joystick", axis + "::" + value);
			if (Math.abs(value) < 0.0079){
				value = 0.0000000000001*(context.axis.x>0?1:-1);
			}
			switch(axis){
				case 0/*, "LEFT_X"*/:
					context.axis.x = value;
					context.vectorOfMoving = context.axis.clone();
				case 1/*"LEFT_Y"*/:
					context.axis.y = value;
					context.vectorOfMoving = context.axis.clone();
				}
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
		/*Gamepad.onConnect.add (function (gamepad) {

			trace ("Connected Gamepad: " + gamepad.name);
			Main.logs.text = ("Connected Gamepad: " + gamepad.name);
			
			gamepad.onAxisMove.add (function (axis:GamepadAxis, value:Float) {
				trace ("Moved Axis " + axis + ": " + value);
				Main.logs.text = (axis + "::" + value);
				var newOfsset = value * context.ofsset;
				switch(axis.toString()){
					case "LEFT_X":
						trace("move left: " + (newOfsset));
						context._xOfssset += newOfsset;
						if(Math.abs(context._xOfssset+newOfsset)<ofsset){
							context._xOfssset += newOfsset;
						} else if(newOfsset>0){
							context._xOfssset = ofsset;
						} else {
							context._xOfssset = -ofsset;
						}
						if (newOfsset > 0){
							context.isXChanges = context._xOfssset > 0 && context._xOfssset - newOfsset < 0;	
						} else {
							context.isXChanges = context._xOfssset < 0 && context._xOfssset - newOfsset > 0;
						}
						if (Math.abs(value) < 0.1){
							context._xfloatP= .95;
						} else {
							context._xfloatP = 1;
						}
					case "LEFT_Y":
						if(Math.abs(context._yOfssset+newOfsset)<ofsset){
							context._yOfssset += newOfsset;
						} else if(newOfsset>0){
							context._yOfssset = ofsset;
						} else {
							context._yOfssset = -ofsset;
						}
						if (Math.abs(value) < 0.1){
							context._yfloatP = .95;
						} else {
							context._yfloatP = 1;
						}
				}
			});

			gamepad.onButtonDown.add (function (button:GamepadButton) {
				trace ("Pressed Button: " + button);
				Main.logs.text = ("Pressed Button: " + button);
				switch(button.toString()){
					case "DPAD_UP":
						context._yOfssset -= ofsset;
					case "DPAD_DOWN":
						context._yOfssset += ofsset;
					case "DPAD_LEFT":
						context._xOfssset -= context.ofsset;
						isXChanges = _xOfssset < 0 && _xOfssset + context.ofsset> 0;
					case "DPAD_RIGHT":
						context._xOfssset += context.ofsset;
						context.isXChanges = context._xOfssset > 0 && context._xOfssset - context.ofsset < 0;
					case "B":
						context.ofsset = 4;
					case "A":
						if (context._currentBulletTimeOffset < 0){
							context._currentBulletTimeOffset = context._bulletTimeOffset;
							trace("g:uia.height:: " + uia.height);
							var startPos = new Point(_x, _y + uia.height);
							var endPosition = new Point(_x, _y);
							context.world.addEntity(new Bullet(startPos, endPosition, 120 + Math.random()*10));
						}
				}
			});

			gamepad.onButtonUp.add (function (button:GamepadButton) {
				trace ("Released Button: " + button);
				Main.logs.text = ("Released Button: " + button);
				switch(button.toString()){
					case "B":
						context.ofsset = 2;
				}
			});

			gamepad.onDisconnect.add (function () {
				trace ("Disconnected Gamepad");
			});

		});*/
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
		/*while (actions.length > 0){
			actions.pop()();
		}*/
		/*var isXChanges:Bool = false;

		if (myDevice != null) {
			ofsset = 2;
			var activeControls:Array<GameInputControl> = getActiveControls();
			for (control in activeControls){
				switch(control.id){
						case GamePadKeys.B:
							ofsset = 4;
						case GamePadKeys.A:
							if (_currentBulletTimeOffset < 0){
								_currentBulletTimeOffset = _bulletTimeOffset;
								world.addEntity(new Bullet(new Point(_x, _y), new Point(_x, _y), 120 + Math.random()*10));
							}
				}
			}
			for (control in activeControls){
				var newOfsset = control.value * ofsset;

				trace(control.id + "::" + control.value);
				//Main.logs.appendText(control.id + "::" + control.value);
				Main.logs.text = (control.id + "::" + control.value);
				
				switch(control.id){
					case GamePadKeys.TOP:
						_yOfssset -= ofsset;
					case GamePadKeys.BOTTOM:
						_yOfssset += ofsset;
					case GamePadKeys.LEFT:
						_xOfssset -= newOfsset;
						isXChanges = _xOfssset < 0 && _xOfssset + newOfsset > 0;
					case GamePadKeys.RIGHT:
						_xOfssset += newOfsset;
						isXChanges = _xOfssset > 0 && _xOfssset - newOfsset < 0;
					case GamePadKeys.V_THUMB_STICK_1:
						#if flash
						_yOfssset -= newOfsset;
						#else
						_yOfssset += newOfsset;
						#end
					case GamePadKeys.H_THUMB_STICK_1:
						trace("move left: " + (newOfsset));
						_xOfssset += newOfsset;
						if (newOfsset > 0){
							isXChanges = _xOfssset > 0 && _xOfssset - newOfsset < 0;	
						} else {
							isXChanges = _xOfssset < 0 && _xOfssset - newOfsset > 0;
						}
				}
			}
		}*/
		/*if (isXChanges){
			isXChanges = false;
			if (_xOfssset < 0){
				uia.scaleX = 1;
				_x -= uia.width;
			} else {
				uia.scaleX = -1;
				_x += uia.width;
			}
		}
		//_y += _yOfssset*=.8;
		_y += _yOfssset *=_yfloatP;
		//_x += _xOfssset *= .8;
		_x += _xOfssset *=_xfloatP;*/
		uia.x = _x;
		uia.y = _y;
		if (vectorOfMoving.x < 0){
			uia.x = _x - uia.width;
			uia.scaleX = 1;
		} else {
			uia.scaleX = -1;
		}
	}
	
	
	public function update(dt:Float):Void {
		var distance = (speed * (dt / 1000)) * axis.length;
		var currentPosition = new Point(_x, _y);
		var point = GameMath.movePointByVector(currentPosition, vectorOfMoving, distance);
		controlBulletsDeploy(dt);
		_x = point.x;
		_y = point.y;
	}
	
	public function initialize(world:World):Void {
		this.world = world;
		gameInput = new GameInput();
		gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
		vectorOfMoving.normalize(1);
	}
	
	public function dispose():Void {
		
	}
	
	function getActiveControls():Array<GameInputControl> {
		var result:Array<GameInputControl> = new Array();
		var floatP:Float = 0.0079;

		for (i in 0 ... myDevice.numControls){
				var control:GameInputControl = myDevice.getControlAt(i);
				if (control.value >= floatP || control.value <= -floatP){
					result.push(control);
				}
		}
		return result;
	}
	
	function controlBulletsDeploy(dt:Float):Void {
		_currentBulletTimeOffset -= dt;
		if (_currentBulletTimeOffset < 0 && deployTorpeds){
			var startPos = new Point(
				_x + (vectorOfMoving.x>0?-50:-uia.width), 
				_y + uia.height * .75
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