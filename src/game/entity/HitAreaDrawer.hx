package game.entity;

import openfl.Lib;
import openfl.display.Shape;
import world.Attackable;
import world.World;
import world.collider.CircleHitArea;
import world.entity.Entity;


class HitAreaDrawer implements Entity {
	var uia:Shape;
	var world:World;

	public function new() {
	
		
	}	
	
	
	/* INTERFACE world.entity.Entity */
	
	public function initialize(world:World):Void 
	{
		this.world = world;
		uia = new Shape();
		Lib.current.stage.addChild(uia);
	}
	
	public function dispose():Void {
		uia.graphics.clear();
		Lib.current.stage.removeChild(uia);
		world = null;
		uia = null;
	}
	
	public function draw():Void 
	{
		
	}
	
	public function update(dt:Float):Void 
	{
		uia.graphics.clear();
		uia.graphics.lineStyle(2, 0xff00ff);
		world.forEach(Attackable, function(attackable:Attackable){
			if (Std.is(attackable.hitArea(), CircleHitArea)){
				var cha = Std.instance(attackable.hitArea(), CircleHitArea);
				uia.graphics.drawCircle(cha.position.x, cha.position.y, cha.radius);
				//uia.graphics.drawCircle(cha.position.x, cha.position.y, cha.radius+Math.random()*5);
				//trace('drawCircle(${cha.position.x}, ${cha.position.y}, ${cha.radius});');
			}
		});
	}
}