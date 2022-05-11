//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleFontAPI
    function AllocCSimpleFont takes nothing returns integer
        return StormAllocateMemory( 0xC4, "MemHackCSimpleFontString", 4, 0 )
    endfunction

    function CreateCSimpleFontEx takes integer pParent, integer arg1, integer arg2 returns integer
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ) )
        local integer baseobj = 0

        if addr != 0 then
            set baseobj = AllocCSimpleFont( )

            if baseobj != 0 then
                return this_call_4( addr, baseobj, pParent, arg1, arg2 )
            endif
        endif

        return 0
    endfunction

    function CreateCSimpleFont takes integer pParent returns integer
        return CreateCSimpleFontEx( pParent, 2, 1 )
    endfunction

    function GetCSimpleFontByName takes string name, integer id returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ) )

        if addr != 0 and name != "" then
            return fast_call_2( addr, GetStringAddress( name ), id )
        endif

        return 0
    endfunction

    function GetCSimpleFontTextByName takes string name, integer id returns string
        local integer pFrame = GetCSimpleFontByName( name, id )

        // GetFrameTextMaxLength = 0x94
        // GetFrameTextLength = 0x98
        if pFrame > 0 then
            return ToJString( ReadRealMemory( pFrame + 0x9C ) )
        endif

        return ""
    endfunction

    function SetCSimpleFontStringScale takes integer pFrame, real scale returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 19 then
                return this_call_2( addr, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFontStringFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 and filename != "" then
            set fid = GetFrameType( pFrame )

            if fid == 19 then
                return this_call_4( addr, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFontStringHeight takes integer pFrame returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 19 then
                return GetRealFromMemory( this_call_1( fid, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function SetCSimpleFontText takes integer pFrame, string text returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 19 then
                return B2I( this_call_2( addr, pFrame, GetStringAddress( text ) ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleFontAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ),    pGameDLL + 0x60DD20 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ), pGameDLL + 0x61CF50 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ),   pGameDLL + 0x60D1B0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ),   pGameDLL + 0x60E1C0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ), pGameDLL + 0x60D710 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ),  pGameDLL + 0x60E470 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ),    pGameDLL + 0x60D580 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ), pGameDLL + 0x61C7B0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ),   pGameDLL + 0x60CA10 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ),   pGameDLL + 0x60DA20 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ), pGameDLL + 0x60CF70 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ),  pGameDLL + 0x60DCD0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ),    pGameDLL + 0x0BFB10 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ), pGameDLL + 0x0C8EF0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ),   pGameDLL + 0x0C1020 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ),   pGameDLL + 0x0C0B40 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ), pGameDLL + 0x0C0490 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ),  pGameDLL + 0x0C0D90 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ),    pGameDLL + 0x113870 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ), pGameDLL + 0x11CC50 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ),   pGameDLL + 0x114D80 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ),   pGameDLL + 0x1148A0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ), pGameDLL + 0x1141F0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ),  pGameDLL + 0x114AF0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "Create" ),    pGameDLL + 0x141F20 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetByName" ), pGameDLL + 0x14B300 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetText" ),   pGameDLL + 0x143430 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetFont" ),   pGameDLL + 0x142F50 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "GetHeight" ), pGameDLL + 0x1428A0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFontString" ), StringHash( "SetScale" ),  pGameDLL + 0x1431A0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleFontAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleFontAPI = CreateTrigger(  )
endfunction
//! endnocjass
