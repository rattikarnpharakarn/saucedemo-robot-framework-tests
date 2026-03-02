*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary


*** Variables ***
${SERVER}         https://www.saucedemo.com/
${BROWSER}        Chrome
${DELAY}          0.5
${LOGIN URL}      ${SERVER}
${WELCOME_URL}    ${SERVER}inventory.html



*** Keywords ***
Open Browser To Login Page
   ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys

    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu


    Call Method    ${chrome_options}    add_argument    --disable-save-password-bubble
    Call Method    ${chrome_options}    add_argument    --disable-features\=SafeBrowsingPasswordCheck
    Call Method    ${chrome_options}    add_argument    --disable-features\=PasswordLeakDetection
    
    ${prefs}=    Create Dictionary    
    ...    credentials_enable_service=${FALSE}    
    ...    profile.password_manager_enabled=${FALSE}    
    ...    profile.password_check_enabled=${FALSE}
    
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}

    Open Browser    ${LOGIN URL}    ${BROWSER}    options=${chrome_options}
    Wait Until Page Contains Element    id=user-name    timeout=10s
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open
    

Login Page Should Be Open
    Title Should Be    Swag Labs


Input Username
    [Arguments]    ${username}
    Input Text    id=user-name    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id=password    ${password}

Submit Credentials
    Click Element   id=login-button

Login With Valid User
    [Arguments]    ${valid_username}    ${valid_password}
    [Documentation]    
    Click Element                    id=user-name
    Input Username    ${valid_username}
    Input Password    ${valid_password}
    Submit Credentials
    Welcome Page Should Be Open

Welcome Page Should Be Open
    Location Should Be    ${WELCOME_URL}
    Title Should Be    Swag Labs
    Element Should Be Visible    class:title


Error Message Should Be Displayed 
    [Arguments]    ${expected_error}
    Wait Until Element Is Visible    css:h3[data-test="error"]    timeout=5s
    Element Text Should Be    css:h3[data-test="error"]    ${expected_error}


Logout
    Location Should Be    ${WELCOME_URL}
    Title Should Be    Swag Labs
    Element Should Be Visible    class:title
    Execute Javascript    document.getElementById('react-burger-menu-btn').click()
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Execute Javascript    document.getElementById('logout_sidebar_link').click()


Verify Logout Success
    Location Should Contain    ${SERVER}
    Wait Until Element Is Visible    css:#login-button    timeout=5s
    Element Should Not Be Visible    id=logout_sidebar_link


Inject React Input
    [Arguments]    ${element_id}    ${value}
    ${js_code}=    Catenate    SEPARATOR=\n
    ...    var el = document.getElementById('${element_id}');
    ...    var nativeSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    ...    nativeSetter.call(el, '${value}');
    ...    el.dispatchEvent(new Event('input', { bubbles: true }));
    Execute Javascript    ${js_code}
    