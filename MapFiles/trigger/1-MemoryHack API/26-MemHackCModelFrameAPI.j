//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCModelFrameAPI
    function AddCModelFrameModel takes integer pFrame, string model, integer modeltype returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 15 then
                return this_call_3( addr, pFrame, GetStringAddress( model ), modeltype )
            endif
        endif

        return 0
    endfunction

    function GetCModelFrameHeight takes integer pFrame returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid == 15 then
                return GetRealFromMemory( this_call_1( addr, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function Init_MemHackCModelFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ),  pGameDLL + 0x621D70 )
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x622100 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ),  pGameDLL + 0x6215D0 )
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x621960 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ),  pGameDLL + 0x0A3FA0 )
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x0A4180 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ),  pGameDLL + 0x0F7D00 )
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x0F7EE0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "AddModel" ),  pGameDLL + 0x126370 )
                call SaveInteger( MemHackTable, StringHash( "CModelFrame" ), StringHash( "GetHeight" ), pGameDLL + 0x126550 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCModelFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCModelFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
