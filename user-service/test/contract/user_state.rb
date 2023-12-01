Pact.provider_states_for 'dashboard_api' do
    provider_state "User subscriptions exist for user ID" do
      set_up do
        # USERS = [
        #     {'id' => 1, 'first_name' => 'Michael', 'last_name' => 'Scott', 'position' => 'Regional Manager', 'role' => 'admin', 'time_zone' => 'America/New_York'}, 
        #     {'id' => 2, 'first_name' => 'Jim', 'last_name' => 'Halpert', 'position' => 'Salesperson', 'role' => 'user', 'time_zone' => 'America/Detroit'},
        #     {'id' => 3, 'first_name' => 'Pam', 'last_name' => 'Beesly', 'position' => 'Receptionist', 'role' => 'user', 'time_zone' => 'America/Denver'},
        #     {'id' => 4, 'first_name' => 'Dwight', 'last_name' => 'Schrute', 'position' => 'Salesperson', 'role' => 'user', 'time_zone' => 'America/Chicago'},
        #     {'id' => 5, 'first_name' => 'Anglea', 'last_name' => 'Martin', 'position' => 'Accountant', 'role' => 'user', 'time_zone' => 'America/Los_Angeles'},
        #   ]
        # user_id = 1
        # user = USERS.find{ |x| x["id"] == user_id.to_i }
        # render json: { "id": user["id"], "first_name": user["first_name"], "last_name": user["last_name"] }
        # Create a thing here using your framework of choice
        # eg. Sequel.sqlite[:somethings].insert(name: "A small something")
      end
  
      tear_down do
        # Any tear down steps to clean up the provider state
      end
    end
  
    provider_state "User subscriptions do not exist for user ID" do
      no_op # If there's nothing to do because the state name is more for documentation purposes,
            # you can use no_op to imply this.
    end
  
end
