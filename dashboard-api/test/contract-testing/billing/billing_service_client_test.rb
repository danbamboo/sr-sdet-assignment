require "test_helper"
require './test/contract-testing/billing/billing_service_client'


class BillingServiceClientTestPact < Minitest::Test
  include Pact::Consumer::Minitest

  Pact.configure do |config|
    config.pact_dir = '../assignment_submission/contract_pacts'
  end

  Pact.service_consumer "dashboard_api" do  # register a consumer with pact
    has_pact_with "billing_service" do   # register the provider that has the pact
      mock_service :billing_service_pact do # register the mock service that will run and pretend to be the provider
        port 8001
      end
    end
  end

  #Consumer-Driven-Pact to validate a successful call to get billing subscription (/subscriptions?user_id=1)
  def test_successful_pact_get_events
    @success_response_body = "{\"user_id\": 1, \"renewal_date\": \"11/03/2023\", \"price_cents\": 1500}"
    @parsed_success_response = JSON.parse(@success_response_body)

    billing_service_pact
      .given("Billing subscriptions exist for user ID")
      .upon_receiving("A request for an billing subscription")
      .with(method: :get, path: '/subscriptions', query: 'user_id=1')
      .will_respond_with(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_success_response )

    assert  BillingServiceClient.new().get_billing_subscriptions_success
  end

  #Consumer-Driven-Pact to validate a error call to get billing subscription (/subscriptions?user_id=0) 
  def test_error_pact_get_events
    @failure_response_body = "{\"message\": \"No subscription found for user_id [0]\"}"
    @parsed_failure_response = JSON.parse(@failure_response_body)

    billing_service_pact
      .given("Billing subscriptions do not exist for user ID")
      .upon_receiving("A request for an billing subscription")
      .with(method: :get, path: '/subscriptions', query: 'user_id=0')
      .will_respond_with(
        status: 404,
        headers: {'Content-Type' => 'application/json'},
        body: @parsed_failure_response )

    assert  BillingServiceClient.new().get_billing_subscriptions_fail
  end
end




# class Contract::BillingPactTest < ActiveSupport::TestCase

# describe BillingServiceClient, :pact => true do
#   include Pact::Consumer::Minitest

#   def setup
#     @billing_service = Api::BillingService.new(1)
#   end

#   describe "get_billing" do
#     before do
#       animal_service.given("an billing event exists").
#         upon_receiving("a request for an billing event").
#         with(method: :get, path: '/event', query: 'user_id=2').
#         will_respond_with(
#           status: 200,
#           headers: {'Content-Type' => 'application/json'},
#           body: {name: 'Betty'} )
#     end

#     it "returns an event" do
#       expect(subject.get_cal_event).to eq(BillingService.new('Betty'))
#     end
#   end
# end






#   include Pact::Consumer::Minitest
#   Pact.service_consumer "dashboard_api" do  # register a consumer with pact
#     has_pact_with "billing_service" do   # register the provider that has the pact
#       mock_service :billing_service do # register the mock service that will run and pretend to be the provider
#         port 8000
#       end
#     end
#   end

#   Pact.configure do |config|
#     config.pact_dir = './test/pacts'
#   end

#   def test_pact
#     billing_service
#       .given('a billing event exists')
#       .upon_receiving('a request for billing event')
#       .with(method: :get, path: '/event', query: 'user_id=2')
#       .will_respond_with(status: 200)

#     HTTPClient.new.get_content('http://localhost:8000')
#   end
# end



