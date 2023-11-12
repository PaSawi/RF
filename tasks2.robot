*** Settings ***
Documentation       Veno automatic tests

Resource            ./resources/keywords.robot
Resource            ./tools/print_tree.robot
Library             RPA.Windows
Library             RPA.Desktop
Library             RPA.Desktop.OperatingSystem
Library             Dialogs
Library             RPA.FTP


*** Test Cases ***
000 To open Veno    [Tags]    000    start
    ${user_name}=    Get Username
    Dialogs.Pause Execution
    ...    message=Hello ${user_name}, I am Robot Script :)${\n}After displaying the system window: 'User account control', ${\n}select: Yes.
    # Required setting of the environment variable for the executable file location
    RPA.Windows.Windows Run
    ...    VenoClient
    Wait For Element    veno_logo    timeout=5

001 Log to Veno    [Tags]    001    smoke
    RPA.Windows.Control Window    regex:VENO*
    Send Keys    class:TextBox -> path:3|2    keys=root
    Send Keys    class:PasswordBox -> path:4|2    keys=pass
    RPA.Windows.Click    name:Logowanie
    Wait For Element    veno_POLON-ALFA    timeout=3

002 Open the device tab    [Tags]    002    smoke
    Open The Device Tab

003 Add the new device POLON 6000    [Tags]    003    smoke
    ${before_add}=    Find Elements By Alias And Count    count_Polon_6000    # change the alias to the appropriate system
    ${add_quantity}=    set Variable    ${2}
    ${start_name_number}=    Set Variable    ${1}
    Add New Device    Polon 6000    ${add_quantity}    ${start_name_number}
    Check The Number Of Elements After Adding Or Substraction New Ones
    ...    ${before_add}    ${add_quantity}    count_Polon_6000    # change the alias to the appropriate system

004 Add the new device POLON 4000    [Tags]    004    smoke
    ${before_add}=    Find Elements By Alias And Count    count_Polon_4000    # change the alias to the appropriate system
    ${add_quantity}=    set Variable    ${2}
    ${start_name_number}=    Set Variable    ${1}
    Add New Device    Polon 4000    ${add_quantity}    ${start_name_number}
    Check The Number Of Elements After Adding Or Substraction New Ones
    ...    ${before_add}    ${add_quantity}    count_Polon_4000    # change the alias to the appropriate system
    Save And Close Device Tab

005 Delete devices    [Tags]    005    smoke
    [Documentation]     Change the alias name to the appropriate device: 
    ...    count_Polon_6000 or count_Polon_4000
    Open The Device Tab
    Delete Devices    count_Polon_4000
    Delete Devices    count_Polon_6000
    Save And Close Device Tab
