*** Settings ***
Documentation    Same login flow as Login.robot, driven by the Browser
...              (Playwright) library: no manual waits, auto-retrying assertions.

Resource         ../../Resources/pages/login_browser.resource

Test Setup       Open Browser To Login Page
Test Teardown    Close Browser

Test Tags        ui    browser


*** Test Cases ***
Verify Successful Login Via Browser Library
    [Documentation]    Valid user logs in and lands in the secure area.
    [Tags]    smoke    regression
    Input Credentials In Browser
    Submit Login In Browser
    Secure Area Should Be Open In Browser
