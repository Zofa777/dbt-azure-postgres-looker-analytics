
.PHONY: prod-artifacts

prod-artifacts:
	mkdir -p prod_artifacts
	dbt docs generate --profiles-dir ./conf --target prod --target-path prod_artifacts
