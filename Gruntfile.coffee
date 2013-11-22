module.exports = (grunt) ->
    # -----------------------------------
    # Options
    # -----------------------------------
    grunt.config.init
        compass:
            example:
                options:
                    sassDir: './example'
                    cssDir: './example'
                    outputStyle: 'compressed'
            src:
                options:
                    sassDir: './src'
                    cssDir: './dist'
                    outputStyle: 'compressed'

        coffee:
            source:
                files:
                    './dist/angular-form-builder.js': ['./src/*.coffee']
            components:
                files:
                    './dist/angular-form-builder-components.js': ['./components/*.coffee']
            demo:
                files:
                    './example/demo.js': './example/demo.coffee'

        watch:
            compass:
                files: ['./example/*.scss', './src/*.scss']
                tasks: ['compass']
                options:
                    spawn: no
            coffee:
                files: ['./src/*.coffee', './components/*.coffee', './example/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: no

        connect:
            server:
                options:
                    protocol: 'http'
                    hostname: '*'
                    port: 8000
                    base: '.'

        karma:
            min:
                configFile: './test/karma-min.config.coffee'
            ng12_jq1:
                configFile: './test/karma-ng1.2-jq1.config.coffee'
            ng12_jq2:
                configFile: './test/karma-ng1.2-jq2.config.coffee'

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