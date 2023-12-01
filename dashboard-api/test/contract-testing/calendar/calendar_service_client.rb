require 'httparty'

class CalendarServiceClient
  include HTTParty
  base_uri 'http://localhost:8000'

  def get_cal_event_success()
    response = self.class.get('/events?user_id=1')
    response.code == 200
  end

  def get_cal_event_fail()
    response = self.class.get('/events?user_id=0')
    response.code == 404
  end
end