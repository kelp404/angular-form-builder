(function() {
  var a, copyObjectToScope, fbComponentController, fbComponentsController, fbFormController, fbFormObjectController, fbFormObjectEditableController;

  a = angular.module('builder.controller', ['builder.provider']);

  copyObjectToScope = function(object, scope) {
    /*
    Copy object (ng-repeat="object in objects") to scope without `hashKey`.
    */

    var key, value;
    for (key in object) {
      value = object[key];
      if (key !== '$$hashKey') {
        scope[key] = value;
      }
    }
  };

  fbFormObjectEditableController = function($scope, $injector) {
    var $builder;
    $builder = $injector.get('$builder');
    $scope.setupScope = function(formObject) {
      /*
      1. Copy origin formObject (ng-repeat="object in formObjects") to scope.
      2. Setup optionsText with formObject.options.
      3. Watch scope.label, .description, .placeholder, .required, .options then copy to origin formObject.
      4. Watch scope.optionsText then convert to scope.options.
      5. setup validationOptions
      */

      var component;
      copyObjectToScope(formObject, $scope);
      $scope.optionsText = formObject.options.join('\n');
      $scope.$watch('[label, description, placeholder, required, options, validation]', function() {
        formObject.label = $scope.label;
        formObject.description = $scope.description;
        formObject.placeholder = $scope.placeholder;
        formObject.required = $scope.required;
        formObject.options = $scope.options;
        return formObject.validation = $scope.validation;
      }, true);
      $scope.$watch('optionsText', function(text) {
        var x;
        $scope.options = (function() {
          var _i, _len, _ref, _results;
          _ref = text.split('\n');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            x = _ref[_i];
            if (x.length > 0) {
              _results.push(x);
            }
          }
          return _results;
        })();
        return $scope.inputText = $scope.options[0];
      });
      component = $builder.components[formObject.component];
      return $scope.validationOptions = component.validationOptions;
    };
    return $scope.data = {
      model: null,
      backup: function() {
        /*
        Backup input value.
        */

        return this.model = {
          label: $scope.label,
          description: $scope.description,
          placeholder: $scope.placeholder,
          required: $scope.required,
          optionsText: $scope.optionsText,
          validation: $scope.validation
        };
      },
      rollback: function() {
        /*
        Rollback input value.
        */

        if (!this.model) {
          return;
        }
        $scope.label = this.model.label;
        $scope.description = this.model.description;
        $scope.placeholder = this.model.placeholder;
        $scope.required = this.model.required;
        $scope.optionsText = this.model.optionsText;
        return $scope.validation = this.model.validation;
      }
    };
  };

  fbFormObjectEditableController.$inject = ['$scope', '$injector'];

  a.controller('fbFormObjectEditableController', fbFormObjectEditableController);

  fbComponentsController = function($scope, $injector) {
    var $builder;
    $builder = $injector.get('$builder');
    $scope.selectGroup = function($event, group) {
      var component, name, _ref, _results;
      if ($event != null) {
        $event.preventDefault();
      }
      $scope.activeGroup = group;
      $scope.components = [];
      _ref = $builder.components;
      _results = [];
      for (name in _ref) {
        component = _ref[name];
        if (component.group === group) {
          _results.push($scope.components.push(component));
        }
      }
      return _results;
    };
    $scope.groups = $builder.groups;
    $scope.activeGroup = $scope.groups[0];
    $scope.allComponents = $builder.components;
    return $scope.$watch('allComponents', function() {
      return $scope.selectGroup(null, $scope.activeGroup);
    });
  };

  fbComponentsController.$inject = ['$scope', '$injector'];

  a.controller('fbComponentsController', fbComponentsController);

  fbComponentController = function($scope) {
    return $scope.copyObjectToScope = function(object) {
      return copyObjectToScope(object, $scope);
    };
  };

  fbComponentController.$inject = ['$scope'];

  a.controller('fbComponentController', fbComponentController);

  fbFormController = function($scope, $injector) {
    var $builder, $timeout;
    $builder = $injector.get('$builder');
    $timeout = $injector.get('$timeout');
    if ($scope.input == null) {
      $scope.input = [];
    }
    return $scope.$watch('form', function() {
      if ($scope.input.length > $scope.form.length) {
        $scope.input.splice($scope.form.length);
      }
      return $timeout(function() {
        return $scope.$broadcast($builder.broadcastChannel.updateInput);
      });
    }, true);
  };

  fbFormController.$inject = ['$scope', '$injector'];

  a.controller('fbFormController', fbFormController);

  fbFormObjectController = function($scope, $injector) {
    var $builder;
    $builder = $injector.get('$builder');
    $scope.copyObjectToScope = function(object) {
      return copyObjectToScope(object, $scope);
    };
    return $scope.updateInput = function(value) {
      /*
      Copy current scope.input[X] to $parent.input.
      @param value: The input value.
      */

      var input;
      input = {
        id: $scope.formObject.id,
        label: $scope.formObject.label,
        value: value != null ? value : ''
      };
      return $scope.$parent.input.splice($scope.$index, 1, input);
    };
  };

  fbFormObjectController.$inject = ['$scope', '$injector'];

  a.controller('fbFormObjectController', fbFormObjectController);

}).call(this);

