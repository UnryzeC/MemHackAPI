//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSpriteFrameAPI
    globals
        integer pSetCSpriteFrameArt      = 0
        integer pGetCSpriteFrameHeight   = 0
        integer pSetCSpriteFrameScale    = 0
    endglobals

    function SetCSpriteFrameArt takes integer pFrame, string model, integer modeltype, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSpriteFrameArt > 0 then
            if fid == 25 then
                return this_call_4( pSetCSpriteFrameArt, pFrame, GetStringAddress( model ), modeltype, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function GetCSpriteFrameHeight takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if pGetCSpriteFrameHeight > 0 then
            if fid == 25 then
                return GetRealFromMemory( this_call_1( pGetCSpriteFrameHeight, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function SetCSpriteFrameScale takes integer pFrame, real scale returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSpriteFrameScale > 0 then
            if fid == 25 then
                return this_call_2( pSetCSpriteFrameScale, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSpriteFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSpriteFrameArt       = pGameDLL + 0x60FB00
                set pGetCSpriteFrameHeight    = pGameDLL + 0x60F2A0
                set pSetCSpriteFrameScale     = pGameDLL + 0x60F600
        elseif PatchVersion == "1.26a" then
                set pSetCSpriteFrameArt       = pGameDLL + 0x60F360
                set pGetCSpriteFrameHeight    = pGameDLL + 0x60EB00
                set pSetCSpriteFrameScale     = pGameDLL + 0x60EE60
        elseif PatchVersion == "1.27a" then
                set pSetCSpriteFrameArt       = pGameDLL + 0x0A38C0
                set pGetCSpriteFrameHeight    = pGameDLL + 0x0A3260
                set pSetCSpriteFrameScale     = pGameDLL + 0x0A39A0
        elseif PatchVersion == "1.27b" then
                set pSetCSpriteFrameArt        = pGameDLL + 0x0F7620
                set pGetCSpriteFrameHeight    = pGameDLL + 0x0F6FC0
                set pSetCSpriteFrameScale     = pGameDLL + 0x0F7700
        elseif PatchVersion == "1.28f" then
                set pSetCSpriteFrameArt       = pGameDLL + 0x125C90
                set pGetCSpriteFrameHeight    = pGameDLL + 0x125630
                set pSetCSpriteFrameScale     = pGameDLL + 0x125D70
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSpriteFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
