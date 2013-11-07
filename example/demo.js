(function() {
  var a;

  a = angular.module('app', ['builder']);

  a.run(function($builder) {});

  a.controller('BuilderController', function($scope, $builder) {
    return $scope.form = [];
  });

}).call(this);
