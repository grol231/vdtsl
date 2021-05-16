create table regions
(
	id serial not null,
	name varchar(200) not null
);

create unique index regions_id_uindex on regions (id);
alter table regions	add constraint regions_pk primary key (id);
insert into regions(name) values ('Санкт-Петербург');



create table tmp_raw_points_starline
(
    unique_device_id     varchar(128),
    sample_timestamp_utc integer,
    latitude             numeric(20, 15),
    longitude            numeric(20, 15),
    speed_kph            integer,
    heading              integer
);
alter table tmp_raw_points_starline owner to vdt;



create table tmp_raw_points_2gis
(
    lon        numeric(20, 15),
    lat        numeric(20, 15),
    azimuth    integer,
    speed      integer,
    accuracy   real,
    utc        integer,
    device_crc bigint,
    utc_hour   integer,
    utc_minute integer,
    utc_second integer
);
alter table tmp_raw_points_2gis owner to vdt;



create table raw_points
(
    id         bigserial not null,
    import_id  bigint,
    device_id  bigint,
    source_id  smallint not null ,
    region_id  smallint,
    utc_time   timestamp,
    lat        numeric(12, 8),
    lon        numeric(12, 8),
    azimuth    smallint,
    speed      smallint,
    accuracy   real,
    utc_hour   smallint,
    utc_minute smallint,
    utc_second smallint
);
create unique index raw_points_id_uindex on raw_points (id);
alter table raw_points	add constraint raw_points_pk primary key (id);
alter table raw_points owner to vdt;


create or replace function hash_md5_bigint(text) returns bigint
    language sql
as
$$
select abs(('x'||substr(md5($1),1,16))::bit(64)::bigint);
$$;

alter function hash_md5_bigint(text) owner to vdt;


create table models
(
    id serial not null,
    avenue_model_id varchar(32) not null,
    name varchar(200) not null,
    file varchar(500),
    created_at timestamptz default now(),
    lt_lat numeric(10,7),
    rb_lon numeric(10,7),
    rb_lat numeric(10,7),
    lt_lon numeric(10,7)
);

create unique index models_id_uindex on models (id);
alter table models add constraint models_pk primary key (id);


create table nodes
(
    id bigserial not null,
    model_id integer not null,
    avenue_id varchar(20),
    parent_id varchar(20),
    type varchar(20),
    lon numeric(10, 7),
    lat numeric(10, 7),
    net329_id int,
    net32_lane_id int
);

create unique index nodes_id_uindex on nodes (id);
alter table nodes add constraint nodes_pk primary key (id);
ALTER TABLE nodes ADD CONSTRAINT nodes_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;


create table edges
(
    id bigserial not null,
    model_id integer not null,
    avenue_id varchar(20),
    parent_id varchar(20),
    target varchar(20),
    source varchar(20),
    portion varchar(10),
    distance numeric(10, 3)
);

create unique index edges_id_uindex on edges (id);
alter table edges add constraint edges_pk primary key (id);
ALTER TABLE edges ADD CONSTRAINT edges_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;


create table routes
(
    id bigserial not null,
    model_id int not null,
    start_avenue_id varchar(20) not null,
    end_avenue_id varchar(20) not null,
    route text
);

create unique index routes_id_uindex on routes (id);

alter table routes add constraint routes_pk primary key (id);
ALTER TABLE routes ADD CONSTRAINT routes_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;



create table first_greens
(
    id bigserial not null,
    model_id int not null,
    avenue_id varchar(20),
    parent_id varchar(20),
    device_id  bigint,
    t_offset int,
    queue int,
    green_time   timestamp,
    utc_timeint bigint,
    utc_hour   smallint,
    utc_minute smallint,
    utc_second smallint
);

create unique index first_greens_id_uindex on first_greens (id);

alter table first_greens add constraint first_greens_pk primary key (id);
ALTER TABLE first_greens ADD CONSTRAINT first_greens_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;


create table stopline_cross
(
    id bigserial not null,
    model_id int not null,
    avenue_id varchar(20),
    parent_id varchar(20),
    device_id  bigint,
    cross_time timestamp,
    utc_timeint bigint,
    utc_hour   smallint,
    utc_minute smallint,
    utc_second smallint
);

create unique index stopline_cross_id_uindex on stopline_cross (id);

alter table stopline_cross add constraint stopline_cross_pk primary key (id);
ALTER TABLE stopline_cross ADD CONSTRAINT stopline_cross_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;


alter table models add column cluster_meta text;


create table zipped_tracks
(
    id bigserial not null,
    model_id int not null,
    track_id varchar(50),
    start_time timestamp,
    finish_time timestamp,
    nodes text,
    trace text
);

create unique index zipped_tracks_id_uindex on zipped_tracks (id);



create table queue_data
(
    id bigserial not null,
    model_id int not null,
    avenue_id varchar(20),
    queue_time timestamp,
    stops int,
    queue int,
    delay int,
    utc_timeint bigint,
    utc_hour   smallint,
    utc_minute smallint,
    utc_second smallint
);

create unique index queue_data_id_uindex on queue_data (id);

alter table queue_data add constraint queue_data_pk primary key (id);
ALTER TABLE queue_data ADD CONSTRAINT queue_data_models_fk FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE;
