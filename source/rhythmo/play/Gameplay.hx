package rhythmo.play;

import rhythmo.ui.BaseState;

class Gameplay extends BaseState
{
	override public function create():Void
	{
		var text:FlxText = new FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
