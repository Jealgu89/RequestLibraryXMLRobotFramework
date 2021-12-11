*** Settings ***
Library    String
Library    RequestsLibrary
Library    OperatingSystem
Library    DateTime
Library    DatabaseLibrary

Library     ../CustomLibs/cdataCleanUp.py
Library     ../CustomLibs/emailValidity.py
Library     ../CustomLibs/prettyPrintXML.py
Library     ../CustomLibs/showDifferences.py
Library     ../CustomLibs/removeSpaces.py


*** Variables ***




${DB_CONNECT_STRING1}    'eim_user/EIM_USER@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=amshpds29.nl.aswatson.net)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=AMSS8T)))'
${DB_CONNECT_STRING2}    'eim_user/EIM_USER@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=amshpds29.nl.aswatson.net)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=AMSS7T)))'
${DB_CONNECT_STRING3}    'eim_user/EIM_USER@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=amshpds29.nl.aswatson.net)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=AMSS9T)))'



*** Keywords ***

Send soap message
    [Documentation]      Send soap message and check responsecode
    [Arguments]     ${responsecode}
    IF    ${INSTANCE} == 1

        Set Test Variable    ${env}     ma
    ELSE IF     ${INSTANCE} == 2

        Set Test Variable    ${env}     sd
    ELSE IF     ${INSTANCE} == 3

        Set Test Variable    ${env}     kv

    END


    ${base_url}     Replace String      ${base_url}     _env_       ${env}
    create session  TestAutomation    ${base_url}
    ${SAVE_Response}=    Post Request     TestAutomation    ${channel_url}    headers=${headers}    data=${request}
    Should Be Equal As Integers    ${SAVE_Response.status_code}     ${responsecode}
    Set Test Variable   ${responsecode}
    Set Test Variable    ${SAVE_Response}
    Log    ${SAVE_Response.text}


Check response
    [Documentation]     check response in txt format
    ${responsePretty}      pretty print xml    ${SAVE_Response.text}
    ${responseClean}    Clean Cdata    ${responsePretty}
    log     ${responseClean}
    #${expectedResponse}=    Get File    ${pathresponse}
    Show Differences    ${responseClean}    ${expectedResponse}
    Run Keyword And Continue On Failure     Should Contain    ${responseClean}      ${expectedResponse}







Login to sit1 database
    connect to database using custom params    cx_Oracle    ${DB_CONNECT_STRING1}

Login to sit2 database
    connect to database using custom params    cx_Oracle    ${DB_CONNECT_STRING2}

Login to sit3 database
    connect to database using custom params    cx_Oracle    ${DB_CONNECT_STRING3}




Create request
        [Arguments]    ${i}     ${parameter1}   ${parameter2}    ${parameter3}      ${parameter4}       ${parameter5}
        [Documentation]     keyword to create a request, in any format

        ${pathrequest}     Replace String       ${pathrequest}        _i_     ${i}
        ${request}=    Get File    ${pathrequest}
        ${request}      Remove Spaces    ${request}
        ${request}      pretty print xml    ${request}
        ${request}      Replace String    ${request}    _A_    ${parameter1}
        ${request}      Replace String    ${request}    _B_    ${parameter2}
        ${request}      Replace String    ${request}    _C_    ${parameter3}
        ${request}      Replace String    ${request}    _D_    ${parameter4}
        ${request}      Replace String    ${request}    _E_    ${parameter5}


        Log    ${request}
        Set Test Variable    ${request}









Create expected response
    [Arguments]         ${i}
    [documentation]     Expected response based for any message based on file path
    ${pathresponse}     Replace String      ${pathresponse}     _i_     ${i}
    ${expectedResponse}=    Get File    ${pathresponse}
    get serverdate
    ${expectedResponse}    Replace String  ${expectedResponse}    _A_    ${serverdate}
    get sent date
    ${expectedResponse}    Replace String  ${expectedResponse}    _B_    ${sentdate}
    ${expectedResponse}     remove spaces       ${expectedResponse}
    ${expectedResponse}     pretty print xml    ${expectedResponse}
    ${expectedResponse}     remove string       ${expectedResponse}     <![CDATA[
    ${expectedResponse}     remove string       ${expectedResponse}     ]]>
    Log    ${expectedResponse}
    set Test Variable       ${expectedResponse}




 get serverdate
    [Documentation]     get current date in yyyy/mm/dd format
    set test variable    ${serverdate}       _A_/_B_/_C_
    ${date}     Get Current Date        result_format=datetime
    ${year}     Convert To String    ${date.year}
    ${serverdate}     Replace string    ${serverdate}    _A_    ${year}
    ${month}     Convert To String    ${date.month}
    IF    ${month} < 10
        ${serverdate}     Replace String   ${serverdate}    _B_    0${month}
    ELSE
         ${serverdate}     Replace String   ${serverdate}    _B_    ${month}
    END
    #might need to add 0 if less than 10
     ${day}     Convert To String    ${date.day}
     IF    ${day} < 10
        ${serverdate}     Replace String   ${serverdate}    _C_    0${day}
    ELSE
         ${serverdate}     Replace String   ${serverdate}    _C_    ${day}
    END
    Log    ${serverdate}
    set Test Variable      ${serverdate}


 get sent date
      [Documentation]   get current date  in dd/mm/yy format
      set test variable    ${sentdate}       _B_/_C_/_A_
    ${date}     Get Current Date        result_format=datetime
    ${year}     Convert To String    ${date.year}
    ${sentdate}     Replace string    ${sentdate}    _A_    ${year}
    ${month}     Convert To String    ${date.month}
    IF    ${month} < 10
        ${sentdate}     Replace String   ${sentdate}    _B_    0${month}
    ELSE
         ${sentdate}     Replace String   ${sentdate}    _B_    ${month}
    END
    #might need to add 0 if less than 10

    ${day}     Convert To String    ${date.day}

     IF    ${day} < 10
        ${sentdate}     Replace String   ${sentdate}    _C_    0${day}
    ELSE
         ${sentdate}     Replace String   ${sentdate}    _C_    ${day}
    END

    Log    ${sentdate}
    set Test Variable      ${sentdate}

