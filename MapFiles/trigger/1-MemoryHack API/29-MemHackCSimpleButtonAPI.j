//TESH.scrollpos=51
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleButtonAPI
    function CreateCSimpleButton takes integer pParent returns integer
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ) )
        local integer baseobj = 0

        if addr != 0 then
            set baseobj = StormAllocateMemory( 0x168, "MemHackCSimpleButton", 14, 0 )

            if baseobj > 0 then
                return this_call_2( addr, baseobj, pParent )
            endif
        endif

        return 0
    endfunction

    function DestroyCSimpleButton takes integer pButton returns boolean
        if pButton > 0 then
            return this_call_2( ReadRealMemory( pButton + 0x8 ), pButton, 1 ) > 0
        endif

        return false
    endfunction
    
    function SetCSimpleButtonStateTexture takes integer pButton, integer state, string texturepath returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ) )

        if addr != 0 and pButton != 0 then
            return this_call_3( addr, pButton, state, GetStringAddress( texturepath ) ) > 0
        endif

        return false
    endfunction

    function SetCSimpleButtonState takes integer pButton, integer state returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ) )

        if addr != 0 and pButton != 0 then
            return this_call_2( addr, pButton, state ) > 0
        endif

        return false
    endfunction

    function ClickCSimpleButton takes integer pButton, integer buttonType returns integer
        // 0x1 = LButton | 0x4 = RButton
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ) )

        if addr != 0 and pButton != 0 then
            return this_call_2( addr, pButton, buttonType )
        endif

        return 0
    endfunction

    function ClickCSimpleButtonEx takes integer pButton, integer buttonType returns boolean
        // 0x1 = LButton | 0x4 = RButton
        local integer oldflag = 0
        local integer retval = 0

        if pButton != 0 then
            set oldflag = ReadRealMemory( pButton + 0x138 )

            if not IsFlagBitSet( oldflag, 0x2 ) then
                call WriteRealMemory( pButton + 0x138, BitwiseXor( oldflag, 0x2 ) )
            endif

            set retval = ClickCSimpleButton( pButton, buttonType )
            call WriteRealMemory( pButton + 0x138, oldflag )
        endif

        return retval != 0
    endfunction
    
    function Init_MemHackCSimpleButtonAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ),          pGameDLL + 0x603880 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ),        pGameDLL + 0x603780 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ), pGameDLL + 0x6039C0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ),           pGameDLL + 0x603BE0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ),          pGameDLL + 0x6030E0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ),        pGameDLL + 0x602FE0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ), pGameDLL + 0x603220 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ),           pGameDLL + 0x603440 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ),          pGameDLL + 0x0BB2A0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ),        pGameDLL + 0x0BB4E0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ), pGameDLL + 0x0BBA40 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ),           pGameDLL + 0x0BB560 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ),          pGameDLL + 0x3A1620 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ),        pGameDLL + 0x10F240 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ), pGameDLL + 0x10F7A0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ),           pGameDLL + 0x10F2C0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Create" ),          pGameDLL + 0x3D5730 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetState" ),        pGameDLL + 0x13D770 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "SetStateTexture" ), pGameDLL + 0x13DCD0 )
                call SaveInteger( MemHackTable, StringHash( "CSimpleButton" ), StringHash( "Click" ),           pGameDLL + 0x13D7F0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleButtonAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleButtonAPI = CreateTrigger(  )
endfunction
//! endnocjass
