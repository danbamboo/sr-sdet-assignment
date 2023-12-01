require 'httparty'

class UserServiceClient
  include HTTParty
  base_uri 'http://localhost:8003'

  def get_user_success()
    response = self.class.get('/user/1')
    response.code == 200
  end

  def get_user_fail()
    response = self.class.get('/user/0')
    response.code == 404
  end
end