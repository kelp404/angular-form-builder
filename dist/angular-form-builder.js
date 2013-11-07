(function() {
  var a, fbBuilder;

  a = angular.module('builder.directive', ['builder.provider']);

  fbBuilder = function($injector) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        var $parse, model, name;
        $parse = $injector.get('$parse');
        model = $parse(attrs.ngModel);
        return name = attrs.fbBuilder;
      }
    };
  };

  fbBuilder.$inject = ['$injector'];

  a.directive('fbBuilder', fbBuilder);

  a.directive('fbComponents', function() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {}
    };
  });

  a.directive('fbForm', function() {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        var name;
        return name = attrs.fbForm;
      }
    };
  });

}).call(this);

(function() {
  angular.module('builder', ['builder.provider', 'builder.directive', 'validator', 'validator.rules']);

}).call(this);

(function() {
  var a;

  a = angular.module('builder.provider', []);

  a.provider('$builder', function() {
    var $injector,
      _this = this;
    $injector = null;
    this.components = {};
    this.builders = {};
    this.setupProviders = function(injector) {
      return $injector = injector;
    };
    this.convertComponent = function(name, component) {
      var result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
      result = {
        name: name,
        label: (_ref = component.label) != null ? _ref : '',
        description: (_ref1 = component.description) != null ? _ref1 : '',
        placeholder: (_ref2 = component.placeholder) != null ? _ref2 : '',
        required: (_ref3 = component.required) != null ? _ref3 : false,
        validation: (_ref4 = component.validation) != null ? _ref4 : /.*/,
        template: (_ref5 = component.template) != null ? _ref5 : "<div class=\"form-group\">\n    <label for=\"{{name}}\" class=\"col-md-2 control-label\" ng-bind=\"label\"></label>\n    <div class=\"col-md-10\">\n        <input type=\"text\" validator=\"{{validation}}\" ng-model=\"input\" class=\"form-control\" id=\"{{name}}\" placeholder=\"{{placeholder}}\"/>\n    </div>\n</div>"
      };
      return result;
    };
    this.registerComponent = function(name, component) {
      if (component == null) {
        component = {};
      }
      /*
      Register the component for form-builder.
      @param name: The component name.
      @param component: The component object.
      */

      return _this.components[name] = _this.convertComponent(name, component);
    };
    this.loadBuilder = function(name, object) {
      if (object == null) {
        return object = [];
      }
      /*
      Load the form information into the builder which name is `name`.
      @param name: The builder name.
      @param object: The form information.
      */

    };
    this.get = function($injector) {
      this.setupProviders($injector);
      this.builders[''] = [];
      return {
        components: this.components,
        builders: this.builder,
        registerComponent: this.registerComponent,
        loadBuilder: this.loadBuilder
      };
    };
    this.get.$inject = ['$injector'];
    return this.$get = this.get;
  });

}).call(this);
