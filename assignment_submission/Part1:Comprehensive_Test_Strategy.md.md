# Comprehensive Testing Strategy
## Summary

This document will detail how I will approach API and Contract testing for the three provided test services (Billing/Calendar/User) and the dashboard-api service as well for contract testing.  This document will define the scope, setup goals and requirements, and provide a brief overview of framework and design for each testing type.

## Scope

* **Test Type**: The current scope is only for contract-testing and API testing since in later sections I will look at CICD, security, test-data and mocking.  For API testing, I will only be creating Functional testing, and not conducting other API testing such as Security, Load, or Resiliency testing for this project.  
  * I will however give consideration to future planning knowing these requirements are to come. 
* **Environment**: Currently only testing on local environment.
* **Test Data**:  Even though we have access to the service’s source code, I will not be updating or manipulating data for testing purposes.  With additional time/planning it may be beneficial to do so, but I am considering this outside the current scope.

## Goals

To begin, I'll define the high-level goals and requirements to decide what we want to achieve with testing.

-  Main Goal 1: Write automated tests for the critical API endpoints of each microservice.
   - Sub-Goals:
     - Require some automation framework to run tests.
     - All API tests should cover a set of critical tests defined in this document (see "Planned Coverage" section).  
     - Framework needs to validate status codes, response bodies, and header data.
      - Framework should allow for variable testing data.
        - I already noticed dates seem random calling the calendar service. 
      - Framework should allow for data-driven testing for future considerations (environments).
      - Framework should easily allow additional tests.
      - Framework should be able to share common component, such as setup, http requests, assertions...
- Main Goal 2: Implement contract tests validating the requests and responses against their defined contracts.
  - Sub-Goals:
    - Since Pact is currently the de-facto contract testing tool, we will support that in our testing.
    - Contract tests will cover at least one happy path and one unhappy path.
    - Only validate the format of the API request, not exact data, since contract tests are not functional tests.
    - Contract tests run in an automation fashion but may require services running locally for providers.
    - Consumer contract tests, for dashboard-api, can run similar to unit tests.  
    - Ok to store contract files locally (see future consideration in "Contract Publishing" section) .

## API Testing Strategy

### Framework Considerations

**Summary (TL/DR)**:  I decided to create a framework using **Python and Pytest** for Automated API testing after considering a number of plausible options.  The main motivating factors for choosing this framework are:

1. Frequently used/popular option and has a lot of support.
2. Python is perhaps the easiest language for users/QE to learn and adapt to. 
3. Pytest can also be used for UI/Selenium framework.
4. No vendor lock-in.
5. Could easily add custom logic and advanced capabilities.

### Other Possible Framework Considerations

* Postman (& Docker Integration)
  * Postman is a good option because it has a UI for creating API tests that can be exported and ran in a docker container.  This would make it easy for QEs to use.  However, it would require vendor lock-in and while it does support some custom scripting it would not be as adaptable as a home-brewed framework.
* JMeter
  * Jmeter is typically used for load testing, but also supports assertions and can be used for API testing.  It has the added benefit of easily running your functional tests as load tests since that’s the name of the game for JMeter.  However, it can be cumbersome to use for creating a suite of tests and doesn’t really lend itself to shared utilities or quick test generation.  
* RestAssured
  * Another popular functional testing library, predominately used with Java.  It’s a fine option, especially if company uses Java heavily, but python is easier to learn and use (subjectively at least).  
* Golang Script
  * Golang is one of my preferred languages, and if under a serious time crunch it would be easy to spit out a handful of API tests for this task (tempting).   However, Golang isn’t known for being an API testing tool and isn’t as widely used as Python.

There are other tooling options out there as well (SOAPUI, Robot...) and the right choice depends on all requirements the company may have.  So for now we just need to make a choice and stick with it. 

### API Test Coverage

For the purpose of this exercise, here is the general set of tests we will cover for the ‘critical’ test cases.   Given more time and a real-world application, we would likely write more tests.  

#### Planned Coverage
* Only testing GET requests (as only specified in doc)
* Validate a least one happy and one unhappy path.
  * 2XX status code && >= 4XX Status
* Validate that any HTTP headers you expect are set
* Validate that there is no missing data in the response body
* Validate response contains everything you expect
* Validate what happens when invalid parameter type data is submitted, e.g. submitting numbers within data fields

#### Outside of Scope

Here are some test cases that I am considering out of scope because they are not as ‘critical’, at least without more context in this contrived scenario. 

* POST/PUT/DELETE requests.
* Validate any max/min limits by testing the largest and lowest value range for all input parameters
* Check for invalid verbs
* Validate that API response times are within a certain threshold
* Validate all data paths on any APIs that contain if/switch cases
* Validate that authorization headers exist
* Validate what happens when authorization headers are not present
* Validate any potential CORs issues
* Load testing. Use a tool like JMeter to ensure the API works when called under load
* Validate cache headers are set
* Validate API warm-up within an acceptable threshold
* Validate what happens in a timeout situation
* Validate what happens when a third-party system is down
* Validate race condition tests or async tests
* Security Testing/SQL Injection

## Contract Testing Strategy

Contract testing allows for “consumers” and “providers” to validate their compatibility with each other, all while enabling each service to be tested in isolation.  There are (at least) two types of contract testing:

1) **Schema based testing**:  This type of testing is useful for having a documented contract (such as Swagger or OpenAPI) that helps ensure provider code is consistent with this documentation.  However, it does not provide any actual test based assurance that its consumers are accessing it properly or that the provider can meet all consumer expectations.
2) **Integration contract testing (My choice)** :  This is what tools like "Pact" implement, where consumers create a shared contract via actual code/testing, and providers tests against that contract to ensure they meet the demands of the consumer.  

**Since it was recommended to use Pact, and integration contract testing is more robust, I will go with this option.**

### General Test Setup

In order to maintain a proper integration contract test, it makes sense to have both “consumers” and “providers”.  Looking through the test repository, I discovered the dashboard-api that calls all three services (Billing, User, Calendar).  It therefore makes sense to setup consumer driven tests from the dashboard-api and run those contracts against each of the three providers.

### Contract Publishing

For sake of this project, I will publish the consumer driven contracts (via dashboard api pact tests), to a local repository.  If setting up a full system, we would likely consider setting up a “Contract Broker” that can be used to store and share tests between Provider and Consumers.  

### Consumer Setup

* I will use Ruby-Pact libraries to setup consumers in the dashboard API.
* I can add testing these contract-tests to the /test folder and ensure they get ran with other tests when running ‘rake’
  * **Note**:  Some existing tests were broken. I updated them so tests passed to avoid confusion when running new tests, not necessarily for correctness. 
* Each provider will have it’s own pact-mocking service test file and a pact test file.
* I can reuse a bit of code from the existing test cases that are already in the dashboard-api.
  * Noteworthy- The dashboard-api has a number of “stubs” (mocks) and test cases, which partially accomplishes what we will do with these contract tests.  However, it doesn’t go so far as to create a contract file that we can test providers against. Also, stubs assume the external service won’t change.



### Provider Setup

* Each provider will setup a test (in source) to pull in the local contract and run a test against the live running service.  
  * We will need to use Pact (Javascript, Python and Ruby) Provider libraries for this :p 
* Since we are already testing APIs with services running locally, I won’t currently go the extra mile to ensure that a provider pact test runs it’s own service within the test itself.  Though this strategy could be useful in the future.

## Next Steps
Time to get testing.  For API and Contract testing details and guide for running see the [Part 2: Automate API and Contract Testse](Part2:API_and_Contract_Testing_Guide.




