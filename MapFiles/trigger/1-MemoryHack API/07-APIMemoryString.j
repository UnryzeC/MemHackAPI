//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryForString
    globals
        integer pConvertString      = 0
        integer pSearchStringAddr1  = 0
        integer pSearchStringAddr2  = 0
        integer pSearchStringValue  = 0
        
        integer pSprintf            = 0
    endglobals

    function ToJString takes integer pCString returns string
        if pCString > 0 then
            return I2SH( this_call_1( pConvertString, pCString ) )
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
        local integer retaddr = this_call_2( pSearchStringValue, pSearchStringAddr1, GetStringAddress( str ) )

        if retaddr == 0 or ReadRealMemory( retaddr + 0x1C ) == 0 then 
            set retaddr = this_call_2( pSearchStringValue, pSearchStringAddr2, GetStringAddress( str ) )
        endif

        if retaddr == 0 or ReadRealMemory( retaddr + 0x1C ) == 0 then 
            return 0
        endif

        return ReadRealMemory( retaddr + 0x1C )
    endfunction

    function SearchStringValue takes string str returns string
        return ToJString( SearchStringValueAddress( str ) )
    endfunction

    function ReplaceStringValue takes string str, integer newstraddress, integer str_len returns nothing
         local integer retaddr = SearchStringValueAddress( str )

         call CopyMemory( retaddr, newstraddress, str_len )
    endfunction

    function sprintf_1 takes string format, integer arg1 returns string
        call c_call_3( ReadRealMemory( pSprintf ), pReservedWritableMemory, GetStringAddress( format ), arg1 )
        return ToJString( pReservedWritableMemory )
    endfunction

    function sprintf_2 takes string format, integer arg1, integer arg2 returns string
        call c_call_4( ReadRealMemory( pSprintf ), pReservedWritableMemory, GetStringAddress( format ), arg1, arg2 )
        return ToJString( pReservedWritableMemory )
    endfunction

    function sprintf_3 takes string format, integer arg1, integer arg2, integer arg3 returns string
        call c_call_5( ReadRealMemory( pSprintf ), pReservedWritableMemory, GetStringAddress( format ), arg1, arg2, arg3 )
        return ToJString( pReservedWritableMemory )
    endfunction

    function sprintf_4 takes string format, integer arg1, integer arg2, integer arg3, integer arg4 returns string
        call c_call_6( ReadRealMemory( pSprintf ), pReservedWritableMemory, GetStringAddress( format ), arg1, arg2, arg3, arg4 )
        return ToJString( pReservedWritableMemory )
    endfunction
    
    function Init_APIMemoryString takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pConvertString      = pGameDLL + 0x3BB560
                set pSearchStringValue  = pGameDLL + 0x5C9670
                set pSearchStringAddr1  = pGameDLL + 0xAE409C
                set pSearchStringAddr2  = pGameDLL + 0xAE4074
                set pSprintf            = pGameDLL + 0x87F3AC
        elseif PatchVersion == "1.26a" then
                set pConvertString      = pGameDLL + 0x3BAA20
                set pSearchStringValue  = pGameDLL + 0x5C8ED0
                set pSearchStringAddr1  = pGameDLL + 0xACD23C
                set pSearchStringAddr2  = pGameDLL + 0xACD214
                set pSprintf            = pGameDLL + 0x86D32C
        elseif PatchVersion == "1.27a" then
                set pConvertString      = pGameDLL + 0x1DA520 // AbilityId2String -> result = sub_6F...(v1);
                set pSearchStringValue  = pGameDLL + 0x06B030 // if (... -> "Warning, string \"%s\" already encountered!"
                set pSearchStringAddr1  = pGameDLL + 0xBB9CD4 // if ( !a1 || !*a1 || !a2 || !a3 ) -> first dword_6F...
                set pSearchStringAddr2  = pGameDLL + 0xBB9CAC // if ( !a1 || !*a1 || !a2 || !a3 ) -> second dword_6F...
                set pSprintf            = pGameDLL + 0x94E464
        elseif PatchVersion == "1.27b" then
                set pConvertString      = pGameDLL + 0x1F7F60
                set pSearchStringValue  = pGameDLL + 0x0BF020
                set pSearchStringAddr1  = pGameDLL + 0xD4776C
                set pSearchStringAddr2  = pGameDLL + 0xD47744
                set pSprintf            = pGameDLL + 0xA7C500
        elseif PatchVersion == "1.28f" then
                set pConvertString      = pGameDLL + 0x22A770
                set pSearchStringValue  = pGameDLL + 0x0ED810
                set pSearchStringAddr1  = pGameDLL + 0xD0F54C
                set pSearchStringAddr2  = pGameDLL + 0xD0F524
                set pSprintf            = pGameDLL + 0xA6B3E0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryString takes nothing returns nothing
    //set gg_trg_APIMemoryString = CreateTrigger(  )
endfunction
//! endnocjass
