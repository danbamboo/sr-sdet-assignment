require 'pact/provider/rspec'
require './test/contract/user_state'


Pact.service_provider "user_service" do
  honours_pact_with 'dashboard_api' do
    # TODO - Add pack broker so some non-local file access
    pact_uri  '../assignment_submission/contract_pacts/dashboard_api-user_service.json'
  end
end


