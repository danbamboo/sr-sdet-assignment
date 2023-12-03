

import path from 'path';
import { Verifier } from "@pact-foundation/pact";
import { fileURLToPath } from 'url';
import testPort from './set-env.js'
import server from '../../app.js'  //Will run server on testPort for unit type testing



const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//Validates a consumer generated contract (from dashboard-api) using local pact file against server this test stands up
//Requires calendar-service to be running
//-->Run with `npm test`

new Verifier({
  providerBaseUrl: `http://localhost:${testPort}`,
  pactUrls: [path.resolve(__dirname, '../../../assignment_submission/contract_pacts/dashboard_api-calendar_service.json')],
}).verifyProvider().then(setTimeout(function(){server.close()}, 5000))  //Shutdown server after 5 seconds to let test run
