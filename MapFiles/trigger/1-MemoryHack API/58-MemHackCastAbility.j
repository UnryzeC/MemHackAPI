//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCastAbility
    globals
        integer pCastAbility = 0
    endglobals

    function CastAbilityPosition takes integer aid, unit source, real targX, real targY returns nothing
        // Fits for non-target spells, i.e. Was Stomp and such...
        local integer pData = ConvertHandle( source )

        if pData > 0 then
            set pData = GetUnitAbility( source, aid )

            if pData > 0 then
                call WriteRealMemory( pData + 0xF8, SetRealIntoMemory( targX ) )
                call WriteRealMemory( pData + 0x100, SetRealIntoMemory( targY ) )
                call WriteRealMemory( pData + 0x20, 0x9800 )
                set pData = this_call_1( pCastAbility, pData )
            endif
        endif
    endfunction

    function CastAbilityTarget takes integer aid, unit source, widget target returns nothing
        // Due to memory issues requires std/this calls to use different memory allocation
        // else spells which deals damage immediately on cast will interference with damage-related functions
        // hence why we use separate memory addresses for each unique stdcall and such.
        local integer pData  = 0
        local integer unitHashA = 0
        local integer unitHashB = 0
        local integer flags  = 0

        if GetUnitAbilityLevel( source, aid ) > 0 and target != null then
            set pData = ConvertHandle( target )

            if pData > 0 then
                set unitHashA = ReadRealMemory( pData + 0x0C )
                set unitHashB = ReadRealMemory( pData + 0x10 )

                if unitHashA > 0 and unitHashB > 0 then
                    set pData = ConvertHandle( source )

                    if pData > 0 then
                        set pData = GetUnitAbility( source, aid )

                        if pData > 0 then
                            // Widget is saved via HashGroup, hence we grab our units HashA and HashB and save them to TargetHashGroup
                            call WriteRealMemory( pData + 0xE4, unitHashA )
                            call WriteRealMemory( pData + 0xE8, unitHashB )
                            set flags = ReadRealMemory( pData + 0x20 )

                            if not IsFlagBitSet( flags, 0x10000 ) then
                                // 0x19804 stands for "target", 0x1F020 stands for "target item", 0x9800 stands for point target
                                call WriteRealMemory( pData + 0x20, flags + 0x10000 )
                                set flags = flags + 0x10000
                                if not IsFlagBitSet( flags, 0x1 ) then
                                    call WriteRealMemory( pData + 0x20, flags + 0x1 )
                                endif
                            endif

                            set pData = this_call_1( pCastAbility, pData ) // If value > 0 then cast has been successful.
                        endif
                    endif
                endif
            endif
        endif
    endfunction

    function CastAbilityTargetGround takes integer aid, unit source, integer lvl, real targX, real targY, boolean remove returns nothing
        call UnitAddAbility( source, aid )

        if lvl > 1 then
            call SetUnitAbilityLevel( source, aid, lvl )
        endif

        call CastAbilityPosition( aid, source, targX, targY )
        if remove then
            // Note: channeled abilities stop as soon as ability is removed!
            // This Applies to Chain Lightning and such.
            call UnitRemoveAbility( source, aid )
        endif
    endfunction

    function CastAbilityTargetWidget takes integer aid, unit source, widget target, integer lvl, boolean remove returns nothing
        call UnitAddAbility( source, aid )

        if lvl > 1 then
            call SetUnitAbilityLevel( source, aid, lvl )
        endif

        call CastAbilityTarget( aid, source, target )
        if remove then
            // Note: channeled abilities stop as soon as ability is removed!
            // This Applies to Chain Lightning and such.
            call UnitRemoveAbility( source, aid )
        endif
    endfunction

    function CastAbilityTargetSelf takes integer aid, unit source, integer lvl returns nothing
        call CastAbilityTargetWidget( aid, source, source, lvl, true )
    endfunction
    
    function Init_MemHackCastAbility takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCastAbility = pGameDLL + 0x05CFD0
        elseif PatchVersion == "1.26a" then
                set pCastAbility = pGameDLL + 0x05C3A0
        elseif PatchVersion == "1.27a" then
                set pCastAbility = pGameDLL + 0x3ECB70
        elseif PatchVersion == "1.27b" then
                set pCastAbility = pGameDLL + 0x40A2B0
        elseif PatchVersion == "1.28f" then
                set pCastAbility = pGameDLL + 0x43E390
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCastAbility takes nothing returns nothing
    //set gg_trg_MemHackCastAbility = CreateTrigger(  )
endfunction
//! endnocjass
