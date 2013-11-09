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
      template: "<div class=\"form-group\">\n    <label for=\"{{name+label}}\" class=\"col-md-4 control-label\">{{label}}</label>\n    <div class=\"col-md-8\">\n        <input type=\"text\" id=\"{{name+label}}\" class=\"form-control\" placeholder=\"{{placeholder}}\"/>\n        <p class='help-block'>{{description}}</p>\n    </div>\n</div>"
    });
  };

  config.$inject = ['$builderProvider'];

  a.config(config);

}).call(this);
