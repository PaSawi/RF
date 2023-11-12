*** Settings ***
Documentation      VENO Keywords
Library            RPA.Desktop
Library            RPA.Windows
Library            Collections

*** Variables ***
${NEW_DEVICE_NUMBER}=    ${0}

*** Keywords ***

Add New Device
    [Documentation]    Add the new Veno device. Enter one of device type:
    ...    Polon 6000, Polon 3000, Polon 4000, CDG 6000, mCDG 6000
    [Arguments]    ${device_type}    ${number_of_devices}    ${NEW_DEVICE_NUMBER}
    FOR    ${counter}    IN RANGE    0    ${number_of_devices}
        Select New Device Type    ${device_type}
        Checking The Window Of The Added Device    ${device_type}
        ${NEW_DEVICE_NUMBER}=    Complete The Fields In The New Device Window    
        ...    ${device_type}    ${NEW_DEVICE_NUMBER}
    END

Check The Number Of Elements After Adding Or Substraction New Ones
    [Arguments]    ${value_before_change}    ${change_value}    ${count_devices}
    ${number_after}=    Find Elements By Alias And Count    ${count_devices}
    # Log To Console    value before change: ${value_before_change}
    Log To Console    change value: ${change_value}
    IF    ${value_before_change} < ${number_after}
        ${check_number}=    BuiltIn.Evaluate    ${number_after}-${change_value}
    ELSE
        ${check_number}=    BuiltIn.Evaluate    ${number_after}+${change_value}
    END
    # Log To Console    number after add: ${number_after}
    ${status}=    BuiltIn.Run Keyword And Return Status
    ...    BuiltIn.Should Be Equal As Integers    ${check_number}    ${value_before_change}
    IF    ${status} == $False    BuiltIn.Fail    Error: Incorrect item addition
    BuiltIn.Should Be Equal As Integers    ${check_number}    ${value_before_change}
    RETURN    ${status}

Checking The Window Of The Added Device
    [Arguments]    ${device_type}
    IF    '${device_type}' == 'Polon 6000'
        # Log To Console    POLON 6000
        Wait For Element    w_polon_6000    timeout=1
    ELSE IF    '${device_type}' == 'Polon 4000'
        # Log To Console    POLON 4000
        Wait For Element    w_polon_4000    timeout=1
    ELSE
        Log    Incorrect device name: ${device_type}    level=ERROR
        Fail
    END

Complete The Fields In The New Device Window
    [Arguments]    ${device_type}    ${name_number}
    FOR    ${counter}    IN RANGE    ${name_number}    99
        ${new_device_name}=    BuiltIn.Catenate    ${device_type}_${name_number}
        IF    '${device_type}' == 'Polon 6000'
            Send Keys    id:textBoxName_Value    keys={ctrl}a{del}${new_device_name}
            Send Keys    id:textBoxIP_Value    keys={ctrl}a{del}192.168.1.${name_number}
            ${repeat_name_status}=    Run Keyword And Return Status    Find Element    repeat_name
            ${repeat_ip_status}=    Run Keyword And Return Status    Find Element    repeat_ip
            IF    ('${repeat_name_status}'!='True') or ('${repeat_ip_status}'!='True')    BREAK
            ${name_number}=    Evaluate    ${name_number} + 1
        ELSE IF    '${device_type}' == 'Polon 4000'
            Send Keys    id:textBox_Value    keys={ctrl}a{del}${new_device_name}
            ${repeat_name_status}=    Run Keyword And Return Status    Find Element    repeat_name
            IF    ('${repeat_name_status}'!='True')    BREAK
            ${name_number}=    Evaluate    ${name_number} + 1
        ELSE
            Log    Incorrect new name    level=ERROR
            Fail
        END
    END
    ${status}=    Run Keyword And Return Status    Find Element    empty_field
    IF    ${status} == ${True}    Fail    Empty fields
    ${status}=    Wait For Element    Anuluj_OK    timeout=1
    RPA.Windows.Click    OK
    Log To Console    Add new device: ${new_device_name}
    ${name_number}=    Evaluate    ${name_number}+1
    RETURN    ${name_number}

Delete Devices
    [Documentation]     To remove devices, enter the alias_name to the appropriate device: 
    ...    count_Polon_6000 or count_Polon_4000
    [Arguments]    ${alias_name}
    Control Window    name:Urządzenia
    ${number}=    Find Elements By Alias And Count    ${alias_name}
    FOR    ${counter}    IN RANGE    0    ${number}
        ${devices}=    Find Elements    ${alias_name}
        ${reversed_devices}=    Reverse List    ${devices}
        FOR    ${element}    IN    @{devices}
            RPA.Desktop.Click    ${element}
            Control Window    name:Urządzenia
            RPA.Windows.Click    name:Usuń
            Control Window    id:toolWindowBase
            RPA.Windows.Click    name:Tak
            Sleep    1
            BREAK
        END
    END
    ${element_status}=    Run Keyword And Return Status    Find Element    ${alias_name}
        IF    ('${element_status}'=='False')    
            Log To Console   Item ${alias_name} removed.
        ELSE
            Log    Item ${alias_name} deletion failed.        level=ERROR
            Fail
        END

Find Elements By Alias And Count
    [Documentation]     Change the alias to the appropriate system: count_Polon_6000 or count_Polon_4000
    [Arguments]    ${picture_alias}
    ${matches}=    RPA.Desktop.Find Elements    alias:${picture_alias}
    ${count}=    BuiltIn.Get Length    ${matches}
    ${count}=    BuiltIn.Convert To Integer    ${count}
    IF    ${count} == 0    Log To Console    No matching elements
    RETURN    ${count}

Open The Device Tab
    RPA.Windows.Control Window    name:"VENO | Numer monitora: 1"
    RPA.Desktop.Click    alias:tab_options
    Sleep    1
    RPA.Windows.Click    type:WindowControl -> class:TextBlock -> path:1|1|3    # open Urządzenia tab

Save And Close Device Tab
    Sleep    1
    RPA.Windows.Control Window    name:Urządzenia
    RPA.Desktop.Click    Centrala_PPOZ
    RPA.Windows.Click    name:Zapisz
    Sleep    1
    RPA.Windows.Click    name:OK

Select New Device Type
    [Arguments]    ${device_type}
    ${selected_device_type}=    Set Variable    ${device_type}
    RPA.Windows.Control Window    name:Urządzenia
    RPA.Windows.Click    name:"Nowe urządzenie"
    RPA.Windows.Control Window    name:"Nowe urządzenie"
    Send Keys    id:comboBox    keys=${selected_device_type}
    Wait For Element    w_New_device_type    timeout=1
    RETURN    ${selected_device_type}
