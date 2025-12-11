package rhythmo.input;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.FlxInput.FlxInputState;

/**
 * A structure for input bindings, which includes both a keyboard key and a gamepad button.
 */
typedef Bind =
{
	/**
	 * The keyboard key(s) associated with the action.
	 */
	key:Array<FlxKey>,

	/**
	 * The gamepad button(s) associated with the action.
	 */
	gamepad:Array<FlxGamepadInputID>
}

/**
 * Class for handling inputs for keyboard and gamepad.
 * @author Joalor64
 */
class Input
{
	static public var kBinds:Array<FlxKey> = Data.settings.keyboardBinds;
	static public var gBinds:Array<FlxGamepadInputID> = Data.settings.gamepadBinds;

	/**
	 * A map of input bindings.
	 */
	public static var binds:Map<String, Bind> = [
		'ui_left' => {key: [kBinds[0], kBinds[4]], gamepad: [gBinds[0], gBinds[4]]},
		'ui_down' => {key: [kBinds[1], kBinds[5]], gamepad: [gBinds[1], gBinds[5]]},
		'ui_up' => {key: [kBinds[2], kBinds[6]], gamepad: [gBinds[2], gBinds[6]]},
		'ui_right' => {key: [kBinds[3], kBinds[7]], gamepad: [gBinds[3], gBinds[7]]},
        'note_left' => {key: [kBinds[8], kBinds[12]], gamepad: [gBinds[8], gBinds[12]]},
		'note_down' => {key: [kBinds[9], kBinds[13]], gamepad: [gBinds[9], gBinds[13]]},
		'note_up' => {key: [kBinds[10], kBinds[14]], gamepad: [gBinds[10], gBinds[14]]},
		'note_right' => {key: [kBinds[11], kBinds[15]], gamepad: [gBinds[11], gBinds[15]]},
		'accept' => {key: [kBinds[16], kBinds[17]], gamepad: [gBinds[13], gBinds[16]]},
		'back' => {key: [kBinds[18], kBinds[19]], gamepad: [gBinds[15]]},
        'pause' => {key: [kBinds[18], kBinds[20]], gamepad: [gBinds[16]]},
		'reset' => {key: [kBinds[21]], gamepad: [gBinds[17]]}
	];

	/**
	 * Refreshes the input controls based on the current settings.
	 */
	public static function refreshControls():Void
	{
		kBinds = Data.settings.keyboardBinds;
		gBinds = Data.settings.gamepadBinds;

		binds.clear();
		binds = [
			'ui_left' => {key: [kBinds[0], kBinds[4]], gamepad: [gBinds[0], gBinds[4]]},
		    'ui_down' => {key: [kBinds[1], kBinds[5]], gamepad: [gBinds[1], gBinds[5]]},
		    'ui_up' => {key: [kBinds[2], kBinds[6]], gamepad: [gBinds[2], gBinds[6]]},
		    'ui_right' => {key: [kBinds[3], kBinds[7]], gamepad: [gBinds[3], gBinds[7]]},
            'note_left' => {key: [kBinds[8], kBinds[12]], gamepad: [gBinds[8], gBinds[12]]},
		    'note_down' => {key: [kBinds[9], kBinds[13]], gamepad: [gBinds[9], gBinds[13]]},
		    'note_up' => {key: [kBinds[10], kBinds[14]], gamepad: [gBinds[10], gBinds[14]]},
		    'note_right' => {key: [kBinds[11], kBinds[15]], gamepad: [gBinds[11], gBinds[15]]},
		    'accept' => {key: [kBinds[16], kBinds[17]], gamepad: [gBinds[13], gBinds[16]]},
		    'back' => {key: [kBinds[18], kBinds[19]], gamepad: [gBinds[15]]},
            'pause' => {key: [kBinds[18], kBinds[20]], gamepad: [gBinds[16]]},
		    'reset' => {key: [kBinds[21]], gamepad: [gBinds[17]]}
		];
	}

	/**
	 * Checks if the input associated with the given tag was just pressed.
	 * @param tag The action name to check.
	 * @return `true` if the key or gamepad button was just pressed, `false` otherwise.
	 */
	public static function justPressed(tag:String):Bool
		return checkInput(tag, JUST_PRESSED);

