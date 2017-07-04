package world.entity;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Point;
import world.World;

/**
 * ...
 * @author loka
 */
class SmokeVfx implements Entity 
{
	var uiaAssets:Bitmap;
	var uia:Sprite;
	var position:Point;
	var world:World;
	var timeToLive:Float;
	var frameRate:Float;
	var fullTimeToLive:Float;
	var rotation:Float;
	private static var frames:Array<RenderedBitmapData> = new Array();
	public function new(position:Point, timeToLive:UInt = 100, rotation:Float = 0) 
	{
		this.rotation = rotation;
		this.fullTimeToLive = this.timeToLive = timeToLive;
		this.position = position;
	}
	
	/* INTERFACE world.entity.Entity */
	var prevFrame:Int = 0;
	
	public function draw():Void 
	{
		
	}
	
	public function update(dt:Float):Void 
	{
		timeToLive -= dt;
		if (timeToLive < 0){
			world.removeEntity(this);
			timeToLive = 100500;
			return;
		}
		if (fullTimeToLive > timeToLive){
			var currentFrame:Int = Math.floor((fullTimeToLive - timeToLive) / frameRate);
			if(currentFrame != prevFrame && currentFrame<frames.length) {
				var rbd = frames[currentFrame];
				uiaAssets.bitmapData = rbd.bd;
				uiaAssets.x =  rbd.position.x;
				uiaAssets.y = rbd.position.y;
				prevFrame = currentFrame;
			}
		}
	}
	
	public function initialize(world:World):Void 
	{
		this.world = world;
		if (frames.length == 0) {
			for (i in 1 ... 24) {
				var bitmapData = Assets.getBitmapData("img/vfx/rocketSmoke/rocketSmoke00" + (i < 10?"0":"") + i + ".png");
				frames.push(new RenderedBitmapData(
					bitmapData,
					new Point(-15, -10)
				));
			}
		}
		this.frameRate = fullTimeToLive / frames.length;
		this.uiaAssets = new Bitmap();
		this.uia = new Sprite();
		this.uia.addChild(uiaAssets);
		Lib.current.stage.addChild(this.uia);
		this.uiaAssets.bitmapData = frames[0].bd;
		this.uia.x = position.x;
		this.uia.y = position.y;
		this.uia.rotation = rotation;		
		this.uiaAssets.smoothing = true;		
	}
	
	public function dispose():Void 
	{
		Lib.current.stage.removeChild(uia);
		uiaAssets.bitmapData = null;
		world = null;
		uia = null;
	}
}

class RenderedBitmapData{
	public var position:Point;
	public var bd:BitmapData;
	public function new(bd:BitmapData, position:Point) {
		this.position = position;
		this.bd = bd;
	}
}