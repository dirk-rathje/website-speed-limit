"use strict";


const fs = require('fs');
const Path = require('path');

const glob = require('glob-fs')({gitignore: true});
const D3DSV = require('d3-dsv');
const D3 = require('d3');

const Debug = require('debug')
Debug.formatters.J = (v) => {
    return JSON.stringify(v, null, "  ");
}
const debug = Debug();
debug.enabled = true;


const packageVersion = require("../../package.json").version;
const harvestedDataFolder = Path.join(".", "_data", packageVersion, "01-harvested");
const transformedDataFolder = Path.join(".", "_data", packageVersion, "02-transformed");

const mkdirp = require("mkdirp");
mkdirp.sync(transformedDataFolder)

let mergedData = [];

const regex = new RegExp(/results\/(.*)\/(.*)\/(.*)\/(.*)\/\d\d\d\d-\d\d/)


var filenames = glob.readdirSync(Path.join(harvestedDataFolder, "browsertime-results", "**/*.json"));

const measurements = filenames.map(filename => {

    debug("filename", filename)
    const match = regex.exec(filename)
    const browsertime = JSON.parse(fs.readFileSync(filename).toString())

    const requester  = match[1];
    const connectivity  = match[2];
    let requestMode  = match[3];
    const timestamp = browsertime.info.timestamp;

    if (requestMode === "1st-page-visit") {requestMode = "1st-site-visit"}
    const url  = browsertime.info.url;

    const measurement = {
        timestamp,
        rumSpeedIndex: browsertime.statistics.timings.rumSpeedIndex.median,
        requestMode,
        url,
        connectivity,


        requester,


    }
    return measurement;
})


let measurementsCSV = D3DSV.csvFormat(measurements)
fs.writeFileSync(Path.join(transformedDataFolder, "rumSpeedIndices.csv"), measurementsCSV);

let json = "";

measurements.forEach(m => {
    json += JSON.stringify(m) + "\n";
})


fs.writeFileSync(Path.join(transformedDataFolder, "rumSpeedIndices.json.log"),json);



