//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCStatusBarAPI
    globals
        integer pSetCStatusBarArt           = 0
        integer pSetCStatusBarMinMaxValue   = 0
    endglobals

    function SetCStatusBarArt takes integer pFrame, string model, integer modeltype returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCStatusBarArt > 0 then
            if fid == 40 then
                return this_call_3( pSetCStatusBarArt, pFrame, GetStringAddress( model ), modeltype )
            endif
        endif

        return 0
    endfunction

    function SetCStatusBarValue takes integer pFrame, real value returns integer
        local integer fid  = GetFrameType( pFrame )
        local real minval  = 0.
        local real maxval  = 0.
        local real curval  = 0.
        local real newval  = 0.

        if fid == 40 then // FUNCTION_CStatusBar__SetValue => 1.27a = 0x0AA870
            set minval = GetRealFromMemory( ReadRealMemory( pFrame + 0x1B4 ) )
            set maxval = GetRealFromMemory( ReadRealMemory( pFrame + 0x1B8 ) )
            set curval = GetRealFromMemory( ReadRealMemory( pFrame + 0x1BC ) )

            if value <= minval then
                set value = minval
            endif
            
            call WriteRealMemory( pFrame + 0x1BC, SetRealIntoMemory( value ) )
            return 1
            //return CallThisCallWith2Args( ReadRealMemory( pFrame + 0xEC ), pFrame, 0 ) ?
        endif

        return 0
    endfunction

    function SetCStatusBarMinMaxValue takes integer pFrame, real minval, real maxval returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCStatusBarMinMaxValue > 0 then
            if fid == 40 then
                return this_call_3( pSetCStatusBarMinMaxValue, pFrame, SetRealIntoMemory( minval ), SetRealIntoMemory( maxval ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCStatusBarAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCStatusBarArt           = pGameDLL + 0x628140
                set pSetCStatusBarMinMaxValue   = pGameDLL + 0x627F60
        elseif PatchVersion == "1.26a" then
                set pSetCStatusBarArt           = pGameDLL + 0x6279A0
                set pSetCStatusBarMinMaxValue   = pGameDLL + 0x6277C0
        elseif PatchVersion == "1.27a" then
                set pSetCStatusBarArt           = pGameDLL + 0x0AA760
                set pSetCStatusBarMinMaxValue   = pGameDLL + 0x0AA7F0
        elseif PatchVersion == "1.27b" then
                set pSetCStatusBarArt           = pGameDLL + 0x0FE4C0
                set pSetCStatusBarMinMaxValue   = pGameDLL + 0x0FE550
        elseif PatchVersion == "1.28f" then
                set pSetCStatusBarArt           = pGameDLL + 0x12CB30
                set pSetCStatusBarMinMaxValue   = pGameDLL + 0x12CBC0
            endif
        endif
    endfunction
endlibrary
//! endnocjass

//===========================================================================
function InitTrig_MemHackCStatusBarAPI takes nothing returns nothing
    //set gg_trg_MemHackCStatusBarAPI = CreateTrigger(  )
endfunction
//! endnocjass
