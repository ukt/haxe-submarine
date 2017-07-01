package;
import openfl.geom.Point;

/**
 * ...
 * @author loka
 */
class GameMath 
{

	public function new() 
	{
		
	}
	/**
	 *
	 * @param	p is a vector
	 * @return return angle from 0 to 360
	 */
	public static function angleOfVector(p:Point):Float
	{
	  var a = Math.acos(p.x);
	  if (p.y < 0) a = Math.PI*2 - a;
	  return converRadToGrad(a);
	}
	
	public static function converRadToGrad(angle:Float):Float{
		return (angle / (2 * Math.PI)) * 360;
	}
	
	public static function converGradToRad(angle:Float):Float{
		//return (angle / (2 * Math.PI)) * 360;
		return ((angle+360)/360)*(Math.PI*2);
	}
	
	public static function movePointTowards(a:Point, b:Point, distance:Float):Point
	{
		var vector = new Point(b.x - a.x, b.y - a.y);
		var length = Math.sqrt(vector.x * vector.x + vector.y * vector.y);
		var unitVector = new Point(vector.x / length, vector.y / length);
		return new Point(a.x + unitVector.x * distance, a.y + unitVector.y * distance);
	}

	public static function movePointByVector(a:Point, vector:Point, distance:Float):Point
	{
		vector = vector.clone();
		//b.normalize(1000);
		//var a = b.x / b.y;
		//b.x = b.x * a;
		//b.y = b.y * a;
		//b.x *= 1000;// * (b.x > a.x?1: -1);
		//b.y *= 1000;// * (b.y > a.y?1: -1);
		//var vector = new Point(b.x - a.x, b.y - a.y);
		var length = Math.sqrt(vector.x * vector.x + vector.y * vector.y);
		var unitVector = new Point(vector.x / length, vector.y / length);
		return new Point(a.x + unitVector.x * distance, a.y + unitVector.y * distance);
	}
	/**
	 * 
	 * @param	point
	 * @param	arroundPoint
	 * @param	angle in graduce
	 * @return
	 */
	public static function rotatePointAroundPoint(point:Point, arroundPoint:Point, angle:Float):Point
	{
		return rotatePoint(point.subtract(arroundPoint), angle)
			.add(arroundPoint);
	}
		
	/**
	 * 
	 * @param	point
	 * @param	angle in graduce
	 * @return
	 */
	public static function rotatePoint(point:Point, angle:Float):Point
	{
		angle = converGradToRad(angle);
		return calcRotation(point.clone(), Math.sin(angle), Math.cos(angle));
	}
	

	private static function calcRotation(point:Point, sinA:Float, cosA:Float):Point
	{
		var xx:Float = point.x * cosA - point.y * sinA;
		point.y = point.y * cosA + point.x * sinA;
		point.x = xx;
		return point;
	}
	
}