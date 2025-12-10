package rhythmo.ui;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.typeLimit.NextState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import rhythmo.modding.module.ModuleHandler;
import rhythmo.modding.events.CreateEvent;
import rhythmo.modding.events.UpdateEvent;
import rhythmo.backend.Conductor.BPMChangeEvent;
import rhythmo.backend.Conductor.TimeScaleChangeEvent;
import rhythmo.backend.Conductor;
import rhythmo.ui.intro.Startup;
import rhythmo.Data;

class BaseState extends FlxTransitionableState
{
	public var curBeat:Int = 0;
	public var curStep:Int = 0;

    public var id:String = 'default';

	/**
	 * @param id The ID of the state.
	 * @param noTransition Whether or not to skip the transition when entering a state.
	 */
	override public function new(?id:String = 'default', ?noTransition:Bool = false):Void
	{
		super();

		this.id = id;

		if (!Startup.transitionsAllowed)
		{
			noTransition = true;
			Startup.transitionsAllowed = true;
		}

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;
	}

	override public function create():Void
	{
		super.create();

        id ??= 'default';

		ModuleHandler.callEvent(module ->
		{
			module.create(new CreateEvent(module, id));
		});
	}

	override public function update(elapsed:Float):Void
	{
        #if desktop
		if (FlxG.save.data != null)
			FlxG.fullscreen = Data.settings.fullscreen;
		#end

		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
			stepHit();

		super.update(elapsed);

        if (FlxG.stage != null)
			FlxG.stage.frameRate = Data.settings.framerate;

        ModuleHandler.callEvent(module ->
		{
			module.update(new UpdateEvent(module, id, elapsed));
		});
	}

    override public function destroy():Void
	{
		super.destroy();

		id = 'default';
	}

	public function transitionState(state:NextState, ?noTransition:Bool = false):Void
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;

		FlxG.switchState(state);
	}

	function updateBeat():Void
	{
		curBeat = Math.floor(curStep / Conductor.timeScale[1]);
	}

	function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length)
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];

		var dumb:TimeScaleChangeEvent = {
			stepTime: 0,
			songTime: 0,
			timeScale: [4, 4]
		};

		var lastTimeChange:TimeScaleChangeEvent = dumb;

		for (i in 0...Conductor.timeScaleChangeMap.length)
			if (Conductor.songPosition >= Conductor.timeScaleChangeMap[i].songTime)
				lastTimeChange = Conductor.timeScaleChangeMap[i];

		if (lastTimeChange != dumb)
			Conductor.timeScale = lastTimeChange.timeScale;

		Conductor.recalculateStuff();

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);

		updateBeat();
	}

	public function stepHit():Void
	{
		if (curStep % Conductor.timeScale[0] == 0)
			beatHit();
	}

	public function beatHit():Void {}
}