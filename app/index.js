const express           = require('express')
const dotenv            = require('dotenv');
const fs                = require('fs');
const _                 = require('lodash');
const { Pool, Client }  = require('pg');
const Router = require('express-promise-router');

const areaRepository = require('./repository/area-repository')
const modeRepository = require('./repository/model-repository')

dotenv.config();

const pool  = new Pool()
areaRepository.setClient(pool)
modeRepository.setClient(pool)

const router = new Router();

const port = process.argv[2];

const app = express()
app.use(express.json({ limit: '50mb' }))

let areas = [];
let points = {};
let handlers = {};
let logHour = (new Date()).getHours();

function timestampFormat(){
    function pad(n) {return n<10 ? "0"+n : n}
    const d = new Date()
    return d.getFullYear() +
        pad(d.getMonth()+1) +
        pad(d.getDate())+
        pad(d.getHours())
}

function generateFileName(areaId){
    return  areaId + '-' +  timestampFormat() + '-' + port + '.csv';
}

function reopenStreams(resetPoints){
    areas.forEach(function(area){
        if(resetPoints) {
            points[area.id] = [];
        }
        if(handlers[area.id]) {
            handlers[area.id].end();
        }
        logHour = (new Date()).getHours();
        const name = generateFileName(area.id);
        handlers[area.id] = fs.createWriteStream('./out/' + name, { flags: 'a' });
    });
}

app.post('/api/traffic/v1/probedata', (req, res) => {
    let total = 0;
    req.body.pp.forEach(function (point) {
        areas.forEach(function (area) {
            if(point.x >= area.lt_lon && point.x <= area.rb_lon){
                if(point.y <= area.lt_lat && point.y >= area.rb_lat){
                    points[area.id].push(point)
                    total++
                }
            }
        })
    });

    areas.forEach(function(area){
        if(points[area.id].length > 1000) {
            points[area.id].forEach(function (point) {
                handlers[area.id].write([point.id, point.t, point.x, point.y, point.s, point.h].join(',')+'\n')
            });
            points[area.id] = [];
        };
    });

    if (logHour != (new Date()).getHours()) {
        reopenStreams(false)
    }
    res.status(200).json({total});
});

async function reloadAreas (req, res, next) {
    const { rows } = await areaRepository.findAll();
    areas = JSON.parse(JSON.stringify(rows));
    points = {};
    reopenStreams(true);
    if (res) {
        res.status(200).json({port: port, status: 'success', total: rows.length});
    }
}

router.get('/area/reload', reloadAreas);

router.get('/area/stat',  async (req, res, next) => {
    const { rows } = await areaRepository.findAll();
    const stat = rows.map(function (row) {
        return {
            id: row.id,
            name: row.name,
            points_buffered: points[row.id] ? points[row.id].length:0
        }
    })
    res.status(200).json(stat);
})


router.get('/area/:id',  async (req, res, next) => {
    const id = parseInt(req.params.id);
    const { rows } = await areaRepository.findById(id);
    res.status(200).json(rows[0]);
})

router.delete('/area/:id',  async (req, res, next) => {
    const id = parseInt(req.params.id);
    const { rows } = await areaRepository.deleteById(id);
    res.status(200).json(rows[0]);
})

router.get('/area',  async (req, res, next) => {
    const { rows } = await areaRepository.findAll();
    res.status(200).json(rows);
})

router.post('/area',  async (req, res, next) => {
    const {rows}  = await areaRepository.insert(req.body);
    res.status(200).json(rows[0]);
})

app.use('/api/traffic/v1/', router)

app.get('/', (req, res) => {
    res.send('It work\'s on ' + port)
})

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
    console.log(`Reload areas`)
    reloadAreas();
});


