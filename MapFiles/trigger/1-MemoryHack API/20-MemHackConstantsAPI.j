//TESH.scrollpos=77
//TESH.alwaysfold=0
//! nocjass
library MemoryHackConstantsAPI
    function IsOPLimitRemoved takes nothing returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ) )

        if addr != 0 then
            return ReadRealMemory( addr ) == 0x7FFFFFFF // 6A570004 -> 0x6A570FFF
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
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( id ) ), oldvalue )
            endif

            if oldvalue != 0 then
                if flag then
                    set value = oldvalue
                else
                    set value = 0x7FFFFFFF // 0x6A570FFF
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
            call EnableOPLimitEx( flag, i )
            set i = i + 1
        endloop
    endfunction

    function Init_MemHackConstantsAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A8ECA )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DED62 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E1716 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E1726 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B5F00 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B5FBF )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B5FF1 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x460487 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x460816 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A838A ) // addr4
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DE242 ) // ScriptRunFunctionById limit1
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E0BF6 ) // ScriptRunFunctionById limit2
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E0C06 ) // ScriptRunFunction "main" limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B53C0 ) // jPreloader Limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B547F ) // config limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B54B1 ) // main limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x45F977 ) // call limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x45FD06 ) // call native limit?
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1BFB49 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x1E99FF )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x1EF711 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x1F224B )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x7F1973 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x7F2A1A )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x8909F5 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x890A05 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x8920A4 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1DD839 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x20744F )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x20D151 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x20FECB )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x91B3B3 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x91C3EC )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x9BBAFA )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x9BBB05 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x9BD1A4 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x2100B9 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x239C1F )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x23F941 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x24255A )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x8D0303 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x8D133A )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x970A85 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x970A95 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x972134 )
            endif
        endif
    endfunction
endlibrary
    
//===========================================================================
function InitTrig_MemHackConstantsAPI takes nothing returns nothing
    //set gg_trg_MemHackConstantsAPI = CreateTrigger(  )
endfunction
//! endnocjass
