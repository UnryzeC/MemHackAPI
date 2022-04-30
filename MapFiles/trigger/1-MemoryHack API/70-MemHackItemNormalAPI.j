//TESH.scrollpos=9
//TESH.alwaysfold=0
//! nocjass
library MemoryHackItemNormalAPI
    globals
        integer pStartItemCD = 0
    endglobals

    function CItemStartCooldown takes integer pUnit, integer pItem, real cd returns nothing
        local integer pInv  = 0

        if pUnit > 0 and pItem > 0 then
            set pInv = ReadRealMemory( pUnit + 0x1F8 )

            if pInv > 0 then
                call WriteRealMemory( pReservedWritableMemory, SetRealIntoMemory( cd ) )
                call this_call_4( pStartItemCD, pInv, pItem, pReservedWritableMemory, pReservedWritableMemory )
            endif
        endif
    endfunction

    function CItemSetTypeId takes integer pItem, integer id returns nothing
        local integer oldId   = 0

        if pItem > 0 then
            set oldId = ReadRealMemory( pItem + 0x30 )

            if oldId > 0 then
                call WriteRealMemory( pItem + 0x30, id )
            endif
        endif
    endfunction
    
    function CItemSetModel takes integer pItem, string model returns nothing
        call SetObjectModel( pItem, model )
    endfunction
    
    function CItemGetLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x58 ) )
        endif
        
        return 0.
    endfunction

    function CItemSetLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x58, SetRealIntoMemory( life ) )
        endif
    endfunction

    function CItemGetMaxLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x60 ) )
        endif
        
        return 0.
    endfunction

    function CItemSetMaxLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x60, SetRealIntoMemory( life ) )
        endif
    endfunction

    function StartItemCooldown takes unit u, item it, real cd returns nothing
        call CItemStartCooldown( ConvertHandle( u ), ConvertHandle( it ), cd )
    endfunction

    function SetItemIdType takes item it, integer id returns nothing
        call CItemSetTypeId( ConvertHandle( it ), id )
    endfunction
    
    function SetItemModel takes item it, string model returns nothing
        call CItemSetModel( ConvertHandle( it ), model )
    endfunction
    
    function GetItemLife takes item it returns real
        return CItemGetLife( ConvertHandle( it ) )
    endfunction

    function SetItemLife takes item it, real life returns nothing
        call CItemSetLife( ConvertHandle( it ), life )
    endfunction

    function GetItemMaxLife takes item it returns real
        return CItemGetMaxLife( ConvertHandle( it ) )
    endfunction

    function SetItemMaxLife takes item it, real life returns nothing
        call CItemSetMaxLife( ConvertHandle( it ), life )
    endfunction

    function Init_MemHackItemNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pStartItemCD    = pGameDLL + 0x0E4B50
        elseif PatchVersion == "1.26a" then
                set pStartItemCD    = pGameDLL + 0x0E3F30
        elseif PatchVersion == "1.27a" then
                set pStartItemCD    = pGameDLL + 0x54C2E0
        elseif PatchVersion == "1.27b" then
                set pStartItemCD    = pGameDLL + 0x569A40
        elseif PatchVersion == "1.28f" then
                set pStartItemCD    = pGameDLL + 0x59DB70
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackItemNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackItemNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass