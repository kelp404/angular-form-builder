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
  var a, fbBuilder, fbComponent, fbComponents, fbForm, fbFormObject;

  a = angular.module('builder.directive', ['builder.provider', 'builder.controller', 'builder.drag']);

  fbBuilder = function($injector) {
    return {
      restrict: 'A',
      template: "<div class='form-horizontal'>\n    <div class='fb-form-object' ng-repeat=\"object in formObjects\"\n        fb-form-object=\"object\"></div>\n</div>",
      controller: 'fbBuilderController',
      link: function(scope, element, attrs) {
        var $builder, $drag, _base, _name;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        scope.formName = attrs.fbBuilder;
        if ((_base = $builder.forms)[_name = scope.formName] == null) {
          _base[_name] = [];
        }
        scope.formObjects = $builder.forms[scope.formName];
        $(element).addClass('fb-builder');
        return $drag.droppable($(element), {
          mode: 'custom',
          move: function(e, draggable) {
            var $empty, $formObject, $formObjects, height, index, offset, positions, _i, _j, _ref, _ref1;
            $formObjects = $(element).find('.fb-form-object:not(.empty,.dragging)');
            if ($formObjects.length === 0) {
              if ($(element).find('.fb-form-object.empty') === 0) {
                $(element).append($("<div class='fb-form-object empty'></div>"));
              }
              return;
            }
            positions = [];
            positions.push(-1000);
            positions.push($($formObjects[0]).offset().top + $($formObjects[0]).height() / 2);
            for (index = _i = 0, _ref = $formObjects.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; index = 0 <= _ref ? ++_i : --_i) {
              if (index === 0) {
                continue;
              }
              $formObject = $($formObjects[index]);
              offset = $formObject.offset();
              height = $formObject.height();
              positions.push(offset.top + height / 2);
            }
            positions.push(positions[positions.length - 1] + 1000);
            for (index = _j = 0, _ref1 = positions.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; index = 0 <= _ref1 ? ++_j : --_j) {
              if (index === 0) {
                continue;
              }
              if (e.pageY > positions[index - 1] && e.pageY <= positions[index]) {
                $(element).find('.empty').remove();
                $empty = $("<div class='fb-form-object empty'></div>");
                if (index - 1 < $formObjects.length) {
                  $empty.insertBefore($($formObjects[index - 1]));
                } else {
                  $empty.insertAfter($($formObjects[index - 2]));
                }
                break;
              }
            }
          },
          out: function(e, draggable) {
            return $(element).find('.empty').remove();
          },
          up: function(e, draggable) {
            return $(element).find('.empty').remove();
          }
        });
      }
    };
  };

  fbBuilder.$inject = ['$injector'];

  a.directive('fbBuilder', fbBuilder);

  fbFormObject = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var $builder, $compile, $drag, $parse, $template, component, cs, formObject, view;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        cs = scope.$new();
        formObject = $parse(attrs.fbFormObject)(scope);
        component = $builder.components[formObject.component];
        $.extend(cs, formObject);
        $drag.draggable($(element));
        $(element).on('click', function() {
          $(element).popover({
            html: true,
            content: "<h2>And here's some amazing content. It's very engaging. right?</h2>"
          });
          $(element).popover('show');
          return console.log('click');
        });
        $template = $(component.template);
        view = $compile($template)(cs);
        return $(element).append(view);
      }
    };
  };

  fbFormObject.$inject = ['$injector'];

  a.directive('fbFormObject', fbFormObject);

  fbComponents = function($injector) {
    return {
      restrict: 'A',
      template: "<ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n    <li ng-repeat=\"group in groups\" ng-class=\"{active:status.activeGroup==group}\">\n        <a href='#' ng-click=\"action.selectGroup($event, group)\">{{group}}</a>\n    </li>\n</ul>\n<div class='form-horizontal'>\n    <div class='fb-component'\n        ng-repeat=\"component in components|filter:{group:status.activeGroup}\"\n        fb-component=\"component\"></div>\n</div>",
      controller: 'fbComponentsController'
    };
  };

  fbComponents.$inject = ['$injector'];

  a.directive('fbComponents', fbComponents);

  fbComponent = function($injector) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var $builder, $compile, $drag, $parse, $template, component, cs, view;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        cs = scope.$new();
        component = $parse(attrs.fbComponent)(scope);
        $.extend(cs, component);
        $drag.draggable($(element), {
          mode: 'mirror',
          defer: false
        });
        $template = $(component.template);
        view = $compile($template)(cs);
        return $(element).append(view);
      }
    };
  };

  fbComponent.$inject = ['$injector'];

  a.directive('fbComponent', fbComponent);

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
  var a;

  a = angular.module('builder.drag', []);

  a.provider('$drag', function() {
    var $injector,
      _this = this;
    $injector = null;
    this.data = {
      draggables: {},
      droppables: {}
    };
    this.hooks = {
      move: {},
      up: {}
    };
    this.eventMouseMove = function() {};
    this.eventMouseUp = function() {};
    $(function() {
      $(document).on('mousemove', function(e) {
        var func, key, _ref;
        _ref = _this.hooks.move;
        for (key in _ref) {
          func = _ref[key];
          if (typeof func === "function") {
            func(e);
          }
        }
      });
      return $(document).on('mouseup', function(e) {
        var func, key, _ref;
        _ref = _this.hooks.up;
        for (key in _ref) {
          func = _ref[key];
          if (typeof func === "function") {
            func(e);
          }
        }
      });
    });
    this.currentId = 0;
    this.getNewId = function() {
      return "" + (_this.currentId++);
    };
    this.setupProviders = function(injector) {
      /*
      Setup providers.
      */

      return $injector = injector;
    };
    this.isHover = function($elementA, $elementB) {
      /*
      Is element A hover on element B?
      @param $elementA: jQuery object
      @param $elementB: jQuery object
      */

      var isHover, offsetA, offsetB, sizeA, sizeB;
      offsetA = $elementA.offset();
      offsetB = $elementB.offset();
      sizeA = {
        width: $elementA.width(),
        height: $elementA.height()
      };
      sizeB = {
        width: $elementB.width(),
        height: $elementB.height()
      };
      isHover = {
        x: false,
        y: false
      };
      isHover.x = offsetA.left > offsetB.left && offsetA.left < offsetB.left + sizeB.width;
      isHover.x = isHover.x || offsetA.left + sizeA.width > offsetB.left && offsetA.left + sizeA.width < offsetB.left + sizeB.width;
      if (!isHover) {
        return false;
      }
      isHover.y = offsetA.top > offsetB.top && offsetA.top < offsetB.top + sizeB.height;
      isHover.y = isHover.y || offsetA.top + sizeA.height > offsetB.top && offsetA.top + sizeA.height < offsetB.top + sizeB.height;
      return isHover.x && isHover.y;
    };
    this.dragMirrorMode = function($element, defer) {
      var result;
      if (defer == null) {
        defer = true;
      }
      result = {
        id: _this.getNewId(),
        mode: 'mirror',
        maternal: $element[0],
        element: null
      };
      $element.on('mousedown', function(e) {
        var $clone;
        e.preventDefault();
        $clone = $element.clone();
        result.element = $clone[0];
        $clone.addClass("fb-draggable form-horizontal prepare-dragging");
        _this.hooks.move.drag = function(e, defer) {
          var droppable, id, _ref, _results;
          if ($clone.hasClass('prepare-dragging')) {
            $clone.css({
              width: $element.width(),
              height: $element.height()
            });
            $clone.removeClass('prepare-dragging');
            $clone.addClass('dragging');
            if (defer) {
              return;
            }
          }
          $clone.offset({
            left: e.pageX - $clone.width() / 2,
            top: e.pageY - $clone.height() / 2
          });
          _ref = _this.data.droppables;
          _results = [];
          for (id in _ref) {
            droppable = _ref[id];
            if (_this.isHover($clone, $(droppable.element))) {
              _results.push(droppable.move(e, result));
            } else {
              _results.push(droppable.out(e, result));
            }
          }
          return _results;
        };
        _this.hooks.up.drag = function(e) {
          var droppable, id, _ref;
          _ref = _this.data.droppables;
          for (id in _ref) {
            droppable = _ref[id];
            if (_this.isHover($clone, $(droppable.element))) {
              droppable.up(e, result);
            }
          }
          delete _this.hooks.move.drag;
          delete _this.hooks.up.drag;
          result.element = null;
          return $clone.remove();
        };
        $('body').append($clone);
        if (!defer) {
          return _this.hooks.move.drag(e, defer);
        }
      });
      return result;
    };
    this.dragDragMode = function($element, defer) {
      var result;
      if (defer == null) {
        defer = true;
      }
      result = {
        id: _this.getNewId(),
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
        $element.addClass('prepare-dragging');
        _this.hooks.move.drag = function(e, defer) {
          var droppable, id, _ref, _results;
          if ($element.hasClass('prepare-dragging')) {
            $element.css({
              width: $element.width(),
              height: $element.height()
            });
            $element.removeClass('prepare-dragging');
            $element.addClass('dragging');
            if (defer) {
              return;
            }
          }
          $element.offset({
            left: e.pageX - $element.width() / 2,
            top: e.pageY - $element.height() / 2
          });
          _ref = _this.data.droppables;
          _results = [];
          for (id in _ref) {
            droppable = _ref[id];
            if (_this.isHover($element, $(droppable.element))) {
              _results.push(droppable.move(e, result));
            } else {
              _results.push(droppable.out(e, result));
            }
          }
          return _results;
        };
        _this.hooks.up.drag = function(e) {
          var droppable, id, _ref;
          _ref = _this.data.droppables;
          for (id in _ref) {
            droppable = _ref[id];
            if (_this.isHover($element, $(droppable.element))) {
              droppable.up(e, result);
            }
          }
          delete _this.hooks.move.drag;
          delete _this.hooks.up.drag;
          $element.css({
            width: '',
            height: '',
            left: '',
            top: ''
          });
          return $element.removeClass('dragging defer-dragging');
        };
        if (!defer) {
          return _this.hooks.move.drag(e, defer);
        }
      });
      return result;
    };
    this.dropCustomMode = function($element, options) {
      var result;
      result = {
        id: _this.getNewId(),
        mode: 'custom',
        element: $element[0],
        move: options.move,
        up: options.up,
        out: options.out
      };
      return result;
    };
    this.draggable = function($element, options) {
      var draggable, element, result, _i, _j, _len, _len1;
      if (options == null) {
        options = {};
      }
      /*
      Make the element could be drag.
      @param element: The jQuery element.
      @param options: Options
          mode: 'drag' [default], 'mirror'
          defer: yes/no. defer dragging
      */

      result = [];
      if (options.mode === 'mirror') {
        for (_i = 0, _len = $element.length; _i < _len; _i++) {
          element = $element[_i];
          draggable = _this.dragMirrorMode($(element), options.defer);
          result.push(draggable.id);
          _this.data.draggables[draggable.id] = draggable;
        }
      } else {
        for (_j = 0, _len1 = $element.length; _j < _len1; _j++) {
          element = $element[_j];
          draggable = _this.dragDragMode($(element), options.defer);
          result.push(draggable.id);
          _this.data.draggables[draggable.id] = draggable;
        }
      }
      return result;
    };
    this.droppable = function($element, options) {
      var droppable, element, result, _i, _len;
      if (options == null) {
        options = {};
      }
      /*
      Make the element coulde be drop.
      @param $element: The jQuery element.
      @param options: The droppable options.
          mode: 'default' [default], 'custom'
          move: The custom mouse move callback. (e, draggable)->
          up: The custom mouse up callback. (e, draggable)->
          out: The custom mouse out callback. (e, draggable)->
      */

      result = [];
      if (options.mode === 'custom') {
        for (_i = 0, _len = $element.length; _i < _len; _i++) {
          element = $element[_i];
          droppable = _this.dropCustomMode($(element), options);
          result.push(droppable);
          _this.data.droppables[droppable.id] = droppable;
        }
      }
      return result;
    };
    this.get = function($injector) {
      this.setupProviders($injector);
      return {
        data: this.data,
        draggable: this.draggable,
        droppable: this.droppable
      };
    };
    this.get.inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);

(function() {
  angular.module('builder', ['builder.directive', 'validator.rules']);

}).call(this);

/*
    component:
        It is like a class.
        The base components are textInput, textArea, select, check, radio.
        User can custom the form with components.
    formObject:
        It is like an object (an instance of the component).
        User can custom the label, description, required and validation of the input.
    form:
        This is for end-user. There are form groups int the form.
        They can input the value to the form.
*/


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
          _this.groups.push(newComponent.group);
        }
      } else {
        console.error("The component " + name + " was registered.");
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
