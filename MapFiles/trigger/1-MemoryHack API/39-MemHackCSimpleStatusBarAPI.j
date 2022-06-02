//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleStatusBarAPI
    function SetCSimpleStatusBarTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSimpleStatusBar" then // 39
                return this_call_3( addr, pFrame, GetStringAddress( texturepath ), B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleStatusBarValue takes integer pFrame, real value returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSimpleStatusBar" then // 39
                return this_call_2( addr, pFrame, SetRealIntoMemory( value ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleStatusBarMinMaxValue takes integer pFrame, real minval, real maxval returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSimpleStatusBar" then // 39
                return this_call_3( addr, pFrame, SetRealIntoMemory( minval ), SetRealIntoMemory( maxval ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleStatusBarAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ),     pGameDLL + 0x60EDB0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ),       pGameDLL + 0x60EBD0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ), pGameDLL + 0x60EB50 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ),     pGameDLL + 0x60E610 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ),       pGameDLL + 0x60E430 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ), pGameDLL + 0x60E3B0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ),     pGameDLL + 0x0BC130 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ),       pGameDLL + 0x0BC2E0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ), pGameDLL + 0x0BC270 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ),     pGameDLL + 0x10FE90 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ),       pGameDLL + 0x110040 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ), pGameDLL + 0x10FFD0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetTexture" ),     pGameDLL + 0x13E3C0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetValue" ),       pGameDLL + 0x13E570 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleStatusBar" ), StringHash( "SetMinMaxValue" ), pGameDLL + 0x13E500 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleStatusBarAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleStatusBarAPI = CreateTrigger(  )
endfunction
//! endnocjass