	/**
	 * Checks if the input associated with the given tag is currently pressed.
	 * @param tag The action name to check.
	 * @return `true` if the key or gamepad button is pressed, `false` otherwise.
	 */
	public static function pressed(tag:String):Bool
		return checkInput(tag, PRESSED);

	/**
	 * Checks if the input associated with the given tag was just released.
	 * @param tag The action name to check.
	 * @return `true` if the key or gamepad button was just released, `false` otherwise.
	 */
	public static function justReleased(tag:String):Bool
		return checkInput(tag, JUST_RELEASED);

	/**
	 * Checks if any of the inputs associated with the given tags were just pressed.
	 * @param tags An array of action names to check.
	 * @return `true` if any of the keys or gamepad buttons were just pressed, `false` otherwise.
	 */
	public static function anyJustPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_PRESSED);

	/**
	 * Checks if any of the inputs associated with the given tags are currently pressed.
	 * @param tags An array of action names to check.
	 * @return `true` if any of the keys or gamepad buttons are currently pressed, `false` otherwise.
	 */
	public static function anyPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, PRESSED);

	/**
	 * Checks if any of the inputs associated with the given tags were just released.
	 * @param tags An array of action names to check.
	 * @return `true` if any of the keys or gamepad buttons were just released, `false` otherwise.
	 */
	public static function anyJustReleased(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_RELEASED);

	/**
	 * Checks if the input associated with the given tag is in the specified state.
	 * @param tag The action name to check.
	 * @param state The state to check.
	 * @return `true` if the key or gamepad button is in the specified state, `false` otherwise.
	 */
	public static function checkInput(tag:String, state:FlxInputState):Bool
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (binds.exists(tag))
		{
			var bind:Null<Bind> = binds.get(tag);
			if (bind == null)
				return false;

			#if FLX_KEYBOARD
			for (input in binds[tag].key)
				if (FlxG.keys.checkStatus(input, state))
					return true;
			#end

			#if FLX_GAMEPAD
			for (input in binds[tag].gamepad)
				if (gamepad != null && gamepad.checkStatus(input, state))
					return true;
			#end
		}
		else
		{
			#if FLX_KEYBOARD
			var kbInput:Null<FlxKey> = FlxKey.fromString(tag);
			if (kbInput != null && kbInput != FlxKey.NONE && FlxG.keys.checkStatus(kbInput, state))
				return true;
			#end

			#if FLX_GAMEPAD
			var gpInput:Null<FlxGamepadInputID> = FlxGamepadInputID.fromString(tag);
			if (gamepad != null && gpInput != null && gpInput != FlxGamepadInputID.NONE && gamepad.checkStatus(gpInput, state))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if any of the inputs associated with the given tags are in the specified state.
	 * @param tags An array of action names to check.
	 * @param state The state to check.
	 * @return `true` if any of the keys or gamepad buttons are in the specified state, `false` otherwise.
	 */
	public static function checkAnyInputs(tags:Array<String>, state:FlxInputState):Bool
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (tags == null || tags.length <= 0)
			return false;

		for (tag in tags)
		{
			if (binds.exists(tag))
			{
				var bind:Null<Bind> = binds.get(tag);
				if (bind == null)
					return false;

				#if FLX_KEYBOARD
				for (input in binds[tag].key)
					if (FlxG.keys.checkStatus(input, state))
						return true;
				#end

				#if FLX_GAMEPAD
				for (input in binds[tag].gamepad)
					if (gamepad != null && gamepad.checkStatus(input, state))
						return true;
				#end
			}
			else
			{
				#if FLX_KEYBOARD
				var kbInput:Null<FlxKey> = FlxKey.fromString(tag);
				if (kbInput != null && kbInput != FlxKey.NONE && FlxG.keys.checkStatus(kbInput, state))
					return true;
				#end

				#if FLX_GAMEPAD
				var gpInput:Null<FlxGamepadInputID> = FlxGamepadInputID.fromString(tag);
				if (gamepad != null && gpInput != null && gpInput != FlxGamepadInputID.NONE && gamepad.checkStatus(gpInput, state))
					return true;
				#end
			}
		}

		return false;
	}
}