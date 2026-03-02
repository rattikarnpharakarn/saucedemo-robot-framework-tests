*** Settings ***
Documentation     Test suite สำหรับฟีเจอร์ Add to Cart
Resource          ../resources/login_page.robot
Resource          ../resources/product_page.robot
Resource          ../resources/env_config.robot


Suite Setup       Run Keywords    Open Browser To Login Page    AND    Login With Valid User    ${VALID_MASTER_USER}    ${VALID_MASTER_PASS}  


Suite Teardown    Close Browser

Test Teardown     Clear Cart Data From Browser

*** Test Cases ***
TC_001: User Should Be Able To Add Product To Cart
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1


TC_002: User Should Be Able To Remove Product From Cart
    [Documentation]    ทดสอบลบสินค้าออกจากตะกร้าและ Badge ต้องหายไป
    [Tags]    Cleanup
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Remove Product From Cart By ID    Sauce Labs Backpack
    Verify Cart Is Empty


TC_003: User Should Be Able To Add Product To Cart BY Item Page
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge จากหน้า รายละเอียดสินค้า
    [Tags]    Positive
    Click Product ID To View Detail  Sauce Labs Backpack 
    Location Should Contain    inventory-item.html
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
   

TC_004: User Should Be Able To Remove Product From Cart BY Item Page
    [Documentation]    ทดสอบลบสินค้าออกจากตะกร้าและ Badge ต้องหายไป จากหน้า รายละเอียดสินค้า
    [Tags]    Cleanup
    Click Product ID To View Detail  Sauce Labs Backpack
    Wait Until Location Contains    inventory-item.html    timeout=5s
    Location Should Contain    inventory-item.html
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Remove Product From Cart By ID    Sauce Labs Backpack
    Verify Cart Is Empty

    
TC_005: User Should Be Able To Add Multiple Product To Cart
    [Documentation]    ทดสอบเพิ่มสินค้าหลายรายการลงตะกร้าและตรวจสอบตัวเลข Badge
    [Tags]    Positive
    Verify On Product Page
    ${product_list}    Create List    Sauce Labs Backpack    Sauce Labs Bike Light    Sauce Labs Bolt T-Shirt  
    ${cart_bage}    Get Length    ${product_list}
    FOR   ${product}  IN  @{product_list}
        Add Product To Cart By ID   ${product}
    END
    Verify Cart Badge Updated   ${cart_bage}


TC_006: Verify Shopping Cart Persistence Across Different Pages
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข BadgeและNaviage to anoter page สินค้ายังคงอยู่และถูกต้องหรือไม่
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Execute Javascript    document.querySelector('.shopping_cart_link').click()  
    Wait Until Location Contains    cart.html    timeout=5s
    Wait Until Element Is Visible    css:.cart_item        
    Element Should Contain          css:.inventory_item_name    Sauce Labs Backpack


TC_007: Verify Shopping cart Data Persistence During Open new tabs in Browser
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge และเปิด url ของ web ใน browser tab ใหม่เพื่อเช็คข้อมูลสินค้าที่เพิ่มว่ายังคงอยู่และถูกต้องหรือไม่
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Execute Javascript              window.open('https://www.saucedemo.com/cart.html')
    Switch Window                   NEW
    Wait Until Location Contains    cart.html    timeout=5s
    Wait Until Element Is Visible   css:.cart_item    timeout=5s
    Element Should Contain          css:.inventory_item_name    Sauce Labs Backpack
    Verify Cart Badge Updated       1
    Switch Window                   MAIN


TC_008: Verify Shopping cart Data Persistence During Page Refresh
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge และ refresh หน้าจอ เช็คสินค้าว่ายังคงอยู่และแสดงถูกต้องหรือไม่
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Reload Page
    Wait Until Element Is Visible    css:.shopping_cart_link    timeout=5s
    Wait Until Element Is Enabled    css:.shopping_cart_link    timeout=5s
    Execute Javascript    document.querySelector('.shopping_cart_link').click() 
    Wait Until Location Contains    cart.html    timeout=5s
    Wait Until Element Is Visible   css:.cart_item    timeout=5s
    Element Should Contain          css:.inventory_item_name    Sauce Labs Backpack
    Verify Cart Badge Updated       1
    

TC_009: Verify Shopping cart Data Persistence During Page Reopening Closed tabs
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge และ ปิด tabs browser และ เปิดใหม่เช็คสินค้าว่ายังคงอยู่และถูกต้องหรือไม่
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Execute Javascript              window.open('https://www.saucedemo.com/cart.html')
    Switch Window                   NEW
    Switch Window                   MAIN
    Close Window
    Switch Window                   MAIN
    Wait Until Location Contains    cart.html    timeout=5s
    Wait Until Element Is Visible   css:.cart_item    timeout=5s
    Element Should Contain          css:.inventory_item_name    Sauce Labs Backpack
    Verify Cart Badge Updated       1


TC_010: User Should Be Able To Add Product To Cart From Inventory page And Can Remove Product Form Product detail page
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge จากหน้า Inventory และสามารถลบสินค้าจากหน้า Product detail
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Click Product ID To View Detail  Sauce Labs Backpack 
    Location Should Contain    inventory-item.html
    Remove Product From Cart By ID    Sauce Labs Backpack
    Verify Cart Is Empty

