//TESH.scrollpos=18
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUIAPI
    globals
        constant integer ANCHOR_TOPLEFT     = 0
        constant integer ANCHOR_TOP         = 1
        constant integer ANCHOR_TOPRIGHT    = 2
        constant integer ANCHOR_LEFT        = 3
        constant integer ANCHOR_CENTER      = 4
        constant integer ANCHOR_RIGHT       = 5
        constant integer ANCHOR_BOTTOMLEFT  = 6
        constant integer ANCHOR_BOTTOM      = 7
        constant integer ANCHOR_BOTTOMRIGHT = 8
        boolean IsGameUIEnabled             = true
    endglobals

    function SetUIFramePoint takes integer pFrame, integer point, integer pParentFrame, integer relativePoint, real x, real y returns integer
        if pFrame != 0 and pParentFrame != 0 then
            return SetCLayoutFramePoint( GetFrameLayoutByType( pFrame, GetFrameType( pFrame ) ), point, GetFrameLayoutByType( pParentFrame, GetFrameType( pParentFrame ) ), relativePoint, x, y )
        endif

        return 0
    endfunction

    function HideUI takes nothing returns nothing
        local integer pRootFrame = GetRootFrame( )

        if pRootFrame != 0 then
            call SetUIFramePoint( GetUIUpperButtonBarFrame( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 0.0, 1.0 ) // crash
            call SetUIFramePoint( GetUIResourceBarFrame( ), ANCHOR_TOPRIGHT, pRootFrame, ANCHOR_TOPRIGHT, 0.0, 1.0 ) // crash

            call SetUIFramePoint( GetUISimpleConsole( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 10.0, 0.0 )
            call SetUIFramePoint( GetUISimpleConsole( ), ANCHOR_TOPRIGHT, pRootFrame, ANCHOR_TOPRIGHT, -10.0, 0.0 )

            call SetUIFramePoint( GetUIPortrait( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 1.0, 1.0 )
            call SetUIFramePoint( GetUIMinimap( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 1.0, 1.0 )

            call SetUIFramePoint( GetUIPeonBar( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 1.0, 1.0 ) // crash
            call SetUIFramePoint( GetUIHeroBar( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 0.0, 1.0 ) // crash

            call SetUIFramePoint( GetUITimeOfDayIndicator( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 1.0, 1.0 )
            call SetUIFramePoint( ReadRealMemory( GetUITimeOfDayIndicator( ) + 0x1B0 ), ANCHOR_TOP, pRootFrame, ANCHOR_TOP, 1.0, 0.0 ) // TimeOfDayIndicator UBERTIP
            call SetUIFramePoint( ReadRealMemory( GetUIInfoBar( ) + 0x14C ), ANCHOR_BOTTOMRIGHT, pRootFrame, ANCHOR_TOPLEFT, 1.0, 0.0 ) // ConsoleInventoryCoverTexture
            call HideFrame( GetUITimeOfDayIndicator( ) )
        endif
    endfunction

    function ShowUI takes nothing returns nothing
        local integer pRootFrame = GetRootFrame( )

        if pRootFrame != 0 then
            call SetUIFramePoint( GetUIUpperButtonBarFrame( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 0.0, 0.0 )
            call SetUIFramePoint( GetUIResourceBarFrame( ), ANCHOR_TOPRIGHT, pRootFrame, ANCHOR_TOPRIGHT, 0.0, 0.0 )

            call SetUIFramePoint( GetUISimpleConsole( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 0.0, 0.0 )
            call SetUIFramePoint( GetUISimpleConsole( ), ANCHOR_TOPRIGHT, pRootFrame, ANCHOR_TOPRIGHT, 0.0, 0.0 )

            call SetUIFramePoint( GetUIPortrait( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 0.207500, 0.030625 )
            call SetUIFramePoint( GetUIMinimap( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 0.009375, 0.006875 )

            call SetUIFramePoint( GetUIPeonBar( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 0.003750, 0.170000 )
            call SetUIFramePoint( GetUIHeroBar( ), ANCHOR_TOPLEFT, pRootFrame, ANCHOR_TOPLEFT, 0.003750, -0.026250 )

            call SetUIFramePoint( GetUITimeOfDayIndicator( ), ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, 0.0, 0.0 )
            call SetUIFramePoint( ReadRealMemory( GetUITimeOfDayIndicator( ) + 0x1B0 ), ANCHOR_TOP, pRootFrame, ANCHOR_TOP, 0.0, 0.0 ) // TimeOfDayIndicator UBERTIP
            call SetUIFramePoint( ReadRealMemory( GetUIInfoBar( ) + 0x14C ), ANCHOR_BOTTOMRIGHT, pRootFrame, ANCHOR_TOPLEFT, -0.200000, 0.0 ) // ConsoleInventoryCoverTexture
            call ShowFrame( GetUITimeOfDayIndicator( ) )
        endif
    endfunction

    function EditBlackBorders takes real topX, real topY, real botX, real botY returns nothing
        local integer pRootFrame        = GetRootFrame( )
        local integer pWorldFrameWar3   = GetUIWorldFrameWar3( )// + 0xB4

        if pRootFrame != 0 then
            call SetUIFramePoint( pWorldFrameWar3, ANCHOR_TOPRIGHT, pRootFrame, ANCHOR_TOPRIGHT, topX, topY )
            call SetUIFramePoint( pWorldFrameWar3, ANCHOR_BOTTOMLEFT, pRootFrame, ANCHOR_BOTTOMLEFT, botX, botY )
        endif
    endfunction

    function HideBlackBorders takes nothing returns nothing
        call EditBlackBorders( 0., 0., 0., 0. )
    endfunction
    
    function ShowBlackBorders takes nothing returns nothing
        call EditBlackBorders( 0., -.02, 0., .13 )
    endfunction

    function EditMiniMap takes integer point, real topX, real topY, real botX, real botY returns nothing
        local integer pRootFrame    = GetRootFrame( )
        local integer pMiniMapFrame = GetUIMinimap( )// + 0xB4

        if pRootFrame > 0 then
            call SetUIFramePoint( pMiniMapFrame, ANCHOR_TOPRIGHT, pRootFrame, point, topX, topY )
            call SetUIFramePoint( pMiniMapFrame, ANCHOR_BOTTOMLEFT, pRootFrame, point, botX, botY )
        endif
    endfunction

    function HideMiniMap takes nothing returns nothing
        local real xMul = .8 / GetWindowWidth( )
        local real yMul = .6 / GetWindowHeight( )

        call EditMiniMap( ANCHOR_TOPRIGHT, -2. * xMul + xMul, 0., -2. * xMul, -yMul )
    endfunction
    
    function ShowMiniMap takes nothing returns nothing
        call EditMiniMap( ANCHOR_BOTTOMLEFT, 0.14875, 0.145, 0.009375, 0.006875 )
    endfunction

    function EditCommandBarButton takes integer row, integer column, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pButtonFrame = GetSkillBarButtonXY( row, column )
        local integer pRootFrame = GetRootFrame( )

        if pButtonFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pButtonFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pButtonFrame, height )
            endif

            call SetUIFramePoint( pButtonFrame, ANCHOR_TOPLEFT, pRootFrame, anchor, offsetX, -offsetY )
        endif
    endfunction

    function EditItemBarButton takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pButtonFrame = GetItemBarButton( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pButtonFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pButtonFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pButtonFrame, height )
            endif

            call SetUIFramePoint( pButtonFrame, ANCHOR_TOPLEFT, pRootFrame, anchor, offsetX, -offsetY )
        endif
    endfunction

    function EditMinimapButton takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pButtonFrame = GetMinimapButton( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pButtonFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pButtonFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pButtonFrame, height )
            endif

            call SetUIFramePoint( pButtonFrame, ANCHOR_TOPLEFT, pRootFrame, anchor, offsetX, -offsetY )
        endif
    endfunction

    function EditUpperButtonBarButton takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pButtonFrame = GetUpperButtonBarButton( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pButtonFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pButtonFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pButtonFrame, height )
            endif
            
            if buttonId == 0 then
                call SetUIFramePoint( pButtonFrame, ANCHOR_TOPLEFT, pRootFrame, anchor, offsetX, -offsetY )
            else
                call SetUIFramePoint( pButtonFrame, ANCHOR_LEFT, pRootFrame, anchor, offsetX, -( offsetY + GetFrameHeight( pButtonFrame ) / 2. ) )
            endif
        endif
    endfunction

    function EditHeroBarButton takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pButtonFrame = GetHeroBarButton( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pButtonFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pButtonFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pButtonFrame, height )
            endif

            call SetUIFramePoint( pButtonFrame, ANCHOR_TOPLEFT, pRootFrame, anchor, offsetX, -offsetY )
        endif
    endfunction

    function EditHeroBarHealthBar takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pHealthFrame = GetHeroBarHealthBar( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pHealthFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pHealthFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pHealthFrame, height )
            endif

            call SetUIFramePoint( pHealthFrame, ANCHOR_TOP, pRootFrame, anchor, offsetX + GetFrameWidth( pHealthFrame ) / 2., -offsetY )
        endif
    endfunction

    function EditHeroBarManaBar takes integer buttonId, integer anchor, real offsetX, real offsetY, real width, real height returns nothing
        local integer pManaFrame = GetHeroBarManaBar( buttonId )
        local integer pRootFrame = GetRootFrame( )

        if pManaFrame > 0 then
            if width >= 0. then
                call SetFrameWidth( pManaFrame, width )
            endif

            if height >= 0. then
                call SetFrameHeight( pManaFrame, height )
            endif

            call SetUIFramePoint( pManaFrame, ANCHOR_TOP, pRootFrame, anchor, offsetX + GetFrameWidth( pManaFrame ) / 2., -offsetY )
        endif
    endfunction

    function EditTooltipUber takes integer anchor, real offsetX, real offsetY, real width returns nothing
        local integer pTooltipUberFrame = GetTooltipUberFrame( )
        local integer pRootFrame        = GetRootFrame( )

        if pTooltipUberFrame != 0 then
            if width >= 0. then
                call SetFrameWidth( pTooltipUberFrame, width ) // Borders
                call SetFrameWidth( ReadRealMemory( pTooltipUberFrame + 0x180 ), width ) // Text
            endif
            //call SetUIFramePoint( pTooltipUberFrame, ANCHOR_BOTTOMRIGHT, pRootFrame, anchor, offsetX + GetFrameWidth( pTooltipUberFrame ), -( offsetY + GetFrameHeight( pTooltipUberFrame ) ) ) // offsetX = 0, offsetY = 0 - top left corner
            call SetUIFramePoint( pTooltipUberFrame, ANCHOR_BOTTOMRIGHT, pRootFrame, anchor, offsetX, -offsetY ) // offsetX = 0, offsetY = 0 - bottom right corner
        endif
    endfunction

    function ShowAllUI takes nothing returns nothing
        call ShowBlackBorders( )
        call ShowUI( )
        call ShowMiniMap( )
    endfunction
    
    function HideAllUI takes nothing returns nothing
        call HideBlackBorders( )
        call HideUI( )
        call HideMiniMap( )
    endfunction

    function ToggleUI takes nothing returns nothing
        set IsGameUIEnabled = not IsGameUIEnabled

        if IsGameUIEnabled then
            call ShowAllUI( )
        else
            call HideAllUI( )
        endif
    endfunction
    
    function Init_MemHackUIAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackUIAPI takes nothing returns nothing
    //set gg_trg_MemHackUIAPI = CreateTrigger(  )
endfunction
//! endnocjass
