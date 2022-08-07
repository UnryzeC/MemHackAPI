//TESH.scrollpos=293
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUnitBaseAPI
    // Unit API Engine
    function GetUnitBaseDataById takes integer uid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ) )

        if addr != 0 and uid != 0 then
            return GetAgileDataNodeById( addr, uid )
        endif

        return 0
    endfunction

    function GetUnitBaseData takes unit u returns integer
        return GetUnitBaseDataById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseDataByIdCaching takes integer uid returns integer
        // DEF_ADR_UNIT_DATA = 2
        local integer pUnit = 0

        if uid > 0 then
            if HaveSavedInteger( htObjectDataPointers, 2, uid ) then 
                return LoadInteger( htObjectDataPointers, 2, uid )
            endif

            set pUnit = GetUnitBaseDataById( uid )

            if pUnit > 0 then
                call SaveInteger( htObjectDataPointers, 2, uid, pUnit )
            endif

            return pUnit
        endif

        return 0
    endfunction

    function GetUnitBaseDataCaching takes unit u returns integer
        return GetUnitBaseDataByIdCaching( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseUIDataById takes integer uid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ) )

        if addr != 0 and uid != 0 then
            return GetWidgetUIDefById( uid )
        endif

        return 0
    endfunction

    function GetUnitBaseUIData takes unit u returns integer
        return GetUnitBaseUIDataById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseUIDataByIdCaching takes integer uid returns integer
        // DEF_ADR_UNIT_UI = 3
        local integer pUnit = 0

        if uid > 0 then
            if HaveSavedInteger( htObjectDataPointers, 3, uid ) then 
                return LoadInteger( htObjectDataPointers, 3, uid )
            endif

            set pUnit = GetUnitBaseUIDataById( uid )
            if pUnit > 0 then
                call SaveInteger( htObjectDataPointers, 3, uid, pUnit )
            endif

            return pUnit
        endif

        return 0
    endfunction

    function GetUnitBaseUIDataCaching takes unit u returns integer
        return GetUnitBaseUIDataByIdCaching( GetUnitTypeId( u ) )
    endfunction
    //===========================================

    // Unit Base UI Data Engine
    function GetUnitBaseUIIntegerParam takes integer uid, integer pointerlevel, integer offset returns integer
        return GetWidgetBaseUIIntegerParamById( uid, pointerlevel, offset )
    endfunction

    function SetUnitBaseUIIntegerParam takes integer uid, integer pointerlevel, integer offset, integer val returns nothing
        call SetWidgetBaseUIIntegerParamById( uid, pointerlevel, offset, val )
    endfunction

    function GetUnitBaseUIStringParam takes integer uid, integer pointerlevel, integer offset returns string
        return GetWidgetBaseUIStringParamById( uid, pointerlevel, offset )
    endfunction

    function SetUnitBaseUIStringParam takes integer uid, integer pointerlevel, integer offset, string val returns nothing
        call SetWidgetBaseUIStringParamById( uid, pointerlevel, offset, val )
    endfunction
    //===========================================
    
    // Unit Base UI Data API by Id
    function GetUnitBasePortraitById takes integer uid returns string
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x38 )

                if pData > 0 then
                    return ToJString( pData )
                endif
            endif
        endif

        return null
    endfunction

    function SetUnitBasePortraitById takes integer uid, string model returns nothing
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                call WriteRealMemory( pData + 0x38, GetStringAddress( model ) )
            endif
        endif
    endfunction

    function GetUnitBaseMissileArtById takes integer uid, integer index returns string
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
        
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x44 )

                    if pData > 0 then
                        return ToJString( ReadRealMemory( pData + index * 4 ) )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetUnitBaseMissileArtById takes integer uid, string model, integer index returns nothing
        local integer pData = 0
    
        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )

                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x44 )
        
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, GetStringAddress( model ) )
                    endif
                endif
            endif
        endif
    endfunction

    function GetUnitBaseMissileSpeedById takes integer uid, integer index returns real
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x64 )
    
                    if pData > 0 then
                        return ReadRealFloat( pData + index * 4 )
                    endif
                endif
            endif
        endif

        return -1.
    endfunction

    function SetUnitBaseMissileSpeedById takes integer uid, integer index, real speed returns nothing
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x64 )
    
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, SetRealIntoMemory( speed ) )
                    endif
                endif
            endif
        endif
    endfunction

    function GetUnitBaseMissileArcById takes integer uid, integer index returns real
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x70 )
    
                    if pData > 0 then
                        return ReadRealFloat( pData + index * 4 )
                    endif
                endif
            endif
        endif

        return -1.
    endfunction

    function SetUnitBaseMissileArcById takes integer uid, integer index, real arc returns nothing
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x70 )
    
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, SetRealIntoMemory( arc ) )
                    endif
                endif
            endif
        endif
    endfunction
    
    function GetUnitBaseColorById takes integer uid returns integer
        local integer pData = 0
    
        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )
    
            if pData > 0 then
                return ReadRealMemory( pData + 0xAC )
            endif
        endif
    
        return 0
    endfunction

    function GetUnitBaseModelById takes integer uid returns string
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x34 )
    
                if pData > 0 then
                    return ToJString( pData )
                endif
            endif
        endif

        return ""
    endfunction

    function SetUnitBaseModelById takes integer uid, string model returns nothing
        local integer pData = 0
    
        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )
    
            if pData > 0 then
                call WriteRealMemory( pData + 0x34, GetStringAddress( model ) )
                //call WriteNullTerminatedString( model, pData + 0x34 )
            endif
        endif
    endfunction
    
    function GetUnitBaseIconPathById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x24C )
    endfunction

    function SetUnitBaseIconPathById takes integer uid, string iconpath returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x24C, iconpath )
    endfunction
    
    function GetUnitBaseTipById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x260 )
    endfunction

    function SetUnitBaseTipById takes integer uid, string text returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x260, text )
    endfunction

    function GetUnitBaseUbertipById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x26C )
    endfunction

    function SetUnitBaseUbertipById takes integer uid, string text returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x26C, text )
    endfunction

    function GetUnitBaseHotkeyById takes integer uid returns integer
        if uid > 0 then
            if GetUnitBaseUIIntegerParam( uid, 0, 0x270 ) > 0 or GetUnitBaseUIIntegerParam( uid, 0, 0x274 ) > 0 then
                return GetUnitBaseUIIntegerParam( uid, 1, 0x278 )
            endif
        endif
    
        return 0
    endfunction

    function SetUnitBaseHotkeyById takes integer uid, integer key returns nothing
        if uid > 0 then
            call SetUnitBaseUIIntegerParam( uid, 0, 0x270,   1 )
            call SetUnitBaseUIIntegerParam( uid, 0, 0x274, key )
            call SetUnitBaseUIIntegerParam( uid, 1, 0x278, key )
        endif
    endfunction
    //===========================================

    // Unit Base UI Data API by Unit
    function GetUnitBaseModel takes unit u returns string
        return GetUnitBaseModelById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseModel takes unit u, string model returns nothing
        call SetUnitBaseModelById( GetUnitTypeId( u ), model )
    endfunction

    function GetUnitBasePortrait takes unit u returns string
        return GetUnitBasePortraitById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBasePortrait takes unit u, string model returns nothing
        call SetUnitBasePortraitById( GetUnitTypeId( u ), model )
    endfunction

    function GetUnitBaseMissileArt takes unit u, integer index returns string
        return GetUnitBaseMissileArtById( GetUnitTypeId( u ), index )
    endfunction

    function SetUnitBaseMissileArt takes unit u, string model, integer index returns nothing
        call SetUnitBaseMissileArtById( GetUnitTypeId( u ), model, index )
    endfunction

    function GetUnitBaseMissileSpeed takes unit u, integer index returns real
        return GetUnitBaseMissileSpeedById( GetUnitTypeId( u ), index )
    endfunction

    function SetUnitBaseMissileSpeed takes unit u, integer index, real speed returns nothing
        call SetUnitBaseMissileSpeedById( GetUnitTypeId( u ), index, speed )
    endfunction

    function GetUnitBaseColor takes unit u returns integer
        return GetUnitBaseColorById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseIconPath takes unit u returns string
        return GetUnitBaseIconPathById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitBaseIconPath takes unit u, string iconpath returns nothing
        call SetUnitBaseIconPathById( GetUnitTypeId( u ), iconpath )
    endfunction
    
    function GetUnitBaseTip takes unit u returns string
        return GetUnitBaseTipById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseTip takes unit u, string text returns nothing
        call SetUnitBaseTipById( GetUnitTypeId( u ), text )
    endfunction

    function GetUnitBaseUbertip takes unit u returns string
        return GetUnitBaseUbertipById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseUbertip takes unit u, string text returns nothing
        call SetUnitBaseUbertipById( GetUnitTypeId( u ), text )
    endfunction

    function GetUnitBaseHotkey takes unit u returns integer
        return GetUnitBaseHotkeyById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseHotkey takes unit u, integer key returns nothing
        call SetUnitBaseHotkeyById( GetUnitTypeId( u ), key )
    endfunction
    //===========================================

    // Unit Base Data API by Id
    function GetUnitGoldCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return -1
    endfunction
    
    function SetUnitGoldCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x20, value )
        endif
    endfunction

    function GetUnitLumberCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x24 )
        endif

        return -1
    endfunction
    
    function SetUnitLumberCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x24, value )
        endif
    endfunction
    
    function GetUnitFoodCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x5C )
        endif

        return -1
    endfunction
    
    function SetUnitFoodCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x5C, value )
        endif
    endfunction
    
    function GetHeroBasePrimaryAttributeById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x17C )
        endif

        return -1
    endfunction

    function SetHeroBasePrimaryAttributeById takes integer uid, integer index returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            if index >= 0 and index <= 2 then
                call WriteRealMemory( pData + 0x17C, index )
            endif
        endif
    endfunction

    function GetUnitCollisionSizeById takes integer uid returns real
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + 0x19C ) )
        endif

        return -1.234 // to ensure we failed
    endfunction
    //===========================================

    // Unit Base Data API by unit
    function GetUnitGoldCostEx takes unit u returns integer
        return GetUnitGoldCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitGoldCostEx takes unit u, integer value returns nothing
        call SetUnitGoldCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetUnitLumberCost takes unit u returns integer
        return GetUnitLumberCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitLumberCost takes unit u, integer value returns nothing
        call SetUnitLumberCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetUnitFoodCost takes unit u returns integer
        return GetUnitFoodCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitFoodCost takes unit u, integer value returns nothing
        call SetUnitFoodCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetHeroBasePrimaryAttribute takes unit u returns integer
        return GetHeroBasePrimaryAttributeById( GetUnitTypeId( u ) )
    endfunction

    function SetHeroBasePrimaryAttribute takes unit u, integer index returns nothing
        call SetHeroBasePrimaryAttributeById( GetUnitTypeId( u ), index )
    endfunction
    
    function GetUnitCollisionSize takes unit u returns real
        return GetUnitCollisionSizeById( GetUnitTypeId( u ) )
    endfunction
    //===========================================

    function Init_MemHackUnitBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xACB2B4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xACC72C )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x32D3C0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xAB445C )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xAB58D4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x32C880 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xBEC470 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xBE6114 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x327020 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xD709D8 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xBE6114 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x344760 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xD38810 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xD324B4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x378720 )
            endif
        endif
    endfunction
    //===========================================
endlibrary

//===========================================================================
function InitTrig_MemHackUnitBaseAPI takes nothing returns nothing
    //set gg_trg_MemHackUnitBaseAPI = CreateTrigger(  )
endfunction
//! endnocjass
