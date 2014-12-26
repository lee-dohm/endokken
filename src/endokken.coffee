#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

ClassPage = require './class-page'
Template = require './template'

object = JSON.parse(fs.readFileSync(path.join(__dirname, '../spec/fixtures/api.json')).toString())
klass = object.classes.Atom
document = Template.render('layout', content: ClassPage.render(klass), title: 'Endokken')

console.log(document)
