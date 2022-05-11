//TESH.scrollpos=67
//TESH.alwaysfold=0
//! nocjass
library TestHookedDamageEvent
    function GetDamageId takes integer dmg_t returns integer
        return log( dmg_t, 2 ) // Gets base 2 logarithm of WeaponType.
    endfunction
    
    function OnUnitDamagedHandlerEx takes integer eventData, unit source, unit target, real dmg returns boolean
        local real init_dmg  = CleanReal( IndexToReal( ReadRealMemory( eventData + 0x04 ) ) )
        local integer phys   = ReadRealMemory( eventData + 0x08 ) // Pointer to parametres or flag saved by damage source, results may vary!
        local integer unk_1  = ReadRealMemory( eventData + 0x0C ) // ??
        local integer pTarg  = ReadRealMemory( eventData + 0x10 ) // Target
        local integer data   = ReadRealMemory( eventData + 0x00 ) // CDamageData
        local integer src_u  = ReadRealMemory( data + 0x00 ) // CUnit source
        local integer wpn_t  = ReadRealMemory( data + 0x04 ) // weapon_type
        local integer flags  = ReadRealMemory( data + 0x0C ) // flags
        local real real_dmg  = CleanReal( IndexToReal( ReadRealMemory( data + 0x10 ) ) ) // damage
        local integer dmg_t  = ReadRealMemory( data + 0x14 ) // Use GetDamageTypeByAddr( dmg_t ) to get Damage Type id.
        local integer atk_t  = ReadRealMemory( data + 0x20 )
        local boolean retval = false // set this value to true, if you handled what you needed in here so OnUnitDamagedHandler will simply end.

        // Attack Types: Spell = 0, Normal = 1, Piercing = 2, Siege = 3, Magic = 4, Chaos = 5, Hero = 6
        // Weapon Types: Melee = 0, Instant = 1, Ranged = 2, ?? = 3, ?? = 4, Splash = 5, Bounce = 6, ?? = 7, ?? = 8
        // 0x4 - DO NOT DEAL DAMAGE (?) | 0x8 - Multishot | 0x10 - Projectile | 0x20 - Penetrates invulnerability
        // 0x40 - DO NOT cause "unit attacked" for the owner (red blinking) (cleave & splash use it!)
        // 0x100 - Melee | 0x101 - Ranged
        // 0x200 - DO NOT cause "unit attacked" for the owner (minimap ping, etc) used in Cyclone (land), hex (end), etc, not sure
        // plain 0x40 == cleave, 0x141 == splash | 0x80 - autocast modifier? | 0x10 - slow aura flag (not a relevant damage? nullify any damage value)
        // Damage Types: ConvertDamageType( i ) = 2 ^ i => ConvertDamageType( 5 ) = 2 ^ 5 = 32 = DAMAGE_TYPE_ENHANCED | Thus reverse is MathLog( 32, 2 ) => 5

        if false then // Miscellaneous Checks
            if flags == 0x10 and phys == ConvertHandle( target ) then // Check WindWalk | Thunderbolt
                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "WindWalk" )
            endif

            if flags == 0x1 and atk_t == 0 and dmg_t == 0x20 and GetUnitAbilityLevel( source, 'NONE' ) > 0 then // Check Fan of Knives based on Id.
                // Change 'NONE' to your Fan of Knives id, to check if damage was caused by it.
            endif
        endif

        if phys == 1 then // Non-Spell Damage || ( IsFlagBitSet( flags, 0x100 ) or IsFlagBitSet( flags, 0x101 ) ) and atk_t != 0
            //call ClearTextMessages( )
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Physical Damage" )
        else
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Magical Damage" )
        endif

        //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Attack Type: " + I2S( atk_t ) + "\n" + "Damage Type: " + I2S( dmg_t ) + "\n" + "Weapon Type: " + I2S( wpn_t ) )
        return retval
    endfunction

    function OnUnitDamagedHandler takes unit source, unit target, real dmg returns nothing
        local integer evntData  = GetDamageEventESPData( )
        local boolean skipBasic = false

        if evntData != 0 then // Check if we had hooked OnDamage data, if not we skip it to not cause a fatal error.
            set skipBasic = OnUnitDamagedHandlerEx( evntData, source, target, dmg )
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "OnUnitDamagedHandlerEx" )
        else
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "OnUnitDamagedHandler" )
        endif

        if not skipBasic then
            // Here you can put anything related to EVENT_UNIT_DAMAGED that does not need MemHack.
            // Edit return value in the function in conditions you set to true, if you wish to skip it reaching this part of the code
            
        endif
    endfunction

    function OnUnitDamagedAction takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger( ) )
        call OnUnitDamagedHandler( GetEventDamageSource( ), GetTriggerUnit( ), GetEventDamage( ) )
        call EnableTrigger( GetTriggeringTrigger( ) )
    endfunction
endlibrary
//===========================================================================
function TestHookedDamageEventEnumUnits takes nothing returns nothing
    local unit u    = null
    local group g   = null
    local trigger t = LoadTriggerHandle( MemHackTable, StringHash( "OnDamage" ), StringHash( "Trigger" ) )

    if t != null then
        set g = CreateGroup( )
        call GroupEnumUnitsInRect( g, GetWorldBounds( ), null )
        loop
            set u = FirstOfGroup( g )
            exitwhen u == null
            call TriggerRegisterUnitEvent( t, u, EVENT_UNIT_DAMAGED )
            call GroupRemoveUnit( g, u )
        endloop

        call DestroyGroup( g )
        set u = null
        set g = null
    endif

    set t = null
endfunction

function InitTrig_TestHookedDamageEvent takes nothing returns nothing
    local trigger t = null

    if LoadTriggerHandle( MemHackTable, StringHash( "OnDamage" ), StringHash( "Trigger" ) ) == null then
        set t = CreateTrigger( )
        call TriggerAddAction( t, function OnUnitDamagedAction )
        call SaveTriggerHandle( MemHackTable, StringHash( "OnDamage" ), StringHash( "Trigger" ), t )
        call TestHookedDamageEventEnumUnits( )
    endif

    set t = null
    //set gg_trg_TestHookedDamageEvent = CreateTrigger(  )
endfunction
//! endnocjass
