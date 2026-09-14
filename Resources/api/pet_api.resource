*** Settings ***
Documentation    Petstore API keywords. One session per suite, no global
...    variables - every keyword takes arguments and RETURNS its response.
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    ../../Library/CustomLib.py
Library    ../../Library/Connectors/PetConnector.py
Resource    ../common.resource

*** Keywords ***
Create Petstore Session
    [Documentation]    Open the shared API session (used as Suite Setup).
    Create Session    petstore    ${PET_BASE_URL}    verify=${VERIFY_TLS}

Create Pet
    [Documentation]    POST a pet payload. Returns the response.
    [Arguments]    ${payload}
    ${response}=    POST On Session    petstore    /    json=${payload}
    RETURN    ${response}

Get Pet By Id
    [Documentation]    GET /pet/{id}. Pass expected_status=404 for deleted pets.
    [Arguments]    ${pet_id}    ${expected_status}=200
    ${response}=    GET On Session    petstore    /${pet_id}    expected_status=${expected_status}
    RETURN    ${response}

Find Pets By Status
    [Documentation]    GET /pet/findByStatus?status={status}.
    [Arguments]    ${status}
    ${params}=      Create Dictionary    status=${status}
    ${response}=    GET On Session    petstore    /findByStatus    params=${params}
    RETURN    ${response}

Delete Pet
    [Documentation]    DELETE /pet/{id}. Returns the response.
    [Arguments]    ${pet_id}
    ${response}=    DELETE On Session    petstore    /${pet_id}
    RETURN    ${response}

Update Pet Via Form
    [Documentation]    POST /pet/{id} with form fields (name/status update).
    [Arguments]    ${pet_id}    ${attribute}    ${attribute_value}
    ${form_data}=    Create Dictionary    ${attribute}=${attribute_value}
    ${response}=     POST On Session    petstore    /${pet_id}    data=${form_data}    expected_status=200
    RETURN    ${response}

Pet Id Should Be
    [Documentation]    Assert the response body id matches.
    [Arguments]    ${response}    ${expected_id}
    ${ids}=          Get Value From Json    ${response.json()}    id
    Should Be Equal As Strings    ${ids}[0]    ${expected_id}

Pet Status Should Be
    [Documentation]    Assert a single-pet response has the expected status.
    [Arguments]    ${response}    ${expected_status}
    ${values}=       Get Value From Json    ${response.json()}    status
    Should Be Equal As Strings    ${values}[0]    ${expected_status}

Pet List Should Contain Pet With Status
    [Documentation]    Assert the findByStatus list contains pet id with status.
    [Arguments]    ${response}    ${pet_id}    ${expected_status}
    ${found}=    Set Variable    ${False}
    FOR    ${item}    IN    @{response.json()}
        IF    '${item['id']}' == '${pet_id}'
            Should Be Equal As Strings    ${item['status']}    ${expected_status}
            ${found}=    Set Variable    ${True}
        END
    END
    Should Be True    ${found}    msg=Pet ${pet_id} not found in findByStatus response.
