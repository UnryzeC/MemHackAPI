//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleMessageFrameAPI
    globals
        integer pSetCSimpleMessageFrameFont = 0
    endglobals

    function SetCSimpleMessageFrameFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer fid = GetFrameType( pFrame )
        
        if pSetCSimpleMessageFrameFont > 0 then
            if fid == 23 then
                return this_call_4( pSetCSimpleMessageFrameFont, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleMessageFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSimpleMessageFrameFont = pGameDLL + 0x6042B0
        elseif PatchVersion == "1.26a" then
                set pSetCSimpleMessageFrameFont = pGameDLL + 0x603B10
        elseif PatchVersion == "1.27a" then
                set pSetCSimpleMessageFrameFont = pGameDLL + 0x0C2E80 // "CSimpleMessageFrame.cpp", 54, 0);
        elseif PatchVersion == "1.27b" then
                set pSetCSimpleMessageFrameFont = pGameDLL + 0x116BE0
        elseif PatchVersion == "1.28f" then
                set pSetCSimpleMessageFrameFont = pGameDLL + 0x145290
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleMessageFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleMessageFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
