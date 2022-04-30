//TESH.scrollpos=109
//TESH.alwaysfold=0
//! nocjass
library SystemDebug
    globals
        integer pTempFrame = 0
        unit uTemp = null
        group gTemp = null
        effect eTemp = null
        item itTemp = null
        destructable desTemp = null

        integer pSimpleFrame = 0
        integer pTexture = 0

        hashtable TestTable = InitHashtable( )
        timer testTimer = CreateTimer( )

        boolean testout = true
        boolean iswhexpause = true
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
    call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "First Delay: " + I2S( time ) + "ms" )

    set i    = 0
    set time = GetLocalTime( 0 )
    loop
        exitwhen i == 10000
        // Some other stuff here

        set i = i + 1
    endloop
    set time  = GetLocalTime( 0 ) - time
    call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Second Delay: " + I2S( time ) + "ms" )
endfunction

function Test_Code_3 takes nothing returns nothing
    //local integer pSimpleFrame = 0 //CreateCSimpleFrame( 0 )
    //local integer pTexture = 0 //CreateCSimpleTexture( pSimpleFrame )
    //local real tempx = GetUnitX( uTemp ) - GetCameraTargetPositionX( )
    //local real tempy = GetUnitY( uTemp ) - GetCameraTargetPositionY( )
    local real tempx = 0.
    local real tempy = 0.

    return
    if pTempFrame == 0 and false then
        set pTempFrame = CreateFrame( "UITextCenter", pGameUI, 20 )
        
        if pTempFrame > 0 then
            call SetFrameSize( pTempFrame, .117, .03 )
            call SetFramePoint( pTempFrame, 1, pGameUI, 1, 0, -.007 )
            call SetFrameText( pTempFrame, "Test Frame :)" )
        endif
    endif
    
    if pTexture == 0 then
        set pSimpleFrame = CreateCSimpleFrame( 0 )
        set pTexture     = CreateCSimpleTexture( pSimpleFrame )
        call SetFrameWidth( pTexture, .05 )
        call SetFrameHeight( pTexture, .02 )
        call SetCSimpleTextureTexture( pTexture, "UI\\Feedback\\HPBarConsole\\human-healthbar-fill.blp", true )
        call FillCSimpleTexture( pTexture, 0xFF00FF00 )
        call BJDebugMsg( "SetFramePoint( pSimpleFrame, ANCHOR_TOP, pGameUI, ANCHOR_TOP, 0., 0. ) = " + I2S( SetFramePoint( pSimpleFrame, ANCHOR_TOP, pGameUI, ANCHOR_TOP, 0., 0. ) ) )
        call BJDebugMsg( "SetFramePoint( pTexture, ANCHOR_TOP, GetUIWorldFrameWar3( ), ANCHOR_TOP, 0., 0. ) = " + I2S( SetFramePoint( pTexture, ANCHOR_TOP, GetUIWorldFrameWar3( ), ANCHOR_TOP, 0., 0. ) ) )
        call BJDebugMsg( "UpdateFrame( pSimpleFrame ) = " + I2S( UpdateFrame( pSimpleFrame ) ) )
    endif

    if pTexture > 0 then
        if GetUnitFramePosition( ConvertHandle( uTemp ) ) then
            set tempx = GetRealFromMemory( ReadRealMemory( pUnitFramePosition ) )
            set tempy = GetRealFromMemory( ReadRealMemory( pUnitFramePosition + 0x4 ) )

            call ClearTextMessages( )
            call BJDebugMsg( "GetUnitFramePositionX = " + R2S( tempx ) )
            call BJDebugMsg( "GetUnitFramePositionY = " + R2S( tempy ) )
            //call SetFrameAbsolutePoint( pTexture, ANCHOR_BOTTOM, SetRealIntoMemory( tempx ), SetRealIntoMemory( tempy ) )
            //call BJDebugMsg( "UpdateFrame( pSimpleFrame ) = " + I2S( UpdateFrame( pSimpleFrame ) ) )
        endif
    endif
endfunction

