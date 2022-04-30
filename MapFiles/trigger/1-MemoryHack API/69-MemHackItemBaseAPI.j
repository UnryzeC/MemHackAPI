//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackItemBaseAPI
    globals
        integer pItemDataNode = 0
    endglobals

    // Item API Engine
    function GetItemBaseDataById takes integer iid returns integer
        return GetAgileDataNodeById( pItemDataNode, iid )
    endfunction

    function GetItemBaseData takes item it returns integer
        return GetItemBaseDataById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseDataByIdCaching takes integer iid returns integer
        return GetWidgetBaseDataByIdCachingEx( pItemDataNode, 2, iid, 0 ) // Base Item Data
    endfunction

    function GetItemBaseDataCaching takes item it returns integer
        return GetItemBaseDataByIdCaching( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseUIDataById takes integer iid returns integer
        return GetWidgetBaseUIDataById( iid )
    endfunction

    function GetItemBaseUIData takes item it returns integer
        return GetItemBaseUIDataById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseUIDataByIdCaching takes integer iid returns integer
        return GetWidgetBaseDataByIdCachingEx( 0, 3, iid, 1 ) // Base Item UI Data | pUnitUIDataNode - no longer necessary
    endfunction

    function GetItemBaseUIDataCaching takes item it returns integer
        return GetItemBaseUIDataByIdCaching( GetItemTypeId( it ) )
    endfunction
    //===========================================

    // Item Base UI Data API by Id
    function GetItemBaseUIStringParamById takes integer iid, integer pointerlevel, integer offset returns string
        return GetWidgetBaseUIStringParamById( iid, pointerlevel, offset )
    endfunction
    
    function SetItemBaseUIStringParamById takes integer iid, integer pointerlevel, integer offset, string text returns nothing
        call SetWidgetBaseUIStringParamById( iid, pointerlevel, offset, text )
    endfunction

    function GetItemBaseNameById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x2C )
    endfunction

    function SetItemBaseNameById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x2C, text )
    endfunction

    function GetItemBaseIconPathById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x24C )
    endfunction

    function SetItemBaseIconPathById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x24C, text )
    endfunction
    
    function GetItemBaseTipById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x260 )
    endfunction

    function SetItemBaseTipById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x260, text )
    endfunction

    function GetItemBaseUbertipById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x26C )
    endfunction

    function SetItemBaseUbertipById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x26C, text )
    endfunction

    function GetItemBaseHotkeyById takes integer iid returns integer
        if iid > 0 then
            if GetWidgetBaseUIIntegerParamById( iid, 0, 0x270 ) > 0 or GetWidgetBaseUIIntegerParamById( iid, 0, 0x274 ) > 0 then
                return GetWidgetBaseUIIntegerParamById( iid, 1, 0x278 )
            endif
        endif
    
        return 0
    endfunction

    function SetItemBaseHotkeyById takes integer iid, integer key returns nothing
        if iid > 0 then
            call SetWidgetBaseUIIntegerParamById( iid, 0, 0x270,   1 )
            call SetWidgetBaseUIIntegerParamById( iid, 0, 0x274, key )
            call SetWidgetBaseUIIntegerParamById( iid, 1, 0x278, key )
        endif
    endfunction
    //===========================================
    
    // Item Base UI Data API
    function GetItemBaseUIStringParam takes item it, integer pointerlevel, integer offset returns string
        return GetItemBaseUIStringParamById( GetItemTypeId( it ), pointerlevel, offset )
    endfunction
    
    function SetItemBaseUIStringParam takes item it, integer pointerlevel, integer offset, string text returns nothing
        call SetItemBaseUIStringParamById( GetItemTypeId( it ), pointerlevel, offset, text )
    endfunction

    function GetItemBaseName takes item it returns string
        return GetItemBaseNameById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseName takes item it, string text returns nothing
        call SetItemBaseNameById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseIconPath takes item it returns string
        return GetItemBaseIconPathById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseIconPath takes item it, string text returns nothing
        call SetItemBaseIconPathById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseTip takes item it returns string
        return GetItemBaseTipById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseTip takes item it, string text returns nothing
        call SetItemBaseTipById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseUbertip takes item it returns string
        return GetItemBaseUbertipById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseUbertip takes item it, string text returns nothing
        call SetItemBaseUbertipById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseHotkey takes item it returns integer
        return GetItemBaseHotkeyById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseHotkey takes item it, integer key returns nothing
        call SetItemBaseHotkeyById( GetItemTypeId( it ), key )
    endfunction
    //===========================================
    
    // Item Base Data API by Id
    function GetItemBaseTypeIdById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x14 )
        endif

        return 0
    endfunction

    function GetItemBaseGoldCostById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return 0
    endfunction

    function SetItemBaseGoldCostById takes integer iid, integer cost returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x20, cost )
        endif
    endfunction

    function GetItemBaseLumberCostById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x24 )
        endif

        return 0
    endfunction

    function SetItemBaseLumberCostById takes integer iid, integer cost returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x24, cost )
        endif
    endfunction

    function GetItemBaseLevelById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x38 )
        endif

        return 0
    endfunction

    function SetItemBaseLevelById takes integer iid, integer level returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x38, level )
        endif
    endfunction

    function IsItemBaseSellableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x50 ) > 1
        endif

        return false
    endfunction

    function IsItemBasePawnableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x54 ) > 1
        endif

        return false
    endfunction

    function IsItemBaseDroppableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x60 ) > 1
        endif

        return false
    endfunction

    function IsItemBaseDroppedOnDeathById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x64 ) > 1
        endif

        return false
    endfunction
    //===========================================

    // Item Base UI Data API
    function GetItemBaseTypeId takes item it returns integer
        return GetItemBaseTypeIdById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseGoldCost takes item it returns integer
        return GetItemBaseGoldCostById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseGoldCost takes item it, integer cost returns nothing
        call SetItemBaseGoldCostById( GetItemTypeId( it ), cost )
    endfunction

    function GetItemBaseLumberCost takes item it returns integer
        return GetItemBaseLumberCostById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseLumberCost takes item it, integer cost returns nothing
        call SetItemBaseLumberCostById( GetItemTypeId( it ), cost )
    endfunction

    function GetItemBaseLevel takes item it returns integer
        return GetItemBaseLevelById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseLevel takes item it, integer lvl returns nothing
        call SetItemBaseLevelById( GetItemTypeId( it ), lvl )
    endfunction

    function IsItemBaseSellable takes item it returns boolean
        return IsItemBaseSellableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBasePawnable takes item it returns boolean
        return IsItemBasePawnableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBaseDroppable takes item it returns boolean
        return IsItemBaseDroppableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBaseDroppedOnDeath takes item it returns boolean
        return IsItemBaseDroppedOnDeathById( GetItemTypeId( it ) )
    endfunction
    //===========================================

    function Init_MemHackItemBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pItemDataNode = pGameDLL + 0xACBA24
        elseif PatchVersion == "1.26a" then
                set pItemDataNode = pGameDLL + 0xAB4BCC
        elseif PatchVersion == "1.27a" then
                set pItemDataNode = pGameDLL + 0xBEC238
        elseif PatchVersion == "1.27b" then
                set pItemDataNode = pGameDLL + 0xD707A0
        elseif PatchVersion == "1.28f" then
                set pItemDataNode = pGameDLL + 0xD385D8
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackItemBaseAPI takes nothing returns nothing
    //set gg_trg_MemHackItemNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass