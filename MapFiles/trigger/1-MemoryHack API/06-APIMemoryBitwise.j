//TESH.scrollpos=53
//TESH.alwaysfold=0
//! nocjass
library APIMemoryBitwise
    function GetGameTypeSupported takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ) )

        if addr != 0 then
            return ReadRealPointer2LVL( addr, 0x30, 0x30 )
        endif
    
        return 0
    endfunction

    function Player2Flag takes player p returns integer
        return R2I( Pow( 2, GetPlayerId( p ) ) )
    endfunction

    function IsFlagBitSet takes integer flags, integer bit returns boolean
        return flags / bit * 2147483648 != 0
    endfunction

    function ShiftLeftForBits takes integer byte, integer shiftval returns integer
        return byte * ( PowI( 2, shiftval ) )
    endfunction
    
    function ShiftRightForBits takes integer byte, integer shiftval returns integer
        return byte / ( PowI( 2, shiftval ) )
    endfunction
    
    function ShiftLeftForBytes takes integer byte, integer shiftval returns integer
        return ShiftLeftForBits( byte, shiftval * 8 )
    endfunction
    
    function ShiftRightForBytes takes integer byte, integer shiftval returns integer
        return ShiftRightForBits( byte, shiftval * 8 )
    endfunction

    function BitwiseOr takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "OR" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isOR" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isOR" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D009 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function BitwiseXor takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "XOR" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isXOR" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isXOR" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D031 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function BitwiseAnd takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "AND" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isAND" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isAND" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D021 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function Init_APIMemoryBitwise takes nothing returns nothing
        local integer i = 0

        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif

            call AllocExecMemEx( "Bitwise",  "OR", 0xC )
            call AllocExecMemEx( "Bitwise", "XOR", 0xC )
            call AllocExecMemEx( "Bitwise", "AND", 0xC )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryBitwise takes nothing returns nothing
    //set gg_trg_APIMemoryBitwise = CreateTrigger(  )
endfunction
//! endnocjass
