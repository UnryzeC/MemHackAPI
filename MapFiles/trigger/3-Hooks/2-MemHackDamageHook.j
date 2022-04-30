//TESH.scrollpos=36
//TESH.alwaysfold=0
//! nocjass
library MemoryHackDamageEventHook
    globals
		integer pDamageStack 				= 0
		integer pDamageHook  				= 0
        integer pUnitVtable                 = 0
        
        trigger DamageTestTrig = CreateTrigger( )
    endglobals

	function GetDamageEventESPData takes nothing returns integer
		local integer Length = ReadRealMemory( pDamageStack )

		if ( Length > 0 ) then
			return ReadRealMemory( pDamageStack + 0x04 + 0x04 * ( Length - 1 ) )
		endif

		return 0
	endfunction
    
    function PreDamageData takes nothing returns nothing
        call BJDebugMsg( "PreDamageData" )
    endfunction

	function Init_DamageEventHook takes nothing returns nothing
        // This simply grabs data from CDamageData in CUnitOnDamage.
        // To replicate this in C++, we simply save data before calling the function and after.
        // Hence we will have predamage and postdamage data.
        // WriteRealMemorys below simply write asm code to replicate this method.

		local integer pSlot72			= pUnitVtable + 0x120 // 1.26a = 6F2A40D0 | CUnitOnDamage | 0x4 * 0x48
		local integer OldProtection 	= ChangeOffsetProtection( pSlot72, 4, 0x04 )
		local integer PreviousMethod 	= ReadRealMemory( pSlot72 )

		set pDamageStack 				= Malloc( 0x4 + 0x4 * 1024 ) // MAX_DAMAGE_STACK_SIZE = 1024
		set pDamageHook 				= AllocateExecutableMemory( 0x60 ) // due to call WriteRealMemory( pDamageHook + 0x5C, 0x0010C2C9 )

		call WriteRealMemory( pSlot72, pDamageHook )
		call ChangeOffsetProtection( pSlot72, 4, OldProtection )

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
		call WriteRealMemory( pDamageHook + 0x4C, PreviousMethod )
		call WriteRealMemory( pDamageHook + 0x50, 0x4589D0FF ) // call eax (PreviousMethod)
		call WriteRealMemory( pDamageHook + 0x54, 0x012B83FC )
		call WriteRealMemory( pDamageHook + 0x58, 0x5BFC458B )
		call WriteRealMemory( pDamageHook + 0x5C, 0x0010C2C9 )
	endfunction

    function Init_MemHackDamageEventHook takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pUnitVtable = pGameDLL + 0x943A94
        elseif PatchVersion == "1.26a" then
                set pUnitVtable = pGameDLL + 0x931934
        elseif PatchVersion == "1.27a" then
                set pUnitVtable = pGameDLL + 0xA4A704
        elseif PatchVersion == "1.27b" then
                set pUnitVtable = pGameDLL + 0xB77EB0
        elseif PatchVersion == "1.28f" then
                set pUnitVtable = pGameDLL + 0xB68914
            endif

            if pUnitVtable > 0 then
                call Init_DamageEventHook( )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackDamageHook takes nothing returns nothing
    //set gg_trg_MemHackDamageHook = CreateTrigger(  )
endfunction
//! endnocjass
