//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCASpriteMiniAPI
    function GetSpriteMiniX takes integer pSpriteMini returns real
        return GetSpriteBaseX( pSpriteMini )
    endfunction

    function SetSpriteMiniX takes integer pSpriteMini, real x returns nothing
        call SetSpriteBaseX( pSpriteMini, x )
    endfunction

    function GetSpriteMiniY takes integer pSpriteMini returns real
        return GetSpriteBaseY( pSpriteMini )
    endfunction

    function SetSpriteMiniY takes integer pSpriteMini, real y returns nothing
        call SetSpriteBaseY( pSpriteMini, y )
    endfunction

    function GetSpriteMiniZ takes integer pSpriteMini returns real
        return GetSpriteBaseZ( pSpriteMini )
    endfunction

    function SetSpriteMiniZ takes integer pSpriteMini, real z returns nothing
        call SetSpriteBaseZ( pSpriteMini, z )
    endfunction

    function SetSpriteMiniPosition takes integer pSpriteMini, real x, real y, real z returns nothing
        call SetSpriteBasePosition( pSpriteMini, x, y, z )
    endfunction

    function GetSpriteMiniTimeScale takes integer pSpriteMini returns real
        // pSpriteMini->pModelComplex->pAnimationComplex[18] // ((pSpriteMini[8])[38])[18]
        return 0.
    endfunction

    function SetSpriteMiniTimeScale takes integer pSpriteMini, real speed returns nothing
        call SetSpriteBaseTimeScaleEx( pSpriteMini, speed )
    endfunction

    function GetSpriteMiniScale takes integer pSpriteMini returns real
        return GetSpriteBaseScale( pSpriteMini )
    endfunction

    function SetSpriteMiniScale takes integer pSpriteMini, real scale returns nothing
        call SetSpriteBaseScale( pSpriteMini, scale )
    endfunction

    function SetSpriteMiniPositionEx takes integer pSpriteMini, real x, real y, real z returns nothing
        call SetSpriteBasePositionEx( pSpriteMini, x, y, z )
    endfunction

    function SetSpriteMiniScaleEx takes integer pSpriteMini, real scale returns nothing
        call SetSpriteBaseScaleEx( pSpriteMini, scale )
    endfunction

    function SetSpriteMiniColour takes integer pSpriteMini, integer colour, boolean flag returns nothing
        call SetSpriteBaseColourEx( pSpriteMini, colour, flag )
    endfunction

    function SetSpriteMiniAlpha takes integer pSpriteMini, integer alpha, boolean flag returns nothing
        call SetSpriteBaseAlphaEx( pSpriteMini, alpha, flag )
    endfunction

    function SetSpriteMiniAnimationByIndexWithRarity takes integer pSpriteMini, integer index, integer rarity returns nothing
        call SetSpriteBaseAnimationByIndexWithRarity( pSpriteMini, index, rarity )
    endfunction
    
    function SetSpriteMiniAnimationByIndex takes integer pSpriteMini, integer index returns nothing
        call SetSpriteMiniAnimationByIndexWithRarity( pSpriteMini, index, 0 )
    endfunction
    
    // Effect Rotation API Radians
    function GetSpriteMiniYawRad takes integer pSpriteMini returns real // Z | Yaw | returns Degrees!
        return GetSpriteBaseYawRad( pSpriteMini )
    endfunction

    function GetSpriteMiniPitchRad takes integer pSpriteMini returns real // Y | returns Degrees!
        return GetSpriteBasePitchRad( pSpriteMini )
    endfunction

    function GetSpriteMiniRollRad takes integer pSpriteMini returns real // X | returns Degrees!
        return GetSpriteBaseRollRad( pSpriteMini )
    endfunction

    function GetSpriteMiniFacingRad takes integer pSpriteMini returns real // Z | Yaw | returns Degrees!
        return GetSpriteMiniYawRad( pSpriteMini )
    endfunction

    function SetSpriteMiniSpaceRotationRad takes integer pSpriteMini, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseSpaceRotationRad( pSpriteMini, yaw, pitch, roll )
    endfunction

    function SetSpriteMiniYawRad takes integer pSpriteMini, real angle returns nothing // Z Yaw | In Degrees!
        call SetSpriteBaseYawRad( pSpriteMini, angle )
    endfunction

    function SetSpriteMiniPitchRad takes integer pSpriteMini, real angle returns nothing // Y | In Degrees!
        call SetSpriteBasePitchRad( pSpriteMini, angle )
    endfunction

    function SetSpriteMiniRollRad takes integer pSpriteMini, real angle returns nothing // X | In Degrees!
        call SetSpriteBaseRollRad( pSpriteMini, angle )
    endfunction

    function SetSpriteMiniOrientationRad takes integer pSpriteMini, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseOrientationRad( pSpriteMini, yaw, pitch, roll )
    endfunction
    //===================================================================
    
    // Effect Rotation API Degrees
    function SetSpriteMiniSpaceRotation takes integer pSpriteMini, real yaw, real pitch, real roll returns nothing
        call SetSpriteMiniSpaceRotationRad( pSpriteMini, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    
    function GetSpriteMiniYaw takes integer pSpriteMini returns real // Z | Yaw | returns Degrees!
        return Rad2Deg( GetSpriteMiniYawRad( pSpriteMini ) )
    endfunction

    function GetSpriteMiniFacing takes integer pSpriteMini returns real
        return Rad2Deg( GetSpriteMiniFacingRad( pSpriteMini ) )
    endfunction
    
    function GetSpriteMiniPitch takes integer pSpriteMini returns real
        return Rad2Deg( GetSpriteMiniPitchRad( pSpriteMini ) )
    endfunction

    function GetSpriteMiniRoll takes integer pSpriteMini returns real
        return Rad2Deg( GetSpriteMiniRollRad( pSpriteMini ) )
    endfunction

    function SetSpriteMiniYaw takes integer pSpriteMini, real angle returns nothing
        call SetSpriteMiniYawRad( pSpriteMini, Deg2Rad( angle ) )
    endfunction

    function SetSpriteMiniFacing takes integer pSpriteMini, real angle returns nothing
        call SetSpriteMiniYawRad( pSpriteMini, Deg2Rad( angle ) )
    endfunction

    function SetSpriteMiniPitch takes integer pSpriteMini, real angle returns nothing
        call SetSpriteMiniPitchRad( pSpriteMini, Deg2Rad( angle ) )
    endfunction

    function SetSpriteMiniRoll takes integer pSpriteMini, real angle returns nothing
        call SetSpriteMiniRollRad( pSpriteMini, Deg2Rad( angle ) )
    endfunction

    function SetSpriteMiniOrientation takes integer pSpriteMini, real yaw, real pitch, real roll returns nothing
        call SetSpriteMiniOrientationRad( pSpriteMini, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    //===================================================================

    function SetSpriteMiniScaleXYZ takes integer pSpriteMini, real x, real y, real z returns nothing
        call SetSpriteBaseScaleXYZ( pSpriteMini, x, y, z )
    endfunction

    function ResetSpriteMiniMatrix takes integer pSpriteMini returns nothing
        call ResetSpriteBaseMatrix( pSpriteMini )
    endfunction

    function Init_MemHackCSpriteMiniAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ), pGameDLL + 0x966E2C )
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ),  pGameDLL + 0x966F2C )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ), pGameDLL + 0x954CD4 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ),  pGameDLL + 0x954DD4 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ), pGameDLL + 0x9646F4 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ),  pGameDLL + 0x9648D4 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ), pGameDLL + 0xA927BC )
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ),  pGameDLL + 0xA9299C )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ), pGameDLL + 0xA825A4 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ),  pGameDLL + 0xA82784 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSpriteMiniAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteMiniAPI = CreateTrigger(  )
endfunction
//! endnocjass
