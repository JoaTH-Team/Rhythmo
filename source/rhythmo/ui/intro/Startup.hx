package rhythmo.ui.intro;

import rhythmo.Data;
import rhythmo.input.Input;
import rhythmo.ui.BaseState;
import rhythmo.ui.intro.Splash;
import rhythmo.ui.menu.MainMenu;
import rhythmo.util.PlatformUtil;
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
		
		trace('Current platform: ${PlatformUtil.getPlatform()}');

		transitionState((Data.settings.skipSplash) ? new Splash() : new MainMenu());
	}
}