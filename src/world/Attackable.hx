package world;
import world.collider.HitArea;

interface Attackable {
	public function hit(damage:Float):Void;
	public function impactForce():Float;
	public function hitArea():HitArea;
}