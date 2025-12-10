package rhythmo.graphics.shaders;

import flixel.addons.display.FlxRuntimeShader;
import rhythmo.Assets;

/**
 * A shader that's generated at runtime instead of being complied.
 */
class RuntimeShader extends FlxRuntimeShader
{
	public function new(source:String):Void
	{
		super(Assets.getText(source));
	}
}