//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSliderAPI
    function SetCSliderCurrentValue takes integer pFrame, real value returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSlider" then // 24
                return this_call_3( addr, pFrame, SetRealIntoMemory( value ), 1 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSliderAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ), pGameDLL + 0x61F610 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ), pGameDLL + 0x61EE70 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ), pGameDLL + 0x0AB3B0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ), pGameDLL + 0x0FF110 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSlider" ), StringHash( "SetCurrentValue" ), pGameDLL + 0x12D780 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSliderAPI takes nothing returns nothing
    //set gg_trg_MemHackCSliderAPI = CreateTrigger(  )
endfunction
//! endnocjass
