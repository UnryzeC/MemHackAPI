//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleFrameAPI
    function AllocCSimpleFrame takes nothing returns integer
        return StormAllocateMemory( 0x124, "MemHackCSimpleFrame", 4, 0 )
    endfunction

    function CreateCSimpleFrame takes integer pParent returns integer
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ) )
        local integer baseobj = 0

        if addr != 0 then
            set baseobj = AllocCSimpleFrame( )

            if baseobj != 0 then
                return this_call_2( addr, baseobj, pParent )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFrameByName takes string name, integer id returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ) )

        if addr != 0 and name != "" then
            return fast_call_2( addr, GetStringAddress( name ), id )
        endif

        return 0
    endfunction

    function SetCSimpleFrameScale takes integer pCSimpleFrame, real scale returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ) )
        local integer fid  = 0

        if addr != 0 and pCSimpleFrame != 0 then
            set fid = GetFrameType( pCSimpleFrame )

            if fid == 22 or fid == 23 or fid == 39 then
                return this_call_2( addr, pCSimpleFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFramePriority takes integer pCSimpleFrame, integer priority returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ) )
        local integer fid  = 0

        if addr != 0 and pCSimpleFrame != 0 then
            set fid = GetFrameType( pCSimpleFrame )

            if fid != 0 then
                if IsFrameLayout( pCSimpleFrame ) then
                    return this_call_2( addr, pCSimpleFrame, priority )
                else
                    call WriteRealMemory( pCSimpleFrame + 0xA8, priority ) // if 1.29+ then 0xB0
                    return 1
                endif
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFrameParent takes integer pCSimpleFrame, integer pParentCSimpleFrame returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ) )

        if addr != 0 and pCSimpleFrame != 0 and pParentCSimpleFrame != 0 then
            if IsFrameLayout( pCSimpleFrame ) and IsFrameLayout( pParentCSimpleFrame ) then
                return this_call_2( addr, pCSimpleFrame, pParentCSimpleFrame  )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ),      pGameDLL + 0x60A410 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ),   pGameDLL + 0x61CF10 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ),    pGameDLL + 0x60A1C0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ), pGameDLL + 0x2F64F0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ),   pGameDLL + 0x60A120 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ),      pGameDLL + 0x609C70 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ),   pGameDLL + 0x61C770 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ),    pGameDLL + 0x609A20 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ), pGameDLL + 0x2F59B0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ),   pGameDLL + 0x609980 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ),      pGameDLL + 0x0B8C00 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ),   pGameDLL + 0x0C8FD0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ),    pGameDLL + 0x0B9FA0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ), pGameDLL + 0x356430 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ),   pGameDLL + 0x0BA040 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ),      pGameDLL + 0x10C960 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ),   pGameDLL + 0x11CD30 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ),    pGameDLL + 0x10DD00 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ), pGameDLL + 0x373BD0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ),   pGameDLL + 0x10DDA0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "Create" ),      pGameDLL + 0x13AE90 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "GetByName" ),   pGameDLL + 0x14B3E0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetScale" ),    pGameDLL + 0x13C230 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetPriority" ), pGameDLL + 0x3A7CA0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleFrame" ), StringHash( "SetParent" ),   pGameDLL + 0x13C2D0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
