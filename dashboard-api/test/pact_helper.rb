ENV["RAILS_ENV"] ||= "test"
require "pact/consumer/minitest"

Pact.service_consumer "Dashboard-API" do  # register a consumer with pact
    has_pact_with "Calendar Service" do   # register the provider that has the pact
        mock_service :calendar_service do # register the mock service that will run and pretend to be the provider
            port 8000
        end
    end
end