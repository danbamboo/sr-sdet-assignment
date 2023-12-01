from pact import Verifier

PROVIDER_URL = "http://localhost:8000"

class BillingServiceProviderTest():
    """Validates a consumer generated contract (from dashboard-api) using local pact file against live running services
    Requires live running billing-service
    Run with `python3 test/contract/provider-contract.py` inside the billing-service directory
    """

verifier = Verifier(provider='billing-service',
                    provider_base_url=PROVIDER_URL)

# Using a local pact file
success, logs = verifier.verify_pacts('../assignment_submission/contract_pacts/dashboard_api-billing_service.json')
assert success == 0