//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSliderAPI
    globals
        integer pSetCSliderCurrentValue = 0
    endglobals

    function SetCSliderCurrentValue takes integer pFrame, real value returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSliderCurrentValue > 0 then 
            if fid == 24 then
                return this_call_3( pSetCSliderCurrentValue, pFrame, SetRealIntoMemory( value ), 1 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSliderAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSliderCurrentValue = pGameDLL + 0x61F610
        elseif PatchVersion == "1.26a" then
                set pSetCSliderCurrentValue = pGameDLL + 0x61EE70
        elseif PatchVersion == "1.27a" then
                set pSetCSliderCurrentValue = pGameDLL + 0x0AB3B0
        elseif PatchVersion == "1.27b" then
                set pSetCSliderCurrentValue = pGameDLL + 0x0FF110
        elseif PatchVersion == "1.28f" then
                set pSetCSliderCurrentValue = pGameDLL + 0x12D780
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSliderAPI takes nothing returns nothing
    //set gg_trg_MemHackCSliderAPI = CreateTrigger(  )
endfunction
//! endnocjass
