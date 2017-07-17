package tests;
import game.entity.Mine;
import haxe.unit.TestCase;
import openfl.geom.Point;
import world.Attackable;
import world.World;
import world.entity.Entity;


class WorldTest extends TestCase {

	public function new() {
		super();
	}
	
	public function testListener(){
		var world = new World();
		world.addEntity(new MockMine());
		world.addEntity(new MockMine());
		world.onEnterFrame();
		var expextedCount = 2;
		var currentCount = 0;
		
		world.forEach(MockMine, function(mine:MockMine){
			currentCount++;
		});
		
		assertEquals(expextedCount, currentCount);
	}
}

class MockMine implements Entity{
	public function new(){
		
	}
	/* INTERFACE world.entity.Entity */
	
	public function initialize(world:World):Void 
	{
		
	}
	
	public function dispose():Void 
	{
		
	}
	
	public function draw():Void 
	{
		
	}
	
	public function update(dt:Float):Void 
	{
		
	}
}