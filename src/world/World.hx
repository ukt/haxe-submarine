package world;
//import haxe.macro.Expr.Function;
import haxe.Constraints.Function;
import haxe.Timer;
import openfl.Lib;
import openfl.events.Event;
import world.World.CallBackFunction;
import world.Attackable;
import world.entity.Entity;

class World 
{
	private var entities:Array<Entity> = new Array();
	private var collider:Collider;
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
			if (collider != null && Std.is(entity, Attackable)){
				collider.removeEntity(cast(entity, Attackable));
			}
			entity.dispose();
			entities.remove(entity);
			if(Main.fps != null){
				Main.fps.values.set("World::entities.size", entities.length);
			}
		}));
	}
	
	public function useCollider(collider:Collider) {
		this.collider = collider;
	}
	
	@:generic public function forEach<T>(entityClass:Class<T>, listener:T->Void):World {
		for (entity in entities) {
			if (Std.is(entity, entityClass)){
				listener(cast(entity));
			}
		}
		return this;
	}
	public function addEntity(entity:Entity, forceAdd:Bool = false) 
	{
		for (entry in entitiesToPush){
			if (entry.entity == entity){
				trace("Could not to be add new entity: " + entity);
				return;
			}
		}
		entitiesToPush.push(new CallBackFunction(entity, function(world:World):Void{
			entities.push(entity);
			if (collider != null && Std.is(entity, Attackable)){
				collider.addEntity(cast(entity, Attackable));
			}
			entity.initialize(world);
			if (Main.fps != null ){
				Main.fps.values.set("World::entities.size", entities.length);
			}
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
		for (entity in entities){
			entity.update(Date.now().getTime() - currentTime);
		}
		if(collider != null){
			collider.update(Date.now().getTime() - currentTime);
		}
		currentTime = Date.now().getTime();
	}
	
	public function onEnterFrame(e:Event = null):Void 
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