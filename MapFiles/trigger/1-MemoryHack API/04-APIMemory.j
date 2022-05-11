//TESH.scrollpos=494
//TESH.alwaysfold=0
//! nocjass
native MergeUnits   takes integer qty, integer a, integer b, integer make returns boolean    // reserved native for call 4 integer function and return BOOLEAN value
native ConvertUnits takes integer qty, integer id returns boolean                            // reserved native for call 2 integer function and return BOOLEAN value (can be converted to int!)
native IgnoredUnits takes integer unitid returns integer                                     // reserved native for call 1 integer function and return integer value

library APIMemory
    globals
        constant integer NULL               = 0 // Reserved for developer's ease of use.
        hashtable MemHackTable              = InitHashtable( )

        integer iGameVersion                = 0
        integer pGameDLL                    = 0
        string PatchVersion                 = ""
        integer pMemory                     = 0
        integer array RJassNativesBuffer
        integer Memory // This is not used, it's here just to fool Jasshelper
        integer array l__Memory
        integer iBytecodeData

        integer pPointers                   = 0
        integer pWriteMemory                = 0
        integer pJassEnvAddress             = 0
        integer RJassNativesBufferSize      = 0

        integer JassVM                      = 0
        integer JassTable                   = 0

        integer pUnlockCall1                = 0
        integer pUnlockCall2                = 0
        integer pUnlockJmp1                 = 0
    endglobals

    function GetByteFromInteger takes integer i, integer byteid returns integer
        local integer tmpval = i
        local integer retval = 0
        local integer byte1  = 0
        local integer byte2  = 0
        local integer byte3  = 0
        local integer byte4  = 0
        
        if tmpval < 0 then
            set tmpval = BitwiseNot( tmpval )
            set byte4  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte3  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte2  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte1  = 255 - tmpval
        else
            set byte4  =  ModuloInteger( tmpval, 256)
            set tmpval = tmpval / 256
            set byte3  =  ModuloInteger( tmpval, 256)
            set tmpval = tmpval / 256
            set byte2  =  ModuloInteger( tmpval, 256)
            set tmpval = tmpval / 256
            set byte1  = tmpval
        endif

        if byteid == 1 then
            return byte1
        elseif byteid == 2 then
            return byte2
        elseif byteid == 3 then
            return byte3
        elseif byteid == 4 then
            return byte4
        endif

        return retval
    endfunction

    function CreateInteger1 takes integer byte1, integer byte2, integer byte3, integer byte4 returns integer
        local integer retval = byte1
        
        set retval = ( retval * 256 ) + byte2
        set retval = ( retval * 256 ) + byte3
        set retval = ( retval * 256 ) + byte4
        
        return retval
    endfunction

    // addr 0x10000 data 1C 2C 8A 7D 6D 5F 5A 4C 6C 3C 8C 7A
    // read memory at 0x10003   ( 7D 6D 5F 5A )
    function CreateIntegerFromTwoByOffset takes integer LocalInteger1, integer LocalInteger2, integer offset returns integer
        local integer array pBytes
        
        set pBytes[ 0 ] = GetByteFromInteger( LocalInteger1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( LocalInteger1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( LocalInteger1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( LocalInteger1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( LocalInteger2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( LocalInteger2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( LocalInteger2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( LocalInteger2, 1 )
        
        return CreateInteger1( pBytes[ offset + 3 ], pBytes[ offset + 2 ], pBytes[ offset + 1 ], pBytes[ offset + 0 ] )
    endfunction

    function CreateDoubleIntegerAndGetOne takes integer LocalInteger1, integer LocalInteger2, integer value, integer offset, boolean first returns integer
        local integer array pBytes

        set pBytes[ 0 ] = GetByteFromInteger( LocalInteger1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( LocalInteger1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( LocalInteger1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( LocalInteger1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( LocalInteger2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( LocalInteger2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( LocalInteger2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( LocalInteger2, 1 )

        set pBytes[ offset + 0 ] = GetByteFromInteger( value, 4 )
        set pBytes[ offset + 1 ] = GetByteFromInteger( value, 3 )
        set pBytes[ offset + 2 ] = GetByteFromInteger( value, 2 )
        set pBytes[ offset + 3 ] = GetByteFromInteger( value, 1 )

        if first then
            return CreateInteger1( pBytes[ 3 ], pBytes[ 2 ], pBytes[ 1 ], pBytes[ 0 ] )
        else
            return CreateInteger1( pBytes[ 7 ], pBytes[ 6 ], pBytes[ 5 ], pBytes[ 4 ] )
        endif
    endfunction

    function ReadMemory takes integer address returns integer
        return l__Memory[ address / 4 ]
    endfunction

    function ReadRealMemorySafe takes integer addr returns integer
        local integer ByteOffset = addr - ( addr / 4 * 4 )
        local integer FirstAddr = addr - ByteOffset
        
        return CreateIntegerFromTwoByOffset( l__Memory[ FirstAddr / 4 ], l__Memory[ FirstAddr / 4 + 1 ] , ByteOffset )
    endfunction

    function ReadUnrealMemory takes integer address returns integer
        if address * 4 < 0x7Fffffff and address > 0x500 then
            return l__Memory[ address ]
        endif

        return 0
    endfunction

    function ReadRealMemory takes integer address returns integer
        if address < 0x500 or address > 0x7FFFFFFF then // MINIMAL_ACCESSABLE_ADDRESS
            return 0
        endif

        if address / 4 * 4 != address then
            return ReadRealMemorySafe( address )
        else
            return ReadMemory( address )
        endif
    endfunction

    function RMem takes integer address returns integer
        return ReadRealMemory( address )
    endfunction
    
    function ReadOffset takes integer pOff returns integer
        return ReadRealMemory( pGameDLL + pOff )
    endfunction

    function ReadOffsetUnsafe takes integer pOff returns integer
        return ReadUnrealMemory( ( pGameDLL + pOff ) / 4 )
    endfunction

    function ReadByte takes integer byte returns integer
        return GetByteFromInteger( ReadRealMemory( byte ), 4 )
    endfunction
    
    function ReadRealFloat takes integer address returns real
        return GetRealFromMemory( ReadRealMemory( address ) )
    endfunction

    function WriteMemory takes integer address, integer value returns nothing
        set l__Memory[ address / 4 ] = value
    endfunction

    function WriteRealMemorySafe takes integer addr, integer val returns nothing
        local integer Int_1
        local integer Int_2
        local integer ByteOffset = addr - ( addr / 4 * 4 )
        local integer FirstAddr = addr - ByteOffset

        set Int_1                           = ReadRealMemory( FirstAddr )
        set Int_2                           = ReadRealMemory( FirstAddr + 0x4 )
        set l__Memory[ FirstAddr / 4 ]      = CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, ByteOffset, true )
        set l__Memory[ FirstAddr / 4 + 1 ]  = CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, ByteOffset, false )
    endfunction

    function WriteUnrealMemory takes integer address, integer value returns nothing
        if address > 0x500 and address * 4 < 0x7FFFFFFF then
            set l__Memory[ address ] = value
            return
        endif
    endfunction

    function WriteRealMemory takes integer address, integer value returns nothing
        if address < 0x500 or address > 0x7FFFFFFF then // MINIMAL_ACCESSABLE_ADDRESS = 0x500
            return
        endif

        if address == pWriteMemory then
            return
        endif

        if address / 4 * 4 != address then
            call WriteRealMemorySafe( address, value )
        else
            call WriteMemory( address, value )
        endif
    endfunction

    function WMem takes integer address, integer value returns nothing
        call WriteRealMemory( address, value )
    endfunction
    
    function WriteOffset takes integer pOff, integer value returns nothing
        call WriteRealMemory( pGameDLL + pOff, value )
    endfunction

    function WriteOffsetUnsafe takes integer pOff, integer value returns nothing
        call WriteUnrealMemory( pGameDLL + pOff, value )
    endfunction

    function WriteRealFloat takes integer address, real value returns nothing
        call WriteRealMemory( address, SetRealIntoMemory( value ) )
    endfunction
    //# +nosemanticerror
    function NewGlobal takes nothing returns integer
        return -0x005E0704  //op: 07(GLOBAL), type: 04(integer), name: 0x005E("i")
        return 0x2700       //op: 27(RETURN)
    endfunction

    //# +nosemanticerror
    function SetGlobal takes nothing returns nothing
        //This will actually set the value of the global variable, not the local
        local integer i = 0x2114D008
    endfunction

    function Malloc takes integer bytes returns integer
        set iBytecodeData = bytes / 4 + 0x4
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( l__Memory[ GetBytecodeAddress( ) / 4 + 0x3 ] + 0x20 ) )
        return ( ReadUnrealMemory( iBytecodeData / 4 + 0x3 ) + 0x4 ) / 4 * 4 // Address of data in the newly created array
    endfunction

    function ConvertPointer takes integer ptr returns integer
        local integer i = ReadRealMemory( ptr )

        if i < 0 then
            return ReadRealMemory( ReadRealMemory( pPointers + 0x2C ) - i * 8 + 0x4 ) //checkme
        endif

        return ReadRealMemory( ReadRealMemory( pPointers + 0xC ) + i * 8 + 0x4 )
    endfunction

    function ReadRealPointer1LVL takes integer addr, integer offset1 returns integer
        local integer retval = 0
        
        if addr > 0 then
            set retval = ReadRealMemory( addr )
            
            if addr > 0 then
                set retval = ReadRealMemory( retval + offset1 )
            else
                set retval = 0
            endif
        endif
        
        return retval
    endfunction

    function WriteRealPointer1LVL takes integer addr, integer offset1, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealMemory( addr )

            if addr > 0 then 
                call WriteRealMemory( retval + offset1, val )
            endif
        endif
    endfunction

    function ReadRealPointer2LVL takes integer addr, integer offset1, integer offset2 returns integer
        local integer retval = ReadRealPointer1LVL( addr, offset1 )
        
        if retval > 0 then
            set retval = ReadRealMemory( retval + offset2 )
        else
            set retval = 0
        endif
        
        return retval
    endfunction

    function WriteRealPointer2LVL takes integer addr, integer offset1, integer offset2, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer1LVL( addr, offset1 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset2, val )
            endif
        endif
    endfunction 

    function ReadRealPointer3LVL takes integer addr, integer offset1, integer offset2, integer offset3 returns integer
        local integer retval = ReadRealPointer2LVL( addr, offset1, offset2 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset3 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer3LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer2LVL( addr, offset1, offset2 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset3, val )
            endif
        endif
    endfunction

    function ReadRealPointer4LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4 returns integer
        local integer retval = ReadRealPointer3LVL( addr, offset1, offset2, offset3 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset4 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer4LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer3LVL( addr, offset1, offset2, offset3 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset4, val )
            endif
        endif
    endfunction

    function ReadRealPointer5LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4, integer offset5 returns integer
        local integer retval = ReadRealPointer4LVL( addr, offset1, offset2, offset3, offset4 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset5 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer5LVL takes integer addr, integer offset1, integer offset2,integer offset3, integer offset4,integer offset5, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer4LVL( addr, offset1, offset2, offset3, offset4 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset5, val )
            endif
        endif
    endfunction

    function IsJassNativeExists takes integer nativeaddress returns boolean
        local integer FirstAddress = ReadRealPointer2LVL( pJassEnvAddress, 0x14, 0x20 )
        local integer NextAddress = FirstAddress
        local integer i = 0

        loop 
            if ReadRealMemory( NextAddress + 0xC ) == nativeaddress then
                return NextAddress > 0
            endif
            
            set NextAddress = ReadRealMemory( NextAddress )
            if NextAddress == FirstAddress or NextAddress == 0 then
                return false
            endif
        endloop

        return false
    endfunction

    function CreateJassNativeHook takes integer oldaddress, integer newaddress returns integer
        local integer FirstAddress    = ReadRealPointer2LVL( pJassEnvAddress, 0x14, 0x20 )
        local integer NextAddress     = FirstAddress
        local integer i = 0
     
        if RJassNativesBufferSize > 0 then
            loop
                set i = i + 1
           
                if RJassNativesBuffer[ i * 3 - 0x3 ] == oldaddress or RJassNativesBuffer[ i * 3 - 0x2 ] == oldaddress or RJassNativesBuffer[ i * 3 - 0x3 ] == newaddress or RJassNativesBuffer[ i * 3 - 0x2 ] == newaddress then
                    call WriteRealMemory( RJassNativesBuffer[ i * 3 - 0x1 ], newaddress )
                    return RJassNativesBuffer[ i * 3 - 0x1 ]
                endif
           
                exitwhen i == RJassNativesBufferSize
            endloop
        endif
     
        loop
            if ReadRealMemory( NextAddress + 0xC ) < 0x3000 then
                return 0
            endif
            
            if ReadRealMemory( NextAddress + 0xC ) == oldaddress then
                call WriteRealMemory( NextAddress + 0xC, newaddress )

                if RJassNativesBufferSize < 100 then
                    set RJassNativesBufferSize = RJassNativesBufferSize + 1
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x1 ] = NextAddress + 0xC
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x2 ] = oldaddress
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x3 ] = newaddress
                endif
           
                return NextAddress + 0xC
            endif
       
            set NextAddress = ReadRealMemory( NextAddress )
            if NextAddress == FirstAddress or NextAddress == 0 then
                return 0
            endif
        endloop
        
        return 0
    endfunction

    function GetJassVM takes integer id returns integer
        local integer result = 0

        if pJassEnvAddress > 0 then
            set result = ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( pJassEnvAddress ) + 0x14 ) + 0x90 ) + 0x4 * id )

            if id == 1 then
                if JassVM <= 0 then
                    set JassVM = result
                endif
            endif
        endif

        return result
    endfunction

    function GetJassTable takes nothing returns integer
        local integer jvm = GetJassVM( 1 )

        if jvm > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( jvm + 0x28A4 ) ) + 0x19C )
        endif

        return 0
    endfunction

    function GetStringAddress takes string s returns integer
        local integer jvm = GetJassVM( 1 )

        if jvm > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( jvm + 0x2874 ) + 0x8 ) + SH2I( s ) * 0x10 + 0x8 ) + 0x1C )
        endif

        return 0
    endfunction

    function BitwiseOperation takes integer memaddr, integer arg1, integer arg2 returns integer
        local integer addr     = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ) )
        local integer func     = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "ConvertUnits" ) )
        local integer retval   = 0

        if addr != 0 and memaddr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, memaddr )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "ConvertUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, memaddr )
                set retval = B2I( ConvertUnits( arg1, arg2 ) )
                call WriteRealMemory( func, addr )
            endif
        endif

        return retval
    endfunction
    
    function ExecuteBytecode takes integer memaddr returns integer
        local integer addr     = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ) )
        local integer func     = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "IgnoredUnits" ) )
        local integer pOffset1 = 0

        if addr != 0 and memaddr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, memaddr )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "IgnoredUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, memaddr )
                set pOffset1 = IgnoredUnits( 0 )
                call WriteRealMemory( func, addr )
            endif
        endif

        return pOffset1
    endfunction    

    function AllocateExecutableMemory takes integer size returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ) )
        local integer func   = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "MergeUnits" ) )
        local integer valloc = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ) )
        local integer retval = 0

        if valloc != 0 and addr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, valloc )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "MergeUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, valloc )
                set retval = B2I( MergeUnits( 0, size + 4, 0x3000, 0x40 ) ) // addr (leave as 0 for autogeneration), size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE
                call WriteRealMemory( func, addr )
            endif

            if retval != 0 then
                return ( retval + 0x4 ) / 4 * 4
            endif
        endif

        return 0
    endfunction

    function AllocatePointerArray takes string name, integer id, integer size returns nothing
        if not HaveSavedInteger( MemHackTable, StringHash( name ), id ) then
            call SaveInteger( MemHackTable, StringHash( name ), id, Malloc( size ) )
            call SaveInteger( MemHackTable, StringHash( name + "Size" ), id, size )
        endif
    endfunction

    //# +nosemanticerror
    function InitMemoryArray takes integer id, integer val returns nothing
        set l__Memory[ id ] = val
    endfunction

    //# +nosemanticerror
     function TypecastMemoryArray takes nothing returns nothing
        local integer Memory // Jasshelper will implicitly rename this to l__Memory
    endfunction

    //# +nosemanticerror
    function GetMemoryArrayAddress takes nothing returns integer
        loop
            return l__Memory
        endloop
            
        return 0
    endfunction

    function UnlockMemEx takes nothing returns nothing
        local integer array i
        local integer a
        local integer b
        local integer offset

        call InitArrayA( 0, 0 )
        call InitArrayA( 0, i[ GetArrayAAddress( ) / 4 ] )
        call InitArrayB( 0, 0 )
        call InitArrayB( 0, i[ GetArrayBAddress( ) / 4 ] )
        call InitArrayC( 0 )
        call InitArrayC( i[ GetArrayCAddress( ) / 4 ] )
        call InitArrayD( 0, 0 )
        call InitArrayD( 0, i[ GetArrayDAddress( ) / 4 ] )
        call InitArrayE( 0 )
        call InitArrayE( i[ GetArrayEAddress( ) / 4 ] )

        set JassVM = i[ i[ i[ i[ pJassEnvAddress / 4 ] / 4 + 5 ] / 4 + 36 ] / 4 + 1 ]

        if JassVM > 0 then
            set JassTable = i[ i[ i[ JassVM / 4 + 0x28A4 / 4 ] / 4 ] / 4 + 0x19C / 4 ]

            if JassTable > 0 then
                set offset = ( i[ GetArrayDAddress( ) / 4 + 3 ] + 4 ) - ( i[ GetArrayBAddress( ) / 4 + 3 ] )
                
                call InitArrayD( 1 + 0x1C / 4, pUnlockCall1 )
                call InitArrayD( 1 + 0xA4 / 4, pUnlockCall2 )
                call InitArrayD( 1 + 0x5C / 4, pUnlockJmp1 )
                call InitArrayD( 1 + 0x04 / 4, GetArrayBAddress( ) - offset + 0x8 )
                call InitArrayD( 1, GetArrayBAddress( ) + 0x8 )
                call InitArrayB( 1, i[ GetArrayDAddress( ) / 4 + 3 ] + 1 * 4 )
                call InitArrayB( 2, pMemory )
                call InitArrayA( 4, i[ GetArrayBAddress( ) / 4 + 3 ] + 4 )

                set b = JassTable - ModuloInteger( i[ GetArrayAAddress( ) / 4 + 3 ] / 4 + 4, 3 )
                set a = ( i[ GetArrayAAddress( ) / 4 + 3 ] / 4 + 4 - b / 4 + 0x2FFFFF ) / 3

                call SetUnitUserData( I2U( a ), 23 )
                call WriteArrayBMemory( 0 + offset / 4, 0xFFFFFFFF )
                call WriteArrayBMemory( 1 + offset / 4, 0 )
                call WriteArrayBMemory( 1 + GetArrayBAddress( ) / 4, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 1, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 2, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 3, 0 )
            endif
        endif
    endfunction

    //# +nosemanticerror
    function UnlockMemory takes nothing returns nothing
        local integer array i
        local boolean IsExtra = false

        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function NewGlobal ) + 0x2 ) )
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function SetGlobal ) + 0x8 ) )
        // local array "i" can now read memory, but not write.
        call InitArray( 0 )
        set pGameDLL = i[ GetArrayAddress( ) / 4 ]
        call InitArray( pGameDLL )
        call InitMemoryArray( 10, 0 )
        set pMemory = GetMemoryArrayAddress( )
        set iGameVersion = pGameDLL - i[ pGameDLL / 4 ]

        if iGameVersion == 0x5084A8 then
            set PatchVersion    = "1.24e"
            set pGameDLL        = pGameDLL - 0x9631B8
            set pJassEnvAddress = pGameDLL + 0xAF16A8
            set pWriteMemory    = pGameDLL + 0x9B26C0
            set pPointers       = ReadRealMemory( pGameDLL + 0xACE5E0 )
    elseif iGameVersion == 0x4F6E60 then
            set PatchVersion    = "1.26a"
            set pGameDLL        = pGameDLL - 0x951060
            set pJassEnvAddress = pGameDLL + 0xADA848
            set pWriteMemory    = pGameDLL + 0xBE6188
            set pPointers       = ReadRealMemory( pGameDLL + 0xAB7788 )
    elseif iGameVersion == 0x277890 then
            set PatchVersion    = "1.27a"
            set pGameDLL        = pGameDLL - 0xA63B30
            set pJassEnvAddress = pGameDLL + 0xBE3740
            set pWriteMemory    = pGameDLL + 0xAB5948
            set pPointers       = ReadRealMemory( pGameDLL + 0xBE40A8 )
    elseif iGameVersion == 0x2C1554 then
            set PatchVersion    = "1.27b"
            set pGameDLL        = pGameDLL - 0xBD7214
            set pJassEnvAddress = pGameDLL + 0xD46118 // Inside ExecuteFunc | under Concurrency::details::ContextBase dword_... = v3
            set pWriteMemory    = pGameDLL + 0xC2E428 // CBuffDrunkenHaze::`RTTI Base Class Array' -> ??_R2CBuffDrunkenHaze@@8
            set pPointers       = ReadRealMemory( pGameDLL + 0xD68610 ) // (int)"Occlusion", (int)"BuildingsOcclude", 0); -> & 0x7FFFFFFF) < *(_DWORD *)(dword_6F... + 60
            set pUnlockCall1    = pGameDLL + 0x3F4C50 // *(_DWORD *)this + 164))(); main func
            set pUnlockCall2    = pGameDLL + 0x124142 // search v1 = a1 > 0.0; -> go to ida -> 3 functions below to push    esi
            set pUnlockJmp1     = pGameDLL + 0x684BA0 // Under "Async set local leader to %s %x:%x for player %d" | (v10 = 
            set IsExtra         = true
    elseif iGameVersion == 0x2BF828 then
            set PatchVersion    = "1.28f"
            set pGameDLL        = pGameDLL - 0xB8A438
            set pJassEnvAddress = pGameDLL + 0xD0DEF8
            set pWriteMemory    = pGameDLL + 0xBEAF90
            set pPointers       = ReadRealMemory( pGameDLL + 0xD30448 )
            set pUnlockCall1    = pGameDLL + 0x428D30
            set pUnlockCall2    = pGameDLL + 0x152802
            set pUnlockJmp1     = pGameDLL + 0x6B8D30
            set IsExtra         = true
        else
            set iGameVersion    = 0
        endif

        // The bytecode unlocks the ability to read and write memory
        // with the "Memory" array

        if IsExtra then // 1.27b and higher required code execution to get access to bytecode.
            call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemEx ) + 0x8 ) )
        endif
        
        call InitBytecode( i[ ( C2I( function ReadMemory ) + 0x34 ) / 4 ], i[ ( GetArrayAddress( ) + 0xC ) / 4 ] + 0x4 )
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( i[ ( GetBytecodeAddress( ) + 0xC ) / 4 ] ) )
    endfunction

    function Init_APIMemory takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x2DDE40 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x2DD9A0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x2DDE00 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x2DDB70 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x2DE730 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x3CB5D0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x3CB650 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x2DD320 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x2DCE80 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x2DD2E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x2DD050 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x2DDC10 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x3CAA90 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x3CAB10 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x891F20 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x890FB0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x88E350 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x890750 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x88CFE0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x1F0710 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x1F04D0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x9BD020 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x9BC0B0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x9B9450 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x9BB850 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x9B80E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x20E150 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x20DF10 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x971FB0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x971040 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x96E3E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x9707E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x96D070 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x240940 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x240700 )
            endif

            call AllocatePointerArray( "StringArray", 0, 3000 )
            call AllocatePointerArray( "PointerArray", 0, 0x10 )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemory takes nothing returns nothing
    //set gg_trg_APIMemory = CreateTrigger(  )
endfunction
//! endnocjass
