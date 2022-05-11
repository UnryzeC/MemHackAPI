//TESH.scrollpos=24
//TESH.alwaysfold=0
//! nocjass
library APIMemoryForString
    function ToJString takes integer pCString returns string
        local integer addr = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ) )

        if addr != 0 and pCString != 0 then
            return I2SH( this_call_1( addr, pCString ) )
        endif

        return null
    endfunction

    function WriteCString takes integer pAddr, string text returns nothing
        call WriteRealMemory( pAddr, GetStringAddress( text ) )
    endfunction

    function ConvertNullTerminatedStringToString takes integer pNullTerminatedString returns string
        return ToJString( pNullTerminatedString )
    endfunction

    function WriteNullTerminatedString takes string s, integer pAddr returns nothing
        call WriteRealMemory( pAddr, GetStringAddress( s ) )
    endfunction
    
    function SearchStringValueAddress takes string str returns integer
        local integer addr1   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ) )
        local integer addr2   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ) )
        local integer addr3   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ) )
        local integer s_addr  = 0
        local integer retaddr = 0

        if addr1 != 0 and addr2 != 0 and addr3 != 0 then
            set s_addr = GetStringAddress( str )
            
            if s_addr != 0 then
                set retaddr = this_call_2( addr1, addr2, s_addr )

                if retaddr == 0 or ReadRealMemory( retaddr + 0x1C ) == 0 then 
                    set retaddr = this_call_2( addr1, addr3, s_addr )
                endif

                if retaddr != 0 and ReadRealMemory( retaddr + 0x1C ) != 0 then
                    return ReadRealMemory( retaddr + 0x1C )
                endif
            endif
        endif

        return 0
    endfunction

    function SearchStringValue takes string str returns string
        return ToJString( SearchStringValueAddress( str ) )
    endfunction

    function ReplaceStringValue takes string str, integer newstraddress, integer str_len returns nothing
         local integer retaddr = SearchStringValueAddress( str )

         call CopyMemory( retaddr, newstraddress, str_len )
    endfunction

    function sprintf_Ex takes string format, integer arg1, integer arg2, integer arg3, integer arg4, integer argsize returns string
        local integer addr = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ) )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 then
            if mem != 0 then
                call WriteRealMemory( mem, 0 )

                if argsize == 1 then
                    call c_call_3( addr, mem, GetStringAddress( format ), arg1 )
            elseif argsize == 2 then
                    call c_call_4( addr, mem, GetStringAddress( format ), arg1, arg2 )
            elseif argsize == 3 then
                    call c_call_5( addr, mem, GetStringAddress( format ), arg1, arg2, arg3 )
            elseif argsize == 4 then
                    call c_call_6( addr, mem, GetStringAddress( format ), arg1, arg2, arg3, arg4 )
                endif

                return ToJString( mem )
            endif
        endif

        return ""
    endfunction
    
    function sprintf_1 takes string format, integer arg1 returns string
        return sprintf_Ex( format, arg1, 0, 0, 0, 1 )
    endfunction

    function sprintf_2 takes string format, integer arg1, integer arg2 returns string
        return sprintf_Ex( format, arg1, arg2, 0, 0, 2 )
    endfunction

    function sprintf_3 takes string format, integer arg1, integer arg2, integer arg3 returns string
        return sprintf_Ex( format, arg1, arg2, arg3, 0, 3 )
    endfunction

    function sprintf_4 takes string format, integer arg1, integer arg2, integer arg3, integer arg4 returns string
        return sprintf_Ex( format, arg1, arg2, arg3, arg4, 4 )
    endfunction
    
    function Init_APIMemoryString takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x3BB560 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x5C9670 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xAE409C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xAE4074 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x87F3AC ) )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x3BAA20 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x5C8ED0 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xACD23C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xACD214 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x86D32C ) )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x1DA520 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x06B030 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xBB9CD4 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xBB9CAC )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x94E464 ) )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x1F7F60 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x0BF020 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xD4776C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xD47744 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0xA7C500 ) )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x22A770 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x0ED810 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xD0F54C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xD0F524 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0xA6B3E0 ) )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryString takes nothing returns nothing
    //set gg_trg_APIMemoryString = CreateTrigger(  )
endfunction
//! endnocjass