(function() {
  var a, fbBuilder, fbComponent, fbComponents, fbForm, fbFormObject, fbFormObjectEditable;

  a = angular.module('builder.directive', ['builder.provider', 'builder.controller', 'builder.drag', 'validator']);

  fbBuilder = function($injector) {
    return {
      restrict: 'A',
      template: "<div class='form-horizontal'>\n    <div class='fb-form-object-editable' ng-repeat=\"object in formObjects\"\n        fb-form-object-editable=\"object\"></div>\n</div>",
      link: function(scope, element, attrs) {
        var $builder, $drag, beginMove, _base, _name;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        scope.formName = attrs.fbBuilder;
        if ((_base = $builder.forms)[_name = scope.formName] == null) {
          _base[_name] = [];
        }
        scope.formObjects = $builder.forms[scope.formName];
        beginMove = true;
        $(element).addClass('fb-builder');
        return $drag.droppable($(element), {
          move: function(e) {
            var $empty, $formObject, $formObjects, height, index, offset, positions, _i, _j, _ref, _ref1;
            if (beginMove) {
              $("div.fb-form-object-editable").popover('hide');
              beginMove = false;
            }
            $formObjects = $(element).find('.fb-form-object-editable:not(.empty,.dragging)');
            if ($formObjects.length === 0) {
              if ($(element).find('.fb-form-object-editable.empty').length === 0) {
                $(element).find('>div:first').append($("<div class='fb-form-object-editable empty'></div>"));
              }
              return;
            }
            positions = [];
            positions.push(-1000);
            for (index = _i = 0, _ref = $formObjects.length; _i < _ref; index = _i += 1) {
              $formObject = $($formObjects[index]);
              offset = $formObject.offset();
              height = $formObject.height();
              positions.push(offset.top + height / 2);
            }
            positions.push(positions[positions.length - 1] + 1000);
            for (index = _j = 1, _ref1 = positions.length - 1; _j <= _ref1; index = _j += 1) {
              if (e.pageY > positions[index - 1] && e.pageY <= positions[index]) {
                $(element).find('.empty').remove();
                $empty = $("<div class='fb-form-object-editable empty'></div>");
                if (index - 1 < $formObjects.length) {
                  $empty.insertBefore($($formObjects[index - 1]));
                } else {
                  $empty.insertAfter($($formObjects[index - 2]));
                }
                break;
              }
            }
          },
          out: function() {
            if (beginMove) {
              $("div.fb-form-object-editable").popover('hide');
              beginMove = false;
            }
            return $(element).find('.empty').remove();
          },
          up: function(e, isHover, draggable) {
            var formObject, newIndex, oldIndex;
            beginMove = true;
            if (!$drag.isMouseMoved()) {
              $(element).find('.empty').remove();
              return;
            }
            if (!isHover && draggable.mode === 'drag') {
              formObject = draggable.object.formObject;
              if (formObject.editable) {
                $builder.removeFormObject(attrs.fbBuilder, formObject.index);
              }
            } else if (isHover) {
              if (draggable.mode === 'mirror') {
                $builder.insertFormObject(scope.formName, $(element).find('.empty').index('.fb-form-object-editable'), {
                  component: draggable.object.componentName
                });
              }
              if (draggable.mode === 'drag') {
                oldIndex = draggable.object.formObject.index;
                newIndex = $(element).find('.empty').index('.fb-form-object-editable');
                if (oldIndex < newIndex) {
                  newIndex--;
                }
                $builder.updateFormObjectIndex(scope.formName, oldIndex, newIndex);
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

  fbFormObjectEditable = function($injector) {
    return {
      restrict: 'A',
      controller: 'fbFormObjectEditableController',
      link: function(scope, element, attrs) {
        var $builder, $compile, $drag, $parse, $validator, component, formObject, popover, view;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        $validator = $injector.get('$validator');
        formObject = $parse(attrs.fbFormObjectEditable)(scope);
        component = $builder.components[formObject.component];
        scope.setupScope(formObject);
        view = $compile(component.template)(scope);
        $(element).append(view);
        $(element).on('click', function() {
          return false;
        });
        $drag.draggable($(element), {
          object: {
            formObject: formObject
          }
        });
        if (!formObject.editable) {
          return;
        }
        popover = {
          id: "fb-" + (Math.random().toString().substr(2)),
          isClickedSave: false,
          view: null,
          html: component.popoverTemplate
        };
        popover.html = $(popover.html).addClass(popover.id);
        scope.popover = {
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

            $event.preventDefault();
            $builder.removeFormObject(scope.formName, scope.$index);
            $(element).popover('hide');
          },
          shown: function() {
            /*
            The shown event of the popover.
            */

            scope.data.backup();
            return popover.isClickedSave = false;
          },
          cancel: function($event) {
            /*
            The cancel event of the popover.
            */

            scope.data.rollback();
            if ($event) {
              $event.preventDefault();
              $(element).popover('hide');
            }
          }
        };
        popover.view = $compile(popover.html)(scope);
        $(element).addClass(popover.id);
        $(element).popover({
          html: true,
          title: component.label,
          content: popover.view,
          container: 'body'
        });
        $(element).on('show.bs.popover', function() {
          var $popover, elementOrigin, popoverTop;
          if ($drag.isMouseMoved()) {
            return false;
          }
          $("div.fb-form-object-editable:not(." + popover.id + ")").popover('hide');
          $popover = $("form." + popover.id).closest('.popover');
          if ($popover.length > 0) {
            elementOrigin = $(element).offset().top + $(element).height() / 2;
            popoverTop = elementOrigin - $popover.height() / 2;
            $popover.css({
              position: 'absolute',
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
          $(".popover ." + popover.id + " input:first").select();
          scope.$apply(function() {
            return scope.popover.shown();
          });
        });
        return $(element).on('hide.bs.popover', function() {
          var $popover;
          $popover = $("form." + popover.id).closest('.popover');
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

  fbFormObjectEditable.$inject = ['$injector'];

  a.directive('fbFormObjectEditable', fbFormObjectEditable);

  fbComponents = function() {
    return {
      restrict: 'A',
      template: "<ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n    <li ng-repeat=\"group in groups\" ng-class=\"{active:activeGroup==group}\">\n        <a href='#' ng-click=\"selectGroup($event, group)\">{{group}}</a>\n    </li>\n</ul>\n<div class='form-horizontal'>\n    <div class='fb-component' ng-repeat=\"component in components\"\n        fb-component=\"component\"></div>\n</div>",
      controller: 'fbComponentsController'
    };
  };

  a.directive('fbComponents', fbComponents);

  fbComponent = function($injector) {
    return {
      restrict: 'A',
      controller: 'fbComponentController',
      link: function(scope, element, attrs) {
        var $builder, $compile, $drag, $parse, component, view;
        $builder = $injector.get('$builder');
        $drag = $injector.get('$drag');
        $parse = $injector.get('$parse');
        $compile = $injector.get('$compile');
        component = $parse(attrs.fbComponent)(scope);
        scope.copyObjectToScope(component);
        $drag.draggable($(element), {
          mode: 'mirror',
          defer: false,
          object: {
            componentName: component.name
          }
        });
        view = $compile(component.template)(scope);
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
      scope: {
        input: '=ngModel'
      },
      template: "<div class='fb-form-object' ng-repeat=\"object in form\" fb-form-object=\"object\"></div>",
      controller: 'fbFormController',
      link: function(scope, element, attrs) {
        var $builder;
        $builder = $injector.get('$builder');
        scope.formName = attrs.fbForm;
        return scope.form = $builder.forms[attrs.fbForm];
      }
    };
  };

  fbForm.$inject = ['$injector'];

  a.directive('fbForm', fbForm);

  fbFormObject = function($injector) {
    return {
      restrict: 'A',
      controller: 'fbFormObjectController',
      link: function(scope, element, attrs) {
        var $builder, $compile, $input, $parse, $template, component, view;
        $builder = $injector.get('$builder');
        $compile = $injector.get('$compile');
        $parse = $injector.get('$parse');
        scope.formObject = $parse(attrs.fbFormObject)(scope);
        component = $builder.components[scope.formObject.component];
        scope.$on($builder.broadcastChannel.updateInput, function() {
          return scope.updateInput(scope.inputText);
        });
        if (component.arrayToText) {
          scope.inputArray = [];
          scope.$watch('inputArray', function(newValue, oldValue) {
            var checked, index;
            if (newValue === oldValue) {
              return;
            }
            checked = [];
            for (index in scope.inputArray) {
              if (scope.inputArray[index]) {
                checked.push(scope.options[index]);
              }
            }
            return scope.inputText = checked.join(', ');
          }, true);
        }
        scope.$watch('inputText', function() {
          return scope.updateInput(scope.inputText);
        });
        scope.$watch(attrs.fbFormObject, function() {
          return scope.copyObjectToScope(scope.formObject);
        }, true);
        $template = $(component.template);
        $input = $template.find("[ng-model='inputText']");
        $input.attr({
          validator: '{{validation}}'
        });
        view = $compile($template)(scope);
        $(element).append(view);
        if (!component.arrayToText && scope.formObject.options.length > 0) {
          return scope.inputText = scope.formObject.options[0];
        }
      }
    };
  };

  fbFormObject.$inject = ['$injector'];

  a.directive('fbFormObject', fbFormObject);

}).call(this);

(function() {
  var a;

  a = angular.module('builder.drag', []);

  a.provider('$drag', function() {
    var $injector, $rootScope, delay,
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
    this.setupEasing = function() {
      return jQuery.extend(jQuery.easing, {
        easeOutQuad: function(x, t, b, c, d) {
          return -c * (t /= d) * (t - 2) + b;
        }
      });
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
    delay = function(ms, func) {
      return setTimeout(function() {
        return func();
      }, ms);
    };
    this.autoScroll = {
      up: false,
      down: false,
      scrolling: false,
      scroll: function() {
        _this.autoScroll.scrolling = true;
        if (_this.autoScroll.up) {
          $('html, body').dequeue().animate({
            scrollTop: $(window).scrollTop() - 50
          }, 100, 'easeOutQuad');
          return delay(100, function() {
            return _this.autoScroll.scroll();
          });
        } else if (_this.autoScroll.down) {
          $('html, body').dequeue().animate({
            scrollTop: $(window).scrollTop() + 50
          }, 100, 'easeOutQuad');
          return delay(100, function() {
            return _this.autoScroll.scroll();
          });
        } else {
          return _this.autoScroll.scrolling = false;
        }
      },
      start: function(e) {
        if (e.clientY < 50) {
          _this.autoScroll.up = true;
          _this.autoScroll.down = false;
          if (!_this.autoScroll.scrolling) {
            return _this.autoScroll.scroll();
          }
        } else if (e.clientY > $(window).innerHeight() - 50) {
          _this.autoScroll.up = false;
          _this.autoScroll.down = true;
          if (!_this.autoScroll.scrolling) {
            return _this.autoScroll.scroll();
          }
        } else {
          _this.autoScroll.up = false;
          return _this.autoScroll.down = false;
        }
      },
      stop: function() {
        _this.autoScroll.up = false;
        return _this.autoScroll.down = false;
      }
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
          _this.autoScroll.start(e);
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
          $clone.remove();
          return _this.autoScroll.stop();
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
          _this.autoScroll.start(e);
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
          $element.removeClass('dragging defer-dragging');
          return _this.autoScroll.stop();
        };
        if (!defer) {
          return _this.hooks.move.drag(e, defer);
        }
      });
      return result;
    };
    this.dropMode = function($element, options) {
      var result;
      result = {
        id: _this.getNewId(),
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
          move: The custom mouse move callback. (e, draggable)->
          up: The custom mouse up callback. (e, isHover, draggable)->
          out: The custom mouse out callback. (e, draggable)->
      */

      result = [];
      for (_i = 0, _len = $element.length; _i < _len; _i++) {
        element = $element[_i];
        droppable = _this.dropMode($(element), options);
        result.push(droppable);
        _this.data.droppables[droppable.id] = droppable;
      }
      return result;
    };
    this.get = function($injector) {
      this.setupEasing();
      this.setupProviders($injector);
      return {
        isMouseMoved: this.isMouseMoved,
        data: this.data,
        draggable: this.draggable,
        droppable: this.droppable
      };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);

(function() {
  angular.module('builder', ['builder.directive']);

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
    var _this = this;
    this.version = '0.0.1';
    this.components = {};
    this.groups = [];
    this.broadcastChannel = {
      updateInput: '$updateInput'
    };
    this.forms = {
      "default": []
    };
    this.formsId = {
      "default": 0
    };
    this.convertComponent = function(name, component) {
      var result, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      result = {
        name: name,
        group: (_ref = component.group) != null ? _ref : 'Default',
        label: (_ref1 = component.label) != null ? _ref1 : '',
        description: (_ref2 = component.description) != null ? _ref2 : '',
        placeholder: (_ref3 = component.placeholder) != null ? _ref3 : '',
        editable: (_ref4 = component.editable) != null ? _ref4 : true,
        required: (_ref5 = component.required) != null ? _ref5 : false,
        validation: (_ref6 = component.validation) != null ? _ref6 : '/.*/',
        validationOptions: (_ref7 = component.validationOptions) != null ? _ref7 : [],
        options: (_ref8 = component.options) != null ? _ref8 : [],
        arrayToText: (_ref9 = component.arrayToText) != null ? _ref9 : false,
        template: component.template,
        popoverTemplate: component.popoverTemplate
      };
      if (!result.template) {
        console.error("The template is empty.");
      }
      if (!result.popoverTemplate) {
        console.error("The popoverTemplate is empty.");
      }
      return result;
    };
    this.convertFormObject = function(name, formObject) {
      var component, exist, form, result, _i, _len, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      if (formObject == null) {
        formObject = {};
      }
      component = this.components[formObject.component];
      if (component == null) {
        throw "The component " + formObject.component + " was not registered.";
      }
      if (formObject.id) {
        exist = false;
        _ref = this.forms[name];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          form = _ref[_i];
          if (!(formObject.id <= form.id)) {
            continue;
          }
          formObject.id = this.formsId[name]++;
          exist = true;
          break;
        }
        if (!exist) {
          this.formsId[name] = formObject.id + 1;
        }
      }
      result = {
        id: (_ref1 = formObject.id) != null ? _ref1 : this.formsId[name]++,
        component: formObject.component,
        editable: (_ref2 = formObject.editable) != null ? _ref2 : component.editable,
        index: (_ref3 = formObject.index) != null ? _ref3 : 0,
        label: (_ref4 = formObject.label) != null ? _ref4 : component.label,
        description: (_ref5 = formObject.description) != null ? _ref5 : component.description,
        placeholder: (_ref6 = formObject.placeholder) != null ? _ref6 : component.placeholder,
        options: (_ref7 = formObject.options) != null ? _ref7 : component.options,
        required: (_ref8 = formObject.required) != null ? _ref8 : component.required,
        validation: (_ref9 = formObject.validation) != null ? _ref9 : component.validation
      };
      return result;
    };
    this.reindexFormObject = function(name) {
      var formObjects, index, _i, _ref;
      formObjects = _this.forms[name];
      for (index = _i = 0, _ref = formObjects.length; _i < _ref; index = _i += 1) {
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
          group: {string} The component group.
          label: {string} The label of the input.
          description: {string} The description of the input.
          placeholder: {string} The placeholder of the input.
          editable: {bool} Is the form object editable?
          required: {bool} Is the form object required?
          validation: {string} angular-validator. "/regex/" or "[rule1, rule2]". (default is RegExp(.*))
          validationOptions: {array} [{rule: angular-validator, label: 'option label'}] the options for the validation. (default is [])
          options: {array} The input options.
          arrayToText: {bool} checkbox could use this to convert input (default is no)
          template: {string} html template
          popoverTemplate: {string} html template
      */

      if (_this.components[name] == null) {
        newComponent = _this.convertComponent(name, component);
        _this.components[name] = newComponent;
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
      Insert the form object into the form at last.
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      return _this.insertFormObject(name, _this.forms[name].length, formObject);
    };
    this.insertFormObject = function(name, index, formObject) {
      var _base, _base1;
      if (formObject == null) {
        formObject = {};
      }
      /*
      Insert the form object into the form at {index}.
      @param name: The form name.
      @param index: The form object index.
      @param form: The form object.
          component: {string} The component name
          editable: {bool} Is the form object editable? (default is yes)
          label: {string} The form object label.
          description: {string} The form object description.
          placeholder: {string} The form object placeholder.
          options: {array} The form object options.
          required: {bool} Is the form object required? (default is no)
          validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
          [id]: {int} The form object id. It will be generate by $builder.
          [index]: {int} The form object index. It will be updated by $builder.
      */

      if ((_base = _this.forms)[name] == null) {
        _base[name] = [];
      }
      if ((_base1 = _this.formsId)[name] == null) {
        _base1[name] = 0;
      }
      if (index > _this.forms[name].length) {
        index = _this.forms[name].length;
      } else if (index < 0) {
        index = 0;
      }
      _this.forms[name].splice(index, 0, _this.convertFormObject(name, formObject));
      return _this.reindexFormObject(name);
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
      return _this.reindexFormObject(name);
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
      return _this.reindexFormObject(name);
    };
    this.get = function() {
      return {
        version: this.version,
        components: this.components,
        groups: this.groups,
        forms: this.forms,
        broadcastChannel: this.broadcastChannel,
        registerComponent: this.registerComponent,
        addFormObject: this.addFormObject,
        insertFormObject: this.insertFormObject,
        removeFormObject: this.removeFormObject,
        updateFormObjectIndex: this.updateFormObjectIndex
      };
    };
    this.$get = this.get;
  });

}).call(this);
