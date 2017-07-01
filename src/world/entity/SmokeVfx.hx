package world.entity;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.geom.Point;
import world.World;

/**
 * ...
 * @author loka
 */
class SmokeVfx implements Entity 
{
	var uia:Shape;
	var position:Point;
	var world:World;
	var color:UInt;
	var timeToLive:Float;
	var alpha:Float = 1;
	var alphaDt:Float;
	var scale:Float = 1;
	var _x:Float;
	var _y:Float;
	public function new(position:Point, color:UInt = 0xcecece, timeToLive:UInt = 100) 
	{
		this.timeToLive = timeToLive;
		this.color = color;
		this.position = position;
		this.alphaDt = 1 / timeToLive;
		//trace("alphaDt: = " + alphaDt);
		
	}
	
	
	/* INTERFACE world.entity.Entity */
	
	public function draw():Void 
	{
		uia.scaleY = uia.scaleX = scale;
		uia.alpha = alpha;
		uia.x = _x;
		uia.y = _y;
	}
	
	public function update(dt:Float):Void 
	{
		if (timeToLive < 0){
			world.removeEntity(this);
			timeToLive = 100500;
		}
		alpha -= alphaDt * dt;
		timeToLive -= dt;
		scale += .1;
		_x += Math.random() * .8 - .4;
		_y += Math.random() * .8 - .6;
	}
	
	public function initialize(world:World):Void 
	{
		this.world = world;
		uia = new Shape();
		//uia.cacheAsBitmap
		_x = position.x;
		_y = position.y;
		Lib.current.stage.addChild(uia);
		uia.graphics.beginFill(color, 1);
		uia.graphics.drawCircle(0,0,2+Math.random());
		uia.graphics.endFill();
		uia.cacheAsBitmap = true;
		
		
	}
	
	public function dispose():Void 
	{
		Lib.current.stage.removeChild(uia);
		world = null;
		uia = null;
	}
	
}