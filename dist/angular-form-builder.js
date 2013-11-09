(function() {
  var a, fbComponentsController;

  a = angular.module('builder.controller', ['builder.provider']);

  fbComponentsController = function($scope, $injector) {
    var $builder;
    $builder = $injector.get('$builder');
    $scope.groups = $builder.groups;
    $scope.components = $builder.componentsArray;
    $scope.status = {
      activeGroup: $scope.groups[0]
    };
    return $scope.action = {
      selectGroup: function($event, group) {
        $event.preventDefault();
        return $scope.status.activeGroup = group;
      }
    };
  };

  fbComponentsController.$inject = ['$scope', '$injector'];

  a.controller('fbComponentsController', fbComponentsController);

}).call(this);

(function() {
  var Draggable, a, fbBuilder, fbComponent, fbComponents, fbDraggableMaternal, fbForm,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Draggable = (function() {
    function Draggable($injector, object) {
      this.setupElement = __bind(this.setupElement, this);
      this.mirrorMode = __bind(this.mirrorMode, this);
      this.injector = $injector;
      this.$maternal = null;
      this.$element = null;
      if (object.maternal) {
        this.$maternal = $(object.maternal);
        this.mirrorMode(this.$maternal);
      }
    }

    Draggable.prototype.mirrorMode = function(maternal) {
      var _this = this;
      return maternal.bind('mousedown', function(e) {
        var callback;
        e.preventDefault();
        _this.$element = maternal.clone();
        callback = {
          move: function(e) {
            return _this.$element.offset({
              left: e.pageX - _this.$element.width() / 2,
              top: e.pageY - _this.$element.height() / 2
            });
          },
          up: function(e) {
            return _this.$element.remove();
          }
        };
        return _this.setupElement(_this.$element, callback, {
          left: e.pageX - _this.$maternal.width() / 2,
          top: e.pageY - _this.$maternal.height() / 2
        });
      });
    };

    Draggable.prototype.setupElement = function(element, callback, object) {
      var _ref, _ref1;
      element.addClass('fb-draggable dragging form-horizontal');
      element.css({
        width: this.$maternal.width(),
        height: this.$maternal.height(),
        left: (_ref = object.left) != null ? _ref : this.$maternal.offset().left,
        top: (_ref1 = object.top) != null ? _ref1 : this.$maternal.offset().top
      });
      element.bind('mousedown', function(e) {
        if (callback.down) {
          return callback.down(e);
        }
      });
      element.bind('mousemove', function(e) {
        if (callback.move) {
          return callback.move(e);
        }
      });
      element.bind('mouseup', function(e) {
        if (callback.up) {
          return callback.up(e);
        }
      });
      return $('body').append(element);
    };

    return Draggable;

  })();

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
      template: "<div class='fb-components'>\n    <ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n        <li ng-repeat=\"group in groups\" ng-class=\"{active:status.activeGroup==group}\">\n            <a href='#' ng-click=\"action.selectGroup($event, group)\">{{group}}</a>\n        </li>\n    </ul>\n    <div class='form-horizontal'>\n        <div class='fb-component'\n            ng-repeat=\"component in components|filter:{group:status.activeGroup}\"\n            fb-component=\"component\" fb-draggable-maternal></div>\n    </div>\n</div>",
      controller: 'fbComponentsController',
      link: function(scope, element, attrs) {}
    };
  };

  fbComponents.$inject = ['$injector'];

  a.directive('fbComponents', fbComponents);

  fbComponent = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var $compile, $parse, $template, component, cs, view;
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        component = $parse(attrs.fbComponent)(scope);
        cs = scope.$new();
        $.extend(cs, component);
        $template = $(component.template);
        view = $compile($template)(cs);
        return $(element).append(view);
      }
    };
  };

  fbComponent.$inject = ['$injector'];

  a.directive('fbComponent', fbComponent);

  fbDraggableMaternal = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        return new Draggable($injector, {
          maternal: element
        });
      }
    };
  };

  fbDraggableMaternal.$inject = ['$injector'];

  a.directive('fbDraggableMaternal', fbDraggableMaternal);

  fbForm = function($injector) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attrs) {
        var name;
        name = attrs.fbForm;
        return console.log('form');
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
  var a,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  a = angular.module('builder.provider', []);

  a.provider('$builder', function() {
    var $injector,
      _this = this;
    $injector = null;
    this.components = {};
    this.componentsArray = [];
    this.groups = [];
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
        template: (_ref7 = component.template) != null ? _ref7 : "<div class=\"form-group\">\n    <label for=\"{{name+label}}\" class=\"col-md-2 control-label\">{{label}}</label>\n    <div class=\"col-md-10\">\n        <input type=\"text\" class=\"form-control\" id=\"{{name+label}}\" placeholder=\"{{placeholder}}\"/>\n    </div>\n</div>"
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
      var newComponent, _ref;
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
          options: []
          template: html template
      */

      if (_this.components[name] == null) {
        newComponent = _this.convertComponent(name, component);
        _this.components[name] = newComponent;
        _this.componentsArray.push(newComponent);
        if (_ref = newComponent.group, __indexOf.call(_this.groups, _ref) < 0) {
          return _this.groups.push(newComponent.group);
        }
      }
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
        componentsArray: this.componentsArray,
        groups: this.groups,
        forms: this.forms,
        registerComponent: this.registerComponent,
        addFormGroup: this.addFormGroup
      };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);
