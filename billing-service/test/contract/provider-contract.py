from pact import Verifier

PROVIDER_URL = "http://localhost:8000"

class ProviderState():
    """Define the provider state."""

verifier = Verifier(provider='billing-service',
                    provider_base_url=PROVIDER_URL)

# Using a local pact file

success, logs = verifier.verify_pacts('../assignment_submission/contract_pacts/dashboard_api-billing_service.json')
assert success == 0