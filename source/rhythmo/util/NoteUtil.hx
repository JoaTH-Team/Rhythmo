package rhythmo.util;

class NoteUtil 
{
    public static function getDirection(index:Int):String
	{
		return switch (index)
		{
			case 0: 'left';
			case 1: 'down';
			case 2: 'up';
			case 3: 'right';
			default: 'unknown';
		}
	}

	public static function getNoteIndex(direction:String):Int
	{
		return switch (direction)
		{
			case 'left': 0;
			case 'down': 1;
			case 'up': 2;
			case 'right': 3;
			default: -1;
		}
	}
}