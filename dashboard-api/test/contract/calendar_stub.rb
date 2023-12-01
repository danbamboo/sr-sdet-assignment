require 'httparty'

class CalendarServiceClient
  include HTTParty
  base_uri 'http://localhost:8000/events'

  def get_cal_event(event)
    json_body = event.to_json
    response = self.class.post('/events?user_id=1', body: json_body)
    response.code == 200
  end
end