.PHONY: install browsers lint test test-parallel test-frontend test-backend clean

PYTHON ?= python3
RESULTS ?= Results

install:
	$(PYTHON) -m pip install -U pip
	$(PYTHON) -m pip install -r requirements.txt

browsers:
	rfbrowser init || $(PYTHON) -m Browser.entry init

lint:
	robocop check Tests Resources Library || $(PYTHON) -m robocop Tests Resources Library

test:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot --outputdir $(RESULTS) Tests

test-parallel:
	mkdir -p $(RESULTS)
	$(PYTHON) -m pabot.pabot --processes 2 --outputdir $(RESULTS) Tests

test-frontend:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot --outputdir $(RESULTS) Tests/Frontend

test-backend:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot --outputdir $(RESULTS) Tests/Backend

clean:
	rm -rf $(RESULTS)/output.xml $(RESULTS)/log.html $(RESULTS)/report.html $(RESULTS)/pabot_results
