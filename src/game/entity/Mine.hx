package game.entity;
import game.entity.attack.CircleAttackEntity;
import game.masks.EntityMasks;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.media.Sound;
import world.Attackable;
import world.World;
import world.collider.CircleHitArea;
import world.collider.HitArea;
import world.collider.HitAreaType;
import world.entity.Entity;

class Mine implements Entity implements Attackable {
	var uia:Bitmap;
	private var _currentDt:Float = 0;
	private var _speed = 10+Math.random()*5;
	var position:Point;
	private var _speedX = Math.random();
	private var _isAlive = true;
	private var _scale:Float = 1;
	private var _minScale = 1;
	var world:World;
	var health:Float;
	var initializeHealth:Float;
	
	public function new(position:Point, health:Float) {
		this.initializeHealth = this.health = health;
		this.position = position;
		_scale = _minScale + 1;
	}	
	
	
	/* INTERFACE world.entity.Entity */
	
	public function draw():Void 
	{
		
	}
	
	public function update(dt:Float):Void 
	{
		_currentDt += _speedX * (dt / 1000);
		uia.x = position.x - uia.width/2;
		uia.y = position.y + Math.sin(_currentDt) * _speed - uia.height / 2;
		uia.scaleX = uia.scaleY = _scale;
	}
	
	public function initialize(world:World):Void {
			this.world = world;
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
	
	public function dispose():Void {
		world = null;
		Lib.current.stage.removeChild(uia);
		uia = null;
		position = null;
	}
	
	/* INTERFACE world.Attackable */
	
	public function hit(damage:Float):Void 
	{
		if (!_isAlive){
			return;
		}
		health -= damage;
		_scale = _minScale + health / initializeHealth;
		if (health > 0){
			return;
		}
		world.removeEntity(this);
		_isAlive = false;
		var radiuse = 10 + Math.round(Math.random() * 90);
		var damage = 100;
		var timeoutToExplose = Math.round(Math.random() * 500);
		world.addEntity(new CircleAttackEntity(position.clone(), radiuse, damage, timeoutToExplose));
	}
	
	public function hitArea():HitArea 
	{
		return new CircleHitArea(new Point(uia.x + uia.width / 2, uia.y + uia.height / 2), uia.width / 2, 
			EntityMasks.getMask(EntityMasks.HITTABLE),
			0
		);
	}
	
	
	/* INTERFACE world.Attackable */
	public function impactForce():Float 
	{
		return 20;
	}
}
