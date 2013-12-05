(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components', 'validator.rules']);

  a.controller('BuilderController', function($scope, $builder) {
    $builder.addFormObject('default', {
      component: 'textInput',
      label: 'Name',
      description: 'Your name',
      placeholder: 'Your name',
      required: true,
      editable: false
    });
    return $scope.form = $builder.forms['default'];
  });

  a.controller('FormController', function($scope, $validator) {
    $scope.input = [];
    return $scope.submit = function() {
      var v;
      v = $validator.validate($scope, 'default');
      v.success(function() {
        return console.log('success');
      });
      return v.error(function() {
        return console.log('error');
      });
    };
  });

}).call(this);
