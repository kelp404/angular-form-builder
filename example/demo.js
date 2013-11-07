(function() {
  var a;

  a = angular.module('app', ['builder']);

  a.run(function($builder) {});

  a.controller('BuilderController', function($scope, $builder) {
    $builder.registerComponent('name', null);
    return $scope.form = [];
  });

}).call(this);
