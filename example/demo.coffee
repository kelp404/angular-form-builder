
a = angular.module 'app', ['builder', 'builder.components', 'validator.rules']

a.controller 'BuilderController', ($scope, $builder) ->
    $builder.addFormObject 'default',
        component: 'textInput'
        label: 'Name'
        description: 'Your name'
        placeholder: 'Your name'
        required: yes
        editable: no
    # formObjects
    $scope.form = $builder.forms['default']

a.controller 'FormController', ($scope, $validator) ->
    # user input value
    $scope.input = []

    $scope.submit = ->
        v = $validator.validate $scope, 'default'
        v.success -> console.log 'success'
        v.error -> console.log 'error'
