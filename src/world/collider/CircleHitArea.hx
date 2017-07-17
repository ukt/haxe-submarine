package world.collider;
import openfl.geom.Point;
import world.collider.HitAreaType;


class CircleHitArea implements HitArea {
	public var position(get, null):Point;
	public var radius(get, set):Float;
	var _radius:Float;
	var _hitMask:UInt;
	var _collideMask:UInt;

	public function new(position:Point, radius:Float, hitMask:UInt, collideMask:UInt = 0) {
		this._radius = radius;
		this.position = position;			
		this._hitMask = hitMask;			
		this._collideMask = collideMask;			
	}	
	
	public function type():HitAreaType {
		return HitAreaType.CIRCLE;
	}
	
	
	/* INTERFACE world.collider.HitArea */
	
	public function hitMask():UInt  {
		return _hitMask;
	}
	
	public function collideMask():UInt  {
		return _collideMask;
	}
	
	function get_position():Point 
	{
		return position;
	}
	
	function get_radius():Float 
	{
		return _radius;
	}
	
	function set_radius(value:Float):Float 
	{
		return _radius = value;
	}
}