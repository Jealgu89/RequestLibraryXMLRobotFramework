*** Settings ***
Documentation           Datadriven testing for cardscan

Library    DataDriver   ../SCSVFiles/Cardscan/${Instance}Cardscan.csv

Suite Setup      Login to SIT${INSTANCE} database
Suite Teardown      Disconnect From Database


Resource    ../Keywords/Cardscan.robot
Resource    ../Keywords/General.robot
Resource    ../Keywords/GeneralQueries.robot
Resource    ../Testdata/Requests/Cardscan${INSTANCE}.robot
Test Template       Cardscan






*** Variables ***


${base_url}
${channel_url}=
&{headers}        Content-Type=text/xml;


#${INSTANCE}     3
${pathresponse}      ../s/Responses/Cardscan/${INSTANCE}Cardscan_i_.txt
${pathrequest}      ../sequests/Cardscan/Cardscan.txt

# errModule is used for querying cx error log
${errModule}

*** Test Cases ***
Cardscan With ${i} ${env} ${responsecode} ${cardnumber} ${bucode}






*** Keywords ***


Cardscan
    [Arguments]     ${i}     ${responsecode}  ${cardnumber}   ${bucode}
    Create request          ${i}       ${cardnumber}   ${bucode}       x        x       x
    Create expected response        ${i}
    Send soap message           ${responsecode}
    Check response
    Check cx error log      ${cardnumber}




