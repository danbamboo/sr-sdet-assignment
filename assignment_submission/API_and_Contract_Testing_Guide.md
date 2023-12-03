# API and Contract Testing Guide
This document provides details on how to run both API and Contract Tests, lists test cases, and documents test findings.

## Intro - TLDR- Just Run The Tests

I wanted to start this section with a quick guide on how to run the tests in case you want to jump in to that immediately.   Subsequent sections will provide additional details.

All tests (API and Contract) can all be ran via the Makefile and make commands :) 

### Run API Tests
Prerequisite:  All services should be running locally.  The command docker compose up --build can still be used for this.

***Running***

* Navigate to the assignment-submissions directory - (where the Makefile lives) - you may already be there if on this README page.
* Run all tests
  * Run `make run api` to run all API tests (21 total; 8 user-service; 5 calendar; 8 billing). 
    *  Behind the scenes this will build a docker image, mount local files, and run pytest -v command inside the docker image.  Test output will be in stdout.  
* Run Individual Tests
  * Can also run `make calendar-api` , `make billing-api` , or `make users-api`  for individual API tests.

### Run Contract Tests

Prerequisite:  

* All services should be running locally.  The command docker compose up --build can still be used for this.
* Requires python3 (to run provider tests for billing service) 
  * Also requires pip3 install pact-python if not already installed.


#### Client Tests and Contract Generation

* Navigate to the assignment-submissions directory - (where the Makefile lives) - you may already be there if on this README page.
* Run Client Tests and Generate Contracts
  * Run `make client-tests `
    * This will run all client tests (for 3 services) and update contracts in [contract_pacts/](contract_pacts/) (feel free to delete these three contracts in that folder and regenerate them with the make client-contract command)
  * Can also run `make contract-billing` , `make contract-users` , or `make contract-calendar` for individual contract tests.

#### Provider Tests 

* Run Provider Tests
  * Run all tests with `make provider-tests` 
  * Can also run `make calendar-provider` ,  `make user-provider`, or `make billing-provider`  for individual provider contract tests.

## API Testing Details and Findings

* The API testing framework can be found in [api_tests](api_tests/).  
* As planned, the framework uses Pytest to drive testing.  
* Testing uses data-driven (JSON)  test cases for each service.  Can see them here: [billing service cases](api_tests/tests/billing/data/env/local/tests.json), [user service cases](api_tests/tests/users/data/env/local/tests.json), and [calendar service cases](api_tests/tests/calendar/data/env/local/tests.json).
* This framework is setup with the the ability to pass in TEST_ENV env variable and setup different endpoints and data files based on setting (defaults to local - staged a staging setting though not setup fully).
* NOTE: I setup all tests to pass so it didn’t seem like my testing pipeline was broken, BUT there are some test cases that don’t match the schema provided and should fail or at least needs some follow-up questions on.  See next section.  

### Testing Findings and Clarification Questions

* Calendar Service
  * Need to ask why dates are random?  Is this expected behavior?
  * Extra field “timeZone” provided from /events response body, made decision to verify but would ask for clarification since not in specs.
  * The date format suggests "MM/DD/YYY" but actually "%m/%d/%Y, %H:%M:%S %p".  
  * Does not return a JSON string with an error message on invalid user_id (granted it doesn’t even check for a user_id just that the ‘user_id’ query param exists).  
* User Service - No major issues or discrepancies found.  
* Billing Service - 
  * The renewal_date is a relative date field.  Is this expected?  

### API Test Cases

| Service  | Endpoint                              | Exp Status | Exp Body                                          | Notes                                           |
| -------- | ------------------------------------- | ---------- | ------------------------------------------------- | ----------------------------------------------- |
| Calendar | /events?user_id=1                     | 200        | JSON w/ date format validation                    | Extra timeZone field + date in different format |
| Calendar | /events?user_id=2                     | 200        | JSON w/ date format validation                    | Extra timeZone field + date in different format |
| Calendar | /events?user_id=RANDOMCHARS123\*(\*(@ | 200        | JSON w/ date format validation                    | Extra timeZone field + date in different format |
| Calendar | /events?invalid_param=1               | 404        | Unexpected text instead of JSON                   | Don't get expected error message per docs.      |
| Calendar | /events/someotherpath?invalid_param=1 | 404        | Unexpected text instead of JSON                   | Don't get expected error message per docs.      |
| User     | /users/1                              | 200        | Expected full raw JSON string                     |                                                 |
| User     | /users/2                              | 200        | Expected full raw JSON string                     |                                                 |
| User     | /users/3                              | 200        | Expected full raw JSON string                     |                                                 |
| User     | /users/4                              | 200        | Expected full raw JSON string                     |                                                 |
| User     | /users/5                              | 200        | Expected full raw JSON string                     |                                                 |
| User     | /users/0                              | 404        | Expected JSON Error                               |                                                 |
| User     | /users/abc                            | 404        | Expected JSON Error                               |                                                 |
| User     | /users/invalidPath/1                  | 404        | Ignore Validation: Path Error Message not in spec | Path error not in spec OK                       |
| Billing  | /subscriptions?user_id=1              | 200        | JSON w/ dynamic renewal_date format validation    | Date value shits                                |
| Billing  | /subscriptions?user_id=2              | 200        | JSON w/ dynamic renewal_date format validation    | Date value shits                                |
| Billing  | /subscriptions?user_id=3              | 200        | JSON w/ dynamic renewal_date format validation    | Date value shits                                |
| Billing  | /subscriptions?user_id=4              | 200        | JSON w/ dynamic renewal_date format validation    | Date value shits                                |
| Billing  | /subscriptions?user_id=5              | 200        | JSON w/ dynamic renewal_date format validation    | Date value shits                                |
| Billing  | /subscriptions?user_id=6              | 404        | JSON error messsage (from doc)                    |                                                 |
| Billing  | /subscriptions?invalid_param=6        | 500        | JSON - 500 Internal Server Error                  | Param error not in spec OK                      |
| Billing  | /subscriptions?invalid_param=a        | 500        | JSON - 500 Internal Server Error                  | Param error not in spec OK                      |



## Contract Testing Details and Findings

* Using Pact, we start by running tests and generating Client Contracts from the dashboard-api service.  Contracts are generated locally in the [assignment-submissions/contract_pacts](assignment-submissions/contract_pacts/) folder.
* Each provider runs tests from source by pulling down the client created contracts to ensure schema is compatible.  
* Currently, requires services to be running (technically only for billing service, the other provider tests stand up server inside).
* We use Pact libraries for Ruby, Python, and Javascript to run Provider tests for each of the three services.

### Contract Test Cases

| Test Scenario                                  | Test Endpoint                    | Client        | Provider         |
| ---------------------------------------------- | -------------------------------- | ------------- | ---------------- |
| Calendar event/s exist for user ID             | /events?user_id=1                | dashboard-api | calendar-service |
| Calendar event/s do not exist for user ID      | /events?invalid_user_id_params=0 | dashboard-api | calendar-service |
| User subscriptions exist for user ID           | /users/1                         | dashboard-api | user-service     |
| User subscriptions do not exist for user ID    | /users/0                         | dashboard-api | user-service     |
| Billing subscriptions exist for user ID        | /subscriptions?user_id=1         | dashboard-api | billing-service  |
| Billing subscriptions do not exist for user ID | /subscriptions?user_id=0         | dashboard-api | billing-service  |



## Next Steps -CICD Integrations

Next, we will discuss CICD integrations for API and Contract testing [CI/CD Pipeline Integration](CICD_Pipeline_Integration.md) 