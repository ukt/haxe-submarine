package tests;
import game.masks.EntityMasks;
import haxe.unit.TestCase;


class EntityMasksTest extends TestCase {

	public function new() {
		super();
	}
	
	public function test_getMask():Void {
		assertEquals(2, EntityMasks.getMask(EntityMasks.HITTABLE));
	}
	
	public function test_getMasks():Void {
		assertEquals(2, EntityMasks.getMasks([EntityMasks.HITTABLE]));
	}
	
	public function test_getMasks2():Void {
		assertEquals(EntityMasks.getMasks([EntityMasks.HITTABLE, EntityMasks.ATTACKABLE]), EntityMasks.getMasks([EntityMasks.HITTABLE, EntityMasks.ATTACKABLE]));
	}
	
	public function test_getMasksOnCollide():Void {
		var mask1 = EntityMasks.getMasks([EntityMasks.HITTABLE, EntityMasks.ATTACKABLE]);
		var mask2 = EntityMasks.getMasks([EntityMasks.HITTABLE]);
		var mask3 = EntityMasks.getMasks([EntityMasks.ATTACKABLE]);
		assertTrue(mask1&mask2>0);
		assertTrue(mask1&mask3>0);
		assertFalse(mask2&mask3>0);
	}
}