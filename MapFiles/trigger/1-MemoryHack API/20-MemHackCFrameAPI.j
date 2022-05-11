//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameAPI
    function CreateCFrameByTagNameEx takes string baseframe, integer parent, integer unk1, integer createContext, integer priority returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ) )

        if addr != 0 and baseframe != "" then
            return fast_call_5( addr, GetStringAddress( baseframe ), parent, unk1, createContext, priority )
        endif

        return 0
    endfunction

    function CreateCFrameByTagName takes string baseframe, integer parent, integer id returns integer
        return CreateCFrameByTagNameEx( baseframe, parent, 0, 0, id )
    endfunction

    function GetCFrameByName takes string name, integer id returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ) )

        if addr != 0 and name != "" then
            return fast_call_2( addr, GetStringAddress( name ), id )
        endif

        return 0
    endfunction

    function SetStringHashNodeListSize takes integer size returns boolean
        local integer addr1 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ) )
        local integer addr2 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ) )

        if addr1 != 0 and addr2 != 0 then
            if ReadRealMemory( addr2 + 0x14 ) < size then // if 1.29+ + 0x18
                call this_call_2( addr1, addr2, size )
            endif

            return true
        endif

        return false
    endfunction
    
    function SetBaseFrameHashNodeListSize takes integer size returns boolean
        local integer addr1 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ) )
        local integer addr2 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ) )

        if addr1 != 0 and addr2 != 0 then
            if ReadRealMemory( addr2 + 0x14 ) < size then // if 1.29+ + 0x18
                call this_call_2( addr1, addr2, size )
            endif

            return true
        endif

        return false
    endfunction
    
    function LoadTOCFile takes string filename returns integer
        local integer addr1 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ) )
        local integer addr2 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ) )
        local integer addr3 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ) )
        local integer addr4 = LoadInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ) )
        local integer retval = 0

        if addr1 != 0 and addr2 != 0 and SetStringHashNodeListSize( 0xFFFF ) and SetBaseFrameHashNodeListSize( 0xFFFF ) then
            set retval = fast_call_4( addr1, GetStringAddress( filename ), addr3, addr4, addr2 )
            //call ReallocateCallMemory( ) // no longer needed, now also causes crash, as the data integrity even after TOC call is fine.
        endif

        return retval
    endfunction

    function GetFrameLayoutByType takes integer pFrame, integer fid returns integer
        local boolean case1 = fid ==  4 or fid == 10 or fid == 12 or ( fid >= 18 and fid <= 23 )
        local boolean case2 = fid == 26 or fid == 30 or fid == 39 or ( fid >= 41 and fid <= 45 )
        local boolean case3 = fid == 47 or ( fid >= 49 and fid <= 64 )

        if fid != 0 then
            if case1 or case2 or case3 then
                return pFrame
            else
                return pFrame + 0xB4 // if 1.29+ 0xBC
            endif
        endif

        return 0
    endfunction

    function GetFrameLayout takes integer pFrame returns integer
        return GetFrameLayoutByType( pFrame, GetFrameType( pFrame ) )
    endfunction

    function IsFrameLayoutByType takes integer pFrame, integer fid returns boolean
        return GetFrameLayoutByType( pFrame, fid ) == pFrame
    endfunction

    function IsFrameLayout takes integer pFrame returns boolean
        return GetFrameLayout( pFrame ) == pFrame
    endfunction

    function Init_MemHackCFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ),       pGameDLL + 0x5C9D00 )
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ),             pGameDLL + 0x5FB110 )

                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ),     pGameDLL + 0xAA2824 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ),      pGameDLL + 0xAE4074 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ),        pGameDLL + 0xAE40C4 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ), pGameDLL + 0x5CB150 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ),  pGameDLL + 0x5D5DF0 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ),        pGameDLL + 0x5D9580 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ),       pGameDLL + 0x5C9560 )
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ),             pGameDLL + 0x5FA970 )

                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ),     pGameDLL + 0xA8C804 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ),      pGameDLL + 0xACD214 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ),        pGameDLL + 0xACD264 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ), pGameDLL + 0x5CA9B0 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ),  pGameDLL + 0x5D5650 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ),        pGameDLL + 0x5D8DE0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ),       pGameDLL + 0x0909C0 )
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ),             pGameDLL + 0x09EF40 )

                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ),     pGameDLL + 0xB662CC )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ),      pGameDLL + 0xBB9CAC )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ),        pGameDLL + 0xBB9CFC )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ), pGameDLL + 0x067560 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ),  pGameDLL + 0x066ED0 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ),        pGameDLL + 0x066590 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ),       pGameDLL + 0x0E4740 )
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ),             pGameDLL + 0x0F2CA0 )

                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ),     pGameDLL + 0xCE3A4C )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ),      pGameDLL + 0xD47744 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ),        pGameDLL + 0xD47794 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ), pGameDLL + 0x0BB550 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ),  pGameDLL + 0x0BAEC0 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ),        pGameDLL + 0x0BA580 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "CreateByTagName" ),       pGameDLL + 0x112D90 )
                call SaveInteger( MemHackTable, StringHash( "CFrame" ), StringHash( "GetByName" ),             pGameDLL + 0x1212F0 )

                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "DefaultCStatus" ),     pGameDLL + 0xCB1A94 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "StringManager" ),      pGameDLL + 0xD0F524 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "FDFHashList" ),        pGameDLL + 0xD0F574 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowStringHashNode" ), pGameDLL + 0x0E9D40 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "GrowFrameHashNode" ),  pGameDLL + 0x0E96B0 )
                call SaveInteger( MemHackTable, StringHash( "CFrameAPI" ), StringHash( "ReadTOCFile" ),        pGameDLL + 0x0E8D70 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
