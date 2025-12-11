package rhythmo.ui.intro;

import rhythmo.Data;
import rhythmo.input.Input;
import rhythmo.ui.BaseState;
import rhythmo.modding.PolymodHandler;

class Startup extends BaseState
{
	static public var transitionsAllowed:Bool = false;

	override public function create():Void
	{
		FlxG.autoPause = FlxG.fixedTimestep = false;

		Data.init();
		Input.refreshControls();
		PolymodHandler.init();

		transitionState(new rhythmo.play.Gameplay());
	}
}
