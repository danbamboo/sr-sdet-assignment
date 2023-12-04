# CI/CD Pipeline Integration

## Purpose

The purpose of this document is to plan how we would integrate our newly created API and contract tests into a CI/CD pipeline.  For this assignment, I will be leveraging existing frameworks (Python/Pytest for API and Pact Client Driven Contracts) as part of my discussion.  

## Provided Goals

* Propose a plan for integrating your automated and contract tests into a CI/CD pipeline, detailing trigger mechanisms, test data management, environment setup/teardown, and result reporting. 
* Include a plan for monitoring the application and observing the test results within the CI/CD pipeline or production environment

## API Testing Pipeline

* Stage:  In CI pipeline
* Trigger:  Push to pre-prod environment (possibly prod environment too)
* Where:  Pre-Prod like env
  * Once user deploys and stages code in pre-prod provider contract tests can run when in up-and-running before pushing to production. 
  * Additionally, some companies may want to run in production, though this is not standard.  You could run a blue-green deployment and run integration tests prior to full release for additional confidence. 
* If integration tests fail, the service’s CI will not allow push to prod.  
* Tests Data & Environments:
  * Depending on the number of environments setup (i.e. alpha/beta/gamma/prod) we will need to manage data across these environments.  I have included config toggles based on ENV variables to switch between different envs.  These toggles allow for switching test data and other configurations such as service URL.
  * It could be beneficial to be able to run tests in local pipeline before pushing to pre-prod environment to try and keep things stable.  Our current framework is local testing only, but is simple.  More mocking would likely need to occur for local testing in complex env.  
* Results:
  * It is good idea to keep good record of test results.  A test management system such as test rail would be beneficial to track test runs over time, make test coverage and pass/fail rates visible, help with triage, bug fixing, backlogging fixes, and making tests more robust.  

## CI/CD Pipeline Plan



## Contract Testing Pipeline

### Client Workflow/Pipeline

* Stage::  In the build pipeline.
* Trigger: Push to master 
* Where: In automated build pipeline (i.e. Jenkins) like a unit test.  
* Details:
  * On push to master, consumers will run contract tests and push them to a contract broker if all CI tests pass.  This can be ran as a “unit-test”, similar to other tests (triggered with rake).  
  * Contract testing allows for tagged contracts, so consumers could push dev contracts for providers to test against (assuming they are stillin progress).  Once contract is esablished, in can be tagged as main or master and this is required for provider to pass before deployment to master.
  * For us, he client is dashboard-api.  Upon successful CI, it will push contract to broker.  
* Test Data & Environment:
  * Client driven contract tests can happen at the build stage so don’t depend on test data or enviornments.
* Results:
  * Adding contract broker would share the contract to providers and be easily visable, otherwise there are not results required for client.

### Provider Workflow/Pipeline

* Stage:  In CI pipeline
* Trigger:  Push to pre-prod environment & push to production environment.  
* Where:  
  * (Preferred) Strategy 1 (Isolation and Mocks):  If provider can be ran in isolation with mock DB and mock states, provider contract tests can be ran in isolation.
    * This is the preferred method because it allows for quicker testing and doesn’t require testing on a full prod-like environment.  The only reason not to do this is if setting up mocks and stubs was too complex for a team.  
  * Strategy 2 (pre-prod environment):  Once user deploys and stages code in pre-prod provider contract tests can run when in up-and-running before pushing to production.  This could also be an on-demand, temporary env if company has this capability. 
* If provider tests fail, the provider’s CI will not allow the provider to continue to production as that would break the consumer
* Tests Data & Environments:
  * Contracts should be validating the schema and not the exact data.  For that reason you shouldn’t need to manage different data for various environments.  
  * Currently, our providers don’t have any known downstream dependencies or database.  However, if they did, we could use Pact tools and states to mock out these dependencies in order to isolate these services.  
* Results:
  * Provider results, pass or fail, can be handled by maintaining a contract broker and reporting result history there.

## Next
Finally, I will devise a strategy for managing test data with security and mocking in mind. [Part 4: Test Data Management and Mocking](Part4:Test_Data_Management_and_Mocking.md) 