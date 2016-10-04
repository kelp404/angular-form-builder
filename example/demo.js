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
      return $builder.registerComponent('name', {
        group: 'Default',
        label: 'Name',
        required: false,
        arrayToText: true,
        template: "<div class=\"form-group\">\n    <label for=\"{{formName+index}}\" class=\"col-md-4 control-label\" ng-class=\"{'fb-required':required}\">{{label}}</label>\n    <div class=\"col-md-8\">\n        <input type='hidden' ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\"/>\n        <div class=\"col-sm-6\" style=\"padding-left: 0;\">\n            <input type=\"text\"\n                ng-model=\"inputArray[0]\"\n                class=\"form-control\" id=\"{{formName+index}}-0\"/>\n            <p class='help-block'>First name</p>\n        </div>\n        <div class=\"col-sm-6\" style=\"padding-left: 0;\">\n            <input type=\"text\"\n                ng-model=\"inputArray[1]\"\n                class=\"form-control\" id=\"{{formName+index}}-1\"/>\n            <p class='help-block'>Last name</p>\n        </div>\n    </div>\n</div>",
        popoverTemplate: "<form>\n    <div class=\"form-group\">\n        <label class='control-label'>Label</label>\n        <input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n    </div>\n    <div class=\"checkbox\">\n        <label>\n            <input type='checkbox' ng-model=\"required\" />\n            Required\n        </label>\n    </div>\n\n    <hr/>\n    <div class='form-group'>\n        <input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n        <input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n        <input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n    </div>\n</form>"
      });
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      var button, divider, radio0, radio1, radio2, radio3;
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Building elevation A'
      });
      radio0 = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign can?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio1 = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio2 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Building elevation B'
      });
      radio0 = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign can?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio1 = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio2 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Building elevation C'
      });
      radio0 = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign can?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio1 = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio2 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Building elevation D'
      });
      radio0 = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign can?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio1 = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio2 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Site signage'
      });
      radio0 = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign support?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio1 = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio3 = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });
      button = $builder.addFormObject('default', {
        id: 'button',
        component: 'button',
        label: 'ADD A SIGN',
        description: 'primary'
      });
      $scope.form = $builder.forms['default'];
      $scope.input = [];
      $scope.defaultValue = {};
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
