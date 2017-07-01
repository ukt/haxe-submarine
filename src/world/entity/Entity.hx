package world.entity;

interface Entity {
	public function draw():Void;
	public function update(dt:Float):Void;
	public function initialize(world:World):Void;
	public function dispose():Void;
}