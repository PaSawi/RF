*** Settings ***
Documentation       POLON Studio - demo

Resource            ../Resources/RPA.Desktop.robot
Resource            ./resources/keywords.robot
Resource            ./resources/variables.robot

Library             RPA.Desktop.OperatingSystem
Library             RPA.Calendar

Suite Setup         Log    Suite Setup!
Task Setup          Log    Task Setup!
Task Timeout        15 minutes


*** Test Cases ***
Open    [Tags]    000    start
    RPA.Desktop.Click    coordinates:100,300
    ${PS}=    RPA.Desktop.Open Application    PolonStudio.exe
    Sleep    4s
    RPA.Desktop.Press Keys    enter
    Log To Console    ${PS}
    Sleep    4s

001, 002, 003 - Create New Project POLON 6000 With 51 Nodes    [Tags]    001    smoke    c
    Get Main Window Name
    ${current_date}=    Log Current Date    # set date in name of files
    ${name}=    BuiltIn.Catenate    test_${current_date}
    RPA.Windows.Send Keys    keys={Alt}p    # language changing for polish
    RPA.Windows.Send Keys    keys={Ctrl}n
    RPA.Desktop.Click    coordinates:900,500
    RPA.Windows.Send Keys    keys=${name}
    Sleep    1s
    RPA.Desktop.Click    coordinates:876,525
    RPA.Windows.Send Keys    keys=5n
    RPA.Desktop.Move Mouse    coordinates:1090,565
    RPA.Desktop.Click    coordinates:1090,565    # click Utwórz
    RPA.Desktop.Move Mouse    coordinates:940,560
    RPA.Desktop.Click    coordinates:940,560    # click possible repeated names
    Sleep    2s
    RPA.Windows.Send Keys    keys={Enter}
    Sleep    8s
    ${node_text}=    RPA.Desktop.Read Text    region:215,900,226,913
    BuiltIn.Should Be Equal As Strings    51    ${node_text}
    Check PSO connections

004 - Check if program prompts errors or warnings    [Tags]    004    smoke    t
    ${v_text}=    RPA.Desktop.Read Text    region:16,675,360,695
    Log To Console    ${v_text}
    BuiltIn.Should Be Equal As Strings    ${VALID_TEXT}    ${v_text}

005 - Create single detection zone    [Tags]    005    smoke    t    c
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|3    # name:'Strefy dozorowe'
    Add Single Detection Zone    1956    POLON-ALFA${SPACE}S.A. Bydgoszcz

006 - Create 2000 detection zones    [Tags]    006    smoke    t    c
    Sleep    1
    ${zones}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Log To Console    Read before adding= ${zones}
    ${zones}=    BuiltIn.Set Variable    ${zones}
    ${number}=    BuiltIn.Set Variable    ${2000}
    ${label_message}=    BuiltIn.Set Variable    TKT-7 Rules! [ :~)}<=< ____NR %Z.
    Add Multiple Detection Zones    ${number}    ${label_message}
    ${sum}=    BuiltIn.Evaluate    ${zones}+${number}-1
    Log To Console    check_sum= ${sum}
    Sleep    2
    ${zones2}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Log To Console    Raad after adding= ${zones2}
    BuiltIn.Should Be Equal As Integers    ${zones2}    ${sum}


008 - Add 10 modules MLD-61 to node nr 1    [Tags]    008    smoke    t    c
    Show Only Nodes In The Tree
    RPA.Windows.Click    control:Tree > path:2
    ${number_before}=    Get Number Of Modules    MLD-61
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:2    40    30    # Main node -> Add modules
    RPA.Windows.Control Window    name:"Dodaj komponent: Węzeł główny" depth:4
    RPA.Windows.Double Click    control:Group > path:7    # Edit MLD-61
    ${amount_to_add}=    BuiltIn.Set Variable    10
    RPA.Windows.Send Keys    keys=${amount_to_add}
    RPA.Desktop.Press Keys    Enter
    Warning Status If Error Window
    ...    red_x    ${ERROR BATTERY CAPACITY}    ERROR
    ${number_after}=    Get Number Of Modules    MLD-61
    Check The Number Of Modules After The Change
    ...    ${number_before}    ${amount_to_add}    ${number_after}

