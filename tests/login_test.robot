*** Settings ***
Documentation     Test Suite สำหรับ Login โดยใช้ข้อมูลจาก CSV
Resource          ../resources/login_page.robot
Library           DataDriver    file=../data/login_data.csv    encoding=utf-8  dialect=unix
Test Setup        Open Browser To Login Page
Test Teardown     Close Browser
Test Template     Login Scenario Template

*** Test Cases ***
Login Scenario with CSV

*** Keywords ***
Login Scenario Template
    [Arguments]    ${test_id}    ${username}    ${password}    ${expected_error}
    Input Username    ${username}
    Input Password    ${password}
    Submit Credentials
    
    IF    '${expected_error}' == '${EMPTY}'
        Welcome Page Should Be Open
    ELSE
        Error Message Should Be Displayed    ${expected_error}
    END
