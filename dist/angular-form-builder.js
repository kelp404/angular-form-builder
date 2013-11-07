(function() {
  var a;

  a = angular.module('builder.directive', ['builder.provider']);

  a.directive('fbBuilder', function() {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {}
    };
  });

  a.directive('fbComponents', function() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {}
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
    var $injector;
    $injector = null;
    this.components = {};
    this.setupProviders = function(injector) {
      return $injector = injector;
    };
    this.addComponent = function(name, component) {
      if (component == null) {
        component = {};
      }
    };
    this.get = function($injector) {
      this.setupProviders($injector);
      return {
        addComponent: this.addComponent
      };
    };
    this.get.$inject = ['$injector'];
    return this.$get = this.get;
  });

}).call(this);
