package world.collider;

interface ColliderAction {
	public function collide(h1:HitArea, h2:HitArea):Bool;
}