009 - Add 10 modules MLD-61 to node nr 2    [Tags]    009    smoke    t    c
    Get Main Window Name
    RPA.Windows.Click    control:Tree > path:3
    ${number_before}=    Get Number Of Modules    MLD-61
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:3    40    30    # Node no.2 -> Add modules
    ${amount_to_add}=    BuiltIn.Convert To Integer    10
    Add Modules By Node_hub    MLD-61    ${amount_to_add}
    ${number_after}=    Get Number Of Modules    MLD-61
    Check The Number Of Modules After The Change
    ...    ${number_before}    ${amount_to_add}    ${number_after}

010 - Add PSO-60 to node nr 2    [Tags]    010    smoke    t
    Get Main Window Name
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:3    40    30    # Node no.2 -> Add modules
    Add Modules By Node_hub    PSO-60    1

011 - Add PSO-60 to node nr 3    [Tags]    011    smoke    t
    Get Main Window Name
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:4    40    30    # Node no.3 -> Add modules
    Add Modules By Node_hub    PSO-60    1

012 - Add MD-60 from PSO-60 position to node nr 3    [Tags]    012    smoke    t
    Find Image Right Click Offset And Click    C:/grafika/blank_printer_field_t12.png    20    30
    Find Image Move To Offset And Click    C:/grafika/mld_61_t8.png    30    75    # MD-60 edit
    RPA.Windows.Send Keys    keys=1
    RPA.Desktop.Press Keys    Enter
    Sleep    1
    RPA.Desktop.Find Element    image:C:/grafika/printer_in_t12.png

013 - Add WPO-60 to node nr 4    [Tags]    013    smoke
    Get Main Window Name
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:5    40    30    # Node no.4 -> Add modules
    Add Modules By Node_hub    WPO-60    1

014 - Add 100 detection lines to node nr 5    [Tags]    014    smoke    c
    Add Detection Line From A Tree Panel    5    100

015 - Add 30 detection lines to node nr 6    [Tags]    015    smoke    c
    Add Detection Line From A Tree Panel    6    30

016 - Add 30 MLD-61 modules to node nr 7    [Tags]    016    smoke    c
    Show Only Nodes In The Tree
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:8    40    30    # Node no.7 -> Add modules
    Add Modules By Node_hub    MLD-61    30

017 - Add 12 MLD-61 modules to node nr 8    [Tags]    017    smoke    c
    Get Main Window Name
    RPA.Windows.Click    control:Tree > path:9
    ${number_before}=    Get Number Of Modules    MLD-61
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:9    40    30    # Node no.8 -> Add modules
    ${amount_to_add}=    BuiltIn.Convert To Integer    12
    Add Modules By Node_hub    MLD-61    ${amount_to_add}
    ${number_after}=    Get Number Of Modules    MLD-61
    Check The Number Of Modules After The Change
    ...    ${number_before}    ${amount_to_add}    ${number_after}

018 - Add 8 ADC-4001M to detection line nr 1    [Tags]    018    smoke
    Search Tree Element And Click Locator    li.*.001    alias:Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    ${number_of_elements}=    BuiltIn.Set Variable    8
    Add Line Elements By Drag And Drop    e_ADC_4001M    ${number_of_elements}
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${number_of_elements}

019 - Add 100 ROP-4001M to detection line nr 2    [Tags]    019    smoke    c
    Search Tree Element And Click Locator    li.*.002    alias:Linia_unilocator
    Find Image Move To Offset Right Click Offset And Click
    ...    C:/grafika/line_hub_t18.png    0    0    30    30
    Add Line Elements By Line_hub    rop-4001m    100    0
    RPA.Desktop.Find Element    image:C:/grafika/rop4001m_check_t19.png

