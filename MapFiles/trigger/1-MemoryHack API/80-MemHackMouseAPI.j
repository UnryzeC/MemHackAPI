//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackMouseAPI
    globals
        integer pGameClass2         = 0
        integer pGlobalMouseEvent   = 0
    endglobals

    function GetCursorX takes nothing returns integer
        local integer pMouse = GetCursorPos( )
        
        if pMouse > 0 then
            return ReadRealMemory( pCursorCoords + 0x0 )
        endif

        return 0
    endfunction

    function GetCursorY takes nothing returns integer
        local integer pMouse = GetCursorPos( )
        
        if pMouse > 0 then
            return ReadRealMemory( pCursorCoords + 0x4 )
        endif

        return 0
    endfunction

    function GetCursorXRelative takes nothing returns integer
        local integer pMouse = GetCursorPos( )

        if pMouse > 0 then
            if ScreenToClient( pHWND_WC3, pCursorCoords ) > 0 then
                return ReadRealMemory( pCursorCoords + 0x0 )
            endif
        endif

        return 0
    endfunction

    function GetCursorYRelative takes nothing returns integer
        local integer pMouse = GetCursorPos( )

        if pMouse > 0 then
            if ScreenToClient( pHWND_WC3, pCursorCoords ) > 0 then
                return ReadRealMemory( pCursorCoords + 0x4 )
            endif
        endif

        return 0
    endfunction

    function GetMouseWorldEnv takes nothing returns integer
        return ReadRealMemory( ReadRealMemory( pGameClass2 ) + 0x3BC ) + 0x310
    endfunction

    function GetMouseWorldX takes nothing returns real
        return GetRealFromMemory( ReadRealMemory( GetMouseWorldEnv( ) + 0x0 ) )
    endfunction

    function GetMouseWorldY takes nothing returns real
        return GetRealFromMemory( ReadRealMemory( GetMouseWorldEnv( ) + 0x4 ) )
    endfunction

    function GetMouseWorldZ takes nothing returns real
        return GetRealFromMemory( ReadRealMemory( GetMouseWorldEnv( ) + 0x8 ) )
    endfunction
    
    function Init_MemHackMouseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGameClass2         = pGameDLL + 0xACBDD8
                set pGlobalMouseEvent   = pGameDLL + 0xAB0454
        elseif PatchVersion == "1.26a" then
                set pGameClass2         = pGameDLL + 0xAB4F80
                set pGlobalMouseEvent   = pGameDLL + 0xA9A434
        elseif PatchVersion == "1.27a" then
                set pGameClass2         = pGameDLL + 0xBE6350 // (_DWORD *)Storm_401(1108, "CGameUI.cpp", 6831, 
                set pGlobalMouseEvent   = pGameDLL + 0xB66308 //  = &CMouseEvent::`vftable`;
        elseif PatchVersion == "1.27b" then
                set pGameClass2         = pGameDLL + 0xD6A8B8
                set pGlobalMouseEvent   = pGameDLL + 0xCE3A8C
        elseif PatchVersion == "1.28f" then
                set pGameClass2         = pGameDLL + 0xD326F0
                set pGlobalMouseEvent   = pGameDLL + 0xCB1AD4
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackMouseAPI takes nothing returns nothing
    //set gg_trg_MemHackMouseAPI = CreateTrigger(  )
endfunction
//! endnocjass
