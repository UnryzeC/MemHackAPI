//TESH.scrollpos=133
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameAPI
    globals
        integer pStringManager                  = 0
        integer pFDFHashTableList               = 0
        integer pStringHashNodeGrowListArray    = 0
        integer pBaseFrameHashNodeGrowListArray = 0
        integer pReadTOCFile                    = 0
        integer pDefaultCStatus                 = 0
        integer pGetCFrameByName                = 0
        integer pCreateCFrame                   = 0
    endglobals

    function SetStringHashNodeListSize takes integer size returns boolean
        if pStringHashNodeGrowListArray != 0 and pStringManager != 0 then
            if ReadRealMemory( pStringManager + 0x14 ) < size then // if 1.29+ + 0x18
                call this_call_2( pStringHashNodeGrowListArray, pStringManager, size )
            endif

            return true
        endif

        return false
    endfunction
    
    function SetBaseFrameHashNodeListSize takes integer size returns boolean
        if pBaseFrameHashNodeGrowListArray != 0 and pFDFHashTableList != 0 then
            if ReadRealMemory( pFDFHashTableList + 0x14 ) < size then // if 1.29+ + 0x18
                call this_call_2( pBaseFrameHashNodeGrowListArray, pFDFHashTableList, size )
            endif

            return true
        endif

        return false
    endfunction
    
    function LoadTOCFile takes string filename returns integer
        local integer retval = 0

        if pReadTOCFile != 0 and pDefaultCStatus != 0 and SetStringHashNodeListSize( 0xFFFF ) and SetBaseFrameHashNodeListSize( 0xFFFF ) then
            set retval = fast_call_4( pReadTOCFile, GetStringAddress( filename ), pStringManager, pFDFHashTableList, pDefaultCStatus )
            //call ReallocateCallMemory( ) // no longer needed, now also causes crash, as the data integrity even after TOC call is fine.
        endif

        return retval
    endfunction

    function GetCFrameByName takes string name, integer id returns integer
        if pGetCFrameByName > 0 then
            if name != "" then
                return fast_call_2( pGetCFrameByName, GetStringAddress( name ), id )
            endif
        endif

        return 0
    endfunction

    function CreateCFrameEx takes string baseframe, integer parent, integer point, integer relativepoint, integer id returns integer
        if pCreateCFrame > 0 then
            if baseframe != "" then
                return fast_call_5( pCreateCFrame, GetStringAddress( baseframe ), parent, point, relativepoint, id )
            endif
        endif

        return 0
    endfunction

    function CreateCFrame takes string baseframe, integer parent, integer id returns integer
        return CreateCFrameEx( baseframe, parent, 0, 0, id )
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
                set pDefaultCStatus                 = pGameDLL + 0xAA2824
                set pStringManager                  = pGameDLL + 0xAE4074
                set pFDFHashTableList               = pGameDLL + 0xAE40C4
                set pStringHashNodeGrowListArray    = pGameDLL + 0x5CB150
                set pBaseFrameHashNodeGrowListArray = pGameDLL + 0x5D5DF0
                set pReadTOCFile                    = pGameDLL + 0x5D9580
                set pGetCFrameByName                = pGameDLL + 0x5FB110
                set pCreateCFrame                   = pGameDLL + 0x5C9D00
        elseif PatchVersion == "1.26a" then
                set pDefaultCStatus                 = pGameDLL + 0xA8C804
                set pStringManager                  = pGameDLL + 0xACD214
                set pFDFHashTableList               = pGameDLL + 0xACD264
                set pStringHashNodeGrowListArray    = pGameDLL + 0x5CA9B0
                set pBaseFrameHashNodeGrowListArray = pGameDLL + 0x5D5650
                set pReadTOCFile                    = pGameDLL + 0x5D8DE0
                set pDefaultCStatus                 = pGameDLL + 0xA8C804
                set pGetCFrameByName                = pGameDLL + 0x5FA970
                set pCreateCFrame                   = pGameDLL + 0x5C9560
        elseif PatchVersion == "1.27a" then
                set pDefaultCStatus                 = pGameDLL + 0xB662CC
                set pStringManager                  = pGameDLL + 0xBB9CAC
                set pFDFHashTableList               = pGameDLL + 0xBB9CFC
                set pStringHashNodeGrowListArray    = pGameDLL + 0x067560
                set pBaseFrameHashNodeGrowListArray = pGameDLL + 0x066ED0
                set pReadTOCFile                    = pGameDLL + 0x066590
                set pGetCFrameByName                = pGameDLL + 0x09EF40
                set pCreateCFrame                   = pGameDLL + 0x0909C0
        elseif PatchVersion == "1.27b" then
                set pDefaultCStatus                 = pGameDLL + 0xCE3A4C
                set pStringManager                  = pGameDLL + 0xD47744
                set pFDFHashTableList               = pGameDLL + 0xD47794
                set pStringHashNodeGrowListArray    = pGameDLL + 0x0BB550
                set pBaseFrameHashNodeGrowListArray = pGameDLL + 0x0BAEC0
                set pReadTOCFile                    = pGameDLL + 0x0BA580
                set pGetCFrameByName                = pGameDLL + 0x0F2CA0
                set pCreateCFrame                   = pGameDLL + 0x0E4740
        elseif PatchVersion == "1.28f" then
                set pDefaultCStatus                 = pGameDLL + 0xCB1A94
                set pStringManager                  = pGameDLL + 0xD0F524
                set pFDFHashTableList               = pGameDLL + 0xD0F574
                set pStringHashNodeGrowListArray    = pGameDLL + 0x0E9D40
                set pBaseFrameHashNodeGrowListArray = pGameDLL + 0x0E96B0
                set pReadTOCFile                    = pGameDLL + 0x0E8D70
                set pGetCFrameByName                = pGameDLL + 0x1212F0
                set pCreateCFrame                   = pGameDLL + 0x112D90
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
