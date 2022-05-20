KSI_TARGETS=$(patsubst notebooks/%.ipynb, ksi_build/%.html, $(wildcard notebooks/*.ipynb))
NASKOC_TARGETS=$(patsubst notebooks/%.ipynb, naskoc_build/%.html, $(wildcard notebooks/*.ipynb))
DOCKER_TARGETS=$(patsubst notebooks/%.ipynb, docker_build/%.html, $(wildcard notebooks/*.ipynb))

ksi: $(KSI_TARGETS)
naskoc: $(NASKOC_TARGETS)
docker: $(DOCKER_TARGETS)
all: $(KSI_TARGETS) $(NASKOC_TARGETS)

include .env

# Note: Race condition on file db_uri.secret

ksi_build/%.html: notebooks/%.ipynb
	echo $(DB_URI_KSI) > db_uri.secret
	ksi-py3-venv/bin/python3 export_monitoring_notebook $< $@
	rm db_uri.secret || true

naskoc_build/%.html: notebooks/%.ipynb
	echo $(DB_URI_NASKOC) > db_uri.secret
	ksi-py3-venv/bin/python3 export_monitoring_notebook $< $@
	rm db_uri.secret || true

docker_build/%.html: notebooks/%.ipynb
	python3 export_monitoring_notebook $< $@

clean:
	rm -rf $(KSI_TARGETS)
	rm -rf $(NASKOC_TARGETS)
	rm -rf $(DOCKER_TARGETS)

.PHONY: all clean
