//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryHStormDLL
    globals
        integer pStormDLL = 0
    endglobals

    function StormLoadFile takes string filename, integer ppBuffer, integer pSize, integer extraSizeToAllocate, integer pOverlapped returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 then
            call WriteRealMemory( arg + 0x0, ppBuffer )
            call WriteRealMemory( arg + 0x4, pSize )
            return std_call_5( addr, GetStringAddress( filename ), arg + 0x0, arg + 0x4, 1, 0 )
        endif

        return 0
    endfunction
    
    function StormAllocateMemory takes integer size, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ) )

        if addr != 0 and size > 0 then
            return std_call_4( addr, size, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction

    function StormFreeMemory takes integer memaddr, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ) )

        if addr != 0 and memaddr != 0 then
            return std_call_4( addr, memaddr, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction

    function StormGetMemorySize takes integer memaddr, string name, integer unk_1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ) )

        if addr != 0 and memaddr != 0 then
           return std_call_3( addr, memaddr, GetStringAddress( name ), unk_1 )
        endif

        return 0
    endfunction

    function StormReallocateMemory takes integer memaddr, integer size, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ) )

        if addr != 0 and memaddr != 0 and size > 0 then
            return std_call_5( addr, memaddr, size, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction
    
    function Init_APIMemoryStormDLL takes nothing returns nothing
        if PatchVersion != "" then
            set pStormDLL = GetModuleHandle( "Storm.dll" )

            if pStormDLL != 0 then
                if PatchVersion == "1.24e" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x01CF30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x025F30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x024880 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x024AD0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x026230 )
            elseif PatchVersion == "1.26a" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x01CF30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x025F30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x024880 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x024AD0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x026230 )
            elseif PatchVersion == "1.27a" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x022660 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02B830 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02BE40 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02C000 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02C8B0 )
            elseif PatchVersion == "1.27b" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x0224E0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02B6D0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02BCE0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02BEA0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02C760 )
            elseif PatchVersion == "1.28f" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x022A50 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02BC10 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02C220 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02C3E0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02CC90 )
                endif
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryStormDLL takes nothing returns nothing
    //set gg_trg_APIMemoryStormDLL = CreateTrigger(  )
endfunction
//! endnocjass
