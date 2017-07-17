package game.entity.attack;

import game.masks.EntityMasks;
import openfl.Assets;
import openfl.geom.Point;
import openfl.media.Sound;
import world.Attackable;
import world.World;
import world.collider.CircleHitArea;
import world.collider.HitArea;
import world.entity.Entity;


class CircleAttackEntity implements Entity implements Attackable {
	var _collideMask:UInt = 0;
	var position:Point;
	var radius:Float;
	var currentDt:Float = 0;
	var timeout:Float = 0;
	var _impactForce:Float = 0;
	var world:World;

	public function new(position:Point, radiuse:Float, impactForce:Float, timeout:Float = 0) {
		this._impactForce = impactForce;
		this.radius = radiuse;
		this.position = position;
		this.timeout = timeout;
	}	
			
	/* INTERFACE world.Attackable */
	
	public function hit(damage:Float):Void {
		
	}
	
	public function impactForce():Float {
		return _impactForce;
	}
	
	public function hitArea():HitArea {
		return new CircleHitArea(position, radius, 0, _collideMask);
	}	
	
	/* INTERFACE world.entity.Entity */
	
	public function initialize(world:World):Void {
		this.world = world;
		
	}
	
	public function dispose():Void {
		world = null;
		position = null;
		radius = null;
	}
	
	public function update(dt:Float):Void {
		if (_collideMask > 0){
			var sound:Sound = Assets.getSound("sounds/explosion_1.wav");
			sound.play (0, -1);
			world.removeEntity(this);
		}
		currentDt += dt;
		if(currentDt>timeout){
			_collideMask = EntityMasks.getMasks([EntityMasks.HITTABLE, EntityMasks.HITTABLE]);
		}
	}
	
	public function draw():Void {
		
	}
}