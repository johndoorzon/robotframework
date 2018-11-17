*** Settings ***
Library           SeleniumLibrary    run_on_failure=Nothing
Library           DateTime
Library           Collections
Library           OperatingSystem

*** Variables ***
${chrome_temp}    ${CURDIR}${/}ChromeTemp
${download_dir}    ${CURDIR}${/}Downloads
${ROOT}    ${CURDIR}
${BROWSER}    gc
@{mozilla}    ff    firefox
@{google}    chrome    gc
${headless}    Nee
${grid}    Ja
${grid_url}    http://192.168.1.100:4444/wd/hub
*** Keywords ***
Start browser
    [Arguments]    ${URL}
    # Open de juiste browser
    Log To Console    ${ROOT}
    Open browser met gewenst profiel    ${URL}

Open browser met gewenst profiel
    [Arguments]    ${url}    ${ff_profile_dir}=None
    [Documentation]    Opent chrome of firefox met een profiel waarin downloads automatisch worden opgeslagen (in project)
    Run Keyword If    '${headless}'=='Nee'    Log To Console    \n\nHeadless: ${headless}
    Run Keyword If    '${headless}'=='Nee'    Remove Directory    ${chrome_temp}    recursive=True
    chrome download profiel    ${url}    ${download_dir}    ${headless}
    # ${profile}=    Create Ff Profile    ${download_dir}    ${ROOT}${/}INSPECT${/}Resources${/}Custom_libraries${/}Browser_addons${/}modify_headers-0.7.1.1-fx.xpi    ${medewerker}
    # Open Browser    ${url}    ${BROWSER}    ff_profile_dir=${profile}
    Run Keyword If    '${BROWSER}' not in @{mozilla} and '${BROWSER}' not in @{google}    Open Browser IE
    # Maximize browser werkt niet onder xvfb
    Set Window Size    ${1920}    ${1080}
    Run Keyword If    '${grid}'=='Nee'    Maximize Browser Window

chrome download profiel
    [Arguments]    ${URL}    ${download_dir}    ${headless}
    [Documentation]    Creëert webdriver profiel voor chrome dat downloads automatisch opslaat op de gewenste locatie
    # Open de chrome opties
    ${chromeOptions}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Set Global Variable    ${chromeOptions}
    # Geef de profielfolder mee als argument
    ${args} =    Set variable    user-data-dir=${chrome_temp}
    # Zet de plugins die je wilt uitschakelen
    ${disabled}=    Create List    Chrome PDF Viewer
    # Zet de downloadfolder en zet plugins uit (zodat downloads niet geopend worden maar meteen opgeslagen
    ${prefs} =    Create Dictionary    download.default_directory=${download_dir}    plugins.plugins_disabled=${disabled}
    # Voeg de extensie ModHeader, Jquery debugger, alsmede bovenstaande opties toe aan het profiel
    Call Method    ${chromeOptions}    add_extension    ${ROOT}${/}jquery_debugger.crx    #Jquery debugger extension
    # Call Method    ${chromeOptions}    add_extension    ${ROOT}${/}INSPECT${/}Resources${/}Custom_libraries${/}Browser_addons${/}Adblock-Plus_v1.12.4.crx    #Jquery debugger extension
    # Run Keyword If    '${omgeving.login}'=='Nee'    Call Method    ${chromeOptions}    add_extension    ${ROOT}${/}INSPECT${/}Resources${/}Custom_libraries${/}Browser_addons${/}idgpnmonknjnojddfkpgkljpfnnfcklj-2.1.2-Crx4Chrome.com.crx    #Modheader
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}
    Run Keyword If    "${grid}"=="Nee"    Call Method    ${chromeOptions}    add_argument    ${args}
    # Nodig voor Adblock plus
    Call Method    ${chromeOptions}    add_argument    no-sandbox
    Call Method    ${chromeOptions}    add_argument    disable-dev-shm-usage
    # Headless of niet
    Run Keyword If    '${headless}'=='Ja'    Call Method    ${chromeOptions}    add_argument    headless
    Run Keyword If    '${headless}'=='Ja'    Call Method    ${chromeOptions}    add_argument    disable-gpu
    ${chromeOptions}=    Call Method    ${chromeOptions}    to_capabilities
    # Cre�er het chrome profiel
    # ${grid_url}    Set Variable If    '${OS}'!='Windows_NT'    http://url/wd/hub    http://url/wd/hub
    Run Keyword If    '${grid}'=='Nee'    Chrome lokaal
    Run Keyword If    '${grid}'=='Ja'    Chrome Grid    ${grid_url}
    # Open chrome en ga naar de addon ModHeader om de juiste headers te kunnen zetten
    # Run Keyword If    '${omgeving.login}'=='Nee'    Go To    chrome-extension://idgpnmonknjnojddfkpgkljpfnnfcklj/icon.png
    # Run Keyword If    '${omgeving.login}'=='Nee'    Execute Javascript    localStorage.setItem('profiles', JSON.stringify([{title: 'Selenium', hideComment: true, appendMode: '', headers: [{enabled: true, name: 'LOGIN_SYSTEEM', value: 'IDENT', comment: ''}, {enabled: true, name: 'OAM_REMOTE_USER', value: '${medewerker}', comment: ''}], respHeaders: [], filters: []}]));
    # Open Inspect
    Go To    ${URL}

Open Browser IE
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.INTERNETEXPLORER    sys,selenium.webdriver
    Set To Dictionary    ${options}    ignoreProtectedModeSettings    ${True}
    Open Browser    ${URL}    Internet Explorer    desired_capabilities=${options}

Chrome lokaal
    Create Webdriver    Chrome    chrome_options=${chromeOptions}

Chrome Grid
    [Arguments]    ${grid_url}
    ${options}=    Call Method    ${chromeOptions}    to_capabilities
    # Create Webdriver    Remote    command_executor=http://localhost:5555/wd/hub    desired_capabilities=${options}
    Create Webdriver    Remote    command_executor=${grid_url}    desired_capabilities=${options}
