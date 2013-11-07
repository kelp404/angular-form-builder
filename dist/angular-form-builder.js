(function() {
  var a;

  a = angular.module('builder.directive', ['builder.provider']);

  a.directive('fbBuilder', function() {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        var name;
        return name = attrs.fbBuilder;
      }
    };
  });

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
  angular.module('builder', ['builder.provider', 'builder.directive']);

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
      var result, _ref, _ref1, _ref2, _ref3, _ref4;
      result = {
        name: name,
        label: (_ref = component.label) != null ? _ref : '',
        description: (_ref1 = component.description) != null ? _ref1 : '',
        placeholder: (_ref2 = component.placeholder) != null ? _ref2 : '',
        required: (_ref3 = component.required) != null ? _ref3 : false,
        template: (_ref4 = component.template) != null ? _ref4 : ""
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
