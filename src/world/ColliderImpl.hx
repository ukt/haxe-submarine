package world;
import world.collider.ColliderAction;
import world.collider.HitAreaType;
import world.collider.actions.CircleOnCircleColliderAction;
import world.entity.Entity;


class ColliderImpl implements Collider {
	
	private var collidableEntities:Array<Attackable> = new Array();
	private var actions:Map<String, ColliderAction> = new Map();
	public function new() {
		actions.set(HitAreaType.CIRCLE.getName() + "_on_" + HitAreaType.CIRCLE.getName(), new CircleOnCircleColliderAction());
	}	
	
	public function update(dt:Float):Void {
		for (entity1 in collidableEntities) {
			for (entity2 in collidableEntities) {
				if (entity1 == entity2){
					continue;
				}
				
				var hitArea1 = entity1.hitArea();
				var hitArea2 = entity2.hitArea();
				var isEntity1CollideEntity2 = hitArea1.collideMask() & hitArea2.hitMask();
				var isEntity2CollideEntity1 = hitArea2.collideMask() & hitArea1.hitMask();
				if (isEntity1CollideEntity2 == 0 && isEntity2CollideEntity1 == 0){	
					//trace('collideMask1: ${hitArea1.collideMask()}, collideMask2: ${hitArea2.collideMask()}, hitMask1: ${hitArea1.hitMask()}, hitMask2: ${hitArea2.hitMask()}');
					continue;
				}
				var action = actions.get(hitArea1.type() + "_on_" + hitArea2.type());
				var result = action.collide(hitArea1, hitArea2);
				if (result){
					var impactForce1:Float = isEntity1CollideEntity2 > 0?entity1.impactForce():0;
					var impactForce2:Float = isEntity2CollideEntity1 > 0?entity2.impactForce():0;
					entity1.hit(impactForce2);
					entity2.hit(impactForce1);
				}
				
			}
		}
	}
	
	public function addEntity(entity:Attackable):Void {
		collidableEntities.push(entity);
	}
	public function removeEntity(entity:Attackable):Void {
		collidableEntities.remove(entity);
	}
}