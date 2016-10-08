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
      var button, panel, radio;
      panel = $builder.addFormObject('default', {
        id: 'panel',
        component: 'panel',
        label: 'Mental Disorders',
        style: 'primary'
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you wished you were dead or wished you could go to sleep and not wake up?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you actually had any thoughts of killing yourself?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you been thinking about how you might kill yourself?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you had these thoughts and had some intention of acting on them?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you started to work out or worked out the details of how to kill yourself and do you intend to carry out this plan?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Have you done anything, started to do anything, or prepared to do anything to end your life?',
        description: '',
        options: ['Yes', 'No']
      });
      button = $builder.addFormObject('default', {
        id: 'button',
        component: 'button',
        label: 'Apply',
        style: 'primary'
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
