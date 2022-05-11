//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCASpriteUberAPI
    function GetSpriteUberColour takes integer pSpriteUber returns integer
        if pSpriteUber != 0 then
            return ReadRealMemory( pSpriteUber + 0x148 )
        endif

        return 0
    endfunction

    function SetSpriteUberAlpha takes integer pSpriteUber, integer alpha returns nothing
        call SetSpriteBaseAlphaEx( pSpriteUber, alpha, true )
    endfunction    

    function SetSpriteUberColour takes integer pSpriteUber, integer colour returns nothing
        call SetSpriteBaseColourEx( pSpriteUber, colour, true )
    endfunction

    function SetSpriteUberColourEx takes integer pSpriteUber, integer red, integer green, integer blue, integer alpha returns nothing
        if pSpriteUber != 0 then
            call SetSpriteUberColour( pSpriteUber, CreateInteger1( alpha, red, green, blue ) )
        endif
    endfunction

    function SetSpriteUberVertexColour takes integer pSpriteUber, integer red, integer green, integer blue, integer alpha returns nothing
        call SetSpriteUberColourEx( pSpriteUber, red, green, blue, alpha )
        call SetSpriteUberAlpha( pSpriteUber, alpha )
    endfunction

    function GetSpriteUberColourA takes integer pSpriteUber returns integer
        if pSpriteUber != 0 then
            return GetByteFromInteger( GetSpriteUberColour( pSpriteUber ), 1 )
        endif
        
        return -1
    endfunction

    function SetSpriteUberColourA takes integer pSpriteUber, integer alpha returns nothing
        local integer colour = 0

        if pSpriteUber != 0 then
            set colour = GetSpriteUberColour( pSpriteUber )
            call SetSpriteUberColour( pSpriteUber, CreateInteger1( alpha, GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetSpriteUberColourR takes integer pSpriteUber returns integer
        if pSpriteUber != 0 then
            return GetByteFromInteger( GetSpriteUberColour( pSpriteUber ), 2 )
        endif

        return -1
    endfunction

    function SetSpriteUberColourR takes integer pSpriteUber, integer red returns nothing
        local integer colour = 0

        if pSpriteUber != 0 then
            set colour = GetSpriteUberColour( pSpriteUber )
            call SetSpriteUberColour( pSpriteUber, CreateInteger1( GetByteFromInteger( colour, 1 ), red, GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction
    
    function GetSpriteUberColourG takes integer pSpriteUber returns integer
        if pSpriteUber != 0 then
            return GetByteFromInteger( GetSpriteUberColour( pSpriteUber ), 3 )
        endif

        return -1
    endfunction

    function SetSpriteUberColourG takes integer pSpriteUber, integer green returns nothing
        local integer colour = 0

        if pSpriteUber != 0 then
            set colour = GetSpriteUberColour( pSpriteUber )
            call SetSpriteUberColour( pSpriteUber, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), green, GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetSpriteUberColourB takes integer pSpriteUber returns integer
        if pSpriteUber != 0 then
            return GetByteFromInteger( GetSpriteUberColour( pSpriteUber ), 4 )
        endif

        return -1
    endfunction

    function SetSpriteUberColourB takes integer pSpriteUber, integer blue returns nothing
        local integer colour = 0

        if pSpriteUber != 0 then
            set colour = GetSpriteUberColour( pSpriteUber )
            call SetSpriteUberColour( pSpriteUber, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), blue ) )
        endif
    endfunction

    function SetSpriteUberAnimationByIndex takes integer pSpriteUber, integer index returns nothing
        call SetSpriteBaseAnimationByIndex( pSpriteUber, index )
    endfunction

    function SetSpriteUberAnimationByIndexWithRarity takes integer pSpriteUber, integer index, integer rarity returns nothing
        call SetSpriteBaseAnimationByIndexWithRarity( pSpriteUber, index, rarity )
    endfunction

    function GetSpriteUberX takes integer pSpriteUber returns real
        return GetSpriteBaseX( pSpriteUber )
    endfunction

    function SetSpriteUberX takes integer pSpriteUber, real x returns nothing
        call SetSpriteBaseX( pSpriteUber, x )
    endfunction

    function GetSpriteUberY takes integer pSpriteUber returns real
        return GetSpriteBaseY( pSpriteUber )
    endfunction

    function SetSpriteUberY takes integer pSpriteUber, real y returns nothing
        call SetSpriteBaseY( pSpriteUber, y )
    endfunction

    function GetSpriteUberZ takes integer pSpriteUber returns real
        return GetSpriteBaseZ( pSpriteUber )
    endfunction

    function SetSpriteUberZ takes integer pSpriteUber, real z returns nothing
        call SetSpriteBaseZ( pSpriteUber, z )
    endfunction

    function SetSpriteUberPosition takes integer pSpriteUber, real x, real y, real z returns nothing
        call SetSpriteBasePosition( pSpriteUber, x, y, z )
    endfunction

    function GetSpriteUberTimeScale takes integer pSpriteUber returns real
        return GetSpriteBaseTimeScale( pSpriteUber )
    endfunction

    function SetSpriteUberTimeScale takes integer pSpriteUber, real speed returns nothing
        call SetSpriteBaseTimeScale( pSpriteUber, speed )
    endfunction

    function GetSpriteUberScale takes integer pSpriteUber returns real
        return GetSpriteBaseScale( pSpriteUber )
    endfunction

    function SetSpriteUberScale takes integer pSpriteUber, real scale returns nothing
        call SetSpriteBaseScale( pSpriteUber, scale )
    endfunction

    // Effect Rotation API Radians
    function GetSpriteUberYawRad takes integer pSpriteUber returns real // Z | Yaw | returns Degrees!
        return GetSpriteBaseYawRad( pSpriteUber )
    endfunction

    function GetSpriteUberPitchRad takes integer pSpriteUber returns real // Y | returns Degrees!
        return GetSpriteBasePitchRad( pSpriteUber )
    endfunction

    function GetSpriteUberRollRad takes integer pSpriteUber returns real // X | returns Degrees!
        return GetSpriteBaseRollRad( pSpriteUber )
    endfunction

    function GetSpriteUberFacingRad takes integer pSpriteUber returns real // Z | Yaw | returns Degrees!
        return GetSpriteUberYawRad( pSpriteUber )
    endfunction

    function SetSpriteUberSpaceRotationRad takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseSpaceRotationRad( pSpriteUber, yaw, pitch, roll )
    endfunction

    function SetSpriteUberYawRad takes integer pSpriteUber, real angle returns nothing // Z Yaw | In Degrees!
        call SetSpriteBaseYawRad( pSpriteUber, angle )
    endfunction

    function SetSpriteUberPitchRad takes integer pSpriteUber, real angle returns nothing // Y | In Degrees!
        call SetSpriteBasePitchRad( pSpriteUber, angle )
    endfunction

    function SetSpriteUberRollRad takes integer pSpriteUber, real angle returns nothing // X | In Degrees!
        call SetSpriteBaseRollRad( pSpriteUber, angle )
    endfunction

    function SetSpriteUberOrientationRad takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseOrientationRad( pSpriteUber, yaw, pitch, roll )
    endfunction
    //===================================================================
    
    // Effect Rotation API Degrees
    function SetSpriteUberSpaceRotation takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteUberSpaceRotationRad( pSpriteUber, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    
    function GetSpriteUberYaw takes integer pSpriteUber returns real // Z | Yaw | returns Degrees!
        return Rad2Deg( GetSpriteUberYawRad( pSpriteUber ) )
    endfunction

    function GetSpriteUberFacing takes integer pSpriteUber returns real
        return Rad2Deg( GetSpriteUberFacingRad( pSpriteUber ) )
    endfunction
    
    function GetSpriteUberPitch takes integer pSpriteUber returns real
        return Rad2Deg( GetSpriteUberPitchRad( pSpriteUber ) )
    endfunction

    function GetSpriteUberRoll takes integer pSpriteUber returns real
        return Rad2Deg( GetSpriteUberRollRad( pSpriteUber ) )
    endfunction

    function SetSpriteUberYaw takes integer pSpriteUber, real angle returns nothing
        call SetSpriteUberYawRad( pSpriteUber, Deg2Rad( angle ) )
    endfunction

    function SetSpriteUberFacing takes integer pSpriteUber, real angle returns nothing
        call SetSpriteUberYawRad( pSpriteUber, Deg2Rad( angle ) )
    endfunction

    function SetSpriteUberPitch takes integer pSpriteUber, real angle returns nothing
        call SetSpriteUberPitchRad( pSpriteUber, Deg2Rad( angle ) )
    endfunction

    function SetSpriteUberRoll takes integer pSpriteUber, real angle returns nothing
        call SetSpriteUberRollRad( pSpriteUber, Deg2Rad( angle ) )
    endfunction

    function SetSpriteUberOrientation takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteUberOrientationRad( pSpriteUber, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    //===================================================================

    function SetSpriteUberScaleXYZ takes integer pSpriteUber, real x, real y, real z returns nothing
        call SetSpriteBaseScaleXYZ( pSpriteUber, x, y, z )
    endfunction

    function ResetSpriteUberMatrix takes integer pSpriteUber returns nothing
        call ResetSpriteBaseMatrix( pSpriteUber )
    endfunction

    function Init_MemHackCSpriteUberAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ), pGameDLL + 0x966EA4 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ),  pGameDLL + 0x966FC4 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ), pGameDLL + 0x954D4C )
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ),  pGameDLL + 0x954E6C )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ), pGameDLL + 0x9647BC )
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ),  pGameDLL + 0x96485C )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ), pGameDLL + 0xA92884 )
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ),  pGameDLL + 0xA92924 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ), pGameDLL + 0xA8266C )
                call SaveInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ),  pGameDLL + 0xA8270C )
            endif
        endif
    endfunction    
endlibrary

//===========================================================================
function InitTrig_MemHackCSpriteUberAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteUberAPI = CreateTrigger(  )
endfunction
//! endnocjass
