//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackzDrawCooldowns
    function GetCDTable takes nothing returns hashtable
        return LoadHashtableHandle( MemHackTable, StringHash( "DrawCooldown" ), StringHash( "HashTable" ) )
    endfunction

    function GetBTableShadow takes integer buttonId, integer id returns integer
        return LoadInteger( GetCDTable( ), StringHash( "Button_" + I2S( buttonId ) ), StringHash( "Shadow_" + I2S( id ) ) )
    endfunction

    function GetBTableText takes integer buttonId returns integer
        return LoadInteger( GetCDTable( ), StringHash( "Button_" + I2S( buttonId ) ), StringHash( "Text" ) )
    endfunction

    function DrawButtonCooldown takes integer id, integer pButton returns boolean
        local integer i = 0
        local real cd
        local string text = ""

        if pButton > 0 then
            set cd = GetButtonCooldown( pButton, false ) //GetButtonCooldown

            if cd > 0. then
                if cd >= 10. then
                    set text = I2S( R2I( cd ) )
                else
                    set text = R2SW( cd, 1, 1 )
                endif
            endif

            loop
                exitwhen i > 7
                //if i == 0 or i == 3 or i == 7 then
                    call SetCSimpleFontText( GetBTableShadow( id, i ), text )
                //endif
                set i = i + 1
            endloop

            call SetCSimpleFontText( GetBTableText( id ), text )
            return true
        endif

        return false
    endfunction

    function CreateButtonCooldown takes integer id, integer pButton returns boolean
        local integer pFrame = 0
        local integer i = 0

        if pButton != 0 then
            loop
                exitwhen i > 7
                //if i == 0 or i == 3 or i == 7 then
                    set pFrame = CreateCSimpleFont( pButton )
                    call SetCSimpleRegionVertexColourEx( pFrame, 0xFF, 0x00, 0x00, 0x00 )
                    call SetCSimpleFontStringFont( pFrame, "Fonts\\FRIZQT__.TTF", .1, 0 )
                    call SetCSimpleFontText( pFrame, "" )
                    call SetCSimpleFontStringScale( pFrame, 1.5 )
                    call SaveInteger( GetCDTable( ), StringHash( "Button_" + I2S( id ) ), StringHash( "Shadow_" + I2S( i ) ), pFrame )
                //endif
                set i = i + 1
            endloop

            set pFrame = CreateCSimpleFont( pButton )
            call SetCSimpleRegionVertexColourEx( pFrame, 0xFF, 0xFF, 0xFF, 0xFF )
            call SetCSimpleFontStringFont( pFrame, "Fonts\\FRIZQT__.TTF", .095, 0 )
            call SetCSimpleFontText( pFrame, "" )
            call SetFramePoint( pFrame, ANCHOR_CENTER, pButton, ANCHOR_CENTER, 0., 0. )
            call SaveInteger( GetCDTable( ), StringHash( "Button_" + I2S( id ) ), StringHash( "Text" ), pFrame )

            call SetFramePoint( GetBTableShadow( id, 0 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0.0003, -0.0003 ) // +
            call SetFramePoint( GetBTableShadow( id, 1 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0.0003, 0. )
            call SetFramePoint( GetBTableShadow( id, 2 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0.0003, 0.0003 )
            call SetFramePoint( GetBTableShadow( id, 3 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0., 0.0003 ) // +
            call SetFramePoint( GetBTableShadow( id, 4 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, -0.0003, 0.0003 )
            call SetFramePoint( GetBTableShadow( id, 5 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, -0.0003, 0. )
            call SetFramePoint( GetBTableShadow( id, 6 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, -0.0003, -0.0003 )
            call SetFramePoint( GetBTableShadow( id, 7 ), ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0., -0.0003 ) // +
            return true
        endif

        return false
    endfunction

    function DrawAllButtonCooldowns takes nothing returns nothing
        local integer i = 0
        local integer p = 0

        if not HaveSavedBoolean( GetCDTable( ), StringHash( "pCDTable" ), StringHash( "IsInit" ) ) then
            call SaveBoolean( GetCDTable( ), StringHash( "pCDTable" ), StringHash( "IsInit" ), true )
            
            loop
                exitwhen i > 17
                if i < 12 then
                    set p = GetSkillBarButton( i )
                else
                    set p = GetItemBarButton( i - 12 )
                endif

                call CreateButtonCooldown( i, p )
                set i = i + 1
            endloop
        endif

        set i = 0
        loop
            exitwhen i > 17
            if i < 12 then
                set p = GetSkillBarButton( i )
            else
                set p = GetItemBarButton( i - 12 )
            endif

            call DrawButtonCooldown( i, p )
            set i = i + 1
        endloop
    endfunction

    function DrawAllCooldownSetDelay takes real delay returns nothing
        if GetCDTable( ) == null then
            call SaveHashtableHandle( MemHackTable, StringHash( "DrawCooldown" ), StringHash( "HashTable" ), InitHashtable( ) )
            call SaveTimerHandle( GetCDTable( ), StringHash( "DrawCooldown" ), StringHash( "Timer" ), CreateTimer( ) )
        endif

        call TimerStart( LoadTimerHandle( GetCDTable( ), StringHash( "DrawCooldown" ), StringHash( "Timer" ) ), delay, true, function DrawAllButtonCooldowns )
    endfunction

    function Init_DrawAllCooldowns takes nothing returns nothing
        call DrawAllCooldownSetDelay( .1 )
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackDrawCooldown takes nothing returns nothing
    //set gg_trg_MemHackDrawCooldown = CreateTrigger(  )
endfunction
//! endnocjass
