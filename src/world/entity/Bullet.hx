package world.entity;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.media.Sound;
import world.World;

class Bullet implements Entity {
	var uia:Bitmap;
	var world:World;
	var position:Point;
	var currentPoint:Point;
	var vector:Point;
	var speed:Float;
	var timeToLive:Float;
	var smokeInterval:Float;
	var smokeIntervalTmp:Float;
	var fireInterval:Float;
	var fireIntervalTmp:Float;
	var xa:Float;
	var ya:Float;
	
	public function new(startPoint:Point, vector:Point, speed:Float, timeToLive:Float = 5000, smokeInterval:Float = 50) {
		smokeIntervalTmp = this.smokeInterval = smokeInterval;
		fireIntervalTmp = this.fireInterval = smokeInterval * .25;
		this.speed = speed;
		this.vector = vector;
		currentPoint = this.position = startPoint;
		this.timeToLive = timeToLive;
		xa = (vector.x - startPoint.x) / (speed / 1000);
		ya = (vector.y - startPoint.y) / (speed / 1000);
		//trace("Bullet::xa: " + xa);
		//trace("Bullet::ya: " + ya);
	}
	
	
	/* INTERFACE world.entity.Entity */
	
	public function draw():Void {
		uia.x = position.x;
		uia.y = position.y;
	}
	
	public function update(dt:Float):Void {
		if ((timeToLive -= dt) < 0){
			world.removeEntity(this);
			timeToLive = 100500; 
			return;
		}
		position = GameMath.movePointByVector(position, (vector), speed * (dt/1000));
		smokeIntervalTmp -= dt;
		fireIntervalTmp -= dt;
		
		if (smokeIntervalTmp < 0){
			smokeIntervalTmp = smokeInterval;
			var position = GameMath.rotatePointAroundPoint(new Point(position.x, position.y+uia.height*.5), new Point(position.x, position.y), uia.rotation);
			world.addEntity(new SmokeVfx(position, 0xcecece, 300));
		}
		if (fireIntervalTmp < 0){
			fireIntervalTmp = fireInterval;
			var position = GameMath.rotatePointAroundPoint(new Point(position.x, position.y+uia.height*.5), new Point(position.x, position.y), uia.rotation);
			world.addEntity(new SmokeVfx(position, 0xffe100, 100));
			world.addEntity(new SmokeVfx(position, 0xff0000, 50));
		}
	}
	
	public function initialize(world:World):Void {
		this.world = world;
		trace(Bullet);
		trace("Bullet uploaded: ");
		trace("position: " + position);
		trace("vector: " + vector);
		var bitmapData = openfl.Assets.getBitmapData("img/torpedo2.png");
		var scale:Float = .30;
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		var smallBMD:BitmapData = new BitmapData(Math.round(bitmapData.width * scale), Math.round(bitmapData.height * scale), true, 0xffffff);
		smallBMD.draw(bitmapData, matrix, null, null, null, true);
		bitmapData.dispose();
		uia = new Bitmap(smallBMD);
		uia.cacheAsBitmap = true;
		//var v:Point = vector.subtract(startPoint);
		//v.normalize(1);
		//var zeroV:Point = new Point(1, 0);
		//zeroV.normalize(1);
		var angle:Float = GameMath.angleOfVector(vector);
		trace("angle::" + angle);
		uia.rotation = angle;
		//uia.scaleX = uia.scaleY = .15;
		
		//var bitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
		
		//var bitmap:Bitmap = new Bitmap();
		//bitmap.cacheAsBitmap = true;
		//uia.bitmapData = bitmapData;
		Lib.current.stage.addChild(uia);
		var sound:Sound = Assets.getSound("sounds/submarine-echo.wav");
		sound.play (0, -1);
		
	}
	
	public function dispose():Void {
		Lib.current.stage.removeChild(uia);
		
		uia.bitmapData.dispose();
		uia.bitmapData = null;
		
		world = null;
		uia = null;
		
		//bitmapData.disposeImage();
		trace("Bullet die");
	}
	
}