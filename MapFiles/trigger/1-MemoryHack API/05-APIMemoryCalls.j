//TESH.scrollpos=60
//TESH.alwaysfold=0
//! nocjass
library APIMemoryAllCalls
    // Explanation:
    // We write assembler in a reversed order, since that is how our written memory will translate to machine code
    // Example: 0xB9F68B56 which is B9 F6 8B 56 => but in fact it will be 0x568BF6B9 or 56 8B F6 B9
    // To translate machine code to asm you can use: https://defuse.ca/online-x86-assembler.htm#disassembly2
    function fast_call_0 takes integer funcaddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x0, 0xBEF68B56 ) // push esi | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x8, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov esi, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr +  0x0, 0xB9F68B56 ) // push esi | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr +  0x8, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x10, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr +  0x4, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr +  0xC, funcaddr ) // mov esi, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0xBAF68B56 ) // push esi | mov esi, esi | edx (arg2)
                call WriteRealMemory( addr + 0x08, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x10, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x18, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )      // mov edx arg2
            call WriteRealMemory( addr + 0x0C, arg1 )      // mov ecx arg1
            call WriteRealMemory( addr + 0x14, funcaddr )  // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg3
                call WriteRealMemory( addr + 0x08, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x10, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x18, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x20, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function fast_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg4
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x10, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x18, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x20, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x28, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg5
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x18, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x20, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x28, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x30, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg6
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x20, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x28, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x30, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x38, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x24, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x2C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_7 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_7" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg7
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x28, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x30, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x38, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x40, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x0C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x14, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x1C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x24, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x2C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x34, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x3C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_8 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_8" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg8
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x30, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x38, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x40, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x48, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg8 )     // push arg8
            call WriteRealMemory( addr + 0x0C, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x14, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x1C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x24, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x2C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x34, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x3C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x44, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_9 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_9" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg9
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x38, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x40, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x48, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x50, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg9 )     // push arg9
            call WriteRealMemory( addr + 0x0C, arg8 )     // push arg8
            call WriteRealMemory( addr + 0x14, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x1C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x24, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x2C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x34, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x3C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x44, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x4C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_10 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_10" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg10
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x40, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x48, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x50, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x58, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x0C, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x14, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x1C, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x24, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x2C, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x34, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x3C, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x44, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x4C, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x54, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_11 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_11" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg11
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x48, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x50, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x58, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x60, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x0C, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x14, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x1C, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x24, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x2C, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x34, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x3C, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x44, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x4C, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x54, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x5C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function fast_call_12 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_12" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg12
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg11
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x50, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x58, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x60, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x68, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg12 )    // push arg12
            call WriteRealMemory( addr + 0x0C, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x14, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x1C, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x24, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x2C, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x34, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x3C, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x44, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x4C, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x54, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x5C, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x64, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_13 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12, integer arg13 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_13" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg13
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg12
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg11
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x50, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x58, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x60, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x68, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x70, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg13 )    // push arg13
            call WriteRealMemory( addr + 0x0C, arg12 )    // push arg12
            call WriteRealMemory( addr + 0x14, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x1C, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x24, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x2C, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x34, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x3C, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x44, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x4C, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x54, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x5C, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x64, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x6C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function this_call_0 takes integer pfuncaddr, integer arg1 returns integer
        return fast_call_1( pfuncaddr, 0 )
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

    function std_call_0 takes integer funcaddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x0, 0xB9519090 ) // push ecx | nop, nop
                call WriteRealMemory( addr + 0x8, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov ecx, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx | mov ecx, ecx | push (arg1)
                call WriteRealMemory( addr + 0x08, 0xB990C98B ) // mov ecx, ecx | nop | mov ecx (funcaddr)
                call WriteRealMemory( addr + 0x10, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x0C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x18, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )     // push arg1
            call WriteRealMemory( addr + 0x0C, arg1 )     // push arg2
            call WriteRealMemory( addr + 0x14, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x20, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov ecx, funcaddr
            
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x28, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x24, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x2C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_7 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_7" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x40, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x0C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x14, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x1C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x24, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x2C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x34, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x3C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction
    
    function c_call_0 takes integer funcaddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x0, 0xB9C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x8, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0xC, 0xCCC35900 ) // 0x0, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function c_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x10, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x14, 0xCCC35904 ) // 0x4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x0C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function c_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0xB990C98B ) // mov ecx,ecx , nop
                call WriteRealMemory( addr + 0x18, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x1C, 0xCCC35908 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x0C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x14, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0xB990C98B ) // mov ecx,ecx, nop
                call WriteRealMemory( addr + 0x20, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x24, 0xCCC3590C ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x28, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x2C, 0xCCC35910 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x34, 0xCCC35914 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov ecx, funcaddr
            
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 , integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x30, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x3C, 0xCCC35918 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x24, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x2C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function GetModuleHandleByAddr takes integer pDll returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ) )

        if addr != 0 then
            return std_call_1( addr, pDll )
        endif

        return 0
    endfunction
    
    function GetModuleHandle takes string nDllName returns integer
        return GetModuleHandleByAddr( GetStringAddress( nDllName ) )
    endfunction

    function GetModuleProcAddressByAddr takes integer pDll, integer pFunc returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ) )

        if addr != 0 then
            return std_call_2( addr, GetModuleHandleByAddr( pDll ), pFunc )
        endif
        
        return 0
    endfunction
    
    function GetModuleProcAddress takes string nDllName, string nProcName returns integer
        return GetModuleProcAddressByAddr( GetStringAddress( nDllName ), GetStringAddress( nProcName ) )
    endfunction

    function GetFuncFromDll takes string libname, string funcname, boolean save returns integer
        local integer l_hash = StringHash( libname )
        local integer f_hash = StringHash( funcname )
        local integer addr   = LoadInteger( MemHackTable, l_hash, f_hash )

        if addr == 0 then
            set addr = GetModuleProcAddress( libname, funcname )
        endif

        if addr != 0 and save then
            if not HaveSavedInteger( MemHackTable, l_hash, f_hash ) then
                call SaveInteger( MemHackTable, l_hash, f_hash, addr )
            endif
        endif

        return addr
    endfunction

    function VirtualAlloc takes integer pRealOffset, integer pMemSize, integer alloctype, integer pProtectFlag returns integer // 0, size + 4, 0x3000, 0x40
        local integer addr = GetFuncFromDll( "Kernel32.dll", "VirtualAlloc", true )

        if addr != 0 then
            return std_call_4( addr, pRealOffset, pMemSize, alloctype, pProtectFlag )
        endif

        return 0
    endfunction

    function VirtualProtect takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "VirtualProtect", true )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 then
            call std_call_4( addr, pRealOffset, pMemSize, pProtectFlag, arg )
            return ReadRealMemory( arg )
        endif

        return 0
    endfunction

    function CopyMemory takes integer dest, integer src, integer size returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ) )

        if addr != 0 then
            return c_call_3( addr, dest, src, size )
        endif

        return 0
    endfunction

    function AllocExecMemEx takes string funcname, string childName, integer size returns nothing
        local integer i      = 0
        local integer f_hash = StringHash( funcname )
        local integer c_hash = StringHash( childName )
        local integer addr   = LoadInteger( MemHackTable, f_hash, c_hash )

        if addr == 0 then
            set addr = AllocateExecutableMemory( size )

            if addr != 0 then
                call SaveInteger( MemHackTable, f_hash, c_hash, addr )

                loop
                    exitwhen i == size
                    call WriteRealMemory( addr + i, 0 )
                    set i = i + 0x4
                endloop
            endif
        endif
    endfunction

    function AllocFunctionCall takes string funcname, integer size returns nothing
        call AllocExecMemEx( funcname, "function", size )
    endfunction

    function ReallocateCallMemory takes nothing returns nothing
        local integer i   = 0

        if PatchVersion != "" then
            call AllocFunctionCall( "fast_call_0",  0x0C )
            call AllocFunctionCall( "fast_call_1",  0x14 )
            call AllocFunctionCall( "fast_call_2",  0x1C )
            call AllocFunctionCall( "fast_call_3",  0x24 )
            call AllocFunctionCall( "fast_call_4",  0x2C )
            call AllocFunctionCall( "fast_call_5",  0x34 )
            call AllocFunctionCall( "fast_call_6",  0x3C )
            call AllocFunctionCall( "fast_call_7",  0x44 )
            call AllocFunctionCall( "fast_call_8",  0x4C )
            call AllocFunctionCall( "fast_call_9",  0x5C )
            call AllocFunctionCall( "fast_call_10", 0x64 )
            call AllocFunctionCall( "fast_call_11", 0x6C )
            call AllocFunctionCall( "fast_call_12", 0x74 )
            call AllocFunctionCall( "fast_call_13", 0x7C )

            call AllocFunctionCall( "std_call_0", 0x0C )
            call AllocFunctionCall( "std_call_1", 0x14 )
            call AllocFunctionCall( "std_call_2", 0x1C )
            call AllocFunctionCall( "std_call_3", 0x24 )
            call AllocFunctionCall( "std_call_4", 0x2C )
            call AllocFunctionCall( "std_call_5", 0x34 )
            call AllocFunctionCall( "std_call_6", 0x3C )
            call AllocFunctionCall( "std_call_7", 0x44 )

            call AllocFunctionCall( "c_call_0", 0x10 )
            call AllocFunctionCall( "c_call_1", 0x18 )
            call AllocFunctionCall( "c_call_2", 0x20 )
            call AllocFunctionCall( "c_call_3", 0x28 )
            call AllocFunctionCall( "c_call_4", 0x30 )
            call AllocFunctionCall( "c_call_5", 0x38 )
            call AllocFunctionCall( "c_call_6", 0x40 )
        endif
    endfunction

    function AllocateCallMemory takes nothing returns nothing
        call ReallocateCallMemory( ) // AllocateExecutableMemory( 37000 )
    endfunction
    
    function Init_APIMemoryCalls takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x87F204 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x87F2BC ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x87F134 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x87F47C ) )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x86D1D0 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x86D280 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x86D0F4 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x86D3CC ) )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x94E184 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x94E168 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x94E270 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x94E468 ) )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0xA7C28C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0xA7C17C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0xA7C2D0 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0xA7C504 ) )

        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0xA6B378 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0xA6B24C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0xA6B2B8 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0xA6B3DC ) )
            endif

            call AllocateCallMemory( )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryCalls takes nothing returns nothing
    //set gg_trg_APIMemoryCalls = CreateTrigger(  )
endfunction
//! endnocjass
