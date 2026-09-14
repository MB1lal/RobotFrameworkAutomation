*** Settings ***
Documentation    Petstore API keywords. One session per suite, no global
...              variables - every keyword takes arguments and RETURNS its response.

Library          RequestsLibrary
Library          JSONLibrary
Library          Library.CustomLib
Library          Library.Connectors.PetConnector
Resource         ../common.resource


*** Keywords ***
Create Petstore Session
    [Documentation]    Open the shared API session (used as Suite Setup).
    ...    Retries transient 5xx on idempotent methods.
    Create Session    petstore    ${PET_BASE_URL}
    ...    verify=${VERIFY_TLS}
    ...    timeout=${API_TIMEOUT}
    ...    max_retries=${API_MAX_RETRIES}
    ...    backoff_factor=0.5
    ...    retry_status_list=${{ [500, 502, 503, 504] }}

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
    VAR    ${params}=    status=${status}
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
    VAR    &{form_data}=    ${attribute}=${attribute_value}
    ${response}=    POST On Session    petstore    /${pet_id}    data=${form_data}    expected_status=200
    RETURN    ${response}

Update Pet Name And Status
    [Documentation]    Rename the pet and move it to another status via the form API.
    [Arguments]    ${pet_id}    ${name}    ${status}
    Update Pet Via Form    ${pet_id}    name    ${name}
    Update Pet Via Form    ${pet_id}    status    ${status}

Pet Id Should Be
    [Documentation]    Assert the response body id matches.
    [Arguments]    ${response}    ${expected_id}
    ${ids}=    Get Value From Json    ${response.json()}    id
    Should Be Equal As Strings    ${ids}[0]    ${expected_id}

Pet Status Should Be
    [Documentation]    Assert a single-pet response has the expected status.
    [Arguments]    ${response}    ${expected_status}
    ${values}=    Get Value From Json    ${response.json()}    status
    Should Be Equal As Strings    ${values}[0]    ${expected_status}

Pet Response Should Match Schema
    [Documentation]    Validate a single-pet response body against the JSON schema.
    [Arguments]    ${response}    ${schema}=pet
    Validate Pet Schema    ${response.json()}    ${EXECDIR}/Resources/api/${schema}_schema.json

Pet List Should Contain Pet With Status
    [Documentation]    Assert the findByStatus list contains pet id with status.
    [Arguments]    ${response}    ${pet_id}    ${expected_status}
    VAR    ${found}=    ${False}
    FOR    ${item}    IN    @{response.json()}
        IF    '${item['id']}' == '${pet_id}'
            Should Be Equal As Strings    ${item['status']}    ${expected_status}
            VAR    ${found}=    ${True}
        END
    END
    Should Be True    ${found}    msg=Pet ${pet_id} not found in findByStatus response.
