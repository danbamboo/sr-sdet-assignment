require "test_helper"
require './test/contract-testing/user/user_service_client'


class UserServiceClientTestPact < Minitest::Test
  include Pact::Consumer::Minitest

  Pact.configure do |config|
    config.pact_dir = '../assignment_submission/contract_pacts'
  end

  Pact.service_consumer "dashboard_api" do  # register a consumer with pact
    has_pact_with "user_service" do   # register the provider that has the pact
      mock_service :user_service_pact do # register the mock service that will run and pretend to be the provider
        port 8003
      end
    end
  end

  def test_successful_pact_get_events
    @success_response_body = "{\"id\":1,\"first_name\":\"Michael\",\"last_name\":\"Scott\"}"
    @parsed_success_response = JSON.parse(@success_response_body)

    user_service_pact
      .given("User subscriptions exist for user ID")
      .upon_receiving("A request for an user subscription")
      .with(method: :get, path: '/user/1')
      .will_respond_with(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_success_response )

    assert  UserServiceClient.new().get_user_success
  end

  def test_error_pact_get_events
    @failure_response_body = "{\"message\":\"User not found\"}"
    @parsed_failure_response = JSON.parse(@failure_response_body)

    user_service_pact
      .given("User subscriptions do not exist for user ID")
      .upon_receiving("A request for an user subscription")
      .with(method: :get, path: '/user/0')
      .will_respond_with(
        status: 404,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_failure_response )

    assert  UserServiceClient.new().get_user_fail
  end
end




# class Contract::UserPactTest < ActiveSupport::TestCase

# describe UserServiceClient, :pact => true do
#   include Pact::Consumer::Minitest

#   def setup
#     @user_service = Api::UserService.new(1)
#   end

#   describe "get_user" do
#     before do
#       animal_service.given("an user event exists").
#         upon_receiving("a request for an user event").
#         with(method: :get, path: '/event', query: 'user_id=2').
#         will_respond_with(
#           status: 200,
#           headers: {'Content-Type' => 'application/json'},
#           body: {name: 'Betty'} )
#     end

#     it "returns an event" do
#       expect(subject.get_cal_event).to eq(UserService.new('Betty'))
#     end
#   end
# end






#   include Pact::Consumer::Minitest
#   Pact.service_consumer "dashboard_api" do  # register a consumer with pact
#     has_pact_with "user_service" do   # register the provider that has the pact
#       mock_service :user_service do # register the mock service that will run and pretend to be the provider
#         port 8000
#       end
#     end
#   end

#   Pact.configure do |config|
#     config.pact_dir = './test/pacts'
#   end

#   def test_pact
#     user_service
#       .given('a user event exists')
#       .upon_receiving('a request for user event')
#       .with(method: :get, path: '/event', query: 'user_id=2')
#       .will_respond_with(status: 200)

#     HTTPClient.new.get_content('http://localhost:8000')
#   end
# end



