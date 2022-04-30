//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCModelFrameAPI
    globals
        integer pAddCModelFrameModel    = 0
        integer pGetCModelFrameHeight   = 0
    endglobals

    function AddCModelFrameModel takes integer pFrame, string model, integer modeltype returns integer
        local integer fid = GetFrameType( pFrame )

        if pAddCModelFrameModel > 0 then
            if fid == 15 then
                return this_call_3( pAddCModelFrameModel, pFrame, GetStringAddress( model ), modeltype )
            endif
        endif

        return 0
    endfunction

    function GetCModelFrameHeight takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if pGetCModelFrameHeight > 0 then
            if fid == 15 then
                return GetRealFromMemory( this_call_1( pGetCModelFrameHeight, pFrame ) )
            endif
        endif

        return 0.
    endfunction

    function Init_MemHackCModelFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pAddCModelFrameModel    = pGameDLL + 0x621D70
                set pGetCModelFrameHeight   = pGameDLL + 0x622100
        elseif PatchVersion == "1.26a" then
                set pAddCModelFrameModel    = pGameDLL + 0x6215D0
                set pGetCModelFrameHeight   = pGameDLL + 0x621960
        elseif PatchVersion == "1.27a" then
                set pAddCModelFrameModel    = pGameDLL + 0x0A3FA0
                set pGetCModelFrameHeight   = pGameDLL + 0x0A4180
        elseif PatchVersion == "1.27b" then
                set pAddCModelFrameModel    = pGameDLL + 0x0F7D00
                set pGetCModelFrameHeight   = pGameDLL + 0x0F7EE0
        elseif PatchVersion == "1.28f" then
                set pAddCModelFrameModel    = pGameDLL + 0x126370
                set pGetCModelFrameHeight   = pGameDLL + 0x126550
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCModelFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCModelFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
