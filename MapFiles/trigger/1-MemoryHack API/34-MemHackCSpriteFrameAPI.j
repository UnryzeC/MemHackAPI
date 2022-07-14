//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSpriteFrameAPI
    function SetCSpriteFrameArt takes integer pFrame, string model, integer modeltype, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSpriteFrame" then // 25
                return this_call_4( addr, pFrame, GetStringAddress( model ), modeltype, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function GetCSpriteFrameHeight takes integer pFrame returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSpriteFrame" then // 25
                return GetRealFromMemory( this_call_1( addr, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function SetCSpriteFrameScale takes integer pFrame, real scale returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSpriteFrame" then // 25
                return this_call_2( addr, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSpriteFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ),    pGameDLL + 0x60FB00 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x60F2A0 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ),  pGameDLL + 0x60F600 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ),    pGameDLL + 0x60F360 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x60EB00 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ),  pGameDLL + 0x60EE60 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ),    pGameDLL + 0x0A38C0 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x0A3260 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ),  pGameDLL + 0x0A39A0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ),    pGameDLL + 0x0F7620 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x0F6FC0 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ),  pGameDLL + 0x0F7700 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetArt" ),    pGameDLL + 0x125C90 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x125630 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteFrame" ), StringHash( "SetScale" ),  pGameDLL + 0x125D70 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSpriteFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
