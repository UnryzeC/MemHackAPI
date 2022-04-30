//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryRestorer
    globals
        boolean bGameIsClosing                = false

        integer array iaOffsetsToRestoreVals
        integer array iaOffsetsToRestore
        integer pExtrasPage                   = 0
        integer pTriggerExecute               = 0
        integer pFinalTableHook               = 0
        integer pOffsetsToRestoreC            = 0
        integer pFinalTableHookRealValue1     = 0
        integer pFinalTableHookRealValue2     = 0
    endglobals

    function AddNewOffsetToRestore takes integer offsetaddress, integer offsetdefaultdata returns nothing
        local integer i

        if bGameIsClosing then
            return
        endif

        set i = pOffsetsToRestoreC
        loop
            exitwhen i == 0
            if iaOffsetsToRestore[ i ] == offsetaddress then
                return
            endif
            set i = i - 1
        endloop

        set pOffsetsToRestoreC = pOffsetsToRestoreC + 1
        set iaOffsetsToRestore[ pOffsetsToRestoreC ] = offsetaddress
        set iaOffsetsToRestoreVals[ pOffsetsToRestoreC ] = offsetdefaultdata
    endfunction

    function ChangeOffsetProtection takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        local integer a
        local integer nIndex = 0

        if pVirtualProtect == 0 then
            set pVirtualProtect = GetModuleProcAddress( "Kernel32.dll", "VirtualProtect" )
        endif

        if pVirtualProtect != 0 then
            call AddNewOffsetToRestore( pRealOffset, ReadRealMemory( pRealOffset ) )
            if pMemSize > 4 then
                set nIndex = pMemSize / 4 - 0x1
                set a = pRealOffset
                loop
                    exitwhen nIndex < 0x1
                    set a = a + 0x4
                    call AddNewOffsetToRestore( a, ReadRealMemory( a ) )
                    set nIndex = nIndex - 0x1
                endloop
            endif
            call std_call_4( pVirtualProtect, pRealOffset, pMemSize, pProtectFlag, pReservedIntArg1 )
            return ReadRealMemory( pReservedIntArg1 )
        endif

        return 0
    endfunction

    function PatchRealMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprotection = VirtualProtect( addr, size, 0x40 )
        call WriteRealMemory( addr, val )
        call VirtualProtect( addr, size, oldprotection )
    endfunction

    function PatchRealMemory takes integer addr, integer val returns nothing
        call PatchRealMemoryEx( addr, val, 0x4 )
    endfunction

    function PatchMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprotection = VirtualProtect( addr, size, 0x40 )
        call WriteMemory( addr, val )
        call VirtualProtect( addr, size, oldprotection )
    endfunction

    function PatchMemory takes integer addr, integer val returns nothing
        call PatchMemoryEx( addr, val, 0x4 )
    endfunction
    
    function RestoreAllMemory takes nothing returns nothing
        local integer i = pOffsetsToRestoreC
        local integer oldprotection

        set bGameIsClosing = true
        loop
            exitwhen i < 1
            set oldprotection = ChangeOffsetProtection( iaOffsetsToRestore[ i ], 0x4, 0x40 )
            call WriteRealMemory( iaOffsetsToRestore[ i ], iaOffsetsToRestoreVals[ i ] )
            call ChangeOffsetProtection( iaOffsetsToRestore[ i ], 0x4, oldprotection )
            set i = i - 1
        endloop
    endfunction

    function InitExtrasPageDisplayOnExit takes integer pTriggerHandle returns nothing
        local integer oldprotection   = VirtualProtect( pExtrasPage, 0x8, 0x40 )
        local integer address         = pExtrasPage

        set pFinalTableHookRealValue1 = ReadRealMemory( pExtrasPage )
        set pFinalTableHookRealValue2 = ReadRealMemory( pExtrasPage + 0x4 )

        call WriteRealMemory( address, 0xE9E9E9E9 )                                                    // jmp | jmp | jmp | jmp
        call WriteRealMemory( address + 1, pFinalTableHook - ( address + 1 ) - 0x4 )                   // redirection to new address
        call WriteRealMemory( pFinalTableHook + 0x00, 0x68609090 )                                     // nop | nop | pusha | push (pTriggerHandle)
        call WriteRealMemory( pFinalTableHook + 0x04, pTriggerHandle )                                 // argument getting pushed
        call WriteRealMemory( pFinalTableHook + 0x08, 0xB890C08B )                                     // mov eax, eax | nop | mov eax, pTriggerExecute
        call WriteRealMemory( pFinalTableHook + 0x0C, pTriggerExecute )                                // argument getting moved into eax
        call WriteRealMemory( pFinalTableHook + 0x10, 0xC483D0FF )                                     // call eax | add esp, 0x4
        call WriteRealMemory( pFinalTableHook + 0x14, 0xE9906104 )                                     // 0x4 | popa | nop | jmp (pExtrasPage)
        call WriteRealMemory( pFinalTableHook + 0x18, pExtrasPage - ( pFinalTableHook + 0x18 ) - 0x4 ) // argument that we jump to
        call VirtualProtect( pExtrasPage, 0x8, oldprotection )                                         // Restoring original Memory Protection Method
    endfunction

    function DisplayExtrasPageDisplayOnExit takes nothing returns nothing
        local integer oldprotection = VirtualProtect( pExtrasPage, 0x8, 0x40 )

        call WriteRealMemory( pExtrasPage, pFinalTableHookRealValue1 )
        call WriteRealMemory( pExtrasPage + 0x4, pFinalTableHookRealValue2 )
        call VirtualProtect( pExtrasPage, 0x8, oldprotection )
        call RestoreAllMemory( )
    endfunction

    function Init_RestoreMemoryOnExit takes trigger t returns nothing
        set pFinalTableHook = AllocateExecutableMemory( 60 * 0x4 )
        call TriggerAddAction( t, function DisplayExtrasPageDisplayOnExit )
        call InitExtrasPageDisplayOnExit( GetHandleId( t ) )
    endfunction
    
    function Init_APIMemoryRestorer takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pTriggerExecute = pGameDLL + 0x3C4A80
                set pExtrasPage     = pGameDLL + 0x5C48C0
        elseif PatchVersion == "1.26a" then
                set pTriggerExecute = pGameDLL + 0x3C3F40
                set pExtrasPage     = pGameDLL + 0x5C4120
        elseif PatchVersion == "1.27a" then
                set pTriggerExecute = pGameDLL + 0x1F9100
                set pExtrasPage     = pGameDLL + 0x2847F0 // 1074331777, (int)sub_6F -> *(_DWORD *)(v3 + 16));
        elseif PatchVersion == "1.27b" then
                set pTriggerExecute = pGameDLL + 0x216D90
                set pExtrasPage     = pGameDLL + 0x2A23E0
        elseif PatchVersion == "1.28f" then
                set pTriggerExecute = pGameDLL + 0x249410
                set pExtrasPage     = pGameDLL + 0x2D4940
            endif
            
            call Init_RestoreMemoryOnExit( CreateTrigger( ) )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryRestorer takes nothing returns nothing
    //set gg_trg_APIMemoryRestorer = CreateTrigger(  )
endfunction
//! endnocjass
