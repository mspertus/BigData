add jar  /home/hadoop/IngestWeather-0.0.1-SNAPSHOT.jar;

CREATE EXTERNAL TABLE IF NOT EXISTS WeatherSummary
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.thrift.ThriftDeserializer'
    WITH SERDEPROPERTIES (
      'serialization.class' = 'edu.uchicago.mpcs53013.weatherSummary.WeatherSummary',
      'serialization.format' =  'org.apache.thrift.protocol.TBinaryProtocol')
  STORED AS SEQUENCEFILE 
  LOCATION '/inputs/thriftWeather';

CREATE EXTERNAL TABLE stations (code STRING, name STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/inputs/stations';

create table ontime(
  Year smallint,
  Quarter tinyint,
  Month tinyint,
  DayofMonth tinyint,
  DayOfWeek tinyint,
  FlightDate string,
  UniqueCarrier string,
  AirlineID string,
  Carrier string,
  TailNum string,
  FlightNum string,
  OriginAirportID string,
  OriginAirportSeqID string,
  OriginCityMarketID string,
  Origin string,
  OriginCityName string,
  OriginState string,
  OriginStateFips string,
  OriginStateName string,
  OriginWac string,
  DestAirportID string,
  DestAirportSeqID string,
  DestCityMarketID string,
  Dest string,
  DestCityName string,
  DestState string,
  DestStateFips string,
  DestStateName string,
  DestWac string,
  CRSDepTime string,
  DepTime string,
  DepDelay decimal,
  DepDelayMinutes string,
  DepDel15 string,
  DepartureDelayGroups string,
  DepTimeBlk string,
  TaxiOut string,
  WheelsOff string,
  WheelsOn string,
  TaxiIn string,
  CRSArrTime string,
  ArrTime string,
  ArrDelay decimal,
  ArrDelayMinutes string,
  ArrDel15 string,
  ArrivalDelayGroups string,
  ArrTimeBlk string,
  Cancelled string,
  CancellationCode string,
  Diverted string,
  CRSElapsedTime string,
  ActualElapsedTime string,
  AirTime string,
  Flights string,
  Distance string,
  DistanceGroup string,
  CarrierDelay string,
  WeatherDelay string,
  NASDelay string,
  SecurityDelay string,
  LateAircraftDelay string)
  stored as orc;

create table delays (
  year smallint, month tinyint, day tinyint, carrier string, flight string,
  origin_name string, origin_city string, origin_code string, dep_delay string,
  dest_name string, dest_city string, dest_code string, arr_delay string)
  stored as orc;

create table flights_and_weather (
  year smallint, month tinyint, day tinyint, carrier string, flight string,
  origin_name string, origin_city string, origin_code string, dep_delay double,
  dest_name string, dest_city string, dest_code string, arr_delay double,
  mean_temperature double, mean_visibility double, mean_windspeed double,
  fog boolean, rain boolean, snow boolean, hail boolean, thunder boolean, tornado boolean,
  fog_delay double, rain_delay double, snow_delay double, hail_delay double,
  thunder_delay double, tornado_delay double, clear_delay double) stored as orc;

create table route_delays (
  origin_name string, dest_name string, flights int,
  fog_flights int, fog_delays bigint,
  rain_flights int, rain_delays bigint,
  snow_flights int, snow_delays bigint,
  hail_flights int, hail_delays bigint,
  thunder_flights int, thunder_delays bigint,
  tornado_flights int, tornado_delays bigint,
  clear_flights int, clear_delays bigint);
