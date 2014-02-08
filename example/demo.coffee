angular.module 'app', ['builder', 'builder.components', 'validator.rules']

.controller 'DemoController', ($scope, $builder, $validator) ->
    # ----------------------------------------
    # builder
    # ----------------------------------------
    textbox = $builder.addFormObject 'default',
        component: 'textInput'
        label: 'Name'
        description: 'Your name'
        placeholder: 'Your name'
        required: yes
        editable: no
    checkbox = $builder.addFormObject 'default',
        component: 'checkbox'
        label: 'Pets'
        description: 'Do you have any pets?'
        options: ['Dog', 'Cat']
    # formObjects
    $scope.form = $builder.forms['default']

    # ----------------------------------------
    # form
    # ----------------------------------------
    # user input value
    $scope.input = []
    $scope.defaultValue = {}
    # formObjectId: default value
    $scope.defaultValue[textbox.id] = 'default value'
    $scope.defaultValue[checkbox.id] = [yes, yes]

    $scope.submit = ->
        $validator.validate $scope, 'default'
        .success -> console.log 'success'
        .error -> console.log 'error'
