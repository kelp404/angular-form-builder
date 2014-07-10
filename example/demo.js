(function() {
  angular.module('app', ['builder', 'builder.components', 'validator.rules']).run([
    '$builder', function($builder) {
      $builder.registerComponent('sampleInput', {
        group: 'from html',
        label: 'Sample',
        description: 'From html template',
        placeholder: 'placeholder',
        required: false,
        validationOptions: [
          {
            label: 'none',
            rule: '/.*/'
          }, {
            label: 'number',
            rule: '[number]'
          }, {
            label: 'email',
            rule: '[email]'
          }, {
            label: 'url',
            rule: '[url]'
          }
        ],
        templateUrl: 'example/template.html',
        popoverTemplateUrl: 'example/popoverTemplate.html'
      });
      return $builder.addComponent('gender', 'radio', {
        group: 'add component',
        label: 'gender',
        description: 'your gender',
        options: ['male', 'female', 'others']
      });
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      var checkbox, textbox;
      textbox = $builder.addFormObject('default', {
        id: 'textbox',
        component: 'textInput',
        label: 'Name',
        description: 'Your name',
        placeholder: 'Your name',
        required: true,
        editable: false
      });
      checkbox = $builder.addFormObject('default', {
        id: 'checkbox',
        component: 'checkbox',
        label: 'Pets',
        description: 'Do you have any pets?',
        options: ['Dog', 'Cat']
      });
      $builder.addFormObject('default', {
        component: 'sampleInput'
      });
      $scope.form = $builder.forms['default'];
      $scope.input = [];
      $scope.defaultValue = {};
      $scope.defaultValue[textbox.id] = 'default value';
      $scope.defaultValue[checkbox.id] = [true, true];
      return $scope.submit = function() {
        return $validator.validate($scope, 'default').success(function() {
          return console.log('success');
        }).error(function() {
          return console.log('error');
        });
      };
    }
  ]);

}).call(this);
