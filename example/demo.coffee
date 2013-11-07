
a = angular.module 'app', ['builder', 'builder.components']


a.run ($builder) ->
    $builder.registerComponent 'name', null


a.controller 'BuilderController', ($scope, $builder) ->

