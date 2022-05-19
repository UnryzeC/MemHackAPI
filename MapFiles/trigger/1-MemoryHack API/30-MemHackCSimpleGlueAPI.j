//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleGlueAPI
    function SetCSimpleGlueFrameScale takes integer pGlueFrame, real scale returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ) )
        local string f_name = ""

        if addr != 0 and pGlueFrame != 0 then
            set f_name = GetFrameTypeName( pGlueFrame )

            if f_name == "CSimpleGlueFrame" then // 21
                return this_call_2( addr, pGlueFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleGlueAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ), pGameDLL + 0x617270 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ), pGameDLL + 0x616AD0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ), pGameDLL + 0x0C19C0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ), pGameDLL + 0x115720 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleGlueFrame" ), StringHash( "SetScale" ), pGameDLL + 0x143DD0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleGlueAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleGlueAPI = CreateTrigger(  )
endfunction
//! endnocjass
