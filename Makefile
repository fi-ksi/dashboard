TARGETS=$(patsubst notebooks/%.ipynb, build/%.html, $(wildcard notebooks/*.ipynb))

all: $(TARGETS)

build/%.html: notebooks/%.ipynb
	python3 export_monitoring_notebook $< $@

clean:
	rm -rf $(DOCKER_TARGETS)

.PHONY: all clean
