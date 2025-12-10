package rhythmo.ui.intro;

import rhythmo.Data;
import rhythmo.modding.PolymodHandler;
import flixel.FlxState;

class Startup extends FlxState
{
	override public function create():Void
	{
		FlxG.autoPause = FlxG.fixedTimestep = false;

		Data.init();
		PolymodHandler.init();

		FlxG.switchState(new rhythmo.play.Gameplay());
	}
}
