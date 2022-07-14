//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryRestorer
    function AddNewOffsetToRestore takes integer offsetaddress, integer offsetdefaultdata returns nothing
        local integer len
        local integer i
        local integer arr_hash  = StringHash( "MemRestorerArray" )
        local integer addr_hash = StringHash( "MemRestorerArrayAddr" )
        local integer val_hash  = StringHash( "MemRestorerArrayValue" )

        if offsetaddress == 0 or LoadBoolean( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "IsGameClosing" ) ) then
            return
        endif

        set len = LoadInteger( MemHackTable, arr_hash, StringHash( "Length" ) )
        set i = len
        loop
            exitwhen i == 0

            if LoadInteger( MemHackTable, addr_hash, i ) == offsetaddress then
                return
            endif

            set i = i - 1
        endloop

        set len = len + 1
        call SaveInteger( MemHackTable, addr_hash, len, offsetaddress )
        call SaveInteger( MemHackTable, val_hash, len, offsetdefaultdata )
        call SaveInteger( MemHackTable, arr_hash, StringHash( "Length" ), len )
    endfunction

    function ChangeOffsetProtection takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        local integer addr   = GetFuncFromDll( "Kernel32.dll", "VirtualProtect", true )
        local integer a
        local integer nIndex = 0

        if addr != 0 then
            call AddNewOffsetToRestore( pRealOffset, ReadRealMemory( pRealOffset ) )

            if pMemSize > 0x4 then
                set nIndex = pMemSize / 0x4 - 0x1
                set a = pRealOffset
                loop
                    exitwhen nIndex < 0x1
                    set a = a + 0x4
                    call AddNewOffsetToRestore( a, ReadRealMemory( a ) )
                    set nIndex = nIndex - 0x1
                endloop
            endif

            return VirtualProtect( pRealOffset, pMemSize, pProtectFlag )
        endif

        return 0
    endfunction

    function PatchRealMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprot = 0
        
        if addr != 0 then
            set oldprot = VirtualProtect( addr, size, 0x40 )
            call WriteRealMemory( addr, val )
            call VirtualProtect( addr, size, oldprot )
        endif
    endfunction

    function PatchRealMemory takes integer addr, integer val returns nothing
        call PatchRealMemoryEx( addr, val, 0x4 )
    endfunction

    function PatchMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprot = 0
        
        if addr != 0 then
            set oldprot = VirtualProtect( addr, size, 0x40 )
            call WriteMemory( addr, val )
            call VirtualProtect( addr, size, oldprot )
        endif
    endfunction

    function PatchMemory takes integer addr, integer val returns nothing
        call PatchMemoryEx( addr, val, 0x4 )
    endfunction
    
    function RestoreAllMemory takes nothing returns nothing
        local integer i         = LoadInteger( MemHackTable, StringHash( "MemRestorerArray" ), StringHash( "Length" ) )
        local integer addr_hash = StringHash( "MemRestorerArrayAddr" )
        local integer val_hash  = StringHash( "MemRestorerArrayValue" )
        local integer oldprot

        call SaveBoolean( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "IsGameClosing" ), true )
        loop
            exitwhen i < 1
            set oldprot = ChangeOffsetProtection( LoadInteger( MemHackTable, addr_hash, i ), 0x4, 0x40 )
            call WriteRealMemory( LoadInteger( MemHackTable, addr_hash, i ), LoadInteger( MemHackTable, val_hash, i ) )
            call ChangeOffsetProtection( LoadInteger( MemHackTable, addr_hash, i ), 0x4, oldprot )
            set i = i - 1
        endloop
    endfunction

    function InitExtrasPageDisplayOnExit takes integer pTriggerHandle returns nothing
        local integer pTriggerExecute = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ) )
        local integer pExtrasPage     = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ) )
        local integer pFinalTableHook = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageMemory" ) )
        local integer oldprot         = 0

        if pTriggerExecute != 0 and pExtrasPage != 0 and pFinalTableHook == 0 then
            set pFinalTableHook = AllocateExecutableMemory( 0x1C ) // Old memory size = 60 * 0x4 | size reduced to the amount it actually occupies, aka last offset + 0x4 -> pFinalTableHook + 0x18 => 0x1C

            if pFinalTableHook != 0 then
                set oldprot   = VirtualProtect( pExtrasPage, 0x8, 0x40 )

                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageMemory" ), pFinalTableHook )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal1" ), ReadRealMemory( pExtrasPage + 0x0 ) )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal2" ), ReadRealMemory( pExtrasPage + 0x4 ) )

                call WriteRealMemory( pExtrasPage     + 0x00, 0xE9E9E9E9 )                                     // jmp | jmp | jmp | jmp
                call WriteRealMemory( pExtrasPage     + 0x01, pFinalTableHook - ( pExtrasPage + 0x1 ) - 0x4 )  // redirection to new address
                call WriteRealMemory( pFinalTableHook + 0x00, 0x68609090 )                                     // nop | nop | pusha | push (pTriggerHandle)
                call WriteRealMemory( pFinalTableHook + 0x04, pTriggerHandle )                                 // argument getting pushed
                call WriteRealMemory( pFinalTableHook + 0x08, 0xB890C08B )                                     // mov eax, eax | nop | mov eax, pTriggerExecute
                call WriteRealMemory( pFinalTableHook + 0x0C, pTriggerExecute )                                // argument getting moved into eax
                call WriteRealMemory( pFinalTableHook + 0x10, 0xC483D0FF )                                     // call eax | add esp, 0x4
                call WriteRealMemory( pFinalTableHook + 0x14, 0xE9906104 )                                     // 0x4 | popa | nop | jmp (pExtrasPage)
                call WriteRealMemory( pFinalTableHook + 0x18, pExtrasPage - ( pFinalTableHook + 0x18 ) - 0x4 ) // argument that we jump to
                call VirtualProtect( pExtrasPage, 0x8, oldprot )                                               // Restoring original Memory Protection Method
            endif
        endif
    endfunction

    function DisplayExtrasPageDisplayOnExit takes nothing returns nothing
        local integer pExtrasPage = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ) )
        local integer oldprot     = 0

        if pExtrasPage != 0 then
            set oldprot = VirtualProtect( pExtrasPage, 0x8, 0x40 )
            call WriteRealMemory( pExtrasPage + 0x0, LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal1" ) ) )
            call WriteRealMemory( pExtrasPage + 0x4, LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal2" ) ) )
            call VirtualProtect( pExtrasPage, 0x8, oldprot )
            call RestoreAllMemory( )
        endif
    endfunction

    function Init_RestoreMemoryOnExit takes trigger t returns nothing
        call TriggerAddAction( t, function DisplayExtrasPageDisplayOnExit )
        call InitExtrasPageDisplayOnExit( GetHandleId( t ) )
    endfunction
    
    function Init_APIMemoryRestorer takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x3C4A80 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x5C48C0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x3C3F40 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x5C4120 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x1F9100 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2847F0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x216D90 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2A23E0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x249410 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2D4940 )
            endif

            call SaveInteger( MemHackTable, StringHash( "MemRestorerArray" ), StringHash( "Length" ), 0 )
            call Init_RestoreMemoryOnExit( CreateTrigger( ) )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryRestorer takes nothing returns nothing
    //set gg_trg_APIMemoryRestorer = CreateTrigger(  )
endfunction
//! endnocjass