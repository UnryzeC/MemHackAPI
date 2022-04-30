//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleStatusBarAPI
    globals
        integer pSetCSimpleStatusBarTexture     = 0
        integer pSetCSimpleStatusBarValue       = 0
        integer pSetCSimpleStatusBarMinMaxValue = 0
    endglobals

    function SetCSimpleStatusBarTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleStatusBarTexture > 0 then
            if fid == 39 then
                return this_call_3( pSetCSimpleStatusBarTexture, pFrame, GetStringAddress( texturepath ), B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleStatusBarValue takes integer pFrame, real value returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleStatusBarValue > 0 then
            if fid == 39 then
                return this_call_2( pSetCSimpleStatusBarValue, pFrame, SetRealIntoMemory( value ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleStatusBarMinMaxValue takes integer pFrame, real minval, real maxval returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleStatusBarMinMaxValue > 0 then
            if fid == 39 then
                return this_call_3( pSetCSimpleStatusBarMinMaxValue, pFrame, SetRealIntoMemory( minval ), SetRealIntoMemory( maxval ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleStatusBarAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSimpleStatusBarTexture     = pGameDLL + 0x60EDB0
                set pSetCSimpleStatusBarValue       = pGameDLL + 0x60EBD0
                set pSetCSimpleStatusBarMinMaxValue = pGameDLL + 0x60EB50
        elseif PatchVersion == "1.26a" then
                set pSetCSimpleStatusBarTexture     = pGameDLL + 0x60E610
                set pSetCSimpleStatusBarValue       = pGameDLL + 0x60E430
                set pSetCSimpleStatusBarMinMaxValue = pGameDLL + 0x60E3B0
        elseif PatchVersion == "1.27a" then
                set pSetCSimpleStatusBarTexture     = pGameDLL + 0x0BC130
                set pSetCSimpleStatusBarValue       = pGameDLL + 0x0BC2E0
                set pSetCSimpleStatusBarMinMaxValue = pGameDLL + 0x0BC270
        elseif PatchVersion == "1.27b" then
                set pSetCSimpleStatusBarTexture     = pGameDLL + 0x10FE90
                set pSetCSimpleStatusBarValue       = pGameDLL + 0x110040
                set pSetCSimpleStatusBarMinMaxValue = pGameDLL + 0x10FFD0
        elseif PatchVersion == "1.28f" then
                set pSetCSimpleStatusBarTexture     = pGameDLL + 0x13E3C0
                set pSetCSimpleStatusBarValue       = pGameDLL + 0x13E570
                set pSetCSimpleStatusBarMinMaxValue = pGameDLL + 0x13E500
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleStatusBarAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleStatusBarAPI = CreateTrigger(  )
endfunction
//! endnocjass
