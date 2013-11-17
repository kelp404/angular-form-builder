
a = angular.module 'app', ['builder', 'builder.components']

a.controller 'BuilderController', ($scope, $builder) ->
    $builder.addFormObject 'default',
        component: 'textInput'
        label: 'Name'
        description: 'Your name'
        placeholder: 'Your name'
        required: yes
        draggable: no
    # formObjects
    $scope.form = $builder.forms['default']

a.controller 'FormController', ($scope, $validator) ->
    # user input value
    $scope.input = []

    $scope.submit = ->
        v = $validator.validate $scope
        v.success -> console.log 'success'
        v.error -> console.log 'error'
