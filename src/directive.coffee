
a = angular.module 'builder.directive', ['builder.provider']

fbBuilder = ($injector) ->
    restrict: 'A'
    require: 'ngModel'  # builder data (the form information)
    link: (scope, element, attrs) ->
        # ----------------------------------------
        # providers
        # ----------------------------------------
        $parse = $injector.get '$parse'

        # ----------------------------------------
        # valuables
        # ----------------------------------------
        model = $parse attrs.ngModel
        name = attrs.fbBuilder


fbBuilder.$inject = ['$injector']
a.directive 'fbBuilder', fbBuilder


a.directive 'fbComponents', ->
    restrict: 'A'
    link: (scope, element, attrs) ->


a.directive 'fbForm', ->
    restrict: 'A'
    require: 'ngModel'  # form data (user input value)
    link: (scope, element, attrs) ->
        name = attrs.fbForm

