//TESH.scrollpos=102
//TESH.alwaysfold=0
//! nocjass
library MemoryHackEffectAPI
    function IsEffectHidden takes effect e returns boolean
        return IsObjectHidden( ConvertHandle( e ) )
    endfunction

    function ShowEffect takes effect e, boolean flag returns nothing
        call ShowObject( ConvertHandle( e ), flag )
    endfunction

    function SetEffectAlpha takes effect e, integer alpha returns nothing
        call SetObjectAlpha( ConvertHandle( e ), alpha )
    endfunction

    function GetEffectColour takes effect e returns integer
        return GetObjectColour( ConvertHandle( e ) )
    endfunction

    function SetEffectColour takes effect e, integer colour returns nothing
        call SetObjectColour( ConvertHandle( e ), colour )
    endfunction

    function SetEffectColourEx takes effect e, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( ConvertHandle( e ), red, green, blue, alpha )
    endfunction

    function SetEffectVertexColour takes effect e, integer red, integer green, integer blue, integer alpha returns nothing
        local integer pObject = ConvertHandle( e )

        if pObject > 0 then
            call SetObjectColourEx( pObject, red, green, blue, alpha )
            call SetObjectAlpha( pObject, alpha )
        endif
    endfunction

    function GetEffectColourA takes effect e returns integer
        return GetObjectColourA( ConvertHandle( e ) )
    endfunction

    function SetEffectColourA takes effect e, integer alpha returns nothing
        call SetObjectColourA( ConvertHandle( e ), alpha )
    endfunction

    function GetEffectColourR takes effect e returns integer
        return GetObjectColourR( ConvertHandle( e ) )
    endfunction

    function SetEffectColourR takes effect e, integer red returns nothing
        call SetObjectColourR( ConvertHandle( e ), red )
    endfunction

    function GetEffectColourG takes effect e returns integer
        return GetObjectColourG( ConvertHandle( e ) )
    endfunction

    function SetEffectColourG takes effect e, integer green returns nothing
        call SetObjectColourG( ConvertHandle( e ), green )
    endfunction

    function GetEffectColourB takes effect e returns integer
        return GetObjectColourB( ConvertHandle( e ) )
    endfunction

    function SetEffectColourB takes effect e, integer blue returns nothing
        call SetObjectColourB( ConvertHandle( e ), blue )
    endfunction

    function SetEffectModel takes effect e, string model, boolean flag returns nothing
        call SetObjectModel( ConvertHandle( e ), model, flag )
    endfunction

    function GetEffectX takes effect e returns real
        return GetObjectX( ConvertHandle( e ) )
    endfunction

    function SetEffectX takes effect e, real x returns nothing
        call SetObjectX( ConvertHandle( e ), x )
    endfunction

    function GetEffectY takes effect e returns real
        return GetObjectY( ConvertHandle( e ) )
    endfunction

    function SetEffectY takes effect e, real y returns nothing
        call SetObjectY( ConvertHandle( e ), y )
    endfunction

    function GetEffectZ takes effect e returns real
        return GetObjectZ( ConvertHandle( e ) )
    endfunction

    function SetEffectZ takes effect e, real z returns nothing
        call SetObjectZ( ConvertHandle( e ), z )
    endfunction

    function SetEffectPosition takes effect e, real x, real y, real z returns nothing
        call SetObjectPosition( ConvertHandle( e ), x, y, z )
    endfunction

    function GetEffectTimeScale takes effect e returns real
        return GetObjectTimeScale( ConvertHandle( e ) )
    endfunction

    function SetEffectTimeScale takes effect e, real speed returns nothing
        call SetObjectTimeScale( ConvertHandle( e ), speed )
    endfunction

    function GetEffectScale takes effect e returns real
        return GetObjectScale( ConvertHandle( e ) )
    endfunction

    function SetEffectScale takes effect e, real scale returns nothing
        call SetObjectScale( ConvertHandle( e ), scale )
    endfunction

    function SetEffectScaleEx takes effect e, real x, real y, real z returns nothing
        call SetObjectScaleEx( ConvertHandle( e ), x, y, z )
    endfunction

    function GetEffectRoll takes effect e returns real // X | returns Degrees!
        return GetObjectRoll( ConvertHandle( e ) )
    endfunction

    function SetEffectRoll takes effect e, real angle returns nothing
        call SetObjectRoll( ConvertHandle( e ), angle )
    endfunction

    function GetEffectPitch takes effect e returns real // Y | returns Degrees!
        return GetObjectPitch( ConvertHandle( e ) )
    endfunction

    function SetEffectPitch takes effect e, real angle returns nothing // Y | In Degrees!
        call SetObjectPitch( ConvertHandle( e ), angle )
    endfunction

    function GetEffectYaw takes effect e returns real // Z | Yaw | returns Degrees!
        return GetObjectYaw( ConvertHandle( e ) )
    endfunction
    
    function GetEffectFacing takes effect e returns real // Z | Yaw | returns Degrees!
        return GetObjectFacing( ConvertHandle( e ) )
    endfunction

    function SetEffectYaw takes effect e, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectYaw( ConvertHandle( e ), angle )
    endfunction

    function SetEffectFacing takes effect e, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectFacing( ConvertHandle( e ), angle )
    endfunction

    function SetEffectSpaceRotation takes effect e, real yaw, real pitch, real roll returns nothing
        call SetObjectSpaceRotation( ConvertHandle( e ), yaw, pitch, roll )
    endfunction

    function SetEffectOrientation takes effect e, real yaw, real pitch, real roll returns nothing
        call SetObjectOrientation( ConvertHandle( e ), yaw, pitch, roll )
    endfunction

    function ResetEffectMatrix takes effect e returns nothing
        call ResetObjectMatrix( ConvertHandle( e ) )
    endfunction

    function SetEffectAnimationByIndex takes effect e, integer index returns nothing
        call SetObjectAnimationByIndex( ConvertHandle( e ), index )
    endfunction

    function SetEffectAnimationByIndexWithRarity takes effect e, integer index, integer rarity returns nothing
        call SetObjectAnimationByIndexWithRarity( ConvertHandle( e ), index, rarity )
    endfunction
    
    function Init_MemHackEffectAPI takes nothing returns nothing
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
function InitTrig_MemHackEffectAPI takes nothing returns nothing
    //set gg_trg_MemHackEffectAPI = CreateTrigger(  )
endfunction
//! endnocjass
