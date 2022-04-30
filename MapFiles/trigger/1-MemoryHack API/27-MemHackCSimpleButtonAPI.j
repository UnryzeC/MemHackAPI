//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleButtonAPI
    globals
        integer pCreateCSimpleButton            = 0
        integer pSetCSimpleButtonState          = 0
        integer pSetCSimpleButtonStateTexture   = 0
    endglobals

    function CreateCSimpleButton takes integer pParent returns integer
        local integer baseobj = 0

        if pCreateCSimpleButton > 0 then
            set baseobj = StormAllocateMemory( 0x168, "", 0, 0 )

            if baseobj > 0 then
                return this_call_2( pCreateCSimpleButton, baseobj, pParent )
            endif
        endif

        return 0
    endfunction

    function DestroyCSimpleButton takes integer pButton returns boolean
        if pButton > 0 then
            return this_call_2( ReadRealMemory( pButton + 0x8 ), pButton, 1 ) > 0
        endif

        return false
    endfunction
    
    function SetCSimpleButtonStateTexture takes integer pButton, integer state, string texturepath returns boolean
        if pSetCSimpleButtonStateTexture > 0 then
            if pButton > 0 then
                return this_call_3( pSetCSimpleButtonStateTexture, pButton, state, GetStringAddress( texturepath ) ) > 0
            endif
        endif

        return false
    endfunction

    function SetCSimpleButtonState takes integer pButton, integer state returns boolean
        if pSetCSimpleButtonState > 0 then
            if pButton > 0 then
                return this_call_2( pSetCSimpleButtonState, pButton, state ) > 0
            endif
        endif

        return false
    endfunction

    function Init_MemHackCSimpleButtonAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCreateCSimpleButton            = pGameDLL + 0x603880
                set pSetCSimpleButtonState          = pGameDLL + 0x603780
                set pSetCSimpleButtonStateTexture   = pGameDLL + 0x6039C0
        elseif PatchVersion == "1.26a" then
                set pCreateCSimpleButton            = pGameDLL + 0x6030E0
                set pSetCSimpleButtonState          = pGameDLL + 0x602FE0
                set pSetCSimpleButtonStateTexture   = pGameDLL + 0x603220
        elseif PatchVersion == "1.27a" then
                set pCreateCSimpleButton            = pGameDLL + 0x0BB2A0
                set pSetCSimpleButtonState          = pGameDLL + 0x0BB4E0
                set pSetCSimpleButtonStateTexture   = pGameDLL + 0x0BBA40
        elseif PatchVersion == "1.27b" then
                set pCreateCSimpleButton            = pGameDLL + 0x3A1620
                set pSetCSimpleButtonState          = pGameDLL + 0x10F240
                set pSetCSimpleButtonStateTexture   = pGameDLL + 0x10F7A0
        elseif PatchVersion == "1.28f" then
                set pCreateCSimpleButton            = pGameDLL + 0x3D5730
                set pSetCSimpleButtonState          = pGameDLL + 0x13D770
                set pSetCSimpleButtonStateTexture   = pGameDLL + 0x13DCD0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleButtonAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleButtonAPI = CreateTrigger(  )
endfunction
//! endnocjass
