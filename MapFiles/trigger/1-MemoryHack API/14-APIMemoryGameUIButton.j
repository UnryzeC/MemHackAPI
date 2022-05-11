//TESH.scrollpos=50
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameUIButton
    function IsCommandButton takes integer pButton returns boolean
        return GetFrameType( pButton ) == 4
    endfunction

    function GetButtonData takes integer pCommandButton returns integer
        if IsCommandButton( pCommandButton ) then
            return ReadRealMemory( pCommandButton + 0x190 )
        endif

        return 0
    endfunction

    function GetButtonGoldCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x58C )
        endif

        return -1
    endfunction

    function GetButtonLumberCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x590 )
        endif

        return -1
    endfunction

    function GetButtonManaCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x594 )
        endif

        return -1
    endfunction

    function GetButtonCooldownOld takes integer pCommandButton returns real
        local integer pAbil     = 0
        local integer pAbilId   = 0
        local integer pOrderId  = 0
        local integer goldcost  = 0
        local integer pAbilVal2 = 0
        local integer pButton   = 0
        local real prAbilVal1   = 0.
        local real prAbilVal2   = 0.

        if IsCommandButton( pCommandButton ) then
            set pButton = ReadRealMemory( pCommandButton + 0x190 )

            if pButton > 0 then
                set pAbil    = ReadRealMemory( pButton + 0x6D4 )
                set pAbilId  = ReadRealMemory( pButton + 0x4   )
                set pOrderId = ReadRealMemory( pButton + 0x8   )
                set goldcost = ReadRealMemory( pButton + 0x58C )

                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton = " + IntToHex( pButton ) )
                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton + 0x6D4 = " + IntToHex( pAbil ) )

                if pAbil != 0 and pAbilId != 'AHer' and pAbilId != 'Amai' and pAbilId != 'Asei' and pAbilId != 'Asel' then //  and goldcost == 0
                    set pAbil = ReadRealMemory( pAbil + 0xDC )
                    //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pAbil + 0xDC = " + IntToHex( pAbil ) )

                    if pAbil > 0 then
                        set pAbilVal2 = ReadRealMemory( pAbil + 0x0C )
                        //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "ReadRealMemory( pAbil + 0x0C ) = " + IntToHex( pAbilVal2 ) )

                        if pAbilVal2 > 0 then
                            set prAbilVal1 = GetRealFromMemory( ReadRealMemory( pAbil + 0x04 ) )
                            set prAbilVal2 = GetRealFromMemory( ReadRealMemory( pAbilVal2 + 0x40 ) )
                            
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal1 = " + R2S( pAbilVal2 ) )
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal2 = " + R2S( pAbilVal2 ) )
                            return prAbilVal1 - prAbilVal2
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction

    function GetButtonCooldown takes integer pCommandButton, boolean addcheck returns real
        local integer i           = 0
        local integer pAbil       = 0
        local integer pAbilId     = 0
        local integer flag        = 0
        local integer pOrderId    = 0
        local integer pButtonData = 0
        local integer pTimer      = 0
        local integer pObj        = 0
        local integer arg         = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if IsCommandButton( pCommandButton ) then
            set pButtonData = ReadRealMemory( pCommandButton + 0x190 )

            if pButtonData != 0 then
                set pOrderId = ReadRealMemory( pButtonData + 0x8   )
                set flag     = ReadRealMemory( pButtonData + 0x10  )
                set pAbil    = ReadRealMemory( pButtonData + 0x6D4 )

                if pAbil != 0 then
                     set pAbilId  = ReadRealMemory( pAbil + 0x34 )

                    if pAbilId == 0 or pAbilId == 'AHer' or pAbilId == 'Apit' or pAbilId == 'Asid' or pAbilId == 'Asud' then
                        return 0.
                elseif pAbilId == 'Amai' or pAbilId == 'Asei' or pAbilId == 'Asel' then
                        loop
                            exitwhen i > 12
                            set pObj = ReadRealMemory( pAbil + 0xCC + i * 0x4 )

                            if pObj == pOrderId then
                                // to check for charges -> ReadRealFloat( ReadRealMemory( pAbil + 0x100 + i * 4 ) + 0xC )

                                if ReadRealFloat( pAbil + 0x1C4 + i * 0x1C + 0xC ) != .0 then
                                    set pTimer = pAbil + 0x1C4 + i * 0x1C
                                else
                                    set pTimer = pAbil + 0x318 + i * 0x1C
                                endif

                                if pTimer != 0 then
                                    call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                    return ReadRealFloat( arg + 0x4 )
                                endif
                                exitwhen true
                            endif
                            set i = i + 1
                        endloop
                    else
                        if addcheck and flag == 0x2000401 then
                            return 0.
                        endif

                        set flag = ReadRealMemory( pAbil + 0x20 )

                        if BitwiseAnd( flag, 0x200 ) != 0 and BitwiseAnd( flag, 0x400 ) == 0 then
                            set pTimer = pAbil + 0xD0

                            if pTimer != 0 then
                                call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                return ReadRealFloat( arg + 0x4 )
                            endif
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction
    
    function IsButtonOnCooldown takes integer pCommandButton returns boolean
        return GetButtonCooldown( pCommandButton, true ) > 0.
    endfunction

    function AddFrameType takes string name, integer vtype, integer pVtable, integer pVTableObj returns nothing
        local integer hid = StringHash( "FrameTypeTable" )

        call SaveStr(     MemHackTable, hid, pGameDLL + pVtable,    name  )
        call SaveStr(     MemHackTable, hid, pGameDLL + pVTableObj, name  )
        call SaveInteger( MemHackTable, hid, pGameDLL + pVtable,    vtype )
        call SaveInteger( MemHackTable, hid, pGameDLL + pVTableObj, vtype )
    endfunction

    function Init_APIMemoryGameUIButton takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x98109C, 0x981074 )
                    call AddFrameType( "CButtonFrame",                  2, 0x9813A4, 0x98137C )
                    call AddFrameType( "CChatMode",                     3, 0x94CA1C, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x94EA04, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x9822E4, 0x9822B8 )
                    call AddFrameType( "CEditBox",                      6, 0x980994, 0x980968 )
                    call AddFrameType( "CFrame",                        7, 0x97FB5C, 0x97FB34 )
                    call AddFrameType( "CFloatingFrame",                8, 0x98175C, 0x981730 )
                    call AddFrameType( "CGameUI",                       9, 0x94847C, 0x948454 )
                    call AddFrameType( "CHeroBarButton",               10, 0x951A34, 0x951A14 )
                    call AddFrameType( "CHighlightFrame",              11, 0x98161C, 0x9815F4 )
                    call AddFrameType( "CLayoutFrame",                 12, 0x97FAF0, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x98150C, 0x9814E4 )
                    call AddFrameType( "CMinimap",                     14, 0x952184, 0x95215C )
                    call AddFrameType( "CModelFrame",                  15, 0x981254, 0x98122C )
                    call AddFrameType( "CPortraitButton",              16, 0x95233C, 0x952314 )
                    call AddFrameType( "CScreenFrame",                 17, 0x97FD24, 0x97FCFC )
                    call AddFrameType( "CSimpleButton",                18, 0x97F934, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x9800AC, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x97FC5C, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x980AAC, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x97FA2C, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x980F1C, 0x980EF4 )
                    call AddFrameType( "CSpriteFrame",                 25, 0x98022C, 0x980200 )
                    call AddFrameType( "CStatBar",                     26, 0x95075C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x980C7C, 0x980C54 )
                    call AddFrameType( "CTextButtonFrame",             28, 0x980DBC, 0x980D90 )
                    call AddFrameType( "CTextFrame",                   29, 0x98065C, 0x980630 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x9517E4, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x9536D4, 0x9536A8 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x96EA84, 0x96EA58 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x96C164, 0x96C138 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x96E944, 0x96E918 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x96BFDC, 0x96BFB4 )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x96EBC4, 0x96EB98 )
                    call AddFrameType( "CSlashChatBox",                37, 0x96FC44, 0x96FC1C )
                    call AddFrameType( "CTimerTextFrame",              38, 0x96C6BC, 0x96C690 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x980134, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x981F0C, 0x981EE4 )
                    call AddFrameType( "CUpperButtonBar",              41, 0x94E544, 0x94E524 )
                    call AddFrameType( "CResourceBar",                 42, 0x94F38C, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x94DE8C, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x951D64, 0x951D48 )
                    call AddFrameType( "CHeroBar",                     45, 0x951ACC, 0x951AB0 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x951FBC, 0x951F90 )
                    call AddFrameType( "CInfoBar",                     47, 0x9527C4, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x94E1B4, 0x94E188 )
                    call AddFrameType( "CProgressIndicator",           49, 0x94A4AC, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x951B7C, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x94F7E4, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x94EFB4, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x94D624, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x94D4D4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x94D3E4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x94D36C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x94D2F4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x94D27C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x94D204, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x94D18C, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x94F0EC, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x94FFFC, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x94F06C, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x9800E8, 0x000000 )
                endif
            elseif PatchVersion == "1.26a" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x96F3F4, 0x96F3CC )
                    call AddFrameType( "CButtonFrame",                  2, 0x96F6FC, 0x96F6D4 )
                    call AddFrameType( "CChatMode",                     3, 0x93A8BC, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x93EBC4, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x97063C, 0x970610 )
                    call AddFrameType( "CEditBox",                      6, 0x96ECEC, 0x96ECC0 )
                    call AddFrameType( "CFrame",                        7, 0x96DEB4, 0x96DE8C )
                    call AddFrameType( "CFloatingFrame",                8, 0x96FAB4, 0x96FA88 )
                    call AddFrameType( "CGameUI",                       9, 0x93631C, 0x9362F4 )
                    call AddFrameType( "CHeroBarButton",               10, 0x93F8DC, 0x93F8BC )
                    call AddFrameType( "CHighlightFrame",              11, 0x96F974, 0x96F94C )
                    call AddFrameType( "CLayoutFrame",                 12, 0x96DE48, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x96F864, 0x96F83C )
                    call AddFrameType( "CMinimap",                     14, 0x94002C, 0x940004 )
                    call AddFrameType( "CModelFrame",                  15, 0x96F5AC, 0x96F584 )
                    call AddFrameType( "CPortraitButton",              16, 0x9401E4, 0x9401BC )
                    call AddFrameType( "CScreenFrame",                 17, 0x96E07C, 0x96E054 )
                    call AddFrameType( "CSimpleButton",                18, 0x96DC8C, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x96E404, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x96DFB4, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x96EE04, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x96DD84, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x96F274, 0x96F24C )
                    call AddFrameType( "CSpriteFrame",                 25, 0x96E584, 0x96E558 )
                    call AddFrameType( "CStatBar",                     26, 0x93E604, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x96EFD4, 0x96EFAC )
                    call AddFrameType( "CTextButtonFrame",             28, 0x96F114, 0x96F0E8 )
                    call AddFrameType( "CTextFrame",                   29, 0x96E9B4, 0x96E988 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x93F68C, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x94157C, 0x941550 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x95C92C, 0x95C900 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x95A00C, 0x959FE0 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x95C7EC, 0x95C7C0 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x959E84, 0x959E5C )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x95CA6C, 0x95CA40 )
                    call AddFrameType( "CSlashChatBox",                37, 0x95DAEC, 0x95DAC4 )
                    call AddFrameType( "CTimerTextFrame",              38, 0x95A564, 0x95A538 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x96E48C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x970264, 0x97023C )
                    call AddFrameType( "CUpperButtonBar",              41, 0x93C3E4, 0x93C3C4 )
                    call AddFrameType( "CResourceBar",                 42, 0x93D22C, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x93BD2C, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x93FC0C, 0x93FBF0 )
                    call AddFrameType( "CHeroBar",                     45, 0x93F974, 0x93F958 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x93FE64, 0x93FE38 )
                    call AddFrameType( "CInfoBar",                     47, 0x94066C, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x93C054, 0x93C028 )
                    call AddFrameType( "CProgressIndicator",           49, 0x93834C, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x93FA24, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x93D684, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x93CE54, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x93B4C4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x93B374, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x93B284, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x93B20C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x93B194, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x93B11C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x93B0A4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x93B02C, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x93CF8C, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x93DE9C, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x93CF0C, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x96E440, 0x000000 )
                endif
        elseif PatchVersion == "1.27a" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x95AC3C, 0x95AD38 )
                    call AddFrameType( "CButtonFrame",                  2, 0x95B318, 0x95B42C )
                    call AddFrameType( "CChatMode",                     3, 0x98FB4C, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x98F6A8, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x95D0BC, 0x95D1AC )
                    call AddFrameType( "CEditBox",                      6, 0x95BCBC, 0x95BDD4 )
                    call AddFrameType( "CFrame",                        7, 0x95A760, 0x95A848 )
                    call AddFrameType( "CFloatingFrame",                8, 0x95D1D4, 0x95D2BC )
                    call AddFrameType( "CGameUI",                       9, 0x98C3EC, 0x98C4D4 )
                    call AddFrameType( "CHeroBarButton",               10, 0x990E44, 0x990EBC )
                    call AddFrameType( "CHighlightFrame",              11, 0x95ADD4, 0x95AEBC )
                    call AddFrameType( "CLayoutFrame",                 12, 0x95CB54, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x95AF28, 0x95B010 )
                    call AddFrameType( "CMinimap",                     14, 0x99244C, 0x992538 )
                    call AddFrameType( "CModelFrame",                  15, 0x95AAE4, 0x95ABE0 )
                    call AddFrameType( "CPortraitButton",              16, 0x9922FC, 0x992424 )
                    call AddFrameType( "CScreenFrame",                 17, 0x95D2E4, 0x95D3CC )
                    call AddFrameType( "CSimpleButton",                18, 0x95C9A4, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x95CE00, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x95C8A4, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x95CE64, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x95CF38, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x95B468, 0x95B584 )
                    call AddFrameType( "CSpriteFrame",                 25, 0x95A8A4, 0x95A994 )
                    call AddFrameType( "CStatBar",                     26, 0x98F52C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x95C610, 0x95C724 )
                    call AddFrameType( "CTextButtonFrame",             28, 0x95BF60, 0x95C074 )
                    call AddFrameType( "CTextFrame",                   29, 0x95B050, 0x95B164 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x98F364, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x98DCD0, 0x98DDB8 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x975D40, 0x975E54 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x975E7C, 0x975F90 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x977A44, 0x977B58 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x975FB8, 0x9760CC )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x9760F4, 0x97620C )
                    call AddFrameType( "CSlashChatBox",                37, 0x977278, 0x977390 )
                    call AddFrameType( "CTimerTextFrame",              38, 0x979FBC, 0x97A0D0 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x95CABC, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x95B1B0, 0x95B2B8 )
                    call AddFrameType( "CUpperButtonBar",              41, 0x98EF64, 0x98EFD4 )
                    call AddFrameType( "CResourceBar",                 42, 0x993E54, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x992D68, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x992C60, 0x992CD4 )
                    call AddFrameType( "CHeroBar",                     45, 0x990ED8, 0x990F4C )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x994620, 0x994710 )
                    call AddFrameType( "CInfoBar",                     47, 0x99197C, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x994510, 0x9945F8 )
                    call AddFrameType( "CProgressIndicator",           49, 0x98B0E4, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x991010, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x98F438, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x991778, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x9916F8, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x991584, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x991510, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x99149C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x991428, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x9913B4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x991340, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x9912CC, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x991678, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x99116C, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x9915F8, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x95CDC4, 0x000000 )
                endif
        elseif PatchVersion == "1.27b" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0xA8B5AC, 0xA8B6A8 )
                    call AddFrameType( "CButtonFrame",                  2, 0xA8BC88, 0xA8BD9C )
                    call AddFrameType( "CChatMode",                     3, 0xABD488, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0xABCFF4, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0xA8DA14, 0xA8DB04 )
                    call AddFrameType( "CEditBox",                      6, 0xA8C62C, 0xA8C744 )
                    call AddFrameType( "CFrame",                        7, 0xA8B0D0, 0xA8B1B8 )
                    call AddFrameType( "CFloatingFrame",                8, 0xA8DB2C, 0xA8DC14 )
                    call AddFrameType( "CGameUI",                       9, 0xAB9D90, 0xAB9E78 )
                    call AddFrameType( "CHeroBarButton",               10, 0xABE768, 0xABE7E0 )
                    call AddFrameType( "CHighlightFrame",              11, 0xA8B744, 0xA8B82C )
                    call AddFrameType( "CLayoutFrame",                 12, 0xA8D4B4, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0xA8B898, 0xA8B980 )
                    call AddFrameType( "CMinimap",                     14, 0xAB0EE4, 0xAB0FD4 )
                    call AddFrameType( "CModelFrame",                  15, 0xA8B454, 0xA8B550 )
                    call AddFrameType( "CPortraitButton",              16, 0xABFBC0, 0xABFCE8 )
                    call AddFrameType( "CScreenFrame",                 17, 0xA8DC3C, 0xA8DD24 )
                    call AddFrameType( "CSimpleButton",                18, 0xA8D304, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0xA8D760, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0xA8D204, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0xA8D7C4, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0xA8D88C, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0xA8BDD8, 0xA8BEF4 )
                    call AddFrameType( "CSpriteFrame",                 25, 0xA8B214, 0xA8B304 )
                    call AddFrameType( "CStatBar",                     26, 0xABCE78, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0xA8CF7C, 0xA8D090 )
                    call AddFrameType( "CTextButtonFrame",             28, 0xA8C8CC, 0xA8C9E0 )
                    call AddFrameType( "CTextFrame",                   29, 0xA8B9C0, 0xA8BAD4 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0xABCCC8, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0xABB66C, 0xABB754 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0xAA3D00, 0xAA3E14 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0xAA3E3C, 0xAA3F50 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0xAA59C0, 0xAA5AD4 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0xAA3F78, 0xAA408C )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0xAA40B4, 0xAA41CC )
                    call AddFrameType( "CSlashChatBox",                37, 0xAA5238, 0xAA5350 )
                    call AddFrameType( "CTimerTextFrame",              38, 0xAA7E70, 0xAA7F84 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0xA8D41C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0xA8BB20, 0xA8BC28 )
                    call AddFrameType( "CUpperButtonBar",              41, 0xABC8D8, 0xABC948 )
                    call AddFrameType( "CResourceBar",                 42, 0xAC16A8, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0xAC05FC, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0xAC0504, 0xAC0578 )
                    call AddFrameType( "CHeroBar",                     45, 0xABE7FC, 0xABE870 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0xAC1E58, 0xAC1F48 )
                    call AddFrameType( "CInfoBar",                     47, 0xABF288, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0xAC1D48, 0xAC1E30 )
                    call AddFrameType( "CProgressIndicator",           49, 0xAB8BE8, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0xABE924, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0xABCD94, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0xABF084, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0xABF004, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0xABEE90, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0xABEE1C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0xABEDA8, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0xABED34, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0xABECC0, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0xABEC4C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0xABEBD8, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0xABEF84, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0xABEA78, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0xABEF04, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0xA8D724, 0x000000 )
                endif
        elseif PatchVersion == "1.28f" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0xA7AFBC, 0xA7B0B8 )
                    call AddFrameType( "CButtonFrame",                  2, 0xA7B698, 0xA7B7AC )
                    call AddFrameType( "CChatMode",                     3, 0xAADE54, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0xAAD9B8, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0xA7D42C, 0xA7D51C )
                    call AddFrameType( "CEditBox",                      6, 0xA7C03C, 0xA7C154 )
                    call AddFrameType( "CFrame",                        7, 0xA7AAE0, 0xA7ABC8 )
                    call AddFrameType( "CFloatingFrame",                8, 0xA7D544, 0xA7D62C )
                    call AddFrameType( "CGameUI",                       9, 0xAAA730, 0xAAA818 )
                    call AddFrameType( "CHeroBarButton",               10, 0xAAF130, 0xAAF1A8 )
                    call AddFrameType( "CHighlightFrame",              11, 0xA7B154, 0xA7B23C )
                    call AddFrameType( "CLayoutFrame",                 12, 0xA7CEC4, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0xA7B2A8, 0xA7B390 )
                    call AddFrameType( "CMinimap",                     14, 0xAB0704, 0xAB07F0 )
                    call AddFrameType( "CModelFrame",                  15, 0xA7AE64, 0xA7AF60 )
                    call AddFrameType( "CPortraitButton",              16, 0xAB05B4, 0xAB06DC )
                    call AddFrameType( "CScreenFrame",                 17, 0xA7D654, 0xA7D73C )
                    call AddFrameType( "CSimpleButton",                18, 0xA7CD14, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0xA7D178, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0xA7CC14, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0xA7D1DC, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0xA7D2A8, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0xA7B7E8, 0xA7B904 )
                    call AddFrameType( "CSpriteFrame",                 25, 0xA7AC24, 0xA7AD14 )
                    call AddFrameType( "CStatBar",                     26, 0xAAD83C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0xA7C98C, 0xA7CAA0 )
                    call AddFrameType( "CTextButtonFrame",             28, 0xA7C2DC, 0xA7C3F0 )
                    call AddFrameType( "CTextFrame",                   29, 0xA7B3D0, 0xA7B4E4 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0xAAD684, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0xAAC008, 0xAAC0F0 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0xA93B68, 0xA93C7C )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0xA93CA4, 0xA93DB8 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0xA95844, 0xA95958 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0xA93DE0, 0xA93EF4 )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0xA93F1C, 0xA94034 )
                    call AddFrameType( "CSlashChatBox",                37, 0xA950A0, 0xA951B8 )
                    call AddFrameType( "CTimerTextFrame",              38, 0xA97D38, 0xA97E4C )
                    call AddFrameType( "CSimpleStatusBar",             39, 0xA7CE2C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0xA7B530, 0xA7B638 )
                    call AddFrameType( "CUpperButtonBar",              41, 0xAAD28C, 0xAAD2FC )
                    call AddFrameType( "CResourceBar",                 42, 0xAB20D4, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0xAB1008, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0xAB0F08, 0xAB0F7C )
                    call AddFrameType( "CHeroBar",                     45, 0xAAF1C4, 0xAAF238 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0xAB2890, 0xAB2980 )
                    call AddFrameType( "CInfoBar",                     47, 0xAAFC58, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0xAB2780, 0xAB2868 )
                    call AddFrameType( "CProgressIndicator",           49, 0xAA950C, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0xAAF2F0, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0xAAD750, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0xAAFA54, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0xAAF9D4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0xAAF860, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0xAAF7EC, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0xAAF778, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0xAAF704, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0xAAF690, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0xAAF61C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0xAAF5A8, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0xAAF954, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0xAAF448, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0xAAF8D4, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0xA7D13C, 0x000000 )
                endif
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameUIButton takes nothing returns nothing
    //set gg_trg_APIMemoryGameUIButton = CreateTrigger(  )
endfunction
//! endnocjass
