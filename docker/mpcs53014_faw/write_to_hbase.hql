create external table weather_delays_by_route (
  route string,
  clear_flights bigint, clear_delays bigint,
  fog_flights bigint, fog_delay bigint,
  rain_flights bigint, rain_delay bigint,
  snow_flights bigint, snow_delay bigint,
  hail_flights bigint, hail_delay bigint,
  thunder_flights bigint, thunder_delay bigint,
  tornado_flights bigint, tornado_delay bigint)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,delay:clear_flights,delay:clear_delays,delay:fog_flights,delay:fog_delays,delay:rain_flights,delay:rain_delays,delay:snow_flights,delay:snow_delays,delay:hail_flights,delay:hail_delays,delay:thunder_flights,delay:thunder_delays,delay:tornado_flights,delay:tornado_delays')
TBLPROPERTIES ('hbase.table.name' = 'weather_delays_by_route');


insert overwrite table weather_delays_by_route
select concat(origin_name,dest_name),
  clear_flights, clear_delays,
  fog_flights, fog_delays,
  rain_flights, rain_delays,
  snow_flights, snow_delays,
  hail_flights, hail_delays,
  thunder_flights, thunder_delays,
  tornado_flights, tornado_delays from route_delays;
