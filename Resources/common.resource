*** Settings ***
Documentation    Shared variables and setup for every suite.
...    Values can be overridden without editing files:
...    `HEADLESS=true BROWSER=Chrome robot --outputdir Results Tests`

*** Variables ***
${PET_BASE_URL}      %{PET_BASE_URL=https://petstore.swagger.io/v2/pet}
${HEROKU_URL}        %{HEROKU_URL=https://the-internet.herokuapp.com/login}
${HEROKU_USER}       %{HEROKU_USER=tomsmith}
${HEROKU_PASSWORD}   %{HEROKU_PASSWORD=SuperSecretPassword!}
${BROWSER}           %{BROWSER=Chrome}
${HEADLESS}          %{HEADLESS=false}
${TIMEOUT}           %{TIMEOUT=10s}
${VERIFY_TLS}        %{VERIFY_TLS=true}
