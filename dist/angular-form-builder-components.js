(function() {
  var Global;

  Global = this;

  !Global.__fbComponents && (Global.__fbComponents = {});

  Global.__fbComponents.button = function($builderProvider) {
    return $builderProvider.registerComponent('button', {
      group: 'Additinal',
      label: 'Button',
      style: 'default',
      options: ['default', 'primary', 'success', 'warning', 'danger'],
      arrayToText: true,
      template: "<p></p>\n		<button type=\"button\" class=\"btn btn-{{style}}\">{{label}}</button>\n<p></p>",
      popoverTemplate: "<form>\n	<div class=\"form-group\">\n		<label class='control-label'>Label</label>\n		<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n	</div>\n		<div class=\"form-group\">\n			<label class='control-label'>Style</label>\n						<select ng-options=\"value for value in options\" id=\"{{formName+index}}\" class=\"form-control\"\n								ng-model=\"style\" ng-init=\"style = options[0]\"/>\n				</div>\n\n		          <hr/>\n		          <div class='form-group'>\n		              <input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n		              <input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n		              <input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		          </div>\n		      </form>"
    });
  };

}).call(this);

(function() {
  var Global, components, config;

  Global = this;

  !Global.__fbComponents && (Global.__fbComponents = {});

  Global.__fbComponents.divider = function($builderProvider) {
    return $builderProvider.registerComponent('divider', {
      group: 'Default',
      label: 'Divider',
      template: "<div class=\"panel panel-default\">\n		<div class=\"panel-body\">\n				{{label}}\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
  };

  Global.__fbComponents["default"] = function($builderProvider) {
    $builderProvider.registerComponent('textInput', {
      group: 'Default',
      label: 'Text Input',
      description: 'description',
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
      template: "<div class=\"form-group\">\n		<label for=\"{{formName+index}}\" class=\"col-sm-4 control-label\" ng-class=\"{'fb-required':required}\">{{label}}</label>\n		<div class=\"col-sm-8\">\n				<input type=\"text\" ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\" id=\"{{formName+index}}\" class=\"form-control\" placeholder=\"{{placeholder}}\"/>\n				<p class='help-block'>{{description}}</p>\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Description</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Placeholder</label>\n				<input type='text' ng-model=\"placeholder\" class='form-control'/>\n		</div>\n		<div class=\"checkbox\">\n				<label>\n						<input type='checkbox' ng-model=\"required\" />\n						Required</label>\n		</div>\n		<div class=\"form-group\" ng-if=\"validationOptions.length > 0\">\n				<label class='control-label'>Validation</label>\n				<select ng-model=\"$parent.validation\" class='form-control' ng-options=\"option.rule as option.label for option in validationOptions\"></select>\n		</div>\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
    $builderProvider.registerComponent('textArea', {
      group: 'Default',
      label: 'Text Area',
      description: 'description',
      placeholder: 'placeholder',
      required: false,
      template: "<div class=\"form-group\">\n		<label for=\"{{formName+index}}\" class=\"col-sm-4 control-label\" ng-class=\"{'fb-required':required}\">{{label}}</label>\n		<div class=\"col-sm-8\">\n				<textarea type=\"text\" ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\" id=\"{{formName+index}}\" class=\"form-control\" rows='6' placeholder=\"{{placeholder}}\"/>\n				<p class='help-block'>{{description}}</p>\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Description</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Placeholder</label>\n				<input type='text' ng-model=\"placeholder\" class='form-control'/>\n		</div>\n		<div class=\"checkbox\">\n				<label>\n						<input type='checkbox' ng-model=\"required\" />\n						Required</label>\n		</div>\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
    $builderProvider.registerComponent('checkbox', {
      group: 'Default',
      label: 'Checkbox',
      description: 'description',
      placeholder: 'placeholder',
      required: false,
      options: ['value one', 'value two'],
      arrayToText: true,
      template: "<div class=\"form-group\">\n		<label for=\"{{formName+index}}\" class=\"col-sm-4 control-label\" ng-class=\"{'fb-required':required}\">{{label}}</label>\n		<div class=\"col-sm-8\">\n				<input type='hidden' ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\"/>\n				<div class='checkbox' ng-repeat=\"item in options track by $index\">\n						<label><input type='checkbox' ng-model=\"$parent.inputArray[$index]\" value='item'/>\n								{{item}}\n						</label>\n				</div>\n				<p class='help-block'>{{description}}</p>\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Description</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Options</label>\n				<textarea class=\"form-control\" rows=\"3\" ng-model=\"optionsText\"/>\n		</div>\n		<div class=\"checkbox\">\n				<label>\n						<input type='checkbox' ng-model=\"required\" />\n						Required\n				</label>\n		</div>\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
    $builderProvider.registerComponent('radio', {
      group: 'Default',
      label: 'Radio',
      description: 'description',
      placeholder: 'placeholder',
      required: false,
      inline: false,
      options: ['value one', 'value two'],
      template: "<div class=\"form-group\">\n		<label for=\"{{formName+index}}\" class=\"col-sm-4 control-label\" ng-class=\"{'fb-required':required}\">{{label}}</label>\n		<div class=\"col-sm-8\">\n				<div class='radio' ng-repeat=\"item in options track by $index\" ng-class=\"{'radio-inline':inline}\">\n						<label><input name='{{formName+index}}' ng-model=\"$parent.inputText\" validator-group=\"{{formName}}\" value='{{item}}' type='radio'/>\n								{{item}}\n						</label>\n				</div>\n				<p class='help-block'>{{description}}</p>\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Description</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Options</label>\n				<textarea class=\"form-control\" rows=\"3\" ng-model=\"optionsText\"/>\n		</div>\n		<div class=\"checkbox\">\n				<label>\n						<input type='checkbox' ng-model=\"inline\" />\n						radio-inline\n				</label>\n		</div>\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
    $builderProvider.registerComponent('select', {
      group: 'Default',
      label: 'Select',
      description: 'description',
      placeholder: 'placeholder',
      required: false,
      options: ['value one', 'value two'],
      template: "<div class=\"form-group\">\n		<label for=\"{{formName+index}}\" class=\"col-sm-4 control-label\">{{label}}</label>\n		<div class=\"col-sm-8\">\n				<select ng-options=\"value for value in options\" id=\"{{formName+index}}\" class=\"form-control\"\n						ng-model=\"inputText\" ng-init=\"inputText = options[0]\"/>\n				<p class='help-block'>{{description}}</p>\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Label</label>\n				<input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Description</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Options</label>\n				<textarea class=\"form-control\" rows=\"3\" ng-model=\"optionsText\"/>\n		</div>\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
    return $builderProvider.registerComponent('panel', {
      group: 'Default',
      label: 'Panel title',
      header: 'Panel title',
      description: 'Panel content',
      style: 'default',
      options: ['default', 'primary', 'success', 'warning', 'danger'],
      template: "<div class=\"panel panel-{{style}}\">\n		<div class=\"panel-heading\">\n				<h3 class=\"panel-title\">{{header}}</h3>\n	  </div>\n		<div class=\"panel-body\">\n			{{description}}\n		</div>\n</div>",
      popoverTemplate: "<form>\n		<div class=\"form-group\">\n				<label class='control-label'>Panel title</label>\n				<input type='text' ng-model=\"header\" validator=\"[required]\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n				<label class='control-label'>Panel content</label>\n				<input type='text' ng-model=\"description\" class='form-control'/>\n		</div>\n		<div class=\"form-group\">\n              <label class='control-label'>Style</label>\n				<select ng-options=\"value for value in options\" id=\"{{formName+index}}\" class=\"form-control\"\n						ng-model=\"style\" ng-init=\"style = options[0]\"/>\n		</div>\n\n\n		<hr/>\n		<div class='form-group'>\n				<input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n				<input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n				<input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n		</div>\n</form>"
    });
  };

  components = ['divider', 'default', 'button'];

  config = function($builderProvider) {
    var component, _results;
    _results = [];
    for (component in Global.__fbComponents) {
      console.log(component);
      Global.__fbComponents[component].$inject = ['$builderProvider'];
      _results.push(Global.__fbComponents[component]($builderProvider));
    }
    return _results;
  };

  angular.module('builder.components', ['builder', 'validator.rules']).config(config);

}).call(this);
