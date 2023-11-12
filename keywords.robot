*** Settings ***
Resource    ./variables.robot
Library        RPA.Desktop
Library        RPA.Windows
Library        String
Library        Collections
Library        DateTime

*** Keywords ***

Add Criteria
    [Documentation]    Enter number of criteria to add and number of inputs to add in each criterion.
    ...    Optionally, enter the number of detection zones in each input
    [Arguments]    ${number_of_criteria}    ${number_of_inputs}    ${zones_in_inputs}=0
    RPA.Desktop.Click    z_Kryteria
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    ${number_of}=    BuiltIn.Evaluate    ${number_of}[-2:]
    FOR    ${counter}    IN RANGE    0    ${number_of_criteria}
        RPA.Desktop.Click    Nowy
        RPA.Desktop.Click With Offset    win_opis_uzytkownika_kryt    y=15
        RPA.Windows.Send Keys    keys=New criterion with inputs containing detection zones
        Add Inputs In The Criterion Window    ${number_of_inputs}    ${zones_in_inputs}
        RPA.Desktop.Click    Dodaj
    END
    Check The Number Of Item After The Change    ${number_of}    ${number_of_criteria}

Add Detection Line From A Tree Panel
    [Arguments]    ${node_number}    ${number_of_lines}
    ${modulo}=    BuiltIn.Evaluate    ${number_of_lines}%2
    IF    '${modulo}' != '${0}'
        ${number}=    BuiltIn.Evaluate    ${number_of_lines}+1
    ELSE
        ${number}=    BuiltIn.Set Variable    ${number_of_lines}
    END
    Log To Console    number:${number}
    Search Tree Element And Click Locator    ^węzeł.*.\\[${node_number}\\]    wezel_unilocator
    ${MLD_61}=    Find Elements By Alias And Count    m_MLD-61
    ${MLD_62}=    Find Elements By Alias And Count    m_MLD-62
    ${lines}=    BuiltIn.Evaluate    (${MLD_61}+${MLD_62})*2
    Log To Console    lines:${lines}
    Move To Region Right Click Offset And Click    wezel_unilocator    30    30
    RPA.Desktop.Click With Offset    add_liczba_linii_dozorowych    x=80
    RPA.Desktop.Click
    RPA.Desktop.Press Keys    backspace
    RPA.Windows.Send Keys    keys=${number_of_lines}
    RPA.Desktop.Click    Dodaj
    Sleep    1
    ${MLD_61_2}=    Find Elements By Alias And Count    m_MLD-61
    ${MLD_62_2}=    Find Elements By Alias And Count    m_MLD-62
    ${lines2}=    BuiltIn.Evaluate    (${MLD_61_2}+${MLD_62_2})*2
    ${status}=    Warning Status If Error Window    red_x    ${ERROR BATTERY CAPACITY}    ERROR
    Log To Console    lines2:${lines2}
    IF    ${status} != ${TRUE}
        Check The Number Of Item After The Change And Compare    ${lines}    ${number}    ${lines2}
    END

Add Detection Zones To The Input In The Criterion Window
    [Arguments]    ${number_of_zones}
    FOR    ${counter}    IN RANGE    0    ${number_of_zones}
        IF    ${counter} == 2    RPA.Desktop.Press Keys    End
        RPA.Desktop.Click With Offset    win_dostepne_zasoby    y=30
        RPA.Desktop.Click    win_left_red_arrow
    END
    RPA.Desktop.Click    Zapis

