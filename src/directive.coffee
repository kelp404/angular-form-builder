
a = angular.module 'builder.directive', ['builder.provider', 'builder.controller']

# ----------------------------------------
# fb-builder
# ----------------------------------------
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


# ----------------------------------------
# fb-components
# ----------------------------------------
fbComponents = ($injector) ->
    restrict: 'A'
    template:
        """
        <ul class="nav nav-tabs nav-justified">
            <li ng-repeat="(group, component) in components" ng-class="{active:$first}"><a>{{group}}</a></li>
        </ul>
        <div ng-repeat="component in components">{{component}}</div>
        """
    controller: 'fbComponentsController'
    link: (scope, element, attrs) ->

fbComponents.$inject = ['$injector']
a.directive 'fbComponents', fbComponents


# ----------------------------------------
# fb-form
# ----------------------------------------
fbForm = ($injector) ->
    restrict: 'A'
    require: 'ngModel'  # form data (user input value)
    link: (scope, element, attrs) ->
        name = attrs.fbForm

fbForm.$inject = ['$injector']
a.directive 'fbForm', fbForm

