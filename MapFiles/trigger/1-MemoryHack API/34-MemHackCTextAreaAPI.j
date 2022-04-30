//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCTextAreaAPI
    globals
        integer pSetCTextAreaText   = 0
    endglobals

    function SetCTextAreaText takes integer pFrame, string text returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCTextAreaText > 0 then
            if fid == 27 then
                return B2I( this_call_2( pSetCTextAreaText, pFrame, GetStringAddress( text ) ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCTextAreaAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCTextAreaText   = pGameDLL + 0x61E830
        elseif PatchVersion == "1.26a" then
                set pSetCTextAreaText   = pGameDLL + 0x61E090
        elseif PatchVersion == "1.27a" then
                set pSetCTextAreaText   = pGameDLL + 0x0B6500 // "QUESTNOTDISCOVERED", &v14,
        elseif PatchVersion == "1.27b" then
                set pSetCTextAreaText   = pGameDLL + 0x10A260
        elseif PatchVersion == "1.28f" then
                set pSetCTextAreaText   = pGameDLL + 0x138790
            endif
        endif
    endfunction
endlibrary
//! endnocjass

//===========================================================================
function InitTrig_MemHackCTextAreaAPI takes nothing returns nothing
    //set gg_trg_MemHackCTextAreaAPI = CreateTrigger(  )
endfunction
//! endnocjass
