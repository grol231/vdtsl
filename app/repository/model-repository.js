
let client;

const sqlSelectModelById   = "SELECT * FROM models WHERE id = $1 LIMIT 1";


function setClient (c) {
    client = c;
}

async function findById (modelId) {
    return await client.query(sqlSelectModelById, [modelId]);
}

module.exports = {
    setClient,
    findById
};