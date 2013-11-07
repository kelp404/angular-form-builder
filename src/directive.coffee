
a = angular.module 'builder.directive', ['builder.provider']

a.directive 'fbBuilder', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs) ->


a.directive 'fbComponents', ->
    restrict: 'A'
    link: (scope, element, attrs) ->

