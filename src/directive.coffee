
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
        <div class='fb-components'>
            <ul ng-if="groups.length > 1" class="nav nav-tabs nav-justified">
                <li ng-repeat="group in groups" ng-class="{active:status.activeGroup==group}">
                    <a href='#' ng-click="action.selectGroup($event, group)">{{group}}</a>
                </li>
            </ul>
            <div class='form-horizontal'>
                <div class='fb-component fb-draggable'
                    ng-repeat="component in components|filter:{group:status.activeGroup}"
                    fb-component="component"></div>
            </div>
        </div>
        """
    controller: 'fbComponentsController'
    link: (scope, element, attrs) ->

fbComponents.$inject = ['$injector']
a.directive 'fbComponents', fbComponents

# ----------------------------------------
# fb-component
# ----------------------------------------
fbComponent = ($injector) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        # providers
        $parse = $injector.get '$parse'
        $compile = $injector.get '$compile'

        # valuables
        component = $parse(attrs.fbComponent) scope
        cs = scope.$new()   # component scope

        $.extend cs, component
        view = $compile(component.template) cs
        $(element).html "<div class='fb-mock'></div>"
        $(element).append view
fbComponent.$inject = ['$injector']
a.directive 'fbComponent', fbComponent


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

