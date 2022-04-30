//TESH.scrollpos=12
//TESH.alwaysfold=0
//! nocjass
library MemoryHackGroupAPI
    globals
        integer iGroupIterator       = 0
        integer pGroupGetUnitByIndex = 0
    endglobals

    function GetAddressGroupUnitCount takes integer pObj returns integer
        if pObj > 0 then
            return ReadRealMemory( pObj + 0x34 )
        endif
        
        return 0
    endfunction

    function GetAddressGroupAddressUnitByIndex takes integer pObj, integer index returns integer
        if pObj > 0 then
            return this_call_2( pGroupGetUnitByIndex, pObj + 0x24, index )
        endif

        return 0
    endfunction

    function GetGroupUnitCount takes group g returns integer
        return GetAddressGroupUnitCount( ConvertHandle( g ) )
    endfunction
    
    function GetUnitFromGroupByIndex takes group g, integer index returns unit
        local integer pObj = GetAddressGroupAddressUnitByIndex( ConvertHandle( g ), index )

        if pObj > 0 then
            set pObj = ObjectToHandleId( pObj )

            if pObj > 0 then
                return I2U( pObj )
            endif
        endif

        return null
    endfunction
    
    function GetRandomUnitFromGroup takes group g returns unit
        local integer pObj  = ConvertHandle( g )
        local integer count = 0
        
        if pObj > 0 then
            set count = GetAddressGroupUnitCount( pObj )
            if count > 0 then
                set pObj  = GetAddressGroupAddressUnitByIndex( pObj, GetRandomInt( 0, count - 1 ) )

                if pObj > 0 then
                    set pObj = ObjectToHandleId( pObj )
                    
                    if pObj > 0 then
                        return I2U( pObj )
                    endif
                endif
            endif
        endif

        return null
    endfunction
    
    function ForEach takes group g returns unit
        local integer pObj = GetAddressGroupAddressUnitByIndex( ConvertHandle( g ), iGroupIterator )

         if pObj > 0 then
            set iGroupIterator = iGroupIterator + 1
            set pObj = ObjectToHandleId( pObj )

            if pObj > 0 then
                return I2U( pObj )
            endif
        else
            set iGroupIterator = 0
        endif

        return null
    endfunction

    function Init_MemHackGroupAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGroupGetUnitByIndex = pGameDLL + 0x422560
        elseif PatchVersion == "1.26a" then
                set pGroupGetUnitByIndex = pGameDLL + 0x421A20
        elseif PatchVersion == "1.27a" then
                set pGroupGetUnitByIndex = pGameDLL + 0x272910
        elseif PatchVersion == "1.27b" then
                set pGroupGetUnitByIndex = pGameDLL + 0x290570
        elseif PatchVersion == "1.28f" then
                set pGroupGetUnitByIndex = pGameDLL + 0x230AA0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackGroupAPI takes nothing returns nothing
    //set gg_trg_MemHackGroupAPI = CreateTrigger(  )
endfunction
//! endnocjass
