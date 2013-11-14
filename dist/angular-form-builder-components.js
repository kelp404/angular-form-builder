(function() {
  var a, config;

  a = angular.module('builder.components', ['builder']);

  config = function($builderProvider) {
    return $builderProvider.registerComponent('textInput', {
      group: 'Default',
      label: 'Text Input',
      description: 'description',
      placeholder: 'placeholder',
      required: false,
      template: "<div class=\"form-group\">\n    <label for=\"{{name+label}}\" class=\"col-md-4 control-label\">{{label}}</label>\n    <div class=\"col-md-8\">\n        <input type=\"text\" id=\"{{name+label}}\" class=\"form-control\" placeholder=\"{{placeholder}}\"/>\n        <p class='help-block'>{{description}}</p>\n    </div>\n</div>",
      popoverTemplate: "<form>\n    <div class=\"form-group\">\n        <label class='control-label col-md-10'>Label</label>\n        <div class=\"col-md-10\">\n            <input type='text' ng-model=\"label\" validator=\"[required]\" class='form-control'/>\n        </div>\n    </div>\n    <div class=\"form-group\">\n        <label class='control-label col-md-10'>Description</label>\n        <div class=\"col-md-10\">\n            <input type='text' ng-model=\"description\" class='form-control'/>\n        </div>\n    </div>\n    <div class=\"form-group\">\n        <label class='control-label col-md-10'>Placeholder</label>\n        <div class=\"col-md-10\">\n            <input type='text' ng-model=\"placeholder\" class='form-control'/>\n        </div>\n    </div>\n    <div class=\"form-group\">\n        <div class=\"col-md-10\">\n            <label class='control-label col-md-10'>\n            <input type='checkbox' ng-model=\"required\" />\n            Required</label>\n        </div>\n    </div>\n\n    <hr/>\n    <div class='form-group'>\n        <div class=\"col-md-10\">\n            <input type='submit' ng-click=\"popover.save($event)\" class='btn btn-primary' value='Save'/>\n            <input type='button' ng-click=\"popover.cancel($event)\" class='btn btn-default' value='Cancel'/>\n            <input type='button' ng-click=\"popover.remove($event)\" class='btn btn-danger' value='Delete'/>\n        </div>\n    </div>\n</form>"
    });
  };

  config.$inject = ['$builderProvider'];

  a.config(config);

}).call(this);
