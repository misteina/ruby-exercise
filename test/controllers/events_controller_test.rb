require 'test_helper'
require 'json'
require 'date'

class EventsControllerTest < ActionDispatch::IntegrationTest

    test "Reject invalid group event name" do
        post '/events', params: { name: "*@!>646rttr7" }, xhr: true
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
        post '/events', params: { name: "Sport", eventstart: "jfhfhr6r" }, xhr: true
        assert_nil( JSON.parse(@response.body)["content"]["eventstart"], nil)
    end

    test "Reject invalid end date" do
        post '/events', params: {name: "Sport", eventend: "ey64tr" }, xhr: true
        assert_nil( JSON.parse(@response.body)["content"]["eventend"], nil)
    end

    test "Reject invalid event duration" do
        post '/events', params: { name: "Sport", duration: "gfghd" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["duration"], 0)
    end

    test "Accept valid group event name" do
        post '/events', params: { name: "Sport" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["name"], "Sport")
    end

    test "Accept valid group event location" do
        post '/events', params: { name: "Sport", location: "Berlin" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["location"], "Berlin")
    end

    test "Accept valid group event description" do
        post '/events', params: { name: "Sport", description: "This is event description" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["description"], "This is event description")
    end

    test "Accept valid event start date" do
        post '/events', params: { name: "Sport", eventstart: "2020-11-02 10:00:00" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["eventstart"], "2020-11-02T10:00:00.000Z")
    end

    test "Accept valid event end date" do
        post '/events', params: { name: "Sport", eventend: "2020-11-10 10:00:00" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["eventend"], "2020-11-10T10:00:00.000Z")
    end

    test "Accept valid event duration" do
        post '/events', params: { name: "Sport", duration: "30" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["duration"], 30)
    end

    test "List all events" do
        get '/events', xhr: true
        assert_includes( @response.body, "success")
    end

    test "Show a group event" do
        event = group_events(:one)
        get '/events/' + event.id.to_s, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["id"], 980190962)
    end

    test "Update group event name" do
        event = group_events(:one)
        put '/events/' + event.id.to_s, params: { name: "Singing" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["name"], "Singing")
    end

    test "Update group event location" do
        event = group_events(:one)
        put '/events/' + event.id.to_s, params: { location: "London" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["location"], "London")
    end

    test "Update group event description" do
        event = group_events(:one)
        put '/events/' + event.id.to_s, params: { description: "New description" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["description"], "New description")
    end

    test "Update group event start time" do
        event = group_events(:one)
        put '/events/' + event.id.to_s, params: { eventstart: "2020-08-12 12:00:00" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["eventstart"], "2020-08-12T12:00:00.000Z")
    end

    test "Update group event end time" do
        event = group_events(:one)
        put '/events/' + event.id.to_s, params: { eventend: "2020-08-15 12:00:00" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["eventend"], "2020-08-15T12:00:00.000Z")
    end

    test "Reject Event start time greater than event end time" do
        post '/events', params: { name: "Sport", eventstart: "2020-08-15 12:00:00", eventend: "2020-08-08 12:00:00" }, xhr: true
        
        assert_equal(JSON.parse(@response.body)["content"], "Invalid start and end time")
    end

    test "Calculate duration from event start and end times" do
        eventStart = "2020-08-15 12:00:00"
        eventEnd = "2020-08-29 12:00:00"
        post '/events', params: { name: "Sport", eventstart: eventStart, eventend: eventEnd }, xhr: true
        startDate = DateTime.parse(eventStart)
        endDate = DateTime.parse(eventEnd)
        assert_equal(JSON.parse(@response.body)["content"]["duration"], (endDate - startDate).to_i)
    end

    test "Calculate event end from event start and duration" do
        eventStart = "2020-08-15 12:00:00"
        duration = 30
        post '/events', params: { name: "Sport", eventstart: eventStart, duration: duration }, xhr: true
        endDate = DateTime.parse(eventStart).next_day(duration).strftime("%Y-%m-%d %I:%M:%S")
        assert_equal(JSON.parse(@response.body)["content"]["eventend"].sub!("T", " ").chomp(".000Z"), endDate)
    end

    test "Calulate event start from event end and duration" do
        eventEnd = "2020-08-15 12:00:00"
        duration = 30
        endDate = DateTime.parse(eventEnd)
        eventStart = (endDate - duration).strftime("%Y-%m-%d %I:%M:%S")
        post '/events', params: { name: "Sport", eventend: eventEnd, duration: duration }, xhr: true
        assert_equal(JSON.parse(@response.body)["content"]["eventstart"].sub!("T", " ").chomp(".000Z"), eventStart)
    end

    test "Mark as Published or Draft" do
        post '/events', params: { name: "Sport", location: "Madrid", description: "The description" }, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["status"], "Draft")
        put '/events/' + group_events(:one).id.to_s, params: { eventstart: "2020-09-10 12:00:00", eventend: "2020-09-12 12:00:00"}, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["status"], "Published")
    end

    test "Delete a group event" do
        event = group_events(:one)
        delete '/events/' + event.id.to_s, xhr: true
        assert_equal( JSON.parse(@response.body)["content"]["status"], "Deleted")
    end

end
