//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleTextureAPI
    function AllocCSimpleTexture takes nothing returns integer
        return StormAllocateMemory( 0xE8, "MemHackCSimpleTexture", 4, 0 )
    endfunction

    function CreateCSimpleTexture takes integer pParent returns integer
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ) )
        local integer baseobj = 0

        if addr != 0 then
            set baseobj = AllocCSimpleTexture( )

            if baseobj > 0 then
                return this_call_4( addr, baseobj, pParent, 2, 1 )
            endif
        endif

        return 0
    endfunction

    function FillCSimpleTexture takes integer pFrame, integer colour returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 and pFrame != 0 then
            call WriteRealMemory( arg + 0x0, colour )
            return B2I( this_call_2( addr, pFrame, arg + 0x0 ) == 0 )
        endif

        return 0
    endfunction

    function GetCSimpleTextureByName takes string name, integer id returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ) )

        if addr != 0 and name != "" then
            return fast_call_2( addr, GetStringAddress( name ), id )
        endif

        return 0
    endfunction

    function SetCSimpleTextureTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )
            if fid == 64 then
                return this_call_3( addr, pFrame, GetStringAddress( texturepath ), B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleTextureAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ),     pGameDLL + 0x60E0A0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ),       pGameDLL + 0x60DB50 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ),  pGameDLL + 0x61CF30 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ), pGameDLL + 0x60E830 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ),     pGameDLL + 0x60D900 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ),       pGameDLL + 0x60D3B0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ),  pGameDLL + 0x61C790 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ), pGameDLL + 0x60E090 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ),     pGameDLL + 0x0C90B0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ),       pGameDLL + 0x324AD0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ),  pGameDLL + 0x0C1170 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ), pGameDLL + 0x0C11E0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ),     pGameDLL + 0x113930 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ),       pGameDLL + 0x342220 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ),  pGameDLL + 0x114ED0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ), pGameDLL + 0x114F40 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Create" ),     pGameDLL + 0x141FE0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "Fill" ),       pGameDLL + 0x3761E0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "GetByName" ),  pGameDLL + 0x143580 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleTexture" ), StringHash( "SetTexture" ), pGameDLL + 0x1435F0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleTextureAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleTextureAPI = CreateTrigger(  )
endfunction
//! endnocjass
