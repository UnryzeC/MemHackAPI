//TESH.scrollpos=394
//TESH.alwaysfold=0
//! nocjass
library APIMemoryGameData
    globals
        hashtable htObjectDataPointers = InitHashtable( )
    endglobals

    function SaveCode takes hashtable ht, integer parentKey, integer childKey, code c returns nothing
        if ht != null then
            call SaveInteger( ht, parentKey, childKey, C2I( c ) )
        endif
    endfunction

    function LoadCode takes hashtable ht, integer parentKey, integer childKey returns code
        if ht != null then
            return I2C( LoadInteger( ht, parentKey, childKey ) )
        endif

        return null
    endfunction
    
    function GetGameStateInstance takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ) )
    endfunction

    function GetTempestThread takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ) )
    endfunction

    function ConvertHandleId takes integer handleid returns integer
        local integer addr = GetGameStateInstance( )

        if addr != 0 and handleid != 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( addr ) + 0x1C ) + 0x19C ) + handleid * 0xC - 0x2FFFFF * 4 )
        endif

        return 0
    endfunction
    
    function ConvertHandle takes handle h returns integer
        return ConvertHandleId( GetHandleId( h ) )
    endfunction

    function GetGameDataNode takes nothing returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ) )
        local integer pData = GetGameStateInstance( )

        if addr != 0 and pData != 0 then
            return this_call_1( addr, ReadRealMemory( pData ) )
        endif

        return 0
    endfunction

    function HandleIdToObject takes integer handleid returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ) )
        local integer pData = GetGameDataNode( )

        if addr != 0 and pData != 0 then
            return this_call_2( addr, pData, handleid )
        endif
        
        return 0
    endfunction
    
    function ObjectToHandleId takes integer pAgent returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ) )
        local integer pData = GetGameDataNode( )

        if addr != 0 and pData != 0 then
            return this_call_3( addr, pData, pAgent, 0 )
        endif
        
        return 0
    endfunction

    function GetAgentType takes handle h returns integer
        // returns code of the handle's type
        // +w3u for unit, +tmr for timer, +trg for trigger, +arg for region, etc...
 
        local integer func = ReadRealMemory( ReadRealMemory( ConvertHandle( h ) ) + 0x1C )
        return ReadRealMemory( func ) / 0x100 + ReadRealMemory( func + 0x4 ) * 0x1000000
    endfunction

    function ObjectToAbility takes integer pObject returns ability
        local integer pAbil = 0

        if pObject > 0 then
            set pAbil = ObjectToHandleId( pObject )

            if pAbil > 0 then
                return I2A( pAbil )
            endif
        endif

        return null
    endfunction
    
    function ObjectToUnit takes integer pUnit returns unit
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ) )

        if addr != 0 and pUnit != 0 then
            set pUnit = fast_call_1( addr, pUnit )

            if pUnit != 0 then
                return I2U( pUnit )
            endif
        endif

        return null
    endfunction
    
    function GetAgentHashKey takes integer agentId returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ) )
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer pData = 0

        if addr != 0 and arg != 0 and agentId != 0 then
            call WriteRealMemory( arg, agentId )
            set pData = this_call_1( addr, arg )
        endif

        return pData
    endfunction

    function GetAgentUIDefById takes integer agentId returns integer // Only use this on Abilities
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ) )

        if addr != 0 and agentId != 0 then
            return this_call_1( addr, agentId )
        endif

        return 0
    endfunction

    function GetAgileDataNodeById takes integer pDataNode, integer agentId returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ) )
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer pData = GetAgentHashKey( agentId )

        if addr != 0 and arg != 0 and pData != 0 then
            return this_call_3( addr, pDataNode, pData, arg )
        endif

        return 0
    endfunction

    function GetWidgetUIDefById takes integer wid returns integer // Units/Destructables/Items (aka widgets)
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ) )

        if addr != 0 and wid != 0 then
            return this_call_1( addr, wid )
        endif

        return 0
    endfunction

    function jUnitToCUnit takes unit u returns integer // Address formerly
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ) )

        if addr != 0 then
            return this_call_1( addr, GetHandleId( u ) )
        endif

        return 0
    endfunction

    function GetCObjectFromHashEx takes integer pHash1, integer pHash2 returns integer // call of sub_6F03FA30 (1.26a)
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ) )

        if addr != 0 and pHash1 != 0xFFFFFFFF and pHash2 != 0xFFFFFFFF then
            return fast_call_2( addr, pHash1, pHash2 )
        endif

        return 0
    endfunction

    function GetCObjectFromHashGroupEx takes integer pHashGroup returns integer // Simplified version of GetCObjectFromHashEx, uses a pointer to HashGroup
        if pHashGroup > 0 then
            return GetCObjectFromHashEx( ReadRealMemory( pHashGroup + 0x0 ), ReadRealMemory( pHashGroup + 0x4 ) )
        endif

        return 0
    endfunction

    function GetCObjectFromHash takes integer pHash1, integer pHash2 returns integer // Jass Variant of sub_6F03FA30 (126a)
        local integer addr  = GetTempestThread( )
        local integer pOff1 = 0x2C

        if addr != 0 then
            if BitwiseAnd( pHash1, pHash2 ) == -1 then
                return 0
            endif

            if pHash1 >= 0 then
                set pOff1 = 0xC
            endif

            set pOff1 = ReadRealMemory( addr ) + pOff1
            set pOff1 = ReadRealMemory( pOff1 )

            if pOff1 == 0 then
                return 0
            endif

            set pOff1 = ReadRealMemory( pOff1 + 0x8 * pHash1 + 0x4 )

            if pOff1 == 0 or ReadRealMemory( pOff1 + 0x18 ) != pHash2 then
                return 0
            endif

            return pOff1
        endif

        return 0
    endfunction

    function GetCAgentFromHash takes integer pHash1, integer pHash2 returns integer // Jass Variant of sub_6F4786B0 (126a) || pass the read values, not the pointers.
        local integer pOff1 = GetCObjectFromHash( pHash1, pHash2 )

        if pOff1 == 0 or ReadRealMemory( pOff1 + 0x20 ) > 0 then
            return 0
        endif

        return ReadRealMemory( pOff1 + 0x54 )
    endfunction

    function GetCAgentFromHashGroup takes integer pHash returns integer // Jass Variant of sub_6F4786B0 (126a) || pass the read values, not the pointers.
        local integer pData = 0

        if pHash != 0 then
            return GetCAgentFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        endif

        return 0
    endfunction
    
    function GetCObjectFromHashGroup takes integer pHashGroup returns integer
        // Alternative to GetCObjectFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        local integer addr     = GetTempestThread( )
        local integer pOffset1 = pHashGroup
        local integer pOffset2

        if addr != 0 and pHashGroup != 0 then
            set pOffset2 = ReadRealMemory( addr )

            if pOffset2 > 0 then
                set pOffset1 = ReadRealMemory( pOffset1 )
                set pOffset2 = ReadRealMemory( pOffset2 + 0xC )
                set pOffset2 = ReadRealMemory( ( pOffset1 * 0x8 ) + pOffset2 + 0x4 )
                return pOffset2
            endif
        endif

        return 0
    endfunction

    function GetCObjectFromHashGroup2 takes integer pHash returns integer
        if pHash > 0 then
            return GetCObjectFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        endif

        return 0
    endfunction

    function GetUnitAddressFloatsRelated takes integer pObject, integer offset returns integer
         // Left here for compatibility reasons, use GetObjectFromHashGroup( pObject + offset ) instead.
        if pObject > 0 then
            return GetCObjectFromHashGroup( pObject + offset )
        endif

        return 0
    endfunction

    function GetAgentTimerCooldown takes integer pTimer returns real
        local integer pData = 0
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pTimer != 0 and arg != 0 then
            set pData = ReadRealMemory( pTimer )

            if pData != 0 then
                call WriteRealMemory( arg, 0 )
                call this_call_2( ReadRealMemory( pData + 0x18 ), pTimer, arg )
                return ReadRealFloat( arg )
            endif
        endif

        return -1. // to ensure failure
    endfunction

    function GetAgentTimerExtendedCooldown takes integer pTimerExt returns real
        local integer pData = 0
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pTimerExt != 0 and arg != 0 then
            set pData = ReadRealMemory( pTimerExt )

            if pData != 0 then
                call WriteRealMemory( arg + 0x0, 0 )
                call WriteRealMemory( arg + 0x4, 0 )
                call this_call_2( ReadRealMemory( pData + 0x10 ), pTimerExt, arg + 0x0 )
                call this_call_2( ReadRealMemory( pData + 0x1C ), pTimerExt, arg + 0x4 )
                return ReadRealFloat( arg + 0x0 ) - ReadRealFloat( arg + 0x4 )
            endif
        endif

        return -1. // to ensure failure
    endfunction

    function GetSmartPositionAxis takes integer pSmartPos returns integer // x,y -> pvector2 -> x = ReadRealFloat( pvector2 + 0x0 ) | y = ReadRealFloat( pvector2 + 0x4 )
        local integer addr      = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ) )
        local integer pvector2  = 0
        
        if pSmartPos != 0 and addr != 0 then
            set pvector2 = LoadInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ) )
            call this_call_2( addr, pSmartPos, pvector2 )
            return pvector2
        endif

        return 0
    endfunction

    function SetSmartPositionAxisEx takes integer pSmartPos, real x, real y, integer flag returns integer
        local integer addr      = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ) )
        local integer pvector2  = 0
        
        if pSmartPos != 0 and addr != 0 then
            set pvector2 = LoadInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ) )
            call WriteRealFloat( pvector2 + 0x0, x )
            call WriteRealFloat( pvector2 + 0x4, y )
            return this_call_3( addr, pSmartPos, pvector2, flag )
        endif

        return 0
    endfunction

    function SetSmartPositionAxis takes integer pSmartPos, real x, real y returns integer
        return SetSmartPositionAxisEx( pSmartPos, x, y, 1 )
    endfunction

    function Init_APIMemoryGameData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xACD44C )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xACE5E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x3BE7F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x3A8BA0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x428B90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x4317C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x4C9020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x46F230 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x32D3C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x32D420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x2DD760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x040770 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x474E00 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x474D60 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xAB65F4 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xAB7788 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x3BDCB0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x3A8060 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x428050 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x430C80 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x4C8520 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x46E720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x32C880 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x32C8E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x2DCC40 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x03FA30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x4742F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x474250 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xBE4238 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xBE40A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x1D1550 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x1C3200 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x268380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x2651D0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x17A710 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x0352A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x021BD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x327020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x322C30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x88F250 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x037350 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x03D790 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x03F020 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xD687A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xD68610 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x1EEF90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x1E0D70 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x285FE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x282E30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x198420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x052480 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x03ECD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x344760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x340380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x9BA350 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x054530 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x058900 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x05C200 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xD305E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xD30448 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x2217A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x2135F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x2B8490 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x2B52E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x1CACC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x07BFE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x069D60 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x378720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x374340 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x96F2E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x07E090 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x0844D0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x085D70 )
            endif

            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ), Malloc( 0x8 ) )
            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector3" ), Malloc( 0xC ) )
            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Matrix3x3" ), Malloc( 0x24 ) )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameData takes nothing returns nothing
    //set gg_trg_APIMemoryGameData = CreateTrigger(  )
endfunction
//! endnocjass
