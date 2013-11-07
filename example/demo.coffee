
a = angular.module 'app', ['builder', 'builder.components']

a.controller 'BuilderController', ($scope, $builder) ->
    $builder.addFormGroup 'form',
        label: 'label'
