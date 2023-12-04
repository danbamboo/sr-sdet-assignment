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

  #Consumer-Driven-Pact to validate a successful call to get user (/user/1)
  def test_successful_pact_get_events
    puts "Running `User subscriptions exist for user ID` Contract Test"
      @success_response_body = "{\"id\":1,\"first_name\":\"Michael\",\"last_name\":\"Scott\"}"
    @parsed_success_response = JSON.parse(@success_response_body)

    user_service_pact
      .given("User subscriptions exist for user ID")
      .upon_receiving("A request for an user subscription")
      .with(method: :get, path: '/users/1')
      .will_respond_with(
        status: 200,
        headers: {'Content-Type' => 'application/json; charset=utf-8'},
        body: Pact.like(@parsed_success_response) )

    assert  UserServiceClient.new().get_user_success
  end

  #Consumer-Driven-Pact to validate a error call to get user (/user/0) 
  def test_error_pact_get_events
    puts "Running `User subscriptions do not exist for user ID` Contract Test"
    @failure_response_body = "{\"message\":\"User not found\"}"
    @parsed_failure_response = JSON.parse(@failure_response_body)

    user_service_pact
      .given("User subscriptions do not exist for user ID")
      .upon_receiving("A request for an user subscription")
      .with(method: :get, path: '/users/0')
      .will_respond_with(
        status: 404,
        headers: {'Content-Type' => 'application/json; charset=utf-8'},
        body: @parsed_failure_response )

    assert  UserServiceClient.new().get_user_fail
  end
end
