//TESH.scrollpos=57
//TESH.alwaysfold=0
//! nocjass
library MemoryHackTrackableAPI
    globals
    
    endglobals

    function IsTrackableHidden takes trackable track returns boolean
        return IsObjectHidden( ConvertHandle( track ) )
    endfunction
    
    function ShowTrackable takes trackable track, boolean flag returns nothing
        call ShowObject( ConvertHandle( track ), flag )
    endfunction
    
    function SetTrackableAlpha takes trackable track, integer alpha returns nothing
        call SetObjectAlpha( ConvertHandle( track ), alpha )
    endfunction
    
    function GetTrackableColour takes trackable track returns integer
        return GetObjectColour( ConvertHandle( track ) )
    endfunction
    
    function SetTrackableColour takes trackable track, integer colour returns nothing
        call SetObjectColour( ConvertHandle( track ), colour )
    endfunction
    
    function SetTrackableColourEx takes trackable track, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( ConvertHandle( track ), red, green, blue, alpha )
    endfunction

    function SetTrackableVertexColour takes trackable track, integer red, integer green, integer blue, integer alpha returns nothing
        local integer pObject = ConvertHandle( track )

        if pObject > 0 then
            call SetObjectColourEx( pObject, red, green, blue, alpha )
            call SetObjectAlpha( pObject, alpha )
        endif
    endfunction

    function GetTrackableColourA takes trackable track returns integer
        return GetObjectColourA( ConvertHandle( track ) )
    endfunction

    function SetTrackableColourA takes trackable track, integer alpha returns nothing
        call SetObjectColourA( ConvertHandle( track ), alpha )
    endfunction

    function GetTrackableColourR takes trackable track returns integer
        return GetObjectColourR( ConvertHandle( track ) )
    endfunction

    function SetTrackableColourR takes trackable track, integer red returns nothing
        call SetObjectColourR( ConvertHandle( track ), red )
    endfunction
    
    function GetTrackableColourG takes trackable track returns integer
        return GetObjectColourG( ConvertHandle( track ) )
    endfunction

    function SetTrackableColourG takes trackable track, integer green returns nothing
        call SetObjectColourG( ConvertHandle( track ), green )
    endfunction

    function GetTrackableColourB takes trackable track returns integer
        return GetObjectColourB( ConvertHandle( track ) )
    endfunction

    function SetTrackableColourB takes trackable track, integer blue returns nothing
        call SetObjectColourB( ConvertHandle( track ), blue )
    endfunction

    function SetTrackableAnimationByIndex takes trackable track, integer index returns nothing
        call SetObjectAnimationByIndex( ConvertHandle( track ), index )
    endfunction
    
    function SetTrackableModel takes trackable track, string model, boolean flag returns nothing
        call SetObjectModel( ConvertHandle( track ), model, flag )
    endfunction

    function GetTrackableX takes trackable track returns real
        return GetObjectX( ConvertHandle( track ) )
    endfunction

    function SetTrackableX takes trackable track, real x returns nothing
        call SetObjectX( ConvertHandle( track ), x )
    endfunction

    function GetTrackableY takes trackable track returns real
        return GetObjectY( ConvertHandle( track ) )
    endfunction

    function SetTrackableY takes trackable track, real y returns nothing
        call SetObjectY( ConvertHandle( track ), y )
    endfunction

    function GetTrackableZ takes trackable track returns real
        return GetObjectZ( ConvertHandle( track ) )
    endfunction

    function SetTrackableZ takes trackable track, real z returns nothing
        call SetObjectZ( ConvertHandle( track ), z )
    endfunction

    function SetTrackablePosition takes trackable track, real x, real y, real z returns nothing
        call SetObjectPosition( ConvertHandle( track ), x, y, z )
    endfunction

    function GetTrackableTimeScale takes trackable track returns real
        return GetObjectTimeScale( ConvertHandle( track ) )
    endfunction

    function SetTrackableTimeScale takes trackable track, real speed returns nothing
        call SetObjectTimeScale( ConvertHandle( track ), speed )
    endfunction

    function GetTrackableScale takes trackable track returns real
        return GetObjectScale( ConvertHandle( track ) )
    endfunction

    function SetTrackableScale takes trackable track, real scale returns nothing
        call SetObjectScale( ConvertHandle( track ), scale )
    endfunction

    function SetTrackableScaleEx takes trackable track, real x, real y, real z returns nothing
        call SetObjectScaleEx( ConvertHandle( track ), x, y, z )
    endfunction

    function GetTrackableRoll takes trackable track returns real // X | returns Degrees!
        return GetObjectRoll( ConvertHandle( track ) )
    endfunction

    function SetTrackableRoll takes trackable track, real angle returns nothing
        call SetObjectRoll( ConvertHandle( track ), angle )
    endfunction

    function GetTrackablePitch takes trackable track returns real // Y | returns Degrees!
        return GetObjectPitch( ConvertHandle( track ) )
    endfunction

    function SetTrackablePitch takes trackable track, real angle returns nothing // Y | In Degrees!
        call SetObjectPitch( ConvertHandle( track ), angle )
    endfunction

    function GetTrackableYaw takes trackable track returns real // Z | Yaw | returns Degrees!
        return GetObjectYaw( ConvertHandle( track ) )
    endfunction
    
    function GetTrackableFacing takes trackable track returns real // Z | Yaw | returns Degrees!
        return GetObjectFacing( ConvertHandle( track ) )
    endfunction

    function SetTrackableYaw takes trackable track, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectYaw( ConvertHandle( track ), angle )
    endfunction

    function SetTrackableFacing takes trackable track, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectFacing( ConvertHandle( track ), angle )
    endfunction

    function SetTrackableSpaceRotation takes trackable track, real yaw, real pitch, real roll returns nothing
        call SetObjectSpaceRotation( ConvertHandle( track ), yaw, pitch, roll )
    endfunction

    function SetTrackableOrientation takes trackable track, real yaw, real pitch, real roll returns nothing
        call SetObjectOrientation( ConvertHandle( track ), yaw, pitch, roll )
    endfunction

    function ResetTrackableMatrix takes trackable track returns nothing
        call ResetObjectMatrix( ConvertHandle( track ) )
    endfunction

    function Init_MemHackTrackableAPI takes nothing returns nothing
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
function InitTrig_MemHackTrackableAPI takes nothing returns nothing
    //set gg_trg_MemHackTrackableAPI = CreateTrigger(  )
endfunction
//! endnocjass
