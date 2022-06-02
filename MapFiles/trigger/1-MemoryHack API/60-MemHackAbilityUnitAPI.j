//TESH.scrollpos=69
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityUnitAPI
    // CUnit Ability API
    function GetUnitAbilityReal takes integer pUnit, integer aid, integer unk1, integer unk2, integer unk3, integer unk4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ) )

        if addr != 0 and pUnit > 0 and aid > 0 then
            return this_call_6( addr, pUnit, aid, unk1, unk2, unk3, unk4 )
        endif

        return 0
    endfunction

    function CUnitAddAbility takes integer pUnit, integer aid returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ) )

        if addr != 0 and pUnit != 0 and aid != 0 then
            return fast_call_5( addr, pUnit, aid, 0, 0, 0 ) > 0
        endif

        return false
    endfunction

    function CUnitRemoveAbility takes integer pUnit, integer pAbil returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ) )

        if addr != 0 and pUnit != 0 and pAbil != 0 then
            call this_call_2( addr, pUnit, pAbil )
            return true
        endif

        return false
    endfunction

    function CUnitRemoveAbilityById takes integer pUnit, integer aid returns boolean
        local integer pAbil = 0

        if pUnit != 0 and aid != 0 then
            set pAbil = GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 )

            if pAbil != 0 then
                return CUnitRemoveAbility( pUnit, pAbil )
            endif
        endif

        return false
    endfunction
    //===========================================
    
    // jUnit Ability API
    function GetUnitAbilityData takes unit u, integer aid, integer flag returns integer
        local integer pUnit

        if u != null and aid > 0 then
            set pUnit = ConvertHandle( u )

            if pUnit > 0 then
                return GetUnitAbilityReal( pUnit, aid, 0, flag, 1, 1 )
            endif
        endif

        return 0
    endfunction

    function GetUnitAbility takes unit u, integer aid returns integer
        if GetUnitAbilityLevel( u, aid ) > 0 then
            return GetUnitAbilityData( u, aid, 1 )
        endif

        return 0
    endfunction

    function GetUnitAbilityByIndex takes unit u, integer index returns ability
        local integer pData = ConvertHandle( u )
        local integer pAbil = 0
        local integer i = 0

        if pData != 0 then
            set pAbil = GetCAgentFromHashGroup( pData + 0x1DC )

            if pAbil != 0 then
                loop
                    exitwhen pAbil == 0 or i == index
                    set pAbil = GetCAgentFromHashGroup( pAbil + 0x24 )
                    set i = i + 1
                endloop

                if pAbil != 0 then
                    return ObjectToAbility( pAbil )
                endif
            endif
        endif

        return null
    endfunction

    function GetUnitJAbility takes unit u, integer aid returns ability
        return ObjectToAbility( GetUnitAbility( u, aid ) )
    endfunction

    function AddUnitAbility takes unit u, integer aid returns boolean
        return CUnitAddAbility( ConvertHandle( u ), aid )
    endfunction

    function RemoveUnitAbility takes unit u, integer aid, boolean removeduplicates returns nothing
        call CUnitRemoveAbility( ConvertHandle( u ), aid )
    endfunction

    function GetUnitAbilityBase takes unit u, integer aid returns integer
        return GetUnitAbilityData( u, aid, 0 )
    endfunction

    function GetUnitAbilityOrderId takes unit u, integer aid returns integer
        return GetAddressAbilityOrderId( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilityOnCooldown takes unit u, integer aid returns boolean
        return IsAddressAbilityOnCooldown( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilitySafe takes unit u, integer aid returns boolean
        return IsAddressAbilitySafe( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilityUsable takes unit u, integer aid returns boolean
        return IsAddressAbilityUsable( GetUnitAbility( u, aid ) )
    endfunction

    function GetUnitAbilityCastpoint takes unit u, integer aid returns real
        return GetAddressAbilityCastpoint( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCastpoint takes unit u, integer aid, real dur returns nothing
        call SetAddressAbilityCastpoint( GetUnitAbility( u, aid ), dur )
    endfunction

    function GetUnitAbilityBackswing takes unit u, integer aid returns real
        return GetAddressAbilityBackswing( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityBackswing takes unit u, integer aid, real dur returns nothing
        call SetAddressAbilityBackswing( GetUnitAbility( u, aid ), dur )
    endfunction

    function GetUnitAbilityManaCost takes unit u, integer aid, integer level returns integer
        return GetAddressAbilityManaCost( GetUnitAbility( u, aid ), level )
    endfunction

    function SetUnitAbilityManaCost takes unit u, integer aid, integer level, integer mc returns nothing
        call SetAddressAbilityManaCost( GetUnitAbility( u, aid ), level, mc )
    endfunction

    function GetUnitAbilityCooldownStamp takes unit u, integer aid returns real
        //This actually returns the timestamp, not the cooldown. To get the real cooldown you need to subtract this from the current game time.
        return GetAddressAbilityCooldownStamp( GetUnitAbility( u, aid ) )
    endfunction

    function GetUnitAbilityCurrentCooldown takes unit u, integer aid returns real
        //This value holds the base cooldown of the ability at the last time it was casted. It’s used to calculate the % of elapsed cooldown.
        //This is completely irrelevant for the gameplay, it’s used only to determine which frame of the cooldown model will be displayed.
        return GetAddressAbilityCurrentCooldown( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCooldown takes unit u, integer aid, real seconds, string mode returns nothing
        call SetAddressAbilityCooldown( GetUnitAbility( u, aid ), seconds, mode )
    endfunction

    function AddUnitAbilityCooldown takes unit u, integer aid, real seconds returns nothing
        call SetUnitAbilityCooldown( u, aid, seconds, "+" )
    endfunction

    function ReduceUnitAbilityCooldown takes unit u, integer aid, real seconds returns nothing
        call SetUnitAbilityCooldown( u, aid, seconds, "-" )
    endfunction

    function ResetUnitAbilityCooldown takes unit u, integer aid returns nothing
        call SetUnitAbilityCooldown( u, aid, -1., "" )
    endfunction

    function StartUnitAbilityCooldown takes unit u, integer aid, real cd returns nothing
        call StartAddressAbilityCooldown( GetUnitAbility( u, aid ), cd )
    endfunction

    function GetUnitAbilityCastTime takes unit u, integer aid returns real
        return GetAddressAbilityCastTime( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCastTime takes unit u, integer aid, real r returns nothing
        call SetAddressAbilityCastTime( GetUnitAbility( u, aid ), r )
    endfunction

    function SetUnitAbilityDisabled takes unit u, integer aid, integer count returns nothing
        // not safe unless used with PauseUnit. Button will be blacked, but current casts of that ability won’t be interrupted.
        call SetAddressAbilityDisabled( GetUnitAbility( u, aid ), count )
    endfunction

    function GetUnitAbilityDisabled takes unit u, integer aid returns integer
        return GetAddressAbilityDisabled( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityHidden takes unit u, integer aid, integer count returns nothing
        // This one is 100% safe. This hides the ability button, and order can’t be issued.
        call SetAddressAbilityHidden( GetUnitAbility( u, aid ), count ) // -1 = unhide | 1 = hide
    endfunction

    function AddUnitAbilityHidden takes unit u, integer aid, integer count returns nothing
        call AddAddressAbilityHidden( GetUnitAbility( u, aid ), count )
    endfunction

    function GetUnitAbilityDisabledEx takes unit u, integer aid returns integer
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        return GetAddressAbilityDisabledEx( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityDisabledEx takes unit u, integer aid, integer count returns nothing
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        call SetAddressAbilityDisabledEx( GetUnitAbility( u, aid ), count ) // -1 = unhide | 1 = hide
    endfunction

    function SilenceUnitAbility takes unit u, integer aid returns nothing
        call SilenceAddressAbility( GetUnitAbility( u, aid ) )
    endfunction

    function UnsilenceUnitAbility takes unit u, integer aid returns nothing
        call UnsilenceAddressAbility( GetUnitAbility( u, aid ) )
    endfunction

    function ShowUnitAbility takes unit u, integer aid, boolean flag returns nothing
        call ShowAddressAbility( GetUnitAbility( u, aid ), flag )
    endfunction
    //===========================================

    // Buff API
    function GetUnitBuffLevel takes unit u, integer bid returns integer
        return GetAddressBuffLevel( GetUnitAbility( u, bid ) )
    endfunction
    //===========================================
    
    function Init_MemHackAbilityUnitAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x079400 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x24D900 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x07A8F0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x0787D0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x24CDF0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x079CC0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x46F440 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x454EB0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x471160 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x48CB80 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x4725F0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x48E8A0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x4C0C90 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x4A6700 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x4C29B0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackAbilityUnitAPI takes nothing returns nothing
    //set gg_trg_MemHackAbilityUnitAPI = CreateTrigger(  )
endfunction
//! endnocjass
