*** Settings ***
Documentation    Login page object: locators + reusable login keywords.
...    Keeps test cases free of Selenium details.
Library    SeleniumLibrary
Resource    ../common.resource

*** Variables ***
${USERNAME_FIELD}    id:username
${PASSWORD_FIELD}    id:password
${SUBMIT_BUTTON}     css:button[type="submit"]
${LOGOUT_LINK}       css:[href="/logout"]
${FLASH_MESSAGE}     id:flash

*** Keywords ***
Open Login Page
    [Documentation]    Open the login page (headless when HEADLESS=true).
    IF    '${HEADLESS}' == 'true'
        Open Browser    ${HEROKU_URL}    ${BROWSER}    options=add_argument("--headless");add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage")
    ELSE
        Open Browser    ${HEROKU_URL}    ${BROWSER}
    END
    Set Selenium Timeout    ${TIMEOUT}
    Maximize Browser Window
    Wait Until Element Is Visible    ${USERNAME_FIELD}    timeout=${TIMEOUT}

Input Credentials
    [Documentation]    Fill username and password. Defaults come from env vars.
    [Arguments]    ${username}=${HEROKU_USER}    ${password}=${HEROKU_PASSWORD}
    Input Text         ${USERNAME_FIELD}    ${username}
    Input Password     ${PASSWORD_FIELD}    ${password}

Submit Login
    [Documentation]    Click the login button.
    Click Element    ${SUBMIT_BUTTON}

Secure Area Should Be Open
    [Documentation]    Assert login succeeded.
    Wait Until Element Is Visible    ${LOGOUT_LINK}    timeout=${TIMEOUT}
    Element Should Contain    ${FLASH_MESSAGE}    You logged into a secure area!

Login Error Should Be Visible
    [Documentation]    Assert login failed with an error banner.
    [Arguments]    ${expected}=Your username is invalid!
    Wait Until Element Is Visible    ${FLASH_MESSAGE}    timeout=${TIMEOUT}
    Element Should Contain    ${FLASH_MESSAGE}    ${expected}
