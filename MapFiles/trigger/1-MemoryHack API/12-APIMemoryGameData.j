//TESH.scrollpos=309
//TESH.alwaysfold=0
//! nocjass
library APIMemoryGameData
    globals
        integer pGameState          = 0
        integer pGameClass1         = 0
        integer pGetUnitAddress     = 0
        integer pGetHandleId        = 0
        integer pHandleIdToObject   = 0
        integer pObjectToHandleId   = 0
        integer pGetHashKey         = 0
        integer pGetDataNode        = 0
        integer pGetUIDataNode      = 0
        integer pGetWidgetUIDef     = 0
        integer pGetAgentUIDef      = 0
        integer pToJUnit            = 0
        integer pGetObjectFromHash  = 0

        hashtable htObjectDataPointers = InitHashtable( )
        
        integer pVector2Arg                 = 0
        integer pVector3Arg                 = 0
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

    function ConvertHandleId takes integer handleid returns integer
        if handleid > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( pGameState ) + 0x1C ) + 0x19C ) + handleid * 0xC - 0x2FFFFF * 4 )
        endif

        return 0
    endfunction
    
    function ConvertHandle takes handle h returns integer
        return ConvertHandleId( GetHandleId( h ) )
    endfunction

    function HandleIdToObject takes integer handleid returns integer
        local integer pData = this_call_1( pGetHandleId, ReadRealMemory( pGameState ) )

        if pData > 0 then
            return this_call_2( pHandleIdToObject, pData, handleid )
        endif
        
        return 0
    endfunction
    
    function ObjectToHandleId takes integer address returns integer
        local integer pData = this_call_1( pGetHandleId, ReadRealMemory( pGameState ) )

        if pData > 0 then
            return this_call_3( pObjectToHandleId, pData, address, 0 )
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
    
    function ObjectToUnit takes integer pObject returns unit
        local integer pUnit = 0

        if pObject > 0 then
            set pUnit = fast_call_1( pToJUnit, pObject )

            if pUnit > 0 then
                return I2U( pUnit )
            endif
        endif
        
        return null
    endfunction
    
    function GetAgentHashKey takes integer agentId returns integer
        local integer pData = 0

        if pGetHashKey != 0 and agentId != 0 then
            call WriteRealMemory( pReservedIntArg1, agentId )
            set pData = this_call_1( pGetHashKey, pReservedIntArg1 )
        endif

        return pData
    endfunction
    
    function GetAgileDataNodeById takes integer pDataNode, integer agentId returns integer
        local integer pData = GetAgentHashKey( agentId )

        if pGetDataNode != 0 and pData != 0 then
            return this_call_3( pGetDataNode, pDataNode, pData, pReservedIntArg1 )
        endif

        return 0
    endfunction

    function GetWidgetUIDefById takes integer wid returns integer // Units/Destructables/Items (aka widgets)
        if pGetWidgetUIDef != 0 and wid != 0 then
            return this_call_1( pGetWidgetUIDef, wid )
        endif

        return 0
    endfunction

    function GetAgentUIDefById takes integer agentId returns integer // Only use this on Abilities
        if pGetWidgetUIDef != 0 and agentId != 0 then
            return this_call_1( pGetAgentUIDef, agentId )
        endif

        return 0
    endfunction

    function GetUnitAddress takes unit u returns integer
        return this_call_1( pGetUnitAddress, GetHandleId( u ) )
    endfunction

    function GetCObjectFromHashEx takes integer pHash1, integer pHash2 returns integer // call of sub_6F03FA30 (1.26a)
        if pHash1 != 0xFFFFFFFF and pHash2 != 0xFFFFFFFF and pGetObjectFromHash > 0 then
            return fast_call_2( pGetObjectFromHash, pHash1, pHash2 )
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
        local integer pOff1 = 0x2C

        if BitwiseAnd( pHash1, pHash2 ) == -1 then
            return 0
        endif

        if pHash1 >= 0 then
            set pOff1 = 0xC
        endif

        set pOff1 = ReadRealMemory( pGameClass1 ) + pOff1
        set pOff1 = ReadRealMemory( pOff1 )

        if pOff1 == 0 then
            return 0
        endif

        set pOff1 = ReadRealMemory( pOff1 + 0x8 * pHash1 + 0x4 )

        if pOff1 == 0 or ReadRealMemory( pOff1 + 0x18 ) != pHash2 then
            return 0
        endif

        return pOff1
    endfunction

    function GetCAgentFromHash takes integer pHash1, integer pHash2 returns integer // Jass Variant of sub_6F4786B0 (126a) || pass the read values, not the pointers.
        local integer pOff1 = GetCObjectFromHash( pHash1, pHash2 )

        if pOff1 == 0 or ReadRealMemory( pOff1 + 0x20 ) > 0 then
            return 0
        endif

        return ReadRealMemory( pOff1 + 0x54 )
    endfunction

    function GetCObjectFromHashGroup takes integer pHashGroup returns integer
        // Alternative to GetCObjectFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        local integer pOffset1 = pHashGroup
        local integer pOffset2

        if pHashGroup > 0 then
            set pOffset2 = ReadRealMemory( pGameClass1 )

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

        if pTimer > 0 then
            set pData = ReadRealMemory( pTimer )

            if pData > 0 then
                call WriteRealMemory( pReservedIntArg1, 0 )
                call this_call_2( ReadRealMemory( pData + 0x18 ), pTimer, pReservedIntArg1 )
                return ReadRealFloat( pReservedIntArg1 )
            endif
        endif

        return -1. // to ensure failure
    endfunction

    function GetAgentTimerExtendedCooldown takes integer pTimerExt returns real
        local integer pData = 0

        if pTimerExt > 0 then
            set pData = ReadRealMemory( pTimerExt )

            if pData > 0 then
                call WriteRealMemory( pReservedIntArg2, 0 )
                call WriteRealMemory( pReservedIntArg3, 0 )
                call this_call_2( ReadRealMemory( pData + 0x10 ), pTimerExt, pReservedIntArg1 )
                call this_call_2( ReadRealMemory( pData + 0x1C ), pTimerExt, pReservedIntArg2 )
                return ReadRealFloat( pReservedIntArg1 ) - ReadRealFloat( pReservedIntArg2 )
            endif
        endif

        return -1. // to ensure failure
    endfunction
    
    function Init_APIMemoryGameData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGameState          = pGameDLL + 0xACD44C
                set pGameClass1         = pGameDLL + 0xACE5E0
                set pGetUnitAddress     = pGameDLL + 0x3BE7F0
                set pGetHandleId        = pGameDLL + 0x3A8BA0
                set pHandleIdToObject   = pGameDLL + 0x428B90
                set pObjectToHandleId   = pGameDLL + 0x4317C0
                set pGetHashKey         = pGameDLL + 0x4C9020
                set pGetDataNode        = pGameDLL + 0x46F230
                set pGetUIDataNode      = pGameDLL + 0x001EC0
                set pGetWidgetUIDef     = pGameDLL + 0x32D3C0
                set pGetAgentUIDef      = pGameDLL + 0x32D420
                set pToJUnit            = pGameDLL + 0x2DD760
                set pGetObjectFromHash  = pGameDLL + 0x040770
        elseif PatchVersion == "1.26a" then
                set pGameState          = pGameDLL + 0xAB65F4
                set pGameClass1         = pGameDLL + 0xAB7788
                set pGetUnitAddress     = pGameDLL + 0x3BDCB0
                set pGetHandleId        = pGameDLL + 0x3A8060
                set pHandleIdToObject   = pGameDLL + 0x428050
                set pObjectToHandleId   = pGameDLL + 0x430C80
                set pGetHashKey         = pGameDLL + 0x4C8520
                set pGetDataNode        = pGameDLL + 0x46E720
                set pGetUIDataNode      = pGameDLL + 0x001EC0
                set pGetWidgetUIDef     = pGameDLL + 0x32C880
                set pGetAgentUIDef      = pGameDLL + 0x32C8E0
                set pToJUnit            = pGameDLL + 0x2DCC40
                set pGetObjectFromHash  = pGameDLL + 0x03FA30
        elseif PatchVersion == "1.27a" then
                set pGameState          = pGameDLL + 0xBE4238 // Inside ExecuteFunc | under Concurrency::details::ContextBase dword_... = v3
                set pGameClass1         = pGameDLL + 0xBE40A8 // "DispatchUnitSelectionModify Start for player %d" -> & 0x7FFFFFFFu) >= *(_DWORD *)(dword_6F... + 60
                set pGetUnitAddress     = pGameDLL + 0x1D1550 // WaygateSetDestination -> result = (signed int *)
                set pGetHandleId        = pGameDLL + 0x1C3200 // this + 7, 0, 0, 0);
                set pHandleIdToObject   = pGameDLL + 0x268380 // this[103] + 12 * a2 - 12582908);
                set pObjectToHandleId   = pGameDLL + 0x2651D0 // (_DWORD *)(v4[112] + 12 * (v5 & v8));
                set pGetHashKey         = pGameDLL + 0x17A710 // for ( i = -286331154; v1; i += v4 + 32 * i + v2
                set pGetDataNode        = pGameDLL + 0x0352A0 // first while ( *result != a2 || result[5] != *a3 )
                set pGetUIDataNode      = pGameDLL + 0x021BD0
                set pGetWidgetUIDef     = pGameDLL + 0x327020
                set pGetAgentUIDef      = pGameDLL + 0x322C30
                set pToJUnit            = pGameDLL + 0x88F250 // GetCreepCamp -> JUMPOUT(&loc_6F...);
                set pGetObjectFromHash  = pGameDLL + 0x037350
        elseif PatchVersion == "1.27b" then
                set pGameState          = pGameDLL + 0xD687A8
                set pGameClass1         = pGameDLL + 0xD68610
                set pGetUnitAddress     = pGameDLL + 0x1EEF90
                set pGetHandleId        = pGameDLL + 0x1E0D70
                set pHandleIdToObject   = pGameDLL + 0x285FE0
                set pObjectToHandleId   = pGameDLL + 0x282E30
                set pGetHashKey         = pGameDLL + 0x198420
                set pGetDataNode        = pGameDLL + 0x052480
                set pGetUIDataNode      = pGameDLL + 0x03ECD0
                set pGetWidgetUIDef     = pGameDLL + 0x344760
                set pGetAgentUIDef      = pGameDLL + 0x340380
                set pToJUnit            = pGameDLL + 0x9BA350
                set pGetObjectFromHash  = pGameDLL + 0x054530
        elseif PatchVersion == "1.28f" then
                set pGameState          = pGameDLL + 0xD305E0
                set pGameClass1         = pGameDLL + 0xD30448
                set pGetUnitAddress     = pGameDLL + 0x2217A0
                set pGetHandleId        = pGameDLL + 0x2135F0
                set pHandleIdToObject   = pGameDLL + 0x2B8490
                set pObjectToHandleId   = pGameDLL + 0x2B52E0
                set pGetHashKey         = pGameDLL + 0x1CACC0
                set pGetDataNode        = pGameDLL + 0x07BFE0
                set pGetUIDataNode      = pGameDLL + 0x069D60
                set pGetWidgetUIDef     = pGameDLL + 0x378720
                set pGetAgentUIDef      = pGameDLL + 0x374340
                set pToJUnit            = pGameDLL + 0x96F2E0
                set pGetObjectFromHash  = pGameDLL + 0x07E090
            endif
            
            set pVector2Arg = Malloc( 0x8 )
            set pVector3Arg = Malloc( 0xC )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameData takes nothing returns nothing
    //set gg_trg_APIMemoryGameData = CreateTrigger(  )
endfunction
//! endnocjass
