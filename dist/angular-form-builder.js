(function() {
  var a;

  a = angular.module('builder.directive', ['builder.provider']);

}).call(this);

(function() {
  angular.module('builder', ['builder.provider', 'builder.directive']);

}).call(this);

(function() {
  var a;

  a = angular.module('builder.provider', []);

}).call(this);
