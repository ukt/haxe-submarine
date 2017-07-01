package metrics;
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author loka
 */
class FPSStatistics  extends TextField
{
	private var times:Array<Float>;
	public var values:Map<String, Dynamic> = new Map();
	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();
		
		x = inX;
		y = inY;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 12, inCol);
		
		text = "FPS: ";
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 800;
		height = 600;
	}
	
	private function onEnter(_)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
			
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		
		if (visible)
		{	
			values.set("FPS", times.length);
			values.set("MEM", mem);
			values.set("MEM peak", memPeak);
			var str = "";
			for (key in values.keys()){
				str += key + ": " + values.get(key) + "\n";
			}
			text = str;
			//text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
		}
	}
	
}