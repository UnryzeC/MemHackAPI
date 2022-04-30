//TESH.scrollpos=119
//TESH.alwaysfold=0
//! nocjass
library APIMemoryBitwise
    globals
        integer pBitwiseOR_ExecutableMemory
        boolean bNeedInitBitwiseOr             = true
        integer pBitwiseXOR_ExecutableMemory
        boolean bNeedInitBitwiseXor            = true
        integer pBitwiseAND_ExecutableMemory
        boolean bNeedInitBitwiseAnd            = true
    endglobals

    function GetGameTypeSupported takes nothing returns integer
        return ReadRealPointer2LVL( pGameState, 0x30, 0x30 )
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
        local integer retval
     
        if bNeedInitBitwiseOr then
            set bNeedInitBitwiseOr = false
            call WriteRealMemory( pBitwiseOR_ExecutableMemory + 0x0, 0x0424448B )
            call WriteRealMemory( pBitwiseOR_ExecutableMemory + 0x4, 0x0824548B )
            call WriteRealMemory( pBitwiseOR_ExecutableMemory + 0x8, 0xCCC3D009 )
        endif

        if pConvertUnitsOffset == 0 then
            set pConvertUnitsOffset = CreateJassNativeHook( pConvertUnits, pBitwiseOR_ExecutableMemory )
        else
            call WriteRealMemory( pConvertUnitsOffset, pBitwiseOR_ExecutableMemory )
        endif
     
        if pConvertUnitsOffset != 0 then
            set retval = B2I( ConvertUnits( arg1,arg2 ) )
            call WriteRealMemory( pConvertUnitsOffset, pConvertUnits )
            return retval
        endif

        return 0
    endfunction

    function BitwiseXor takes integer arg1, integer arg2 returns integer
        local integer retval
     
        if bNeedInitBitwiseXor then
            set bNeedInitBitwiseXor = false
            call WriteRealMemory( pBitwiseXOR_ExecutableMemory + 0x0, 0x0424448B )
            call WriteRealMemory( pBitwiseXOR_ExecutableMemory + 0x4, 0x0824548B )
            call WriteRealMemory( pBitwiseXOR_ExecutableMemory + 0x8, 0xCCC3D031 )
        endif
     
        if pConvertUnitsOffset == 0 then
            set pConvertUnitsOffset = CreateJassNativeHook( pConvertUnits, pBitwiseXOR_ExecutableMemory )
        else
            call WriteRealMemory( pConvertUnitsOffset, pBitwiseXOR_ExecutableMemory )
        endif
     
        if pConvertUnitsOffset != 0 then
            set retval = B2I( ConvertUnits( arg1,arg2 ) )
            call WriteRealMemory( pConvertUnitsOffset, pConvertUnits )
            return retval
        endif

        return 0
    endfunction

    function BitwiseAnd takes integer arg1, integer arg2 returns integer
        local integer retval
     
        if bNeedInitBitwiseAnd then
            set bNeedInitBitwiseAnd = false
            call WriteRealMemory( pBitwiseAND_ExecutableMemory + 0x0, 0x0424448B )
            call WriteRealMemory( pBitwiseAND_ExecutableMemory + 0x4, 0x0824548B )
            call WriteRealMemory( pBitwiseAND_ExecutableMemory + 0x8, 0xCCC3D021 )
        endif

        if pConvertUnitsOffset == 0 then
            set pConvertUnitsOffset = CreateJassNativeHook( pConvertUnits, pBitwiseAND_ExecutableMemory )
        else
            call WriteRealMemory( pConvertUnitsOffset, pBitwiseAND_ExecutableMemory )
        endif
     
        if pConvertUnitsOffset != 0 then
            set retval = B2I( ConvertUnits( arg1,arg2 ) )
            call WriteRealMemory( pConvertUnitsOffset, pConvertUnits )
            return retval
        endif

        return 0
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

            set pBitwiseOR_ExecutableMemory  = AllocateExecutableMemory( 0xC )
            set pBitwiseXOR_ExecutableMemory = AllocateExecutableMemory( 0xC )
            set pBitwiseAND_ExecutableMemory = AllocateExecutableMemory( 0xC )
            
            loop
                exitwhen i > 0x8
                call WriteRealMemory( pBitwiseOR_ExecutableMemory + i, 0 )
                call WriteRealMemory( pBitwiseXOR_ExecutableMemory + i, 0 )
                call WriteRealMemory( pBitwiseAND_ExecutableMemory + i, 0 )
                set i = i + 4
            endloop
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryBitwise takes nothing returns nothing
    //set gg_trg_APIMemoryBitwise = CreateTrigger(  )
endfunction
//! endnocjass
