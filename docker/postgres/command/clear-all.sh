#!/bin/bash

psql -U vdt -d vdt -c "truncate tmp_raw_points_2gis"
psql -U vdt -d vdt -c "truncate tmp_raw_points_starline"
psql -U vdt -d vdt -c "truncate raw_points"