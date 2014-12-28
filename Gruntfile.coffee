module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    copy:
      css:
        expand: true
        cwd: 'bootstrap/dist/css'
        src: '*.min.css'
        dest: 'static/'
      js:
        expand: true
        cwd: 'bootstrap/dist/js'
        src: '*.min.js'
        dest: 'static/'
      fonts:
        expand: true
        cwd: 'bootstrap/dist/fonts'
        src: '*'
        dest: 'static/'

    coffeelint:
      options: grunt.file.readJSON('coffeelint.json')
      src: ['src/*.coffee']
      test: ['spec/*.coffee']

    shell:
      spec:
        command: './node_modules/jasmine-focused/bin/jasmine-focused --captureExceptions --coffee spec/'
        options:
          stdout: true
          stderr: true
          failOnError: true

      less:
        command: './node_modules/less/bin/lessc ./stylesheets/base.less > ./static/base.css'
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
  grunt.registerTask('default', ['lint', 'test', 'less', 'copy'])
  grunt.registerTask('spec', ['shell:spec'])
  grunt.registerTask('test', ['spec'])
