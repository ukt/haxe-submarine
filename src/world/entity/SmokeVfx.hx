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
	private static var uiaDump:Array<MovieClip> = new Array();
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
		/*if (fullTimeToLive > timeToLive){
			var currentFrame:UInt = Math.floor((fullTimeToLive - timeToLive) / frameRate);
			//uia.gotoAndStop(currentFrame);
			if(currentFrame != prevFrame && currentFrame<frames.length) {
				var rbd = frames[currentFrame];
				uiaAssets.bitmapData = rbd.bd;
				uiaAssets.x =  rbd.position.x;
				uiaAssets.y = rbd.position.y;
				prevFrame = currentFrame;
			}
		}*/
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
			//uia.gotoAndStop(currentFrame);
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
			var uia:MovieClip = new RocketSmoke();
			for (i in 1 ... 24) {
				var bitmapData = Assets.getBitmapData("img/vfx/rocketSmoke/rocketSmoke00" + (i < 10?"0":"") + i + ".png");
				//bitmapData.
				frames.push(new RenderedBitmapData(
					bitmapData,
					new Point(-15, -10)
				));
			}
			/*for (i in 0 ... uia.totalFrames) {
				uia.gotoAndStop(i);
				//var bitmapData:BitmapData = new BitmapData(Math.round(uia.width), Math.round(uia.height), true, 0x00000000);
				//var bitmapData:BitmapData = drawImg(uia);
				//bitmapData.draw(uia);
				frames.push(drawImg(uia));
				
			}*/
			trace("Create new RocketSmoke");
		}
		this.frameRate = fullTimeToLive / frames.length;
		this.uiaAssets = new Bitmap();
		this.uia = new Sprite();
		this.uia.addChild(uiaAssets);
		Lib.current.stage.addChild(this.uia);
		//this.uia.stop();
		this.uiaAssets.bitmapData = frames[0].bd;
		this.uia.x = position.x/*+frames[0].position.x*/;
		this.uia.y = position.y/*+frames[0].position.y*/;		
		this.uia.rotation = rotation;		
		this.uiaAssets.smoothing = true;		
	}
	
public static function drawImg(el:DisplayObject, smoothing:Bool = true, x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):RenderedBitmapData {
			var matrix:Matrix = new Matrix();
			var rect = el.getRect(Lib.current.stage);
			
			//if (x == 0) matrix.tx = -x; else matrix.tx = -x;
			//if (y == 0) matrix.ty = -y; else matrix.ty = -y;
			//trace(rect);
			matrix.tx = -(rect.x-10);
			matrix.ty = -(rect.y-10);
			if (width == 0) width = el.width+20;
			if (height == 0) height = el.height+20;
			if(height < 1)
			{
				height = 1;
			}
			if(width < 1)
			{
				width = 1;
			}
			var bitMapDat:BitmapData = new BitmapData(Math.round(width), Math.round(height), true, 0x00000000);
			//var bitMapDat:BitmapData = new BitmapData(Math.round(width), Math.round(height), false, 0x000000);
			//bitMapDat.unlock();
			//bitMapDat.drawWithQuality(
			bitMapDat.draw(el, matrix);
			//var bitMap:Bitmap = new Bitmap(bitMapDat);
			//bitMap.smoothing = smoothing;
			return new RenderedBitmapData(bitMapDat, new Point(rect.x-10, rect.y-10));
		}
		
	public function dispose():Void 
	{
		Lib.current.stage.removeChild(uia);
		//uiaDump.push(uia);
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