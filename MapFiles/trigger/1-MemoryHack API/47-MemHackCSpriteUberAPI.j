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
        //call SetSpriteUberAlpha( pSpriteUber, alpha )
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
        // Does not work on CSpriteUberMini, refer to GetSpriteUber for explanation.

        if pSpriteUber != 0 then
            //call fast_call_3( pSetSpriteUberAnimation, pSpriteUber, index, 0 )
        endif
    endfunction

    function GetSpriteUberX takes integer pSpriteUber returns real
        return GetSpriteBaseFloat( pSpriteUber, 0xC0 )
    endfunction

    function SetSpriteUberX takes integer pSpriteUber, real x returns nothing
        call SetSpriteBaseFloat( pSpriteUber, 0xC0, x )
    endfunction

    function GetSpriteUberY takes integer pSpriteUber returns real
        return GetSpriteBaseFloat( pSpriteUber, 0xC4 )
    endfunction

    function SetSpriteUberY takes integer pSpriteUber, real y returns nothing
        call SetSpriteBaseFloat( pSpriteUber, 0xC4, y )
    endfunction

    function GetSpriteUberZ takes integer pSpriteUber returns real
        return GetSpriteBaseFloat( pSpriteUber, 0xC8 )
    endfunction

    function SetSpriteUberZ takes integer pSpriteUber, real z returns nothing
        call SetSpriteBaseFloat( pSpriteUber, 0xC8, z )
    endfunction

    function SetSpriteUberPosition takes integer pSpriteUber, real x, real y, real z returns nothing
        if pSpriteUber != 0 then
            call WriteRealFloat( pSpriteUber + 0xC0, x )
            call WriteRealFloat( pSpriteUber + 0xC4, y )
            call WriteRealFloat( pSpriteUber + 0xC8, z )
        endif
    endfunction

    function GetSpriteUberTimeScale takes integer pSpriteUber returns real
        return GetSpriteBaseFloat( pSpriteUber, 0x190 )
    endfunction

    function SetSpriteUberTimeScale takes integer pSpriteUber, real speed returns nothing
        call SetSpriteBaseFloat( pSpriteUber, 0x190, speed )
    endfunction

    function GetSpriteUberScale takes integer pSpriteUber returns real
        return GetSpriteBaseScale( pSpriteUber, true )
    endfunction

    function SetSpriteUberScale takes integer pSpriteUber, real scale returns nothing
        call SetSpriteBaseScale( pSpriteUber, scale, true )
    endfunction

    // Effect Rotation API Radians
    function GetSpriteUberYawRad takes integer pSpriteUber returns real // Z | Yaw | returns Degrees!
        return GetSpriteBaseYawRad( pSpriteUber, true )
    endfunction

    function GetSpriteUberPitchRad takes integer pSpriteUber returns real // Y | returns Degrees!
        return GetSpriteBasePitchRad( pSpriteUber, true )
    endfunction

    function GetSpriteUberRollRad takes integer pSpriteUber returns real // X | returns Degrees!
        return GetSpriteBaseRollRad( pSpriteUber, true )
    endfunction

    function GetSpriteUberFacingRad takes integer pSpriteUber returns real // Z | Yaw | returns Degrees!
        return GetSpriteUberYawRad( pSpriteUber )
    endfunction

    function SetSpriteUberSpaceRotationRad takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseSpaceRotationRad( pSpriteUber, yaw, pitch, roll, true )
    endfunction

    function SetSpriteUberYawRad takes integer pSpriteUber, real angle returns nothing // Z Yaw | In Degrees!
        call SetSpriteBaseYawRad( pSpriteUber, angle, true )
    endfunction

    function SetSpriteUberPitchRad takes integer pSpriteUber, real angle returns nothing // Y | In Degrees!
        call SetSpriteBasePitchRad( pSpriteUber, angle, true )
    endfunction

    function SetSpriteUberRollRad takes integer pSpriteUber, real angle returns nothing // X | In Degrees!
        call SetSpriteBaseRollRad( pSpriteUber, angle, true )
    endfunction

    function SetSpriteUberOrientationRad takes integer pSpriteUber, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseOrientationRad( pSpriteUber, yaw, pitch, roll, true )
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
        call SetSpriteBaseScaleXYZ( pSpriteUber, x, y, z, true )
    endfunction

    function ResetSpriteUberMatrix takes integer pSpriteUber returns nothing
        call ResetSpriteBaseMatrix( pSpriteUber, true )
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSpriteUberAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteUberAPI = CreateTrigger(  )
endfunction
//! endnocjass
