//TESH.scrollpos=111
//TESH.alwaysfold=0
//! nocjass
library MemoryHackBerserkHook
    function BerserkHookMemAlloc takes integer abilCount returns nothing
        local integer mem      = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Memory" ) )
        local integer mem_size = 0
        
        if mem == 0 then
            // This is a function that will automatycally allocate necessary memory, this has to be called before BerserkHookEnd( ).
            // The whole point is, to prepare a jump function for the berserk order hook, and whatever we write to our allocated memory, will then be called from the original function.
            set mem_size = 0x10 * abilCount + 0x4 + 0x4 // size = 0x10 * Abilities hooked + 0x4 (hook start) + 0x4 (hook end)
            // since I hook 3 abilities the result will be -> 0x10 * 3 + 0x4 + 0x4 => 0x30 + 0x8 => 0x38
            set mem = AllocateExecutableMemory( mem_size )

            //===================================Do NOT touch this!===============================================
            call WriteRealMemory( mem + 0x0, 0x3D34418B ) // mov eax, dword ptr[ ecx + 0x34 ];
            //====================================================================================================

            call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemorySize" ), mem_size )
            call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Memory" ), mem )
        endif
    endfunction

    function BerserkHookStart takes nothing returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ) )
        local integer prot = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Protection" ) )
        
        if addr != 0 then
            // this has to be called at the very start, so we "remove" function protection, this allows us to modify its bytecode.
            call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Protection" ), ChangeOffsetProtection( addr, 0xA, 0x40 ) )
        endif

        return addr != 0
    endfunction

    function BerserkHookEnd takes nothing returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ) )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Memory" ) )
        local integer prot = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Protection" ) )
        
        if addr != 0 and mem != 0 then
            // This HAS to be called at the end, so the bytecode is updated with jump to the newly written memory.

            //===================================Do NOT touch this!===============================================
            call WriteRealMemory( addr + 0x0, 0x000000E9 ) // jmp
            call WriteRealMemory( addr + 0x3, 0x00000090 ) // nop
            call WriteRealMemory( addr + 0x1, mem - addr - 0x5 )
            call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Protection" ), ChangeOffsetProtection( addr, 0xA, prot ) )
            //====================================================================================================
        endif
    endfunction

    function SetBerserkOrder takes integer mempos, integer abilId, integer orderId returns nothing
        local integer mem      = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Memory" ) )
        local integer mem_size = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemorySize" ) )
        local integer mem_cur  = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemoryCurrent" ) )

        if mem != 0 then
            // Simple function that pushes the said abilId and orderId to the memory position along with the data.
            // This is used in AddBerserkOrder, which is a simplified version, to "remove" the hook, just put an empty abil Id, so the check never picks it up.
            if mempos + 0x10 > mem_size then // prevent overflow
                return
            endif

            //===========================Hook Ability Id to change its order Id========================================
            call WriteRealMemory( mem + mempos +  0x4,     abilId ) // cmp eax, 'Abil';  | Checks AbilityId
            call WriteRealMemory( mem + mempos +  0x8, 0xB8900775 ) // jne next; nop;    | Jump next if not equal
            call WriteRealMemory( mem + mempos +  0xC,    orderId ) // mov eax, OrderId; | Sets OrderId to eax
            call WriteRealMemory( mem + mempos + 0x10, 0x3D9090C3 ) // retn eax;         | returns eax
            //=========================================================================================================

            // Write at 0x000000C3 to end hooking, this is REQUIRED or game will freeze.
            call WriteRealMemory( mem + mempos + 0x14, 0x000000C3 ) // retn | else returns original order (eax)
            // Note, every edit requires for this process to be repeated, until you are finally done.

            call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemoryCurrent" ), mem_cur + 0x10 )
        endif
    endfunction

    function SetBerserkOrderByIdEx takes integer abilId, integer newabilId, integer neworderId returns nothing
        local integer i       = 0
        local integer mempos  = 0
        local integer mem     = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "Memory" ) )
        local integer mem_cur = LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemoryCurrent" ) )

        if mem != 0 then
            loop
                set mempos = i * 0x10
                exitwhen mempos > mem_cur

                if ReadRealMemory( mem + mempos + 0x4 ) == abilId then
                    call SetBerserkOrder( mempos, newabilId, neworderId )
                    return
                endif

                set i = i + 1
            endloop
        endif
    endfunction

    function SetBerserkOrderById takes integer abilId, integer neworderId returns nothing
        call SetBerserkOrderByIdEx( abilId, abilId, neworderId )
    endfunction

    function RemoveBerserkOrderById takes integer abilId returns nothing
        call SetBerserkOrderByIdEx( abilId, abilId, 852100 )
    endfunction

    function AddBerserkOrder takes integer abilId, integer orderId returns nothing
        call SetBerserkOrder( LoadInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "MemoryCurrent" ) ), abilId, orderId )
    endfunction

    function Init_BerserkHookEx takes integer abilCount returns nothing
        // This is an example, meaning you have to call BerserkAbilityHookStart( ) and BerserkHookMemAlloc( NUMBER ) to allocate memory
        // Then you can add hooks for the abilities with AddBerserkOrder or SetBerserkOrder, AddBerserkOrder simply uses SetBerserkOrder (which is protected from overflow)
        if BerserkHookStart( ) then
            call BerserkHookMemAlloc( abilCount )

            // These 3 functions will cause 'A000' to return 852099 order id, 'A001' to return 852164 order id and 'A002' to return 852161 order id, instead of the original Berserk order Id.
            call AddBerserkOrder( 'A000', 852099 ) // mempos = 0
            call AddBerserkOrder( 'A001', 852164 ) // mempos = 0x10
            call AddBerserkOrder( 'A002', 852161 ) // mempos = 0x20
            //

            // If you want to "unhook" the ability, you can functions like these: 
            // call SetBerserkOrderByIdEx( 'A000', 'A000', 852100 ) // or call SetBerserkOrderByIdEx( 'A000', 0, 0 ) // but I suggest the former.
            // call RemoveBerserkOrderById( 'A000' ) // this calls to SetBerserkOrderByIdEx
            // call SetBerserkOrderById( 'A000', 852100 ) // this calls to SetBerserkOrderByIdEx
            // Or lastly you can just use the memposition
            // call SetBerserkOrder( 0, 0, 0 ) // as mempos = 0 for 'A000' // which would be // call SetBerserkOrder( 0x10, 0, 0 ) // as mempos = 0x10 for 'A001'

            call BerserkHookEnd( ) // ALWYS necessary to call at the end, so we push the newly written bytecode to the original function
        endif
    endfunction

    function Init_BerserkHook takes nothing returns nothing
        call Init_BerserkHookEx( 3 ) // change with any number you want, this will simply decide how much memory needs to be allocated.
    endfunction

    function Init_MemHackBerserkHook takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ), pGameDLL + 0x1C7750 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ), pGameDLL + 0x1C6C40 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ), pGameDLL + 0x4C67F0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ), pGameDLL + 0x4E3F40 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "BerserkHook" ), StringHash( "OrderAddr" ), pGameDLL + 0x518060 )
            endif

            call Init_BerserkHook( )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackBerserkHook takes nothing returns nothing
    //set gg_trg_MemHackBerserkHook = CreateTrigger(  )
endfunction
//! endnocjass