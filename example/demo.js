(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components']);

  a.run(function($builder) {
    return $builder.registerComponent('name', null);
  });

  a.controller('BuilderController', function($scope, $builder) {});

}).call(this);
