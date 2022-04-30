//TESH.scrollpos=131
//TESH.alwaysfold=0
//! nocjass
library MemoryHackTestAbilityChargesHook
    globals
        integer pDrawAbilityCharges         = 0
        integer pCommonAIJumpOut            = 0
        integer pGameUIAbilityChargesBox    = 0
        integer pGameUIAbilityChargesCount  = 0
        integer pHTLoadInteger              = 0
        integer pHTLoadBoolean              = 0
        integer pUnitUpdateCommandPanel     = 0
    
        hashtable ChargesIndicatorData      = InitHashtable( )
        integer ChargesIndicatorDataHandle  = GetHandleId( ChargesIndicatorData )
        integer pCustomChargesDisplayer     = 0
    endglobals

    function InitCustomChargesData takes nothing returns nothing
        local integer i = 0
        local integer memSize = 0x140 // size = pCustomChargesDisplayer + 0x13C | last offset + 0x4

        set pCustomChargesDisplayer = AllocateExecutableMemory( memSize )

        loop
            exitwhen i > ( memSize - 0x4 )
            call WriteRealMemory( pCustomChargesDisplayer + i, 0x0 )
            set i = i + 4
        endloop

        call WriteRealMemory( pCustomChargesDisplayer +   0x0, 0x0824448B )
        call WriteRealMemory( pCustomChargesDisplayer +   0x4, 0x7C8B5756 )
        call WriteRealMemory( pCustomChargesDisplayer +   0x8, 0x57500C24 )
        call WriteRealMemory( pCustomChargesDisplayer +   0xC, 0x8DE8F18B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x10, 0x85000372 )

        call WriteRealMemory( pCustomChargesDisplayer +  0xF, pDrawAbilityCharges - ( pCustomChargesDisplayer + 0xF ) - 0x4 )

        call WriteRealMemory( pCustomChargesDisplayer +  0x14, 0x397C75FF )
        call WriteRealMemory( pCustomChargesDisplayer +  0x18, 0x777F407E )
        call WriteRealMemory( pCustomChargesDisplayer +  0x1C, 0x51605E5F )
        call WriteRealMemory( pCustomChargesDisplayer +  0x20, 0x4E8B9090 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x24, 0xCC40B830 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x28, 0xD0FF6F2D )

        call WriteRealMemory( pCustomChargesDisplayer +  0x26, pCommonAIJumpOut )

        call WriteRealMemory( pCustomChargesDisplayer +  0x2C, 0x6974C085 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x30, 0x8B905159 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x34, 0x3476FFD8 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x38, 0x99996850 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x3C, 0x10B89999 )

        call WriteRealMemory( pCustomChargesDisplayer +  0x3A, ChargesIndicatorDataHandle )

        call WriteRealMemory( pCustomChargesDisplayer +  0x40, 0xFF6F3CAB )
        call WriteRealMemory( pCustomChargesDisplayer +  0x3F, pHTLoadBoolean )

        call WriteRealMemory( pCustomChargesDisplayer +  0x44, 0x0CC483D0 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x48, 0x4C74C085 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x4C, 0x90905990 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x50, 0x828B168B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x54, 0x00000308 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x58, 0x53347E8B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x5C, 0xD0FFCE8B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x60, 0x533476FF )
        call WriteRealMemory( pCustomChargesDisplayer +  0x64, 0x99999968 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x68, 0xB8D88B99 )
        
        call WriteRealMemory( pCustomChargesDisplayer +  0x65, ChargesIndicatorDataHandle )

        call WriteRealMemory( pCustomChargesDisplayer +  0x6C, pHTLoadInteger )

        call WriteRealMemory( pCustomChargesDisplayer +  0x70, 0xC483D0FF )
        call WriteRealMemory( pCustomChargesDisplayer +  0x74, 0x51C88B0C )
        call WriteRealMemory( pCustomChargesDisplayer +  0x78, 0xCF8BD38B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x7C, 0x332E10B8 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x80, 0x6AD0FF6F )
        
        call WriteRealMemory( pCustomChargesDisplayer +  0x7D, pGameUIAbilityChargesBox )

        call WriteRealMemory( pCustomChargesDisplayer +  0x84, 0x8BD38B01 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x88, 0x2E40B8CF )
        call WriteRealMemory( pCustomChargesDisplayer +  0x8C, 0xD0FF6F33 )
        
        call WriteRealMemory( pCustomChargesDisplayer +  0x8A, pGameUIAbilityChargesCount )

        call WriteRealMemory( pCustomChargesDisplayer +  0x90, 0x5F07EB5B )
        call WriteRealMemory( pCustomChargesDisplayer +  0x94, 0x0008C25E )
        call WriteRealMemory( pCustomChargesDisplayer +  0x98, 0xC2615990 )
        call WriteRealMemory( pCustomChargesDisplayer +  0x9C, 0x90900008 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xA0, 0x0824448B )
        call WriteRealMemory( pCustomChargesDisplayer +  0xA4, 0x7C8B5756 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xA8, 0x57500C24 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xAC, 0x8390F18B )
        call WriteRealMemory( pCustomChargesDisplayer +  0xB0, 0x859008C4 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xB4, 0x397C75FF )
        call WriteRealMemory( pCustomChargesDisplayer +  0xB8, 0x777F407E )
        call WriteRealMemory( pCustomChargesDisplayer +  0xBC, 0x51605E5F )
        call WriteRealMemory( pCustomChargesDisplayer +  0xC0, 0x4E8B9090 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xC4, 0xCC40B830 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xC8, 0xD0FF6F2D )
        
        call WriteRealMemory( pCustomChargesDisplayer +  0xC6, pCommonAIJumpOut )

        call WriteRealMemory( pCustomChargesDisplayer +  0xCC, 0x6974C085 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xD0, 0x8B905159 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xD4, 0x3476FFD8 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xD8, 0x99996850 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xDC, 0x10B89999 )

        call WriteRealMemory( pCustomChargesDisplayer +  0xDA, ChargesIndicatorDataHandle )

        call WriteRealMemory( pCustomChargesDisplayer +  0xE0, 0xFF6F3CAB )

        call WriteRealMemory( pCustomChargesDisplayer +  0xDF, pHTLoadBoolean )

        call WriteRealMemory( pCustomChargesDisplayer +  0xE4, 0x0CC483D0 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xE8, 0x4C74C085 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xEC, 0x90905990 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xF0, 0x828B168B )
        call WriteRealMemory( pCustomChargesDisplayer +  0xF4, 0x00000308 )
        call WriteRealMemory( pCustomChargesDisplayer +  0xF8, 0x53347E8B )
        call WriteRealMemory( pCustomChargesDisplayer +  0xFC, 0xD0FFCE8B )
        call WriteRealMemory( pCustomChargesDisplayer + 0x100, 0x533476FF )
        call WriteRealMemory( pCustomChargesDisplayer + 0x104, 0x99999968 )
        call WriteRealMemory( pCustomChargesDisplayer + 0x108, 0xB8D88B99 )

        call WriteRealMemory( pCustomChargesDisplayer + 0x105, ChargesIndicatorDataHandle )

        call WriteRealMemory( pCustomChargesDisplayer + 0x10C, pHTLoadInteger )

        call WriteRealMemory( pCustomChargesDisplayer + 0x110, 0xC483D0FF )
        call WriteRealMemory( pCustomChargesDisplayer + 0x114, 0x51C88B0C )
        call WriteRealMemory( pCustomChargesDisplayer + 0x118, 0xCF8BD38B )
        call WriteRealMemory( pCustomChargesDisplayer + 0x11C, 0x332E10B8 )
        call WriteRealMemory( pCustomChargesDisplayer + 0x120, 0x6AD0FF6F )

        call WriteRealMemory( pCustomChargesDisplayer + 0x11D, pGameUIAbilityChargesBox )

        call WriteRealMemory( pCustomChargesDisplayer + 0x124, 0x8BD38B01 )
        call WriteRealMemory( pCustomChargesDisplayer + 0x128, 0x2E40B8CF )
        call WriteRealMemory( pCustomChargesDisplayer + 0x12C, 0xD0FF6F33 )

        call WriteRealMemory( pCustomChargesDisplayer + 0x12A, pGameUIAbilityChargesCount )

        call WriteRealMemory( pCustomChargesDisplayer + 0x130, 0x5F07EB5B )
        call WriteRealMemory( pCustomChargesDisplayer + 0x134, 0x0008C25E )
        call WriteRealMemory( pCustomChargesDisplayer + 0x138, 0xC2615990 )
        call WriteRealMemory( pCustomChargesDisplayer + 0x13C, 0x90900008 )
    endfunction

    function InitCustomAbilityAddressChargesHook takes integer pAbil returns nothing
        local integer pData         = 0
        local integer pAddr         = 0
        local integer oldprotection = 0

        if pAbil > 0 then
            set pData = ReadRealMemory( pAbil ) + 0x1C4
            set pAddr = ReadRealMemory( pData )

            if pAddr > 0 then
                if pAddr == pDrawAbilityCharges or pAddr == pGameDLL + 0x00020AF0 then
                    set oldprotection = ChangeOffsetProtection( pData, 0x4, 0x40 )

                    if pAddr == pDrawAbilityCharges then
                        call WriteRealMemory( pData, pCustomChargesDisplayer )
                    elseif pAddr == pGameDLL + 0x00020AF0 then
                        call WriteRealMemory( pData, pCustomChargesDisplayer + 0xA0 )
                    endif

                    call ChangeOffsetProtection( pData, 0x4, oldprotection )
                else
                    call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Invalid Address: " + I2S( pAddr ) )
                endif
            endif
        endif
    endfunction

    function EnableCustomUnitAbilityCharges takes unit u, integer aid returns nothing
        call SaveBoolean( ChargesIndicatorData, GetHandleId( u ), aid, true )
    endfunction

    function DisableCustomUnitAbilityCharges takes unit u, integer aid returns nothing
        call SaveBoolean( ChargesIndicatorData, GetHandleId( u ), aid, false )
    endfunction

    function GetCustomUnitAbilityCharges takes unit u, integer aid returns integer
        return LoadInteger( ChargesIndicatorData, GetHandleId( u ), aid )
    endfunction

    function SetCustomUnitAbilityCharges takes unit u, integer aid, integer charges returns nothing
        if not HaveSavedBoolean( ChargesIndicatorData, GetHandleId( u ), aid ) then
            call InitCustomAbilityAddressChargesHook( GetUnitAbilityData( u, aid, 1 ) )
            call SaveBoolean( ChargesIndicatorData, GetHandleId( u ), aid, true )
        endif

        call SaveInteger( ChargesIndicatorData, GetHandleId( u ), aid, charges )
    endfunction

    function Init_MemHackCustomAbilityChargesHook takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pDrawAbilityCharges         = pGameDLL + 0x0385E0
                set pCommonAIJumpOut            = pGameDLL + 0x2DD760
                set pGameUIAbilityChargesBox    = pGameDLL + 0x333950
                set pGameUIAbilityChargesCount  = pGameDLL + 0x333980
                set pHTLoadInteger              = pGameDLL + 0x3CB5D0
                set pHTLoadBoolean              = pGameDLL + 0x3CB650
        elseif PatchVersion == "1.26a" then
                set pDrawAbilityCharges         = pGameDLL + 0x0378A0
                set pCommonAIJumpOut            = pGameDLL + 0x2DCC40
                set pGameUIAbilityChargesBox    = pGameDLL + 0x332E10
                set pGameUIAbilityChargesCount  = pGameDLL + 0x332E40
                set pHTLoadInteger              = pGameDLL + 0x3CAA90
                set pHTLoadBoolean              = pGameDLL + 0x3CAB10
        elseif PatchVersion == "1.27a" then
                set pDrawAbilityCharges         = pGameDLL + 0x413FE0 // !(*(int (**)(void))(*a1 + 788))() && (!a3 || a4 == v4[27]) )
                set pCommonAIJumpOut            = pGameDLL + 0x88F250 // GetBuilding -> JUMPOUT
                set pGameUIAbilityChargesBox    = pGameDLL + 0x359C00 // v9, v7 + 852027, v11, a2, v9);
                set pGameUIAbilityChargesCount  = pGameDLL + 0x359C30 // under ^
                set pHTLoadInteger              = pGameDLL + 0x1F0710 // LoadInteger
                set pHTLoadBoolean              = pGameDLL + 0x1F04D0 // LoadBoolean
        elseif PatchVersion == "1.27b" then
                set pDrawAbilityCharges         = pGameDLL + 0x431720
                set pCommonAIJumpOut            = pGameDLL + 0x9BA350
                set pGameUIAbilityChargesBox    = pGameDLL + 0x3773A0
                set pGameUIAbilityChargesCount  = pGameDLL + 0x3773D0
                set pHTLoadInteger              = pGameDLL + 0x20E150
                set pHTLoadBoolean              = pGameDLL + 0x20DF10
        elseif PatchVersion == "1.28f" then
                set pDrawAbilityCharges         = pGameDLL + 0x465830
                set pCommonAIJumpOut            = pGameDLL + 0x96F2E0
                set pGameUIAbilityChargesBox    = pGameDLL + 0x3AB4B0
                set pGameUIAbilityChargesCount  = pGameDLL + 0x3AB4E0
                set pHTLoadInteger              = pGameDLL + 0x240940
                set pHTLoadBoolean              = pGameDLL + 0x240700
            endif

            if pDrawAbilityCharges > 0 then
                call InitCustomChargesData( )
                //call ReallocateCallMemory( )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCustomAbilityChargesHook takes nothing returns nothing
    //set gg_trg_MemHackCustomAbilityChargesHook = CreateTrigger(  )
endfunction
//! endnocjass
