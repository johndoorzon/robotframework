*** Settings ***
Library    SeleniumLibrary  
Library    Dialogs
Resource    ../Resources/Browser.robot
Resource    ../Resources/Setup.robot
Test Setup    Run Keywords    Set Log Level    INFO    AND    Clean
Test Teardown    Close Browser    
  
*** Variables ***
${timeout}    20
@{main_menu}    Categorieën    Cadeaus & Inspiratie    Aanbiedingen
*** Test Cases ***
Open browser en navigeer naar Bartosz home
    Start browser    https://www.bartosz.nl
    Klik link    Bartosz    
    Wait Until Element Is Visible    jquery:.staff-slider    timeout=${timeout}    
    ${mgmt}    Get Element Count    jquery:.slide.slick-slide:contains("Maarten")
    Should Be Equal As Integers    ${mgmt}    ${2}    
    Log To Console    \n\nAantal foto's: ${mgmt}    
    # Pause Execution

Open browser en navigeer naar Bol.com home
    Start browser    https://www.bol.com
    Verifieer header
    # Pause Execution
    
    
*** Keywords ***
Klik link
    [Arguments]    ${linktekst}
    Wait Until Element Is Visible    jquery:.home-link:contains("${linktekst}")    timeout=${timeout}    
    Wait For Condition    return jQuery.active==0    timeout=${timeout}    
    Click Link    ${linktekst}
    Wait For Condition    return jQuery.active==0    timeout=${timeout} 
    
Open url
    [Arguments]    ${url}
    Open Browser    ${url}    gc
    Wait For Condition    return jQuery.active==0    timeout=${timeout}    
    
    Maximize Browser Window
    
Verifieer header
    Wait Until Element Is Visible    jquery:.header-section
    Check main menu buttons
    


Check main menu buttons
    :FOR    ${item}    IN    @{main_menu}
    \    ${item_aanwezig}    Run Keyword And Return Status    Element Should Be Visible    jquery:nav.main-menu__button:contains("${item}")
    \    Run Keyword If    ${item_aanwezig}    Log To Console    \nMenuknop ${item} is aanwezig!
    \    Run Keyword If    not ${item_aanwezig}    Set Test Message    Menuknop ${item} is niet aanwezig!\n    append=true            
           
