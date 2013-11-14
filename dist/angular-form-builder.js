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
        var $builder, $drag, beginMove, formName, _base;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        formName = attrs.fbBuilder;
        if ((_base = $builder.forms)[formName] == null) {
          _base[formName] = [];
        }
        scope.formObjects = $builder.forms[formName];
        beginMove = true;
        $(element).addClass('fb-builder');
        return $drag.droppable($(element), {
          mode: 'custom',
          move: function(e, draggable) {
            var $empty, $formObject, $formObjects, height, index, offset, positions, _i, _j, _ref, _ref1;
            if (beginMove) {
              $("div.fb-form-object").popover('hide');
              beginMove = false;
            }
            $formObjects = $(element).find('.fb-form-object:not(.empty,.dragging)');
            if ($formObjects.length === 0) {
              if ($(element).find('.fb-form-object.empty').length === 0) {
                $(element).find('>div:first').append($("<div class='fb-form-object empty'></div>"));
              }
              return;
            }
            positions = [];
            positions.push(-1000);
            positions.push($($formObjects[0]).offset().top + $($formObjects[0]).height() / 2);
            for (index = _i = 0, _ref = $formObjects.length - 1; _i <= _ref; index = _i += 1) {
              if (index === 0) {
                continue;
              }
              $formObject = $($formObjects[index]);
              offset = $formObject.offset();
              height = $formObject.height();
              positions.push(offset.top + height / 2);
            }
            positions.push(positions[positions.length - 1] + 1000);
            for (index = _j = 0, _ref1 = positions.length - 1; _j <= _ref1; index = _j += 1) {
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
            if (beginMove) {
              $("div.fb-form-object").popover('hide');
              beginMove = false;
            }
            return $(element).find('.empty').remove();
          },
          up: function(e, isHover, draggable) {
            var formObject, newIndex, oldIndex;
            beginMove = true;
            if (!$drag.isMouseMoved()) {
              return;
            }
            if (!isHover && draggable.mode === 'drag') {
              formObject = draggable.object.formObject;
              $builder.removeFormObject(formObject.name, formObject.index);
            } else if (isHover) {
              if (draggable.mode === 'mirror') {
                $builder.insertFormObject(formName, $(element).find('.empty').index('.fb-form-object'), {
                  component: draggable.object.componentName
                });
              }
              if (draggable.mode === 'drag') {
                oldIndex = draggable.object.formObject.index;
                newIndex = $(element).find('.empty').index('.fb-form-object');
                if (oldIndex < newIndex) {
                  newIndex--;
                }
                $builder.updateFormObjectIndex(formName, oldIndex, newIndex);
              }
            }
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
        var $builder, $compile, $drag, $parse, $template, $validator, component, key, popover, popoverId, value, view, _ref;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        $validator = $injector.get('$validator');
        component = $builder.components[scope.object.component];
        _ref = scope.object;
        for (key in _ref) {
          value = _ref[key];
          if (key !== '$$hashKey') {
            scope[key] = value;
          }
        }
        scope.$watch('[label, description, placeholder, required, options]', function() {
          scope.object.label = scope.label;
          scope.object.description = scope.description;
          scope.object.placeholder = scope.placeholder;
          scope.object.required = scope.required;
          return scope.object.options = scope.options;
        }, true);
        $drag.draggable($(element), {
          object: {
            formObject: scope.object
          }
        });
        $template = $(component.template);
        view = $compile($template)(scope);
        $(element).append(view);
        popoverId = "fb-" + (Math.random().toString().substr(2));
        popover = {
          isClickedSave: false,
          view: null,
          html: component.popoverTemplate
        };
        popover.html = $(popover.html).addClass(popoverId);
        scope.popover = {
          ngModel: null,
          save: function($event) {
            /*
            The save event of the popover.
            */

            $event.preventDefault();
            $validator.validate(scope).success(function() {
              popover.isClickedSave = true;
              return $(element).popover('hide');
            });
          },
          remove: function($event) {
            /*
            The delete event of the popover.
            */

            var formName;
            $event.preventDefault();
            formName = $(element).closest('[fb-builder]').attr('fb-builder');
            $builder.removeFormObject(formName, scope.$index);
            $(element).popover('hide');
          },
          shown: function() {
            /*
            The shown event of the popover.
            */

            var x;
            this.ngModel = {
              label: scope.label,
              description: scope.description,
              placeholder: scope.placeholder,
              required: scope.required,
              options: (function() {
                var _i, _len, _ref1, _results;
                _ref1 = scope.options;
                _results = [];
                for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
                  x = _ref1[_i];
                  _results.push(x);
                }
                return _results;
              })()
            };
            return popover.isClickedSave = false;
          },
          cancel: function($event) {
            /*
            The cancel event of the popover.
            */

            var x, _i, _len, _ref1;
            if (this.ngModel) {
              scope.label = this.ngModel.label;
              scope.description = this.ngModel.description;
              scope.placeholder = this.ngModel.placeholder;
              scope.required = this.ngModel.required;
              scope.options.length = 0;
              _ref1 = this.ngModel;
              for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
                x = _ref1[_i];
                scope.options.push(x);
              }
            }
            if ($event) {
              $event.preventDefault();
              $(element).popover('hide');
            }
          }
        };
        popover.view = $compile(popover.html)(scope);
        $(element).addClass(popoverId);
        $(element).popover({
          html: true,
          title: component.label,
          content: popover.view
        });
        $(element).on('show.bs.popover', function() {
          var $popover, elementOrigin, popoverTop;
          if ($drag.isMouseMoved()) {
            return false;
          }
          $("div.fb-form-object:not(." + popoverId + ")").popover('hide');
          $popover = $("form." + popoverId).closest('.popover');
          if ($popover.length > 0) {
            elementOrigin = $(element).offset().top + $(element).height() / 2;
            popoverTop = elementOrigin - $popover.height() / 2 - 20;
            $popover.css({
              top: popoverTop
            });
            $popover.show();
            setTimeout(function() {
              $popover.addClass('in');
              return $(element).triggerHandler('shown.bs.popover');
            }, 0);
            return false;
          }
        });
        $(element).on('shown.bs.popover', function() {
          $(".popover ." + popoverId + " input:first").select();
          scope.$apply(function() {
            return scope.popover.shown();
          });
        });
        return $(element).on('hide.bs.popover', function() {
          var $popover;
          $popover = $("form." + popoverId).closest('.popover');
          if (!popover.isClickedSave) {
            if (scope.$$phase) {
              scope.popover.cancel();
            } else {
              scope.$apply(function() {
                return scope.popover.cancel();
              });
            }
          }
          $popover.removeClass('in');
          setTimeout(function() {
            return $popover.hide();
          }, 300);
          return false;
        });
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
          defer: false,
          object: {
            componentName: component.name
          }
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
    var $injector, $rootScope,
      _this = this;
    $injector = null;
    $rootScope = null;
    this.data = {
      draggables: {},
      droppables: {}
    };
    this.mouseMoved = false;
    this.isMouseMoved = function() {
      return _this.mouseMoved;
    };
    this.hooks = {
      down: {},
      move: {},
      up: {}
    };
    this.eventMouseMove = function() {};
    this.eventMouseUp = function() {};
    $(function() {
      $(document).on('mousedown', function(e) {
        var func, key, _ref;
        _this.mouseMoved = false;
        _ref = _this.hooks.down;
        for (key in _ref) {
          func = _ref[key];
          func(e);
        }
      });
      $(document).on('mousemove', function(e) {
        var func, key, _ref;
        _this.mouseMoved = true;
        _ref = _this.hooks.move;
        for (key in _ref) {
          func = _ref[key];
          func(e);
        }
      });
      return $(document).on('mouseup', function(e) {
        var func, key, _ref;
        _ref = _this.hooks.up;
        for (key in _ref) {
          func = _ref[key];
          func(e);
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

      $injector = injector;
      return $rootScope = $injector.get('$rootScope');
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
    this.dragMirrorMode = function($element, defer, object) {
      var result;
      if (defer == null) {
        defer = true;
      }
      result = {
        id: _this.getNewId(),
        mode: 'mirror',
        maternal: $element[0],
        element: null,
        object: object
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
          var droppable, id, isHover, _ref;
          _ref = _this.data.droppables;
          for (id in _ref) {
            droppable = _ref[id];
            isHover = _this.isHover($clone, $(droppable.element));
            droppable.up(e, isHover, result);
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
    this.dragDragMode = function($element, defer, object) {
      var result;
      if (defer == null) {
        defer = true;
      }
      result = {
        id: _this.getNewId(),
        mode: 'drag',
        maternal: null,
        element: $element[0],
        object: object
      };
      $element.addClass('fb-draggable');
      $element.on('mousedown', function(e) {
        e.preventDefault();
        if ($element.hasClass('dragging')) {
          return;
        }
        $element.addClass('prepare-dragging');
        _this.hooks.move.drag = function(e, defer) {
          var droppable, id, _ref;
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
          for (id in _ref) {
            droppable = _ref[id];
            if (_this.isHover($element, $(droppable.element))) {
              droppable.move(e, result);
            } else {
              droppable.out(e, result);
            }
          }
        };
        _this.hooks.up.drag = function(e) {
          var droppable, id, isHover, _ref;
          _ref = _this.data.droppables;
          for (id in _ref) {
            droppable = _ref[id];
            isHover = _this.isHover($element, $(droppable.element));
            droppable.up(e, isHover, result);
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
        move: function(e, draggable) {
          return $rootScope.$apply(function() {
            return typeof options.move === "function" ? options.move(e, draggable) : void 0;
          });
        },
        up: function(e, isHover, draggable) {
          return $rootScope.$apply(function() {
            return typeof options.up === "function" ? options.up(e, isHover, draggable) : void 0;
          });
        },
        out: function(e, draggable) {
          return $rootScope.$apply(function() {
            return typeof options.out === "function" ? options.out(e, draggable) : void 0;
          });
        }
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
          object: custom information
      */

      result = [];
      if (options.mode === 'mirror') {
        for (_i = 0, _len = $element.length; _i < _len; _i++) {
          element = $element[_i];
          draggable = _this.dragMirrorMode($(element), options.defer, options.object);
          result.push(draggable.id);
          _this.data.draggables[draggable.id] = draggable;
        }
      } else {
        for (_j = 0, _len1 = $element.length; _j < _len1; _j++) {
          element = $element[_j];
          draggable = _this.dragDragMode($(element), options.defer, options.object);
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
          up: The custom mouse up callback. (e, isHover, draggable)->
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
        isMouseMoved: this.isMouseMoved,
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
      var result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      result = {
        name: name,
        group: (_ref = component.group) != null ? _ref : 'Default',
        label: (_ref1 = component.label) != null ? _ref1 : '',
        description: (_ref2 = component.description) != null ? _ref2 : '',
        placeholder: (_ref3 = component.placeholder) != null ? _ref3 : '',
        required: (_ref4 = component.required) != null ? _ref4 : false,
        validation: (_ref5 = component.validation) != null ? _ref5 : /.*/,
        options: (_ref6 = component.options) != null ? _ref6 : [],
        template: component.template,
        popoverTemplate: component.popoverTemplate
      };
      if (!result.template) {
        console.error("template is empty");
      }
      if (!result.popoverTemplate) {
        console.error("popoverTemplate is empty");
      }
      return result;
    };
    this.convertFormObject = function(name, formObject) {
      var component, result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      if (formObject == null) {
        formObject = {};
      }
      component = this.components[formObject.component];
      if (component == null) {
        console.error("component " + formObject.component + " was not registered.");
      }
      result = {
        name: name,
        component: formObject.component,
        removable: (_ref = formObject.removable) != null ? _ref : true,
        draggable: (_ref1 = formObject.draggable) != null ? _ref1 : true,
        index: (_ref2 = formObject.index) != null ? _ref2 : 0,
        label: (_ref3 = formObject.label) != null ? _ref3 : component.label,
        description: (_ref4 = formObject.description) != null ? _ref4 : component.description,
        placeholder: (_ref5 = formObject.placeholder) != null ? _ref5 : component.placeholder,
        options: (_ref6 = formObject.options) != null ? _ref6 : component.options,
        required: (_ref7 = formObject.required) != null ? _ref7 : component.required
      };
      return result;
    };
    this.reIndexFormObject = function(name) {
      var formObjects, index, _i, _ref;
      formObjects = _this.forms[name];
      for (index = _i = 0, _ref = formObjects.length - 1; _i <= _ref; index = _i += 1) {
        formObjects[index].index = index;
      }
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
          popoverTemplate: html template
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
      Insert the form Object into the form at last.
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      return _this.insertFormObject(name, _this.forms[name].length, formObject);
    };
    this.insertFormObject = function(name, index, formObject) {
      var _base;
      if (formObject == null) {
        formObject = {};
      }
      /*
      Insert the form object into the form at {index}.
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
          required:
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      if (index > _this.forms.length) {
        index = _this.forms.length;
      } else if (index < 0) {
        index = 0;
      }
      _this.forms[name].splice(index, 0, _this.convertFormObject(name, formObject));
      return _this.reIndexFormObject(name);
    };
    this.removeFormObject = function(name, index) {
      /*
      Remove the form object by the index.
      @param name: The form name.
      @param index: The form object index.
      */

      var formObjects;
      formObjects = _this.forms[name];
      formObjects.splice(index, 1);
      return _this.reIndexFormObject(name);
    };
    this.updateFormObjectIndex = function(name, oldIndex, newIndex) {
      /*
      Update the index of the form object.
      @param name: The form name.
      @param oldIndex: The old index.
      @param newIndex: The new index.
      */

      var formObject, formObjects;
      if (oldIndex === newIndex) {
        return;
      }
      formObjects = _this.forms[name];
      formObject = formObjects.splice(oldIndex, 1)[0];
      formObjects.splice(newIndex, 0, formObject);
      return _this.reIndexFormObject(name);
    };
    this.get = function($injector) {
      this.setupProviders($injector);
      return {
        components: this.components,
        componentsArray: this.componentsArray,
        groups: this.groups,
        forms: this.forms,
        registerComponent: this.registerComponent,
        addFormObject: this.addFormObject,
        insertFormObject: this.insertFormObject,
        removeFormObject: this.removeFormObject,
        updateFormObjectIndex: this.updateFormObjectIndex
      };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);
