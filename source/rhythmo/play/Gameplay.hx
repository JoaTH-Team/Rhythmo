package rhythmo.play;

import flixel.text.FlxText;
import rhythmo.ui.BaseState;

class Gameplay extends BaseState
{
	override public function create():Void
	{
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
