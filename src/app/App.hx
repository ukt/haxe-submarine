package app;
import world.World;

/**
 * ...
 * @author loka
 */
class App 
{
	
	public static var instance(default, null):App = new App();
    
	public var world(default, null):World;

	public function new() 
	{
	}
	
	public function initialize() 
	{
		world = new World();		
	}
	
}