020 - Add 1 smoke detector to detector line nr 2 and assign it to detection_zone nr 10    [Tags]    020    smoke
    Find Image Move To Offset Right Click Offset And Click
    ...    C:/grafika/line_hub_t18.png    0    0    30    30
    Add Line Elements By Line_hub    dor-4046    1    10
    RPA.Desktop.Find Element    image:C:/grafika/dor4046_check_t20.png

021 - Add 1 smoke detector to detector line nr 2 using the add and move method    [Tags]    021    smoke
    ${number_before}=    Get Number Of Line Elements
    RPA.Desktop.Wait For Element    alias:L2/E4_ROP
    RPA.Desktop.Click    alias:L2/E4_ROP    right_click
    RPA.Desktop.Wait For Element    alias:dodaj_i_przesun
    RPA.Desktop.Click    alias:dodaj_i_przesun
    Sleep    1
    Add Line Elements By Line_hub    dut-6046    2    0
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    2

022 - Changing element number    [Tags]    022    smoke
    ${location}=    RPA.Desktop.Find Element    alias:L2/E4_ROP
    Changing Element Number    ${location}
    # RPA.Desktop.Click    alias:Linia002
    Search Tree Element And Click Locator    li.*.002    alias:Linia_unilocator
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    alias:L2/E4_ROP
    IF    ${status}    Fail    Element was found

023 - Setting the automatic number update mode    [Tags]    023    smoke
    ${location}=    RPA.Desktop.Find Element    alias:L2/E104_ROP
    Move To Region Right Click Offset And Click    alias:green_line_hub    50    210
    Sleep    1
    RPA.Desktop.Click    alias:Tak
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    alias:L2/E104_ROP
    IF    ${status}    Fail    Element was found

024 - Add 100 DUO-6046 to detection line nr 165    [Tags]    024    smoke    k    c
    Search Tree Element And Click Locator    li.*.165    alias:Linia_unilocator
    Find Element By Locator With Warning    Linia165    Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    alias:green_line_hub    30    30
    Sleep    1
    ${number_of_elements}=    BuiltIn.Set Variable    100
    Add Line Elements By Line_hub    DUO-6046    ${number_of_elements}    0
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${number_of_elements}

025 - Add 200 DOR-4046 to detection line nr 166    [Tags]    025    smoke    k
    Get Main Window Name
    Search Tree Element And Click Locator    li.*.166    alias:Linia_unilocator
    Changing The Detection Line Current    20
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    alias:green_line_hub    30    30
    Sleep    1
    ${number_of_elements}=    BuiltIn.Set Variable    200
    Add Line Elements By Line_hub    DOR-4046    ${number_of_elements}    0
    Find Element By Locator With Warning    line_current_error    line_current_error_U
    Sleep    1
    RPA.Desktop.Press Keys    Enter
    # ${number_of_elements}
    Check The Number Of Elements After Adding Or Substraction New Ones
    ...    ${number_before}
    ...    133

026 - Setting detection line 166 in 4000 mode    [Tags]    026    smoke    k    c
    Changing The Detection Line Protocol    4000

027 - Setting the detection line current to 50 mA    [Tags]    027    smoke    k    c
    Changing The Detection Line Current    50

028 - Adding 10 EKS-4001 units to line no. 166 in 4000 mode    [Tags]    028    smoke    k    c
    Get Main Window Name
    Search Tree Element And Click Locator    li.*.166    alias:Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    alias:green_line_hub    30    30
    Sleep    1
    ${number_of_elements}=    BuiltIn.Set Variable    10
    Add Line Elements By Line_hub    EKS-4001    ${number_of_elements}    0
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${number_of_elements}

