module.exports = (grunt) ->
    # -----------------------------------
    # Options
    # -----------------------------------
    grunt.config.init
        compass:
            dev:
                options:
                    sassDir: './example'
                    cssDir: './example'
                    outputStyle: 'compressed'

        coffee:
            source:
                files:
                    './dist/angular-form-builder.js': ['./src/*.coffee']
            demo:
                files:
                    './example/demo.js': './example/demo.coffee'

        watch:
            compass:
                files: ['./example/*.scss']
                tasks: ['compass']
                options:
                    spawn: false
            coffee:
                files: ['./src/*.coffee', './example/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: false

        connect:
            server:
                options:
                    protocol: 'http'
                    hostname: '*'
                    port: 8000
                    base: '.'

        karma:
            ng1_0:
                configFile: './test/karma-ng1.0.config.coffee'

    # -----------------------------------
    # register task
    # -----------------------------------
    grunt.registerTask 'dev', ['connect', 'watch']
    grunt.registerTask 'test', ['karma']

    # -----------------------------------
    # Plugins
    # -----------------------------------
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-karma'