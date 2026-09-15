*** Settings ***
Documentation    Shared variables and setup for every suite.
...              Values can be overridden without editing files:
...              `HEADLESS=true BROWSER=Chrome robot --outputdir Results Tests`
...              Per-environment files live in config/: use
...              `--variablefile config/stage.yaml` (needs PyYAML).


*** Variables ***
${PET_BASE_URL}       %{PET_BASE_URL=https://petstore.swagger.io/v2/pet}
${HEROKU_URL}         %{HEROKU_URL=https://the-internet.herokuapp.com/login}
${HEROKU_USER}        %{HEROKU_USER=tomsmith}
${HEROKU_PASSWORD}    %{HEROKU_PASSWORD=SuperSecretPassword!}
${BROWSER}            %{BROWSER=Chrome}
${HEADLESS}           %{HEADLESS=false}
${TIMEOUT}            %{TIMEOUT=10s}
${VERIFY_TLS}         %{VERIFY_TLS=true}
${GRID_URL}          %{GRID_URL=${EMPTY}}
${CHROMEDRIVER_PATH}  %{CHROMEDRIVER_PATH=${EMPTY}}
${CHROME_BINARY}      %{CHROME_BINARY=${EMPTY}}
${API_TIMEOUT}       %{API_TIMEOUT=10}
${API_MAX_RETRIES}    %{API_MAX_RETRIES=3}
