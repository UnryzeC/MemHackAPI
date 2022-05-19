//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityNormalAPI
    // jAbility API
    function GetAbilityOrderId takes ability a returns integer
        return GetAddressAbilityOrderId( ConvertHandle( a ) )
    endfunction

    function IsAbilityOnCooldown takes ability a returns boolean
        return IsAddressAbilityOnCooldown( ConvertHandle( a ) )
    endfunction

    function IsAbilitySafe takes ability a returns boolean
        return IsAddressAbilitySafe( ConvertHandle( a ) )
    endfunction

    function IsAbilityUsable takes ability a returns boolean
        return IsAddressAbilityUsable( ConvertHandle( a ) )
    endfunction

    function GetAbilityCastpoint takes ability a returns real
        return GetAddressAbilityCastpoint( ConvertHandle( a ) )
    endfunction

    function SetAbilityCastpoint takes ability a, real dur returns nothing
        call SetAddressAbilityCastpoint( ConvertHandle( a ), dur )
    endfunction

    function GetAbilityBackswing takes ability a returns real
        return GetAddressAbilityBackswing( ConvertHandle( a ) )
    endfunction

    function SetAbilityBackswing takes ability a, real dur returns nothing
        call SetAddressAbilityBackswing( ConvertHandle( a ), dur )
    endfunction

    function GetAbilityManaCost takes ability a, integer level returns integer
        return GetAddressAbilityManaCost( ConvertHandle( a ), level )
    endfunction

    function SetAbilityManaCost takes ability a, integer level, integer mc returns nothing
        call SetAddressAbilityManaCost( ConvertHandle( a ), level, mc )
    endfunction

    function GetAbilityCooldownStamp takes ability a returns real
        //This actually returns the timestamp, not the cooldown. To get the real cooldown you need to subtract this from the current game time.
        return GetAddressAbilityCooldownStamp( ConvertHandle( a ) )
    endfunction

    function GetAbilityCurrentCooldown takes ability a returns real
        //This value holds the base cooldown of the ability at the last time it was casted. It’s used to calculate the % of elapsed cooldown.
        //This is completely irrelevant for the gameplay, it’s used only to determine which frame of the cooldown model will be displayed.
        return GetAddressAbilityCurrentCooldown( ConvertHandle( a ) )
    endfunction

    function SetAbilityCooldown takes ability a, real seconds, string mode returns nothing
        call SetAddressAbilityCooldown( ConvertHandle( a ), seconds, mode )
    endfunction

    function AddAbilityCooldown takes ability a, real seconds returns nothing
        call SetAbilityCooldown( a, seconds, "+" )
    endfunction

    function ReduceAbilityCooldown takes ability a, real seconds returns nothing
        call SetAbilityCooldown( a, seconds, "-" )
    endfunction

    function ResetAbilityCooldown takes ability a returns nothing
        call SetAbilityCooldown( a, -1., "" )
    endfunction

    function StartAbilityCooldown takes ability a, real cd returns nothing
        call StartAddressAbilityCooldown( ConvertHandle( a ), cd )
    endfunction

    function GetAbilityCastTime takes ability a returns real
        return GetAddressAbilityCastTime( ConvertHandle( a ) )
    endfunction

    function SetAbilityCastTime takes ability a, real r returns nothing
        call SetAddressAbilityCastTime( ConvertHandle( a ), r )
    endfunction

    function SetAbilityDisabled takes ability a, integer count returns nothing
        // not safe unless used with PauseUnit. Button will be blacked, but current casts of that ability won’t be interrupted.
        call SetAddressAbilityDisabled( ConvertHandle( a ), count )
    endfunction

    function GetAbilityDisabled takes ability a returns integer
        return GetAddressAbilityDisabled( ConvertHandle( a ) )
    endfunction

    function SetAbilityHidden takes ability a, integer count returns nothing
        // This one is 100% safe. This hides the ability button, and order can’t be issued.
        call SetAddressAbilityHidden( ConvertHandle( a ), count ) // -1 = unhide | 1 = hide
    endfunction

    function AddAbilityHidden takes ability a, integer count returns nothing
        call AddAddressAbilityHidden( ConvertHandle( a ), count )
    endfunction

    function GetAbilityDisabledEx takes ability a returns integer
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        return GetAddressAbilityDisabledEx( ConvertHandle( a ) )
    endfunction

    function SetAbilityDisabledEx takes ability a, integer count returns nothing
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        call SetAddressAbilityDisabledEx( ConvertHandle( a ), count ) // -1 = unhide | 1 = hide
    endfunction

    function SilenceAbility takes ability a returns nothing
        call SilenceAddressAbility( ConvertHandle( a ) )
    endfunction

    function UnsilenceAbility takes ability a returns nothing
        call UnsilenceAddressAbility( ConvertHandle( a ) )
    endfunction

    function ShowAbility takes ability a, boolean flag returns nothing
        call ShowAddressAbility( ConvertHandle( a ), flag )
    endfunction
    //===========================================

    // Buff API
    function GetBuffLevel takes buff b returns integer
        return GetAddressBuffLevel( ConvertHandle( b ) )
    endfunction
    //===========================================

    function Init_MemHackAbilityNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackAbilityNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackAbilityNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass
