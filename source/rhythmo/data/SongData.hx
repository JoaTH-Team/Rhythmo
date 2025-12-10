package rhythmo.data;

typedef SongMetaData =
{
	var song:String;
	var notes:Array<SectionData>;
	var bpm:Float;

	var timeScale:Array<Int>;
}

typedef SectionData =
{
	var sectionNotes:Array<NoteData>;
	var bpm:Float;
	var changeBPM:Bool;

	var timeScale:Array<Int>;
	var changeTimeScale:Bool;
	var stepsPerSection:Int;
}

typedef NoteData =
{
	var noteStrum:Float;
	var noteData:Int;
	var noteSus:Float;
}