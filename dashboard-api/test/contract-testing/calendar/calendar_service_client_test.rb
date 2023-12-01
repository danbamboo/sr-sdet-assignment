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

  def test_successful_pact_get_events
    @success_response_body = "{\"events\":[{\"id\":1,\"name\":\"Hangout\",\"duration\":30,\"date\":\"10/1/2023, 12:00:02 PM\",\"attendees\":2,\"timeZone\":\"America/New_York\"},{\"id\":2,\"name\":\"Pre-Screen\",\"duration\":60,\"date\":\"9/29/2023, 1:00:02 PM\",\"attendees\":3,\"timeZone\":\"America/Chicago\"},{\"id\":3,\"name\":\"Group Interview\",\"duration\":120,\"date\":\"9/30/2023, 2:00:02 PM\",\"attendees\":3,\"timeZone\":\"America/Denver\"},{\"id\":4,\"name\":\"1on1\",\"duration\":60,\"date\":\"10/8/2023, 9:00:02 AM\",\"attendees\":2,\"timeZone\":\"America/Los_Angeles\"}]}"
    @parsed_success_response = JSON.parse(@success_response_body)

    calendar_service_pact
      .given("Calendar event/s exist for user ID")
      .upon_receiving("A request for an calendar event")
      .with(method: :get, path: '/events', query: 'user_id=1')
      .will_respond_with(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_success_response )

    assert  CalendarServiceClient.new().get_cal_event_success
  end

  def test_error_pact_get_events
    @failure_response_body = "{\"message\":\"No events found for user_id [1]\"}"
    @parsed_failure_response = JSON.parse(@failure_response_body)

    calendar_service_pact
      .given("Calendar event/s do not exist for user ID")
      .upon_receiving("A request for an calendar event")
      .with(method: :get, path: '/events', query: 'user_id=0')
      .will_respond_with(
        status: 404,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_failure_response )

    assert  CalendarServiceClient.new().get_cal_event_fail
  end
end




# class Contract::CalendarPactTest < ActiveSupport::TestCase

# describe CalendarServiceClient, :pact => true do
#   include Pact::Consumer::Minitest

#   def setup
#     @calendar_service = Api::CalendarService.new(1)
#   end

#   describe "get_calendar" do
#     before do
#       animal_service.given("an calendar event exists").
#         upon_receiving("a request for an calendar event").
#         with(method: :get, path: '/event', query: 'user_id=2').
#         will_respond_with(
#           status: 200,
#           headers: {'Content-Type' => 'application/json'},
#           body: {name: 'Betty'} )
#     end

#     it "returns an event" do
#       expect(subject.get_cal_event).to eq(CalendarService.new('Betty'))
#     end
#   end
# end






#   include Pact::Consumer::Minitest
#   Pact.service_consumer "dashboard_api" do  # register a consumer with pact
#     has_pact_with "calendar_service" do   # register the provider that has the pact
#       mock_service :calendar_service do # register the mock service that will run and pretend to be the provider
#         port 8000
#       end
#     end
#   end

#   Pact.configure do |config|
#     config.pact_dir = './test/pacts'
#   end

#   def test_pact
#     calendar_service
#       .given('a calendar event exists')
#       .upon_receiving('a request for calendar event')
#       .with(method: :get, path: '/event', query: 'user_id=2')
#       .will_respond_with(status: 200)

#     HTTPClient.new.get_content('http://localhost:8000')
#   end
# end



