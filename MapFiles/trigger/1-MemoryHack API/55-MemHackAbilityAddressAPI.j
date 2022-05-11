//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityAddressAPI
    // CAbility API
    function GetAbilityBaseDataByAddress takes integer pAbil returns integer
        if pAbil > 0 then
            return ReadRealMemory( pAbil + 0x54 )
        endif

        return 0
    endfunction

    function GetAddressAbilityTypeId takes integer pAbil returns integer
        local integer base = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 then
                return ReadRealMemory( base + 0x34 )
            endif
        endif

        return 0
    endfunction
    
    function GetAddressAbilityBaseId takes integer pAbil returns integer
        local integer base = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 and ReadRealMemory( pAbil + 0x6C ) > 0 then
                return ReadRealMemory( base + 0x30 )
            endif
        endif

        return 0
    endfunction

    function GetAddressAbilityOrderId takes integer pAbil returns integer
        local integer pOffset2 = 0
        local integer base     = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 then
                set base = ReadRealMemory( base + 0x30 )

                if base > 0 then
                    if base == 'ANcl' then
                        return ReadRealMemory( pAbil + 0x124 )
                    else
                        return c_call_1( ReadRealMemory( ReadRealMemory( pAbil ) + 0x308 ), 0 )
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function IsAddressAbilityOnCooldown takes integer pAbil returns boolean
        if pAbil > 0 then
            return IsFlagBitSet( ReadRealMemory( pAbil + 0x20 ), 512 )
        endif

        return false
    endfunction
    
    function IsAddressAbilitySafe takes integer pAbil returns boolean
        local integer base  = GetAddressAbilityBaseId( pAbil )
        local integer order = 0

        if base > 0 then
            if base == 'ANcl' then
                set order = ReadRealMemory( pAbil + 0x124 )
            else
                set order = GetAddressAbilityOrderId( pAbil )
            endif

            if base == 'AOre' or base == 'Aexh' then
                return true
            endif

            return order > 0 and base != 'ANeg'
        endif

        return false
    endfunction

    function IsAddressAbilityUsable takes integer pAbil returns boolean // Always false for ANcl
        if pAbil > 0 then
            return this_call_1( ReadRealMemory( ReadRealMemory( pAbil ) + 0x1D8 ), pAbil ) == 1 or ( ReadRealMemory( pAbil + 0x6C ) != 0 and GetAddressAbilityBaseId( pAbil ) == 'ANcl' ) 
        endif

        return false
    endfunction

    function GetAddressAbilityCastTime takes integer pAbil returns real
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0x84 )

            if pAbil > 0 then
                return GetRealFromMemory( ReadRealMemory( pAbil ) )
            endif
        endif

        return 0.
    endfunction

    function SetAddressAbilityCastTime takes integer pAbil, real r returns nothing
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0x84 )

            if pAbil > 0 then
                call WriteRealMemory( pAbil, SetRealIntoMemory( r ) )
            endif
        endif
    endfunction
    
    function GetAddressAbilityCastpoint takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0x8C ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityCastpoint takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x8C, SetRealIntoMemory( dur ) )
        endif
    endfunction

    function GetAddressAbilityBackswing takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0x94 ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityBackswing takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x94, SetRealIntoMemory( dur ) )
        endif
    endfunction

    function GetAddressAbilityDefaultCooldown takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0xB4 ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityDefaultCooldown takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0xB4, SetRealIntoMemory( dur ) )
        endif
    endfunction
    
    function GetAddressAbilityManaCost takes integer pAbil, integer level returns integer
        if pAbil > 0 then
            set pAbil = GetAbilityBaseDataByAddress( pAbil )

            if pAbil > 0 then
                return ReadRealMemory( pAbil + level * 0x68 )
            endif
        endif

        return 0
    endfunction
    
    function SetAddressAbilityManaCost takes integer pAbil, integer level, integer mc returns nothing
        if pAbil > 0 then
            set pAbil = GetAbilityBaseDataByAddress( pAbil )

            if pAbil > 0 then
                call WriteRealMemory( pAbil + level * 0x68, mc )
            endif
        endif
    endfunction

    function GetAddressAbilityCooldownStamp takes integer pAbil returns real
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )
            
            if pAbil > 0 then
                return GetRealFromMemory( ReadRealMemory( pAbil + 0x4 ) )
            endif
        endif

        return 0.
    endfunction
    
    function GetAddressAbilityCurrentCooldown takes integer pAbil returns real
        local real cd = 0.

        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )

            if pAbil > 0 then
                set cd    = GetRealFromMemory( ReadRealMemory( pAbil + 0x4 ) )
                set pAbil = ReadRealMemory( pAbil + 0xC )

                if pAbil > 0 then
                    set pAbil = ReadRealMemory( pAbil + 0x40 )
                    
                    if pAbil > 0 then
                        return cd - GetRealFromMemory( pAbil )
                    endif
                endif
            endif
        endif

        return .0
    endfunction
    
    function SetAddressAbilityCooldown takes integer pAbil, real seconds, string mode returns nothing
        local real cd = 0.

        if pAbil != 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )
 
            if pAbil != 0 then
                set cd = ReadRealFloat( pAbil + 0x4 )

                if mode == "+" then
                    set seconds = cd + seconds
            elseif mode == "-" then
                    set seconds = cd - seconds
                endif

                call WriteRealMemory( pAbil + 0x4, SetRealIntoMemory( seconds ) )
            endif
        endif
    endfunction
    
    function StartAddressAbilityCooldown takes integer pAbil, real cd returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and pAbil != 0 and arg != 0 and IsAddressAbilitySafe( pAbil ) then
            call WriteRealFloat( arg + 0x0, cd )
            call this_call_2( addr, pAbil, arg + 0x0 )
            return IsAddressAbilityOnCooldown( pAbil )
        endif

        return false
    endfunction

    function SetAddressAbilityDisabled takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x3C, count )
        endif
    endfunction

    function GetAddressAbilityDisabled takes integer pAbil returns integer
        return ReadRealMemory( pAbil + 0x3C )
    endfunction

    function SetAddressAbilityHidden takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x40, count )
        endif
    endfunction

    function AddAddressAbilityHidden takes integer pAbil, integer d returns nothing
        call WriteRealMemory( pAbil + 0x40, ReadRealMemory( pAbil + 0x40 ) + d )
    endfunction

    function GetAddressAbilityDisabledEx takes integer pAbil returns integer
        if pAbil > 0 then
            return ReadRealMemory( pAbil + 0x44 ) 
        endif
        
        return 0
    endfunction

    function SetAddressAbilityDisabledEx takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x44, count )
        endif
    endfunction

    function ShowAddressAbility takes integer pAbil, boolean flag returns nothing
        if pAbil > 0 then
            if ReadRealMemory( pAbil ) > 0 then
                call WriteRealMemory( pAbil + 0x40, B2I( not flag ) )
            endif
        endif
    endfunction

    function SilenceAddressAbility takes integer pAbil returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ) )

        if addr != 0 and pAbil != 0 then
            call this_call_3( addr, pAbil, 0, 1 )
        endif
    endfunction

    function UnsilenceAddressAbility takes integer pAbil returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ) )

        if addr != 0 and pAbil != 0 then
            call this_call_3( addr, pAbil, 0, 1 )
        endif
    endfunction
    //===========================================

    // Buff API
    function GetAddressBuffLevel takes integer pBuff returns integer
        if pBuff > 0 then
            return ReadRealMemory( pBuff + 0xB0 ) + 1
        endif

        return -1 // Ensure we failed
    endfunction
    //===========================================

    function Init_MemHackAbilityAddressAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x0518B0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x0538A0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x053900 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x050B70 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x052B60 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x052BC0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x418D20 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x3E9FA0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x3EE3C0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x436460 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x4076E0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x40BB00 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x46A570 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x43B7C0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x43FBE0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackAbilityAddressAPI takes nothing returns nothing
    //set gg_trg_MemHackAbilityAddressAPI = CreateTrigger(  )
endfunction
//! endnocjass
