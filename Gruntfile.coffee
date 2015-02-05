path = require 'path'

module.exports = (grunt) ->
  themeJoin = (theme, subPath...) ->
    path.join('./themes', theme, subPath...)

  stylesheetOut = (theme) ->
    themeJoin(theme, 'static', 'base.css')

  stylesheetSource = (theme) ->
    themeJoin(theme, 'stylesheets', 'base.less')

  jasmine = './node_modules/jasmine-focused/bin/jasmine-focused'
  lessc = './node_modules/less/bin/lessc'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    copy:
      css:
        expand: true
        cwd: 'bootstrap/dist/css'
        src: '*.min.css'
        dest: themeJoin('default', 'static')
      js:
        expand: true
        cwd: 'bootstrap/dist/js'
        src: '*.min.js'
        dest: themeJoin('default', 'static')
      fonts:
        expand: true
        cwd: 'bootstrap/dist/fonts'
        src: '*'
        dest: themeJoin('default', 'static')

    coffeelint:
      options: grunt.file.readJSON('coffeelint.json')
      src: ['src/*.coffee']
      test: ['spec/*.coffee']

    shell:
      spec:
        command: "#{jasmine} --captureExceptions --coffee spec/"
        options:
          stdout: true
          stderr: true
          failOnError: true

      less:
        command: "#{lessc} #{stylesheetSource('default')} > #{stylesheetOut('default')}"
        options:
          stdout: true
          stderr: true
          failOnError: true

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask 'clean', -> require('rimraf').sync('lib')
  grunt.registerTask('lint', ['coffeelint:src', 'coffeelint:test'])
  grunt.registerTask('less', ['shell:less'])
  grunt.registerTask('default', ['lint', 'spec', 'less', 'copy'])
  grunt.registerTask('spec', ['shell:spec'])
  grunt.registerTask('test', ['spec'])
