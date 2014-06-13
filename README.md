#angular-form-builder [![Build Status](https://secure.travis-ci.org/kelp404/angular-form-builder.png?branch=master)](http://travis-ci.org/kelp404/angular-form-builder) [![devDependency Status](https://david-dm.org/kelp404/angular-form-builder/dev-status.png?branch=master)](https://david-dm.org/kelp404/angular-form-builder#info=devDependencies&view=table)

[MIT License](http://www.opensource.org/licenses/mit-license.php)


This is an AngularJS form builder written in [CoffeeScript](http://coffeescript.org).




##Frameworks
1. [AngularJS](http://angularjs.org/) 1.2.18
2. [jQuery](http://jquery.com/) 2.1.0
3. [Bootstrap 3](http://getbootstrap.com/)
4. [angular-validator](https://github.com/kelp404/angular-validator)




##$builder
```coffee
# just $builder
angular.module 'yourApp', ['builder']

# include $builder and default components
angular.module 'yourApp', ['builder', 'builder.components']
```


####components
>
```coffee
###
All components.
###
$builder.components =
    componentName{string}: component{object}
```


####groups
>
```coffee
###
All groups of components.
###
$builder.groups = [componentGroup{string}]
```


####registerComponent
>
```coffee
# .config
$builderProvider.registerComponent = (name, component={}) ->
    ###
    Register the component for form-builder.
    @param name: The component name.
    @param component: The component object.
        group: {string} The component group.
        label: {string} The label of the input.
        description: {string} The description of the input.
        placeholder: {string} The placeholder of the input.
        editable: {bool} Is the form object editable?
        required: {bool} Is the form object required?
        validation: {string} angular-validator. "/regex/" or "[rule1, rule2]". (default is '/.*/')
        validationOptions: {array} [{rule: angular-validator, label: 'option label'}] the options for the validation. (default is [])
        options: {array} The input options.
        arrayToText: {bool} checkbox could use this to convert input (default is no)
        template: {string} html template
        templateUrl: {string} The url of the template.
        popoverTemplate: {string} html template
        popoverTemplateUrl: {string} The url of the popover template.
    ###
# .run
$builder.registerComponent = (name, component={}) ->
```

>component.template
```html
<div class="form-group">
    <label for="{{name+index}}" class="col-md-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
    <div class="col-md-8">
        <input type="text" ng-model="inputText" validator-required="{{required}}" id="{{name+index}}" class="form-control" placeholder="{{placeholder}}"/>
        <p class='help-block'>{{description}}</p>
    </div>
</div>
```

>component.popoverTemplate
```html
<form>
    <div class="form-group">
        <label class='control-label'>Label</label>
        <input type='text' ng-model="label" validator="[required]" class='form-control'/>
    </div>
    <div class="form-group">
        <label class='control-label'>Description</label>
        <input type='text' ng-model="description" class='form-control'/>
    </div>
    <div class="form-group">
        <label class='control-label'>Placeholder</label>
        <input type='text' ng-model="placeholder" class='form-control'/>
    </div>
    <div class="checkbox">
        <label>
            <input type='checkbox' ng-model="required" />
            Required</label>
    </div>
    <div class="form-group" ng-if="validationOptions.length > 0">
        <label class='control-label'>Validation</label>
        <select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
    </div>
    <hr/>
    <div class='form-group'>
        <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
        <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
        <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
    </div>
</form>
```


####forms
>
```coffee
###
builder mode: `fb-builder` you could drag and drop to build the form.
form mode: `fb-form` this is the form for end-user to input value.
Default is {default: []}
###
$builder.forms =
    formName{string}: formObjects{array}
```


####insertFormObject
>
```coffee
$builder.insertFormObject = (name, index, formObject={}) =>
    ###
    Insert the form object into the form at {index}.
    @param name: The form name.
    @param index: The form object index.
    @param form: The form object.
        id: {int} The form object id. It will be generate by $builder if not asigned.
        component: {string} The component name
        editable: {bool} Is the form object editable? (default is yes)
        label: {string} The form object label.
        description: {string} The form object description.
        placeholder: {string} The form object placeholder.
        options: {array} The form object options.
        required: {bool} Is the form object required? (default is no)
        validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
        [index]: {int} The form object index. It will be generated by $builder.
    @return: The form object.
    ###
```

####addFormObject
>
```coffee
$builder.addFormObject = (name, formObject={}) =>
    ###
    Insert the form object into the form at last.
    reference $builder.insertFormObject()
    ###
```

####removeFormObject
>
```coffee
$builder.removeFormObject = (name, index) =>
    ###
    Remove the form object by the index.
    @param name: {string} The form name.
    @param index: {int} The form object index.
    ###
```




##builder.directive
####fb-components
>
```coffee
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller', 'builder.drag', 'validator']
fbComponents = ->
    ###
    You could use `fb-components` to render the components view.
    ###
    restrict: 'A'
    template:
        """
        <ul ng-if="groups.length > 1" class="nav nav-tabs nav-justified">
            <li ng-repeat="group in groups" ng-class="{active:activeGroup==group}">
                <a href='#' ng-click="selectGroup($event, group)">{{group}}</a>
            </li>
        </ul>
        <div class='form-horizontal'>
            <div class='fb-component' ng-repeat="component in components"
                fb-component="component"></div>
        </div>
        """
    controller: 'fbComponentsController'
a.directive 'fbComponents', fbComponents
```

>
```html
<div fb-components></div>
```


####fb-builder
>
```coffee
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller', 'builder.drag', 'validator']
fbBuilder = ($injector) ->
    ###
    You could use `fb-builder="formName"` to render the builder view.
    ###
    restrict: 'A'
    template:
        """
        <div class='form-horizontal'>
            <div class='fb-form-object-editable' ng-repeat="object in formObjects"
                fb-form-object-editable="object"></div>
        </div>
        """
    link: (scope, element, attrs) ->
fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder
```

>
```html
<div fb-builder="default"></div>
```


####fb-form
>
```coffee
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller', 'builder.drag', 'validator']
fbForm = ($injector) ->
    ###
    You could use `fb-form="formName"` to render the form view for end-users.
    ###
    restrict: 'A'
    require: 'ngModel'  # form data (end-user input value)
    scope:
        # input model for scops in ng-repeat
        input: '=ngModel'
    template:
        """
        <div class='fb-form-object' ng-repeat="object in form" fb-form-object="object">
        </div>
        """
    controller: 'fbFormController'
    link: (scope, element, attrs) ->
fbForm.$inject = ['$injector']
a.directive 'fbForm', fbForm
```

>
```html
<form class="form-horizontal">
    <div ng-model="input" fb-form="default" fb-default="defaultValue"></div>
    <div class="form-group">
        <div class="col-md-8 col-md-offset-4">
            <input type="submit" ng-click="submit()" class="btn btn-default"/>
        </div>
    </div>
</form>
```




##builder.components
> There are some default components at this module. This module is not required.
+ textInput
+ textArea
+ checkbox
+ radio
+ select




##Unit Test
>
```bash
$ grunt test
```




##Development
```bash
# install node modules
$ npm install
# install bower components
$ bower install
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
