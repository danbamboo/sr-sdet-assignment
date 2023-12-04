# Test Data Management and Mocking

## Provided Goals

* Devise a strategy for managing test data across various environments, addressing data privacy and compliance, and outlining mocking strategies for testing.

## API Data Management

* Data & Envs:
  * As mentioned  previously, I have included config toggles based on ENV variables to switch between different envs.  These toggles allow for switching test data and other configurations such as service URL.
  * For API testing, data management is important.  In general, we want our API to be as prod-like as possible to ensure have good coverage and edge-cases get caught during the test phase. Depending on how important this is, and how complex data and data dimensions can get, we may want to model test data off of production data.  
  * Home Brewed Data Management Service
    * For our purposes, we can maintain our own Data Management service that we utilize to generate and manage data for us.  We will enable our framework to call this service prior to running tests to setup test data for us.  We can therefore have full control of how we generate data, we are not locked in to a Test Data Management vendor, and can manage our own security if we decide to obfuscate or profile live production data.  This can be developed in isolated from our API test framework to add advanced functionalities while ensuring backwards compatibility with any current uses.
    * While having dynamic and changing data can help us to catch more edge cases, we run the risk of tests being more flaky.  If things get too complex, we could end up with inaccurate test test results.  We need a good case to use this approach and thoughtful execution. 
* Mocking:
  * For functional API testing, mocking isn’t needed in general since we are validating integration.  There might be some unique cases that need mocked. 
  * For load testing, mocking becomes more important because load testing one service may trigger unwanted load on downstream services.  For example, if your service calls a 3rd party service such as Gmail, you may want to mock gmail calls when load testing your service to 1) isolate performance results for your service only and 2) avoid causing pains for downstream services (gmail in this case).  It depends on the scenario you want to test, sometimes you do want to API load test E2E scenarios and don’t want to mock.  
    * To achieve this, we can maintain a “mock-service” that users can call and configure how it responds.  This can be deployed in each testing environment.  
* Data Privacy/Security:
  * If prod-like data is used (obfuscated, anonymized...):
    * We must first ensure we have data-security standards in place to ensure our Data Management Service will meet all those requirements.
    * Ensure that data is genuinely anonymized and irreversible. This is a nontrivial task and would take a lot of planning and careful execution.  

## Contract Data Management

### Client Data Management

* Data:
  * We should not be required to manage data in different environments since contract testing is mainly schema validation.  
* Mocking:
  * Clients run internal mocks, as we did in dashboard-api for this project.  This helps define the expected data schema but shouldn’t need specific data.
* Data Privacy/Security:
  * NA, since don’t need to maintain specific data. 


### Provider Data Management

* Data:
  * Similar to the client, we don't need to maintain a set of test data in each environment to test against for contract testing because it is only schema based testing.
* Mocking:
  * We could speed up the testing pipeline with the ability to run provider tests in isolation.  In order to do so, you would need to implement mocking/stubs if you have a complex architecture.  
  * Since contract testing is mainly validating the schema, mocking does not need to be extensive as we don’t need to fully implement/simulate downstream dependency behavior.  
* Data Privacy/Security:
  * Not a main concern here since don’t need to maintain data.  

## The End
That concludes the tasks for this assignment.  Thanks for taking the time to review.  