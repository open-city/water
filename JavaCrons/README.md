#JavaCrons

####Automated scrapers that fill our mysql database

###ForecastIoScraper
Gets 48 hours of forecasts for eight weather stations acrossed the city and stores them in our database.  This data is used for our Combined Sewer Overflow prediction model

1. Requires the installation of Java 1.7 and Maven
2. Create build using maven with command:
`mvn package`
3. Run the app with java using:
```java
`java -cp ./waterCrons.jar org.opencityapps.cron.scrapeForecastIo *forecastIoKey* *mysql_database_host:port/dbName* *mysql_user* *user_password*`
```
  * **forecastIoKey** is a key from Forecast.io, which can be applied for here
  * **mysql_database_host:port/dbName** is the endpoint of your mysql server:  for example server.awesome.com:1234/waterDb
  * **mysql_user** is the user name that has write access to the mysql database
  * **user_password** is the password for the aforementioned user

