//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCObjectAPI
    function GetARGBColour takes integer alpha, integer red, integer green, integer blue returns integer
        return CreateInteger1( alpha, red, green, blue )
    endfunction

    function IsObjectHidden takes integer pObject returns boolean
        if pObject > 0 then
            return IsFlagBitSet( ReadRealMemory( pObject + 0x20 ), 1 )
        endif

        return false
    endfunction

    function ShowObject takes integer pObject, boolean flag returns nothing
        if pObject > 0 then
            call WriteRealMemory( pObject + 0x20, B2I( not flag ) )
        endif
    endfunction

    function GetObjectTypeId takes integer pObj returns integer
        // Do NOT use this with effects or trackables, since they do not have TypeId
        if pObj > 0 then
            return ReadRealMemory( pObj + 0x30 )
        endif

        return 0
    endfunction    

    function GetObjectSprite takes integer pObject returns integer
        // Units and Effects return CSpriteUber | items and destructables returns CSpriteMini
        if pObject != 0 then
            return ReadRealMemory( pObject + 0x28 )
        endif

        return 0
    endfunction

    function GetObjectSpriteFloat takes integer pObject, integer offset returns real
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            return ReadRealFloat( pSprite + offset )
        endif

        return 0.
    endfunction

    function SetObjectSpriteFloat takes integer pObject, integer offset, real value returns real
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            call WriteRealFloat( pSprite + offset, value )
        endif

        return 0.
    endfunction

    function UpdateObjectColour takes integer pObject returns nothing // pObject = ConvertHandle( h )
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )
        local integer flag    = 0

        if pSprite != 0 then
            call WriteRealMemory( pSprite + 0x140, 0 )
            call WriteRealMemory( pSprite + 0x13C, 0 )
            set flag = ReadRealMemory( pSprite + 0x138 )

            if not IsFlagBitSet( flag, 0x800 ) then
                call WriteRealMemory( pSprite + 0x138, flag + 0x800 )
            endif
        endif
    endfunction

    function SetObjectAlpha takes integer pObject, integer alpha returns nothing
        // Does not work on items/units/destructables/doodads, meaning only works on Effects (they are pure CSpriteUber)
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ) )
        local integer pSprite = GetObjectSprite( pObject )

        if addr != 0 and pSprite != 0 then
            if alpha >= 0x00 and alpha <= 0xFF then
                call fast_call_3( addr, pSprite, alpha, 0 )
            endif
        endif
    endfunction

    function GetObjectColour takes integer pObject returns integer
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            return ReadRealMemory( pSprite + 0x148 )
        endif

        return 0
    endfunction

    function SetObjectColour takes integer pObject, integer colour returns nothing
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            call WriteRealMemory( pSprite + 0x148, colour )
            call UpdateObjectColour( pObject )
        endif
    endfunction

    function SetObjectColourEx takes integer pObject, integer red, integer green, integer blue, integer alpha returns nothing
        if pObject != 0 then
            call SetObjectColour( pObject, CreateInteger1( alpha, red, green, blue ) )
        endif
    endfunction
    
    function SetObjectVertexColour takes integer pObject, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( pObject, red, green, blue, alpha )
        call SetObjectAlpha( pObject, alpha )
    endfunction

    function GetObjectColourA takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 1 )
        endif
        
        return -1
    endfunction

    function SetObjectColourA takes integer pObject, integer alpha returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( alpha, GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetObjectColourR takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 2 )
        endif

        return -1
    endfunction

    function SetObjectColourR takes integer pObject, integer red returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), red, GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction
    
    function GetObjectColourG takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 3 )
        endif

        return -1
    endfunction

    function SetObjectColourG takes integer pObject, integer green returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), green, GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetObjectColourB takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 4 )
        endif

        return -1
    endfunction

    function SetObjectColourB takes integer pObject, integer blue returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), blue ) )
        endif
    endfunction
    
    function SetObjectAnimationByIndex takes integer pObject, integer index returns nothing
        call SetSpriteBaseAnimationByIndex( GetObjectSprite( pObject ), index )
    endfunction

    function SetObjectAnimationByIndexWithRarity takes integer pObject, integer index, integer rarity returns nothing
        call SetSpriteBaseAnimationByIndexWithRarity( GetObjectSprite( pObject ), index, rarity )
    endfunction
    
    function SetObjectModel takes integer pObject, string model returns nothing
        // Works on every handle, even items.
        local integer pData = 0

        if pObject > 0 then
            set pData = ReadRealMemory( pObject ) + 0x88

            if pData > 0 then
                set pData = ReadRealMemory( pData )

                if pData > 0 then
                    call this_call_3( pData, pObject, GetStringAddress( model ), 1 )
                endif
            endif
        endif
    endfunction

    function GetObjectX takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC0 )
    endfunction

    function SetObjectX takes integer pObject, real x returns nothing
        call SetObjectSpriteFloat( pObject, 0xC0, x )
    endfunction

    function GetObjectY takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC4 )
    endfunction

    function SetObjectY takes integer pObject, real y returns nothing
        call SetObjectSpriteFloat( pObject, 0xC4, y )
    endfunction

    function GetObjectZ takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC8 )
    endfunction

    function SetObjectZ takes integer pObject, real z returns nothing
        call SetObjectSpriteFloat( pObject, 0xC8, z )
    endfunction

    function SetObjectPosition takes integer pObject, real x, real y, real z returns nothing
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            call WriteRealFloat( pSprite + 0xC0, x )
            call WriteRealFloat( pSprite + 0xC4, y )
            call WriteRealFloat( pSprite + 0xC8, z )
        endif
    endfunction

    function GetObjectTimeScale takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0x190 )
    endfunction

    function SetObjectTimeScale takes integer pObject, real speed returns nothing
        call SetObjectSpriteFloat( pObject, 0x190, speed )
    endfunction

    function GetObjectScale takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xE8 )
    endfunction

    function SetObjectScale takes integer pObject, real scale returns nothing
        call SetObjectSpriteFloat( pObject, 0xE8, scale )
    endfunction

    // Effect Rotation API Radians
    function GetObjectYawRad takes integer pObject returns real // Z | Yaw | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r11   = ReadRealFloat( pSprite + 0x108 )
            set r21   = ReadRealFloat( pSprite + 0x114 )
            set r31   = ReadRealFloat( pSprite + 0x120 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw   = -Atan2( r21, r11 )

            if yaw < 0 then
                set yaw = 6.28319 + yaw
            endif
        endif

        return yaw
    endfunction

    function GetObjectPitchRad takes integer pObject returns real // Y | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r31   = ReadRealFloat( pSprite + 0x120 )
            set r32   = ReadRealFloat( pSprite + 0x124 )
            set r33   = ReadRealFloat( pSprite + 0x128 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )

            if r31 < 0. and r33 > 0. then
                set pitch = pitch
        elseif r31 < 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 > 0. then
                set pitch = 6.28319 + pitch
            endif
        endif
        
        return pitch
    endfunction

    function GetObjectRollRad takes integer pObject returns real // X | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r31     = ReadRealFloat( pSprite + 0x120 )
            set r32     = ReadRealFloat( pSprite + 0x124 )
            set r33     = ReadRealFloat( pSprite + 0x128 )
            set pitch   = -Asin( r31 )
            set roll    = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            if roll < 0. then
                set roll = 6.28319 + roll
            endif
        endif
        
        return roll
    endfunction

    function GetObjectFacingRad takes integer pObject returns real // Z | Yaw | returns Degrees!
        return GetObjectYawRad( pObject )
    endfunction

    function SetObjectSpaceRotationRad takes integer pObject, real yaw, real pitch, real roll returns nothing
        local integer pSprite = GetObjectSprite( pObject )
        local real Sx = Sin( roll )
        local real Sy = Sin( pitch )
        local real Sz = Sin( -yaw )
        local real Cx = Cos( roll )
        local real Cy = Cos( pitch )
        local real Cz = Cos( -yaw )

        if pSprite != 0 then
            call WriteRealFloat( pSprite + 0x108, Cy * Cz )
            call WriteRealFloat( pSprite + 0x10C, -Cy * Sz )
            call WriteRealFloat( pSprite + 0x110, Sy )
            call WriteRealFloat( pSprite + 0x114, Cz * Sx * Sy + Cx * Sz )
            call WriteRealFloat( pSprite + 0x118, Cx * Cz - Sx * Sy * Sz )
            call WriteRealFloat( pSprite + 0x11C, -Cy * Sx )
            call WriteRealFloat( pSprite + 0x120, -Cx * Cz * Sy + Sx * Sz )
            call WriteRealFloat( pSprite + 0x124, Cz * Sx + Cx * Sy * Sz )
            call WriteRealFloat( pSprite + 0x128, Cx * Cy )
        endif
    endfunction

    function SetObjectYawRad takes integer pObject, real angle returns nothing // Z Yaw | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r31      = ReadRealFloat( pSprite + 0x120 )
            set r32      = ReadRealFloat( pSprite + 0x124 )
            set r33      = ReadRealFloat( pSprite + 0x128 )
            set pitch    = -Asin( r31 ) //Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set roll     = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            call SetObjectSpaceRotationRad( pObject, angle, pitch, roll )
        endif
    endfunction

    function SetObjectPitchRad takes integer pObject, real angle returns nothing // Y | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real yaw          = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r11     = ReadRealFloat( pSprite + 0x108 )
            set r21     = ReadRealFloat( pSprite + 0x114 )
            set r32     = ReadRealFloat( pSprite + 0x124 )
            set r33     = ReadRealFloat( pSprite + 0x128 )
            set yaw     = Atan2( r21 / Cos( angle ), r11 / Cos( angle ) )
            set roll    = Atan2( r32 / Cos( angle ), r33 / Cos( angle ) )

            call SetObjectSpaceRotationRad( pObject, yaw, angle, roll )
        endif
    endfunction

    function SetObjectRollRad takes integer pObject, real angle returns nothing // X | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r11     = ReadRealFloat( pSprite + 0x108 )
            set r21     = ReadRealFloat( pSprite + 0x114 )
            set r31     = ReadRealFloat( pSprite + 0x120 )
            set pitch   = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw     = Atan2( r21 / Cos( pitch ), r11 / Cos( pitch ) )

            call SetObjectSpaceRotationRad( pObject, yaw, pitch, angle )
        endif
    endfunction

    function SetObjectOrientationRad takes integer pObject, real yaw, real pitch, real roll returns nothing
        if pObject > 0 then
            call SetObjectSpaceRotationRad( pObject, yaw, pitch, roll )
            //call SetObjectRollRad( pObject, roll )
            //call SetObjectPitchRad( pObject, pitch )
            //call SetObjectYawRad( pObject, yaw )
        endif
    endfunction
    //===================================================================
    
    // Effect Rotation API Degrees
    function SetObjectSpaceRotation takes integer pObject, real yaw, real pitch, real roll returns nothing
        call SetObjectSpaceRotationRad( pObject, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    
    function GetObjectYaw takes integer pObject returns real // Z | Yaw | returns Degrees!
        return Rad2Deg( GetObjectYawRad( pObject ) )
    endfunction

    function GetObjectFacing takes integer pObject returns real
        return Rad2Deg( GetObjectFacingRad( pObject ) )
    endfunction
    
    function GetObjectPitch takes integer pObject returns real
        return Rad2Deg( GetObjectPitchRad( pObject ) )
    endfunction

    function GetObjectRoll takes integer pObject returns real
        return Rad2Deg( GetObjectRollRad( pObject ) )
    endfunction

    function SetObjectYaw takes integer pObject, real angle returns nothing
        call SetObjectYawRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectFacing takes integer pObject, real angle returns nothing
        call SetObjectYawRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectPitch takes integer pObject, real angle returns nothing
        call SetObjectPitchRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectRoll takes integer pObject, real angle returns nothing
        call SetObjectRollRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectOrientation takes integer pObject, real yaw, real pitch, real roll returns nothing
        call SetObjectOrientationRad( pObject, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    //===================================================================

    function SetObjectScaleEx takes integer pObject, real x, real y, real z returns nothing
        call SetSpriteBaseMaterialScale( GetObjectSprite( pObject ), x, y, z )
    endfunction

    function ResetObjectMatrix takes integer pObject returns nothing
        call ResetSpriteBaseMatrix( GetObjectSprite( pObject ) )
    endfunction

    function Init_APIMemoryObjectData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x4D3D50 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x4D3250 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x186FA0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x1A4CC0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x1D7550 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCObjectAPI takes nothing returns nothing
    //set gg_trg_MemHackCObjectAPI = CreateTrigger(  )
endfunction
//! endnocjass
