*** Settings ***
Documentation    Login page object on the Browser (Playwright) library:
...              auto-waiting assertions, trace/video on failure via playwright config.

Library          Browser
Resource         ../common.resource


*** Variables ***
${USERNAME_FIELD}    id=username
${PASSWORD_FIELD}    id=password
${SUBMIT_BUTTON}     css=button[type="submit"]
${LOGOUT_LINK}       css=[href="/logout"]
${FLASH_MESSAGE}     id=flash


*** Keywords ***
Open Browser To Login Page
    [Documentation]    Launch Chromium (headless when HEADLESS=true) at login.
    ${headless}=    Convert To Boolean    ${HEADLESS}
    New Browser    browser=chromium    headless=${headless}
    New Context    viewport={'width': 1280, 'height': 720}
    New Page    ${HEROKU_URL}
    Set Browser Timeout    ${TIMEOUT}

Input Credentials In Browser
    [Documentation]    Fill username and password. Defaults come from env vars.
    [Arguments]    ${username}=${HEROKU_USER}    ${password}=${HEROKU_PASSWORD}
    Fill Text    ${USERNAME_FIELD}    ${username}
    Fill Text    ${PASSWORD_FIELD}    ${password}

Submit Login In Browser
    [Documentation]    Click the login button.
    Click    ${SUBMIT_BUTTON}

Secure Area Should Be Open In Browser
    [Documentation]    Assert login succeeded.
    Wait For Elements State    ${LOGOUT_LINK}    visible    timeout=${TIMEOUT}
    ${message}=    Get Text    ${FLASH_MESSAGE}
    Should Contain    ${message}    You logged into a secure area!
