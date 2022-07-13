//TESH.scrollpos=69
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCWidgetAPI
    function GetTerrainZ takes real axisX, real axisY returns real // Use at your own risk...
        local integer addr = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ) )

        if addr != 0 then
            return GetRealFromMemory( fast_call_5( addr, -1, 0, SetRealIntoMemory( axisX ), SetRealIntoMemory( axisY ), 1 ) ) // Function returns double, probably can't handle it in Jass :\
        endif

        return 0.
    endfunction

    function SetCWidgetCoordinates takes integer pWidget, real x, real y returns integer
        // This does NOT work for destructables/doodads
        local integer addr = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 and pWidget != 0 then
            call WriteRealFloat( arg + 0x0, x )
            call WriteRealFloat( arg + 0x4, y )
            return this_call_12( addr, pWidget, arg + 0x0, arg + 0x4, 1, 1, -1, 0, 0, 0, 0, -1, 0 )
        endif

        return 0
    endfunction
    
    function GetCWidgetAgent takes integer pWidget returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ) )

        if addr != 0 and pWidget != 0 then
            return this_call_1( addr, pWidget + 0x8C )
        endif

        return 0
    endfunction

    function GetCWidgetPresence takes integer pWidget returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ) )

        if addr != 0 and pWidget != 0 then
            set pWidget = GetCWidgetAgent( pWidget )
            
            if pWidget != 0 then
                return fast_call_2( addr, ReadRealMemory( pWidget + 0xC ), ReadRealMemory( pWidget + 0x10 ) )
            endif
        endif

        return 0
    endfunction

    function UpdateCWidget takes integer pWidget returns nothing
        local integer addr   = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ) )
        local integer pAgent = 0
        local integer pPres  = 0

        if addr != 0 and pWidget != 0 then
            set pAgent = GetCWidgetAgent( pWidget )
            
            if pAgent != 0 then
                set pPres = GetCWidgetPresence( pWidget )
                
                if pPres != 0 then
                    if ReadRealMemory( pPres + 0x0C ) == '+agl' and ReadRealMemory( pPres + 0x20 ) == 0 then
                        call this_call_2( addr, pAgent, pWidget )
                    endif
                endif
            endif
        endif
    endfunction

    function SetCWidgetPosition takes integer pWidget, real x, real y returns integer
        // Works for destructables/doodads/items/units
        local integer addr = LoadInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 and pWidget != 0 then
            if BitwiseAnd( ReadRealMemory( pWidget + 0x8C ), ReadRealMemory( pWidget + 0x90 ) ) != -1 then
                call UpdateCWidget( pWidget )
            endif

            call WriteRealFloat( arg + 0x0, x )
            call WriteRealFloat( arg + 0x4, y )
            return this_call_4( addr, pWidget, arg + 0x0, arg + 0x4, -1 )
        endif

        return 0
    endfunction    

    function GetWidgetTerrainZ takes widget Widget returns real
        if Widget != null then
            return GetTerrainZ( GetWidgetX( Widget ), GetWidgetY( Widget ) )
        endif

        return 0.
    endfunction
    
    function SetWidgetCoordinates takes widget Widget, real x, real y returns integer
        return SetCWidgetCoordinates( ConvertHandle( Widget ), x, y )
    endfunction
    
    function GetWidgetAgent takes widget Widget returns integer
        return GetCWidgetAgent( ConvertHandle( Widget ) )
    endfunction

    function GetWidgetPresence takes widget Widget returns integer
        return GetCWidgetPresence( ConvertHandle( Widget ) )
    endfunction

    function UpdateWidget takes widget Widget returns nothing
        call UpdateCWidget( ConvertHandle( Widget ) )
    endfunction    

    function SetWidgetPosition takes widget Widget, real x, real y returns integer
        return SetCWidgetPosition( ConvertHandle( Widget ), x, y )
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
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ), pGameDLL + 0x24FEF0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ), pGameDLL + 0x4791C0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ), pGameDLL + 0x040770 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ), pGameDLL + 0x283960 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ), pGameDLL + 0x2B7600 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ), pGameDLL + 0x2E6EC0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ), pGameDLL + 0x24F3E0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ), pGameDLL + 0x4786B0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ), pGameDLL + 0x03FA30 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ), pGameDLL + 0x282E40 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ), pGameDLL + 0x2B6AE0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ), pGameDLL + 0x2AC220 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ), pGameDLL + 0x6320B0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ), pGameDLL + 0x044150 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ), pGameDLL + 0x037350 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ), pGameDLL + 0x6775B0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ), pGameDLL + 0x63CC10 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ), pGameDLL + 0x635DE0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ), pGameDLL + 0x64F7E0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ), pGameDLL + 0x061320 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ), pGameDLL + 0x054530 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ), pGameDLL + 0x694CE0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ), pGameDLL + 0x65A340 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ), pGameDLL + 0x9D7AC0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAxisZ" ), pGameDLL + 0x683900 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetAgent" ), pGameDLL + 0x08AE90 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "GetPresence" ), pGameDLL + 0x07E090 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "UpdateAgent" ), pGameDLL + 0x6C8EA0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetPosition" ), pGameDLL + 0x2B6AE0 )
                call SaveInteger( MemHackTable, StringHash( "CWidget" ), StringHash( "SetCoordinates" ), pGameDLL + 0x98CA60 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackWidgetNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackWidgetNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass
