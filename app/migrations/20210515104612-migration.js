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
  const sql = "create table areas \n" +
      "(\n" +
        "id serial not null,\n" +
        "name varchar(200) not null,\n" +
        "lt_lon numeric(10,7),\n" +
        "lt_lat numeric(10,7),\n" +
        "rb_lon numeric(10,7),\n" +
        "rb_lat numeric(10,7)\n" +
      ");\n" +
      "\n" +
      "create unique index areas_id_uindex on areas (id);\n" +
      "alter table areas add constraint areas_pk primary key (id);\n"
  db.runSql(sql);
  return null;
};

exports.down = function(db) {
  db.runSql("drop table areas cascade;");
  return null;
};

exports._meta = {
  "version": 1
};
