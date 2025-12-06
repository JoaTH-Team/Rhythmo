package rhythmo.states;

import rhythmo.Data;
import rhythmo.modding.PolymodHandler;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create():Void
	{
		FlxG.autoPause = FlxG.fixedTimestep = false;

		Data.init();
		PolymodHandler.init();

		super.create();

		var text:FlxText = new FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
