(function() {
  angular.module('app', ['builder', 'builder.components', 'validator.rules']).run([
    '$builder', function($builder) {
      return $builder.registerComponent('sampleInput', {
        group: 'Additional',
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
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      var json;
      $scope.pages = [];
      json = [
        {
          "id": "divider",
          "component": "divider",
          "editable": true,
          "index": 0,
          "label": "Building elevation A",
          "description": "",
          "placeholder": "",
          "options": [],
          "required": false,
          "inline": false,
          "validation": "/.*/",
          "text": "",
          "header": "",
          "footer": "",
          "align": [],
          "style": ""
        }, {
          "id": "radio0",
          "component": "radio",
          "editable": true,
          "index": 1,
          "label": "What is the condition of the sign can?",
          "description": "",
          "placeholder": "placeholder",
          "options": ["1", "2", "3", "4", "5"],
          "required": false,
          "inline": true,
          "validation": "/.*/",
          "text": "",
          "header": "",
          "footer": "",
          "align": [],
          "style": ""
        }, {
          "id": "radio1",
          "component": "radio",
          "editable": true,
          "index": 2,
          "label": "What is the condition of the sign face?",
          "description": "",
          "placeholder": "placeholder",
          "options": ["1", "2", "3", "4", "5"],
          "required": false,
          "inline": true,
          "validation": "/.*/",
          "text": "",
          "header": "",
          "footer": "",
          "align": [],
          "style": ""
        }, {
          "id": "radio2",
          "component": "radio",
          "editable": true,
          "index": 3,
          "label": "Observed while illumination on?",
          "description": "",
          "placeholder": "placeholder",
          "options": ["Yes", "No"],
          "required": false,
          "inline": true,
          "validation": "/.*/",
          "text": "",
          "header": "",
          "footer": "",
          "align": [],
          "style": ""
        }, {
          "id": "radio2",
          "component": "radio",
          "editable": true,
          "index": 4,
          "label": "If yes, were there any problems with illumination?",
          "description": "",
          "placeholder": "placeholder",
          "options": ["Yes", "No"],
          "required": false,
          "inline": true,
          "validation": "/.*/",
          "text": "",
          "header": "",
          "footer": "",
          "align": [],
          "style": ""
        }
      ];
      json.map((function(_this) {
        return function(component, index) {
          return $builder.addFormObject('default', component);
        };
      })(this));

      /*	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation B'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation C'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      
      
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation D'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Site signage'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign support?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      	button = $builder.addFormObject 'default',
      		id: 'button'
      		component: 'button'
      		label: 'ADD A SIGN'
      		description: 'primary'
       */
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
