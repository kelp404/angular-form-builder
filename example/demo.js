(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components']);

  a.controller('BuilderController', function($scope, $builder) {
    return $builder.addFormGroup('form', {
      label: 'label'
    });
  });

}).call(this);
