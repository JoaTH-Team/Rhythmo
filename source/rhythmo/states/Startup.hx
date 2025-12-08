package rhythmo.states;

import rhythmo.Data;
import rhythmo.modding.PolymodHandler;
import flixel.FlxState;
import flixel.sound.FlxSound;

class Startup extends FlxState
{
	override public function create():Void
	{
		FlxG.autoPause = FlxG.fixedTimestep = false;

		Data.init();
		PolymodHandler.init();

		FlxG.switchState(new PlayState());
	}
}
