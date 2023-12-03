Pact.provider_states_for 'dashboard_api' do

  #Currently no updates to the 2 required "states" for contracts to pass.
  
    provider_state "User subscriptions exist for user ID" do
      no_op # No actions requred for error state
      #No setup required due to hardcoded data
    end
  
    provider_state "User subscriptions do not exist for user ID" do
      no_op # No actions requred for error state
    end
  
end
