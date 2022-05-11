//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCTextAreaAPI
    function SetCTextAreaText takes integer pFrame, string text returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 27 then
                return B2I( this_call_2( addr, pFrame, GetStringAddress( text ) ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCTextAreaAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ), pGameDLL + 0x61E830 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ), pGameDLL + 0x61E090 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ), pGameDLL + 0x0B6500 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ), pGameDLL + 0x10A260 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CTextArea" ), StringHash( "SetText" ), pGameDLL + 0x138790 )
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
