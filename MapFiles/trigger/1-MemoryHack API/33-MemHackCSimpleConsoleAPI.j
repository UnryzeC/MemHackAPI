//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleConsoleAPI
    function CreateCSimpleConsoleByTagName takes string tagName, integer parent, integer id returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ) )

        if addr != 0 and tagName != "" then
            return fast_call_3( addr, GetStringAddress( tagName ), parent, id )
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleConsoleAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ), pGameDLL + 0x5C9DB0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ), pGameDLL + 0x5C9610 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ), pGameDLL + 0x090A60 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ), pGameDLL + 0x0E47E0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleConsole" ), StringHash( "CreateByTagName" ), pGameDLL + 0x112E30 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleConsoleAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleConsoleAPI = CreateTrigger(  )
endfunction
//! endnocjass
