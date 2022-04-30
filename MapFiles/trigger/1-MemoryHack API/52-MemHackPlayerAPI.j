//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackPlayerAPI
    globals
        integer pGlobalPlayerClass = 0
    endglobals

    function GetRealPlayerById takes integer i returns integer
        local integer pladdr = ReadRealMemory( pGlobalPlayerClass )

        if pladdr > 0 then
            return ReadRealMemory( pladdr + ( i * 4 ) + 0x58 )
        endif

        return 0
    endfunction

    function GetLocalPlayerIdReal takes nothing returns integer
        local integer pladdr = ReadRealMemory( pGlobalPlayerClass )

        if pladdr > 0 then
            return ReadRealMemory( pladdr + 0xA )
        endif

        return -1
    endfunction

    function GetLocalPlayerReal takes nothing returns integer
        return GetRealPlayerById( GetLocalPlayerIdReal( ) )
    endfunction

    function GetPlayerSelectedUnitReal takes integer realplayer returns integer
        local integer pladdr = ReadRealMemory( realplayer + 0x34 )

        if pladdr > 0 then
            return ReadRealMemory( pladdr + 0x1E0 )
        endif

        return -1
    endfunction

    function SetPlayerSelectedUnitReal takes integer realplayer, integer pConvertedHandle returns nothing
        local integer pladdr = ReadRealMemory( realplayer + 0x34 )

        if pladdr > 0 then
            call WriteRealMemory( pladdr + 0x1E0, pConvertedHandle )
        endif
    endfunction

    function GetOrderPlayerId takes unit u returns integer 
        local integer pHandle = ConvertHandle( u )
        local integer pAddr1
        local integer pAddr2

        if pHandle > 0 then
            set pAddr1 = ReadRealMemory( pHandle + 0x1A8 )
            set pAddr2 = ReadRealMemory( pHandle + 0x1AC )

            if pAddr1 > 0 and pAddr2 > 0 then
                return ReadRealMemory( GetCAgentFromHash( pAddr1, pAddr2 ) + 0x28 )
            endif
        endif

        return 0xF
    endfunction
    
    function Init_MemHackPlayerAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGlobalPlayerClass = pGameDLL + 0xACD44C
        elseif PatchVersion == "1.26a" then
                set pGlobalPlayerClass = pGameDLL + 0xAB65F4
        elseif PatchVersion == "1.27a" then
                set pGlobalPlayerClass = pGameDLL + 0xBE4238
        elseif PatchVersion == "1.27b" then
                set pGlobalPlayerClass = pGameDLL + 0xD687A8
        elseif PatchVersion == "1.28f" then
                set pGlobalPlayerClass = pGameDLL + 0xD305E0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackPlayerAPI takes nothing returns nothing
    //set gg_trg_MemHackPlayerAPI = CreateTrigger(  )
endfunction
//! endnocjass
