
a = angular.module 'builder.directive', ['builder.provider']

a.directive 'fbBuilder', ->
    restrict: 'A'
    require: 'ngModel'  # builder data (the form information)
    link: (scope, element, attrs) ->
        name = attrs.fbBuilder


a.directive 'fbComponents', ->
    restrict: 'A'
    link: (scope, element, attrs) ->


a.directive 'fbForm', ->
    restrict: 'A'
    require: 'ngModel'  # form data (user input value)
    link: (scope, element, attrs) ->
        name = attrs.fbForm

