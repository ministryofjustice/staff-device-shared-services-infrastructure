apply:
	terraform apply
	./scripts/ensure_cloudwatch_log_retention_policies.sh