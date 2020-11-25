require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
    
    test "Reject invalid group event name" do
        name = (0...40).map { ('a'..'z').to_a[rand(26)] }.join
        post '/events', params: { name: name }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Reject invalid group event location" do
        post '/events', params: { name: "Sport", location: "437dgdh" }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Reject invalid group event description" do
        post '/events', params: { name: "Sport", description: "h" }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Reject invalid start date" do
        post '/events', params: { name: "Sport", start: "2020-12-03 12:00:00" }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Reject invalid end date" do
        post '/events', params: { name: "Sport", end: "ey64tr" }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Reject invalid event duration" do
        post '/events', params: { name: "Sport", duration: "gfghd" }, xhr: true
        assert_includes( @response.body, "error")
    end

    test "Accept valid group event name" do
        post '/events', params: { name: "Sport" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Accept valid group event location" do
        post '/events', params: { name: "Sport", location: "Berlin" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Accept valid group event description" do
        post '/events', params: { name: "Sport", description: "This is event description" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Accept valid event start date" do
        post '/events', params: { name: "Sport", start: "2020-11-02 10:00:00" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Accept valid event end date" do
        post '/events', params: { name: "Sport", start: "2020-11-10 10:00:00" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Accept valid event duration" do
        post '/events', params: { name: "Sport", duration: "30" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "List all events" do
        get '/events', xhr: true
        assert_includes( @response.body, "success")
    end

    test "Show a group event" do
        get '/events/980190962', xhr: true
        assert_includes( @response.body, "success")
    end

    test "Update group event location" do
        put '/events/980190962', params: { name: "Sport", location: "London" }, xhr: true
        assert_includes( @response.body, "success")
    end

    test "Delete a group event" do
        delete '/events/980190962', xhr: true
        assert_includes( @response.body, "success")
    end

end
