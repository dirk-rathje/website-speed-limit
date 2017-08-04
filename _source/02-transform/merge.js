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

const regex = new RegExp(/results\/(.*)\/(preloaded|unpreloaded)\/(.*)\/\d\d\d\d-\d\d/)


var filenames = glob.readdirSync(Path.join(harvestedDataFolder, "browsertime-results", "**/browsertime.json"));

const measurements = filenames.map(filename => {


    const match = regex.exec(filename)
    const browsertime = JSON.parse(fs.readFileSync(filename).toString())

    const measurement = {
        requester: match[1],
        preloaded: (match[2] === "preloaded"),
        url: browsertime.info.url,
        timestamp: browsertime.info.timestamp,
        connectivity: (browsertime.info.connectivity.profile === "custom" ? "dsl20" : browsertime.info.connectivity.profile),
        rumSpeedIndex: browsertime.statistics.timings.rumSpeedIndex.median
    }
    return measurement;
})


let measurementsCSV = D3DSV.csvFormat(measurements)
fs.writeFileSync(Path.join(transformedDataFolder, "rumSpeedIndices.csv"), measurementsCSV);

