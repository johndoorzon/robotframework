*** Settings ***
Suite Setup    Clean
Library    OperatingSystem    
*** Variables ***
*** Keywords ***

Clean
    Run    taskkill /IM "chrome.exe" /F