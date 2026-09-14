.PHONY: install browsers lint test test-parallel test-frontend test-backend test-allure clean

# Prefer the project venv when it exists (local dev), else system python (CI/Docker).
PYTHON ?= $(shell [ -x venv/bin/python ] && echo venv/bin/python || echo python3)
RESULTS ?= Results
ENV ?= dev

# Auto-load .env (copied from .env.example) so `make test` picks it up.
-include .env
export
COMMON_ARGS ?= --pythonpath . --variablefile config/$(ENV).yaml

install:
	$(PYTHON) -m pip install -U pip
	$(PYTHON) -m pip install -r requirements.txt

browsers:
	rfbrowser init || $(PYTHON) -m Browser.entry init

lint:
	robocop check Tests Resources Library

test:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot $(COMMON_ARGS) --outputdir $(RESULTS) Tests

test-parallel:
	mkdir -p $(RESULTS)
	$(PYTHON) -m pabot.pabot --processes 2 $(COMMON_ARGS) --outputdir $(RESULTS) Tests

test-frontend:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot $(COMMON_ARGS) --outputdir $(RESULTS) Tests/Frontend

test-backend:
	mkdir -p $(RESULTS)
	$(PYTHON) -m robot $(COMMON_ARGS) --outputdir $(RESULTS) Tests/Backend

# Allure history: serial run with the allure listener, then a static report.
# Needs the allure CLI (brew install allure / npm i -g allure-commandline).
test-allure:
	mkdir -p $(RESULTS)/allure-results
	$(PYTHON) -m robot $(COMMON_ARGS) --outputdir $(RESULTS) \
		--listener "allure_robotframework;$(RESULTS)/allure-results" Tests/Backend
	allure generate $(RESULTS)/allure-results -o $(RESULTS)/allure-report --clean

clean:
	rm -rf $(RESULTS)/output.xml $(RESULTS)/log.html $(RESULTS)/report.html $(RESULTS)/pabot_results $(RESULTS)/allure-results $(RESULTS)/allure-report