function Test_Code_2 takes nothing returns nothing
    if testout then
        call BJDebugMsg( "pGameDLL: " + IntToHex( pGameDLL ) )
        call BJDebugMsg( "iGameVersion: " + IntToHex( iGameVersion ) )
        call BJDebugMsg( "pJassEnvAddress: "  + IntToHex( pJassEnvAddress ) )
        call BJDebugMsg( "pJassVmAddress: "  + IntToHex( GetJassVM( 1 ) ) )
        call BJDebugMsg( "pJassHandleTable: "  + IntToHex( GetJassTable( ) ) )
        call BJDebugMsg( "GetStringAddress( Test ): "  + IntToHex( GetStringAddress( "Test" ) ) )
        set testout = false
    endif
endfunction

function Test_Code_1 takes nothing returns nothing
    local integer i = 0
    local integer pPointer = 0
    local integer pTempFrame1 = 0
    
    call EnableOPLimit( false ) // This removes operation limit, hence allowing us to use benchmark method above.
    // Since it has over 20000 complex operations, we need to remove limit to complete benchmark without exiting the thread until it fully completes.
    //call LoadTOCFile( "UI\\Data\\List.toc" )

    //set pTempFrame1 = CreateFrame( "ChatHistoryBackdrop", pGameUI, 20 ) //CreateCBackdropFrame( pGameUI, 20 )
    //call SetFrameSize( pTempFrame1, .14 , .373 )
    //call SetFrameAbsolutePoint( pTempFrame1, 0, 0.11, 0.16 )

    set uTemp = CreateUnit( Player( 0 ), 'H000', 100., 50., 270 )
    //call UnitAddAbility( uTemp, 'AOsh' )
    //call SetUnitAbilityLevel( uTemp, 'AOsh', 2 )
    call UnitAddAbility( uTemp, 'A000' )
    call UnitAddAbility( uTemp, 'A001' )
    //call UnitAddAbility( uTemp, 'A002' )
    call UnitAddAbility( uTemp, 'A003' )
    //call SetUnitMaxLife( uTemp, 9999. )
    set itTemp = CreateItem( 'afac', 20., 30. )
    
    call SetCustomUnitAbilityCharges( uTemp, 'A000', 2 )

    call TimerStart( GetExpiredTimer( ), .1, false, function TestBenchmarking )
    //call BJDebugMsg( "iTemp -> " + GetItemBaseName( itTemp ) )
    //
    return
    //call BJDebugMsg( "GetAbilityBaseUIByIdById( 'AOsh' ) = " + IntToHex( GetAbilityBaseUIById( 'AOsh' ) ) )

    call SetAbilityBaseMissleArtById( 'AOsh', "units\\human\\Peasant\\Peasant.mdl" )
    call SetAbilityBaseIconById( 'AOsh', "ReplaceableTextures\\CommandButtons\\BTNMagicLariet.blp" )
    call SetAbilityBaseTipById( 'AOsh', 1, "Hehe test" )
    call SetAbilityBaseUbertipById( 'AOsh', 1, "Data edited :)" )
    call SetAbilityBaseButtonXById( 'AOsh', 1 )
    call SetAbilityBaseButtonYById( 'AOsh', 1 )
    
    //call BJDebugMsg( "GetAbilityBaseMissleArtById( 'AOsh' ) = " + GetAbilityBaseMissleArtById( 'AOsh' ) )
    //call BJDebugMsg( "GetAbilityBaseIconById( 'AOsh' ) = " + GetAbilityBaseIconById( 'AOsh' ) )

    //call BJDebugMsg( "pAttackTrig = " + IntToHex( ReadRealMemory( ReadRealMemory( ReadRealMemory( ConvertHandle( uTemp ) + 0x1E8 ) ) + 0x2CC ) ) ) // 1.26a = 6F0C6920
    // MissleFunc 1.26a = 6F0CF660 

    //call LoadTOCFile( "uitoc.toc" )

    //call TimerStart( GetExpiredTimer( ), .1, false, function TestBenchmarking )
    //call TimerStart( GetExpiredTimer( ), .01, true, function Test_Code_2 )
endfunction

//===========================================================================
function InitTrig_Testing takes nothing returns nothing
    //set gg_trg_Testing = CreateTrigger(  )
    call PanCameraToTimed( 0., 0., 0. )
    call FogEnable( false )
    call FogMaskEnable( false )
    call TimerStart( CreateTimer( ), .1, false, function Test_Code_1 )
endfunction

endlibrary
//! endnocjass
