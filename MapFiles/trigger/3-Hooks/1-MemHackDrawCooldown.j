//TESH.scrollpos=220
//TESH.alwaysfold=0
//! nocjass
library MemoryHackzDrawCooldowns
    globals
        hashtable pCDTable = InitHashtable( )
        timer pCDDrawTimer = CreateTimer( )
        integer pSomeFrame = 0
    endglobals

    function GetBTableShadow takes integer buttonId, integer id returns integer
        return LoadInteger( pCDTable, StringHash( "Button_" + I2S( buttonId ) ), StringHash( "Shadow_" + I2S( id ) ) )
    endfunction

    function GetBTableText takes integer buttonId returns integer
        return LoadInteger( pCDTable, StringHash( "Button_" + I2S( buttonId ) ), StringHash( "Text" ) )
    endfunction

    function DrawButtonCooldown takes integer id, integer pButton returns boolean
        local integer i = 0
        local real cd
        local string text = ""

        if pButton > 0 then
            set cd = GetButtonCooldown( pButton )

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

        if pButton > 0 then
            loop
                exitwhen i > 7
                //if i == 0 or i == 3 or i == 7 then
                    set pFrame = CreateCSimpleFont( pButton )
                    call SetCSimpleRegionVertexColourEx( pFrame, 0xFF, 0x00, 0x00, 0x00 )
                    call SetCSimpleFontStringFont( pFrame, "Fonts\\FRIZQT__.TTF", .1, 0 )
                    call SetCSimpleFontText( pFrame, "" )
                    call SetCSimpleFontStringScale( pFrame, 1.5 )
                    call SaveInteger( pCDTable, StringHash( "Button_" + I2S( id ) ), StringHash( "Shadow_" + I2S( i ) ), pFrame )
                //endif
                set i = i + 1
            endloop

            set pFrame = CreateCSimpleFont( pButton )
            call SetCSimpleRegionVertexColourEx( pFrame, 0xFF, 0xFF, 0xFF, 0xFF )
            call SetCSimpleFontStringFont( pFrame, "Fonts\\FRIZQT__.TTF", .095, 0 )
            call SetCSimpleFontText( pFrame, "" )
            call SetFramePoint( pFrame, ANCHOR_CENTER, pButton, ANCHOR_CENTER, 0., 0. )
            call SaveInteger( pCDTable, StringHash( "Button_" + I2S( id ) ), StringHash( "Text" ), pFrame )

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
        local integer j = 0
        local integer k = 0
        local real dis  = 0.
        local real cd   = 0.
        local integer p = 0

        if not HaveSavedBoolean( pCDTable, StringHash( "pCDTable" ), StringHash( "IsInit" ) ) then
            call SaveBoolean( pCDTable, StringHash( "pCDTable" ), StringHash( "IsInit" ), true )
            
            loop
                exitwhen i > 17
                if i == 12 then
                    set j = 0
                endif

                if i < 12 then
                    set p = GetSkillBarButton( j )
                else
                    set p = GetItemBarButton( j )
                endif

                call CreateButtonCooldown( i, p )
                set i = i + 1
                set j = j + 1
            endloop
        endif

        set i = 0
        set j = 0
        loop
            exitwhen i > 17
            if i == 12 then
                set j = 0
            endif

            if i < 12 then
                set p = GetSkillBarButton( j )
            else
                set p = GetItemBarButton( j )
            endif

            call DrawButtonCooldown( i, p )
            set i = i + 1
            set j = j + 1
        endloop
    endfunction

    globals
        integer array pCDTextShadow
        integer array pCDFrame
    endglobals
    
    function OldStyleCooldownDrawing takes nothing returns nothing
        local integer i = 0
        local integer j = 0
        local integer k = 0
        local real dis  = 0.
        local real cd   = 0.
        local integer p = 0

        if pSomeFrame == 0 then
            set p = GetSkillBarButton( 5 )

            if p > 0 then
                loop
                    exitwhen k > 7
                    set pCDTextShadow[ k ] = CreateCSimpleFont( p )
                    call SetCSimpleRegionVertexColourEx( pCDTextShadow[ k ], 0xFF, 0x00, 0x00, 0x00 )
                    call SetCSimpleFontStringFont( pCDTextShadow[ k ], "Fonts\\FRIZQT__.TTF", .1, 0 )
                    call SetCSimpleFontText( pCDTextShadow[ k ], "60" )
                    call SetCSimpleFontStringScale( pCDTextShadow[ k ], 1.5 )
                    set k = k + 1
                endloop

                set pSomeFrame = CreateCSimpleFont( p )
                call SetCSimpleRegionVertexColourEx( pSomeFrame, 0xFF, 0xFF, 0xFF, 0xFF )
                call SetCSimpleFontStringFont( pSomeFrame, "Fonts\\FRIZQT__.TTF", .095, 0 )
                call SetCSimpleFontText( pSomeFrame, "60" )
                call SetFramePoint( pSomeFrame, ANCHOR_CENTER, p, ANCHOR_CENTER, 0., 0. )

                call SetFramePoint( pCDTextShadow[ 0 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, 0.0003, -0.0003 )
                call SetFramePoint( pCDTextShadow[ 1 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, 0.0003, 0. )
                call SetFramePoint( pCDTextShadow[ 2 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, 0.0003, 0.0003 )
                call SetFramePoint( pCDTextShadow[ 3 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, 0., 0.0003 )
                call SetFramePoint( pCDTextShadow[ 4 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, -0.0003, 0.0003 )
                call SetFramePoint( pCDTextShadow[ 5 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, -0.0003, 0. )
                call SetFramePoint( pCDTextShadow[ 6 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, -0.0003, -0.0003 )
                call SetFramePoint( pCDTextShadow[ 7 ], ANCHOR_CENTER, pSomeFrame, ANCHOR_CENTER, 0., -0.0003 )

                //set pBackground = CreateCSimpleFont( p ) //CreateCSimpleTexture
                //call BJDebugMsg( "SetFrameSize = " + I2S( SetFrameSize( pBackground, .005, .005 ) ) )
                //call BJDebugMsg( "FillCSimpleTexture = " + I2S( FillCSimpleTexture( pBackground, 0xC0000000 ) ) )
                //call BJDebugMsg( "SetFramePointTexture = " + I2S( SetFramePoint( pBackground, ANCHOR_CENTER, pFrame, ANCHOR_CENTER, 0., 0. ) ) )

                //call BJDebugMsg( "UpdateFrame( pFrame ) = " + I2S( B2I( UpdateFrame( pFrame ) > 0 ) ) )
                //call BJDebugMsg( "ShowFrame( pFrame ) = " + I2S( ShowFrame( pFrame ) ) )
                //call BJDebugMsg( "SetFrameSize = " + I2S( SetFrameSize( pCDFrame[ i ], 0.2, 0. ) ) )
            endif
        endif

        loop
            exitwhen i > 17
            if i == 12 then
                set j = 0
            endif

            if i >= 9 and i <= 11 then
                set dis = .025
            else
                set dis = 0.
            endif

            if pCDFrame[ i ] == 0 then
                set pCDFrame[ i ] = CreateFrame( "UITextCenter", pGameUI, 20 + i )

                if pCDFrame[ i ] > 0 then
                    if i < 12 then
                        set p = GetSkillBarButton( j )
                    else
                        set p = GetItemBarButton( j )
                    endif

                    call SetFrameSize( pCDFrame[ i ], 0.2, 0. ) // call SetFrameSize( pCDFrame[ i ], 0.117, 0.03 )
                    call SetFramePoint( pCDFrame[ i ], ANCHOR_CENTER, p, ANCHOR_CENTER, dis, 0. )
                    call SetFrameFont( pCDFrame[ i ], "Fonts\\FRIZQT__.TTF", 15., 1 ) // 1 = shadow
                endif
            endif

            if pCDFrame[ i ] > 0 then
                if i < 12 then
                    set p = GetSkillBarButton( j )
                else
                    set p = GetItemBarButton( j )
                endif

                if p > 0 then
                    set cd = GetButtonCooldown( p )

                    if cd > 0. then
                        if cd >= 10. then
                            call SetFrameText( pCDFrame[ i ], I2S( R2I( cd ) ) )
                        else
                            call SetFrameText( pCDFrame[ i ], R2SW( cd, 1, 1 ) )
                        endif
                    else
                        call SetFrameText( pCDFrame[ i ], "" )
                    endif
                endif
            endif
            set i = i + 1
            set j = j + 1
        endloop

        //return
        //if pFrame == 0 then
            //set pFrame = CreateFrame( "UITextCenter", pGameUI, 20 )

            //if pFrame > 0 then
                //call SetFrameSize( pFrame, 0.117, 0.03 )
                //call SetFrameText( pFrame, "|cff00ff0060...|r" )
                //call SetFramePoint( pFrame, 1, GetCommandBarButton( 2, 0 ), 1, 0., -.007 )
                //call SetFrameText( pFrame, "|cff00ff00Pizdec-desu|r" )
            //endif
        //endif
    endfunction

    function DrawAllCooldownSetDelay takes real delay returns nothing
        call TimerStart( pCDDrawTimer, delay, true, function DrawAllButtonCooldowns )
    endfunction
    
    function Init_DrawAllCooldowns takes nothing returns nothing
        call DrawAllCooldownSetDelay( .01 )
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackDrawCooldown takes nothing returns nothing
    //set gg_trg_MemHackDrawCooldown = CreateTrigger(  )
endfunction
//! endnocjass
