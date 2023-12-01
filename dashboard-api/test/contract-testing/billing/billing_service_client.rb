require 'httparty'

class BillingServiceClient
  include HTTParty
  base_uri 'http://localhost:8001'

  def get_billing_subscriptions_success()
    response = self.class.get('/subscriptions?user_id=1')
    response.code == 200
  end

  def get_billing_subscriptions_fail()
    response = self.class.get('/subscriptions?user_id=0')
    response.code == 404
  end
end