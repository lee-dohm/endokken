#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

ClassPage = require './class-page'
Template = require './template'

object = JSON.parse(fs.readFileSync(path.join(__dirname, '../spec/fixtures/api.json')).toString())
page = new ClassPage(object.classes.CommandLogger)
fullPage = new Template 'layout',
  content: page.render()
  title: "Endokken: #{page.title}"

console.log(fullPage.render())