029 - Attempt to add the EKS type 6000 to the detection line No. 166 in the 4000 mode    [Tags]    029    smoke
    Show Line Elements Type 6000
    Sleep    1
    Add Line Elements By Drag And Drop    e_EKS_6044    1
    RPA.Desktop.Find Element    alias:line_protocol_error
    RPA.Desktop.Press Keys    Esc
    RPA.Desktop.Press Keys    Esc

030 - Adding 10 EKS series 6000 to line No. 167 in 6000 mode    [Tags]    030    smoke    c
    Search Tree Element And Click Locator    li.*.167    alias:Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    alias:green_line_hub    30    30
    Sleep    1
    ${number_of_elements}=    BuiltIn.Set Variable    10
    Add Line Elements By Line_hub    EKS-6022    ${number_of_elements}    0
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${number_of_elements}

032 - Add 10 modules MKS-60 to node nr 9    [Tags]    032    smoke
    Show Only Nodes In The Tree
    RPA.Windows.Click    control:Tree > path:9
    ${number_before}=    Get Number Of Modules    MKS-60
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:10    40    30    # Node no.9 -> Add modules
    ${amount_to_add}=    BuiltIn.Convert To Integer    10
    Add Modules By Node_hub    MKS-60    ${amount_to_add}
    ${number_after}=    Get Number Of Modules    MKS-60
    Check The Number Of Modules After The Change
    ...    ${number_before}    ${amount_to_add}    ${number_after}

033 - Add 10 modules MLK-60 to node nr 10    [Tags]    033    smoke
    Show Only Nodes In The Tree
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:11    40    30    # Node no.10 -> Add modules
    Add Modules By Node_hub    MLK-60    10

034 - Add 1 modules MD-60 to node nr 1    [Tags]    034    smoke
    Show Only Nodes In The Tree
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:2    40    30    # Node no.1 -> Add modules
    Add Modules By Node_hub    MD-60    1
    ${status}=    BuiltIn.Run Keyword And Warn On Failure    Check PSO connections

035 - Add 2 modules MWS-60 to node nr 1    [Tags]    035    smoke
    Show Only Nodes In The Tree
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:2    40    30    # Node no.1 -> Add modules
    Add Modules By Node_hub    MWS-60    2

