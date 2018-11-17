*** Settings ***
Suite Setup    Clean
Library    OperatingSystem    

*** Keyword ***
Clean
    Run    taskkill /IM "chrome.exe" /F
