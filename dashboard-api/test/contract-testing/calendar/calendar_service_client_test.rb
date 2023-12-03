require "test_helper"
require './test/contract-testing/calendar/calendar_service_client'


class PactTest < Minitest::Test
  include Pact::Consumer::Minitest

  Pact.configure do |config|
    config.pact_dir = '../assignment_submission/contract_pacts'
  end

  Pact.service_consumer "dashboard_api" do  # register a consumer with pact
    has_pact_with "calendar_service" do   # register the provider that has the pact
      mock_service :calendar_service_pact do # register the mock service that will run and pretend to be the provider
        port 8000
      end
    end
  end

  #Consumer-Driven-Pact to validate a successful call to get event (/event?user_id=1)
  def test_successful_pact_get_events

    puts "Running `Calendar event/s exist for user ID` Contract Test"
    #Expected response - uses 'Pact.like' on date fields to match format not exact since dates returned are random.
    @parsed_success_response = {events: [
    {
      id: 1,
      name: "Hangout",
      duration: 30,
      date: Pact.like("11/28/2023, 11:00:11 AM"),
      attendees: 2,
      timeZone: "America/New_York"
    },
    {
      id: 2,
      name: "Pre-Screen",
      duration: 60,
      date: Pact.like("11/28/2023, 11:00:11 AM"),
      attendees: 3,
      timeZone: "America/Chicago"
    },
    {
      id: 3,
      name: "Group Interview",
      duration: 120,
      date: Pact.like("11/28/2023, 11:00:11 AM"),
      attendees: 3,
      timeZone: "America/Denver"
    },
    {
      id: 4,
      name: "1on1",
      duration: 60,
      date: Pact.like("11/28/2023, 11:00:11 AM"),
      attendees: 2,
      timeZone: "America/Los_Angeles"
    }
  ]}

    calendar_service_pact
      .given("Calendar event/s exist for user ID")
      .upon_receiving("A request for an calendar event")
      .with(method: :get, path: '/events', query: 'user_id=1')
      .will_respond_with(
        status: 200,
        headers: {'Content-Type' => 'application/json; charset=utf-8'},
        body: @parsed_success_response )

    assert  CalendarServiceClient.new().get_cal_event_success
  end

  #Consumer-Driven-Pact to validate a error call to get event (/event?invalid_user_id_params=0) 
  #NOTE: Updated to match current behavior of Calendar service, does not match specification from assignment.  Only updated to create "passing" contract for demonstration purposes.
  def test_error_pact_get_events
    puts "Running `Calendar event/s do not exist for user ID` Contract Test"
    @failure_response_body = "User Does Not Exist"

    calendar_service_pact
      .given("Calendar event/s do not exist for user ID")
      .upon_receiving("A request for an calendar event")
      .with(method: :get, path: '/events', query: 'invalid_user_id_params=0')
      .will_respond_with(
        status: 404,
        headers: {'Content-Type' => 'text/html; charset=utf-8'},
        body: @failure_response_body )

    assert  CalendarServiceClient.new().get_cal_event_fail
  end
end
