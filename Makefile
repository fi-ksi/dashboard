TARGETS=$(patsubst notebooks/%.ipynb, build/%.html, $(wildcard notebooks/*.ipynb))
DOCKER_TARGETS=$(patsubst notebooks/%.ipynb, docker_build/%.html, $(wildcard notebooks/*.ipynb))

all: $(TARGETS)
docker_all: $(DOCKER_TARGETS)

build/%.html: notebooks/%.ipynb
	ksi-py3-venv/bin/python3 export_monitoring_notebook $< $@
	
docker_build/%.html: notebooks/%.ipynb
	python3 export_monitoring_notebook $< $@

clean:
	rm -rf $(TARGETS)

.PHONY: all clean
