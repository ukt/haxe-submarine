package world.entity;

import world.Drawable;
import world.Updatable;

interface Entity extends Updatable extends Drawable {
	public function initialize(world:World):Void;
	public function dispose():Void;
}