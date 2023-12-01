Pact.provider_states_for 'dashboard_api' do

  #Currently not required with service running - Could add additional cases for various 
  
    provider_state "User subscriptions exist for user ID" do
      set_up do
        #Any setup steps
      end
  
      tear_down do
        # Any tear down steps to clean up the provider state
      end
    end
  
    provider_state "User subscriptions do not exist for user ID" do
      no_op # No actions requred for error state
    end
  
end
