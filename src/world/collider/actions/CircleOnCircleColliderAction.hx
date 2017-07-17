package world.collider.actions;

import world.collider.CircleHitArea;
import world.collider.ColliderAction;
import world.collider.HitArea;


class CircleOnCircleColliderAction implements ColliderAction {

	public function new() {
	
	}	
	
	
	/* INTERFACE world.collider.ColliderAction */
	
	public function collide(h1:HitArea, h2:HitArea):Bool {
		var ch1:CircleHitArea = Std.instance(h1, CircleHitArea);
		var ch2:CircleHitArea = Std.instance(h2, CircleHitArea);
		var distance:Float = ch1.position.subtract(ch2.position).length;
		var distanceToCollide:Float = ch1.radius + ch2.radius;
		if (distance < distanceToCollide){
			trace("Collided!!!");
			return true;
		}
		return false;
		
	}
}