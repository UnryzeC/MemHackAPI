//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library HandleAPI // Deprecated, but, you can refer to APIMemoryObjectData to see which functions will work or no.
    function GetSpriteDataOffsetR takes handle h, integer offset returns real
        return GetSpriteDataOffsetAddressR( ConvertHandle( h ), offset )
    endfunction
    
    function SetSpriteDataOffsetR takes handle h, integer offset, real r returns nothing
        call SetSpriteDataOffsetAddressR( ConvertHandle( h ), offset, r )
    endfunction

    function GetHandleColour takes handle h returns integer
        return GetObjectColour( ConvertHandle( h ) )
    endfunction

    function SetHandleColour takes handle h, integer colour returns nothing
        call SetObjectColour( ConvertHandle( h ), colour )
    endfunction

    function SetHandleColourEx takes handle h, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( ConvertHandle( h ), red, green, blue, alpha )
    endfunction

    function UpdateHandleColour takes handle h returns nothing
        call UpdateObjectColour( ConvertHandle( h ) )
    endfunction

    function GetHandleColourA takes handle h returns integer
        return GetObjectColourA( ConvertHandle( h ) )
    endfunction

    function SetHandleColourA takes handle h, integer alpha returns nothing
        call SetObjectColourA( ConvertHandle( h ), alpha )
    endfunction

    function GetHandleColourR takes handle h returns integer
        return GetObjectColourR( ConvertHandle( h ) )
    endfunction

    function SetHandleColourR takes handle h, integer red returns nothing
        call SetObjectColourR( ConvertHandle( h ), red )
    endfunction
    
    function GetHandleColourG takes handle h returns integer
        return GetObjectColourG( ConvertHandle( h ) )
    endfunction

    function SetHandleColourG takes handle h, integer green returns nothing
        call SetObjectColourG( ConvertHandle( h ), green )
    endfunction

    function GetHandleColourB takes handle h returns integer
        return GetObjectColourB( ConvertHandle( h ) )
    endfunction

    function SetHandleColourB takes handle h, integer blue returns nothing
        call SetObjectColourB( ConvertHandle( h ), blue )
    endfunction
endlibrary

//===========================================================================
function InitTrig_HandleAPI takes nothing returns nothing
    //set gg_trg_HandleAPI = CreateTrigger(  )
endfunction
//! endnocjass
