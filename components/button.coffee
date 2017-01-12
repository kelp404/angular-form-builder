#angular.module 'builder.components', ['builder', 'validator.rules']

#.config ['$builderProvider', ($builderProvider) ->

Global = this

!Global.__fbComponents && (Global.__fbComponents = {})

Global.__fbComponents.button = ($builderProvider) ->

	# ----------------------------------------
	# Button
	# ----------------------------------------
	$builderProvider.registerComponent 'button',
		group: 'Additinal'
		label: 'Button'
		style: 'default'
#		description: 'default'
#				required: no
		options: ['default', 'primary', 'success', 'warning', 'danger']
		arrayToText: yes
		template:
			"""
			<p></p>
					<button type="button" class="btn btn-{{style}}">{{label}}</button>
			<p></p>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="form-group">
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="[required]" class='form-control'/>
				</div>
					<div class="form-group">
						<label class='control-label'>Style</label>
									<select ng-options="value for value in options" id="{{formName+index}}" class="form-control"
											ng-model="style" ng-init="style = options[0]"/>
							</div>

		          <hr/>
		          <div class='form-group'>
		              <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
		              <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
		              <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
		          </div>
		      </form>
		      """

#]