TC_011: User Should Be Able To Add Product To Cart From Product detail page page And Can Remove Product Form Inventory page
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge จากหน้า Product detail และสามารถลบสินค้าจากหน้า Inventory
    [Tags]    Positive
    Click Product ID To View Detail  Sauce Labs Backpack 
    Location Should Contain    inventory-item.html
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Go Back
    Verify On Product Page
    Remove Product From Cart By ID    Sauce Labs Backpack
    Verify Cart Is Empty


TC_012: User Should Be Able To Sorted By Price in Descending Order (High to Low)
    [Documentation]    ทดสอบเพิ่มSorted by price เรียงราคาจากมากไปน้อย
    [Tags]    Positive
    Verify On Product Page
    Select From List By Value  css:.product_sort_container  hilo
    ${actual_text}=    Execute Javascript    return document.querySelector('.active_option').innerText
    Should Contain    ${actual_text}    Price (high to low)  
    ${price_elements}=    Get WebElements    css:.inventory_item_price
    ${prices}=            Create List
    FOR    ${el}    IN    @{price_elements}
        ${text}=          Get Text    ${el}
        ${num}=           Remove String    ${text}    $
        ${num_float}=     Convert To Number    ${num}   
        Append To List    ${prices}    ${num_float}
    END
    ${expected_sort}=     Copy List    ${prices}
    Sort List             ${expected_sort}  
    Reverse List          ${expected_sort} 
    Lists Should Be Equal    ${prices}    ${expected_sort}


TC_013: User Should Be Able To Sorted By Price in Ascending Order (Low to High)
    [Documentation]    ทดสอบเพิ่มSorted by price เรียงราคาจากน้อยไปมาก
    [Tags]    Positive
    Verify On Product Page
    Execute Javascript    document.querySelector('.product_sort_container').click() 
    Select From List By Value  css:.product_sort_container  lohi
    ${actual_text}=    Execute Javascript    return document.querySelector('.active_option').innerText
    Should Contain    ${actual_text}   Price (low to high)
    ${price_elements}=    Get WebElements    css:.inventory_item_price
    ${prices}=            Create List
    FOR    ${el}    IN    @{price_elements}
        ${text}=          Get Text    ${el}
        ${num}=           Remove String    ${text}    $
        ${num_float}=     Convert To Number    ${num}   
        Append To List    ${prices}    ${num_float}
    END
    ${expected_sort}=     Copy List    ${prices}
    Sort List             ${expected_sort}  
    Lists Should Be Equal    ${prices}    ${expected_sort}


TC_014: User Should Be Able To Sorted By Name in Descending Order (Z-A)
    [Documentation]    ทดสอบเพิ่มSorted by Name เรียงจากตัวหนังสือ Z-A
    [Tags]    Positive
    Verify On Product Page
    Execute Javascript    document.querySelector('.product_sort_container').click() 
    Select From List By Value  css:.product_sort_container  za
    ${actual_text}=    Execute Javascript    return document.querySelector('.active_option').innerText
    Should Contain    ${actual_text}     Name (Z to A)
    ${name_elements}=    Get WebElements    css:.inventory_item_name
    ${names}=            Create List
    FOR    ${el}    IN    @{name_elements}
        ${text}=          Get Text    ${el} 
        Append To List    ${names}    ${text}
    END
    ${expected_sort}=     Copy List    ${names}
    Sort List             ${expected_sort}  
    Reverse List          ${expected_sort}
    Lists Should Be Equal    ${names}    ${expected_sort}


TC_015: User Should Be Able To Sorted By Name in Ascending Order (A-Z)
    [Documentation]    ทดสอบเพิ่มSorted by Name เรียงจากตัวหนังสือ A-Z
    [Tags]    Positive
    Verify On Product Page
    Execute Javascript    document.querySelector('.product_sort_container').click() 
    Select From List By Value  css:.product_sort_container  az
    ${actual_text}=    Execute Javascript    return document.querySelector('.active_option').innerText
    Should Contain    ${actual_text}     Name (A to Z)
    ${name_elements}=    Get WebElements    css:.inventory_item_name
    ${names}=            Create List
    FOR    ${el}    IN    @{name_elements}
        ${text}=          Get Text    ${el} 
        Append To List    ${names}    ${text}
    END
    ${expected_sort}=     Copy List    ${names}
    Sort List             ${expected_sort}  
    Lists Should Be Equal    ${names}    ${expected_sort}

TC_016: Verify Shopping cart Persistence After User Logout And Re-Login
    [Documentation]    ทดสอบเพิ่มสินค้าลงตะกร้าและตรวจสอบตัวเลข Badge และ Logout และ Login ใหม่
    [Tags]    Positive
    Verify On Product Page
    Add Product To Cart By ID    Sauce Labs Backpack
    Verify Cart Badge Updated    1
    Logout
    Verify Logout Success
    Wait Until Element Is Visible    id=user-name    timeout=5s
    Inject React Input    user-name    ${VALID_MASTER_USER}
    Inject React Input    password     ${VALID_MASTER_PASS}
    Execute Javascript    document.getElementById('login-button').click()
    Wait Until Location Contains    inventory.html    timeout=5s
    Click Element                   css:.shopping_cart_link
    Wait Until Location Contains    cart.html         timeout=5s
    Wait Until Element Is Visible   css:.cart_item    timeout=5s
    Element Should Contain          css:.inventory_item_name    Sauce Labs Backpack
    Verify Cart Badge Updated       1