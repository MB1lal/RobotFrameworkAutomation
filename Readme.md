[![Robot Tests](https://github.com/MB1lal/RobotFrameworkAutomation/actions/workflows/robot.yml/badge.svg)](https://github.com/MB1lal/RobotFrameworkAutomation/actions/workflows/robot.yml)

# Robot Framework Practice

Hey! This is my little playground for learning test automation with Robot Framework. It covers both sides of a typical app: clicking through a real login page (UI tests with Selenium *and* Playwright) and pushing data around a demo pet store API (RequestsLibrary with schema checks). If you're just getting started with Robot, you're in good company — pull up a chair and poke around.

## What's inside

- `Tests/Frontend/Login.robot` — Selenium login (and failed login) on the-internet.herokuapp.com
- `Tests/Frontend/LoginBrowser.robot` — the same flow on the Browser (Playwright) library: no manual waits, auto-retrying assertions
- `Tests/Frontend/LoginDataDriven.robot` + `Tests/data/login_invalid.csv` — one template keyword, four CSV rows, four test cases. Add a row, get a test.
- `Tests/Backend/ApiTesting.robot` — create, fetch, search, update, and delete pets on the demo petstore API, with JSON-schema validation on the way back
- `Resources/` — the good stuff lives here: shared settings (`common.resource`), page objects (`pages/login.resource`, `pages/login_browser.resource`), and all the API keywords (`api/pet_api.resource`, `api/pet_schema.json`)
- `Library/` — two small Python helpers: `CustomLib.py` (random names/ids) and `Connectors/PetConnector.py` (builds pet payloads, validates responses against the schema)
- `config/{dev,stage,prod}.yaml` — per-environment URLs, browsers, and timeouts. Secrets never live here — those come from env vars (see `.env.example`).
- `.github/workflows/robot.yml` — lint + parallel tests + an Allure history report on every push/PR, reports kept for 14 days
- `Dockerfile` + `Makefile` — run it anywhere without the "works on my machine" drama

A couple of habits baked in that I wish someone had told me earlier: no hardcoded secrets, each API test uses its own random id so reruns and parallel runs don't step on each other, API sessions retry transient 5xx, and browsers always close after a test — even when it fails.

## Getting going

You'll need Python 3.10+ (3.12 is what CI uses) and Node.js 18+ (for the Browser library).

```bash
git clone https://github.com/MB1lal/RobotFrameworkAutomation.git
cd RobotFrameworkAutomation
python3 -m venv venv && source venv/bin/activate
make install browsers
```

`make install` pins everything in `requirements.txt` (Robot Framework 7.5, SeleniumLibrary 6.9, Browser 20.4, and friends). `make browsers` downloads the Playwright browsers. Activating the venv matters — `pabot` shells out to the `robot` on your PATH.

Copy `.env.example` to `.env` if you want to override the defaults (URLs, user, browser, headless mode, Selenium Grid URL) — totally optional, everything works out of the box.

## Running tests

```bash
# everything, dev config (the default)
make test ENV=dev

# faster — same thing, in parallel
make test-parallel

# slices
make test-frontend
make test-backend

# Allure history report for the API suite (needs the allure CLI)
make test-allure

# raw commands, if you prefer
robot --pythonpath . --variablefile config/stage.yaml --outputdir Results Tests
pabot --processes 2 --pythonpath . --variablefile config/prod.yaml --outputdir Results Tests

# single suite, headless Chrome, grid run
HEADLESS=true BROWSER=Chrome robot --pythonpath . --outputdir Results Tests/Frontend/Login.robot
GRID_URL=http://localhost:4444/wd/hub robot --pythonpath . --outputdir Results Tests/Frontend
```

Open `Results/log.html` afterwards for the full story with screenshots, or `Results/allure-report/index.html` after `make test-allure`.

Run it in Docker if you'd rather not install anything:

```bash
docker build -t rf-practice .
docker run --rm -v "$PWD/Results:/opt/tests/Results" rf-practice
```

## Handy bits

- Tags: `smoke`, `regression`, `api`, `ui`, `browser`, `datadriven` — e.g. `robot --include smoke --outputdir Results Tests`
- Lint & format: `make lint` (Robocop 9, must be clean — CI enforces it), `robocop format Tests Resources` to auto-fix
- Data-driven: DataDriver CSVs use `;` as the delimiter (that's its default dialect), with `${...}` headers matching the template keyword's `[Arguments]`
- CI: every push and PR to `master` runs lint, the full suite in parallel (Chrome is installed for the Selenium suites), then builds the Allure report and uploads both artifacts
- Legacy note: `Resources/config.ini` is leftover from the early days; the real knobs now are `config/*.yaml` + env vars

## Blogs I wrote along the way

- [Getting started with Robot Framework UI Tests](https://medium.com/@m.b1lal/getting-started-with-robot-framework-ui-tests-e2d28b7d8e70)
- [Getting started with Robot Framework API Tests]()

Something broken or confusing? Open an issue — I'd genuinely love to hear about it.
