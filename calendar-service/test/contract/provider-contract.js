import path from 'path';
import { Verifier } from "@pact-foundation/pact";
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//Validates a consumer generated contract (from dashboard-api) using local pact file against live running services
//Requires calendar-service to be running
//-->Run with `npm test`

new Verifier({
  providerBaseUrl: `http://localhost:8000`,
  pactUrls: [path.resolve(__dirname, '../../../assignment_submission/contract_pacts/dashboard_api-calendar_service.json')],
}).verifyProvider()