036 - Remove MD-60 module from node nr 1    [Tags]    036    smoke
    Search Tree Element And Click Locator    ^węzeł.*.\\[1\\]    wezel_unilocator
    Find Alias Move To Offset Right Click Offset And Click    m_MD-60    0    0    30    30
    RPA.Desktop.Click    alias:Tak
    ${image_status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    alias:m_MD-60
    IF    ${image_status}    BuiltIn.Fail    Error removing modules
    BuiltIn.Run Keyword And Warn On Failure    Check PSO connections

037 - Remove 3 MLD-61 modules from node nr 8    [Tags]    037    smoke
    Remove Modules From Node    8    MLD-61    3
    BuiltIn.Run Keyword And Warn On Failure    Check PSO connections

038 - Remove 3 MKS-60 modules from node nr 9    [Tags]    038    smoke
    Remove Modules From Node    9    MKS-60    3
    BuiltIn.Run Keyword And Warn On Failure    Check PSO connections

039 - Add 2 modules MLD-61 to node nr 9    [Tags]    039    smoke
    Show Only Nodes In The Tree
    Move To Windows Locator Right Click Offset And Click
    ...    control:Tree > path:10    40    30    # Node no.9 -> Add modules
    Add Modules By Node_hub    MLD-61    2

040 - Add modules MLD-61 and MLD-62 to node nr 9    [Tags]    040    smoke
    Add Modules To SM-60 By Drag And Drop    MLD-61    1
    Add Modules To SM-60 By Drag And Drop    MLD-62    1

041 - Adding your own alarm variants    [Documentation]    Add your own alert variants with using the first and second templates
    [Tags]    041    smoke
    FOR    ${v_count}    IN RANGE    0    2
        RPA.Desktop.Click    z_Warianty_alarmowania
        Sleep    1
        ${number_of_variants}=    Read Text From Region With Resize Region
        ...    win_razem    5    0    40    0
        RPA.Desktop.Wait For Element    Nowy
        RPA.Desktop.Click    Nowy
        Move To Region Click Offset And Click    win_wariant_locator    30    30
        IF    ${v_count} == 0
            RPA.Desktop.Press Keys    s    Enter
        ELSE
            RPA.Desktop.Press Keys    s
            Sleep    1
            RPA.Desktop.Press Keys    s    Enter
        END
        Move To Region Offset And Click    win_opis    30    0
        RPA.Windows.Send Keys    keys=New alerting variant created by the user from the template
        RPA.Desktop.Click    win_tryb_ROP_II_st.
        IF    ${v_count} == 0
            ${nie}=    Find Element By Locator With Warning    win_nie    win_nie_eng
            ${wybierz_strefy}=    Find Element By Locator With Warning    win_wybierz_strefy    win_wybierz_strefy_eng
        END
        RPA.Desktop.Click    ${nie}
        RPA.Desktop.Click    ${wybierz_strefy}
        FOR    ${counter}    IN RANGE    0    3
            IF    ${counter} == 2    RPA.Desktop.Press Keys    End
            Move To Region Offset And Click    win_dostepne_zasoby    0    30
            RPA.Desktop.Click    win_left_red_arrow
        END
        RPA.Desktop.Click    Zapis
        RPA.Desktop.Click    Dodaj
        Check The Number Of Item After The Change    ${number_of_variants}
    END

042 - Removing your own alarm variant    [Tags]    042    smoke
    ${number_of_variants}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    RPA.Desktop.Click    z_Warianty_alarmowania
    RPA.Desktop.Click With Offset    z_Warianty_alarmowania    y=50
    RPA.Desktop.Press Keys    end
    RPA.Desktop.Click    Usun
    Sleep    1
    RPA.Desktop.Click With Offset    win_Anuluj    x=-80
    RPA.Desktop.Click    Tak
    Check The Number Of Item After The Change    ${number_of_variants}

043 - Adding a criterion and grup with any settings    [Tags]    043    smoke
    RPA.Desktop.Click    z_Kryteria
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika_kryt    y=15
    RPA.Windows.Send Keys    keys=New criterion with default settings
    Add Inputs In The Criterion Window    3    0
    RPA.Desktop.Click    win_kryt_przypisz_grupe_wyjsc
    RPA.Desktop.Click    Dodaj
    Check The Number Of Item After The Change    ${number_of}

044 - Adding a criterion and grup with detection zones    [Tags]    044    smoke
    RPA.Desktop.Click    z_Kryteria
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika_kryt    y=15
    RPA.Windows.Send Keys    keys=New criterion with inputs containing detection zones
    Add Inputs In The Criterion Window    4    3
    RPA.Desktop.Click    win_kryt_przypisz_grupe_wyjsc
    RPA.Desktop.Click    Dodaj
    Check The Number Of Item After The Change    ${number_of}

045 - Adding a group with default settings    [Tags]    045    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    RPA.Desktop.Click    Nowy
    RPA.Desktop.Click With Offset    win_opis_uzytkownika_kryt    y=15
    RPA.Windows.Send Keys    keys=New group with default settings
    RPA.Desktop.Click    win_brak_kryterium_wysterowania
    RPA.Desktop.Press Keys    end    enter
    Check The Number Of Item After The Change    ${number_of}

046 - Adding a group with outputs    [Tags]    046    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    Add Output Groups    1    2
    Check The Number Of Item After The Change    ${number_of}

047 - Adding a group with sounders type outputs    [Tags]    047    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    Add Output Groups    1    2    alarm
    Check The Number Of Item After The Change    ${number_of}

048 - Adding a group with alarm tramission devices outputs    [Tags]    048    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    Sleep    1
    ${number_read}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    Log To Console    number_read: ${number_read}
    Add Output Groups    1    2    trans
    ${int}=    Check The Number Of Item After The Change    ${number_read}
    Log To Console    number after change:${int}

049 - Adding a group with fire protection devices outputs    [Tags]    049    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    Sleep    1
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    Add Output Groups    1    2    zabez
    Check The Number Of Item After The Change    ${number_of}

050 - Adding the ADC-4001M adapter with the input assigned to the detection zone    [Tags]    050    smoke
    RPA.Desktop.Click    z_Informacje_o_systemie
    Search Tree Element And Click Locator    li.*.165    alias:Linia_unilocator
    Find Element By Locator With Warning    Linia165    Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    alias:green_line_hub    30    30
    Sleep    1
    ${number_of_elements}=    BuiltIn.Set Variable    1
    Add Line Elements By Line_hub    ADC-4001M    ${number_of_elements}    2001
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${number_of_elements}

051 - Adding the input of the ADC-4001M adapters to the 100 detection zone    [Tags]    051    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones
    ...    Elementy    8    100    ADC-4001M

052 - Adding 10 ROP-4001M units to the detection zone no. 10    [Tags]    052    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones
    ...    Elementy    10    10    ROP-4001M

053 - Adding 3 DOT-6046 units to the detection zone no. 50    [Tags]    053    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones
    ...    Elementy    3    50    DOT-6046

054 - Adding 3 DOP-6001 units to the detection zone no. 250    [Tags]    054    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones
    ...    Elementy    3    250    DOP-6001

055 - Addition of conventional lines from MLK-60 modules to the detection zone    [Tags]    055    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones    Wej    5    500

056 - Addition of conventional lines from MLK-60 modules to the detection zone    [Tags]    056    smoke
    Add Line Elements, Inputs, Conventional Lines To The Detection Zones    MLK    3    3
    Sleep    1

057 - Remove the output groups    [Tags]    057    smoke
    RPA.Desktop.Click    z_Grupy_wyjsc
    ${number_of_groups}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    ${amount_to_remove}=    Remove Criteria or Groups    z_Grupy_wyjsc    2
    Check The Number Of Item After The Change    ${number_of_groups}    ${amount_to_remove}

058 - Add criteria with inputs containing detection zones    [Tags]    058    smoke
    Add Criteria    4    2    2

059 - Remove a criteria    [Tags]    059    smoke
    RPA.Desktop.Click    z_Kryteria
    ${number_of_criteria}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    ${amount_to_remove}=    Remove Criteria or Groups    z_Kryteria    3
    Check The Number Of Item After The Change    ${number_of_criteria}    ${amount_to_remove}

060 - Removing inputs from a last criterion    [Tags]    060    smoke
    RPA.Desktop.Click    z_Kryteria
    Remove An Inputs From A Criterion    1
    RPA.Desktop.Click    Zamknij

061 - Removing inputs from a pointed criterion    [Tags]    061    smoke
    RPA.Desktop.Click    z_Kryteria
    Remove An Inputs From A Criterion    2    6
    RPA.Desktop.Click    Zamknij

062 - Removing detection zones    [Tags]    062    smoke
    RPA.Desktop.Click    z_Strefy_dozorowe
    ${number_of_zones}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    ${amount_to_remove}=    Remove Detection Zones    3    1551
    Check The Number Of Item After The Change    ${number_of_zones}    ${amount_to_remove}

063 - Removing a detector from a detection line    [Tags]    063    smoke
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|1    # "Informacje o systemie"
    Search Tree Element And Click Locator    li.*.002    alias:Linia_unilocator
    Find Element By Locator With Warning    Linia002    Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    ${amount_to_remove}=    Remove Line Elements    2    1    1
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${amount_to_remove}

064 - Removing the detector using the remove and move method    [Tags]    064    smoke
    Get Main Window Name
    Search Tree Element And Click Locator    li.*.002    alias:Linia_unilocator
    Find Element By Locator With Warning    Linia002    Linia_unilocator
    RPA.Windows.Send Keys    keys={add}
    ${number_before}=    Get Number Of Line Elements
    ${amount_to_remove}=    BuiltIn.Set Variable    ${1}
    RPA.Desktop.Click With Offset    Linia_unilocator    x=30    y=150    action=right_click
    RPA.Desktop.Move Mouse    offset:50,120
    RPA.Desktop.Click
    RPA.Desktop.Click    Tak
    Sleep    1
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    ${amount_to_remove}

065 - Import of detection lines from TLD to the POLON 6000    [Tags]    065    smoke
    RPA.Desktop.Click    z_Informacje_o_systemie
    Search Tree Element And Click Locator    li.*.166    alias:Linia_unilocator
    RPA.Desktop.Click    Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Move To Region Right Click Offset And Click    green_line_hub    50    150
    RPA.Desktop.Press Keys    alt    i
    Sleep    1
    RPA.Windows.Control Window    name:"Otwieranie" depth:4
    RPA.Windows.Click    automationid:1001 offset:260,0    # Address edit field
    ${file_path}=    BuiltIn.Convert To String    C:\\POLON_STUDIO\\TestowaniePS\\00.TLD files
    RPA.Windows.Send Keys    keys=${file_path}{enter}
    Sleep    1
    RPA.Windows.Double Click    name:"test.tld"
    RPA.Desktop.Click    Zamknij
    RPA.Desktop.Click    wezel_unilocator
    RPA.Desktop.Click    Linia_unilocator
    Sleep    1
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    5

066 - Import of detection lines from TLD to the POLON 6000    [Tags]    066    smoke
    RPA.Desktop.Click    z_Informacje_o_systemie
    Search Tree Element And Click Locator    li.*.168    alias:Linia_unilocator
    RPA.Desktop.Click    Linia_unilocator
    ${number_before}=    Get Number Of Line Elements
    Changing The Detection Line Current    50
    Import of detection lines from TLD    dlugalinia.tld
    Check The Number Of Elements After Adding Or Substraction New Ones    ${number_before}    220

067 - Import detection lines with repetitioning elements numbers    [Tags]    067    smoke
    Search Tree Element And Click Locator    li.*.050    alias:Linia_unilocator
    RPA.Desktop.Click    Linia_unilocator
    Move To Region Right Click Offset And Click    green_line_hub    50    150
    RPA.Desktop.Press Keys    alt    i
    ${file_path}=    BuiltIn.Convert To String    C:\\POLON_STUDIO\\TestowaniePS\\00.TLD files
    Opening File In Child Window    ${file_path}    acr.tld
    Sleep    1
    ${status}=    BuiltIn.Run Keyword And Return Status    RPA.Desktop.Find Element    win_wykryto_duplikat
    IF    '${status}'=='False'
        Sleep    1
        RPA.Desktop.Click    Zamknij
        BuiltIn.Run Keyword    BuiltIn.Fail    Error: verifying duplicate serial numbers of linear elements
    END
    Log To Console    Import detection lines with repetitioning elements numbers
    RPA.Desktop.Press Keys    enter
    RPA.Desktop.Click    win_Anuluj
    RPA.Desktop.Click    win_OK
    RPA.Desktop.Click    win_OK
    RPA.Desktop.Click    Zamknij
    Sleep    1

068 - Add detection lines    [Tags]    068    smoke
    Add detection line from a tree panel    11    1

069 - Detection line numbers aren't repeated    [Tags]    069    smoke
    Check the correctness of detection line numbers    170    180
    Show Only Nodes In The Tree

070 - Add user button disablement - Grupy wyjść    [Tags]    070    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|9    # tab - User buttons
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add User Button    BLOKOWANIE    Grupy wyjść    3
    Check The Number Of Item After The Change    ${number_of}

071 - Add user button tests - Strefy dozorowe    [Tags]    071    smoke
    Get Main Window Name
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add User Button    TESTOWANIE    Strefy dozorowe    3
    Check The Number Of Item After The Change    ${number_of}

072 - Remove user button    [Tags]    072    smoke
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|9    # tab - User buttons
    ${number_of}=    Read Text From Region With Resize Region    win_razem    5    0    40    0
    Remove Items    1    1
    Check The Number Of Item After The Change    ${number_of}    1

073 - Add user button disablement - Linie dozorowe adresowalne    [Tags]    073    smoke
    Get Main Window Name
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add User Button    BLOKOWANIE    Linie dozorowe adresowalne    3
    Check The Number Of Item After The Change    ${number_of}

074 - Add user button disablement - Wejścia kontrolne    [Tags]    074    smoke
    Get Main Window Name
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add User Button    BLOKOWANIE    Wejścia kontrolne    3
    Check The Number Of Item After The Change    ${number_of}

075 - Add a daily schedule    [Tags]    075    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    # RPA.Windows.Double Click    type:Pane > control:Button name:"Przewiń w prawo"
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|10    # tab - Schedules
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule    Dzienny
    Add Schedule    Okresowy
    Check The Number Of Item After The Change    ${number_of}    2

076 - Add a periodic schedule    [Tags]    076    smoke
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|10    # tab - Schedules
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule    Okresowy
    Add Schedule    Dzienny
    Check The Number Of Item After The Change    ${number_of}    2

077 - Add schedules tasks Blokowanie modułów    [Tags]    077    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|11    # tab - Schedules tasks
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule Task    BL    2
    Check The Number Of Item After The Change    ${number_of}

078 - Add schedules tasks Blokowanie linii dozorowych adresowalnych    [Tags]    078    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|11    # tab - Schedules tasks
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule Task    BL    1    Linie dozorowe adresowalne    2
    Check The Number Of Item After The Change    ${number_of}

079 - Add schedules tasks Wyłączenie czasu opóźnienia    [Tags]    079    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|11    # tab - Schedules tasks
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule Task    WY    4
    Check The Number Of Item After The Change    ${number_of}

080 - Add schedules tasks Personel nieobecny    [Tags]    080    smoke
    Get Main Window Name
    RPA.Windows.Double Click    control:Custom > path:1|1|1|1|1|2|2|15    # scroll right >
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|11    # tab - Schedules tasks
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Schedule Task    PE    3
    Check The Number Of Item After The Change    ${number_of}

081 - Add scenarios    [Tags]    081    smoke
    Get Main Window Name
    RPA.Windows.Click    control:Custom > path:1|1|1|1|1|2|2|12    # tab - Scenario
    ${number_of}=    Read Text From Region With Resize Region
    ...    win_razem    5    0    40    0
    Add Scenario    3    Linie dozorowe adresowalne    2
    Check The Number Of Item After The Change    ${number_of}

090 - Test the program's operation on older versions of project files    [Tags]    090    smoke
    ${file_path}=    BuiltIn.Convert To String    C:\\POLON_STUDIO\\TestowaniePS\\00.Versions\\pc6
    FOR    ${PC6_file}    IN    @{LIST_PC6_FILE_TO_TEST}
        Get Main Window Name
        RPA.Windows.Click    control:MenuItem path:3|1    # Plik Tab
        RPA.Windows.Control Window    type:Menu
        RPA.Windows.Click    control:MenuItem path:5    # Wczytaj PC6
        Log    ${PC6_file}
        Opening File In Child Window    ${file_path}    ${PC6_file}
        # Control Window    name:Pytanie
        # RPA.Windows.Click    control:Button path:3    # Otwórz konfigurację"
        Sleep    3
    END

Close    [Tags]    999    close
    RPA.Desktop.Click    coordinates:180,10
    ${PA}=    Get Main Window Name
    RPA.Windows.Close Window    ${PA}
