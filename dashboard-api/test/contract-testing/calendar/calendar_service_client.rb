require 'httparty'

class CalendarServiceClient
  include HTTParty
  base_uri 'http://localhost:8000'

  #Call Pact Mock service with valid request- Expect 200
  def get_cal_event_success()
    response = self.class.get('/events?user_id=1')
    response.code == 200
  end

  #Call Pact Mock service with invalid request- Expect 404
  def get_cal_event_fail()
    response = self.class.get('/events?invalid_user_id_params=0')
    response.code == 404
  end
end