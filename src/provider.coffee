
a = angular.module 'builder.provider', []

a.provider '$builder', ->
    # ----------------------------------------
    # providers
    # ----------------------------------------
    $injector = null

    # ----------------------------------------
    # properties
    # ----------------------------------------
    @components = {}

    # ----------------------------------------
    # private functions
    # ----------------------------------------
    @setupProviders = (injector) ->
        $injector = injector

    # ----------------------------------------
    # public functions
    # ----------------------------------------
    @addComponent = (name, component={}) ->


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupProviders $injector

        addComponent: @addComponent
    @get.$inject = ['$injector']
    @$get = @get
