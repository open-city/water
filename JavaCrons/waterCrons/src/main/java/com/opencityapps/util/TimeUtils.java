package com.opencityapps.util;

import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class TimeUtils {

//dd-mm-yyyy hh:mm:ss (military)
    public static DateTime convertForecastTimeToCST(String forecastTimeStr) {
        DateTimeFormatter fmt = DateTimeFormat.forPattern("dd-MM-yyyy HH:mm:ss");
        DateTime dt = fmt.parseDateTime(forecastTimeStr);

        dt = dt.withZoneRetainFields(DateTimeZone.forID("UTC"));
        DateTime cstTime = dt.withZone(DateTimeZone.forID("America/Chicago"));

        return cstTime;
    }

}
