package rhythmo.ui;

import flixel.FlxState;
import rhythmo.Data;
import rhythmo.backend.Conductor.BPMChangeEvent;
import rhythmo.backend.Conductor.TimeScaleChangeEvent;

class BaseState extends FlxState
{
	public var curBeat:Int = 0;
	public var curStep:Int = 0;

	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
			stepHit();

		if (FlxG.stage != null)
			FlxG.stage.frameRate = Data.settings.framerate;

		#if debug
		if (FlxG.keys.justPressed.F5)
			FlxG.resetState();
		#end

		super.update(elapsed);
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

		Conductor.recalculateStuff(multi);

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