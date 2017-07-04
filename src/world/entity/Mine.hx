package world.entity;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;
import world.World;
import world.entity.Entity;

class Mine implements Entity {
	var uia:Bitmap;
	public function new(position:Point) {		
		this.position = position;
		
	}	
	
	
	/* INTERFACE world.entity.Entity */
	
	public function draw():Void 
	{
		
	}
	private var _currentDt:Float = 0;
	private var _speed = 10+Math.random()*5;
	var position:Point;
	private var _speedX = Math.random();
	public function update(dt:Float):Void 
	{
		_currentDt += _speedX * (dt / 1000);
		uia.x = position.x;
		uia.y = position.y + Math.sin(_currentDt) * _speed;
	}
	
	public function initialize(world:World):Void {
			var bitmapData = Assets.getBitmapData("img/mine_1.png");

		//var bitmapData = asset;
			var scale:Float = .20;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			var smallBMD:BitmapData = new BitmapData(Math.round(bitmapData.width * scale), Math.round(bitmapData.height * scale), true, 0xffffff);
			smallBMD.draw(bitmapData, matrix, null, null, null, true);
			bitmapData.dispose();
			
			//smallBMD.smo
		uia = new Bitmap(smallBMD);
		//uia.bitmapData = bitmapData;
		uia.cacheAsBitmap = true;
		uia.smoothing = true;
		Lib.current.stage.addChild(uia);
	}
	
	public function dispose():Void 
	{
		
	}
}
