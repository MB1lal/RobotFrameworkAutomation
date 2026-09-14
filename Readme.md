[![Robot Tests](https://github.com/MB1lal/RobotFrameworkAutomation/actions/workflows/robot.yml/badge.svg)](https://github.com/MB1lal/RobotFrameworkAutomation/actions/workflows/robot.yml)

# Robot Framework Practice

Hey! This is my little playground for learning test automation with Robot Framework. It covers both sides of a typical app: clicking through a real login page (UI tests with Selenium) and pushing data around a demo pet store API (API tests with RequestsLibrary). If you're just getting started with Robot, you're in good company — pull up a chair and poke around.

## What's inside

- `Tests/Frontend/Login.robot` — log in (and fail to log in) on the-internet.herokuapp.com
- `Tests/Backend/ApiTesting.robot` — create, fetch, search, update, and delete pets on the demo petstore API
- `Resources/` — the good stuff lives here: shared settings (`common.resource`), the login page object (`pages/login.resource`), and all the API keywords (`api/pet_api.resource`)
- `Library/` — two small Python helpers: `CustomLib.py` (random names/ids) and `Connectors/PetConnector.py` (builds pet payloads so tests stay readable)
- `.github/workflows/robot.yml` — runs everything on every push/PR, in parallel, and keeps the reports for 14 days
- `Dockerfile` + `Makefile` — run it anywhere without the "works on my machine" drama

A couple of habits baked in that I wish someone had told me earlier: no hardcoded secrets (everything comes from env vars, see `.env.example`), each API test uses its own random id so reruns and parallel runs don't step on each other, and browsers always close after a test — even when it fails.

## Getting going

You'll need Python 3.10+ (3.12 works great).

```bash
git clone https://github.com/MB1lal/RobotFrameworkAutomation.git
cd RobotFrameworkAutomation
pip install -r requirements.txt
# only needed for the Browser (Playwright) library:
rfbrowser init
```

Copy `.env.example` to `.env` if you want to override the defaults (URLs, user, browser, headless mode) — totally optional, everything works out of the box.

## Running tests

```bash
# everything
robot --outputdir Results Tests

# faster — same thing, in parallel
pabot --processes 2 --outputdir Results Tests

# or use the shortcuts
make test
make test-parallel
make test-frontend
make test-backend

# single suite, headless Chrome, custom env
HEADLESS=true BROWSER=Chrome robot --outputdir Results Tests/Frontend/Login.robot
```

Open `Results/log.html` afterwards for the full story with screenshots.

Run it in Docker if you'd rather not install anything:

```bash
docker build -t rf-practice .
docker run --rm -v "$PWD/Results:/opt/tests/Results" rf-practice
```

## Handy bits

- Tags: `smoke`, `regression`, `api`, `ui` — e.g. `robot --include smoke --outputdir Results Tests`
- Lint: `make lint` (Robocop) — CI runs this too
- Config: `Resources/config.ini` is leftover from the early days; the real knobs now are the env vars in `Resources/common.resource` / `.env.example`
- CI: every push and PR to `master` runs lint + the full suite and uploads `Results/` as an artifact

## Blogs I wrote along the way

- [Getting started with Robot Framework UI Tests](https://medium.com/@m.b1lal/getting-started-with-robot-framework-ui-tests-e2d28b7d8e70)
- [Getting started with Robot Framework API Tests]()

Something broken or confusing? Open an issue — I'd genuinely love to hear about it.
