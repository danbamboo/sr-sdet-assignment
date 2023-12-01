require 'httparty'

class UserServiceClient
  include HTTParty
  base_uri 'http://localhost:8003'

  #Call Pact Mock service with valid request- Expect 200
  def get_user_success()
    response = self.class.get('/users/1')
    response.code == 200
  end

  #Call Pact Mock service with invalid request- Expect 404
  def get_user_fail()
    response = self.class.get('/users/0')
    response.code == 404
  end
end