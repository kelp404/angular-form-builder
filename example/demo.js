(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components']);

  a.controller('BuilderController', function($scope, $builder) {
    $builder.addFormObject('default', {
      component: 'textInput',
      label: 'label A',
      description: 'your description'
    });
    $builder.addFormObject('default', {
      component: 'textInput',
      label: 'label B',
      description: 'your description'
    });
    return $scope.form = $builder.forms['default'];
  });

}).call(this);
