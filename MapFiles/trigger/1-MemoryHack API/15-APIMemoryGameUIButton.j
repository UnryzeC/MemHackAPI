//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameUIButton
    function IsCommandButton takes integer pButton returns boolean
        return GetFrameTypeName( pButton ) == "CCommandButton"
    endfunction

    function GetButtonData takes integer pCommandButton returns integer
        if IsCommandButton( pCommandButton ) then
            return ReadRealMemory( pCommandButton + 0x190 )
        endif

        return 0
    endfunction

    function GetButtonGoldCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x58C )
        endif

        return -1
    endfunction

    function GetButtonLumberCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x590 )
        endif

        return -1
    endfunction

    function GetButtonManaCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x594 )
        endif

        return -1
    endfunction

    function GetButtonCooldownOld takes integer pCommandButton returns real
        local integer pAbil     = 0
        local integer pAbilId   = 0
        local integer pOrderId  = 0
        local integer goldcost  = 0
        local integer pAbilVal2 = 0
        local integer pButton   = 0
        local real prAbilVal1   = 0.
        local real prAbilVal2   = 0.

        if IsCommandButton( pCommandButton ) then
            set pButton = ReadRealMemory( pCommandButton + 0x190 )

            if pButton > 0 then
                set pAbil    = ReadRealMemory( pButton + 0x6D4 )
                set pAbilId  = ReadRealMemory( pButton + 0x4   )
                set pOrderId = ReadRealMemory( pButton + 0x8   )
                set goldcost = ReadRealMemory( pButton + 0x58C )

                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton = " + IntToHex( pButton ) )
                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton + 0x6D4 = " + IntToHex( pAbil ) )

                if pAbil != 0 and pAbilId != 'AHer' and pAbilId != 'Amai' and pAbilId != 'Asei' and pAbilId != 'Asel' then //  and goldcost == 0
                    set pAbil = ReadRealMemory( pAbil + 0xDC )
                    //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pAbil + 0xDC = " + IntToHex( pAbil ) )

                    if pAbil > 0 then
                        set pAbilVal2 = ReadRealMemory( pAbil + 0x0C )
                        //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "ReadRealMemory( pAbil + 0x0C ) = " + IntToHex( pAbilVal2 ) )

                        if pAbilVal2 > 0 then
                            set prAbilVal1 = GetRealFromMemory( ReadRealMemory( pAbil + 0x04 ) )
                            set prAbilVal2 = GetRealFromMemory( ReadRealMemory( pAbilVal2 + 0x40 ) )
                            
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal1 = " + R2S( pAbilVal2 ) )
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal2 = " + R2S( pAbilVal2 ) )
                            return prAbilVal1 - prAbilVal2
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction

    function GetButtonCooldown takes integer pCommandButton, boolean addcheck returns real
        local integer i           = 0
        local integer pAbil       = 0
        local integer pAbilId     = 0
        local integer flag        = 0
        local integer pOrderId    = 0
        local integer pButtonData = 0
        local integer pTimer      = 0
        local integer pObj        = 0
        local integer arg         = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if IsCommandButton( pCommandButton ) then
            set pButtonData = ReadRealMemory( pCommandButton + 0x190 )

            if pButtonData != 0 then
                set pOrderId = ReadRealMemory( pButtonData + 0x8   )
                set flag     = ReadRealMemory( pButtonData + 0x10  )
                set pAbil    = ReadRealMemory( pButtonData + 0x6D4 )

                if pAbil != 0 then
                     set pAbilId  = ReadRealMemory( pAbil + 0x34 )

                    if pAbilId == 0 or pAbilId == 'AHer' or pAbilId == 'Apit' or pAbilId == 'Asid' or pAbilId == 'Asud' then
                        return 0.
                elseif pAbilId == 'Amai' or pAbilId == 'Asei' or pAbilId == 'Asel' then
                        loop
                            exitwhen i > 12
                            set pObj = ReadRealMemory( pAbil + 0xCC + i * 0x4 )

                            if pObj == pOrderId then
                                // to check for charges -> ReadRealFloat( ReadRealMemory( pAbil + 0x100 + i * 4 ) + 0xC )

                                if ReadRealFloat( pAbil + 0x1C4 + i * 0x1C + 0xC ) != .0 then
                                    set pTimer = pAbil + 0x1C4 + i * 0x1C
                                else
                                    set pTimer = pAbil + 0x318 + i * 0x1C
                                endif

                                if pTimer != 0 then
                                    call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                    return ReadRealFloat( arg + 0x4 )
                                endif
                                exitwhen true
                            endif
                            set i = i + 1
                        endloop
                    else
                        if addcheck and flag == 0x2000401 then
                            return 0.
                        endif

                        set flag = ReadRealMemory( pAbil + 0x20 )

                        if BitwiseAnd( flag, 0x200 ) != 0 and BitwiseAnd( flag, 0x400 ) == 0 then
                            set pTimer = pAbil + 0xD0

                            if pTimer != 0 then
                                call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                return ReadRealFloat( arg + 0x4 )
                            endif
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction
    
    function IsButtonOnCooldown takes integer pCommandButton returns boolean
        return GetButtonCooldown( pCommandButton, true ) > 0.
    endfunction

    function Init_APIMemoryGameUIButton takes nothing returns nothing
        
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameUIButton takes nothing returns nothing
    //set gg_trg_APIMemoryGameUIButton = CreateTrigger(  )
endfunction
//! endnocjass
