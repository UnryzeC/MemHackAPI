//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackTimerAPI
    function TimerRestart takes timer tmr returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ) )
        local integer data = ConvertHandle( tmr )

        if addr != 0 and data != 0 then
            return this_call_1( addr, data ) != 0
        endif

        return false
    endfunction    
    
    function TimerGetCallbackName takes timer tmr returns string
        return ""
    endfunction

    function Init_MemHackTimerAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ), pGameDLL + 0x3F7480 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ), pGameDLL + 0x3F6940 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ), pGameDLL + 0x2227C0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ), pGameDLL + 0x2403F0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CTimerWar3" ), StringHash( "Restart" ), pGameDLL + 0x272900 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackTimerAPI takes nothing returns nothing
    //set gg_trg_MemHackTimerAPI = CreateTrigger(  )
endfunction
//! endnocjass
