(function() {
  var a;

  a = angular.module('app', ['builder', 'builder.components']);

  a.controller('BuilderController', function($scope, $builder) {
    $builder.addFormGroup('form', {
      label: 'label'
    });
    return $scope.add = function() {
      return $builder.registerComponent('textInput AA', {
        group: 'AA',
        label: 'Text Input AA',
        description: 'description',
        placeholder: 'placeholder',
        required: false,
        template: "<div class=\"form-group\">\n    <label for=\"{{name+label}}\" class=\"col-md-4 control-label\">{{label}}</label>\n    <div class=\"col-md-8\">\n        <input type=\"text\" id=\"{{name+label}}\" class=\"form-control\" placeholder=\"{{placeholder}}\"/>\n    </div>\n</div>"
      });
    };
  });

}).call(this);
