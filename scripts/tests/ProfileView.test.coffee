Backbone = require "backbone"
Application = require "../Application.coffee"
ProfileView = require "../views/ProfileView.coffee"

class MockFeeds extends Backbone.Collection
    fetch: ->


config =
    profileCMD:
        id: "profile"
        name: "Profile"
        type: "webWindow"
        url: "http://profile.example.com"
    passwordCMD:
        id: "changepassword"
        name: "Change password"
        type: "webWindow"
        url: "http://password.example.com"
    settingsCMD:
        id: "settings"
        name: "System settings"
        type: "custom"
        command: "gnome-control-center"

describe "ProfileView", ->

    describe "with basic contents", ->
        view = null
        beforeEach ->
            view = new ProfileView
                user: new Backbone.Model(fullName: "John Doe")
                config: new Backbone.Model config
                feeds: new MockFeeds

            view.render()

        afterEach ->
            view.remove()

        it "should display user's fullname", ->
            expect(view.$el).to.contain("John Doe")

        it "should have profile settings button", ->
            expect(view.$el).to.have(".item-profile")

        it "should have change password button", ->
            expect(view.$el).to.have(".item-changepassword")

        describe "my profile button", ->
            it "emits open-app for profile edit on profile button click", (done) ->
                view.once "open-app", (model) ->
                    expect(model.get("url")).to.eq "http://profile.example.com"
                    expect(model.get("type")).to.eq "webWindow"
                    done()
                view.profile.$el.click()

        describe "password button", ->
            it "emits open-app for password edit on password button click", (done) ->
                view.once "open-app", (model) ->
                    expect(model.get("url")).to.eq "http://password.example.com"
                    expect(model.get("type")).to.eq "webWindow"
                    done()
                view.password.$el.click()

        describe "settings button", ->
            it "emits open-app for system settings on settings button click", (done) ->
                view.once "open-app", (model) ->
                    expect(model.get("command")).to.eq "gnome-control-center"
                    expect(model.get("type")).to.eq "custom"
                    done()
                view.settings.$el.click()


    describe "with missing changePasswordUrl&profileUrl", ->

        view = null
        after -> view.remove()
        before ->
            view = new ProfileView
                user: new Backbone.Model(fullName: "John Doe")
                feeds: new MockFeeds
                config: new Backbone.Model
                    passwordCMD: null
                    profileCMD: null
                    settingsCMD:
                        name: "System settings"
                        type: "custom"
                        command: "gnome-control-center"
            view.render()

        it "should not have profile settings button", ->
            expect(view.profile).to.be.not.ok

        it "should not have change password button", ->
            expect(view.password).to.be.not.ok


