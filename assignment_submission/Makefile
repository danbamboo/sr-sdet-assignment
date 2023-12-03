# API TESTING DOCKER INFO
API_DOCKER_IMAGE=sdet-takehome-main-api-tests  #Docker image default name
API_CONTAINER=api_testing_container  #Container Name Default for API Tests
API_TEST_VOLUME=./api_tests:/app
#API TESTING TEST DATA LOCATION/CMD
ALL_TESTS=pytest -v
CALENDAR_TESTS=pytest -v /app/tests/calendar
USERS_TESTS=pytest -v /app/tests/users
BILLING_TESTS=pytest -v /app/tests/billing

##################
##  API TESTING ##
##################

#Build API Image
.PHONY: build
build:
	docker build -t $(API_DOCKER_IMAGE) -f api_tests/Dockerfile .
#Run all api tests
.PHONY: run-api
run-api: build
	docker run --network=host --rm --name=$(API_CONTAINER) -v $(API_TEST_VOLUME) $(API_DOCKER_IMAGE) $(ALL_TESTS)
#Run calendar api tests
.PHONY: calendar-api
calendar-api: build
	docker run --network=host --rm --name=$(API_CONTAINER) -v $(API_TEST_VOLUME) $(API_DOCKER_IMAGE) $(CALENDAR_TESTS)
#Run user api tests
.PHONY: users-api
users-api: build
	docker run --network=host --rm --name=$(API_CONTAINER) -v $(API_TEST_VOLUME) $(API_DOCKER_IMAGE) $(USERS_TESTS)
#Run calendar api tests
.PHONY: billing-api
billing-api: build
	docker run --network=host --rm --name=$(API_CONTAINER) -v $(API_TEST_VOLUME) $(API_DOCKER_IMAGE) $(BILLING_TESTS)

#Run api in terminal
.PHONY: term-api
term-api: build
	docker run --network=host -it --rm --name=$(API_CONTAINER) -v $(API_TEST_VOLUME) $(API_DOCKER_IMAGE) sh

#######################
##  CONTRACT TESTING ##
#######################

##### Client Tests 
#Create Client Contract on Dashboard API (contracts generated in /contract_pacts) by running tests for all three services in dashboard-api
.PHONY: client-tests
client-tests: contract-billing contract-users contract-calendar

.PHONY: contract-billing
contract-billing: 
	(cd ../dashboard-api/ && ruby -I test test/contract-testing/billing/billing_service_client_test.rb)

.PHONY: contract-users
contract-users: 
	(cd ../dashboard-api/ && ruby -I test test/contract-testing/user/user_service_client_test.rb)

.PHONY: contract-calendar
contract-calendar: 
	(cd ../dashboard-api/ && ruby -I test test/contract-testing/calendar/calendar_service_client_test.rb)

##### Provider Tests 
.PHONY: provider-tests
provider-tests: billing-provider user-provider calendar-provider

.PHONY: billing-provider
billing-provider: 
	(python3 ../billing-service/test/contract/provider-contract.py)

.PHONY: user-provider
user-provider: 
	(cd ../user-service && rake)

.PHONY: calendar-provider
calendar-provider: 
	(cd ../calendar-service && npm test )
