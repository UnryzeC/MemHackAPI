//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackPlayerAPI
    function GetCGameObjectStruct takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "Instance" ) )

        if addr != 0 then
            return ReadRealMemory( addr )
        endif

        return 0
    endfunction
    
    function GetRealPlayerById takes integer i returns integer
        local integer addr = GetCGameObjectStruct( )

        if addr != 0 then
            return ReadRealMemory( addr + ( i * 4 ) + 0x58 )
        endif

        return 0
    endfunction

    function GetLocalPlayerIdReal takes nothing returns integer
        local integer addr = GetCGameObjectStruct( )

        if addr != 0 then
            return ReadRealMemory( addr + 0xA )
        endif

        return -1
    endfunction

    function GetLocalPlayerReal takes nothing returns integer
        return GetRealPlayerById( GetLocalPlayerIdReal( ) )
    endfunction

    function GetPlayerSelectedUnitReal takes integer cplayer returns integer
        local integer addr = 0

        if cplayer != 0 then
            set addr = ReadRealMemory( addr + 0x34 )

            if addr != 0 then
                return ReadRealMemory( addr + 0x1E0 )
            endif
        endif

        return -1
    endfunction

    function SetPlayerSelectedUnitReal takes integer cplayer, integer pConvertedHandle returns nothing
        local integer addr = 0

        if cplayer != 0 and pConvertedHandle != 0 then
            set addr = ReadRealMemory( addr + 0x34 )

            if addr != 0 then
                call WriteRealMemory( addr + 0x1E0, pConvertedHandle )
            endif
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

        elseif PatchVersion == "1.26a" then

        elseif PatchVersion == "1.27a" then

        elseif PatchVersion == "1.27b" then

        elseif PatchVersion == "1.28f" then

            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackPlayerAPI takes nothing returns nothing
    //set gg_trg_MemHackPlayerAPI = CreateTrigger(  )
endfunction
//! endnocjass
