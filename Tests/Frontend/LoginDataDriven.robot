*** Settings ***
Documentation    Data-driven invalid logins (Selenium). Each CSV row becomes
...              its own test case - add rows in Tests/data/login_invalid.csv.

Resource         ../../Resources/pages/login.resource
Library          DataDriver    file=../data/login_invalid.csv

Test Setup       Open Login Page
Test Teardown    Close All Browsers
Test Template    Invalid Login Attempt Shows Error

Test Tags        ui    datadriven    regression


*** Test Cases ***
Placeholder - replaced by DataDriver rows
    [Documentation]    Never executed: DataDriver swaps this for one test per CSV row.
    No Operation


*** Keywords ***
Invalid Login Attempt Shows Error
    [Documentation]    Template: bad credentials stay out with an error banner.
    [Arguments]    ${username}    ${password}    ${error}
    Input Credentials    ${username}    ${password}
    Submit Login
    Login Error Should Be Visible    ${error}
