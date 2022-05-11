//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameEditBoxAPI
    function SetCEditBoxFocus takes integer pFrame, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 6 then
                return this_call_2( addr, pFrame, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function SetCEditBoxFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 6 then
                return this_call_4( addr, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function GetCEditBoxText takes integer pFrame returns string
        local integer addr = LoadInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 6 then
                return ToJString( this_call_1( addr, pFrame ) )
            endif
        endif

        return ""
    endfunction

    function SetCEditBoxText takes integer pFrame, string text returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 6 or fid == 36 or fid == 37 then
                return B2I( this_call_3( addr, pFrame, GetStringAddress( text ), 1 ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCEditBoxAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ),  pGameDLL + 0x614640 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ),  pGameDLL + 0x6162F0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ),  pGameDLL + 0x614440 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ), pGameDLL + 0x615920 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ),  pGameDLL + 0x613EA0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ),  pGameDLL + 0x615B50 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ),  pGameDLL + 0x613CA0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ), pGameDLL + 0x615180 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ),  pGameDLL + 0x0AEDF0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ),  pGameDLL + 0x0B0450 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ),  pGameDLL + 0x0B0350 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ), pGameDLL + 0x0B0260 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ),  pGameDLL + 0x102B50 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ),  pGameDLL + 0x1041B0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ),  pGameDLL + 0x1040B0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ), pGameDLL + 0x103FC0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "GetText" ),  pGameDLL + 0x1311C0 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetText" ),  pGameDLL + 0x132820 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFont" ),  pGameDLL + 0x132720 )
                call SaveInteger( MemHackTable, StringHash( "CEditBox" ), StringHash( "SetFocus" ), pGameDLL + 0x132630 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCEditBoxAPI takes nothing returns nothing
    //set gg_trg_MemHackCEditBoxAPI = CreateTrigger(  )
endfunction
//! endnocjass
