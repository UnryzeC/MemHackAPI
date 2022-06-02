//TESH.scrollpos=144
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCWidgetBaseAPI
    // Widget API Engine
    function GetWidgetTypeId takes widget w returns integer
        local integer pWidget = 0
        
        if w != null then
            set pWidget = ConvertHandle( w )
            
            if pWidget != 0 then
                return ReadRealMemory( pWidget + 0x30 )
            endif
        endif

        return 0
    endfunction

    function GetWidgetBaseDataById takes integer pDataNode, integer wid returns integer
        return GetAgileDataNodeById( pDataNode, wid )
    endfunction
    
    function GetWidgetBaseUIDataById takes integer id returns integer
        return GetWidgetUIDefById( id )
    endfunction

    function GetWidgetBaseData takes integer pDataNode, widget w returns integer
        return GetAgileDataNodeById( pDataNode, GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseDataByIdCachingEx takes integer pDataNode, integer index, integer id, integer mode returns integer
        local integer pData = 0

        if id > 0 then
            if HaveSavedInteger( htObjectDataPointers, index, id ) then 
                return LoadInteger( htObjectDataPointers, index, id )
            endif

            if mode == 0 then
                set pData = GetWidgetBaseDataById( pDataNode, id )
            elseif mode == 1 then
                set pData = GetWidgetBaseUIDataById( id )
            endif

            if pData > 0 then
                call SaveInteger( htObjectDataPointers, index, id, pData )
            endif

            return pData
        endif

        return 0
    endfunction
    
    function GetWidgetBaseDataByIdCaching takes integer pDataNode, integer id returns integer
        return GetWidgetBaseDataByIdCachingEx( pDataNode, 2, id, 0 ) // DEF_ADR_UNIT_DATA = 2 | BaseData = 0
    endfunction

    function GetWidgetBaseDataCaching takes integer pDataNode, widget w returns integer
        return GetWidgetBaseDataByIdCaching( pDataNode, GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseUIData takes widget w returns integer
        return GetWidgetBaseUIDataById( GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseUIDataByIdCaching takes integer id returns integer
        return GetWidgetBaseDataByIdCachingEx( 0, 3, id, 1 ) // DEF_ADR_UNIT_UI = 3 | UI = 1
    endfunction

    function GetWidgetBaseUIDataCaching takes widget w returns integer
        return GetWidgetBaseUIDataByIdCaching( GetWidgetTypeId( w ) )
    endfunction
    //===========================================
    
    // Widget Base UI Data Engine
    function GetWidgetBaseUIIntegerParamById takes integer id, integer pointerlevel, integer offset returns integer
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = ReadRealMemory( pData + offset )

                if pData > 0 then
                    if pointerlevel == 0 then
                        return pData
                elseif pointerlevel == 1 then
                        return ReadRealMemory( pData )
                    endif
                endif
            endif
        endif
        
        return 0
    endfunction

    function SetWidgetBaseUIIntegerParamById takes integer id, integer pointerlevel, integer offset, integer val returns nothing
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = pData + offset

                if offset == 0x274 then
                    call WriteRealMemory( pData, pData - 0x4 )
                else
                    if pointerlevel == 0 then
                        call WriteRealMemory( pData, val )
                elseif pointerlevel == 1 then
                        if ReadRealMemory( pData ) == 0 then
                            call WriteRealMemory( pData, GetStringAddress( I2S( val ) ) )
                        endif
                        call WriteRealMemory( ReadRealMemory( pData ), val )
                    endif
                endif
            endif
        endif
    endfunction

    function GetWidgetBaseUIStringParamById takes integer id, integer pointerlevel, integer offset returns string
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = ReadRealMemory( pData + offset )

                if pData > 0 then
                    if pointerlevel == 1 then
                        set pData = ReadRealMemory( pData )
                    endif

                    if pData > 0 then
                        return ToJString( pData )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetWidgetBaseUIStringParamById takes integer id, integer pointerlevel, integer offset, string val returns nothing
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = pData + offset

                if pointerlevel == 0 then
                    call WriteRealMemory( pData, GetStringAddress( val ) )
            elseif pointerlevel == 1 then
                    if ReadRealMemory( pData ) == 0 then
                        call WriteRealMemory( pData, GetStringAddress( val ) )
                    endif
                    call WriteRealMemory( ReadRealMemory( pData ), GetStringAddress( val ) )
                endif
            endif
        endif
    endfunction
    
    function Init_MemHackCWidgetBaseAPI takes nothing returns nothing
        if PatchVersion != "" then

        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackWidgetBaseAPI takes nothing returns nothing
    //set gg_trg_MemHackWidgetBaseAPI = CreateTrigger(  )
endfunction
//! endnocjass
