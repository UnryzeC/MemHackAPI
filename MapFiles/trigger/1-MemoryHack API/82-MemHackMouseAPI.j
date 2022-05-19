//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackMouseAPI
    function GetCMouseEvent takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ) )
    endfunction

    function GetCursorX takes nothing returns integer
        local integer pMouse = GetCursorPosStruct( )
        
        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x0 )
        endif

        return 0
    endfunction

    function GetCursorY takes nothing returns integer
        local integer pMouse = GetCursorPosStruct( )
        
        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x4 )
        endif

        return 0
    endfunction
    
    function GetCursorRelativeAxis takes nothing returns integer
        local integer window = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) )
        local integer pMouse = 0

        if window != 0 then
            set pMouse = GetCursorPosStruct( )

            if pMouse != 0 then
                if ScreenToClient( window, pMouse ) > 0 then
                    return pMouse
                endif
            endif
        endif

        return 0
    endfunction

    function GetCursorXRelative takes nothing returns integer
        local integer pMouse = GetCursorRelativeAxis( )

        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x0 )
        endif

        return 0
    endfunction

    function GetCursorYRelative takes nothing returns integer
        local integer pMouse = GetCursorRelativeAxis( )

        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x4 )
        endif

        return 0
    endfunction

    function GetMouseWorldEnv takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ) )

        if addr != 0 then
            set addr = ReadRealMemory( addr )

            if addr != 0 then
                set addr = ReadRealMemory( addr + 0x3BC )

                if addr != 0 then
                    return addr + 0x310
                endif
            endif
        endif

        return 0
    endfunction

    function GetMouseWorldAxis takes integer offset returns real
        local integer addr = GetMouseWorldEnv( )

        if addr != 0 then
            return ReadRealFloat( GetMouseWorldEnv( ) + offset )
        endif

        return 0.
    endfunction

    function GetMouseWorldX takes nothing returns real
        return GetMouseWorldAxis( 0x0 )
    endfunction

    function GetMouseWorldY takes nothing returns real
        return GetMouseWorldAxis( 0x4 )
    endfunction

    function GetMouseWorldZ takes nothing returns real
        return GetMouseWorldAxis( 0x8 )
    endfunction
    
    function Init_MemHackMouseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xACBDD8 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xAB0454 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xAB4F80 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xA9A434 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xBE6350 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xB66308 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xD6A8B8 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xCE3A8C )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xD326F0 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xCB1AD4 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackMouseAPI takes nothing returns nothing
    //set gg_trg_MemHackMouseAPI = CreateTrigger(  )
endfunction
//! endnocjass
