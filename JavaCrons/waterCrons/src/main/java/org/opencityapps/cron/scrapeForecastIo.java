package org.opencityapps.cron;

import com.github.dvdme.ForecastIOLib.FIODataPoint;
import com.github.dvdme.ForecastIOLib.FIOHourly;
import com.github.dvdme.ForecastIOLib.ForecastIO;
import com.opencityapps.util.TimeUtils;
import org.joda.time.DateTime;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class scrapeForecastIo {

    public static void main(String[] args) {

        // TODO: Create configuration file
        String forecastIoKey = args[0];
        String connectionString = "jdbc:mysql://" + args[1];
        String userName = args[2];
        String password = args[3];

        Connection connection;
        Statement statement;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager
                    .getConnection(connectionString, userName, password);
            statement = connection.createStatement();
        }
        catch (Exception e) {
            e.printStackTrace();
            return;
        }

        System.out.println("Grabbing data from ForecastIo");


        ForecastIO fio = new ForecastIO(forecastIoKey); //instantiate the class with the API key.
        fio.setUnits(ForecastIO.UNITS_SI);             //sets the units as SI - optional


        List<List<String>> weatherStationCoords = new ArrayList<List<String>>(8);

        // TODO: Shouldn't be hardcoded like this
        weatherStationCoords.add(Arrays.asList("ARR", "41.77", "-88.48139"));
        weatherStationCoords.add(Arrays.asList("DPA", "41.91444", "-88.24639"));
        weatherStationCoords.add(Arrays.asList("IGQ", "41.5362", "87.5327"));
        weatherStationCoords.add(Arrays.asList("LOT", "41.60", "-88.09"));
        weatherStationCoords.add(Arrays.asList("MDW", "41.78611", "-87.75222"));
        weatherStationCoords.add(Arrays.asList("ORD", "41.995", "-87.9336"));
        weatherStationCoords.add(Arrays.asList("PWK", "42.12083", "-87.90472"));
        weatherStationCoords.add(Arrays.asList("UGN", "42.41667", "-87.86667"));

        for(List<String> coords : weatherStationCoords) {
            String callSign = coords.get(0);
            fio.getForecast(coords.get(1), coords.get(2));
            FIOHourly hourly = new FIOHourly(fio);

            for(int i = 0; i<hourly.hours(); i++){

                FIODataPoint hourlyDataPoint = hourly.getHour(i);

                Double precipIntensity = hourlyDataPoint.precipIntensity();
                String precipType = hourlyDataPoint.precipType();
                if (precipType.equals("no data"))
                    precipType = null;


                String time = hourlyDataPoint.time();
                DateTime timeCst = TimeUtils.convertForecastTimeToCST(time);
                Timestamp timestamp = new Timestamp(timeCst.getMillis());


                String query = "INSERT INTO io_forecast (call_sign, forecast_time, precip_intensity, precip_type) " +
                        "VALUES ('" + callSign + "','" + timestamp + "'," + precipIntensity + "," + precipType + ")";

                try {
                    statement.addBatch(query);
                }
                catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }

        try {
            statement.executeBatch();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (null != statement) statement.close();
                connection.close();
            }
            catch (Exception e) {e.printStackTrace();}

        }

        System.out.println("Done!");

    }
}
