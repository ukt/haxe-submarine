package world;
//import haxe.macro.Expr.Function;
import haxe.Constraints.Function;
import haxe.Timer;
import openfl.Lib;
import openfl.events.Event;
import world.World.CallBackFunction;
import world.entity.Entity;

class World 
{
	private var entities:Array<Entity> = new Array();
	private var entitiesToPush:Array<CallBackFunction> = new Array();
	private var entitiesToRemove:Array<CallBackFunction> = new Array();
	private var timer:haxe.Timer;
	var currentTime:Float;

	public function new() 
	{
		
	}
	
	public function removeEntity(entity:Entity){
		for (entry in entitiesToRemove){
			if (entry.entity == entity){
				trace("Could not to be remove entity: " + entity);
				return;
			}
		}
		entitiesToRemove.push(new CallBackFunction(entity, function():Void{
			entity.dispose();
			entities.remove(entity);
			Main.fps.values.set("World::entities.size", entities.length);
		}));
	}
	public function addEntity(entity:Entity) 
	{
		for (entry in entitiesToPush){
			if (entry.entity == entity){
				trace("Could not to be add new entity: " + entity);
				return;
			}
		}
		entitiesToPush.push(new CallBackFunction(entity, function(world:World):Void{
			entities.push(entity);
			entity.initialize(world);
			Main.fps.values.set("World::entities.size", entities.length);
		}));
		
	}
	
	public function start() 
	{
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		timer = new Timer(Math.round(1000/30));
		currentTime = Date.now().getTime();
		timer.run = onTimer;
	}
	
	private function onTimer():Void {
		//var time = Date.now().getTime();
		//var dt = time - currentTime;
		for (entity in entities){
			entity.update(Date.now().getTime() - currentTime);
		}
		currentTime = Date.now().getTime();
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		for (f in entitiesToPush){
			f.action(this);
		}
		entitiesToPush = new Array();

		for (entity in entities){
			entity.draw();
		}
		for (f in entitiesToRemove){
			f.action();
		}
		entitiesToRemove = new Array();
	}
	
}
class CallBackFunction {
	public var action:Function;
	public var entity:Entity;
	public function new(entity:Entity, action:Function){
		this.action = action;
		this.entity = entity;
		
	}
}