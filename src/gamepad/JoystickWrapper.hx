package gamepad;
import haxe.Constraints.Function;

/**
 * ...
 * @author loka
 */
class JoystickWrapper 
{
	private var map:Map<String, Function> = new Map();
	public function new() 
	{
		
	}
	
	public function addListener(type:String, listener:Function/*<Float->Bool->Void>*/ ) {
		map.set(type, listener);
	}
	
}