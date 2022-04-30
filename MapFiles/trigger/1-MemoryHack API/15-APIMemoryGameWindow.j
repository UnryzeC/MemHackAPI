//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameWindow
    globals
        integer pGetWarcraftWindow          = 0
        integer pGetWindowWidth             = 0
        integer pGetWindowHeight            = 0
    endglobals

    // Window API Engine
    function GetWindowWidth takes nothing returns real
        if pGetWindowWidth > 0 then
            return GetRealFromMemory( ReadRealMemory( pGetWindowWidth ) )
        endif

        return 0.
    endfunction

    function GetWindowHeight takes nothing returns real
        if pGetWindowHeight > 0 then
            return GetRealFromMemory( ReadRealMemory( pGetWindowHeight ) )
        endif

        return 0.
    endfunction
    
    function GetWindowCenterX takes nothing returns real
        return GetWindowX( pHWND_WC3 ) + GetWindowWidth( ) * 0.5
    endfunction

    function GetWindowCenterY takes nothing returns real
        return GetWindowY( pHWND_WC3 ) + GetWindowHeight( ) * 0.5
    endfunction

    function GetWarcraftWindow takes nothing returns integer
        local integer hwnd = 0

        if pGetWarcraftWindow > 0 then
            set hwnd = this_call_1( pGetWarcraftWindow, 0 )
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
                set pGetWindowWidth     = pGameDLL + 0xAF577C
                set pGetWindowHeight    = pGameDLL + 0xAF5778
                set pGetWarcraftWindow  = pGameDLL + 0x6BB510
        elseif PatchVersion == "1.26a" then
                set pGetWindowWidth     = pGameDLL + 0xADE91C
                set pGetWindowHeight    = pGameDLL + 0xADE918
                set pGetWarcraftWindow  = pGameDLL + 0x6BAD70
        elseif PatchVersion == "1.27a" then
                set pGetWindowWidth     = pGameDLL + 0xBBA22C // "config.txt", 0) -> sub_6F first func no params -> above return variable under |= 1u = pGetWindow | pGetWindow + 0xC
                set pGetWindowHeight    = pGameDLL + 0xBBA228 // pGetWindow + 0x8
                set pGetWarcraftWindow  = pGameDLL + 0x14D670 // return GetActiveWindow();
        elseif PatchVersion == "1.27b" then
                set pGetWindowWidth     = pGameDLL + 0xD47CC4
                set pGetWindowHeight    = pGameDLL + 0xD47CC0
                set pGetWarcraftWindow  = pGameDLL + 0x08B0A0
        elseif PatchVersion == "1.28f" then
                set pGetWindowWidth     = pGameDLL + 0xD0FAB4
                set pGetWindowHeight    = pGameDLL + 0xD0FAB0
                set pGetWarcraftWindow  = pGameDLL + 0x0B49B0
            endif

            if pGetWarcraftWindow > 0 then
                set pHWND_WC3 = GetWarcraftWindow( )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameWindow takes nothing returns nothing
    //set gg_trg_APIMemoryGameWindow = CreateTrigger(  )
endfunction
//! endnocjass
