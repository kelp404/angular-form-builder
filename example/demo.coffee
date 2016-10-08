angular.module 'app', ['builder', 'builder.components', 'validator.rules']

.run ['$builder', ($builder) ->
	$builder.registerComponent 'sampleInput',
		group: 'from html'
		label: 'Sample'
		description: 'From html template'
		placeholder: 'placeholder'
		required: no
		validationOptions: [
			{label: 'none', rule: '/.*/'}
			{label: 'number', rule: '[number]'}
			{label: 'email', rule: '[email]'}
			{label: 'url', rule: '[url]'}
		]
		templateUrl: 'example/template.html'
		popoverTemplateUrl: 'example/popoverTemplate.html'

	# ----------------------------------------
	# two text input
	# ----------------------------------------
	$builder.registerComponent 'name',
		group: 'Default'
		label: 'Name'
		required: no
		arrayToText: yes
		template:
			"""
      <div class="form-group">
          <label for="{{formName+index}}" class="col-md-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
          <div class="col-md-8">
              <input type='hidden' ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}"/>
              <div class="col-sm-6" style="padding-left: 0;">
                  <input type="text"
                      ng-model="inputArray[0]"
                      class="form-control" id="{{formName+index}}-0"/>
                  <p class='help-block'>First name</p>
              </div>
              <div class="col-sm-6" style="padding-left: 0;">
                  <input type="text"
                      ng-model="inputArray[1]"
                      class="form-control" id="{{formName+index}}-1"/>
                  <p class='help-block'>Last name</p>
              </div>
          </div>
      </div>
      """
		popoverTemplate:
			"""
      <form>
          <div class="form-group">
              <label class='control-label'>Label</label>
              <input type='text' ng-model="label" validator="[required]" class='form-control'/>
          </div>
          <div class="checkbox">
              <label>
                  <input type='checkbox' ng-model="required" />
                  Required
              </label>
          </div>

          <hr/>
          <div class='form-group'>
              <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
              <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
              <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
          </div>
      </form>
      """
]


.controller 'DemoController', ['$scope', '$builder', '$validator', ($scope, $builder, $validator) ->
# ----------------------------------------
# builder
# ----------------------------------------

#	textbox = $builder.addFormObject 'default',
#		id: 'textbox'
#		component: 'textInput'
#		label: 'Name'
#		description: 'Your name'
#		placeholder: 'Your name'
#		required: yes
#   editable: no


	panel = $builder.addFormObject 'default',
		id: 'panel'
		component: 'panel'
		label: 'Mental Disorders'
		style: 'primary'

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you wished you were dead or wished you could go to sleep and not wake up?'
		description: ''
		options: ['Yes', 'No']

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you actually had any thoughts of killing yourself?'
		description: ''
		options: ['Yes', 'No']

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you been thinking about how you might kill yourself?'
		description: ''
		options: ['Yes', 'No']

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you had these thoughts and had some intention of acting on them?'
		description: ''
		options: ['Yes', 'No']

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you started to work out or worked out the details of how to kill yourself and do you intend to carry out this plan?'
		description: ''
		options: ['Yes', 'No']

	radio = $builder.addFormObject 'default',
		id: 'radio2'
		component: 'radio'
		inline: yes
		label: 'Have you done anything, started to do anything, or prepared to do anything to end your life?'
		description: ''
		options: ['Yes', 'No']

	button = $builder.addFormObject 'default',
		id: 'button'
		component: 'button'
		label: 'Apply'
		style: 'primary'


	#    $builder.addFormObject 'default',
	#        component: 'sampleInput'
	# formObjects
	$scope.form = $builder.forms['default']

	# ----------------------------------------
	# form
	# ----------------------------------------
	# user input value
	$scope.input = []
	$scope.defaultValue = {}
	# formObjectId: default value
#	$scope.defaultValue[textbox.id] = 'default value'
#	$scope.defaultValue[checkbox.id] = [yes, yes]

	$scope.submit = ->
		$validator.validate $scope, 'default'
		.success -> console.log 'success'
		.error -> console.log 'error'
]