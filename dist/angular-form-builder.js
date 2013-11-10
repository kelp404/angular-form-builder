(function() {
  var a, fbBuilderController, fbComponentsController;

  a = angular.module('builder.controller', ['builder.provider']);

  fbBuilderController = function($scope, $injector) {
    var $builder;
    return $builder = $injector.get('$builder');
  };

  fbBuilderController.$inject = ['$scope', '$injector'];

  a.controller('fbBuilderController', fbBuilderController);

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
  var Draggable, a, fbBuilder, fbComponent, fbComponents, fbDraggable, fbDraggableMaternal, fbForm,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Draggable = (function() {
    function Draggable($injector, object) {
      this.beginDrag = __bind(this.beginDrag, this);
      this.dragMode = __bind(this.dragMode, this);
      this.mirrorMode = __bind(this.mirrorMode, this);
      this.injector = $injector;
      this.$maternal = null;
      this.$element = null;
      if (object.maternal) {
        this.$maternal = $(object.maternal);
        this.mirrorMode(this.$maternal);
      } else if (object.element) {
        this.$element = $(object.element);
        this.dragMode(this.$element);
      }
    }

    Draggable.prototype.mirrorMode = function($maternal) {
      var _this = this;
      return $maternal.bind('mousedown', function(e) {
        var callback;
        e.preventDefault();
        _this.$element = $maternal.clone();
        _this.$element.addClass('fb-draggable form-horizontal');
        $('body').append(_this.$element);
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
        return _this.beginDrag(_this.$element, callback, {
          width: _this.$maternal.width(),
          height: _this.$maternal.height(),
          left: e.pageX - _this.$maternal.width() / 2,
          top: e.pageY - _this.$maternal.height() / 2
        });
      });
    };

    Draggable.prototype.dragMode = function($element) {
      var _this = this;
      $element.addClass('fb-draggable');
      return $element.bind('mousedown', function(e) {
        var callback;
        e.preventDefault();
        if ($element.hasClass('dragging')) {
          return;
        }
        callback = {
          move: function(e) {
            if (!$element.hasClass('dragging')) {
              return;
            }
            return $element.offset({
              left: e.pageX - $element.width() / 2,
              top: e.pageY - $element.height() / 2
            });
          },
          up: function(e) {
            if (!$element.hasClass('dragging')) {
              return;
            }
            $element.css({
              width: '',
              height: '',
              left: '',
              top: ''
            });
            return $element.removeClass('dragging');
          }
        };
        return _this.beginDrag($element, callback, {
          width: $element.width(),
          height: $element.height()
        });
      });
    };

    Draggable.prototype.beginDrag = function(element, callback, object) {
      element.addClass('dragging');
      element.css({
        width: object.width,
        height: object.height,
        left: object != null ? object.left : void 0,
        top: object != null ? object.top : void 0
      });
      $(document).on('mousemove', element, function(e) {
        if (callback.move) {
          return callback.move(e);
        }
      });
      return element.bind('mouseup', function(e) {
        $(document).off('mousemove', element);
        if (callback.up) {
          return callback.up(e);
        }
      });
    };

    return Draggable;

  })();

  a = angular.module('builder.directive', ['builder.provider', 'builder.controller']);

  fbBuilder = function($injector) {
    return {
      restrict: 'A',
      template: "<div class='form-horizontal'>\n    <div class='fb-component'\n        ng-repeat=\"object in form\"\n        fb-form-object=\"object\" fb-draggable></div>\n</div>",
      controller: 'fbBuilderController',
      link: function(scope, element, attrs) {
        var $builder, _base, _name;
        $builder = $injector.get('$builder');
        scope.formName = attrs.fbBuilder;
        if ((_base = $builder.forms)[_name = scope.formName] == null) {
          _base[_name] = [];
        }
        scope.form = $builder.forms[scope.formName];
        return $(element).addClass('fb-builder fb-droppable');
      }
    };
  };

  fbBuilder.$inject = ['$injector'];

  a.directive('fbBuilder', fbBuilder);

  fbComponents = function($injector) {
    return {
      restrict: 'A',
      template: "<ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n    <li ng-repeat=\"group in groups\" ng-class=\"{active:status.activeGroup==group}\">\n        <a href='#' ng-click=\"action.selectGroup($event, group)\">{{group}}</a>\n    </li>\n</ul>\n<div class='form-horizontal'>\n    <div class='fb-component'\n        ng-repeat=\"component in components|filter:{group:status.activeGroup}\"\n        fb-component=\"component\" fb-draggable-maternal></div>\n</div>",
      controller: 'fbComponentsController'
    };
  };

  fbComponents.$inject = ['$injector'];

  a.directive('fbComponents', fbComponents);

  fbComponent = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var $builder, $compile, $parse, $template, component, cs, formObject, view;
        $builder = $injector.get('$builder');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        cs = scope.$new();
        if (attrs.fbComponent) {
          component = $parse(attrs.fbComponent)(scope);
          $.extend(cs, component);
        } else {
          formObject = $parse(attrs.fbFormObject)(scope);
          component = $builder.components[formObject.component];
          $.extend(cs, formObject);
        }
        $template = $(component.template);
        view = $compile($template)(cs);
        return $(element).append(view);
      }
    };
  };

  fbComponent.$inject = ['$injector'];

  a.directive('fbComponent', fbComponent);

  a.directive('fbFormObject', fbComponent);

  fbDraggableMaternal = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element) {
        return new Draggable($injector, {
          maternal: element
        });
      }
    };
  };

  fbDraggableMaternal.$inject = ['$injector'];

  a.directive('fbDraggableMaternal', fbDraggableMaternal);

  fbDraggable = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element) {
        return new Draggable($injector, {
          element: element
        });
      }
    };
  };

  fbDraggableMaternal.$inject = ['$injector'];

  a.directive('fbDraggable', fbDraggable);

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
    this.forms['default'] = [];
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
    this.convertFormObject = function(formObject) {
      var component, result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      if (formObject == null) {
        formObject = {};
      }
      component = this.components[formObject.component];
      if (component == null) {
        console.error("component " + formObject.component + " was not registered.");
      }
      result = {
        component: formObject.component,
        removable: (_ref = formObject.removable) != null ? _ref : true,
        draggable: (_ref1 = formObject.draggable) != null ? _ref1 : true,
        index: (_ref2 = formObject.index) != null ? _ref2 : 0,
        label: (_ref3 = formObject.label) != null ? _ref3 : component.label,
        description: (_ref4 = formObject.description) != null ? _ref4 : component.description,
        placeholder: (_ref5 = formObject.placeholder) != null ? _ref5 : component.placeholder,
        options: (_ref6 = formObject.options) != null ? _ref6 : component.options
      };
      return result;
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
    this.addFormObject = function(name, formObject) {
      var _base;
      if (formObject == null) {
        formObject = {};
      }
      /*
      Add the form object into the form.
      @param name: The form name.
      @param form: The form object.
          component: The component name
          removable: true
          draggable: true
          index: 0
          label:
          description:
          placeholder:
          options:
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      return _this.forms[name].push(_this.convertFormObject(formObject));
    };
    this.get = function($injector) {
      this.setupProviders($injector);
      return {
        components: this.components,
        componentsArray: this.componentsArray,
        groups: this.groups,
        forms: this.forms,
        registerComponent: this.registerComponent,
        addFormObject: this.addFormObject
      };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);
