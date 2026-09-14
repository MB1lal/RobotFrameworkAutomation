*** Settings ***
Documentation    Petstore API regression suite (demo API: petstore.swagger.io).
...    One session per suite, unique ids per test, no global variables.
Suite Setup      Create Petstore Session
Suite Teardown   Delete All Sessions
Resource         ../../Resources/api/pet_api.resource
Force Tags       api

*** Test Cases ***
Create And Fetch Pet By Id
    [Documentation]    Create a pet with a unique id, then fetch and verify it.
    [Tags]    regression    smoke
    ${pet_id}=     Generate Random Id
    ${payload}=    Build Pet Payload    pet_id=${pet_id}    status=available
    ${created}=    Create Pet    ${payload}
    Status Should Be    200    ${created}
    ${fetched}=    Get Pet By Id    ${pet_id}
    Status Should Be    200    ${fetched}
    Pet Id Should Be    ${fetched}    ${pet_id}
    Pet Status Should Be    ${fetched}    available

Find Newly Created Pet By Status
    [Documentation]    Create a sold pet, then verify it shows up in findByStatus.
    [Tags]    regression
    ${pet_id}=     Generate Random Id
    ${pet_name}=   Generate random name    ${10}
    ${payload}=    Build Pet Payload    pet_id=${pet_id}    name=${pet_name}    status=sold
    ${created}=    Create Pet    ${payload}
    Status Should Be    200    ${created}
    ${listed}=     Find Pets By Status    sold
    Status Should Be    200    ${listed}
    Pet List Should Contain Pet With Status    ${listed}    ${pet_id}    sold

Delete Pet
    [Documentation]    Create a pet, delete it, then verify it is gone (404).
    [Tags]    regression
    ${pet_id}=     Generate Random Id
    ${payload}=    Build Pet Payload    pet_id=${pet_id}    status=available
    ${created}=    Create Pet    ${payload}
    Status Should Be    200    ${created}
    ${deleted}=    Delete Pet    ${pet_id}
    Status Should Be    200    ${deleted}
    Get Pet By Id    ${pet_id}    expected_status=404

Update Pet Name And Status
    [Documentation]    Create a pet, update name/status via form, verify status.
    [Tags]    regression
    ${pet_id}=     Generate Random Id
    ${payload}=    Build Pet Payload    pet_id=${pet_id}    status=available
    ${created}=    Create Pet    ${payload}
    Status Should Be    200    ${created}
    Update Pet Via Form    ${pet_id}    name    Unicorn
    Update Pet Via Form    ${pet_id}    status    sold
    ${fetched}=    Get Pet By Id    ${pet_id}
    Status Should Be    200    ${fetched}
    Pet Id Should Be    ${fetched}    ${pet_id}
    Pet Status Should Be    ${fetched}    sold
