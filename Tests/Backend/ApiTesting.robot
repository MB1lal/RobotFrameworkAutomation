*** Settings ***
Documentation  API Testing in Robot Framework
Library  SeleniumLibrary
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library  ../../Library/CustomLib.py

*** Variables ***
${basePetURI}   https://petstore.swagger.io/v2/pet

*** Test Cases ***

Verifying newly added pet through Id
    I add the pet with id = 10001
    I call the pet api with id = 10001
    The pet with id = 10001 exists

Verifying newly added pet through Status
    I add the pet with status = sold
    I call the pet api with status
    The pet has status = sold

Verifying newly added pet can be deleted
    I add the pet with id = 10002
    I call the pet deletion api with id = 10002
    The pet with id = 10002 doesn't exist

Verifying pet details are correctly updated
    I add the pet with id = 10004
    I update the pet name to Unicorn
    I update the pet status to sold
    I call the pet api with id = 10004
    The pet with id = 10004 exists
    The pet has status = sold

*** Keywords ***
I add the pet with id = ${id}
    Create Session    mysession     ${basePetURI}   verify=true
    ${category_1}   create dictionary    id=${569}     name=TestDragon
    ${Category}=  create dictionary    id=${569}      name=TestDragon
    ${PhotoURLs}=   create list    photoURL
    ${Tags}=    create list     ${category_1}
    &{body}=    create dictionary    id=${id}   category=${Category}    name=TestingDragon  photoUrls=${PhotoURLs}  tags=${Tags}    status=availble
    &{header}=  Create Dictionary  Content-Type=application/json
    ${response}=    POST On Session    mysession    \   json=${body}
    Status Should Be    200
    set global variable    ${id}

I call the pet api with id = ${id}
     Create Session    mysession     ${basePetURI}   verify=true
     ${response}=  GET On Session  mysession  /${id}
     Status Should Be  200  ${response}  #Check Status as 200
     Set Global Variable      ${response}

The pet with id = ${id} exists
    ${ResponseId}=  Get Value From Json  ${response.json()}  id
    ${ExpectedId}   convert to string    ${responseId}[0]
    Should be equal  ${ExpectedId}  ${id}

I add the pet with status = sold
    ${id}   Evaluate  random.sample(range(1000, 100000),1)   random
    ${name}     Generate random name    ${10}
    Create Session    mysession     ${basePetURI}   verify=true
    ${category_1}   create dictionary    id=${id}[0]     name=${name}
    ${Category}=  create dictionary    id=${id}[0]      name=${name}
    ${PhotoURLs}=   create list    photoURL
    ${Tags}=    create list     ${category_1}
    &{body}=    create dictionary    id=${id}[0]   category=${Category}    name=${name}  photoUrls=${PhotoURLs}  tags=${Tags}    status=sold
    &{header}=  Create Dictionary  Content-Type=application/json
    ${response}=    POST On Session    mysession    \   json=${body}
    Status Should Be    200
    Set global variable    ${body}
    set global variable    ${id}

I call the pet api with status
    Create Session    mysession     ${basePetURI}   verify=true
    ${params} =    Create Dictionary    status=sold
    ${response}=  GET On Session  mysession  /findByStatus     params=${params}
    Status Should Be  200  ${response}  #Check Status as 200
    Set Global Variable      ${response}

The pet has status = sold
    ${firstChar}    convert json to string    ${response.json()}
    IF    "${firstChar}[0]" == "["
        FOR   ${item}   IN  @{response.json()}
            IF    ${item['id']} == ${id}[0]
                 should be equal as strings    sold   ${item['status']}
            END
        END
    ELSE
        ${response_status}  Get Value From Json  ${response.json()}  status
        should be equal    sold     ${response_status}[0]
    END

I call the pet deletion api with id = 10002
    Create Session    mysession     ${basePetURI}   verify=true
    DELETE On Session    mysession  /${id}

The pet with id = 10002 doesn't exist
    Create Session    mysession     ${basePetURI}   verify=true
    GET On Session  mysession  /${id}   expected_status=404

I update the pet ${attribute} to ${attribute_value}
    Create Session    mysession     ${basePetURI}   verify=true
    ${form_data}    create dictionary    ${attribute}=${attribute_value}
    POST On session    mysession    /${id}  data=${form_data}   expected_status=200