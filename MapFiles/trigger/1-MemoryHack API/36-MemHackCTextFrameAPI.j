//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCTextFrameAPI
    function SetCTextFrameTextColour takes integer pFrame, integer colour returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid  = GetFrameType( pFrame )

            if fid == 6 or fid == 29 then
                return this_call_2( addr, pFrame, colour ) // ARGB colour
            endif
        endif

        return 0
    endfunction

    function SetCTextFrameTextColourEx takes integer pFrame, integer alpha, integer red, integer blue, integer green returns integer
        return SetCTextFrameTextColour( pFrame, CreateInteger1( alpha, red, green, blue ) )
    endfunction

    function GetCTextFrameHeight takes integer pFrame returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid  = GetFrameType( pFrame )

            if fid == 29 then
                return GetRealFromMemory( this_call_1( addr, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function SetCTextFrameText takes integer pFrame, string text returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid  = GetFrameType( pFrame )

            if fid == 28 or fid == 33 or fid == 29 or fid == 38 then
                if fid == 28 or fid == 33 then
                    // if 1.29.2+ then 0x1F4
                    set pFrame = ReadRealMemory( pFrame + 0x1E4 )
                endif

                return B2I( this_call_2( addr, pFrame, GetStringAddress( text ) ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCTextFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ),     pGameDLL + 0x612040 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ),       pGameDLL + 0x6124E0 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ), pGameDLL + 0x611D30 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ),     pGameDLL + 0x6118A0 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ),       pGameDLL + 0x611D40 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ), pGameDLL + 0x611590 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ),     pGameDLL + 0x0A9770 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ),       pGameDLL + 0x0AA130 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ), pGameDLL + 0x0AA210 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ),     pGameDLL + 0x0FD4D0 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ),       pGameDLL + 0x0FDE90 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ), pGameDLL + 0x0FDF70 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "GetHeight" ),     pGameDLL + 0x12BB40 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetText" ),       pGameDLL + 0x12C500 )
                call SaveInteger( MemHackTable, StringHash( "CTextFrame" ), StringHash( "SetTextColour" ), pGameDLL + 0x12C5E0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCTextFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCTextFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
