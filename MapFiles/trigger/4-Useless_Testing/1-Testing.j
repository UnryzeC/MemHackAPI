//TESH.scrollpos=73
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

function TestBenchmarking takes nothing returns nothing
    local integer p     = 0
    local integer i     = 0
    local integer j     = 0
    local real r        = 0.
    local integer time1 = 0
    local integer time2 = 0

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

    call BJDebugMsg( "First Delay: " + I2S( time1 ) + "ms" )
    call BJDebugMsg( "Second Delay: " + I2S( time2 ) + "ms" )
    
    call ClickFrame( GetCommandBarButton( 0 ) )
endfunction

function debilizm takes nothing returns nothing
    call CreateUnit( Player( 0 ), 'hpea', 0., 0., 0. )
endfunction

function TestCondition takes nothing returns boolean
    return true
endfunction

function TestConditionFalse takes nothing returns boolean
    return false
endfunction

function Init_TestCode takes nothing returns nothing
    local integer i = 0
    local integer mem = 0

    call EnableOPLimit( false ) // This removes operation limit, hence allowing us to use benchmark method above.
    // Since it has over 20000 complex operations, we need to remove limit to complete benchmark without exiting the thread until it fully completes.
    //call LoadTOCFile( "UI\\Data\\List.toc" ) // not needed for code testing, you can however load your own TOCs.

    if true then
        set uTemp = CreateUnit( Player( 0 ), 'H000', 600., -200., 270 )
        call SetUnitMaxLife( uTemp, 99999. )
        call SetUnitLifeRegen( uTemp, 9999. )
        call SetUnitMaxMana( uTemp, 99999. )
        call SetUnitManaRegen( uTemp, 9999. )
        call SetUnitAttackSpeed( uTemp, 6. )
        call SetUnitBaseDamage( uTemp, 10000 )
        
        call UnitAddAbility( uTemp, 'AIsr' )

        call UnitAddAbility( uTemp, 'A000' )
        call UnitAddAbility( uTemp, 'A001' )
        call UnitAddAbility( uTemp, 'A002' )
    endif

    call SelectUnit( uTemp, true )
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
