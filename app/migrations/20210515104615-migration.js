'use strict';

var dbm;
var type;
var seed;

/**
  * We receive the dbmigrate dependency from dbmigrate initially.
  * This enables us to not have to rely on NODE_PATH.
  */
exports.setup = function(options, seedLink) {
  dbm = options.dbmigrate;
  type = dbm.dataType;
  seed = seedLink;
};

exports.up = function(db) {
  const sql = "create table models\n" +
      "(\n" +
      "    id serial not null,\n" +
      "    avenue_model_id varchar(32) not null,\n" +
      "    name varchar(200) not null,\n" +
      "    file varchar(500),\n" +
      "    created_at timestamptz default now(),\n" +
      "    lt_lon numeric(10,7),\n" +
      "    lt_lat numeric(10,7),\n" +
      "    rb_lon numeric(10,7),\n" +
      "    rb_lat numeric(10,7)\n" +
      " \n" +
      ");\n" +
      "\n" +
      "create unique index models_id_uindex on models (id);\n" +
      "alter table models add constraint models_pk primary key (id);\n";
  db.runSql(sql);
  return null;
};

exports.down = function(db) {
  db.runSql("drop table models cascade;");
  return null;
};

exports._meta = {
  "version": 1
};
