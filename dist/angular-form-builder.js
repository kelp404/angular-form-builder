(function() {
  var a, fbComponentsController;

  a = angular.module('builder.controller', ['builder.provider']);

  fbComponentsController = function($scope, $injector) {
    var $builder, group, groups, _i, _len, _results;
    $builder = $injector.get('$builder');
    groups = $builder.getComponentGroups();
    $scope.components = {};
    _results = [];
    for (_i = 0, _len = groups.length; _i < _len; _i++) {
      group = groups[_i];
      _results.push($scope.components[group] = $builder.getComponentsByGroup(group));
    }
    return _results;
  };

  fbComponentsController.$inject = ['$scope', '$injector'];

  a.controller('fbComponentsController', fbComponentsController);

}).call(this);

(function() {
  var a, fbBuilder, fbComponents, fbForm;

  a = angular.module('builder.directive', ['builder.provider', 'builder.controller']);

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

  fbComponents = function($injector) {
    return {
      restrict: 'A',
      template: "<ul class=\"nav nav-tabs nav-justified\">\n    <li ng-repeat=\"(group, component) in components\" ng-class=\"{active:$first}\"><a>{{group}}</a></li>\n</ul>\n<div ng-repeat=\"component in components\">{{component}}</div>",
      controller: 'fbComponentsController',
      link: function(scope, element, attrs) {}
    };
  };

  fbComponents.$inject = ['$injector'];

  a.directive('fbComponents', fbComponents);

  fbForm = function($injector) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        var name;
        return name = attrs.fbForm;
      }
    };
  };

  fbForm.$inject = ['$injector'];

  a.directive('fbForm', fbForm);

}).call(this);

(function() {
  angular.module('builder', ['builder.directive', 'validator.rules']);

}).call(this);

(function() {
  var a;

  a = angular.module('builder.provider', []);

  a.provider('$builder', function() {
    var $injector,
      _this = this;
    $injector = null;
    this.components = {};
    this.forms = {};
    this.forms[''] = [];
    this.setupProviders = function(injector) {
      return $injector = injector;
    };
    this.convertComponent = function(name, component) {
      var result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      result = {
        name: name,
        group: (_ref = component.group) != null ? _ref : 'Default',
        label: (_ref1 = component.label) != null ? _ref1 : '',
        description: (_ref2 = component.description) != null ? _ref2 : '',
        placeholder: (_ref3 = component.placeholder) != null ? _ref3 : '',
        required: (_ref4 = component.required) != null ? _ref4 : false,
        validation: (_ref5 = component.validation) != null ? _ref5 : /.*/,
        options: (_ref6 = component.options) != null ? _ref6 : [],
        template: (_ref7 = component.template) != null ? _ref7 : "<div class=\"form-group\">\n    <label for=\"{{name+label}}\" ng-bind=\"label\" class=\"col-md-2 control-label\"></label>\n    <div class=\"col-md-10\">\n        <input type=\"text\" validator=\"{{validation}}\" class=\"form-control\" id=\"{{name+label}}\" placeholder=\"{{placeholder}}\"/>\n    </div>\n</div>"
      };
      return result;
    };
    this.convertFormGroup = function(formGroup) {
      if (formGroup == null) {
        formGroup = {};
      }
      return formGroup;
    };
    this.registerComponent = function(name, component) {
      if (component == null) {
        component = {};
      }
      /*
      Register the component for form-builder.
      @param name: The component name.
      @param component: The component object.
          group: The compoent group.
          label: The label of the input.
          descriptiont: The description of the input.
          placeholder: The placeholder of the input.
          required: yes / no
          validation: RegExp
          template: html template
      */

      return _this.components[name] = _this.convertComponent(name, component);
    };
    this.getComponentGroups = function() {
      var component, groupSet, name, _ref;
      groupSet = {};
      _ref = _this.components;
      for (name in _ref) {
        component = _ref[name];
        groupSet[component.group] = null;
      }
      return Object.keys(groupSet);
    };
    this.getComponentsByGroup = function(group) {
      var component, name, _ref, _results;
      _ref = _this.components;
      _results = [];
      for (name in _ref) {
        component = _ref[name];
        if (component.group === group) {
          _results.push(component);
        }
      }
      return _results;
    };
    this.addFormGroup = function(name, formGroup) {
      var _base;
      if (formGroup == null) {
        formGroup = {};
      }
      /*
      Add the form group into the form.
      @param name: The form name.
      @param formGroup: The form group.
          removable: true
          label:
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      return _this.forms[name].push(_this.convertFormGroup(formGroup));
    };
    this.get = function($injector) {
      this.setupProviders($injector);
      return {
        components: this.components,
        forms: this.forms,
        registerComponent: this.registerComponent,
        getComponentGroups: this.getComponentGroups,
        getComponentsByGroup: this.getComponentsByGroup,
        addFormGroup: this.addFormGroup
      };
    };
    this.get.$inject = ['$injector'];
    return this.$get = this.get;
  });

}).call(this);
