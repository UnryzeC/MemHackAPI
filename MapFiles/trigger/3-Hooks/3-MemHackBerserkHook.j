//TESH.scrollpos=93
//TESH.alwaysfold=0
//! nocjass
library MemoryHackBerserkHook
    globals
        integer pBerserkHookProtection = 0
        integer pBerserkOrderAddr      = 0
        integer pBerserkHookMemory     = 0
        integer pBerserkCurMemPos      = 0
        integer pBerserkTotalMemSize   = 0
    endglobals

    function BerserkHookMemAlloc takes integer abilCount returns nothing
        // This is a function that will automatycally allocate necessary memory, this has to be called before BerserkHookEnd( ).
        // The whole point is, to prepare a jump function for the pBerserkOrderAddr, and whatever we write to pBerserkHookMemory, will then be called from pBerserkOrderAddr.
        set pBerserkTotalMemSize = 0x10 * abilCount + 0x4 + 0x4 // size = 0x10 * Abilities hooked + 0x4 (hook start) + 0x4 (hook end)
        // since I hook 3 abilities the result will be -> 0x10 * 3 + 0x4 + 0x4 => 0x30 + 0x8 => 0x38
        set pBerserkHookMemory = AllocateExecutableMemory( pBerserkTotalMemSize )

        //===================================Do NOT touch this!===============================================
        call WriteRealMemory( pBerserkHookMemory +  0x0, 0x3D34418B ) // mov eax, dword ptr[ ecx + 0x34 ];
        //====================================================================================================
    endfunction

    function BerserkHookStart takes nothing returns nothing
        // this has to be called at the very start, so we "remove" function protection, this allows us to modify its bytecode.
        set pBerserkHookProtection = ChangeOffsetProtection( pBerserkOrderAddr, 0xA, 0x40 )
    endfunction

    function BerserkHookEnd takes nothing returns nothing
        // This HAS to be called at the end, so the bytecode is updated with jump to the newly written memory.

        //===================================Do NOT touch this!===============================================
        call WriteRealMemory( pBerserkOrderAddr + 0x0, 0x000000E9 ) // jmp
        call WriteRealMemory( pBerserkOrderAddr + 0x3, 0x00000090 ) // nop
        call WriteRealMemory( pBerserkOrderAddr + 0x1, pBerserkHookMemory - pBerserkOrderAddr - 0x5 )
        set pBerserkHookProtection = ChangeOffsetProtection( pBerserkOrderAddr, 0xA, pBerserkHookProtection )
        //====================================================================================================        
    endfunction

    function SetBerserkOrder takes integer mempos, integer abilId, integer orderId returns nothing
        // Simple function that pushes the said abilId and orderId to the memory position along with the data.
        // This is used in AddBerserkOrder, which is a simplified version, to "remove" the hook, just put an empty abil Id, so the check never picks it up.
        if mempos + 0x10 > pBerserkTotalMemSize then // prevent overflow
            return
        endif

        //===========================Hook Ability Id to change its order Id========================================
        call WriteRealMemory( pBerserkHookMemory + mempos +  0x4,     abilId ) // cmp eax, 'Abil';  | Checks AbilityId
        call WriteRealMemory( pBerserkHookMemory + mempos +  0x8, 0xB8900775 ) // jne next; nop;    | Jump next if not equal
        call WriteRealMemory( pBerserkHookMemory + mempos +  0xC,    orderId ) // mov eax, OrderId; | Sets OrderId to eax
        call WriteRealMemory( pBerserkHookMemory + mempos + 0x10, 0x3D9090C3 ) // retn eax;         | returns eax
        //=========================================================================================================

        // Write at 0x000000C3 to end hooking, this is REQUIRED or game will freeze.
        call WriteRealMemory( pBerserkHookMemory + mempos + 0x14, 0x000000C3 ) // retn | else returns original order (eax)
        // Note, every edit requires for this process to be repeated, until you are finally done.

        set pBerserkCurMemPos = mempos + 0x10
    endfunction

    function SetBerserkOrderByIdEx takes integer abilId, integer newabilId, integer neworderId returns nothing
        local integer i = 0
        local integer mempos = 0

        loop
            set mempos = i * 0x10
            exitwhen mempos > pBerserkCurMemPos

            if ReadRealMemory( mempos + 0x4 ) == abilId then
                call SetBerserkOrder( mempos, newabilId, neworderId )
                return
            endif

            set i = i + 1
        endloop
    endfunction

    function SetBerserkOrderById takes integer abilId, integer neworderId returns nothing
        call SetBerserkOrderByIdEx( abilId, abilId, neworderId )
    endfunction

    function RemoveBerserkOrderById takes integer abilId returns nothing
        call SetBerserkOrderByIdEx( abilId, abilId, 852100 )
    endfunction

    function AddBerserkOrder takes integer abilId, integer orderId returns nothing
        call SetBerserkOrder( pBerserkCurMemPos, abilId, orderId )
    endfunction

    function Init_BerserkHookEx takes integer abilCount returns nothing
        // This is an example, meaning you have to call BerserkAbilityHookStart( ) and BerserkHookMemAlloc( NUMBER ) to allocate memory
        // Then you can add hooks for the abilities with AddBerserkOrder or SetBerserkOrder, AddBerserkOrder simply uses SetBerserkOrder (which is protected from overflow)
        call BerserkHookStart( )
        call BerserkHookMemAlloc( abilCount )

        // These 3 functions will cause 'A000' to return 852099 order id, 'A001' to return 852164 order id and 'A002' to return 852161 order id, instead of the original Berserk order Id.
        call AddBerserkOrder( 'A000', 852099 ) // pBerserkCurMemPos = 0
        call AddBerserkOrder( 'A001', 852164 ) // pBerserkCurMemPos = 0x10
        call AddBerserkOrder( 'A003', 852161 ) // pBerserkCurMemPos = 0x20
        //

        // If you want to "unhook" the ability, you can functions like these: 
        // call SetBerserkOrderByIdEx( 'A000', 'A000', 852100 ) // or call SetBerserkOrderByIdEx( 'A000', 0, 0 ) // but I suggest the former.
        // call RemoveBerserkOrderById( 'A000' ) // this calls to SetBerserkOrderByIdEx
        // call SetBerserkOrderById( 'A000', 852100 ) // this calls to SetBerserkOrderByIdEx
        // Or lastly you can just use the memposition
        // call SetBerserkOrder( 0, 0, 0 ) // as pBerserkCurMemPos = 0 for 'A000' // which would be // call SetBerserkOrder( 0x10, 0, 0 ) // as pBerserkCurMemPos = 0x10 for 'A001'

        call BerserkHookEnd( ) // ALWYS necessary to call at the end, so we push the newly written bytecode to the original function
    endfunction

    function Init_BerserkHook takes nothing returns nothing
        call Init_BerserkHookEx( 3 ) // change with any number you want, this will simply decide how much memory needs to be allocated.
    endfunction

    function Init_MemHackBerserkHook takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pBerserkOrderAddr = pGameDLL + 0x1C7750
        elseif PatchVersion == "1.26a" then
                set pBerserkOrderAddr = pGameDLL + 0x1C6C40
        elseif PatchVersion == "1.27a" then
                set pBerserkOrderAddr = pGameDLL + 0x4C67F0 // return 852100;
        elseif PatchVersion == "1.27b" then
                set pBerserkOrderAddr = pGameDLL + 0x4E3F40
        elseif PatchVersion == "1.28f" then
                set pBerserkOrderAddr = pGameDLL + 0x518060
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
