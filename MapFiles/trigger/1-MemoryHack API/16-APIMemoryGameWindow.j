//TESH.scrollpos=21
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameWindow
    // Window API Engine
    function GetWindowWidth takes nothing returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ) )
    
        if addr != 0 then
            return ReadRealFloat( addr )
        endif

        return 0.
    endfunction

    function GetWindowHeight takes nothing returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ) )

        if addr != 0 then
            return ReadRealFloat( addr )
        endif

        return 0.
    endfunction
    
    function GetWindowCenterX takes nothing returns real
        return GetWindowX( LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) ) ) + GetWindowWidth( ) * 0.5
    endfunction

    function GetWindowCenterY takes nothing returns real
        return GetWindowY( LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) ) ) + GetWindowHeight( ) * 0.5
    endfunction

    function GetWarcraftWindow takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ) )
        local integer hwnd = 0

        if addr != 0 then
            set hwnd = this_call_1( addr, 0 )
        else
            set hwnd = FindWindow( "Warcraft III", "Warcraft III" )
        endif

        return hwnd
    endfunction
    
    function FromPixelX takes integer i returns real
        return i * 0.8 / GetWindowWidth( )
    endfunction

    function FromPixelY takes integer i returns real
        return i * 0.6 / GetWindowHeight( )
    endfunction
    //===========================================

    function Init_APIMemoryGameWindow takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xAF577C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xAF5778 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x6BB510 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xADE91C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xADE918 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x6BAD70 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xBBA22C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xBBA228 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x14D670 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xD47CC4 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xD47CC0 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x08B0A0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xD0FAB4 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xD0FAB0 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x0B49B0 )
            endif

            call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ), GetWarcraftWindow( ) )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameWindow takes nothing returns nothing
    //set gg_trg_APIMemoryGameWindow = CreateTrigger(  )
endfunction
//! endnocjass
