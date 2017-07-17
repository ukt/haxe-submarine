package game.masks;


class EntityMasks {
	public static var HITTABLE = "HITTABLE";
	public static var ATTACKABLE = "ATTACKABLE";
	public static var HASH:Map<String,Int> = new Map();
	private static var mask:UInt = 2;
	private static var init:EntityMasks = new EntityMasks();
	public function new() {
		initMask(HITTABLE);
		initMask(ATTACKABLE);
	}	
	
	public static function getMasks(value:Array<String>):UInt {
		var result:UInt = 0;
		for (mask in value) {
			result |= HASH[mask];
		}
		return result;
	}
	
	public static function getMask(value:String):UInt {
		var arr:Array<String> = value.split(",");
		return getMasks(arr);
	}
	
	static private function initMask(value:String):Void {
		HASH[value] = mask;
		mask *= 2;
	}

}