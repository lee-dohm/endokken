#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

hamlc = require 'haml-coffee'

compileTemplate = (name) ->
  haml = fs.readFileSync(path.join(__dirname, '../templates', name)).toString()
  hamlc.compile(haml)

template = compileTemplate('layout.haml')
html = template(title: 'Endokkened', content: '<p>Test</p>')

console.log(html)
