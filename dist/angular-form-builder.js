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
  var a, fbBuilder, fbComponent, fbComponents, fbDraggable, fbDraggableMaternal, fbForm;

  a = angular.module('builder.directive', ['builder.provider', 'builder.controller', 'builder.drag']);

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
        var $drag;
        $drag = $injector.get('$drag');
        return $drag.draggable($(element), {
          mode: 'mirror'
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
        var $drag;
        $drag = $injector.get('$drag');
        return $drag.draggable($(element));
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
  var a, drag;

  a = angular.module('builder.drag', []);

  drag = function($injector) {
    var _this = this;
    this.data = {
      draggables: [],
      droppables: []
    };
    this.eventMouseDown = function() {};
    this.eventMouseMove = function() {};
    this.eventMouseUp = function() {};
    $(function() {
      $(document).on('mousedown', function(e) {
        return _this.eventMouseDown(e);
      });
      $(document).on('mousemove', function(e) {
        return _this.eventMouseMove(e);
      });
      return $(document).on('mouseup', function(e) {
        return _this.eventMouseUp(e);
      });
    });
    this.makeMirrorMode = function($element) {
      var result;
      result = {
        mode: 'mirror',
        maternal: $element[0],
        element: null
      };
      $element.on('mousedown', function(e) {
        var $clone;
        e.preventDefault();
        $clone = $element.clone();
        result.element = $clone[0];
        $clone.css({
          width: $element.width(),
          height: $element.height()
        });
        $clone.addClass("fb-draggable form-horizontal dragging");
        _this.eventMouseMove = function(e) {
          return $clone.offset({
            left: e.pageX - $clone.width() / 2,
            top: e.pageY - $clone.height() / 2
          });
        };
        _this.eventMouseUp = function(e) {
          _this.eventMouseMove = function() {};
          _this.eventMouseUp = function() {};
          result.element = null;
          return $clone.remove();
        };
        $('body').append($clone);
        return _this.eventMouseMove(e);
      });
      return result;
    };
    this.makeDragMode = function($element) {
      var result;
      result = {
        mode: 'drag',
        maternal: null,
        element: $element[0]
      };
      $element.addClass('fb-draggable');
      $element.on('mousedown', function(e) {
        e.preventDefault();
        if ($element.hasClass('dragging')) {
          return;
        }
        $element.css({
          width: $element.width(),
          height: $element.height()
        });
        $element.addClass('dragging');
        _this.eventMouseMove = function(e) {
          return $element.offset({
            left: e.pageX - $element.width() / 2,
            top: e.pageY - $element.height() / 2
          });
        };
        _this.eventMouseUp = function(e) {
          _this.eventMouseMove = function() {};
          _this.eventMouseUp = function() {};
          $element.css({
            width: '',
            height: '',
            left: '',
            top: ''
          });
          return $element.removeClass('dragging');
        };
        return _this.eventMouseMove(e);
      });
      return result;
    };
    this.draggable = function($element, options) {
      var element, _i, _j, _len, _len1;
      if (options == null) {
        options = {};
      }
      /*
      Make the element could be drag.
      @param element: The jQuery element.
      @param options: Options
          mode: 'drag' [default], 'mirror'
      */

      if (options.mode === 'mirror') {
        for (_i = 0, _len = $element.length; _i < _len; _i++) {
          element = $element[_i];
          _this.data.draggables.push(_this.makeMirrorMode($(element)));
        }
      } else {
        for (_j = 0, _len1 = $element.length; _j < _len1; _j++) {
          element = $element[_j];
          _this.data.draggables.push(_this.makeDragMode($(element)));
        }
      }
    };
    this.removeDraggable = function($element) {
      return $element;
    };
    this.droppable = function($element, opeions) {
      /*
      Make the element coulde be drop.
      @param $element: The jQuery element.
      */

      return $element;
    };
    return {
      data: this.data,
      draggable: this.draggable,
      removeDraggable: this.removeDraggable,
      droppable: this.droppable
    };
  };

  drag.$inject = ['$injector'];

  a.factory('$drag', drag);

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
