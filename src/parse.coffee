#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

donna = require 'donna'
tello = require 'tello'

rootPath = path.resolve('.')
outputPath = path.resolve('api.json')

metadata = donna.generateMetadata([rootPath])
digestedMetadata = tello.digest(metadata)
api = JSON.stringify(digestedMetadata, null, 2)
fs.writeFileSync(outputPath, api)
