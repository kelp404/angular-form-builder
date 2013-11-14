
a = angular.module 'app', ['builder', 'builder.components']

a.controller 'BuilderController', ($scope, $builder) ->
    $builder.addFormObject 'default',
        component: 'textInput'
        label: 'label A'
        description: 'your description'
    $builder.addFormObject 'default',
        component: 'textInput'
        label: 'label B'
        description: 'your description'
    $scope.form = $builder.forms['default']
