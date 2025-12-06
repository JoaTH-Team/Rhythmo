package rhythmo.util;

/**
 * Utility class for date-related functions.
 */
class DateUtil
{
	/**
	 * Get the current date and time formatted as a string suitable for file names.
	 * @return The current date and time in the format "YYYY-MM-DD_HH-MM-SS", or null if the date cannot be retrieved.
	 */
	public static function getFormattedDateTimeForFile():Null<String>
	{
		final curDate:Null<Date> = Date.now();

		if (curDate != null)
			return curDate.toString().replace(' ', '_').replace(':', '-');

		return null;
	}
}
