//TESH.scrollpos=81
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCLayoutFrameAPI
    globals
        integer pSetCLayoutFrameScale           = 0
        integer pGetCLayoutFrameHeight          = 0
        
        integer pSetCLayoutFramePoint           = 0
        integer pClearCLayoutFrameAllPoints     = 0
        integer pSetCLayoutFrameWidth           = 0
        integer pSetCLayoutFrameHeight          = 0
        integer pSetCLayoutFrameAbsolutePoint   = 0
        integer pSetCLayoutFrameCageMouse       = 0
        integer pSetCLayoutFrameAllPoints       = 0
    endglobals

    function SetCLayoutFrameAbsolutePoint takes integer pFrame, integer point, real offsetX, real offsetY returns integer
        if pSetCLayoutFrameAbsolutePoint > 0 then
            if GetFrameLayout( pFrame ) > 0 then
                return this_call_5( pSetCLayoutFrameAbsolutePoint, pFrame, point, SetRealIntoMemory( offsetX ), SetRealIntoMemory( offsetY ), 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameCageMouse takes integer pFrame, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayoutFrameCageMouse > 0 then
            if fid > 0 then
                return this_call_2( pSetCLayoutFrameCageMouse, pFrame, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function ClearCLayoutFrameAllPoints takes integer pFrame returns integer
        if pClearCLayoutFrameAllPoints > 0 then
            set pFrame = GetFrameLayout( pFrame )

            if pFrame > 0 then
                return this_call_2( pClearCLayoutFrameAllPoints, pFrame, 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameWidth takes integer pFrame, real width returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayoutFrameWidth > 0 then
            if fid > 0 then
                return this_call_2( pSetCLayoutFrameWidth, pFrame, SetRealIntoMemory( width ) )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameHeight takes integer pFrame, real height returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayoutFrameHeight > 0 then
            if fid > 0 then
                return this_call_2( pSetCLayoutFrameHeight, pFrame, SetRealIntoMemory( height ) )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameAllPoints takes integer pFrame, integer relativeframe returns integer
         if pSetCLayoutFrameAllPoints > 0 then
            set pFrame = GetFrameLayout( pFrame )

            if pFrame > 0 and GetFrameLayout( relativeframe ) > 0 then
                return this_call_3( pSetCLayoutFrameAllPoints, pFrame, relativeframe, 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameSize takes integer pFrame, real width, real height returns integer
        local integer fid = GetFrameLayout( pFrame )

        if pSetCLayoutFrameWidth > 0 and pSetCLayoutFrameHeight > 0 then
            if fid != 0 then
                call this_call_2( pSetCLayoutFrameWidth, fid, SetRealIntoMemory( width ) )
                call this_call_2( pSetCLayoutFrameHeight, fid, SetRealIntoMemory( height ) )
                return 1
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFramePoint takes integer pFrame, integer point, integer pParentFrame, integer relativePoint, real x, real y returns integer
        if pSetCLayoutFramePoint > 0 then
            if pFrame > 0 and pParentFrame > 0 then
                return B2I( this_call_7( pSetCLayoutFramePoint, pFrame, point, pParentFrame, relativePoint, SetRealIntoMemory( x ), SetRealIntoMemory( y ), 1 ) > 0 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameScale takes integer pFrame, real scale returns integer
        set pFrame = GetFrameLayout( pFrame )

        if pSetCLayoutFrameScale > 0 then
            if pFrame > 0 then
                return this_call_2( pSetCLayoutFrameScale, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function GetCLayoutFrameHeight takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if pGetCLayoutFrameHeight > 0 then
            if fid != 15 and fid != 19 and fid != 25 and fid != 29 then
                set pFrame = GetFrameLayoutByType( pFrame, fid )

                if pFrame > 0 then
                    return GetRealFromMemory( this_call_1( pGetCLayoutFrameHeight, pFrame ) )
                endif
            endif
        endif

        return 0.
    endfunction

    function Init_MemHackCLayoutFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGetCLayoutFrameHeight          = pGameDLL + 0x605740
                set pSetCLayoutFrameScale           = pGameDLL + 0x6064E0
                set pSetCLayoutFramePoint           = pGameDLL + 0x606F10
                set pClearCLayoutFrameAllPoints     = pGameDLL + 0x606A10
                set pSetCLayoutFrameWidth           = pGameDLL + 0x606530
                set pSetCLayoutFrameHeight          = pGameDLL + 0x606550
                set pSetCLayoutFrameAbsolutePoint   = pGameDLL + 0x606950
                set pSetCLayoutFrameCageMouse       = pGameDLL + 0x605760
                set pSetCLayoutFrameAllPoints       = pGameDLL + 0x606F90
        elseif PatchVersion == "1.26a" then
                set pGetCLayoutFrameHeight          = pGameDLL + 0x604FA0
                set pSetCLayoutFrameScale           = pGameDLL + 0x605D40
                set pSetCLayoutFramePoint           = pGameDLL + 0x606770
                set pClearCLayoutFrameAllPoints     = pGameDLL + 0x606270
                set pSetCLayoutFrameWidth           = pGameDLL + 0x605D90
                set pSetCLayoutFrameHeight          = pGameDLL + 0x605DB0
                set pSetCLayoutFrameAbsolutePoint   = pGameDLL + 0x6061B0
                set pSetCLayoutFrameCageMouse       = pGameDLL + 0x604FC0
                set pSetCLayoutFrameAllPoints       = pGameDLL + 0x6067F0
        elseif PatchVersion == "1.27a" then
                set pGetCLayoutFrameHeight          = pGameDLL + 0x0BCDF0
                set pSetCLayoutFrameScale           = pGameDLL + 0x0BD7E0
                set pSetCLayoutFramePoint           = pGameDLL + 0x0BD8A0
                set pClearCLayoutFrameAllPoints     = pGameDLL + 0x0BCB50
                set pSetCLayoutFrameWidth           = pGameDLL + 0x0BD960
                set pSetCLayoutFrameHeight          = pGameDLL + 0x0BD7C0
                set pSetCLayoutFrameAbsolutePoint   = pGameDLL + 0x0BD830
                set pSetCLayoutFrameCageMouse       = pGameDLL + 0x0BC8D0
                set pSetCLayoutFrameAllPoints       = pGameDLL + 0x0BD750
        elseif PatchVersion == "1.27b" then
                set pGetCLayoutFrameHeight          = pGameDLL + 0x110B50
                set pSetCLayoutFrameScale           = pGameDLL + 0x111540
                set pSetCLayoutFramePoint           = pGameDLL + 0x111600
                set pClearCLayoutFrameAllPoints     = pGameDLL + 0x1108B0
                set pSetCLayoutFrameWidth           = pGameDLL + 0x1116C0
                set pSetCLayoutFrameHeight          = pGameDLL + 0x111520
                set pSetCLayoutFrameAbsolutePoint   = pGameDLL + 0x111590
                set pSetCLayoutFrameCageMouse       = pGameDLL + 0x110630
                set pSetCLayoutFrameAllPoints       = pGameDLL + 0x1114B0
        elseif PatchVersion == "1.28f" then
                set pGetCLayoutFrameHeight          = pGameDLL + 0x13F170
                set pSetCLayoutFrameScale           = pGameDLL + 0x13FB60
                set pSetCLayoutFramePoint           = pGameDLL + 0x13FC20
                set pClearCLayoutFrameAllPoints     = pGameDLL + 0x13EE90
                set pSetCLayoutFrameWidth           = pGameDLL + 0x13FCE0
                set pSetCLayoutFrameHeight          = pGameDLL + 0x13FB40
                set pSetCLayoutFrameAbsolutePoint   = pGameDLL + 0x13FBB0
                set pSetCLayoutFrameCageMouse       = pGameDLL + 0x13EB60
                set pSetCLayoutFrameAllPoints       = pGameDLL + 0x13FAD0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCLayoutFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCLayoutFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
