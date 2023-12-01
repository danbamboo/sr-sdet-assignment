// const { Verifier } = require('@pact-foundation/pact');
// const path = require('path')
import path from 'path';
import { Verifier } from "@pact-foundation/pact";
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// import { path } from "path";
// var Verifier = require('@pact-foundation/pact');
// const testPort = process.env.TESTPORT || 8099;
// const { startServer } = require('../../app')

// (1) Start provider locally. Be sure to stub out any external dependencies
// startServer();



new Verifier({
  providerBaseUrl: `http://localhost:8000`,
  pactUrls: [path.resolve(__dirname, '../../../assignment_submission/contract_pacts/dashboard_api-calendar_service.json')],
}).verifyProvider()

// try {
//   await new Verifier({
//     providerBaseUrl: 'http://localhost:8080',
//     pactUrls: [path.resolve(__dirname, '../assignment_submission/contract_pacts/dashboard_api-calendar_service.json')],
//   }).verifyProvider()
// } catch (error) {
//   console.error('Error: ' + error.message)
//   process.exit(1)
// }

// describe('Calendar Service Pact Verification', () => {
//   test('should validate the expectations of our consumer', () => {
//     const opts = {
//       provider: 'calendar_service',
//       providerBaseUrl: 'http://localhost:8000',
//       pactBrokerUrl: '../assignment_submission/contract_pacts',
//       publishVerificationResult: true,
//       providerVersion: '1.0.0',
//       logLevel: 'INFO',
//     };

//     return new Verifier(opts).verifyProvider();
//   });
// });