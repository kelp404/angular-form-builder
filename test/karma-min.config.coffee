module.exports = (config) ->
    config.set
        # base path, that will be used to resolve files and exclude
        basePath: '../'

        frameworks: ['jasmine']

        # list of files / patterns to load in the browser
        files: [
            'bower_components/jquery/dist/jquery.min.js'
            'bower_components/angular/angular.min.js'
            'bower_components/angular-mocks/angular-mocks.js'
            'submodules/angular-validator/dist/angular-validator.js'
            'submodules/angular-validator/dist/angular-validator-rules.js'
            'dist/angular-form-builder.min.js'
            'dist/angular-form-builder-components.min.js'
            'test/specs/*.coffee'
        ]

        preprocessors:
            '**/*.coffee': 'coffee'

        # list of files to exclude
        exclude: []

        # use dots reporter, as travis terminal does not support escaping sequences
        # possible values: 'dots', 'progress'
        # CLI --reporters progress
        reporters: ['progress']

        # web server port
        # CLI --port 9876
        port: 8082

        # enable / disable colors in the output (reporters and logs)
        # CLI --colors --no-colors
        colors: yes

        # level of logging
        # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        # CLI --log-level debug
        logLevel: config.LOG_DEBUG

        # enable / disable watching file and executing tests whenever any file changes
        # CLI --auto-watch --no-auto-watch
        autoWatch: no

        # Start these browsers, currently available:
        # - Chrome
        # - ChromeCanary
        # - Firefox
        # - Opera
        # - Safari (only Mac)
        # - PhantomJS
        # - IE (only Windows)
        # CLI --browsers Chrome,Firefox,Safari
        browsers: ['PhantomJS']

        # If browser does not capture in given timeout [ms], kill it
        # CLI --capture-timeout 5000
        captureTimeout: 20000

        # Auto run tests on start (when browsers are captured) and exit
        # CLI --single-run --no-single-run
        singleRun: yes

        # report which specs are slower than 500ms
        # CLI --report-slower-than 500
        reportSlowerThan: 500
