//TESH.scrollpos=9
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleFrameAPI
    globals
        integer pGetCSimpleFrameByName      = 0
        integer pCreateCSimpleFrame         = 0
        integer pCreateCSimpleConsole       = 0
        integer pSetCSimpleFrameScale       = 0
        integer pSetCSimpleFramePriority    = 0
        integer pSetCSimpleFrameParent      = 0
    endglobals

    function CreateCSimpleFrame takes integer pParent returns integer
        local integer baseobj = 0

        if pCreateCSimpleFrame > 0 then
            set baseobj = StormAllocateMemory( 0x124, "", 0, 0 )

            if baseobj > 0 then
                return this_call_2( pCreateCSimpleFrame, baseobj, pParent )
            endif
        endif

        return 0
    endfunction
    
    function CreateCSimpleConsole takes string baseCSimpleConsole, integer parent, integer id returns integer
        if pCreateCSimpleConsole > 0 then
            if baseCSimpleConsole != "" then
                return fast_call_3( pCreateCSimpleConsole, GetStringAddress( baseCSimpleConsole ), parent, id )
            endif
        endif

        return 0
    endfunction

    function GetCSimpleFrameByName takes string name, integer id returns integer
        if pGetCSimpleFrameByName > 0 then
            if name != "" then
                return fast_call_2( pGetCSimpleFrameByName, GetStringAddress( name ), id )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFrameScale takes integer pCSimpleFrame, real scale returns integer
        local integer fid = GetFrameType( pCSimpleFrame )

        if pSetCSimpleFrameScale > 0 then
            if fid == 22 or fid == 23 or fid == 39 then
                return this_call_2( pSetCSimpleFrameScale, pCSimpleFrame, SetRealIntoMemory( scale ) )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFramePriority takes integer pCSimpleFrame, integer priority returns integer
        local integer fid = GetFrameType( pCSimpleFrame )

        if pSetCSimpleFramePriority > 0 then
            if fid > 0 then
                if IsFrameLayout( pCSimpleFrame ) then
                    return this_call_2( pSetCSimpleFramePriority, pCSimpleFrame, priority )
                else
                    call WriteRealMemory( pCSimpleFrame + 0xA8, priority ) // if 1.29+ then 0xB0
                    return 1
                endif
            endif
        endif

        return 0
    endfunction

    function SetCSimpleFrameParent takes integer pCSimpleFrame, integer pParentCSimpleFrame returns integer
        if pSetCSimpleFrameParent > 0 then
            if IsFrameLayout( pCSimpleFrame ) and IsFrameLayout( pParentCSimpleFrame ) then
                return this_call_2( pSetCSimpleFrameParent, pCSimpleFrame, pParentCSimpleFrame  )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCreateCSimpleConsole       = pGameDLL + 0x5C9DB0
                set pCreateCSimpleFrame         = pGameDLL + 0x60A410
                set pGetCSimpleFrameByName      = pGameDLL + 0x61CF10
                set pSetCSimpleFrameScale       = pGameDLL + 0x60A1C0
                set pSetCSimpleFramePriority    = pGameDLL + 0x2F64F0
                set pSetCSimpleFrameParent      = pGameDLL + 0x60A120
        elseif PatchVersion == "1.26a" then
                set pCreateCSimpleConsole       = pGameDLL + 0x5C9610
                set pCreateCSimpleFrame         = pGameDLL + 0x609C70
                set pGetCSimpleFrameByName      = pGameDLL + 0x61C770
                set pSetCSimpleFrameScale       = pGameDLL + 0x609A20
                set pSetCSimpleFramePriority    = pGameDLL + 0x2F59B0
                set pSetCSimpleFrameParent      = pGameDLL + 0x609980
        elseif PatchVersion == "1.27a" then
                set pCreateCSimpleConsole       = pGameDLL + 0x090A60
                set pCreateCSimpleFrame         = pGameDLL + 0x0B8C00
                set pGetCSimpleFrameByName      = pGameDLL + 0x0C8FD0
                set pSetCSimpleFrameScale       = pGameDLL + 0x0B9FA0
                set pSetCSimpleFramePriority    = pGameDLL + 0x356430
                set pSetCSimpleFrameParent      = pGameDLL + 0x0BA040
        elseif PatchVersion == "1.27b" then
                set pCreateCSimpleConsole       = pGameDLL + 0x0E47E0
                set pCreateCSimpleFrame         = pGameDLL + 0x10C960
                set pGetCSimpleFrameByName      = pGameDLL + 0x11CD30
                set pSetCSimpleFrameScale       = pGameDLL + 0x10DD00
                set pSetCSimpleFramePriority    = pGameDLL + 0x373BD0
                set pSetCSimpleFrameParent      = pGameDLL + 0x10DDA0
        elseif PatchVersion == "1.28f" then
                set pCreateCSimpleConsole       = pGameDLL + 0x112E30
                set pCreateCSimpleFrame         = pGameDLL + 0x13AE90
                set pGetCSimpleFrameByName      = pGameDLL + 0x14B3E0
                set pSetCSimpleFrameScale       = pGameDLL + 0x13C230
                set pSetCSimpleFramePriority    = pGameDLL + 0x3A7CA0
                set pSetCSimpleFrameParent      = pGameDLL + 0x13C2D0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
