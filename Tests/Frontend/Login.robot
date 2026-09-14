*** Settings ***
Documentation    Login functionality for the-internet.herokuapp.com.
...    Credentials come from env vars (see .env.example), browsers
...    close after every test - even on failure.
Test Setup       Open Login Page
Test Teardown    Close All Browsers
Resource         ../../Resources/pages/login.resource
Force Tags       ui

*** Test Cases ***
Verify Successful Login
    [Documentation]    Valid user logs in and lands in the secure area.
    [Tags]    smoke    regression
    Input Credentials
    Submit Login
    Secure Area Should Be Open

Verify Invalid Login Shows Error
    [Documentation]    Wrong password keeps the user out with an error banner.
    [Tags]    regression
    Input Credentials    ${HEROKU_USER}    wrong-password
    Submit Login
    Login Error Should Be Visible
