//TESH.scrollpos=12
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleGlueAPI
    globals
        integer pSetCSimpleGlueFrameScale = 0
    endglobals

    function SetCSimpleGlueFrameScale takes integer pFrame, real scale returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleGlueFrameScale > 0 then
            if fid == 21 then
                return this_call_2( pSetCSimpleGlueFrameScale, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleGlueAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSimpleGlueFrameScale = pGameDLL + 0x617270
        elseif PatchVersion == "1.26a" then
                set pSetCSimpleGlueFrameScale = pGameDLL + 0x616AD0
        elseif PatchVersion == "1.27a" then
                set pSetCSimpleGlueFrameScale = pGameDLL + 0x0C19C0 // (*(int (__stdcall **)(float))(*(_DWORD *)(v2[73]
        elseif PatchVersion == "1.27b" then
                set pSetCSimpleGlueFrameScale = pGameDLL + 0x115720
        elseif PatchVersion == "1.28f" then
                set pSetCSimpleGlueFrameScale = pGameDLL + 0x143DD0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleGlueAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleGlueAPI = CreateTrigger(  )
endfunction
//! endnocjass
