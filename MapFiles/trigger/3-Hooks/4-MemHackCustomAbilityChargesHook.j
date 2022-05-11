//TESH.scrollpos=192
//TESH.alwaysfold=0
//! nocjass
library MemoryHackTestAbilityChargesHook
    function GetChargesTable takes nothing returns hashtable
        return LoadHashtableHandle( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "HashTable" ) )
    endfunction

    function InitCustomChargesData takes nothing returns nothing
        local integer i                           = 0
        local integer memSize                     = 0x140 // size = memory + 0x13C | last offset + 0x4 -> so 0x13C + 0x4 => 0x130
        local integer mem                         = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "Memory" ) )
        local integer pHTLoadInteger              = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ) )
        local integer pHTLoadBoolean              = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ) )
        local integer pDrawAbilityCharges         = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ) )
        local integer pCommonAIJumpOut            = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ) )
        local integer pGameUIAbilityChargesCount  = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ) )
        local integer pGameUIAbilityChargesState  = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ) )
        local integer hid                         = 0

        if mem == 0 and pHTLoadInteger != 0 and pHTLoadBoolean != 0 then
            call SaveHashtableHandle( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "HashTable" ), InitHashtable( ) )
            set hid = GetHandleId( GetChargesTable( ) )
            set mem = AllocateExecutableMemory( memSize )

            call WriteRealMemory( mem +   0x0, 0x0824448B )
            call WriteRealMemory( mem +   0x4, 0x7C8B5756 )
            call WriteRealMemory( mem +   0x8, 0x57500C24 )
            call WriteRealMemory( mem +   0xC, 0x8DE8F18B )
            call WriteRealMemory( mem +  0x10, 0x85000372 )

            call WriteRealMemory( mem +  0xF, pDrawAbilityCharges - ( mem + 0xF ) - 0x4 )

            call WriteRealMemory( mem +  0x14, 0x397C75FF )
            call WriteRealMemory( mem +  0x18, 0x777F407E )
            call WriteRealMemory( mem +  0x1C, 0x51605E5F )
            call WriteRealMemory( mem +  0x20, 0x4E8B9090 )
            call WriteRealMemory( mem +  0x24, 0xCC40B830 )
            call WriteRealMemory( mem +  0x28, 0xD0FF6F2D )

            call WriteRealMemory( mem +  0x26, pCommonAIJumpOut )

            call WriteRealMemory( mem +  0x2C, 0x6974C085 )
            call WriteRealMemory( mem +  0x30, 0x8B905159 )
            call WriteRealMemory( mem +  0x34, 0x3476FFD8 )
            call WriteRealMemory( mem +  0x38, 0x99996850 )
            call WriteRealMemory( mem +  0x3C, 0x10B89999 )

            call WriteRealMemory( mem +  0x3A, hid )

            call WriteRealMemory( mem +  0x40, 0xFF6F3CAB )
            call WriteRealMemory( mem +  0x3F, pHTLoadBoolean )

            call WriteRealMemory( mem +  0x44, 0x0CC483D0 )
            call WriteRealMemory( mem +  0x48, 0x4C74C085 )
            call WriteRealMemory( mem +  0x4C, 0x90905990 )
            call WriteRealMemory( mem +  0x50, 0x828B168B )
            call WriteRealMemory( mem +  0x54, 0x00000308 )
            call WriteRealMemory( mem +  0x58, 0x53347E8B )
            call WriteRealMemory( mem +  0x5C, 0xD0FFCE8B )
            call WriteRealMemory( mem +  0x60, 0x533476FF )
            call WriteRealMemory( mem +  0x64, 0x99999968 )
            call WriteRealMemory( mem +  0x68, 0xB8D88B99 )
            
            call WriteRealMemory( mem +  0x65, hid )

            call WriteRealMemory( mem +  0x6C, pHTLoadInteger )

            call WriteRealMemory( mem +  0x70, 0xC483D0FF )
            call WriteRealMemory( mem +  0x74, 0x51C88B0C )
            call WriteRealMemory( mem +  0x78, 0xCF8BD38B )
            call WriteRealMemory( mem +  0x7C, 0x332E10B8 )
            call WriteRealMemory( mem +  0x80, 0x6AD0FF6F )
            
            call WriteRealMemory( mem +  0x7D, pGameUIAbilityChargesCount )

            call WriteRealMemory( mem +  0x84, 0x8BD38B01 )
            call WriteRealMemory( mem +  0x88, 0x2E40B8CF )
            call WriteRealMemory( mem +  0x8C, 0xD0FF6F33 )
            
            call WriteRealMemory( mem +  0x8A, pGameUIAbilityChargesState )

            call WriteRealMemory( mem +  0x90, 0x5F07EB5B )
            call WriteRealMemory( mem +  0x94, 0x0008C25E )
            call WriteRealMemory( mem +  0x98, 0xC2615990 )
            call WriteRealMemory( mem +  0x9C, 0x90900008 )
            call WriteRealMemory( mem +  0xA0, 0x0824448B )
            call WriteRealMemory( mem +  0xA4, 0x7C8B5756 )
            call WriteRealMemory( mem +  0xA8, 0x57500C24 )
            call WriteRealMemory( mem +  0xAC, 0x8390F18B )
            call WriteRealMemory( mem +  0xB0, 0x859008C4 )
            call WriteRealMemory( mem +  0xB4, 0x397C75FF )
            call WriteRealMemory( mem +  0xB8, 0x777F407E )
            call WriteRealMemory( mem +  0xBC, 0x51605E5F )
            call WriteRealMemory( mem +  0xC0, 0x4E8B9090 )
            call WriteRealMemory( mem +  0xC4, 0xCC40B830 )
            call WriteRealMemory( mem +  0xC8, 0xD0FF6F2D )
            
            call WriteRealMemory( mem +  0xC6, pCommonAIJumpOut )

            call WriteRealMemory( mem +  0xCC, 0x6974C085 )
            call WriteRealMemory( mem +  0xD0, 0x8B905159 )
            call WriteRealMemory( mem +  0xD4, 0x3476FFD8 )
            call WriteRealMemory( mem +  0xD8, 0x99996850 )
            call WriteRealMemory( mem +  0xDC, 0x10B89999 )

            call WriteRealMemory( mem +  0xDA, hid )

            call WriteRealMemory( mem +  0xE0, 0xFF6F3CAB )

            call WriteRealMemory( mem +  0xDF, pHTLoadBoolean )

            call WriteRealMemory( mem +  0xE4, 0x0CC483D0 )
            call WriteRealMemory( mem +  0xE8, 0x4C74C085 )
            call WriteRealMemory( mem +  0xEC, 0x90905990 )
            call WriteRealMemory( mem +  0xF0, 0x828B168B )
            call WriteRealMemory( mem +  0xF4, 0x00000308 )
            call WriteRealMemory( mem +  0xF8, 0x53347E8B )
            call WriteRealMemory( mem +  0xFC, 0xD0FFCE8B )
            call WriteRealMemory( mem + 0x100, 0x533476FF )
            call WriteRealMemory( mem + 0x104, 0x99999968 )
            call WriteRealMemory( mem + 0x108, 0xB8D88B99 )

            call WriteRealMemory( mem + 0x105, hid )

            call WriteRealMemory( mem + 0x10C, pHTLoadInteger )

            call WriteRealMemory( mem + 0x110, 0xC483D0FF )
            call WriteRealMemory( mem + 0x114, 0x51C88B0C )
            call WriteRealMemory( mem + 0x118, 0xCF8BD38B )
            call WriteRealMemory( mem + 0x11C, 0x332E10B8 )
            call WriteRealMemory( mem + 0x120, 0x6AD0FF6F )

            call WriteRealMemory( mem + 0x11D, pGameUIAbilityChargesCount )

            call WriteRealMemory( mem + 0x124, 0x8BD38B01 )
            call WriteRealMemory( mem + 0x128, 0x2E40B8CF )
            call WriteRealMemory( mem + 0x12C, 0xD0FF6F33 )

            call WriteRealMemory( mem + 0x12A, pGameUIAbilityChargesState )

            call WriteRealMemory( mem + 0x130, 0x5F07EB5B )
            call WriteRealMemory( mem + 0x134, 0x0008C25E )
            call WriteRealMemory( mem + 0x138, 0xC2615990 )
            call WriteRealMemory( mem + 0x13C, 0x90900008 )

            call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "Memory" ), mem )
        endif
    endfunction

    function InitCustomAbilityAddressChargesHook takes integer pAbil returns nothing
        local integer pDrawAddr     = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ) )
        local integer mem           = LoadInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "Memory" ) )
        local integer pData         = 0
        local integer pAddr         = 0
        local integer oldprotection = 0

        if pDrawAddr != 0 and mem != 0 and pAbil != 0 then
            set pData = ReadRealMemory( pAbil ) + 0x1C4
            set pAddr = ReadRealMemory( pData )

            if pAddr != 0 then
                if pAddr == pDrawAddr or pAddr == pGameDLL + 0x00020AF0 then
                    set oldprotection = ChangeOffsetProtection( pData, 0x4, 0x40 )

                    if pAddr == pDrawAddr then
                        call WriteRealMemory( pData, mem )
                    elseif pAddr == pGameDLL + 0x00020AF0 then
                        call WriteRealMemory( pData, mem + 0xA0 )
                    endif

                    call ChangeOffsetProtection( pData, 0x4, oldprotection )
                else
                    call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Invalid Address: " + I2S( pAddr ) )
                endif
            endif
        endif
    endfunction

    function EnableCustomUnitAbilityCharges takes unit u, integer aid returns nothing
        call SaveBoolean( GetChargesTable( ), GetHandleId( u ), aid, true )
    endfunction

    function DisableCustomUnitAbilityCharges takes unit u, integer aid returns nothing
        call SaveBoolean( GetChargesTable( ), GetHandleId( u ), aid, false )
    endfunction

    function GetCustomUnitAbilityCharges takes unit u, integer aid returns integer
        return LoadInteger( GetChargesTable( ), GetHandleId( u ), aid )
    endfunction

    function SetCustomUnitAbilityCharges takes unit u, integer aid, integer charges returns nothing
        if not HaveSavedBoolean( GetChargesTable( ), GetHandleId( u ), aid ) then
            call InitCustomAbilityAddressChargesHook( GetUnitAbilityData( u, aid, 1 ) )
            call SaveBoolean( GetChargesTable( ), GetHandleId( u ), aid, true )
        endif

        call SaveInteger( GetChargesTable( ), GetHandleId( u ), aid, charges )
    endfunction

    function Init_MemHackCustomAbilityChargesHook takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ), pGameDLL + 0x0385E0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ),          pGameDLL + 0x2DD760 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ),    pGameDLL + 0x333950 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ),    pGameDLL + 0x333980 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ), pGameDLL + 0x0378A0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ),          pGameDLL + 0x2DCC40 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ),    pGameDLL + 0x332E10 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ),    pGameDLL + 0x332E40 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ), pGameDLL + 0x413FE0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ),          pGameDLL + 0x88F250 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ),    pGameDLL + 0x359C00 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ),    pGameDLL + 0x359C30 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ), pGameDLL + 0x431720 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ),          pGameDLL + 0x9BA350 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ),    pGameDLL + 0x3773A0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ),    pGameDLL + 0x3773D0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "DrawAbilityCharges" ), pGameDLL + 0x465830 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "AIJumpOut" ),          pGameDLL + 0x96F2E0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesCount" ),    pGameDLL + 0x3AB4B0 )
                call SaveInteger( MemHackTable, StringHash( "DrawChargesAPI" ), StringHash( "SetChargesState" ),    pGameDLL + 0x3AB4E0 )
            endif

            call InitCustomChargesData( )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCustomAbilityChargesHook takes nothing returns nothing
    //set gg_trg_MemHackCustomAbilityChargesHook = CreateTrigger(  )
endfunction
//! endnocjass
