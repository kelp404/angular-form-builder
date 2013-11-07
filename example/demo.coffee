
a = angular.module 'app', ['builder']

a.run ($builder) ->


a.controller 'BuilderController', ($scope, $builder) ->
    $builder.registerComponent 'name', null
    $scope.form = []
