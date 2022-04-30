//TESH.scrollpos=31
//TESH.alwaysfold=0
//! nocjass
library MemoryHackConstantsAPI
    globals
        integer pOPLimitPos = 0
        integer pGetOPLimit = 0
    endglobals

    function IsOPLimitEnabled takes nothing returns boolean
        return ReadRealMemory( pOPLimitPos ) == 0x6A570FFF
    endfunction

    function EnableOPLimit takes boolean flag returns nothing
        local integer oldprotection1 = 0
        local integer value          = 0

        if pOPLimitPos > 0 then
            if pGetOPLimit == 0 then
                set pGetOPLimit = ReadRealMemory( pOPLimitPos )
            endif
            
            if pGetOPLimit > 0 then
                if flag then
                    set value = pGetOPLimit
                else
                    set value = 0x6A570FFF
                endif

                set oldprotection1 = ChangeOffsetProtection( pOPLimitPos, 0x4, 0x40 )
                call WriteRealMemory( pOPLimitPos, value )
                call ChangeOffsetProtection( pOPLimitPos, 0x4, oldprotection1 )
            endif
        endif
    endfunction
    
    function Init_MemHackConstantsAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pOPLimitPos = pGameDLL + 0x3A8ECC
        elseif PatchVersion == "1.26a" then
                set pOPLimitPos = pGameDLL + 0x3A838C
        elseif PatchVersion == "1.27a" then
                set pOPLimitPos = pGameDLL + 0x1BFB4B // 0, a3, 300000, a5, a6); or check "Script function timeout!" | addr + 0x3
        elseif PatchVersion == "1.27b" then
                set pOPLimitPos = pGameDLL + 0x1DD83B
        elseif PatchVersion == "1.28f" then
                set pOPLimitPos = pGameDLL + 0x2100BB
            endif
        endif
    endfunction
endlibrary
    
//===========================================================================
function InitTrig_MemHackConstantsAPI takes nothing returns nothing
    //set gg_trg_MemHackConstantsAPI = CreateTrigger(  )
endfunction
//! endnocjass
