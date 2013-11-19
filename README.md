#angular-form-builder [![Build Status](https://secure.travis-ci.org/kelp404/angular-form-builder.png?branch=master)](http://travis-ci.org/kelp404/angular-form-builder) [![devDependency Status](https://david-dm.org/kelp404/angular-form-builder/dev-status.png?branch=master)](https://david-dm.org/kelp404/angular-form-builder#info=devDependencies&view=table)

[MIT License](http://www.opensource.org/licenses/mit-license.php)


This is an AngularJS form builder written in [CoffeeScript](http://coffeescript.org).




##Frameworks
1. [AngularJS](http://angularjs.org/) 1.2.1
2. [jQuery](http://jquery.com/) 1.10.2, 2.0.3
3. [Bootstrap 3](http://getbootstrap.com/)
4. [angular-validator](https://github.com/kelp404/angular-validator)




##$builder
```coffee
# just $builder
angular.module 'yourApp', ['builder']

# include $builder and default components
angular.module 'yourApp', ['builder', 'builder.components']
```

####registerComponent
>
```coffee
# .config
$builderProvider.registerComponent = (name, component={}) ->
    ###
    Register the component for form-builder.
    @param name: The component name.
    @params component:
        group: The component group.
        label: The label of the input.
        description: The description of the input.
        placeholder: The placeholder of the input.
        required: yes / no
        validation: angular-validator
        errorMessage: validator error message
        options: []
        arrayToText: yes / no (checkbox could use this to convert input
        template: html template
        popoverTemplate: html template
    ###
# .run
$builder.registerComponent = (name, component={}) ->
```




##Unit Test
>
```bash
$ grunt test
```




##Development
```bash
# install node modules
$ npm install
```
```bash
# run the local server and the file watcher to compile CoffeeScript
$ grunt dev
```




###[Closure Compiler](https://code.google.com/p/closure-compiler/)
You could download compiler form [Google Code](https://code.google.com/p/closure-compiler/wiki/BinaryDownloads?tm=2).

**[External Tools](http://www.jetbrains.com/pycharm/webhelp/external-tools.html):**

Settings  |  value
:---------:|:---------:
Program | java
Parameters | -jar /Volumes/Data/tools/closure-compiler/compiler.jar --compilation_level SIMPLE_OPTIMIZATIONS --js $FileName$ --js_output_file $FileNameWithoutExtension$.min.$FileExt$
Working directory | $FileDir$
