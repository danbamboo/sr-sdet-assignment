require 'httparty'

class BillingServiceClient
  include HTTParty
  base_uri 'http://localhost:8001'

  #Call Pact Mock service with valid request- Expect 200
  def get_billing_subscriptions_success()
    response = self.class.get('/subscriptions?user_id=1')
    response.code == 200
  end

  #Call Pact Mock service with invalid request- Expect 404
  def get_billing_subscriptions_fail()
    response = self.class.get('/subscriptions?user_id=0')
    response.code == 404
  end
end