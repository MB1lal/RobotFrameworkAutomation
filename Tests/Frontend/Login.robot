*** Settings ***
Documentation  Login Functionality
Library  SeleniumLibrary

*** Variables ***
${BROWSER}        Chrome
${HEROKU_URL}  https://the-internet.herokuapp.com/login

*** Test Cases ***
Verify Successful Login to the-internet.herokuapp
    [documentation]  This test case verifies that user is able to successfully Login to the-internet.herokuapp
    [tags]  Smoke
    Navigate to Heroku Login page
    Input Username and Password
    Login into app
    Verify user is logged in


*** Keywords ***
Navigate to Heroku Login page
    Open Browser    ${HEROKU_URL}   ${BROWSER}
    Wait Until Element Is Visible  id:username  timeout=5

Input Username and Password
    Input Text  id:username  tomsmith
    Input Password  id:password  SuperSecretPassword!

Login into app
    Click Element  css:button[type="submit"]

Verify user is logged in
    Element Should Be Visible  css:[href="/logout"]  timeout=5
    Close Browser