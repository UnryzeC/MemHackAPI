//TESH.scrollpos=3
//TESH.alwaysfold=0
//! nocjass
native MergeUnits   takes integer qty, integer a, integer b, integer make returns boolean    // reserved native for call 4 integer function and return BOOLEAN value
native ConvertUnits takes integer qty, integer id returns boolean                            // reserved native for call 2 integer function and return BOOLEAN value (can be converted to int!)
native IgnoredUnits takes integer unitid returns integer                                     // reserved native for call 1 integer function and return integer value
native GetUnitCount takes integer addr returns integer                                       // reserved native for FastReadMemory call 1 integer function and return integer value
native AttackMoveXY takes integer addr, integer val returns nothing                          // reserved native for FastWriteMemory call 2 integer function and return integer value

library APIMemoryAllCalls
    globals
        integer AllocatedMemorySize         = 0

        integer pMergeUnits                 = 0
        integer pMergeUnitsOffset           = 0
        integer pIgnoredUnits               = 0
        integer pIgnoredUnitsOffset         = 0
        integer pConvertUnits               = 0
        integer pConvertUnitsOffset         = 0
        integer pGetUnitCount               = 0
        integer pGetUnitCountOffset         = 0
        integer pAttackMoveXY               = 0
        integer pAttackMoveXYOffset         = 0

        integer pMemcpy                     = 0

        integer pGetModuleHandle            = 0
        integer pGetProcAddress             = 0

        integer pVirtualAlloc               = 0
        integer pVirtualProtect             = 0

        //Pointers for calls Start
        integer pFastRead         = 0
        integer pFastWrite        = 0        

        integer pfast_call_1      = 0
        integer pfast_call_2      = 0
        integer pfast_call_3      = 0
        integer pfast_call_4      = 0
        integer pfast_call_5      = 0
        integer pfast_call_6      = 0
        integer pfast_call_7      = 0
        integer pfast_call_8      = 0
        integer pfast_call_9      = 0
        integer pfast_call_10     = 0
        integer pfast_call_11     = 0
        integer pfast_call_12     = 0
        integer pfast_call_13     = 0

        integer pstd_call_1       = 0
        integer pstd_call_2       = 0
        integer pstd_call_3       = 0
        integer pstd_call_4       = 0
        integer pstd_call_5       = 0
        integer pstd_call_6       = 0

        integer pc_call_1         = 0
        integer pc_call_2         = 0
        integer pc_call_3         = 0
        integer pc_call_4         = 0
        integer pc_call_5         = 0
        integer pc_call_6         = 0
        //Pointers for calls End
    endglobals

    // Explanation:
    // We write assembler in a reversed order, since that is how our written memory will translate to machine code
    // Example: 0xB9F68B56 which is B9 F6 8B 56 => but in fact it will be 0x568BF6B9 or 56 8B F6 B9
    // To translate machine code to asm you can use: https://defuse.ca/online-x86-assembler.htm#disassembly2

    function InitFastReadMemory takes nothing returns nothing
		if pGetUnitCount != 0 then
			call WriteRealMemory( pFastRead + 0x0, 0x0424448B )
			call WriteRealMemory( pFastRead + 0x4, 0x90C3008B )
			set pGetUnitCountOffset = CreateJassNativeHook( pGetUnitCount, pFastRead )
		endif
    endfunction

    function InitFastWriteMemory takes nothing returns nothing
		if pAttackMoveXY != 0 then
			call WriteRealMemory( pFastWrite + 0x0, 0x246C8B55 )
			call WriteRealMemory( pFastWrite + 0x4, 0x24448B0C )
			call WriteRealMemory( pFastWrite + 0x8, 0x5D288908 )
			call WriteRealMemory( pFastWrite + 0xC, 0x000090C3 )
			set pAttackMoveXYOffset = CreateJassNativeHook( pAttackMoveXY, pFastWrite )
		endif
    endfunction

    function fast_call_1 takes integer pFuncFastcallAddr, integer arg1 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_1 ) == 0 then
            call WriteRealMemory( pfast_call_1 +  0x0, 0xB9F68B56 ) // push esi | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_1 +  0x8, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_1 + 0x10, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_1 +  0x4, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_1 +  0xC, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_1 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_1 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_2 takes integer pFuncFastcallAddr, integer arg1, integer arg2 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_2 ) == 0 then
            call WriteRealMemory( pfast_call_2 + 0x00, 0xBAF68B56 ) // push esi | mov esi, esi | edx (arg2)
            call WriteRealMemory( pfast_call_2 + 0x08, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_2 + 0x10, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_2 + 0x18, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_2 + 0x04, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_2 + 0x0C, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_2 + 0x14, pFuncFastcallAddr )  // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_2 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_2 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_3 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_3 ) == 0 then
            call WriteRealMemory( pfast_call_3 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg3
            call WriteRealMemory( pfast_call_3 + 0x08, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_3 + 0x10, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_3 + 0x18, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_3 + 0x20, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_3 + 0x04, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_3 + 0x0C, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_3 + 0x14, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_3 + 0x1C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_3 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_3 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_4 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_4 ) == 0 then
            call WriteRealMemory( pfast_call_4 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg4
            call WriteRealMemory( pfast_call_4 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_4 + 0x10, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_4 + 0x18, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_4 + 0x20, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_4 + 0x28, 0xC35ED6FF ) // call esi | pop esi | ret
        endif
        
        call WriteRealMemory( pfast_call_4 + 0x04, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_4 + 0x0C, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_4 + 0x14, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_4 + 0x1C, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_4 + 0x24, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_4 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_4 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_5 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_5 ) == 0 then
            call WriteRealMemory( pfast_call_5 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg5
            call WriteRealMemory( pfast_call_5 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_5 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_5 + 0x18, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_5 + 0x20, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_5 + 0x28, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_5 + 0x30, 0xC35ED6FF ) // call esi | pop esi | ret
        endif
        
        call WriteRealMemory( pfast_call_5 + 0x04, arg5 ) // push arg5
        call WriteRealMemory( pfast_call_5 + 0x0C, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_5 + 0x14, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_5 + 0x1C, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_5 + 0x24, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_5 + 0x2C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_5 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_5 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_6 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_6 ) == 0 then
            call WriteRealMemory( pfast_call_6 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg6
            call WriteRealMemory( pfast_call_6 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_6 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_6 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_6 + 0x20, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_6 + 0x28, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_6 + 0x30, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_6 + 0x38, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_6 + 0x04, arg6 ) // push arg6
        call WriteRealMemory( pfast_call_6 + 0x0C, arg5 ) // push arg5
        call WriteRealMemory( pfast_call_6 + 0x14, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_6 + 0x1C, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_6 + 0x24, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_6 + 0x2C, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_6 + 0x34, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_6 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_6 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_7 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_7 ) == 0 then
            call WriteRealMemory( pfast_call_7 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg7
            call WriteRealMemory( pfast_call_7 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_7 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_7 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_7 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_7 + 0x28, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_7 + 0x30, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_7 + 0x38, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_7 + 0x40, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_7 + 0x04, arg7 ) // push arg7
        call WriteRealMemory( pfast_call_7 + 0x0C, arg6 ) // push arg6
        call WriteRealMemory( pfast_call_7 + 0x14, arg5 ) // push arg5
        call WriteRealMemory( pfast_call_7 + 0x1C, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_7 + 0x24, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_7 + 0x2C, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_7 + 0x34, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_7 + 0x3C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_7 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_7 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_8 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_8 ) == 0 then
            call WriteRealMemory( pfast_call_8 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg8
            call WriteRealMemory( pfast_call_8 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_8 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_8 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_8 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_8 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_8 + 0x30, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_8 + 0x38, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_8 + 0x40, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_8 + 0x48, 0xC35ED6FF ) // call esi | pop esi | ret
        endif
        
        call WriteRealMemory( pfast_call_8 + 0x04, arg8 ) // push arg8
        call WriteRealMemory( pfast_call_8 + 0x0C, arg7 ) // push arg7
        call WriteRealMemory( pfast_call_8 + 0x14, arg6 ) // push arg6
        call WriteRealMemory( pfast_call_8 + 0x1C, arg5 ) // push arg5
        call WriteRealMemory( pfast_call_8 + 0x24, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_8 + 0x2C, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_8 + 0x34, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_8 + 0x3C, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_8 + 0x44, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_8 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_8 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_9 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_9 ) == 0 then
            call WriteRealMemory( pfast_call_9 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg9
            call WriteRealMemory( pfast_call_9 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg8
            call WriteRealMemory( pfast_call_9 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_9 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_9 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_9 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_9 + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_9 + 0x38, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_9 + 0x40, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_9 + 0x48, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_9 + 0x50, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_9 + 0x04, arg9 ) // push arg9
        call WriteRealMemory( pfast_call_9 + 0x0C, arg8 ) // push arg8
        call WriteRealMemory( pfast_call_9 + 0x14, arg7 ) // push arg7
        call WriteRealMemory( pfast_call_9 + 0x1C, arg6 ) // push arg6
        call WriteRealMemory( pfast_call_9 + 0x24, arg5 ) // push arg5
        call WriteRealMemory( pfast_call_9 + 0x2C, arg4 ) // push arg4
        call WriteRealMemory( pfast_call_9 + 0x34, arg3 ) // push arg3
        call WriteRealMemory( pfast_call_9 + 0x3C, arg2 ) // mov edx arg2
        call WriteRealMemory( pfast_call_9 + 0x44, arg1 ) // mov ecx arg1
        call WriteRealMemory( pfast_call_9 + 0x4C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_9 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_9 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_10 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_10 ) == 0 then
            call WriteRealMemory( pfast_call_10 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg10
            call WriteRealMemory( pfast_call_10 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg9
            call WriteRealMemory( pfast_call_10 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg8
            call WriteRealMemory( pfast_call_10 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_10 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_10 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_10 + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_10 + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_10 + 0x40, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_10 + 0x48, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_10 + 0x50, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_10 + 0x58, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_10 + 0x04, arg10 ) // push arg10
        call WriteRealMemory( pfast_call_10 + 0x0C, arg9  ) // push arg9
        call WriteRealMemory( pfast_call_10 + 0x14, arg8  ) // push arg8
        call WriteRealMemory( pfast_call_10 + 0x1C, arg7  ) // push arg7
        call WriteRealMemory( pfast_call_10 + 0x24, arg6  ) // push arg6
        call WriteRealMemory( pfast_call_10 + 0x2C, arg5  ) // push arg5
        call WriteRealMemory( pfast_call_10 + 0x34, arg4  ) // push arg4
        call WriteRealMemory( pfast_call_10 + 0x3C, arg3  ) // push arg3
        call WriteRealMemory( pfast_call_10 + 0x44, arg2  ) // mov edx arg2
        call WriteRealMemory( pfast_call_10 + 0x4C, arg1  ) // mov ecx arg1
        call WriteRealMemory( pfast_call_10 + 0x54, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_10 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_10 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_11 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_11 ) == 0 then
            call WriteRealMemory( pfast_call_11 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg11
            call WriteRealMemory( pfast_call_11 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg10
            call WriteRealMemory( pfast_call_11 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg9
            call WriteRealMemory( pfast_call_11 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg8
            call WriteRealMemory( pfast_call_11 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_11 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_11 + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_11 + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_11 + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_11 + 0x48, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_11 + 0x50, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_11 + 0x58, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_11 + 0x60, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_11 + 0x04, arg11 ) // push arg11
        call WriteRealMemory( pfast_call_11 + 0x0C, arg10 ) // push arg10
        call WriteRealMemory( pfast_call_11 + 0x14, arg9  ) // push arg9
        call WriteRealMemory( pfast_call_11 + 0x1C, arg8  ) // push arg8
        call WriteRealMemory( pfast_call_11 + 0x24, arg7  ) // push arg7
        call WriteRealMemory( pfast_call_11 + 0x2C, arg6  ) // push arg6
        call WriteRealMemory( pfast_call_11 + 0x34, arg5  ) // push arg5
        call WriteRealMemory( pfast_call_11 + 0x3C, arg4  ) // push arg4
        call WriteRealMemory( pfast_call_11 + 0x44, arg3  ) // push arg3
        call WriteRealMemory( pfast_call_11 + 0x4C, arg2  ) // mov edx arg2
        call WriteRealMemory( pfast_call_11 + 0x54, arg1  ) // mov ecx arg1
        call WriteRealMemory( pfast_call_11 + 0x5C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_11 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_11 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_12 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_12 ) == 0 then
            call WriteRealMemory( pfast_call_12 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg12
            call WriteRealMemory( pfast_call_12 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg11
            call WriteRealMemory( pfast_call_12 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg10
            call WriteRealMemory( pfast_call_12 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg9
            call WriteRealMemory( pfast_call_12 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg8
            call WriteRealMemory( pfast_call_12 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_12 + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_12 + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_12 + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_12 + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_12 + 0x50, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_12 + 0x58, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_12 + 0x60, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_12 + 0x68, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_12 + 0x04, arg12 ) // push arg12
        call WriteRealMemory( pfast_call_12 + 0x0C, arg11 ) // push arg11
        call WriteRealMemory( pfast_call_12 + 0x14, arg10 ) // push arg10
        call WriteRealMemory( pfast_call_12 + 0x1C, arg9  ) // push arg9
        call WriteRealMemory( pfast_call_12 + 0x24, arg8  ) // push arg8
        call WriteRealMemory( pfast_call_12 + 0x2C, arg7  ) // push arg7
        call WriteRealMemory( pfast_call_12 + 0x34, arg6  ) // push arg6
        call WriteRealMemory( pfast_call_12 + 0x3C, arg5  ) // push arg5
        call WriteRealMemory( pfast_call_12 + 0x44, arg4  ) // push arg4
        call WriteRealMemory( pfast_call_12 + 0x4C, arg3  ) // push arg3
        call WriteRealMemory( pfast_call_12 + 0x54, arg2  ) // mov edx arg2
        call WriteRealMemory( pfast_call_12 + 0x5C, arg1  ) // mov ecx arg1
        call WriteRealMemory( pfast_call_12 + 0x64, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_12 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_12 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function fast_call_13 takes integer pFuncFastcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12, integer arg13 returns integer
        local integer pOffset1

        if ReadRealMemory( pfast_call_13 ) == 0 then
            call WriteRealMemory( pfast_call_13 + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg13
            call WriteRealMemory( pfast_call_13 + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg12
            call WriteRealMemory( pfast_call_13 + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg11
            call WriteRealMemory( pfast_call_13 + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg10
            call WriteRealMemory( pfast_call_13 + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg9
            call WriteRealMemory( pfast_call_13 + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg8
            call WriteRealMemory( pfast_call_13 + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg7
            call WriteRealMemory( pfast_call_13 + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg6
            call WriteRealMemory( pfast_call_13 + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg5
            call WriteRealMemory( pfast_call_13 + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg4
            call WriteRealMemory( pfast_call_13 + 0x50, 0x68F68B90 ) // nop | move esi, esi | push arg3
            call WriteRealMemory( pfast_call_13 + 0x58, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
            call WriteRealMemory( pfast_call_13 + 0x60, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
            call WriteRealMemory( pfast_call_13 + 0x68, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (pFuncFastcallAddr)
            call WriteRealMemory( pfast_call_13 + 0x70, 0xC35ED6FF ) // call esi | pop esi | ret
        endif

        call WriteRealMemory( pfast_call_13 + 0x04, arg13 ) // push arg13
        call WriteRealMemory( pfast_call_13 + 0x0C, arg12 ) // push arg12
        call WriteRealMemory( pfast_call_13 + 0x14, arg11 ) // push arg11
        call WriteRealMemory( pfast_call_13 + 0x1C, arg10 ) // push arg10
        call WriteRealMemory( pfast_call_13 + 0x24, arg9  ) // push arg9
        call WriteRealMemory( pfast_call_13 + 0x2C, arg8  ) // push arg8
        call WriteRealMemory( pfast_call_13 + 0x34, arg7  ) // push arg7
        call WriteRealMemory( pfast_call_13 + 0x3C, arg6  ) // push arg6
        call WriteRealMemory( pfast_call_13 + 0x44, arg5  ) // push arg5
        call WriteRealMemory( pfast_call_13 + 0x4C, arg4  ) // push arg4
        call WriteRealMemory( pfast_call_13 + 0x54, arg3  ) // push arg3
        call WriteRealMemory( pfast_call_13 + 0x5C, arg2  ) // mov edx arg2
        call WriteRealMemory( pfast_call_13 + 0x64, arg1  ) // mov ecx arg1
        call WriteRealMemory( pfast_call_13 + 0x6C, pFuncFastcallAddr ) // mov esi, pFuncFastcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pfast_call_13 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pfast_call_13 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function this_call_1 takes integer pfuncaddr, integer arg1 returns integer
        return fast_call_2( pfuncaddr, arg1, 0 )
    endfunction

    function this_call_2 takes integer pfuncaddr, integer arg1, integer arg2 returns integer
        return fast_call_3( pfuncaddr, arg1, 0, arg2 )
    endfunction

    function this_call_3 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3 returns integer
        return fast_call_4( pfuncaddr, arg1, 0, arg2, arg3 )
    endfunction

    function this_call_4 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4 returns integer
        return fast_call_5( pfuncaddr, arg1, 0, arg2, arg3, arg4 )
    endfunction

    function this_call_5 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5 returns integer
        return fast_call_6( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5 )
    endfunction

    function this_call_6 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        return fast_call_7( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6 )
    endfunction

    function this_call_7 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        return fast_call_8( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7 )
    endfunction

    function this_call_8 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8 returns integer
        return fast_call_9( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8 )
    endfunction

    function this_call_9 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9 returns integer
        return fast_call_10( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 )
    endfunction

    function this_call_10 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10 returns integer
        return fast_call_11( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
    endfunction

    function this_call_11 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11 returns integer
        return fast_call_12( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 )
    endfunction

    function this_call_12 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12 returns integer
        return fast_call_13( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 )
    endfunction

    function std_call_1 takes integer pFuncStdcallAddr, integer arg1 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_1 ) == 0 then
            call WriteRealMemory( pstd_call_1 + 0x00, 0x68C98B51 )    // push ecx | mov ecx, ecx | push (arg1)
            call WriteRealMemory( pstd_call_1 + 0x08, 0xB990C98B )    // mov ecx, ecx | nop | mov ecx (pFuncStdcallAddr)
            call WriteRealMemory( pstd_call_1 + 0x10, 0xC359D1FF )    // call ecx, pop ecx, ret
        endif
        
        call WriteRealMemory( pstd_call_1 + 0x04, arg1 )                // push arg1
        call WriteRealMemory( pstd_call_1 + 0x0C, pFuncStdcallAddr )    // mov ecx, pFuncStdcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_1 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_1 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        
        return pOffset1
    endfunction

    function std_call_2 takes integer pFuncStdcallAddr, integer arg1, integer arg2 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_2 ) == 0 then
            call WriteRealMemory( pstd_call_2 + 0x00, 0x68C98B51 )    // push ecx, mov ecx, ecx
            call WriteRealMemory( pstd_call_2 + 0x08, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_2 + 0x10, 0xB990C98B )    // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_2 + 0x18, 0xC359D1FF )    // call ecx, pop ecx, ret
        endif

        call WriteRealMemory( pstd_call_2 + 0x04, arg2 )                // push arg1
        call WriteRealMemory( pstd_call_2 + 0x0C, arg1 )                // push arg2
        call WriteRealMemory( pstd_call_2 + 0x14, pFuncStdcallAddr )     // mov ecx, pFuncStdcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_2 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_2 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        
        return pOffset1
    endfunction

    function std_call_3 takes integer pFuncStdcallAddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_3 ) == 0 then
            call WriteRealMemory( pstd_call_3 + 0x00, 0x68C98B51 )   // push ecx, mov ecx, ecx
            call WriteRealMemory( pstd_call_3 + 0x08, 0x6890C98B )   // mov ecx, ecx
            call WriteRealMemory( pstd_call_3 + 0x10, 0x6890C98B )   // mov ecx, ecx
            call WriteRealMemory( pstd_call_3 + 0x18, 0xB990C98B )   // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_3 + 0x20, 0xC359D1FF )   // call ecx, pop ecx, ret
        endif

        call WriteRealMemory( pstd_call_3 + 0x04, arg3 )                // push arg3
        call WriteRealMemory( pstd_call_3 + 0x0C, arg2 )                // push arg2
        call WriteRealMemory( pstd_call_3 + 0x14, arg1 )                // push arg1
        call WriteRealMemory( pstd_call_3 + 0x1C, pFuncStdcallAddr )    // mov ecx, pFuncStdcallAddr
        

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_3 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_3 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function std_call_4 takes integer pFuncStdcallAddr, integer arg1, integer arg2, integer arg3, integer arg4 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_4 ) == 0 then
            call WriteRealMemory( pstd_call_4 + 0x00, 0x68C98B51 )    // push ecx, mov ecx, ecx
            call WriteRealMemory( pstd_call_4 + 0x08, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_4 + 0x10, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_4 + 0x18, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_4 + 0x20, 0xB990C98B )    // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_4 + 0x28, 0xC359D1FF )    // call ecx, pop ecx, ret
        endif

        call WriteRealMemory( pstd_call_4 + 0x04, arg4 )                // push arg4
        call WriteRealMemory( pstd_call_4 + 0x0C, arg3 )                // push arg3
        call WriteRealMemory( pstd_call_4 + 0x14, arg2 )                // push arg2
        call WriteRealMemory( pstd_call_4 + 0x1C, arg1 )                // push arg1
        call WriteRealMemory( pstd_call_4 + 0x24, pFuncStdcallAddr )    // mov ecx, pFuncStdcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_4 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_4 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        
        return pOffset1
    endfunction

    function std_call_5 takes integer pFuncStdcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_5 ) == 0 then
            call WriteRealMemory( pstd_call_5 + 0x00, 0x68C98B51 )    // push ecx, mov ecx, ecx
            call WriteRealMemory( pstd_call_5 + 0x08, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_5 + 0x10, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_5 + 0x18, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_5 + 0x20, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_5 + 0x28, 0xB990C98B )    // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_5 + 0x30, 0xC359D1FF )    // call ecx, pop ecx, ret
        endif

        call WriteRealMemory( pstd_call_5 + 0x04, arg5 )                // push arg5
        call WriteRealMemory( pstd_call_5 + 0x0C, arg4 )                // push arg4
        call WriteRealMemory( pstd_call_5 + 0x14, arg3 )                // push arg3
        call WriteRealMemory( pstd_call_5 + 0x1C, arg2 )                // push arg2
        call WriteRealMemory( pstd_call_5 + 0x24, arg1 )                // push arg1
        call WriteRealMemory( pstd_call_5 + 0x2C, pFuncStdcallAddr )    // mov ecx, pFuncStdcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_5 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_5 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function std_call_6 takes integer pFuncStdcallAddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer pOffset1

        if ReadRealMemory( pstd_call_6 ) == 0 then
            call WriteRealMemory( pstd_call_6 + 0x00, 0x68C98B51 )    // push ecx, mov ecx, ecx
            call WriteRealMemory( pstd_call_6 + 0x08, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_6 + 0x10, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_6 + 0x18, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_6 + 0x20, 0x6890C98B )    // mov ecx, ecx
            call WriteRealMemory( pstd_call_6 + 0x28, 0x6890C98B )    // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_6 + 0x30, 0xB990C98B )    // mov ecx, ecx, nop
            call WriteRealMemory( pstd_call_6 + 0x38, 0xC359D1FF )    // call ecx, pop ecx, ret
        endif

        call WriteRealMemory( pstd_call_6 + 0x04, arg6 )                  // push arg5
        call WriteRealMemory( pstd_call_6 + 0x0C, arg5 )                  // push arg4
        call WriteRealMemory( pstd_call_6 + 0x14, arg4 )                  // push arg3
        call WriteRealMemory( pstd_call_6 + 0x1C, arg3 )                  // push arg2
        call WriteRealMemory( pstd_call_6 + 0x24, arg2 )                  // push arg1
        call WriteRealMemory( pstd_call_6 + 0x2C, arg1 )                  // push arg1
        call WriteRealMemory( pstd_call_6 + 0x34, pFuncStdcallAddr )     // mov ecx, pFuncStdcallAddr

        if pIgnoredUnitsOffset == 0 then
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pstd_call_6 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pstd_call_6 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_1 takes integer pFuncCdeclAddr, integer arg1 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_1 ) == 0 then 
            call WriteRealMemory( pc_call_1 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_1 + 0x08, 0xB990C98B ) // mov ecx, ecx, nop
            call WriteRealMemory( pc_call_1 + 0x10, 0xC483D1FF ) // call ecx, add esp
            call WriteRealMemory( pc_call_1 + 0x14, 0xCCC35904 ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_1 + 0x04, arg1 )           // push arg1
        call WriteRealMemory( pc_call_1 + 0x0C, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr

        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_1 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_1 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_2 takes integer pFuncCdeclAddr, integer arg1, integer arg2 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_2 ) == 0 then 
            call WriteRealMemory( pc_call_2 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_2 + 0x08, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_2 + 0x10, 0xB990C98B ) // mov ecx,ecx , nop
            call WriteRealMemory( pc_call_2 + 0x18, 0xC483D1FF ) // call ecx, add esp, 
            call WriteRealMemory( pc_call_2 + 0x1C, 0xCCC35908 ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_2 + 0x04, arg2 )           // push arg2
        call WriteRealMemory( pc_call_2 + 0x0C, arg1 )           // push arg1
        call WriteRealMemory( pc_call_2 + 0x14, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr

        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_2 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_2 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_3 takes integer pFuncCdeclAddr, integer arg1, integer arg2, integer arg3 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_3 ) == 0 then 
            call WriteRealMemory( pc_call_3 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_3 + 0x08, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_3 + 0x10, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_3 + 0x18, 0xB990C98B ) // mov ecx,ecx, nop
            call WriteRealMemory( pc_call_3 + 0x20, 0xC483D1FF ) // call ecx, add esp
            call WriteRealMemory( pc_call_3 + 0x24, 0xCCC3590C ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_3 + 0x04, arg3 )           // push arg3
        call WriteRealMemory( pc_call_3 + 0x0C, arg2 )           // push arg2
        call WriteRealMemory( pc_call_3 + 0x14, arg1 )           // push arg1
        call WriteRealMemory( pc_call_3 + 0x1C, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr

        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_3 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_3 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_4 takes integer pFuncCdeclAddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_4 ) == 0 then 
            call WriteRealMemory( pc_call_4 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_4 + 0x08, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_4 + 0x10, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_4 + 0x18, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_4 + 0x20, 0xB990C98B ) // mov ecx, ecx, nop
            call WriteRealMemory( pc_call_4 + 0x28, 0xC483D1FF ) // call ecx, add esp
            call WriteRealMemory( pc_call_4 + 0x2C, 0xCCC35910 ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_4 + 0x04, arg4 )           // push arg4
        call WriteRealMemory( pc_call_4 + 0x0C, arg3 )           // push arg3
        call WriteRealMemory( pc_call_4 + 0x14, arg2 )           // push arg2
        call WriteRealMemory( pc_call_4 + 0x1C, arg1 )           // push arg1
        call WriteRealMemory( pc_call_4 + 0x24, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr

        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_4 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_4 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_5 takes integer pFuncCdeclAddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_5 ) == 0 then 
            call WriteRealMemory( pc_call_5 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_5 + 0x08, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_5 + 0x10, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_5 + 0x18, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_5 + 0x20, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_5 + 0x28, 0xB990C98B ) // mov ecx, ecx, nop
            call WriteRealMemory( pc_call_5 + 0x30, 0xC483D1FF ) // call ecx, add esp, 
            call WriteRealMemory( pc_call_5 + 0x34, 0xCCC35914 ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_5 + 0x04, arg5 )           // push arg5
        call WriteRealMemory( pc_call_5 + 0x0C, arg4 )           // push arg4
        call WriteRealMemory( pc_call_5 + 0x14, arg3 )           // push arg3
        call WriteRealMemory( pc_call_5 + 0x1C, arg2 )           // push arg2
        call WriteRealMemory( pc_call_5 + 0x24, arg1 )           // push arg1
        call WriteRealMemory( pc_call_5 + 0x2C, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr
        
        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_5 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_5 )
        endif
        
        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function c_call_6 takes integer pFuncCdeclAddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 , integer arg6 returns integer 
        local integer pOffset1

        if ReadRealMemory( pc_call_6 ) == 0 then 
            call WriteRealMemory( pc_call_6 + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x08, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x10, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x18, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x20, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x28, 0x6890C98B ) // mov ecx, ecx
            call WriteRealMemory( pc_call_6 + 0x30, 0xB990C98B ) // mov ecx, ecx, nop
            call WriteRealMemory( pc_call_6 + 0x38, 0xC483D1FF ) // call ecx, add esp, 
            call WriteRealMemory( pc_call_6 + 0x3C, 0xCCC35918 ) // 4, pop ecx, ret
        endif

        call WriteRealMemory( pc_call_6 + 0x04, arg6 )           // push arg6
        call WriteRealMemory( pc_call_6 + 0x0C, arg5 )           // push arg5
        call WriteRealMemory( pc_call_6 + 0x14, arg4 )           // push arg4
        call WriteRealMemory( pc_call_6 + 0x1C, arg3 )           // push arg3
        call WriteRealMemory( pc_call_6 + 0x24, arg2 )           // push arg2
        call WriteRealMemory( pc_call_6 + 0x2C, arg1 )           // push arg1
        call WriteRealMemory( pc_call_6 + 0x34, pFuncCdeclAddr ) // mov ecx, pFuncCdeclAddr

        if pIgnoredUnitsOffset == 0 then 
            set pIgnoredUnitsOffset = CreateJassNativeHook( pIgnoredUnits, pc_call_6 )
        else
            call WriteRealMemory( pIgnoredUnitsOffset, pc_call_6 )
        endif

        set pOffset1 = IgnoredUnits( 0 )
        call WriteRealMemory( pIgnoredUnitsOffset, pIgnoredUnits )
        return pOffset1
    endfunction

    function AllocateExecutableMemory takes integer size returns integer
        local integer retval = 0

        if pVirtualAlloc != 0 then
            if pMergeUnitsOffset == 0 then
                set pMergeUnitsOffset = CreateJassNativeHook( pMergeUnits, ReadRealMemory( pVirtualAlloc ) )
            else
                call WriteRealMemory( pMergeUnitsOffset, ReadRealMemory( pVirtualAlloc ) )
            endif

            set retval = B2I( MergeUnits( 0, size + 4, 0x3000, 0x40 ) )
            call WriteRealMemory( pMergeUnitsOffset, pMergeUnits )
        endif

        if retval == 0 then
            return 0
        endif

        return ( retval + 0x4 ) / 4 * 4
    endfunction

    function AllocateExecutableMemoryCounted takes integer size returns integer
        local integer retval = AllocateExecutableMemory( size )

        if retval != 0 then
            set AllocatedMemorySize = AllocatedMemorySize + size
        endif
        
        return retval
    endfunction
    
    function CopyMemory takes integer dest, integer src, integer size returns integer 
        return c_call_3( ReadRealMemory( pMemcpy ), dest, src, size )
    endfunction
    
    function GetModuleHandleByAddr takes integer pDll returns integer
        if pGetModuleHandle > 0 then
            return std_call_1( ReadRealMemory( pGetModuleHandle ), pDll )
        endif

        return 0
    endfunction
    
    function GetModuleHandle takes string nDllName returns integer
        return GetModuleHandleByAddr( GetStringAddress( nDllName ) )
    endfunction

    function GetModuleProcAddressByAddr takes integer pDll, integer pFunc returns integer
        if pGetProcAddress > 0 then
            return std_call_2( ReadRealMemory( pGetProcAddress ), GetModuleHandleByAddr( pDll ), pFunc )
        endif
        
        return 0
    endfunction
    
    function GetModuleProcAddress takes string nDllName, string nProcName returns integer
        return GetModuleProcAddressByAddr( GetStringAddress( nDllName ), GetStringAddress( nProcName ) )
    endfunction
    
    function ReallocateCallMemory takes nothing returns nothing
        local integer i   = 0

        set pFastRead     = AllocateExecutableMemoryCounted( 0x8 )
        set pFastWrite    = AllocateExecutableMemoryCounted( 0x10 )

        set pfast_call_1  = AllocateExecutableMemoryCounted( 0x14 )
        set pfast_call_2  = AllocateExecutableMemoryCounted( 0x1C )
        set pfast_call_3  = AllocateExecutableMemoryCounted( 0x24 )
        set pfast_call_4  = AllocateExecutableMemoryCounted( 0x2C )
        set pfast_call_5  = AllocateExecutableMemoryCounted( 0x34 )
        set pfast_call_6  = AllocateExecutableMemoryCounted( 0x3C )
        set pfast_call_7  = AllocateExecutableMemoryCounted( 0x44 )
        set pfast_call_8  = AllocateExecutableMemoryCounted( 0x4C )
        set pfast_call_9  = AllocateExecutableMemoryCounted( 0x5C )
        set pfast_call_10 = AllocateExecutableMemoryCounted( 0x64 )
        set pfast_call_11 = AllocateExecutableMemoryCounted( 0x6C )
        set pfast_call_12 = AllocateExecutableMemoryCounted( 0x74 )
        set pfast_call_13 = AllocateExecutableMemoryCounted( 0x7C )

        set pstd_call_1   = AllocateExecutableMemoryCounted( 0x14 )
        set pstd_call_2   = AllocateExecutableMemoryCounted( 0x1C )
        set pstd_call_3   = AllocateExecutableMemoryCounted( 0x24 )
        set pstd_call_4   = AllocateExecutableMemoryCounted( 0x2C )
        set pstd_call_5   = AllocateExecutableMemoryCounted( 0x34 )
        set pstd_call_6   = AllocateExecutableMemoryCounted( 0x3C )

        set pc_call_1     = AllocateExecutableMemoryCounted( 0x18 )
        set pc_call_2     = AllocateExecutableMemoryCounted( 0x20 )
        set pc_call_3     = AllocateExecutableMemoryCounted( 0x28 )
        set pc_call_4     = AllocateExecutableMemoryCounted( 0x30 )
        set pc_call_5     = AllocateExecutableMemoryCounted( 0x38 )
        set pc_call_6     = AllocateExecutableMemoryCounted( 0x40 )

        loop
            exitwhen i > ( AllocatedMemorySize - 0x4 )
            call WriteRealMemory( pFastRead + i, 0 )
            set i = i + 4
        endloop

        set AllocatedMemorySize = 0
    endfunction

    function AllocateCallMemory takes nothing returns nothing
        call ReallocateCallMemory( ) // AllocateExecutableMemory( 37000 )
    endfunction
    
    function Init_APIMemoryCalls takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pMergeUnits          = pGameDLL + 0x2DDE40
                set pIgnoredUnits        = pGameDLL + 0x2DD9A0
                set pConvertUnits        = pGameDLL + 0x2DDE00
                set pGetUnitCount        = pGameDLL + 0x2DDB70
                set pAttackMoveXY        = pGameDLL + 0x2DE730
                set pMemcpy              = pGameDLL + 0x87F47C
                set pGetModuleHandle     = pGameDLL + 0x87F204
                set pGetProcAddress      = pGameDLL + 0x87F2BC
                set pVirtualAlloc        = pGameDLL + 0x87F134
        elseif PatchVersion == "1.26a" then
                set pMergeUnits          = pGameDLL + 0x2DD320
                set pIgnoredUnits        = pGameDLL + 0x2DCE80
                set pConvertUnits        = pGameDLL + 0x2DD2E0
                set pGetUnitCount        = pGameDLL + 0x2DD050
                set pAttackMoveXY        = pGameDLL + 0x2DDC10
                set pMemcpy              = pGameDLL + 0x86D3CC
                set pGetModuleHandle     = pGameDLL + 0x86D1D0
                set pGetProcAddress      = pGameDLL + 0x86D280
                set pVirtualAlloc        = pGameDLL + 0x86D0F4
        elseif PatchVersion == "1.27a" then
                set pMergeUnits          = pGameDLL + 0x891F20
                set pIgnoredUnits        = pGameDLL + 0x890FB0
                set pConvertUnits        = pGameDLL + 0x88E350
                set pGetUnitCount        = pGameDLL + 0x890750
                set pAttackMoveXY        = pGameDLL + 0x88CFE0
                set pMemcpy              = pGameDLL + 0x94E468
                set pGetModuleHandle     = pGameDLL + 0x94E184
                set pGetProcAddress      = pGameDLL + 0x94E168
                set pVirtualAlloc        = pGameDLL + 0x94E270
        elseif PatchVersion == "1.27b" then
                set pMergeUnits          = pGameDLL + 0x9BD020
                set pIgnoredUnits        = pGameDLL + 0x9BC0B0
                set pConvertUnits        = pGameDLL + 0x9B9450
                set pGetUnitCount        = pGameDLL + 0x9BB850
                set pAttackMoveXY        = pGameDLL + 0x9B80E0
                set pMemcpy              = pGameDLL + 0xA7C504
                set pGetModuleHandle     = pGameDLL + 0xA7C28C
                set pGetProcAddress      = pGameDLL + 0xA7C17C
                set pVirtualAlloc        = pGameDLL + 0xA7C2D0
        elseif PatchVersion == "1.28f" then
                set pMergeUnits          = pGameDLL + 0x971FB0
                set pIgnoredUnits        = pGameDLL + 0x971040
                set pConvertUnits        = pGameDLL + 0x96E3E0
                set pGetUnitCount        = pGameDLL + 0x9707E0
                set pAttackMoveXY        = pGameDLL + 0x96D070
                set pMemcpy              = pGameDLL + 0xA6B3DC
                set pGetModuleHandle     = pGameDLL + 0xA6B378
                set pGetProcAddress      = pGameDLL + 0xA6B24C
                set pVirtualAlloc        = pGameDLL + 0xA6B2B8
            endif

            if pMergeUnits != 0 then
                call AllocateCallMemory( )
                call InitFastReadMemory( )
                call InitFastWriteMemory( )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryCalls takes nothing returns nothing
    //set gg_trg_APIMemoryCalls = CreateTrigger(  )
endfunction
//! endnocjass
