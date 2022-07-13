//TESH.scrollpos=58
//TESH.alwaysfold=0
//! nocjass
library SystemDebug
    globals
        group gTemp = null
        unit uTemp = null
        effect eTemp = null
        item itTemp = null
        integer iTemp = 0
        trigger tTemp = null
        //hashtable htTemp = InitHashtable( )
        
        boolean testout = true
    endglobals
endlibrary

library ZzATestCode
function PrintMemHackData takes nothing returns nothing
    call BJDebugMsg( "pGameDLL: " + IntToHex( pGameDLL ) )
    call BJDebugMsg( "iGameVersion: " + IntToHex( iGameVersion ) )
    call BJDebugMsg( "pJassEnvAddress: "  + IntToHex( pJassEnvAddress ) )
    call BJDebugMsg( "pJassVmAddress: "  + IntToHex( GetJassVM( 1 ) ) )
    call BJDebugMsg( "pJassHandleTable: "  + IntToHex( GetJassTable( ) ) )
endfunction

function SomeFunction takes nothing returns nothing
    
endfunction

function TestBenchmarking takes nothing returns nothing
    local integer p     = 0
    local integer i     = 0
    local integer j     = 0
    local real r        = 0.
    local integer time1 = 0
    local integer time2 = 0
    local integer sum = 0

    set i    = 0
    set time1 = GetLocalTime( 0 )
    
    
    
    loop
        exitwhen i == 10000
        // Some stuff here

        set i = i + 1
    endloop
    set time1  = GetLocalTime( 0 ) - time1

    set i    = 0
    set time2 = GetLocalTime( 0 )
    loop
        exitwhen i == 10000
        // Some other stuff here

        set i = i + 1
    endloop
    set time2  = GetLocalTime( 0 ) - time2

    if time1 < 0 then
        set time1 = 1000 + time1
    endif

    if time2 < 0 then
        set time2 = 1000 + time2
    endif

    call BJDebugMsg( "First Delay: " + I2S( time1 ) + "ms" )
    call BJDebugMsg( "Second Delay: " + I2S( time2 ) + "ms" )
    
    set eTemp = AddSpecialEffect( "Units\\Human\\Footman\\Footman.mdx", 0., 0. )
    
    call SetEffectPosition( eTemp, 1500., 100., 100. )
    //call fast_call_3( pGameDLL + 0x4D3200, GetObjectSprite( ConvertHandle( eTemp ) ), 0xFFFF, 0 )
    call BJDebugMsg( "eTemp: " + IntToHex( ConvertHandle( eTemp ) ) + " pos-> " + R2S( GetEffectX( eTemp ) ) + " | " + R2S( GetEffectY( eTemp ) ) + " | " + R2S( GetEffectZ( eTemp ) ) )
endfunction

function Init_TestCode takes nothing returns nothing
    local integer i = 0
    local integer mem = 0

    call BJDebugMsg( "IsOPLimitRemoved = " + B2S( IsOPLimitRemoved( ) ) )
    call EnableOPLimit( false ) // This removes operation limit, hence allowing us to use benchmark method above.
    // Since it has over 20000 complex operations, we need to remove limit to complete benchmark without exiting the thread until it fully completes.
    //call LoadTOCFile( "UI\\Data\\List.toc" ) // not needed for code testing, you can however load your own TOCs.
    call BJDebugMsg( "IsOPLimitRemoved = " + B2S( IsOPLimitRemoved( ) ) )
    
    
    
    if true then
        set uTemp = CreateUnit( Player( 0 ), 'H000', 0., 0., 270. )
        call SetUnitMaxLife( uTemp, 99999. )
        call SetUnitLifeRegen( uTemp, 9999. )
        call SetUnitMaxMana( uTemp, 99999. )
        call SetUnitManaRegen( uTemp, 9999. )
        call SetUnitAttackSpeed( uTemp, 6. )
        call SetUnitBaseDamage( uTemp, 10000 )
        //call SetUnitScale( uTemp, .8, .8, .8 )

        //call UnitAddAbility( uTemp, 'AIsr' )
        //call UnitAddAbility( uTemp, 'Aroc' )
        //call BJDebugMsg( "'Aroc' = " + IntToHex( GetUnitAbility( uTemp, 'Aroc' ) ) )

        //call UnitAddAbility( uTemp, 'A000' )
        //call SetAbilityBaseHotkeyIdById( 'A000', 'K' )
        //call BJDebugMsg( "'K' hotkey == A000 hotkey: " + I2S( GetAbilityBaseHotkeyIdById( 'A000' ) ) )
        //call UnitAddAbility( uTemp, 'A001' )
        //call UnitAddAbility( uTemp, 'A002' )
    endif

    //call UnitAddAbility( uTemp, 'A003' )
    
    //call UnitAddAbility( uTemp, 'AOsh' )
    //call UnitAddAbility( uTemp, 'AOws' )
    //call UnitAddAbility( uTemp, 'AUcs' )
    //call UnitAddAbility( uTemp, 'AHbz' )
    
    call TimerStart( GetExpiredTimer( ), .1, false, function TestBenchmarking )
    //call TimerStart( CreateTimer( ), .0, true, function TestTimerSpeed )
endfunction

//===========================================================================
function InitTrig_Testing takes nothing returns nothing
    //set gg_trg_Testing = CreateTrigger(  )
    call PanCameraToTimed( 0., 0., 0. )
    call FogEnable( false )
    call FogMaskEnable( false )
    call TimerStart( CreateTimer( ), .1, false, function Init_TestCode )
endfunction

endlibrary
//! endnocjass
