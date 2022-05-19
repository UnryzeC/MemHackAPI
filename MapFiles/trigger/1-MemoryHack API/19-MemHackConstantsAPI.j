//TESH.scrollpos=69
//TESH.alwaysfold=0
//! nocjass
library MemoryHackConstantsAPI
    function IsOPLimitRemoved takes nothing returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "GetData" ) )

        if addr != 0 then
            return ReadRealMemory( addr ) == 0x6A570FFF // 6A570004
        endif

        return false
    endfunction

    function EnableOPLimitEx takes boolean flag, integer id returns nothing
        local integer addr           = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr" + I2S( id ) ) )
        local integer oldvalue       = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( id ) ) )
        local integer value          = 0
        local integer oldprotection1 = 0

        if addr != 0 then
            if oldvalue == 0 then
                set oldvalue = ReadRealMemory( addr )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( id ) ), ReadRealMemory( addr ) )
            endif

            if oldvalue != 0 then
                if flag then
                    set value = oldvalue
                else
                    set value = 0x6A570FFF
                endif

                set oldprotection1 = ChangeOffsetProtection( addr, 0x4, 0x40 )
                call WriteRealMemory( addr, value )
                //call BJDebugMsg( "ReadRealMemory( addr " + I2S( id ) + " ) = " + IntToHex( ReadRealMemory( addr ) ) )
                call ChangeOffsetProtection( addr, 0x4, oldprotection1 )
            endif
        endif
    endfunction
    
    function EnableOPLimit takes boolean flag returns nothing
        local integer i = 1

        loop
            exitwhen i > 9
            call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( i ) ), 0x0 )
            call EnableOPLimitEx( flag, i )
            set i = i + 1
        endloop
    endfunction
    
    function Init_MemHackConstantsAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A8ECC )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DED64 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E1718 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E1728 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B5F02 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B5FC1 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B5FF3 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x460489 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x460818 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A838C ) // addr4
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DE244 ) // ScriptRunFunctionById limit1
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E0BF8 ) // ScriptRunFunctionById limit2
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E0C08 ) // ScriptRunFunction "main" limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B53C2 ) // jPreloader Limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B5481 ) // config limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B54B3 ) // main limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x45F979 ) // call limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x45FD08 ) // call native limit?
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1BFB4B )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x1E9A01 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x1EF713 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x1F224D )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x7F1975 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x7F2A1C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x8909F7 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x890A07 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x8920A6 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1DD83B )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x207451 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x20D153 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x20FECD )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x91B3B5 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x91C3EC )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x9BBAF7 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x9BBB07 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x9BD1A6 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x2100BB )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x239C21 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x23F943 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x24255C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x8D0305 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x8D133C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x970A87 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x970A97 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x972136 )
            endif

            
        endif
    endfunction
endlibrary
    
//===========================================================================
function InitTrig_MemHackConstantsAPI takes nothing returns nothing
    //set gg_trg_MemHackConstantsAPI = CreateTrigger(  )
endfunction
//! endnocjass
