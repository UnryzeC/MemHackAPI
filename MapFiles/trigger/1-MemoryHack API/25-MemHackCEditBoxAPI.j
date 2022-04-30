//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameEditBoxAPI
    globals
        integer pGetCEditBoxText    = 0
        integer pSetCEditBoxText    = 0
        integer pSetCEditBoxFont    = 0
        integer pSetCEditBoxFocus   = 0
    endglobals

    function SetCEditBoxFocus takes integer pFrame, boolean flag returns integer
        if GetFrameType( pFrame ) == 6 then
            return this_call_2( pSetCEditBoxFocus, pFrame, B2I( flag ) )
        endif

        return 0
    endfunction

    function SetCEditBoxFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer fid = GetFrameType( pFrame )
        
        if pSetCEditBoxFont > 0 then
            if fid == 6 then
                return this_call_4( pSetCEditBoxFont, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function GetCEditBoxText takes integer pFrame returns string
        local integer fid = GetFrameType( pFrame )

        if pGetCEditBoxText > 0 then
            if fid == 6 then
                return ToJString( this_call_1( pGetCEditBoxText, pFrame ) )
            endif
        endif

        return ""
    endfunction

    function SetCEditBoxText takes integer pFrame, string text returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCEditBoxText > 0 then
            if fid == 6 or fid == 36 or fid == 37 then
                return B2I( this_call_3( pSetCEditBoxText, pFrame, GetStringAddress( text ), 1 ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCEditBoxAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGetCEditBoxText    = pGameDLL + 0x614640
                set pSetCEditBoxText    = pGameDLL + 0x6162F0
                set pSetCEditBoxFont    = pGameDLL + 0x614440
                set pSetCEditBoxFocus   = pGameDLL + 0x615920
        elseif PatchVersion == "1.26a" then
                set pGetCEditBoxText    = pGameDLL + 0x613EA0
                set pSetCEditBoxText    = pGameDLL + 0x615B50
                set pSetCEditBoxFont    = pGameDLL + 0x613CA0
                set pSetCEditBoxFocus   = pGameDLL + 0x615180
        elseif PatchVersion == "1.27a" then
                set pGetCEditBoxText    = pGameDLL + 0x0AEDF0
                set pSetCEditBoxText    = pGameDLL + 0x0B0450
                set pSetCEditBoxFont    = pGameDLL + 0x0B0350
                set pSetCEditBoxFocus   = pGameDLL + 0x0B0260
        elseif PatchVersion == "1.27b" then
                set pGetCEditBoxText    = pGameDLL + 0x102B50
                set pSetCEditBoxText    = pGameDLL + 0x1041B0
                set pSetCEditBoxFont    = pGameDLL + 0x1040B0
                set pSetCEditBoxFocus   = pGameDLL + 0x103FC0
        elseif PatchVersion == "1.28f" then
                set pGetCEditBoxText    = pGameDLL + 0x1311C0
                set pSetCEditBoxText    = pGameDLL + 0x132820
                set pSetCEditBoxFont    = pGameDLL + 0x132720
                set pSetCEditBoxFocus   = pGameDLL + 0x132630
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCEditBoxAPI takes nothing returns nothing
    //set gg_trg_MemHackCEditBoxAPI = CreateTrigger(  )
endfunction
//! endnocjass
