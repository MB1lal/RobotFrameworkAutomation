*** Settings ***
Documentation    Login functionality for the-internet.herokuapp.com.
...              Credentials come from env vars (see .env.example), browsers
...              close after every test - even on failure.

Resource         ../../Resources/pages/login.resource

Test Setup       Open Login Page
Test Teardown    Close All Browsers

Test Tags        ui    regression


*** Test Cases ***
Verify Successful Login
    [Documentation]    Valid user logs in and lands in the secure area.
    [Tags]    smoke
    Input Credentials
    Submit Login
    Secure Area Should Be Open

Verify Invalid Login Shows Error
    [Documentation]    Wrong password keeps the user out with an error banner.
    Input Credentials    ${HEROKU_USER}    wrong-password
    Submit Login
    Login Error Should Be Visible    Your password is invalid!
