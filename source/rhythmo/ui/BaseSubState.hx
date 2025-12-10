package rhythmo.ui;

import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.typeLimit.NextState;
import rhythmo.modding.module.ModuleHandler;
import rhythmo.modding.events.CreateEvent;
import rhythmo.modding.events.UpdateEvent;
import rhythmo.backend.Conductor.BPMChangeEvent;
import rhythmo.Data;

class BaseSubState extends FlxSubState
{
	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	public var id:String = 'default';

	/**
	 * @param bgColor Optional background color forwarded to FlxSubState.
	 * @param id The ID of the substate.
	 */
	override public function new(?bgColor:Null<Int> = null, ?id:String = 'default'):Void
	{
		super(bgColor);

		this.id = id;
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
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
			stepHit();

		super.update(elapsed);

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
		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;

		FlxG.switchState(state);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / (16 / Conductor.timeScale[1]));
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length)
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];

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