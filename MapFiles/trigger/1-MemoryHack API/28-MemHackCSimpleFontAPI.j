//TESH.scrollpos=6
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleFontAPI
    globals
        integer pCreateCSimpleFont          = 0
        integer pGetCSimpleFontByName       = 0
        integer pSetCSimpleFontText         = 0
        integer pSetCSimpleFontStringScale  = 0
        integer pSetCSimpleFontStringFont   = 0
        integer pGetCSimpleFontStringHeight = 0
    endglobals

    function CreateCSimpleFont takes integer pParent returns integer
        local integer baseobj = 0

        if pCreateCSimpleFont > 0 then
            set baseobj = StormAllocateMemory( 0xC4, "", 0, 0 )

            if baseobj > 0 then
                return this_call_4( pCreateCSimpleFont, baseobj, pParent, 2, 1 )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFontByName takes string name, integer id returns integer
        if pGetCSimpleFontByName > 0 then
            if name != "" then
                return fast_call_2( pGetCSimpleFontByName, GetStringAddress( name ), id )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFontTextByName takes string name, integer id returns string
        local integer pFrame = GetCSimpleFontByName( name, id )

        // GetFrameTextMaxLength = 0x94
        // GetFrameTextLength = 0x98
        if pFrame > 0 then
            return ToJString( ReadRealMemory( pFrame + 0x9C ) )
        endif

        return ""
    endfunction

    function SetCSimpleFontStringScale takes integer pFrame, real scale returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleFontStringScale > 0 then
            if fid == 19 then
                return this_call_2( pSetCSimpleFontStringScale, pFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFontStringFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleFontStringFont > 0 then
            if fid == 19 then
                return this_call_4( pSetCSimpleFontStringFont, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFontStringHeight takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if pGetCSimpleFontStringHeight > 0 then
            if fid == 19 then
                return GetRealFromMemory( this_call_1( pGetCSimpleFontStringHeight, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function SetCSimpleFontText takes integer pFrame, string text returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleFontText > 0 then
            if fid == 19 then
                return B2I( this_call_2( pSetCSimpleFontText, pFrame, GetStringAddress( text ) ) > 0 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleFontAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCreateCSimpleFont          = pGameDLL + 0x60DD20
                set pGetCSimpleFontByName       = pGameDLL + 0x61CF50
                set pSetCSimpleFontText         = pGameDLL + 0x60D1B0
                set pSetCSimpleFontStringFont   = pGameDLL + 0x60E1C0
                set pGetCSimpleFontStringHeight = pGameDLL + 0x60D710
                set pSetCSimpleFontStringScale  = pGameDLL + 0x60E470
        elseif PatchVersion == "1.26a" then
                set pCreateCSimpleFont          = pGameDLL + 0x60D580
                set pGetCSimpleFontByName       = pGameDLL + 0x61C7B0
                set pSetCSimpleFontText         = pGameDLL + 0x60CA10
                set pSetCSimpleFontStringFont   = pGameDLL + 0x60DA20
                set pGetCSimpleFontStringHeight = pGameDLL + 0x60CF70
                set pSetCSimpleFontStringScale  = pGameDLL + 0x60DCD0
        elseif PatchVersion == "1.27a" then
                set pCreateCSimpleFont          = pGameDLL + 0x0BFB10
                set pGetCSimpleFontByName       = pGameDLL + 0x0C8EF0
                set pSetCSimpleFontText         = pGameDLL + 0x0C1020
                set pSetCSimpleFontStringFont   = pGameDLL + 0x0C0B40
                set pGetCSimpleFontStringHeight = pGameDLL + 0x0C0490
                set pSetCSimpleFontStringScale  = pGameDLL + 0x0C0D90
        elseif PatchVersion == "1.27b" then
                set pCreateCSimpleFont          = pGameDLL + 0x113870
                set pGetCSimpleFontByName       = pGameDLL + 0x11CC50
                set pSetCSimpleFontText         = pGameDLL + 0x114D80
                set pSetCSimpleFontStringFont   = pGameDLL + 0x1148A0
                set pGetCSimpleFontStringHeight = pGameDLL + 0x1141F0
                set pSetCSimpleFontStringScale  = pGameDLL + 0x114AF0
        elseif PatchVersion == "1.28f" then
                set pCreateCSimpleFont          = pGameDLL + 0x141F20
                set pGetCSimpleFontByName       = pGameDLL + 0x14B300
                set pSetCSimpleFontText         = pGameDLL + 0x143430
                set pSetCSimpleFontStringFont   = pGameDLL + 0x142F50
                set pGetCSimpleFontStringHeight = pGameDLL + 0x1428A0
                set pSetCSimpleFontStringScale  = pGameDLL + 0x1431A0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleFontAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleFontAPI = CreateTrigger(  )
endfunction
//! endnocjass
