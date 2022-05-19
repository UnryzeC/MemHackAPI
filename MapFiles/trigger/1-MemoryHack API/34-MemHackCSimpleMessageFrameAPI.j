//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleMessageFrameAPI
    function SetCSimpleMessageFrameFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ) )
        local string f_name = ""
        
        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CSimpleMessageFrame" then // 23
                return this_call_4( addr, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleMessageFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ), pGameDLL + 0x6042B0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ), pGameDLL + 0x603B10 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ), pGameDLL + 0x0C2E80 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ), pGameDLL + 0x116BE0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleMessageFrame" ), StringHash( "SetFont" ), pGameDLL + 0x145290 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleMessageFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleMessageFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