Add Inputs In The Criterion Window
    [Arguments]    ${number_of_inputs}    ${number_of_zones}
    FOR    ${counter}    IN RANGE    0    ${number_of_inputs}
        RPA.Desktop.Click    win_Dodaj_kryt
        IF    ${number_of_zones} > 0
            RPA.Desktop.Click    win_ogolne
            RPA.Desktop.Press Keys    down    enter
            RPA.Desktop.Click    win_dodaj_modyfikuj
            Add Detection Zones To The Input In The Criterion Window    ${number_of_zones}
        END
        RPA.Desktop.Click With Offset    win_Dodaj_wej_kryt    x=-15    y=40
        Sleep    1
        ${image_status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    win_uwaga_wejscie
        IF    ${image_status} == True    RPA.Desktop.Press Keys    enter
    END

Add Line Elements By Drag And Drop
    [Arguments]    ${picture_alias}    ${number_of_elements}
    ${element}=    RPA.Desktop.Find Element    alias:${picture_alias}
    ${line_hub}=    RPA.Desktop.Find Element    alias:green_line_hub
    RPA.Desktop.Drag And Drop    ${element}    ${line_hub}
    RPA.Desktop.Click
    FOR    ${counter}    IN RANGE    1    ${number_of_elements}    1
        Log    ${counter}
        Sleep    1
        RPA.Desktop.Click
    END
    Sleep    1
    ${image_status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    alias:line_protocol_error
    IF    ${image_status} != True    RPA.Desktop.Press Keys    Esc
    RETURN    ${number_of_elements}

Add Line Elements, Inputs, Conventional Lines To The Detection Zones
    [Documentation]    Chose ${type}: Elementy, Wej, MLK
    [Arguments]    ${type}    ${number_of_items}    ${zone_number}    ${name_of_the_element}=default
    RPA.Desktop.Click    z_Strefy_dozorowe
    RPA.Desktop.Click With Offset    z_Strefy_dozorowe    y=30
    RPA.Windows.Send Keys    keys={home}${zone_number}{enter}
    RPA.Desktop.Click    ${type}
    Sleep    1
    # ${elementy}=    BuiltIn.Set Variable    Elementy
    ${default}=    BuiltIn.Set Variable    default

    IF    '${name_of_the_element}' != '${default}'
        RPA.Desktop.Click With Offset    win_typ    y=20
        Sleep    1
        RPA.Windows.Send Keys    keys=${name_of_the_element}{space}{enter}
        RPA.Desktop.Click    win_lupa
    END
    Sleep    1
    ${region}=    RPA.Desktop.Find Element    alias:win_w_systemie
    ${moved_region}=    RPA.Desktop.Move Region    ${region}    0    30
    FOR    ${counter}    IN RANGE    0    ${number_of_items}
        RPA.Desktop.Click    ${moved_region}
        RPA.Desktop.Click    win_left_red_arrow
    END
    RPA.Desktop.Click    Zapis
    RPA.Desktop.Click    Zamknij

Add Line Elements By Line_hub
    [Arguments]    ${name_of_the_element}    ${number_of_elements}    ${detection_zone}
    RPA.Windows.Send Keys    keys=${detection_zone}
    Find Image Move To Offset And Click    C:/grafika/elements_list_t19.png    0    0
    RPA.Windows.Send Keys    keys=${name_of_the_element}
    RPA.Desktop.Press Keys    Enter
    RPA.Desktop.Press Keys    tab
    RPA.Windows.Send Keys    keys=${number_of_elements}
    RPA.Desktop.Press Keys    Enter
    Sleep    2

Add Modules By Node_hub
    [Arguments]    ${name_of_the_module}    ${number_of_modules}
    ${string}=    BuiltIn.Set Variable    ${name_of_the_module}
    ${replaced_string}=    String.Convert To Lower Case    ${string}
    ${replaced_string}=    String.Replace String    ${replaced_string}    -    _
    ${replaced_string}=    BuiltIn.Catenate    add_${replaced_string}
    Log To Console    ${replaced_string}
    ${module_alias}=    RPA.Desktop.Move Mouse    alias:${replaced_string}
    Find Alias Move To Offset And Click    ${replaced_string}    60    0
    RPA.Desktop.Press Keys    backspace
    RPA.Windows.Send Keys    keys=${number_of_modules}
    RPA.Desktop.Press Keys    Enter
    Sleep    2
    ${module}=    BuiltIn.Catenate    check_${string}
    # RPA.Desktop.Find Element    alias:${module}
    Warning Status If Error Window
    ...    red_x    ${ERROR BATTERY CAPACITY}    ERROR

Add Modules To SM-60 By Drag And Drop
    [Arguments]    ${module_name}    ${amount_to_add}
    Get Main Window Name
    ${string}=    BuiltIn.Set Variable    ${module_name}
    ${module_alias}=    BuiltIn.Catenate    d_${string}
    ${matches}=    RPA.Desktop.Find Elements    empty_slot_SMA
    ${empty_slots}=    Find Elements By Alias And Count    empty_slot_SMA
    IF    ${empty_slots} < ${amount_to_add}
        Fail    There aren't that enought empty slot in SMA-60 ${module_name}
    END
    Log To Console    empty slots= ${empty_slots}
    ${c}=    BuiltIn.Convert To Integer    0
    ${counter}=    Set Variable    ${c}
    FOR    ${match}    IN    @{matches}
        ${region}=    RPA.Desktop.Define Region
        ...    ${match.left}    ${match.top}    ${match.right}    ${match.bottom}
        RPA.Desktop.Drag And Drop    ${module_alias}    ${region}
        RPA.Desktop.Click
        Sleep    1
        ${counter}=    BuiltIn.Evaluate    ${counter}+1
        # BuiltIn.Log To Console    ${counter}
        IF    ${counter} == ${amount_to_add}    BREAK
    END
    ${matches2}=    RPA.Desktop.Find Elements    empty_slot_SMA
    ${empty_slots2}=    Find Elements By Alias And Count    empty_slot_SMA
    Log To Console    Added ${amount_to_add} ${module_name}
    Log To Console    empty slots left= ${empty_slots2}
    RPA.Desktop.Press Keys    Esc
    ${number_of_slots}=    BuiltIn.Evaluate    ${empty_slots}-${amount_to_add}
    # BuiltIn.Log To Console    ${number_of_slots}
    BuiltIn.Should Be Equal As Integers    ${empty_slots2}    ${number_of_slots}

Add Multiple Detection Zones
    [Arguments]    ${number_of_zones}    ${label_message}=0
    Get Main Window Name
    RPA.Desktop.Click    wiele_nowych
    # RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|1|1|1|3
    RPA.Windows.Control Window    name:"Utwórz wiele stref dozorowych"
    RPA.Windows.Click    control:Custom > path:3
    RPA.Desktop.Click With Offset    win_dodaj_strefy    x=110    y=-25    action=double_click
    RPA.Windows.Send Keys    keys={back}${number_of_zones}
    IF    '${label_message}' != '${0}'
        ${loc}=    RPA.Desktop.Click With Offset    win_opis    x=50
        RPA.Windows.Send Keys    keys={ctrl}a
        RPA.Windows.Send Keys    keys={back}${label_message}
        Log To Console    label_message: ${label_message}
    END
    RPA.Desktop.Click    win_OK
    RPA.Windows.Control Window    name:"Utwórz wiele stref dozorowych"
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    win_OK
    IF    ${status} == True    RPA.Desktop.Click    win_OK
    RPA.Desktop.Click    Dodaj

Add Output Groups
    [Documentation]    Enter number of groups to create,
    ...    enter the number of outputs in each group,
    ...    optionally select the device type in the group.
    ...    The available types are: alarm, trans, zabez
    ...    The default type is set to None.
    [Arguments]    ${number_of_groups}    ${number_of_outputs_in_the group}    ${device_type}=brak
    FOR    ${counter}    IN RANGE    0    ${number_of_groups}
        RPA.Desktop.Click    Nowy
        Sleep    1
        RPA.Desktop.Click With Offset    win_opis_uzytkownika_kryt    y=15
        RPA.Windows.Send Keys    keys=New group with outputs for alarm devices
        RPA.Desktop.Click With Offset    win_typ_urzadzen    y=15
        ${brak}=    BuiltIn.Set Variable    brak
        ${alarm}=    BuiltIn.Set Variable    alarm
        ${trans}=    BuiltIn.Set Variable    trans
        ${zabez}=    BuiltIn.Set Variable    zabez
        ${status_device}=    BuiltIn.Set Variable    ${device_type}
        IF    '${status_device}' != '${brak}'
            RPA.Desktop.Press Keys    home
            IF    '${status_device}' == '${alarm}'
                RPA.Windows.Send Keys    keys={down}
            ELSE IF    '${status_device}' == '${trans}'
                RPA.Windows.Send Keys    keys={down}{down}
            ELSE IF    '${status_device}' == '${zabez}'
                RPA.Windows.Send Keys    keys={down}{down}{down}
            ELSE
                Log    Bad device_type    level=WARN
            END
            RPA.Desktop.Click
        ELSE
            Log    defaul device type = None
        END
        RPA.Desktop.Click    win_brak_kryterium_wysterowania
        RPA.Desktop.Press Keys    end
        RPA.Desktop.Click
        Sleep    1
        RPA.Desktop.Click    win_wyjscia
        Add Outputs In The Group Window    ${number_of_outputs_in_the group}
        RPA.Desktop.Click    Dodaj
    END

Add Outputs In The Group Window
    [Arguments]    ${number_of_outputs}
    RPA.Desktop.Click    win_wszystko_grupy_wyjsc
    Sleep    1
    RPA.Desktop.Click With Offset    win_wszystko_grupy_wyjsc    y=40
    Sleep    1
    RPA.Desktop.Press Keys    esc
    RPA.Desktop.Click    win_lupa
    Sleep    1
    FOR    ${counter}    IN RANGE    0    ${number_of_outputs}
        IF    ${counter} == 2    RPA.Desktop.Press Keys    End
        Move To Region Offset And Click    win_dostepne_zasoby    0    30
        RPA.Desktop.Click    win_left_red_arrow
    END

Add Resources
    [Documentation]    Add resources to User button and Schedule tasks
    [Arguments]    ${resource_type}    ${number_of_items}
    ${value}=    BuiltIn.Set Variable    ${resource_type}
    ${status}=    BuiltIn.Run Keyword And Return Status    Check If Value Exist In List    ${value}
    FOR    ${counter}    IN RANGE    0    ${number_of_items}
        IF    ${status} == True
            RPA.Desktop.Click With Offset    win_w_systemie    y=25
        ELSE
            RPA.Desktop.Click With Offset    win_dostepne_zasoby    y=25
        END
        Sleep    1
        RPA.Desktop.Click    win_left_red_arrow
    END
    RPA.Desktop.Click    Zapis
    RPA.Desktop.Click    Zamknij

Add Scenario
    [Arguments]    ${number_of_criterion}    ${resource_type}    ${number_of_items}
    ${event_name}=    BuiltIn.Convert To String    Blokowanie
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika    y=60
    Sleep    1
    RPA.Desktop.Click
    RPA.Desktop.Press Keys    ${number_of_criterion}
    RPA.Desktop.Click    win_dodaj_modyfikuj
    RPA.Desktop.Click With Offset    win_typ_zasobu    x=50
    Sleep    1
    RPA.Windows.Send Keys    keys=${resource_type}
    RPA.Desktop.Press Keys    enter
    Add Resources    ${resource_type}    ${number_of_items}
    ${label}=    BuiltIn.Convert To String    {SPACE}-{SPACE}${number_of_items}{SPACE}{SPACE}${resource_type}
    Sleep    1
    RPA.Desktop.Click With Offset    win_opis_uzytkownika    x=80
    RPA.Windows.Send Keys    keys={ctrl}a
    RPA.Windows.Send Keys
    ...    keys=Scenariusz${SPACE}${event_name}${SPACE}${label}{SPACE}od kryterium nr${SPACE}${number_of_criterion}
    RPA.Desktop.Click    check_box_field_empty
    RPA.Desktop.Click    Dodaj

Add Schedule
    [Documentation]    Enter Dzienny or Okresowy as the ${schedule_type},
    [Arguments]    ${schedule_type}
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika    x=80
    RPA.Windows.Send Keys    keys={ctrl}a
    RPA.Windows.Send Keys    keys=Harmonogram${SPACE}${schedule_type}
    ${status_schedule}=    BuiltIn.Set Variable    ${schedule_type}
    IF    '${status_schedule}' == 'Dzienny'
        Log To Console    Dzienny
        # add time ranges
        FOR    ${from}    ${to}    IN ZIP    ${LIST_TIME_FROM}    ${LIST_TIME_TO}
            RPA.Windows.Control Window    regex:Harmonogram*
            RPA.Windows.Click    type:Button path:2|6|4    # Dodaj
            RPA.Windows.Control Window    name:"Czas trwania"
            Log    from: ${from} - to: ${to}
            RPA.Desktop.Click With Offset    win_od    x=30    action=double_click
            RPA.Windows.Send Keys    keys=${from}{TAB}
            Sleep    1
            RPA.Windows.Send Keys    keys=${to}
            RPA.Windows.Click    type:Button path:2    # Dodaj
        END
        RPA.Desktop.Click With Offset    win_okresy_harmonogramu    y=110
        RPA.Desktop.Find Element    win_Usun_wejscia
    ELSE IF    '${status_schedule}' == 'Okresowy'
        Log To Console    Okresowy
        RPA.Desktop.Click With Offset    win_okresowy    x=-15
        RPA.Desktop.Click With Offset    win_od    x=30
        RPA.Desktop.Click With Offset    y=30
        RPA.Desktop.Click With Offset    win_od    x=120    action=double_click
        RPA.Windows.Send Keys    keys=0812{TAB}{down}{down}{down}{Tab}1959{Tab}
        Sleep    1
        RPA.Desktop.Find Element    win_czwartek_19
    ELSE
        Log    Wrong schedule type    level=ERROR
    END
    ${matches}=    RPA.Desktop.Find Elements    check_box_field_empty
    FOR    ${match}    IN    @{matches}
        RPA.Desktop.Click    ${match}
    END
    RPA.Windows.Control Window    regex:Harmonogram*
    RPA.Windows.Click    type:Button path:2|1    # Dodaj

Add Schedule Task
    [Documentation]    Enter BL to choose event type "Blokowanie",
    ...    enter PE to choose "Personel nieobecny" ,
    ...    or enter WY to choose "Wyłączenie czasu opóźnienia",
    ...    and then enter schedule number.
    ...    Optionally enter the resource type in the ${resource_type}.
    ...    The choices are:
    ...    Elementy liniowe, Linie dozorowe adresowalne,
    ...    Linie dozorowe konwencjonalne, Strefy dozorowe,
    ...    Grupy wyjść, Wyjścia sterujące, Wejścia kontrolne,
    ...    and finally enter the number of items to add
    [Arguments]    ${event_type}    ${schedule_no}    ${resource_type}=Moduły    ${number_of_items}=3
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_harmonogram    y=20
    Sleep    1
    RPA.Desktop.Click
    RPA.Desktop.Press Keys    ${schedule_no}
    ${status_event}=    BuiltIn.Set Variable    ${event_type}
    IF    '${status_event}' == 'BL'
        ${event_name}=    BuiltIn.Convert To String    Blokowanie
        RPA.Desktop.Click    win_dodaj_modyfikuj
        RPA.Desktop.Click With Offset    win_typ_zasobu    x=50
        Sleep    1
        RPA.Windows.Send Keys    keys=${resource_type}
        RPA.Desktop.Press Keys    enter
        Add Resources    ${resource_type}    ${number_of_items}
        ${label}=    BuiltIn.Convert To String    {SPACE}-{SPACE}${number_of_items}{SPACE}{SPACE}${resource_type}
    ELSE IF    '${status_event}' == 'PE'
        ${event_name}=    BuiltIn.Convert To String    Personel Nieobecny
        RPA.Desktop.Click With Offset    win_typ_zdarzenia    y=20
        Sleep    1
        RPA.Desktop.Click With Offset    win_typ_zdarzenia    y=50
        ${label}=    BuiltIn.Convert To String    !
    ELSE IF    '${status_event}' == 'WY'
        ${event_name}=    BuiltIn.Convert To String    Wyłączenie czasu opóźnienia
        RPA.Desktop.Click With Offset    win_typ_zdarzenia    y=20
        Sleep    1
        RPA.Desktop.Click With Offset    win_typ_zdarzenia    y=70
        ${label}=    BuiltIn.Convert To String    !
    ELSE
        Log    Wrong event type    level=ERROR
    END
    Sleep    1
    RPA.Desktop.Click With Offset    win_opis_uzytkownika    x=80
    RPA.Windows.Send Keys    keys={ctrl}a
    RPA.Windows.Send Keys    keys=Harmonogram nr{SPACE}${schedule_no},{SPACE}${event_name}${label}
    RPA.Desktop.Click    check_box_field_empty
    RPA.Desktop.Click    Dodaj

Add Single Detection Zone
    [Documentation]    Optionally add zone number and detection zone message
    [Arguments]    ${zone_number}=0    ${label_message}=0
    RPA.Desktop.Click    Nowy
    IF    '${zone_number}' != '${0}'
        RPA.Desktop.Click With Offset    win_numer_strefy    x=60    action=double_click
        RPA.Windows.Send Keys    keys={back}${zone_number}
    END
    IF    '${label_message}' != '${0}'
        ${loc}=    RPA.Desktop.Click With Offset    win_numer_strefy    y=60
        RPA.Windows.Send Keys    keys={ctrl}a
        RPA.Windows.Send Keys    keys={back}${label_message}
        Log To Console    ${label_message}
    END
    RPA.Desktop.Click    Dodaj

Add User Button
    [Documentation]    Enter BLOKOWANIE or TESTOWANIE as the ${event_type},
    ...    then enter the resource type in the ${resource_type}.
    ...    The choices are:
    ...    Elementy liniowe, Linie dozorowe adresowalne,
    ...    Linie dozorowe konwencjonalne, Strefy dozorowe,
    ...    Grupy wyjść, Wyjścia sterujące, Wejścia kontrolne,
    ...    and finally enter the number of items to add
    [Arguments]    ${event_type}    ${resource_type}    ${number_of_items}
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|9    # "User buttons"
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika    x=80
    RPA.Windows.Send Keys    keys={ctrl}a
    RPA.Windows.Send Keys
    ...    keys=Przycisk${SPACE}POLON${SPACE}6000:${SPACE}${event_type}${SPACE}-${SPACE}${resource_type}
    RPA.Desktop.Click With Offset    win_typ_zdarzenia    y=25
    RPA.Windows.Send Keys    keys=${event_type}
    RPA.Desktop.Press Keys    enter
    RPA.Desktop.Click With Offset    win_aktywny    x=-35
    RPA.Desktop.Click    win_dodaj_modyfikuj
    RPA.Desktop.Click With Offset    win_typ_zasobu    x=50
    Sleep    1
    RPA.Windows.Send Keys    keys=${resource_type}
    RPA.Desktop.Press Keys    enter

    RPA.Desktop.Click With Offset    win_dostepne_zasoby    y=50

    FOR    ${counter}    IN RANGE    0    ${number_of_items}
        RPA.Desktop.Click With Offset    win_dostepne_zasoby    y=20
        RPA.Desktop.Click    win_left_red_arrow
    END
    RPA.Desktop.Click    Zapis
    RPA.Desktop.Click    Zamknij
    RPA.Desktop.Click    Dodaj

Changing Element Number
    [Arguments]    ${location}
    RPA.Desktop.Click    ${location}    right_click
    RPA.DEsktop.Wait For Element    alias:Wlasciwosci
    RPA.Desktop.Click    alias:Wlasciwosci
    RPA.Desktop.Click With Offset    alias:Numer_logiczny    x=85
    RPA.Desktop.Press Keys    down
    Sleep    1
    RPA.Desktop.Click
    RPA.Desktop.Wait For Element    alias:Zapis
    RPA.Desktop.Click    alias:Zapis
    RPA.Desktop.Press Keys    down

Changing The Detection Line Current
    [Arguments]    ${line_current}
    ${current}=    BuiltIn.Set Variable    ${line_current}
    Move To Region Right Click Offset And Click    alias:green_line_hub    50    125
    IF    ${current} == 50
        Move To Region Offset Click Offset And Click    alias:line_resistance    70    0    0    40
        RPA.Desktop.Find Element    alias:max_current_50
    ELSE IF    ${current} == 20
        Move To Region Offset Click Offset And Click    alias:line_resistance    70    0    0    20
        RPA.Desktop.Find Element    alias:max_current_20
    ELSE IF    ${current} == 22
        Move To Region Offset Click Offset And Click    alias:line_resistance    70    0    0    30
        RPA.Desktop.Find Element    alias:max_current_22
    ELSE
        BuiltIn.Fatal Error
    END
    Click Point_1 Or Point_2, Depending On Which Point Is Visible    alias:Zapis    alias:OK

Changing The Detection Line Protocol
    [Arguments]    ${line_protocol}
    ${protocol}=    BuiltIn.Set Variable    ${line_protocol}
    Move To Region Right Click Offset And Click    alias:green_line_hub    50    125
    IF    ${protocol} == 4000
        Move To Region Click Offset And Click    alias:line_protocol    0    30
        RPA.Desktop.Find Element    alias:line_protocol_4000
    ELSE IF    ${protocol} == 6000
        Move To Region Click Offset And Click    alias:line_protocol    0    15
        RPA.Desktop.Find Element    alias:line_protocol_6000
    ELSE
        BuiltIn.Fatal Error
    END
    Click Point_1 Or Point_2, Depending On Which Point Is Visible    alias:Zapis    alias:OK

Check If Value Exist In List
    [Arguments]    ${value}
    ${resource}=    BuiltIn.Set Variable    ${value}
    Collections.List Should Contain Value    ${LIST_RESOURCE}    ${resource}

Check PSO connections
    ${PSO_connect}=    Find Elements By Alias And Count    PSO_connect
    ${PSO}=    Find Elements By Alias And Count    PSO
    BuiltIn.Should Be Equal As Numbers    ${PSO_connect}    ${PSO}

Check the correctness of detection line numbers    [Tags]    069    smoke
    [Arguments]    ${start_from_number}    ${end_number}
    ${end}=    BuiltIn.Evaluate    ${end_number}+1
    FOR    ${counter}    IN RANGE    ${start_from_number}    ${end}
        ${str_counter}=    BuiltIn.Convert To String    ${counter}
        ${status}=    BuiltIn.Run Keyword And Return Status
        ...    Search Tree Element And Click Locator    li.*.${str_counter.zfill(3)}    Linia_unilocator
        IF    ${status} == $False
            ${count}=    Find Elements By Alias And Count    Linia_unilocator
            # Log To Console    locator_count= ${count}
            IF    '${count}' == '${0}'
                Log    Line no. ${str_counter} doesn't exist    level=WARN
            ELSE
                Log    Line no. ${str_counter} repetition error    level=ERROR
            END
        END
    END

Check The Number Of Elements After Adding Or Substraction New Ones
    [Documentation]    Add the second default argument if different from 1
    [Arguments]    ${value_before_change}    ${change_value}
    ${number_after}=    Get Number Of Line Elements
    Log To Console    value before change: ${value_before_change}
    Log To Console    change value: ${change_value}
    Log To Console    read number after: ${number_after}
    IF    ${value_before_change} < ${number_after}
        ${check_number}=    BuiltIn.Evaluate    ${number_after}-${change_value}
        Log To Console    < check_number: ${check_number}
    ELSE
        ${check_number}=    BuiltIn.Evaluate    ${number_after}+${change_value}
        Log To Console    >= check_number: ${check_number}
    END
    Log To Console    check number after loop: ${check_number}
    ${status}=    BuiltIn.Run Keyword And Return Status
    ...    BuiltIn.Should Be Equal As Integers    ${check_number}    ${value_before_change}
    IF    ${status} == $False    BuiltIn.Fail    Error: Incorrect item addition
    BuiltIn.Should Be Equal As Integers    ${check_number}    ${value_before_change}
    # RETURN    ${number_after}
    RETURN    ${status}

Check The Number Of Item After The Change
    [Documentation]    Add the second default argument if different from 1
    [Arguments]    ${value_before_change}    ${number_of_changed}=${1}
    ${number_read}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    ${int}=    BuiltIn.Convert To Integer    ${number_read}
    ${number_after_change}=    BuiltIn.Set Variable    ${int}
    ${int_add}=    BuiltIn.Convert To Integer    ${number_of_changed}
    Log To Console    number_of_changed:${number_of_changed}
    # Log To Console    number after change: ${number_after_change}
    IF    ${value_before_change} < ${int}
        ${int}=    BuiltIn.Evaluate    ${int}-${int_add}
    ELSE
        ${int}=    BuiltIn.Evaluate    ${int}+${int_add}
    END
    ${status}=    BuiltIn.Run Keyword And Return Status
    ...    BuiltIn.Should Be Equal As Integers    ${int}    ${value_before_change}
    IF    ${status} == $False    BuiltIn.Fail    Error: Incorrect item addition
    RETURN    ${number_after_change}

Check The Number Of Item After The Change And Compare
    [Documentation]    Lines must be added evenly!
    [Arguments]    ${value_before_change}    ${number_of_changed}    ${correct_number_after_change}
    ${int}=    BuiltIn.Convert To Integer    ${correct_number_after_change}
    ${correct_number_after_change}=    BuiltIn.Set Variable    ${int}
    ${int_add}=    BuiltIn.Convert To Integer    ${number_of_changed}
    Log To Console    number_of_changed:${number_of_changed}
    # Log To Console    number after change: ${number_after_change}
    IF    ${value_before_change} < ${int}
        ${int}=    BuiltIn.Evaluate    ${int}-${int_add}
    ELSE
        ${int}=    BuiltIn.Evaluate    ${int}+${int_add}
    END
    ${status}=    BuiltIn.Run Keyword And Return Status
    ...    BuiltIn.Should Be Equal As Integers    ${int}    ${value_before_change}
    IF    ${status} == $False    BuiltIn.Fail    Error: Incorrect item addition
    RETURN    ${correct_number_after_change}

Check The Number Of Modules After The Change
    [Arguments]    ${number_before_change}    ${amount_to_change}    ${number_after_change}
    IF    ${number_before_change} < ${number_after_change}
        ${number_of_modules}=    BuiltIn.Evaluate    ${number_before_change}+${amount_to_change}
    ELSE
        ${number_of_modules}=    BuiltIn.Evaluate    ${number_before_change}-${amount_to_change}
    END
    Log To Console    number_of_modules: ${number_of_modules}
    BuiltIn.Should Be Equal As Integers    ${number_after_change}    ${number_of_modules}

Click Point_1 Or Point_2, Depending On Which Point Is Visible
    [Arguments]    ${point1}    ${point2}
    ${status1}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    ${point1}
    ${status2}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    ${point2}
    IF    ${status1}
        RPA.Desktop.Click    ${point1}
    ELSE IF    ${status2}
        RPA.Desktop.Click    ${point2}
    ELSE
        BuiltIn.Fail
    END

Find Alias Move To Offset And Click
    [Arguments]    ${picture_alias}    ${offset_x}    ${offset_y}
    RPA.Desktop.Move Mouse    alias:${picture_alias}
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Click
    Sleep    1

Find Alias Move To Offset Right Click Offset And Click
    [Arguments]    ${picture_alias}    ${offset_x}    ${offset_y}    ${offset_a}    ${offset_b}
    RPA.Desktop.Move Mouse    alias:${picture_alias}
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    ${locator}=    RPA.Desktop.Click
    RPA.Desktop.Click    ${locator}    right_click
    RPA.Desktop.Move Mouse    offset:${offset_a},${offset_b}
    RPA.Desktop.Click
    Sleep    1

Find Elements By Alias And Count
    [Arguments]    ${picture_alias}
    ${matches}=    RPA.Desktop.Find Elements    alias:${picture_alias}
    ${count}=    BuiltIn.Get Length    ${matches}
    ${count}=    BuiltIn.Convert To Integer    ${count}
    IF    ${count} == 0    Log To Console    No matching elements
    RETURN    ${count}

Find Element By Locator With Warning
    [Documentation]    Checking the correctness of translations
    [Arguments]    ${picture_alias}    ${alternative_picture_alias}
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    ${picture_alias}
    IF    ${status} == ${TRUE}
        RETURN    ${picture_alias}
    ELSE
        ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    ${alternative_picture_alias}
        IF    ${status} == ${TRUE}
            Log    Translation error! alias:${alternative_picture_alias}    level=WARN
            RETURN    ${alternative_picture_alias}
        ELSE
            BuiltIn.Fail    Error!, Neither alias ${picture_alias} nor ${alternative_picture_alias} exist
        END
    END

Find Image Move To Offset Right Click Offset And Click
    [Documentation]    Use: Find Image Move To With Offset And Right Click    C:/grafika/wezel_glowny_t9.png    25    0
    [Arguments]    ${image_path}    ${offset_x}    ${offset_y}    ${offset_a}    ${offset_b}
    ${element}=    RPA.DEsktop.Find Element    image:${image_path}
    RPA.Desktop.Move Mouse    ${element}
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    ${locator}=    RPA.Desktop.Click
    RPA.Desktop.Click    ${locator}    right_click
    RPA.Desktop.Move Mouse    offset:${offset_a},${offset_b}
    ${locator}=    RPA.Desktop.Click
    Sleep    1

Find Image Right Click Offset And Click
    [Documentation]    Find Image Right Click Offset And Click    C:/grafika/wezel_2_t9.png    30    30
    [Arguments]    ${image_path}    ${offset_x}    ${offset_y}
    ${element}=    RPA.Desktop.Find Element    image:${image_path}
    RPA.Desktop.Move Mouse    ${element}
    ${locator}=    RPA.Desktop.Click
    RPA.Desktop.Click    ${locator}    right_click
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Click
    Sleep    1

Find Image Move To Offset And Click
    [Documentation]    Use: Find Image Move To With Offset And Click    C:/grafika/mld_61_t8.png    25    0
    [Arguments]    ${image_path}    ${offset_x}    ${offset_y}
    ${element}=    RPA.Desktop.Find Element    image:${image_path}
    RPA.Desktop.Move Mouse    ${element}
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Click
    Sleep    1

Get Main Window Name
    ${app_title}=    RPA.Desktop.Read Text    region:17,4,1000,25
    Log To Console    ${app_title}
    # ${app_title_star}=    String.Replace String    ${app_title}    "    *
    # ${app_title_star}=    String.Replace String    ${app_title_star}    o:    o
    # ${app_title_star}=    Replace String    ${app_title_star}    '    ${EMPTY}
    # ${app_title_star3}=    Replace String    ${app_title_star}    ${SPACE}_    ${EMPTY}
    ${PA}=    RPA.Windows.Control Window    regex:POLON*
    RETURN    ${PA}

Get Number Of Line Elements
    ${label_region}=    RPA.Desktop.Find Element    Number_of_line_elements
    ${resized_region}=    RPA.Desktop.Resize Region    ${label_region}    left=-150    top=5    right=210    bottom=0
    ${raw_string}=    RPA.Desktop.Read Text    ${resized_region}
    ${input_string}=    BuiltIn.Set Variable    ${raw_string}
    # BuiltIn.Log To Console    ${input_string}
    ${output_string}=    BuiltIn.Set Variable    ${input_string}
    ${output_string}=    String.Replace String Using Regexp    ${input_string}    (.*):    \
    ${output_string}=    String.Replace String    ${output_string}    .    ${EMPTY}
    ${output_string}=    String.Replace String    ${output_string}    °    ${EMPTY}
    # BuiltIn.Log To Console    ${output_string}
    ${number_of_elements}=    BuiltIn.Convert To Integer    ${output_string}
    RETURN    ${number_of_elements}

Get Number Of Modules
    [Arguments]    ${module_name}
    ${string}=    BuiltIn.Set Variable    ${module_name}
    ${module_alias}=    BuiltIn.Catenate    m_${string}
    # Log To Console    ${module_alias}
    ${number_of_modules}=    Find Elements By Alias And Count    ${module_alias}
    Log To Console    number: ${number_of_modules}
    RETURN    ${number_of_modules}

Get Window Title POLON Studio
    ${current_date}=    Log Current Date
    ${window_name}=    BuiltIn.Catenate    ${APP_NAME} - [Projekt: test_${current_date}*]
    Log    ${window_name}
    RETURN    ${window_name}

Import of detection lines from TLD
    [Arguments]    ${file_name}
    Move To Region Right Click Offset And Click    green_line_hub    50    150
    RPA.Desktop.Press Keys    alt    i
    Opening File In Child Window    ${TLD_FILES_PATH}    ${file_name}
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    win_wykryto_duplikat
    IF    '${status}'=='True'
        RPA.Desktop.Press Keys    enter
        Sleep    4
        RPA.Desktop.Click    win_Anuluj
        RPA.Desktop.Click    win_OK
        RPA.Desktop.Click    win_OK
        RPA.Desktop.Click    Zamknij
        BuiltIn.Run Keyword    BuiltIn.Fail    Attempting to import duplicate element numbers
    END
    RPA.Desktop.Click    Zamknij
    RPA.Desktop.Click    wezel_unilocator
    RPA.Desktop.Click    Linia_unilocator
    Sleep    1

Log Current Date
    ${current_date}=    DateTime.Get Current Date    result_format=%Y-%m-%d
    RETURN    ${current_date}

Move To Coordinates Mouse Press Offset And Mouse Release
    [Arguments]    ${coord_x}    ${coord_y}    ${offset_x}    ${offset_y}
    ${location}=    RPA.Desktop.Move Mouse    coordinates:${coord_x},${coord_y}
    Sleep    1
    RPA.Desktop.Press Mouse Button
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Release Mouse Button

Move To Coordinates Right Click Offset And Click
    [Documentation]    Use: Move to Right Click Offset And Click    (coordintes:)    (offset:)
    [Arguments]    ${coord_x}    ${coord_y}    ${offset_x}    ${offset_y}
    ${location}=    RPA.Desktop.Move Mouse    coordinates:${coord_x},${coord_y}
    RPA.Desktop.Click    ${location}    right_click
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Click
    Sleep    1    # Sleep needed

Move To Region Offset And Click
    [Arguments]    ${region_locator}    ${offset_x}    ${offset_y}
    RPA.Desktop.Move Mouse    alias:${region_locator}
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    RPA.Desktop.Click
    Sleep    1

Move To Region Right Click Offset And Click
    [Documentation]    Use: Move To Region Right Click Offset And Click    ${wezel_glowny}    30    30
    [Arguments]    ${region_locator}    ${offset_x}    ${offset_y}
    RPA.Desktop.Move Mouse    ${region_locator}
    RPA.Desktop.Click    ${region_locator}    right_click
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    Sleep    1
    RPA.Desktop.Click
    Sleep    1

Move To Windows Locator Right Click Offset And Click
    [Documentation]    Only for RPA.Windows Locators,
    ...    Use: Move To Windows Locator Right Click Offset And Click    ${wezel_glowny}    30    30
    ...    Hint: Remember to set the activity of the appropriate window
    [Arguments]    ${windows_locator}    ${offset_x}    ${offset_y}
    RPA.Windows.Right Click    ${windows_locator}
    RPA.Windows.Click    ${windows_locator} offset:${offset_x},${offset_y}

Move To Region Click Offset And Click
    [Arguments]    ${region_locator}    ${offset_x}    ${offset_y}
    RPA.Desktop.Move Mouse    ${region_locator}
    RPA.Desktop.Click    ${region_locator}
    Sleep    1
    RPA.Desktop.Move Mouse    offset:${offset_x},${offset_y}
    Sleep    1
    RPA.Desktop.Click
    Sleep    1

Move To Region Offset Click Offset And Click
    [Arguments]    ${region_locator}    ${offset_x}    ${offset_y}    ${offset_a}    ${offset_b}
    RPA.Desktop.Move Mouse    ${region_locator}
    RPA.Desktop.Click With Offset    ${region_locator}    x=${offset_x}    y=${offset_y}
    RPA.Desktop.Move Mouse    offset:${offset_a},${offset_b}
    Sleep    1
    RPA.Desktop.Click
    Sleep    1

Opening File In Child Window
    [Documentation]    Enter file path    and file name e.g.:
    ...    ${file_path}=    BuiltIn.Convert To String    C:\\POLON_STUDIO\\TestowaniePS\\00.TLD files
    ...    ${file_name}=    BuiltIn.Convert To String    test.tld
    ...    Opening File In Child Window    ${file_path}    ${file_name}
    [Arguments]    ${file_path}    ${file_name}
    RPA.Windows.Control Window    name:"Otwieranie" depth:4
    RPA.Windows.Click    automationid:41477 offset:250,0    # name:Adres class Edit
    RPA.Windows.Send Keys    keys=${file_path}{enter}
    RPA.Windows.Double Click    ${file_name}

Read Text From Region With Resize Region
    [Arguments]    ${region}    ${left}    ${top}    ${right}    ${bottom}
    Sleep    1
    ${region}=    RPA.Desktop.Find Element    alias:${region}
    ${region_to_read}=    RPA.Desktop.Resize Region
    ...    ${region}
    ...    left=${left}
    ...    top=${top}
    ...    right=${right}
    ...    bottom=${bottom}
    ${string}=    RPA.Desktop.Read Text    ${region_to_read}
    ${output_string}=    String.Replace String Using Regexp    ${string}    (.*):    \
    # BuiltIn.Log To Console    output_string:${output_string}
    RETURN    ${output_string}

Remove An Inputs From A Criterion
    [Documentation]    Select the number of inputs to be removed and optionally enter the number of the criterion
    ...    from which you are removing inputs. The last criterion is set by default.
    [Arguments]    ${amount_to_remove}    ${criterion_number}=last
    RPA.Desktop.Click    z_Kryteria
    RPA.Desktop.Click With Offset    z_Kryteria    y=50
    ${last}=    Set Variable    last
    IF    '${criterion_number}'== '${last}'
        RPA.Desktop.Press Keys    page_down    enter
    ELSE
        RPA.Windows.Send Keys    keys=${criterion_number}
        RPA.Desktop.Press Keys    enter
    END

    FOR    ${counter}    IN RANGE    0    ${amount_to_remove}
        Sleep    1
        RPA.Desktop.Click With Offset    win_kryterium_wejsciowe    y=15
        RPA.Desktop.Press Keys    page_down
        Sleep    1
        RPA.Desktop.Click    win_Usun_wejscia
        RPA.Desktop.Click    Tak
    END
    RPA.Desktop.Click    Zapis

Remove Criteria or Groups
    [Documentation]    Write what do you want to remove. To choose from: z_Kryteria, z_Grupy_wyjsc
    ...    and enter the number of items to be removed.
    [Arguments]    ${what_remove}    ${amount_to_remove}
    FOR    ${counter}    IN RANGE    0    ${amount_to_remove}
        RPA.Desktop.Click With Offset    ${what_remove}    y=50
        RPA.Desktop.Press Keys    end
        RPA.Desktop.Click    Usun
        Sleep    1
        RPA.Desktop.Click    win_Usun
        Sleep    1
        RPA.Desktop.Click    Tak
    END
    RETURN    ${amount_to_remove}

Remove Detection Zones
    [Arguments]    ${amount_to_remove}    ${remove_from}
    RPA.Desktop.Click    z_Strefy_dozorowe
    RPA.Desktop.Click With Offset    z_Strefy_dozorowe    y=50
    FOR    ${counter}    IN RANGE    0    ${amount_to_remove}
        ${to_remove}=    BuiltIn.Evaluate    ${remove_from}+${counter}
        Log To Console    to_remove:${to_remove}
        RPA.Windows.Send Keys    keys=${to_remove}
        RPA.Desktop.Click    Usun
        RPA.Desktop.Click    win_Usun
        RPA.Desktop.Click    Tak
    END
    RETURN    ${amount_to_remove}

Remove Items
    [Documentation]    Remove items such as: Detection zones, Criterions, Outputs groups,
    ...    User buttons, Schedules, Schedules tasks, Scenarios.
    ...    Enter the quantity to be removed and which number to start with.
    [Arguments]    ${amount_to_remove}    ${remove_from}
    Sleep    1
    RPA.Desktop.Click    coordinates:400,800    # item list panel
    FOR    ${counter}    IN RANGE    0    ${amount_to_remove}
        ${to_remove}=    BuiltIn.Evaluate    ${remove_from}+${counter}
        Log To Console    to_remove:${to_remove}
        RPA.Windows.Send Keys    keys=${to_remove}
        Sleep    1
        RPA.Desktop.Click    Usun
        RPA.Desktop.Click    win_Usun
        Sleep    1
        ${status}=    Run Keyword And Return Status    RPA.Desktop.Find Element    Tak
        IF    '${status}' == 'True'    RPA.Desktop.Click    Tak
    END
    RETURN    ${amount_to_remove}

Remove Last Char
    ${text}=    BuiltIn.Set Variable    Hello, World!
    ${text_length}=    BuiltIn.Get Length    ${text}
    ${text_without_last_char}=    BuiltIn.Evaluate    "${text}"[:-1]
    Log To Console    ${text_without_last_char}

Remove Line Elements
    [Documentation]    Select the line number, enter quntity to be removed
    ...    and indicate number from whitch you want to start removing
    [Arguments]    ${line_number}    ${amount_to_remove}    ${remove_from}=1
    ${str_line}=    BuiltIn.Set Variable    ${line_number}
    ${out_str_line}=    BuiltIn.Set Variable    li.*.${str_line.zfill(3)}
    Log To Console    output: ${out_str_line}
    Search Tree Element And Click Locator    ${out_str_line}    Linia_unilocator
    RPA.Windows.Send Keys    keys={add}
    ${range}=    BuiltIn.Evaluate    ${amount_to_remove}+${remove_from}
    FOR    ${counter}    IN RANGE    ${remove_from}    ${range}
        #    Log To Console    counter:${counter}
        ${keys}=    BuiltIn.Set Variable    L${line_number}/E${counter}
        #    Log To Console    keys= ${keys}
        RPA.Windows.Send Keys    keys=L${line_number}/E${counter}
        RPA.Windows.Send Keys    keys={del}{left}{enter}
        Sleep    1
    END
    RETURN    ${amount_to_remove}

Remove Modules From Node
    [Arguments]    ${node_number}    ${module_name}    ${amount_to_remove}
    Search Tree Element And Click Locator    ^węzeł.*.\\[${node_number}\\]    wezel_unilocator
    ${string}=    BuiltIn.Set Variable    ${module_name}
    ${module_alias}=    BuiltIn.Catenate    m_${string}
    Log To Console    ${module_alias}
    ${matches}=    RPA.Desktop.Find Elements    ${module_alias}
    ${modules}=    Find Elements By Alias And Count    ${module_alias}
    IF    ${modules} < ${amount_to_remove}
        Fail    There aren't that many modules ${module_name}
    END
    Log To Console    ${modules}
    ${c}=    BuiltIn.Convert To Integer    0
    ${counter}=    BuiltIn.Set Variable    ${c}
    FOR    ${match}    IN    @{matches}
        Move To Region Right Click Offset And Click    ${match}    30    30
        RPA.Desktop.Click    alias:Tak
        Sleep    1
        ${counter}=    BuiltIn.Evaluate    ${counter}+1
        Log To Console    ${counter}
        IF    ${counter} == ${amount_to_remove}    BREAK
    END
    ${matches2}=    RPA.Desktop.Find Elements    ${module_alias}
    ${modules2}=    Find Elements By Alias And Count    ${module_alias}
    Log To Console    ${modules2}
    ${number_of_modules}=    BuiltIn.Evaluate    ${modules}-${amount_to_remove}
    Log To Console    ${number_of_modules}
    BuiltIn.Should Be Equal As Integers    ${modules2}    ${number_of_modules}

Search Tree Element And Click Picture
    [Arguments]    ${text_to_send}    ${control_screenshoot_path}
    RPA.Desktop.Move Mouse    region:79,90,313,110    # search window
    RPA.Desktop.Click
    RPA.Desktop.Press Keys    ctrl    a
    RPA.Desktop.Press Keys    backspace
    RPA.Windows.Send Keys    keys=${text_to_send}
    RPA.Desktop.Press Keys    Enter
    Sleep    1
    ${locator}=    RPA.Desktop.Find Element    image:${control_screenshoot_path}
    RPA.Desktop.Click    ${locator}
    Sleep    1

Search Tree Element And Click Locator
    [Documentation]    To find node number use regexp ^węzeł\[number\],
    ...    To find line number use regexp li.*.number
    [Arguments]    ${text_to_send}    ${locator_to_click}
    RPA.DEsktop.Move Mouse    region:79,90,313,110    # search window
    RPA.Desktop.Click
    RPA.Desktop.Press Keys    ctrl    a
    RPA.Desktop.Press Keys    backspace
    RPA.Windows.Send Keys    keys=${text_to_send}
    RPA.Desktop.Press Keys    Enter
    Sleep    1
    RPA.Desktop.Click    ${locator_to_click}
    Sleep    1

Show Line Elements Type 6000
    ${image_status}=    Run Keyword And Return Status    RPA.Desktop.Find Element    alias:protocol_6000
    IF    ${image_status} != True
        ${location}=    RPA.Desktop.Find Element    alias:protocol_
        Move To Region Offset Click Offset And Click    ${location}    40    0    0    40
    END

Show Only Nodes In The Tree
    Get Main Window Name
    RPA.Desktop.Click    region:79,90,313,110
    RPA.Desktop.Press Keys    ctrl    a
    RPA.Desktop.Press Keys    backspace    enter
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:1    40    190    # Projekt -> Zwiń wszystko
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:1    40    210    # Projekt -> Rozwiń wszystko

Warning Status If Error Window
    [Arguments]    ${locator}    ${Warning_text}    ${level}=WARN
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    ${locator}
    Sleep    1
    IF    ${status} == ${TRUE}
        Log    ${warning_text}    level=${level}
        Sleep    1
        RPA.Desktop.Press Keys    enter
    END
    RETURN    ${status}
