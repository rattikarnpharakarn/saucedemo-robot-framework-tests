*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary
Library           String
Library           Collections

*** Variables ***
${SERVER}         https://www.saucedemo.com/
${INVEN_ITEM_URL}    ${SERVER}inventory-item.html?id=
${INVENTORY_URL}    ${SERVER}inventory.html
${BROWSER}        Chrome
${DELAY}         0
${CART_BADGE}              class=shopping_cart_badge
${PRODUCT_TITLE}           class=title
${ADD_TO_CART_PREFIX}      id=add-to-cart-
${REMOVE_FROM_CART_PREFIX}  id=remove-



*** Keywords ***
Verify on Product Page
    Element Text Should Be    ${PRODUCT_TITLE}   Products
    Set Selenium Speed    ${DELAY}

Click Product ID To View Detail
    [Arguments]    ${product_id}
    [Documentation]    คลิกที่ชื่อสินค้าเพื่อเข้าไปดูรายละเอียด
    Wait Until Page Contains    ${product_id}    timeout=10s
    
    # 2. ใช้ JavaScript XPath สั่งคลิกไปที่ Text นั้นเลย
    # คำสั่งนี้จะหา Element ที่เป็น <div> หรือ <a> ที่มีข้อความตรงกับชื่อสินค้าแล้วสั่งคลิก
    Execute Javascript    
    ...    var xpath = "//div[text()='${product_id}']";
    ...    var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    ...    if (element) { element.click(); }
    
    # 3. ตรวจสอบว่าหน้าเปลี่ยนหรือยัง
    Wait Until Location Contains    inventory-item.html    timeout=5s

Add Product To Cart By ID
    [Arguments]    ${product_id}
    ${current_url}=    Get Location
    IF    'inventory-item.html' in '${current_url}'
        ${target}=    Set Variable    id=add-to-cart
        Wait Until Element Is Visible    ${target}    timeout=10s
        Scroll Element Into View         ${target}
        # ใช้ Execute Javascript เพื่อสั่งคลิกโดยตรงที่ Element ID นั้น
        Execute Javascript    document.getElementById('${target.replace('id=', '')}').click()
    ELSE
        ${dynamic_id}=    Convert To Lower Case    ${product_id}
        ${dynamic_id}=    Replace String    ${dynamic_id}    ${SPACE}    -
        ${target}=    Set Variable    ${ADD_TO_CART_PREFIX}${dynamic_id}
        Wait Until Element Is Visible    ${target}    timeout=10s
        Scroll Element Into View         ${target}
        # ใช้ Execute Javascript เพื่อสั่งคลิกโดยตรงที่ Element ID นั้น
        Execute Javascript    document.getElementById('${target.replace('id=', '')}').click()
    END
   

Remove Product From Cart By ID
    [Arguments]    ${product_id}
     ${current_url}=    Get Location
    IF    'inventory-item.html' in '${current_url}'
        ${target_id}=    Set Variable    id=remove
        Wait Until Element Is Visible    ${target_id}    timeout=10s
        Scroll Element Into View         ${target_id}
        Execute Javascript    document.getElementById('${target_id.replace("id=", "")}').click()
    ELSE
        ${dynamic_id}=    Convert To Lower Case    ${product_id}
        ${dynamic_id}=    Replace String    ${dynamic_id}    ${SPACE}    -
        ${target_id}=    Set Variable    ${REMOVE_FROM_CART_PREFIX}${dynamic_id}
        Wait Until Element Is Visible    ${target_id}    timeout=10s
        Scroll Element Into View         ${target_id}
        Execute Javascript    document.getElementById('${target_id.replace("id=", "")}').click()
    END
    # 3. ให้เวลาหน้าเว็บอัปเดต Badge แป๊บหนึ่งก่อนไปเช็ก 0
    Sleep    1s

Verify Cart Badge Updated
    [Arguments]    ${cart_bage}
    # เพิ่มบรรทัดนี้: รอให้ Badge โผล่มาก่อนค่อยเช็กเลขข้างใน
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=10s
    Element Text Should Be           ${CART_BADGE}    ${cart_bage}


Verify Cart Is Empty
    # นับจำนวน Badge ที่อยู่ในหน้าเว็บ
    ${count}=    Get Element Count    class=shopping_cart_badge
    # ถ้าจำนวนเป็น 0 แปลว่าตะกร้าว่าง (ผ่าน!)
    Should Be Equal As Integers    ${count}    0    msg=ยังมีสินค้าค้างอยู่ในตะกร้า!



Clear Cart Data From Browser
    [Documentation]    ล้างข้อมูลตะกร้าผ่าน Browser Storage โดยตรง (ท่าการทำงานจริง)
    Execute Javascript    window.localStorage.removeItem('cart-contents');
    Reload Page
    Go To    ${INVENTORY_URL}
    