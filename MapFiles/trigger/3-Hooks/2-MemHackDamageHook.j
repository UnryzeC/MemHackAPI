//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackDamageEventHook
	function GetDamageEventESPData takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "OnDamageHook" ), StringHash( "Stack" ) )
		local integer len  = 0

        if addr != 0 then
            set len = ReadRealMemory( addr )

            if len > 0 then
                return ReadRealMemory( addr + 0x04 + 0x04 * ( len - 1 ) )
            endif
        endif

		return 0
	endfunction

	function Init_DamageEventHook takes nothing returns nothing
        // This simply grabs data from CDamageData in CUnitOnDamage.
        // To replicate this in C++, we simply save data before calling the function and after.
        // Hence we will have predamage and postdamage data.
        // WriteRealMemorys below simply write asm code to replicate this method.

        local integer vtable          = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ) )
        local integer pOnDamageOffset = vtable + 0x120 // 1.26a = 6F2A40D0 | CUnitOnDamage | 0x4 * 0x48
		local integer pOnDamage       = 0
		local integer oldprot 	      = 0
        local integer pDamageStack    = 0
        local integer pDamageHook     = 0

        if vtable != 0 then
            set oldprot       = ChangeOffsetProtection( pOnDamageOffset, 4, 0x04 )
            set pOnDamage     = ReadRealMemory( pOnDamageOffset )
            set pDamageStack  = Malloc( 0x4 + 0x4 * 1024 ) // MAX_DAMAGE_STACK_SIZE = 1024
            set pDamageHook   = AllocateExecutableMemory( 0x60 ) // due to call WriteRealMemory( pDamageHook + 0x5C, 0x0010C2C9 )

            call SaveInteger( MemHackTable, StringHash( "OnDamageHook" ), StringHash( "Stack" ), pDamageStack )
            call SaveInteger( MemHackTable, StringHash( "OnDamageHook" ), StringHash( "Hook" ), pDamageHook )

            call WriteRealMemory( pOnDamageOffset, pDamageHook )
            call ChangeOffsetProtection( pOnDamageOffset, 0x4, oldprot )

            call WriteRealMemory( pDamageHook + 0x00, 0x8DE58955 )
            call WriteRealMemory( pDamageHook + 0x04, 0x53E82464 )
            call WriteRealMemory( pDamageHook + 0x08, 0xB8F84D89 )
            call WriteRealMemory( pDamageHook + 0x0C, pDamageStack )
            call WriteRealMemory( pDamageHook + 0x10, 0x890C558B )
            call WriteRealMemory( pDamageHook + 0x14, 0x558BE855 )
            call WriteRealMemory( pDamageHook + 0x18, 0x10528B0C )
            call WriteRealMemory( pDamageHook + 0x1C, 0x8BEC5589 )
            call WriteRealMemory( pDamageHook + 0x20, 0x55891055 )
            call WriteRealMemory( pDamageHook + 0x24, 0x14558BF0 )
            call WriteRealMemory( pDamageHook + 0x28, 0x8DF45589 )
            call WriteRealMemory( pDamageHook + 0x2C, 0xC389E84D )
            call WriteRealMemory( pDamageHook + 0x30, 0x4C89138B )
            call WriteRealMemory( pDamageHook + 0x34, 0x03830490 )
            call WriteRealMemory( pDamageHook + 0x38, 0x4D8B9001 )

            call WriteRealMemory( pDamageHook + 0x3C, 0x1475FFF8 )
            call WriteRealMemory( pDamageHook + 0x40, 0x8B1075FF )
            call WriteRealMemory( pDamageHook + 0x44, 0x8B500C45 )
            call WriteRealMemory( pDamageHook + 0x48, 0xB8500845 )
            call WriteRealMemory( pDamageHook + 0x4C, pOnDamage  )
            call WriteRealMemory( pDamageHook + 0x50, 0x4589D0FF ) // call eax (PreviousMethod)
            call WriteRealMemory( pDamageHook + 0x54, 0x012B83FC )
            call WriteRealMemory( pDamageHook + 0x58, 0x5BFC458B )
            call WriteRealMemory( pDamageHook + 0x5C, 0x0010C2C9 )
        endif
	endfunction

    function Init_MemHackDamageEventHook takes nothing returns nothing
        if PatchVersion != "" then
            call Init_DamageEventHook( )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackDamageHook takes nothing returns nothing
    //set gg_trg_MemHackDamageHook = CreateTrigger(  )
endfunction
//! endnocjass
