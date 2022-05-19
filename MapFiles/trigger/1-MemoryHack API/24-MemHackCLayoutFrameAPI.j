//TESH.scrollpos=9
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCLayoutFrameAPI
    function SetCLayoutFrameAbsolutePoint takes integer pFrame, integer point, real offsetX, real offsetY returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameLayout( pFrame )

            if fid != 0 then
                return this_call_5( addr, pFrame, point, SetRealIntoMemory( offsetX ), SetRealIntoMemory( offsetY ), 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameCageMouse takes integer pFrame, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CageMouse" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid != 0 then
                return this_call_2( addr, pFrame, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function ClearCLayoutFrameAllPoints takes integer pFrame returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ) )

        if addr != 0 and pFrame != 0 then
            set pFrame = GetFrameLayout( pFrame )

            if pFrame != 0 then
                return this_call_2( addr, pFrame, 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameWidth takes integer pFrame, real width returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid != 0 then
                set pFrame = GetFrameLayout( pFrame )
                return this_call_2( addr, pFrame, SetRealIntoMemory( width ) )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameHeight takes integer pFrame, real height returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid != 0 then
                set pFrame = GetFrameLayout( pFrame )
                return this_call_2( addr, pFrame, SetRealIntoMemory( height ) )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameAllPoints takes integer pFrame, integer relativeframe returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ) )

        if addr != 0 and pFrame != 0 then
            set pFrame = GetFrameLayout( pFrame )

            if pFrame != 0 and GetFrameLayout( relativeframe ) > 0 then
                return this_call_3( addr, pFrame, relativeframe, 1 )
            endif
        endif

        return 0
    endfunction

    function SetCLayoutFrameSize takes integer pFrame, real width, real height returns integer
        if pFrame != 0 and GetFrameLayout( pFrame ) != 0 then
            call SetCLayoutFrameWidth( pFrame, width )
            call SetCLayoutFrameHeight( pFrame, height )
            return 1
        endif

        return 0
    endfunction

    function SetCLayoutFramePoint takes integer pFrame, integer point, integer pParentFrame, integer relativePoint, real x, real y returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ) )

        if addr != 0 and pFrame != 0 and pParentFrame != 0 then
            return B2I( this_call_7( addr, pFrame, point, pParentFrame, relativePoint, SetRealIntoMemory( x ), SetRealIntoMemory( y ), 1 ) > 0 )
        endif

        return 0
    endfunction

    function SetCLayoutFrameScale takes integer pFrame, real scale returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ) )

        if addr != 0 and pFrame != 0 then
            set pFrame = GetFrameLayout( pFrame )

            if pFrame != 0 then
                return this_call_2( addr, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function GetCLayoutFrameHeight takes integer pFrame returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ) )
        local string f_name = ""

        if addr != 0 then
            set f_name = GetFrameTypeName( pFrame )
            
            if f_name != "CModelFrame" and f_name != "CSimpleFontString" and f_name != "CSpriteFrame" and f_name != "CTextFrame" then // 15 | 19 | 25 | 29
                set pFrame = GetFrameLayoutByType( pFrame, GetFrameType( pFrame ) )

                if pFrame != 0 then
                    return GetRealFromMemory( this_call_1( addr, pFrame ) )
                endif
            endif
        endif

        return 0.
    endfunction

    function Init_MemHackCLayoutFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ),        pGameDLL + 0x605740 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ),         pGameDLL + 0x6064E0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ), pGameDLL + 0x606F10 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ),   pGameDLL + 0x606A10 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ),         pGameDLL + 0x606530 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ),        pGameDLL + 0x606550 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ), pGameDLL + 0x606950 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CaseMouse" ),        pGameDLL + 0x605760 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ),     pGameDLL + 0x606F90 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ),        pGameDLL + 0x604FA0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ),         pGameDLL + 0x605D40 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ), pGameDLL + 0x606770 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ),   pGameDLL + 0x606270 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ),         pGameDLL + 0x605D90 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ),        pGameDLL + 0x605DB0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ), pGameDLL + 0x6061B0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CaseMouse" ),        pGameDLL + 0x604FC0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ),     pGameDLL + 0x6067F0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ),        pGameDLL + 0x0BCDF0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ),         pGameDLL + 0x0BD7E0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ), pGameDLL + 0x0BD8A0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ),   pGameDLL + 0x0BCB50 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ),         pGameDLL + 0x0BD960 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ),        pGameDLL + 0x0BD7C0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ), pGameDLL + 0x0BD830 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CaseMouse" ),        pGameDLL + 0x0BC8D0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ),     pGameDLL + 0x0BD750 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ),        pGameDLL + 0x110B50 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ),         pGameDLL + 0x111540 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ), pGameDLL + 0x111600 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ),   pGameDLL + 0x1108B0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ),         pGameDLL + 0x1116C0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ),        pGameDLL + 0x111520 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ), pGameDLL + 0x111590 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CaseMouse" ),        pGameDLL + 0x110630 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ),     pGameDLL + 0x1114B0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "GetHeight" ),        pGameDLL + 0x13F170 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetScale" ),         pGameDLL + 0x13FB60 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetRelativePoint" ), pGameDLL + 0x13FC20 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "ClearAllPoints" ),   pGameDLL + 0x13EE90 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetWidth" ),         pGameDLL + 0x13FCE0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetHeight" ),        pGameDLL + 0x13FB40 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAbsolutePoint" ), pGameDLL + 0x13FBB0 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "CaseMouse" ),        pGameDLL + 0x13EB60 )
                call SaveInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ),     pGameDLL + 0x13FAD0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCLayoutFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCLayoutFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
