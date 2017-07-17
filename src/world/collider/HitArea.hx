package world.collider;
import world.entity.Entity;

interface HitArea {
	public function type():HitAreaType;
	public function hitMask():UInt;
	public function collideMask():UInt;
	//public entity():Entity;
	//public move(dx:Float, dy:Float):HitArea;
}