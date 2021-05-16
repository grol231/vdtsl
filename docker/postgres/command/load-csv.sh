#!/bin/bash

psql -U vdt -d vdt -c "truncate tmp_raw_points_$1"
psql -U vdt -d vdt -c "\copy tmp_raw_points_$1 FROM '$2' WITH (FORMAT CSV, DELIMITER ',', HEADER true)"

#psql -U vdt -d vdt -c "\copy (select * from tmp_raw_points_$1 order by device_crc, utc) to '$2' WITH (FORMAT CSV, DELIMITER ',', HEADER true)"

if [ $1 = '2gis' ]; then
  sql_2gis="insert into raw_points (import_id, device_id, source_id, region_id, utc_time, lat, lon, azimuth, speed, accuracy, utc_hour, utc_minute, utc_second)
            select hash_md5_bigint(to_char(current_timestamp, 'HH12:MI:SS')),
               hash_md5_bigint(device_crc::text), 1, 1, to_timestamp(utc),
               lat, lon, azimuth, accuracy, speed, utc_hour, utc_minute, utc_second::smallint from tmp_raw_points_2gis";

  psql -U vdt -d vdt -c "$sql_2gis"
fi

if [ $1 = 'starline' ]; then
  sql_starline="insert into raw_points (import_id, device_id, source_id, region_id, utc_time, lat, lon, azimuth, speed, accuracy, utc_hour, utc_minute, utc_second)
                select  hash_md5_bigint(to_char(current_timestamp, 'HH12:MI:SS')),
                   hash_md5_bigint(unique_device_id), 2, 1, to_timestamp(sample_timestamp_utc),
                   latitude, longitude, heading, speed_kph, 1,
                   date_part('hour', to_timestamp(sample_timestamp_utc)),
                   date_part('minute', to_timestamp(sample_timestamp_utc)),
                   date_part('second', to_timestamp(sample_timestamp_utc))::smallint
                   from tmp_raw_points_starline;"

  psql -U vdt -d vdt -c "$sql_starline"
fi



