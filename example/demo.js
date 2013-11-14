(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components']);

  a.controller('BuilderController', function($scope, $builder) {
    $builder.addFormObject('default', {
      component: 'textInput',
      label: 'Name',
      description: 'Your name',
      placeholder: 'Your name',
      required: true,
      draggable: false
    });
    return $scope.form = $builder.forms['default'];
  });

}).call(this);
