angular.module 'app', ['builder', 'builder.components', 'validator.rules']

.run ['$builder', ($builder) ->
    $builder.registerComponent 'sampleInput',
        group: 'from html'
        label: 'Sample'
        description: 'From html template'
        placeholder: 'placeholder'
        required: no
        validationOptions: [
            {label: 'none', rule: '/.*/'}
            {label: 'number', rule: '[number]'}
            {label: 'email', rule: '[email]'}
            {label: 'url', rule: '[url]'}
        ]
        templateUrl: 'example/template.html'
        popoverTemplateUrl: 'example/popoverTemplate.html'
]


.controller 'DemoController', ['$scope', '$builder', '$validator', ($scope, $builder, $validator) ->
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
    $builder.addFormObject 'default',
        component: 'sampleInput'
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
]