package rhythmo.util;

#if linux
import rhythmo.Assets;
#end

/**
 * Utility class for window-related functions.
 */
@:nullSafety
class WindowUtil
{
	/**
	 * Initializes the window utility.
	 */
	public static function init():Void
	{
		#if linux
		if (Assets.exists('icon.png'))
		{
			final icon:Null<openfl.display.BitmapData> = Assets.getBitmapData('icon.png', false);

			if (icon != null)
				Lib.application.window.setIcon(icon.image);
		}
		#end
	}

	/**
	 * Show a popup with the given text.
	 * @param name The title of the popup.
	 * @param desc The content of the popup.
	 */
	public static inline function showAlert(name:String, desc:String):Void
	{
		#if !android
		Lib.application.window.alert(desc, name);
		#else
		extension.androidtools.Tools.showAlertDialog(name, desc, {name: 'Ok', func: null});
		#end
	}

	/**
   	 * Runs platform-specific code to open a URL in a web browser.
     * @param url The URL to open.
     */
	public static function openURL(url:String):Void
	{
		#if linux
		var cmd = Sys.command('xdg-open', [url]);
		if (cmd != 0)
			cmd = Sys.command('/usr/bin/xdg-open', [url]);
		Sys.command('/usr/bin/xdg-open', [url]);
		#else
		FlxG.openURL(url);
		#end
	}
}
