//TESH.scrollpos=59
//TESH.alwaysfold=0
//! nocjass
library SystemDebug
    globals
        unit uTemp = null
        effect eTemp = null
        integer iTemp = 0

        boolean testout = true
    endglobals
endlibrary

library ZzATestCode

function TestBenchmarking takes nothing returns nothing
    local integer p     = 0
    local integer i     = 0
    local integer time  = 0

    set i    = 0
    set time = GetLocalTime( 0 )
    loop
        exitwhen i == 10000
        // Some stuff here
        
        set i = i + 1
    endloop
    set time  = GetLocalTime( 0 ) - time
    call BJDebugMsg( "First Delay: " + I2S( time ) + "ms" )

    set i    = 0
    set time = GetLocalTime( 0 )
    loop
        exitwhen i == 10000
        // Some other stuff here
        
        set i = i + 1
    endloop
    set time  = GetLocalTime( 0 ) - time
    call BJDebugMsg( "Second Delay: " + I2S( time ) + "ms" )
    
    call SetCustomUnitAbilityCharges( uTemp, 'AOsh', 2 )
endfunction

function PrintMemHackData takes nothing returns nothing
    call BJDebugMsg( "pGameDLL: " + IntToHex( pGameDLL ) )
    call BJDebugMsg( "iGameVersion: " + IntToHex( iGameVersion ) )
    call BJDebugMsg( "pJassEnvAddress: "  + IntToHex( pJassEnvAddress ) )
    call BJDebugMsg( "pJassVmAddress: "  + IntToHex( GetJassVM( 1 ) ) )
    call BJDebugMsg( "pJassHandleTable: "  + IntToHex( GetJassTable( ) ) )
endfunction

function TestTimerSpeed takes nothing returns nothing
    set iTemp = iTemp + 1
    
    if iTemp == 100 then
        call PauseTimer( GetExpiredTimer( ) )
        call BJDebugMsg( "iTemp = " + I2S( iTemp ) )
        call BJDebugMsg( "Elapsed = " + R2S( TimerGetElapsed( GetExpiredTimer( ) ) ) )
    endif
endfunction

function Init_TestCode takes nothing returns nothing
    local integer i = 1
    call EnableOPLimit( false ) // This removes operation limit, hence allowing us to use benchmark method above.
    // Since it has over 20000 complex operations, we need to remove limit to complete benchmark without exiting the thread until it fully completes.
    //call LoadTOCFile( "UI\\Data\\List.toc" ) // not needed for code testing, you can however load your own TOCs.

    set uTemp = CreateUnit( Player( 0 ), 'H000', 600., -200., 270 )
    call SetUnitMaxLife( uTemp, 99999. )
    call SetUnitLifeRegen( uTemp, 9999. )
    call SetUnitMaxMana( uTemp, 99999. )
    call SetUnitManaRegen( uTemp, 9999. )
    call UnitAddAbility( uTemp, 'AOsh' )
    call SetUnitAbilityLevel( uTemp, 'AOsh', 2 )

    call UnitAddAbility( uTemp, 'A000' )
    call UnitAddAbility( uTemp, 'A001' )
    //call UnitAddAbility( uTemp, 'A002' )
    call UnitAddAbility( uTemp, 'A003' )
    call UnitAddAbility( uTemp, 'AOws' )
    call UnitAddAbility( uTemp, 'AUcs' )
    call UnitAddAbility( uTemp, 'AHbz' )
    
    call UnitAddItemById( uTemp, 'shas' )
    call UnitAddItemById( uTemp, 'shas' )
    call UnitAddItemById( uTemp, 'shas' )
    call UnitAddItemById( uTemp, 'shas' )
    call UnitAddItemById( uTemp, 'shas' )
    call UnitAddItemById( uTemp, 'shas' )

    call TimerStart( GetExpiredTimer( ), .1, false, function TestBenchmarking )
    call TimerStart( CreateTimer( ), .0, true, function TestTimerSpeed )
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
