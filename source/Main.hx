package;

import rhythmo.Game;
import rhythmo.backend.debug.FPS;
import haxe.ui.Toolkit;
#if hxgamemode
import hxgamemode.GamemodeClient;
#end
import flixel.util.typeLimit.NextState;

/**
 * The main entry point for the game.
 */
@:nullSafety
class Main extends openfl.display.Sprite
{
	/**
	 * The width of the game window in pixels.
	 */
	private static final GAME_WIDTH:Int = 1280;

	/**
	 * The height of the game window in pixels.
	 */
	private static final GAME_HEIGHT:Int = 720;

	/**
	 * The frame rate of the game, in frames per second (FPS).
	 */
	private static final GAME_FRAMERATE:Int = 60;

	/**
	 * The initial state of the game.
	 */
	private static final GAME_INITIAL_STATE:InitialState = () -> new rhythmo.ui.intro.Startup();

	/**
	 * Whether to skip the splash screen on startup.
	 */
	private static final GAME_SKIP_SPLASH:Bool = true;

	/**
	 * Whether to start the game in fullscreen mode on desktop.
	 */
	private static final GAME_START_FULLSCREEN:Bool = false;

	/**
	 * The frame rate display.
	 */
	public static var fpsDisplay:Null<FPS>;

	public static var framerate(get, set):Float;

	static function set_framerate(cap:Float):Float
	{
		if (FlxG.game != null)
		{
			FlxG.updateFramerate = Std.int(cap);
			FlxG.drawFramerate = Std.int(cap);
		}
		return Lib.current.stage.frameRate = cap;
	}

	static function get_framerate():Float
		return Lib.current.stage.frameRate;

	/**
	 * This will make it so it is run right at startup.
	 */
	private static function __init__():Void
	{
		#if hxgamemode
		if (GamemodeClient.request_start() != 0)
			Sys.println('Failed to request gamemode start: ${GamemodeClient.error_string()}...');
		else
			Sys.println('Succesfully requested gamemode to start...');
		#end
	}

	/**
	 * The entry point of the application.
	 */
	public static function main():Void
	{
		#if android
		Sys.setCwd(haxe.io.Path.addTrailingSlash(extension.androidtools.os.Build.VERSION.SDK_INT > 30 ? extension.androidtools.content.Context.getObbDir() : extension.androidtools.content.Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(haxe.io.Path.addTrailingSlash(openfl.filesystem.File.documentsDirectory.nativePath));
		#end

		#if (!web && !debug)
		rhythmo.api.CrashHandler.init();
		#end

		rhythmo.util.WindowUtil.init();

		Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		Lib.current.stage.quality = openfl.display.StageQuality.LOW;
		Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}

	/**
	 * Initializes the game and sets up the application.
	 */
	public function new():Void
	{
		super();

		Toolkit.init();
    	Toolkit.theme = 'dark'; 
    	Toolkit.autoScale = false;
    	haxe.ui.focus.FocusManager.instance.autoFocus = false;
    	haxe.ui.tooltips.ToolTipManager.defaultDelay = 200;

		#if windows
		rhythmo.api.native.WindowsAPI.darkMode(true);
		#end

		#if hxdiscord_rpc
		rhythmo.api.DiscordClient.load();
		#end

		rhythmo.util.CleanupUtil.init();
		rhythmo.util.ResizeUtil.init();

		framerate = GAME_FRAMERATE; // Default framerate
		addChild(new Game(GAME_WIDTH, GAME_HEIGHT, GAME_INITIAL_STATE, GAME_FRAMERATE, GAME_FRAMERATE, GAME_SKIP_SPLASH, GAME_START_FULLSCREEN));

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		#if debug
		rhythmo.util.plugins.MemoryGCPlugin.initialize();
		#end
		rhythmo.util.plugins.EvacuateDebugPlugin.initialize();
		rhythmo.util.plugins.CrashPlugin.initialize();

		FlxG.debugger.toggleKeys = [F2];

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		fpsDisplay = new FPS(10, 10, 0xffffff);
		addChild(fpsDisplay);

		#if desktop
		FlxG.mouse.visible = false;
		#end
	}
}