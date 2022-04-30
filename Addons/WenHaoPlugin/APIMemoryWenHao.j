//! nocjass
native TeleportCaptain takes real x,real y returns nothing
native SetHeroLevels takes code f returns nothing
native GetUnitGoldCost takes integer unitid returns integer

library MemoryHackWenHaoAPI
    globals
        constant boolean LoadWenHao = true
        boolean IsWenHaoOn = false

        hashtable japi_ht                           = InitHashtable( )
        integer   japi__key                         = StringHash( "jass" )
        constant hashtable  LocalActionLib___ht     = japi_ht
        constant integer    LocalActionLib___key    = japi__key
        constant hashtable  d3d__ht                 = japi_ht
        constant integer    d3d__key                = japi__key
    endglobals

    function GetFuncAddr takes code f returns integer
        call SetHeroLevels( f )
        return LoadInteger( japi_ht, japi__key, 0 )
    endfunction

     function WHGetMouseX takes nothing returns real
        call SaveStr( japi_ht, japi__key, 0, "()R" )
        call UnitId( "GetMouseX" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

     function WHGetMouseY takes nothing returns real
        call SaveStr( japi_ht, japi__key, 0, "()R" )
        call UnitId( "GetMouseY" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

     function WHEXGetUnitAbility takes unit u, integer abilityId returns integer
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( u ) )
        call SaveInteger( japi_ht, japi__key, 2, abilityId )
        call SaveStr( japi_ht, japi__key, 0, "(II)I" )
        call UnitId( "EXGetUnitAbility" )
        return LoadInteger( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWEGetUnitAbilityState takes unit u, integer abilcode, integer data_type returns real
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(II)R" )
        call UnitId( "EXGetAbilityState" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWEGetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type returns integer
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(III)I" )
        call UnitId( "EXGetAbilityDataInteger" )
        return LoadInteger( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWEGetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type returns real
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(III)R" )
        call UnitId( "EXGetAbilityDataReal" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWEGetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type returns string
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(III)S" )
        call UnitId( "EXGetAbilityDataString" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWESetUnitAbilityState takes unit u, integer abilcode, integer data_type, real value returns nothing
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveReal( japi_ht, japi__key, 3, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIR)V" )
        call UnitId( "EXSetAbilityState" )
    endfunction

    function WHYDWESetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type, integer value returns nothing
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveInteger( japi_ht, japi__key, 4, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIII)V" )
        call UnitId( "EXSetAbilityDataInteger" )
    endfunction

    function WHYDWESetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type, real value returns nothing
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveReal( japi_ht, japi__key, 4, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIIR)V" )
        call UnitId( "EXSetAbilityDataReal" )
    endfunction

    function WHYDWESetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type, string value returns nothing
        call SaveInteger( japi_ht, japi__key, 1, WHEXGetUnitAbility( u, abilcode ) )
        call SaveInteger( japi_ht, japi__key, 2, level )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveStr( japi_ht, japi__key, 4, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIIS)V" )
        call UnitId( "EXSetAbilityDataString" )
    endfunction

    function WHEXSetAbilityAEmeDataA takes integer ability_handle, integer value returns boolean
        call SaveInteger( japi_ht, japi__key, 1, ability_handle )
        call SaveInteger( japi_ht, japi__key, 2, value )
        call SaveStr( japi_ht, japi__key, 0, "(II)B" )
        call UnitId( "EXSetAbilityAEmeDataA" )
        return LoadBoolean( japi_ht, japi__key, 0 )
    endfunction

    function WHYDWEUnitTransform takes unit u, integer abilcode, integer targetid returns nothing
        call UnitAddAbility( u, abilcode )
        call WHYDWESetUnitAbilityDataInteger( u, abilcode, 1, 117, GetUnitTypeId( u ) )
        call WHEXSetAbilityAEmeDataA( WHEXGetUnitAbility( u, abilcode ), GetUnitTypeId( u ) )
        call UnitRemoveAbility( u, abilcode )
        call UnitAddAbility( u, abilcode )
        call WHEXSetAbilityAEmeDataA( WHEXGetUnitAbility( u, abilcode ), targetid )
        call UnitRemoveAbility( u, abilcode )
    endfunction

    function WHEXPauseUnit takes unit unit_handle, boolean flag returns nothing
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( unit_handle ) )
        call SaveBoolean( japi_ht, japi__key, 2, flag )
        call SaveStr( japi_ht, japi__key, 0, "(IB)V" )
        call UnitId( "EXPauseUnit" )
    endfunction

    function WHEXGetUnitString takes integer unitcode, integer data_type returns string
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(II)S" )
        call UnitId( "EXGetUnitString" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetUnitString takes integer unitcode, integer data_type, string value returns boolean
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 3, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIS)B" )
        call UnitId( "EXSetUnitString" )
        return LoadBoolean( japi_ht, japi__key, 0 )
    endfunction

     function WHEXGetUnitReal takes integer unitcode, integer data_type returns real
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(II)R" )
        call UnitId( "EXGetUnitReal" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetUnitReal takes integer unitcode, integer data_type, real value returns boolean
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveReal( japi_ht, japi__key, 3, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIR)B" )
        call UnitId( "EXSetUnitReal" )
        return LoadBoolean( japi_ht, japi__key, 0 )
    endfunction

    function WHEXGetUnitInteger takes integer unitcode, integer data_type returns integer
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(II)I" )
        call UnitId( "EXGetUnitInteger" )
        return LoadInteger( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetUnitInteger takes integer unitcode, integer data_type, integer value returns boolean
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveInteger( japi_ht, japi__key, 3, value )
        call SaveStr( japi_ht, japi__key, 0, "(III)B" )
        call UnitId( "EXSetUnitInteger" )
        return LoadBoolean( japi_ht, japi__key, 0 )
    endfunction

    function WHEXGetUnitArrayString takes integer unitcode, integer data_type, integer index returns string
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveInteger( japi_ht, japi__key, 3, index )
        call SaveStr( japi_ht, japi__key, 0, "(III)S" )
        call UnitId( "EXGetUnitArrayString" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetUnitArrayString takes integer unitcode, integer data_type, integer index, string value returns boolean
        call SaveInteger( japi_ht, japi__key, 1, unitcode )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveInteger( japi_ht, japi__key, 3, index )
        call SaveStr( japi_ht, japi__key, 4, value )
        call SaveStr( japi_ht, japi__key, 0, "(IIIS)B" )
        call UnitId( "EXSetUnitArrayString" )
        return LoadBoolean( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetUnitFacing takes unit unit_handle, real angle returns nothing
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( unit_handle ) )
        call SaveReal( japi_ht, japi__key, 2, angle )
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call UnitId( "EXSetUnitFacing" )
    endfunction

    function WHEXSetUnitCollisionType takes boolean enable, unit unit_handle, integer data_type returns nothing
        call SaveBoolean( japi_ht, japi__key, 1, enable )
        call SaveInteger( japi_ht, japi__key, 2, GetHandleId( unit_handle ) )
        call SaveInteger( japi_ht, japi__key, 3, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(BII)V" )
        call UnitId( "EXSetUnitCollisionType" )
    endfunction

    function WHEXSetUnitMoveType takes unit unit_handle, integer data_type returns nothing
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( unit_handle ) )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 0, "(II)V" )
        call UnitId( "EXSetUnitMoveType" )
    endfunction

    function WHYDWEUnitAddStun takes unit u returns nothing
        call WHEXPauseUnit( u, true )
    endfunction

    function WHYDWEUnitRemoveStun takes unit u returns nothing
        call WHEXPauseUnit( u, false )
    endfunction

    function WHEXGetEventDamageData takes integer data_type returns integer
        //call SaveInteger( ht, key, 1, data_type )
        //call SaveStr( ht, key, 0, "(I)I" )
        //call Call( "EXGetEventDamageData" )
        //return LoadInteger( ht, key, 0 )
        return GetUnitGoldCost( data_type )
    endfunction

    function WHEXSetEventDamage takes real dmg returns boolean
        //call SaveReal( ht, key, 1, dmg )
        //call SaveStr( ht, key, 0, "(R)B" )
        //call Call( "EXSetEventDamage" )
        //return LoadBoolean( ht, key,0 )
        call TeleportCaptain( dmg, 0.00 )
        return true
    endfunction

    function WHYDWEIsEventPhysicalDamage takes nothing returns boolean
        return GetUnitGoldCost( 1 ) != 0
    endfunction

    function WHYDWEIsEventAttackDamage takes nothing returns boolean
        return GetUnitGoldCost( 2 ) != 0
    endfunction

    function WHYDWEIsEventRangedDamage takes nothing returns boolean
        return GetUnitGoldCost( 3 ) != 0
    endfunction

    function WHYDWEIsEventDamageType takes damagetype d_type returns boolean
        return d_type == ConvertDamageType( GetUnitGoldCost( 4 ) )
    endfunction

    function WHYDWEIsEventWeaponType takes weapontype w_type returns boolean
        return w_type == ConvertWeaponType( GetUnitGoldCost( 5 ) )
    endfunction

    function WHYDWEIsEventAttackType takes attacktype a_type returns boolean
        return a_type == ConvertAttackType( GetUnitGoldCost( 6 ) )
    endfunction

    function WHYDWESetEventDamage takes real amount returns boolean
        return WHEXSetEventDamage( amount )
    endfunction

    function WHYDWESetItemDataString takes integer iid, integer data_type, string text returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IIS)V" )
        call SaveInteger( japi_ht, japi__key, 1, iid )
        call SaveInteger( japi_ht, japi__key, 2, data_type )
        call SaveStr( japi_ht, japi__key, 3, text )
        call UnitId( "EXSetItemDataString" )
    endfunction

    function WHYDWEGetItemDataString takes integer iid,integer data_type returns string
        call SaveStr( japi_ht, japi__key, 0, "(II)S" )
        call SaveInteger( japi_ht, japi__key, 1, iid )
        call SaveInteger(japi_ht, japi__key, 2, data_type )
        call UnitId( "EXGetItemDataString" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetEffectXY takes effect e, real x, real y returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IRR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, x )
        call SaveReal( japi_ht, japi__key, 3, y )
        call UnitId( "EXSetEffectXY" )
    endfunction

    function WHEXSetEffectZ takes effect e,real z returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IRR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, z )
        call UnitId( "EXSetEffectZ" )
    endfunction

    function WHEXGetEffectX takes effect e returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call UnitId( "EXGetEffectX" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXGetEffectY takes effect e returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call UnitId( "EXGetEffectY" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXGetEffectZ takes effect e returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call UnitId( "EXGetEffectZ" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXSetEffectSize takes effect e, real size returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, size )
        call UnitId( "EXSetEffectSize" )
    endfunction

    function WHEXGetEffectSize takes effect e returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call UnitId( "EXGetEffectSize" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXEffectMatRotateX takes effect e,real x returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, x )
        call UnitId( "EXEffectMatRotateX" )
    endfunction

    function WHEXEffectMatRotateY takes effect e, real y returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, y )
        call UnitId( "EXEffectMatRotateY" )
    endfunction

    function WHEXEffectMatRotateZ takes effect e, real z returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, z )
        call UnitId( "EXEffectMatRotateZ" )
    endfunction

    function WHEXEffectMatScale takes effect e, real x, real y, real z returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IRRR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, x )
        call SaveReal( japi_ht, japi__key, 3, y )
        call SaveReal( japi_ht, japi__key, 4, z )
        call UnitId( "EXEffectMatScale" )
    endfunction

    function WHEXEffectMatReset takes effect e returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(I)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call UnitId( "EXEffectMatReset" )
    endfunction

    function WHEXSetEffectSpeed takes effect e, real speed returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( e ) )
        call SaveReal( japi_ht, japi__key, 2, speed )
        call UnitId( "EXSetEffectSpeed" )
    endfunction

    function WHEXSetTrackableXY takes trackable trk, real x, real y returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IRR)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( trk ) )
        call SaveReal( japi_ht, japi__key, 2, x )
        call SaveReal( japi_ht, japi__key, 3, y )
        call UnitId( "EXSetEffectXY" )
    endfunction

    function WHEXGetTrackableX takes trackable trk returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( trk ) )
        call UnitId( "EXGetEffectX" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXGetTrackableY takes trackable trk returns real
        call SaveStr( japi_ht, japi__key, 0, "(I)R" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( trk ) )
        call UnitId( "EXGetEffectY" )
        return LoadReal( japi_ht, japi__key, 0 )
    endfunction

    function WHEXExecuteScript takes string str returns string
        call SaveStr( japi_ht, japi__key, 0, "(S)S" )
        call SaveStr( japi_ht, japi__key, 1, str )
        call UnitId( "EXExecuteScript" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

     function WHEXDisplayChat takes player p, integer chat_recipient, string message returns nothing
        call SaveStr( japi_ht, japi__key, 0, "(IIS)V" )
        call SaveInteger( japi_ht, japi__key, 1, GetHandleId( p ) )
        call SaveInteger( japi_ht, japi__key, 2, chat_recipient )
        call SaveStr( japi_ht, japi__key, 3, message )
        call UnitId( "EXDisplayChat" )
    endfunction

    function WHYDWEDisplayChat takes player p, integer chat_recipient, string message returns nothing
        call WHEXDisplayChat( p, chat_recipient, message )
    endfunction

    function WHGetMapName takes nothing returns string
        call SaveStr( japi_ht, japi__key, 0, "()S" )
        call UnitId( "GetMapName" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    function WHGetGameVersion takes nothing returns integer
        call SaveStr( japi_ht, japi__key, 0, "()I" )
        call UnitId( "GetGameVersion" )
        return LoadInteger( japi_ht, japi__key, 0 )
    endfunction

    function WHGetPluginVersion takes nothing returns string
        call SaveStr( japi_ht, japi__key, 0, "()S" )
        call UnitId( "GetPluginVersion" )
        return LoadStr( japi_ht, japi__key, 0 )
    endfunction

    //============================||================================
    function WHLocalOrder takes integer order, integer flags returns nothing
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(II)V" )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 1, order )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 2, flags )
        call UnitId( "LocalOrder"  )
    endfunction

    function WHLocalPointOrder takes integer order, real x, real y, integer flags returns nothing
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(IRRI)V" )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 1, order )
        call SaveReal( LocalActionLib___ht, LocalActionLib___key, 2, x )
        call SaveReal( LocalActionLib___ht, LocalActionLib___key, 3, y )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 4, flags )
        call UnitId( "LocalPointOrder" )
    endfunction

    function WHLocalTargetOrder takes integer order, widget object, integer flags returns nothing
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(IHwidget;I)V" )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 1, order )
        call SaveWidgetHandle(LocalActionLib___ht, LocalActionLib___key, 2, object )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 3, flags )
        call UnitId( "LocalTargetOrder" )
    endfunction

    function WHGetPlayerSelectedUnit takes player p returns unit
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(I)Hunit;" )
        call RemoveSavedHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 1, GetHandleId( p ) )
        call UnitId( "GetPlayerSelectedUnit" )
        return LoadUnitHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHGetTargetUnit takes nothing returns unit
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(V)Hunit;" )
        call RemoveSavedHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
        call UnitId( "GetTargetObject" )
        return LoadUnitHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHGetTargetItem takes nothing returns item
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(V)Hitem;" )
        call RemoveSavedHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
        call UnitId( "GetTargetObject" )
        return LoadItemHandle(LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHGetTargetDestructable takes nothing returns destructable
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(V)Hdestructable;" )
        call RemoveSavedHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
        call UnitId( "GetTargetObject" )
        return LoadDestructableHandle( LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHSetUnitAbilityButtonShow takes unit u, integer id, boolean show returns nothing
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(IIB)V" )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 1, GetHandleId(  u ) )
        call SaveInteger( LocalActionLib___ht, LocalActionLib___key, 2, id )
        call SaveBoolean( LocalActionLib___ht, LocalActionLib___key, 3, show )
        call UnitId( "SetUnitAbilityButtonShow" )
    endfunction

    function WHShowFpsText takes boolean Open returns nothing
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "(B)V" )
        call SaveBoolean( LocalActionLib___ht, LocalActionLib___key, 1, Open )
        call UnitId( "ShowFpsText" )
    endfunction

    function WHGetFps takes nothing returns real
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "()R" )
        call UnitId( "GetFps" )
        return LoadReal( LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHGetChatState takes nothing returns boolean
        call SaveStr( LocalActionLib___ht, LocalActionLib___key, 0, "()B" )
        call UnitId( "GetChatState" )
        return LoadBoolean(LocalActionLib___ht, LocalActionLib___key, 0 )
    endfunction

    function WHGetMouseVectorX takes nothing returns real
        call SaveStr( d3d__ht, d3d__key, 0, "()R" )
        call UnitId( "GetMouseVectorX" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetMouseVectorY takes nothing returns real
        call SaveStr( d3d__ht, d3d__key, 0, "()R" )
        call UnitId( "GetMouseVectorY" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetWindowWidth takes nothing returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "()I" )
        call UnitId( "GetWindowWidth" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetWindowHeight takes nothing returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "()I" )
        call UnitId( "GetWindowHeight" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHHex takes integer i returns string
        call SaveStr( d3d__ht, d3d__key, 0, "(I)S" )
        call SaveInteger( d3d__ht, d3d__key, 1, i )
        call UnitId( "Hex" )
        return LoadStr( d3d__ht, d3d__key, 0 )
    endfunction
    
    //==================Font API================================
    function WHCreateFont takes nothing returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "()I" )
        call UnitId( "CreateFont" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHDestroyFont takes integer l__font returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(I)V" )
        call UnitId( "DestroyFont" )
    endfunction

    function WHGetFontWidth takes integer l__font returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call UnitId( "GetFontWidth" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetFontWidth takes integer l__font, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetFontWidth" )
    endfunction

    function WHGetFontHeight takes integer l__font returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call UnitId( "GetFontHeight" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetFontHeight takes integer l__font, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetFontHeight" )
    endfunction

    function WHGetFontWeight takes integer l__font returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call UnitId( "GetFontWeight" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetFontWeight takes integer l__font, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetFontWeight" )
    endfunction

    function WHSetFontItalic takes integer l__font, boolean value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IB)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveBoolean( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetFontItalic" )
    endfunction

    function WHGetFontFaceName takes integer l__font returns string
        call SaveStr( d3d__ht, d3d__key, 0, "(I)S" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call UnitId( "GetFontFaceName" )
        return LoadStr( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetFontFaceName takes integer l__font, string value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IS)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveStr( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetFontFaceName" )
    endfunction

    //==================Text API================================
    function WHCreateText takes integer l__font, string str, real x, real y, real time, integer color returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(ISRRRI)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, l__font )
        call SaveStr( d3d__ht, d3d__key, 2, str )
        call SaveReal( d3d__ht, d3d__key, 3, x )
        call SaveReal( d3d__ht, d3d__key, 4, y )
        call SaveReal( d3d__ht, d3d__key, 5, time )
        call SaveInteger( d3d__ht, d3d__key, 6, color )
        call UnitId( "CreateText" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetTextString takes integer text returns string
        call SaveStr( d3d__ht, d3d__key, 0, "(I)S" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call UnitId( "GetTextString" )
        return LoadStr( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextString takes integer text, string str returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IS)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call SaveStr( d3d__ht, d3d__key, 2, str )
        call UnitId( "SetTextString" )
    endfunction

    function WHGetTextX takes integer text returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call UnitId( "GetTextX" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextX takes integer text, real x returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call SaveReal( d3d__ht, d3d__key, 2, x )
        call UnitId( "SetTextX" )
    endfunction

    function WHGetTextY takes integer text returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call UnitId( "GetTextY" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextY takes integer text, real y returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call SaveReal( d3d__ht, d3d__key, 2, y )
        call UnitId( "SetTextY" )
    endfunction

    function WHGetTextTime takes integer text returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call UnitId( "GetTextTime" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextTime takes integer text, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextTime" )
    endfunction

    function WHGetTextColor takes integer text returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call UnitId( "GetTextColor" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextColor takes integer text, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, text )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextColor" )
    endfunction

    //==================Texture API================================
    function WHCreateTexture takes string path, real x, real y, real width, real height, integer color, integer level returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(SRRRRII)I" )
        call SaveStr( d3d__ht, d3d__key, 1, path )
        call SaveReal( d3d__ht, d3d__key, 2, x )
        call SaveReal( d3d__ht, d3d__key, 3, y )
        call SaveReal( d3d__ht, d3d__key, 4, width )
        call SaveReal( d3d__ht, d3d__key, 5, height )
        call SaveInteger( d3d__ht, d3d__key, 6, color )
        call SaveInteger( d3d__ht, d3d__key, 7, level )
        call UnitId( "CreateTexture" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHDestroyTexture takes integer texture returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(I)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "DestroyTexture" )
    endfunction

    function WHGetTextureX takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureX" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureX takes integer texture, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureX" )
    endfunction

    function WHGetTextureY takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureY" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureY takes integer texture, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureY" )
    endfunction

    function WHGetTextureWidth takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureWidth" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureWidth takes integer texture, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureWidth" )
    endfunction

    function WHGetTextureHeight takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureHeight" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureHeight takes integer texture, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureHeight" )
    endfunction

    function WHGetTextureColor takes integer texture returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureColor" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureColor takes integer texture, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureColor" )
    endfunction

    function WHGetTextureLevel takes integer texture returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(I)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureLevel" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureLevel takes integer texture, integer value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveInteger( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureLevel" )
    endfunction

    function WHGetTextureRotation takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureRotation" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureRotation takes integer texture, real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IR)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveReal( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureRotation" )
    endfunction

    function WHGetTexturePixelWidth takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTexturePixelWidth" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetTexturePixelHeight takes integer texture returns real
        call SaveStr( d3d__ht, d3d__key, 0, "(I)R" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTexturePixelWidth" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHGetTextureSrcRect takes integer texture returns rect
        call SaveStr( d3d__ht, d3d__key, 0, "(I)Hrect;" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call UnitId( "GetTextureSrcRect" )
        return LoadRectHandle( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetTextureSrcRect takes integer texture, rect value returns nothing
        call RemoveSavedHandle( d3d__ht, d3d__key, 0 )
        call SaveStr( d3d__ht, d3d__key, 0, "(IHrect;)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveRectHandle(d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureSrcRect" )
    endfunction

    function WHSetTexture takes integer texture, string value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IS)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveStr( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTexture" )
    endfunction

    function WHSetTextureShow takes integer texture, boolean value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IB)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveBoolean( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureShow" )
    endfunction

    function WHSetTextureTrigger takes integer texture, boolean value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IB)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveBoolean( d3d__ht, d3d__key, 2, value )
        call UnitId( "SetTextureTrigger" )
    endfunction

    function WHEnableTextureTrigger takes integer texture returns nothing
        call WHSetTextureTrigger( texture, true )
    endfunction

    function WHDisableTextureTrigger takes integer texture returns nothing
        call WHSetTextureTrigger( texture, false )
    endfunction

    function WHGetTextureCenterX takes integer texture returns real
        return WHGetTextureX( texture ) + WHGetTextureWidth( texture ) / 2
    endfunction

    function WHGetTextureCenterY takes integer texture returns real
        return WHGetTextureY( texture ) + WHGetTextureHeight( texture ) / 2
    endfunction

    function WHGetTextureMinX takes integer texture returns real
        return WHGetTextureX( texture )
    endfunction

    function WHGetTextureMinY takes integer texture returns real
        return WHGetTextureY( texture )
    endfunction

    function WHGetTextureMaxX takes integer texture returns real
        return WHGetTextureX( texture ) + WHGetTextureWidth( texture )
    endfunction

    function WHGetTextureMaxY takes integer texture returns real
        return WHGetTextureY( texture ) + WHGetTextureHeight( texture )
    endfunction

    function WHTextureAddEvent takes integer texture, integer order, code wCallBack, code lCallBack returns integer
        call SaveStr( d3d__ht, d3d__key, 0, "(IIII)I" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveInteger( d3d__ht, d3d__key, 2, order )
        call SaveInteger( d3d__ht, d3d__key, 3, GetFuncAddr( wCallBack ) )
        call SaveInteger( d3d__ht, d3d__key, 4, GetFuncAddr( lCallBack ) )
        call UnitId( "TextureAddEvent" )
        return LoadInteger( d3d__ht, d3d__key, 0 )
    endfunction

    function WHTextureRemoveEvent takes integer texture, integer Event returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(II)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, texture )
        call SaveInteger( d3d__ht, d3d__key, 2, Event )
        call UnitId( "TextureRemoveEvent" )
    endfunction

    //==================EventAPI API================================
    function WHSetKeyboard takes integer Key, boolean up returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(IB)V" )
        call SaveInteger( d3d__ht, d3d__key, 1, Key )
        call SaveBoolean( d3d__ht, d3d__key, 2, up )
        call UnitId( "SetKeyboard" )
    endfunction

    function WHClickKeyboard takes integer Key returns nothing
        call WHSetKeyboard( Key, true )
        call WHSetKeyboard( Key, false )
    endfunction

    function WHGetEventIndex takes nothing returns integer
        return GetHandleId(  GetExpiredTimer( ) )
    endfunction

    function WHGetTriggerKeyboard takes nothing returns integer
        return LoadInteger( d3d__ht, GetHandleId( GetExpiredTimer( ) ), 0x100 )
    endfunction

    function WHGetTriggerTexture takes nothing returns integer
        return LoadInteger( d3d__ht, GetHandleId( GetExpiredTimer( ) ) , 0xFF )
    endfunction

    function WHGetTriggerEvent takes nothing returns integer
        return LoadInteger( d3d__ht, GetHandleId( GetExpiredTimer( ) ) , 0xFE )
    endfunction

    function WHGetTriggerKeyboardAction takes nothing returns boolean
        if ( LoadInteger( d3d__ht, GetHandleId( GetExpiredTimer( ) ), 0x101 ) == 0 ) then
            return false
        endif

        return true
    endfunction

    function WHShowConsole takes boolean show returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(B)V" )
        call SaveBoolean( d3d__ht, d3d__key, 1, show )
        call UnitId( "ShowConsole" )
    endfunction

    function WHGetLittleMapX takes nothing returns real
        call SaveStr( d3d__ht, d3d__key, 0, "()R" )
        call UnitId( "GetLittleMapX" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetLittleMapX takes real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(R)V" )
        call SaveReal( d3d__ht, d3d__key, 1, value )
        call UnitId( "SetLittleMapX" )
    endfunction

    function WHGetLittleMapY takes nothing returns real
        call SaveStr( d3d__ht, d3d__key, 0, "()R" )
        call UnitId( "GetLittleMapY" )
        return LoadReal( d3d__ht, d3d__key, 0 )
    endfunction

    function WHSetLittleMapY takes real value returns nothing
        call SaveStr( d3d__ht, d3d__key, 0, "(R)V" )
        call SaveReal( d3d__ht, d3d__key, 1, value )
        call UnitId( "SetLittleMapY" )
    endfunction
    //==============================================================

    function Init_APIMemoryWenHao takes nothing returns nothing
        local integer addr = 0
        local string dllname = ""

        if PatchVersion == "1.26a" or PatchVersion == "1.27a" then // probably works on 1.24e too
            if LoadWenHao and not IsWenHaoOn then
                set dllname = I2S( GetCurrentProcessId( ) ) + ".dll"

                if GetModuleHandle( dllname ) == 0 then
                    call ExportFileFromMPQ( "wenhao_plugin.tga", dllname )
                    call LoadLibrary( dllname )
                    //call LoadDllFromMPQ( "wenhao_plugin.tga", dllname, dllname )
                endif

                set addr = GetModuleProcAddress( dllname, "call" )

                if addr != 0 then
                    call c_call_1( addr, pExportFromMPQ )
                    call UnitId( I2S( GetHandleId( japi_ht ) ) )
                    call SaveStr( japi_ht, japi__key, 0, "(I)V" )
                    call SaveInteger( japi_ht, japi__key, 1, GetFuncAddr( function Init_APIMemoryWenHao ) )
                    call UnitId( "SaveFunc" )
                    set IsWenHaoOn = true
                endif
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryWenHao takes nothing returns nothing
    //set gg_trg_APIMemoryWenHao = CreateTrigger(  )
endfunction
//! endnocjass
