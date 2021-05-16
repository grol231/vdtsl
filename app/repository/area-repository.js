
let client;

const sqlSelectAreaById  = "SELECT * FROM areas WHERE id = $1";
const sqlDeleteAreaById  = "DELETE FROM areas WHERE id = $1 RETURNING *";
const sqlSelectAreaAll   = "SELECT * FROM areas order by id limit 1000";
const sqlInsertArea      = "insert into areas (name, lt_lon, lt_lat, rb_lon, rb_lat)  " +
                            "values ($1,$2,$3,$4,$5) returning *;";


function setClient (c) {
    client = c;
}

function findById (areaId) {
    return  client.query(sqlSelectAreaById, [areaId]);
}

function deleteById (areaId) {
    return  client.query(sqlDeleteAreaById, [areaId]);
}


function findAll () {
    return  client.query(sqlSelectAreaAll);
}


function insert (area) {
    return client.query(sqlInsertArea, [area.name, area.ltLon,  area.ltLat,  area.rbLon,  area.rbLat])
}

module.exports = {
    setClient,
    findById,
    deleteById,
    findAll,
    insert
};