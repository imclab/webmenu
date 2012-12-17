define [
  "backbone.viewmaster"

  "cs!app/application"
  "cs!app/views/menuitem_view"
  "hbs!app/templates/menulist"
], (
  ViewMaster

  Application
  MenuItemView
  template
) ->
  class MenuListView extends ViewMaster

    className: "bb-menu"

    template: template

    constructor: (opts) ->
      super

      @initial = @model
      @setCurrent()
      @startApp = null
      @startAppIndex = 0

      @listenTo Application.global, "select", (model) =>
        if model.get("type") is "menu"
          @model = model
          @setCurrent()
          @refreshViews()

      if FEATURE_SEARCH
        @listenTo Application.global, "search", (filter) =>
          if filter.trim()
            @setItems @collection.searchFilter(filter)
            @setStartApplication(0)
          else
            @setCurrent()
          @refreshViews()

        @listenTo Application.global, "startApplication",  =>
          if @startApp?.model
            Application.bridge.trigger "open", @startApp.model.toJSON()
            @startApp = null

        @listenTo Application.global, "nextStartApplication", =>
          @setStartApplication(@startAppIndex + 1)

    setRoot: ->
      @setItems(@initial.items.toArray())

    setCurrent: ->
      @setItems(@model.items.toArray())

    setItems: (models) ->
      @setView ".menu-app-list", models.map (model) ->
        new MenuItemView
          model: model

    setStartApplication: (index) ->
      @startApp.hideSelectHighlight() if @startApp
      @startAppIndex = index
      @startApp = @getViews(".menu-app-list")?[@startAppIndex]
      @startApp.displaySelectHighlight()
