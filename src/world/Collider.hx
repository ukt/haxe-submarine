package world;
import world.entity.Entity;

interface Collider extends Updatable {
	function addEntity(entity:Attackable):Void;
	
	function removeEntity(entity:Attackable):Void;
	
}