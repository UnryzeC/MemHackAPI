//TESH.scrollpos=6
//TESH.alwaysfold=0
//! nocjass
library APIMemoryMPQ
    function FileExists takes string s returns boolean
        return GetFileAttributes( s ) != -1
    endfunction

    function GetFileSizeFromMPQ takes string source returns integer
        return StormLoadFile( source, 0, 0, 1, 0 )
    endfunction

    function ExportFileFromMPQByAddr takes integer saddr, integer daddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ) )

        if addr != 0 and saddr != 0 and daddr != 0 then
            return fast_call_2( addr, saddr, daddr )
        endif

        return 0
    endfunction

    function ExportFileFromMPQ takes string source, string dest returns boolean
        return ExportFileFromMPQByAddr( GetStringAddress( source ), GetStringAddress( dest ) ) > 0
    endfunction

    function LoadDllFromMPQEx takes string source, string dest, string dllname returns boolean
        if ExportFileFromMPQ( source, dest ) then
            call LoadLibrary( dllname )
            return true
        endif

        return false
    endfunction

    function LoadDllFromMPQ takes string dllname returns boolean
        return LoadDllFromMPQEx( dllname, dllname, dllname )
    endfunction
    
    function Init_APIMemoryMPQ takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x7386A0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x737F00 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x702C50 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x720390 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x754560 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryMPQ takes nothing returns nothing
    //set gg_trg_APIMemoryMPQ = CreateTrigger(  )
endfunction
//! endnocjass
