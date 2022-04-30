//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCWidgetAPI
    globals
        integer pGetAxisZ               = 0
        integer pGetAgentInternal       = 0
        integer pGetPressenseTagged     = 0
        integer pAgentUpdate            = 0
        integer pSetWidgetPosition      = 0
        integer pSetWidgetCoordinates   = 0
    endglobals

    function GetTerrainZ takes real axisX, real axisY returns real // Use at your own risk...
        if pGetAxisZ > 0 then
            return GetRealFromMemory( fast_call_5( pGetAxisZ, -1, 0, SetRealIntoMemory( axisX ), SetRealIntoMemory( axisY ), 1 ) ) // Function returns double, probably can't handle it in Jass :\
        endif

        return 0.
    endfunction

    function GetWidgetTerrainZ takes widget Widget returns real
        if Widget != null then
            return GetTerrainZ( GetWidgetX( Widget ), GetWidgetY( Widget ) )
        endif

        return 0.
    endfunction

    function SetWidgetCoordinates takes widget Widget, real x, real y returns integer
        // This does NOT work for destructables/doodads
        local integer pWidget = ConvertHandle( Widget )

        if pWidget > 0 and pSetWidgetCoordinates > 0 then
            call WriteRealMemory( pReservedIntArg1, SetRealIntoMemory( x ) )
            call WriteRealMemory( pReservedIntArg2, SetRealIntoMemory( y ) )
            return this_call_12( pSetWidgetCoordinates, pWidget, pReservedIntArg1, pReservedIntArg2, 1, 1, -1, 0, 0, 0, 0, -1, 0 )
        endif

        return 0
    endfunction

    function SetWidgetPosition takes widget Widget, real x, real y returns integer
        // Works for destructables/doodads/items/units
        local integer pWidget = ConvertHandle( Widget )
        local integer pVal1 = 0
        local integer pVal2 = 0

        if pWidget > 0 then
            if BitwiseAnd( ReadRealMemory( pWidget + 0x8C ), ReadRealMemory( pWidget + 0x90 ) ) != -1 and pGetAgentInternal > 0 then
                set pVal1 = this_call_1( pGetAgentInternal, pWidget + 0x8C )

                if pVal1 > 0 and pGetPressenseTagged > 0 then
                    set pVal2 = fast_call_2( pGetPressenseTagged, ReadRealMemory( pVal1 + 0xC ), ReadRealMemory( pVal1 + 0x10 ) )

                    if pVal2 > 0 and pAgentUpdate > 0 then
                        if ReadRealMemory( pVal2 + 0x0C ) == 727803756 and ReadRealMemory( pVal2 + 0x20 ) == 0 then
                            call this_call_2( pAgentUpdate, pVal1, pWidget )
                        endif
                    endif
                endif
            endif

            if pSetWidgetPosition > 0 then
                call WriteRealMemory( pReservedIntArg1, SetRealIntoMemory( x ) )
                call WriteRealMemory( pReservedIntArg2, SetRealIntoMemory( y ) )
                return this_call_4( pSetWidgetPosition, pWidget, pReservedIntArg1, pReservedIntArg2, -1 )
            endif
        endif

        return 0
    endfunction

    function SetDestructablePosition takes destructable dest, real x, real y returns integer
        return SetWidgetPosition( dest, x, y )
    endfunction
    
    function SetWidgetFacing takes widget Widget, real facing returns nothing
        local integer pWidget = ConvertHandle( Widget )

        if pWidget != 0 then
            call SetObjectFacing( pWidget, facing )
        endif
    endfunction
    
    function Init_MemHackCWidgetNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGetAxisZ               = pGameDLL + 0x24FEF0
                set pGetAgentInternal       = pGameDLL + 0x4791C0
                set pGetPressenseTagged     = pGameDLL + 0x040770
                set pAgentUpdate            = pGameDLL + 0x283960
                set pSetWidgetPosition      = pGameDLL + 0x2B7600
                set pSetWidgetCoordinates   = pGameDLL + 0x2E6EC0
        elseif PatchVersion == "1.26a" then
                set pGetAxisZ               = pGameDLL + 0x24F3E0
                set pGetAgentInternal       = pGameDLL + 0x4786B0
                set pGetPressenseTagged     = pGameDLL + 0x03FA30
                set pAgentUpdate            = pGameDLL + 0x282E40
                set pSetWidgetPosition      = pGameDLL + 0x2B6AE0
                set pSetWidgetCoordinates   = pGameDLL + 0x2AC220
        elseif PatchVersion == "1.27a" then
                set pGetAxisZ               = pGameDLL + 0x6320B0
                set pGetAgentInternal       = pGameDLL + 0x044150
                set pGetPressenseTagged     = pGameDLL + 0x037350
                set pAgentUpdate            = pGameDLL + 0x6775B0
                set pSetWidgetPosition      = pGameDLL + 0x63CC10
                set pSetWidgetCoordinates   = pGameDLL + 0x635DE0
        elseif PatchVersion == "1.27b" then
                set pGetAxisZ               = pGameDLL + 0x64F7E0
                set pGetAgentInternal       = pGameDLL + 0x061320
                set pGetPressenseTagged     = pGameDLL + 0x054530
                set pAgentUpdate            = pGameDLL + 0x694CE0
                set pSetWidgetPosition      = pGameDLL + 0x65A340
                set pSetWidgetCoordinates   = pGameDLL + 0x9D7AC0
        elseif PatchVersion == "1.28f" then
                set pGetAxisZ               = pGameDLL + 0x683900
                set pGetAgentInternal       = pGameDLL + 0x08AE90
                set pGetPressenseTagged     = pGameDLL + 0x07E090
                set pAgentUpdate            = pGameDLL + 0x6C8EA0
                set pSetWidgetPosition      = pGameDLL + 0x2B6AE0
                set pSetWidgetCoordinates   = pGameDLL + 0x98CA60
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackWidgetNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackWidgetNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass
