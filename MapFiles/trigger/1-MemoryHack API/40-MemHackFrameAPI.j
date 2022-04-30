//TESH.scrollpos=109
//TESH.alwaysfold=0
//! nocjass
library MemoryHackFrameAPI
    globals
        integer pTooltipFrame                   = 0
        integer pGetTooltipFrame                = 0
        integer pGetFrameSkinByName             = 0
        integer pDestroyFrame                   = 0
        integer pSetFrameState                  = 0
        integer pClickFrame                     = 0
        integer pUpdateFrame                    = 0

        integer pUnitFramePosition              = 0
        integer pGetUnitFramePosition           = 0
    endglobals

    // Frame API Engine
    function GetFrameByName takes string name, integer id returns integer
        local integer addr = GetCFrameByName( name, id )

        if addr == 0 then
            set addr = GetCSimpleFrameByName( name, id )

            if addr == 0 then
                set addr = GetCSimpleTextureByName( name, id )

                if addr == 0 then
                    set addr = GetCSimpleFontByName( name, id )
                endif
            endif
        endif

        return addr
    endfunction

    function CreateFrameEx takes string baseframe, integer parent, integer point, integer relativepoint, integer id returns integer
        return CreateCFrameEx( baseframe, parent, point, relativepoint, id )
    endfunction

    function CreateFrame takes string baseframe, integer parent, integer id returns integer
        return CreateFrameEx( baseframe, parent, 0, 0, id )
    endfunction

    function CreateSimpleFrame takes integer parent returns integer
        return CreateCSimpleFrame( parent )
    endfunction

    function GetUnitFramePosition takes integer pUnit returns boolean
        if pGetUnitFramePosition > 0 then
            return I2B( fast_call_3( pGetUnitFramePosition, pUnit, pUnitFramePosition, 0 ) )
        endif

        return false
    endfunction
    
    function HideFrame takes integer pFrame returns integer
        return HideCLayer( pFrame )
    endfunction

    function ShowFrame takes integer pFrame returns integer
        return ShowCLayer( pFrame )
    endfunction

    function SetFrameAlpha takes integer pFrame, integer alpha returns integer
        return SetCLayerAlpha( pFrame, alpha )
    endfunction

    function SetLayerFont takes integer pFrame, string filename, real height, integer flag returns integer
        return SetCLayerFont( pFrame, filename, height, flag )
    endfunction

    function SetFrameTooltip takes integer pFrame, integer pTooltip returns integer
        return SetCLayerTooltip( pFrame, pTooltip )
    endfunction

    function SetFrameFocus takes integer pFrame, boolean flag returns integer
        return SetCEditBoxFocus( pFrame, flag )
    endfunction

    function SetFrameCageMouse takes integer pFrame, boolean flag returns integer
        return SetCLayoutFrameCageMouse( pFrame, flag )
    endfunction

    function SetFrameAbsolutePoint takes integer pFrame, integer point, real x, real y returns integer
        local integer fid_1 = GetFrameType( pFrame )

        if fid_1 > 0 then
            set pFrame = GetFrameLayoutByType( pFrame, fid_1 )
            return SetCLayoutFrameAbsolutePoint( pFrame, point, x, y )
        endif

        return 0
    endfunction

    function SetFramePoint takes integer pFrame, integer point, integer pParentFrame, integer relativePoint, real x, real y returns integer
        local integer fid_1 = GetFrameType( pFrame )
        local integer fid_2 = GetFrameType( pParentFrame )

        if fid_1 > 0 and fid_2 > 0 then
            set pFrame = GetFrameLayoutByType( pFrame, fid_1 )
            set pParentFrame = GetFrameLayoutByType( pParentFrame, fid_2 )
            return SetCLayoutFramePoint( pFrame, point, pParentFrame, relativePoint, x, y )
        endif

        return 0
    endfunction

    function ClearFrameAllPoints takes integer pFrame returns integer
        return ClearCLayoutFrameAllPoints( pFrame )
    endfunction

    function SetFrameWidth takes integer pFrame, real width returns integer
        return SetCLayoutFrameWidth( pFrame, width )
    endfunction

    function SetFrameHeight takes integer pFrame, real height returns integer
        return SetCLayoutFrameHeight( pFrame, height )
    endfunction

    function SetFrameAllPoints takes integer pFrame, integer relativeframe returns integer
        return SetCLayoutFrameAllPoints( pFrame, relativeframe )
    endfunction

    function SetFrameSize takes integer pFrame, real width, real height returns integer
        return SetCLayoutFrameSize( pFrame, width, height )
    endfunction

    function SetLayoutFrameScale takes integer pFrame, real scale returns integer
        return SetCLayoutFrameScale( pFrame, scale )
    endfunction

    function SetFrameVertexColour takes integer pFrame, integer colour returns integer
        return SetCSimpleRegionVertexColour( pFrame, colour )
    endfunction

    function SetFrameVertexColourEx takes integer pFrame, integer alpha, integer red, integer blue, integer green returns integer
        return SetCSimpleRegionVertexColourEx( pFrame, alpha, red, blue, green )
    endfunction

    function GetFrameSkinByName takes string name, integer id returns integer
        if pGetFrameSkinByName > 0 then
            if name != "" then
                return fast_call_2( pGetFrameSkinByName, GetStringAddress( name ), id )
            endif
        endif

        return 0
    endfunction

    function DestroyFrame takes integer pFrame returns integer
        if pDestroyFrame > 0 then
            if pFrame > 0 then
                return this_call_2( pDestroyFrame, pFrame, 1 )
            endif
        endif

        return 0
    endfunction

    function GetFrameState takes integer pFrame, integer state returns boolean
        if pFrame > 0 then
            return BitwiseAnd( state, ReadRealMemory( pFrame + 0x1D4 ) ) == state
        endif

        return false
    endfunction
    
    function IsFrameEnabled takes integer pFrame returns boolean
        return GetFrameState( pFrame, 1 )
    endfunction

    function SetFrameState takes integer pFrame, boolean flag returns integer
        if pSetFrameState > 0 then
            if pFrame > 0 then
                return this_call_2( pSetFrameState, pFrame, B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function EnableFrame takes integer pFrame returns integer
        return SetFrameState( pFrame, true )
    endfunction
    
    function DisableFrame takes integer pFrame returns integer
        return SetFrameState( pFrame, false )
    endfunction

    function GetFrameTextByName takes string name, integer id returns string
        return GetCSimpleFontTextByName( name, id )
    endfunction

    function SetFrameTextColour takes integer pFrame, integer colour returns integer
        return SetCTextFrameTextColour( pFrame, colour )
    endfunction

    function SetFrameTextColourEx takes integer pFrame, integer alpha, integer red, integer blue, integer green returns integer
        return SetCTextFrameTextColourEx( pFrame, alpha, red, green, blue )
    endfunction

    function FindLayerUnderCursor takes nothing returns integer
        return FindCLayerUnderCursor( )
    endfunction

    function ClickFrame takes integer pFrame returns integer
        if pClickFrame > 0 then
            if pFrame > 0 then
                return this_call_2( pClickFrame, pFrame, 1 )
            endif
        endif

        return 0
    endfunction

    function SetFrameModel takes integer pFrame, string model, integer modeltype, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if fid == 15 then
            return AddCModelFrameModel( pFrame, model, modeltype )
        endif

        if fid == 25 then
            return SetCSpriteFrameArt( pFrame, model, modeltype, flag )
        endif

        if fid == 40 then
            return SetCStatusBarArt( pFrame, model, modeltype )
        endif

        return 0
    endfunction

    function GetFrameAlpha takes integer pFrame returns integer
        local integer fid = GetFrameType( pFrame )

        if fid > 0 then
            return ReadRealMemory( pFrame + 0xAC )
        endif

        return 0
    endfunction

    function UpdateFrame takes integer pFrame returns integer
        if pUpdateFrame > 0 then
            if pFrame > 0 then
                return this_call_2( pUpdateFrame, pFrame, 0 )
            endif
        endif

        return 0
    endfunction

    function SetFrameStepValue takes integer pFrame, real step returns nothing
        local integer fid = GetFrameType( pFrame )
        
        if fid == 24 then
            call WriteRealMemory( pFrame + 0x1F8, SetRealIntoMemory( step ) )
        endif
    endfunction

    function GetFrameParent takes integer pFrame returns integer
        local integer fid  = GetFrameType( pFrame )
        local integer pOff = 0

        if fid > 0 then
            if not IsFrameLayout( pFrame ) then
                set pOff = 0x20
            else
                set pOff = 0x68 // if 1.29+ set pOff = 0x70
            endif

            if pOff > 0 then
                return ReadRealMemory( pFrame + pOff )
            endif
        endif

        return 0
    endfunction

    function SetFrameParent takes integer pFrame, integer pParentFrame returns integer
        if GetFrameType( pFrame ) > 0 and GetFrameType( pParentFrame ) > 0 then
            if IsFrameLayout( pFrame ) then
                if IsFrameLayout( pParentFrame ) then
                    return SetCSimpleFrameParent( pFrame, pParentFrame )
                endif
            else
                if IsFrameLayout( pParentFrame ) then
                    return SetCLayerOwner( pFrame, pParentFrame )
                endif
            endif
        endif

        return 0
    endfunction

    function GetFrameName takes integer pFrame returns string
        local integer fid   = GetFrameType( pFrame )
        local integer pText = 0

        if fid > 0 then
            if IsFrameLayout( pFrame ) then
                set pText = pFrame + 0x7C  // if 1.29+  0x80
            else
                set pText = pFrame + 0x160 // if 1.29+ 0x16C
            endif

            if pText > 0 then
                return ToJString( ReadRealMemory( pText ) )
            endif
        endif

        return ""
    endfunction

    function SetFrameTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if fid == 1 or fid == 39 or fid == 64 then
            if fid == 1 then
                return SetCBackDropFrameTexture( pFrame, texturepath, flag )
            endif

            if fid == 39 then
                return SetCSimpleStatusBarTexture( pFrame, texturepath, flag )
            endif

            if fid == 64 then
                return SetCSimpleTextureTexture( pFrame, texturepath, flag )
            endif
        endif

        return 0
    endfunction

    function SetFrameScale takes integer pFrame, real scale returns integer
        local integer fid = GetFrameType( pFrame )

        if fid > 0 then
            if fid == 19 or fid == 21 or fid == 22 or fid == 23 or fid == 39 or fid == 25 then
                if fid == 19 then
                    return SetCSimpleFontStringScale( pFrame, scale )
                endif

                if fid == 21 then
                    return SetCSimpleGlueFrameScale( pFrame, scale )
                endif

                if fid == 22 or fid == 23 or fid == 39 then
                    return SetCSimpleFrameScale( pFrame, scale )
                endif

                if fid == 25 then
                    return SetCSpriteFrameScale( pFrame, scale )
                endif
            else
                return SetLayoutFrameScale( pFrame, scale )
            endif
        endif

        return 0
    endfunction
    
    function GetFrameValue takes integer pFrame returns real
        local integer fid  = GetFrameType( pFrame )
        local integer pOff = 0
        
        if fid == 24 or fid == 39 or fid == 40 then
            if fid == 24 then
                set pOff = 0x500 // if 1.29+ 0x516
            endif

            if fid == 39 then
                set pOff = 0x130 // if 1.29+ 0x12C
            endif

            if fid == 40 then
                set pOff = 0x1BC // if 1.29+ 0x1CC
            endif

            if pOff > 0 then
                return GetRealFromMemory( ReadRealMemory( pFrame + pOff ) )
            endif
        endif

        return 0.
    endfunction

    function SetFrameValue takes integer pFrame, real value returns integer
        local integer fid  = GetFrameType( pFrame )

        if fid == 24 or fid == 39 or fid == 40 then
            if fid == 24 then
                return SetCSliderCurrentValue( pFrame, value )
            endif

            if fid == 39 then
                return SetCSimpleStatusBarValue( pFrame, value )
            endif

            if fid == 40 then
                return SetCStatusBarValue( pFrame, value )
            endif
        endif

        return 0
    endfunction

    function SetFrameMinMaxValue takes integer pFrame, real minval, real maxval returns integer
        local integer fid       = GetFrameType( pFrame )
        local real cur_val      = 0.
        local real new_val      = 0.

        if fid == 24 or fid == 39 or fid == 40 then
            if minval < maxval then
                if fid == 24 then
                    call WriteRealMemory( pFrame + 0x1EC, SetRealIntoMemory( minval ) )
                    call WriteRealMemory( pFrame + 0x1F0, SetRealIntoMemory( maxval ) )
                    set cur_val = GetRealFromMemory( ReadRealMemory( pFrame + 0x1F4 ) )

                    if minval <= cur_val then
                        if cur_val > maxval then
                            set new_val = maxval
                        endif
                    else
                        set new_val = minval
                    endif

                    return SetCSliderCurrentValue( pFrame, new_val )
                endif

                if fid == 39 then
                    return SetCSimpleStatusBarMinMaxValue( pFrame, minval, maxval )
                endif

                if fid == 40 then
                    return SetCStatusBarMinMaxValue( pFrame, minval, maxval )
                endif
            endif
        endif

        return 0
    endfunction
    //===========================================

    // Frame Point API Engine
    function SetFrameFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer fid = GetFrameType( pFrame )
        
        if fid == 6 or fid == 19 or fid == 23 then
            if fid == 6 then
                return SetCEditBoxFont( pFrame, filename, height, flag )
            endif

            if fid == 19 then
                return SetCSimpleFontStringFont( pFrame, filename, height, flag )
            endif

            if fid == 23 then
                return SetCSimpleMessageFrameFont( pFrame, filename, height, flag )
            endif
        else
            if not IsFrameLayoutByType( pFrame, fid ) then
                return SetLayerFont( pFrame, filename, height, flag )
            endif
        endif

        return 0
    endfunction
    
    function GetFrameWidth takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if fid > 0 then
            return GetRealFromMemory( ReadRealMemory( pFrame + 0x58 ) )
        endif

        return 0.
    endfunction

    function GetFrameHeight takes integer pFrame returns real
        local integer fid = GetFrameType( pFrame )

        if fid == 15 or fid == 19 or fid == 25 or fid == 29 then
            if fid == 15 then
                return GetCModelFrameHeight( pFrame )
            endif

            if fid == 19 then
                return GetCSimpleFontStringHeight( pFrame )
            endif

            if fid == 25 then
                return GetCSpriteFrameHeight( pFrame )
            endif

            if fid == 29 then
                return GetCTextFrameHeight( pFrame )
            endif
            // return GetRealFromMemory( ReadRealMemory( pFrame + 0x5C ) )
        else
            return GetCLayoutFrameHeight( pFrame )
        endif

        return 0.
    endfunction

    function GetFramePoint takes integer pFrame, integer point returns integer
        local integer fid = GetFrameType( pFrame )

        if fid > 0 then
            return ReadRealMemory( pFrame + 0x4 * point + 0x8 )
        endif

        return 0
    endfunction

    // Frame Absolute Point API
    function GetFrameAbsolutePoint takes integer pFrame, integer point returns integer
        return GetFramePoint( pFrame, point )
    endfunction
    
    function GetFrameAbsolutePointX takes integer pFrame, integer point returns real
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return GetRealFromMemory( ReadRealMemory( pFramePoint + 0x4 ) )
        endif

        return 0.
    endfunction

    function GetFrameAbsolutePointY takes integer pFrame, integer point returns real
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return GetRealFromMemory( ReadRealMemory( pFramePoint + 0x8 ) )
        endif

        return 0.
    endfunction
    //===========================================

    // Frame Relative Point API
    function GetFrameRelativePoint takes integer pFrame, integer point returns integer
        return GetFramePoint( pFrame, point )
    endfunction

    function GetFrameRelativePointParent takes integer pFrame, integer point returns integer
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return ReadRealMemory( pFramePoint + 0x4 )
        endif

        return 0
    endfunction

    function GetFramePointRelativePoint takes integer pFrame, integer point returns integer
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return ReadRealMemory( pFramePoint + 0x8 )
        endif

        return 0
    endfunction

    function GetFrameRelativePointX takes integer pFrame, integer point returns real
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return GetRealFromMemory( ReadRealMemory( pFramePoint + 0xC ) )
        endif

        return 0.
    endfunction

    function GetFrameRelativePointY takes integer pFrame, integer point returns real
        local integer pFramePoint = GetFramePoint( pFrame, point )

        if pFramePoint > 0 then
            return GetRealFromMemory( ReadRealMemory( pFramePoint + 0x10 ) )
        endif

        return 0.
    endfunction
    //===========================================

    //===========================================

    // Frame Text API Engine
    function GetFrameTextMaxLength takes integer pFrame returns integer
        local integer frameId = GetFrameType( pFrame )

        if frameId == 6 then
            return ReadRealMemory( pFrame + 0x1F0 )
        endif

        return 0
    endfunction

    function SetFrameMaxTextLength takes integer pFrame, integer length returns nothing
        local integer frameId = GetFrameType( pFrame )

        if frameId == 6 then
            call WriteRealMemory( pFrame + 0x1F0, length )
        endif
    endfunction

    function GetFrameTextLength takes integer pFrame returns integer
        local integer fid = GetFrameType( pFrame )

        if fid == 6 then
            return ReadRealMemory( pFrame + 0x1F4 )
        endif

        return 0
    endfunction

    function GetFrameText takes integer pFrame returns string
        local integer fid        = GetFrameType( pFrame )
        local integer pFrameText = 0

        if fid > 0 then
            if fid == 6 then
                set pFrameText = ReadRealMemory( pFrame + 0x1E4 )
            endif

            if fid == 19 then
                set pFrameText = ReadRealMemory( pFrame + 0x01C )
            endif

            if fid == 27 then
                set pFrameText = ReadRealMemory( pFrame + 0x230 )
            endif

            if fid == 29 then
                set pFrameText = ReadRealMemory( pFrame + 0x1E8 )
            endif

            if pFrameText > 0 then
                return ToJString( pFrameText )
            endif
        endif

        return ""
    endfunction

    function SetFrameText takes integer pFrame, string text returns integer
        local integer fid = GetFrameType( pFrame )

        if fid > 0 then
            if fid == 6 or fid == 36 or fid == 37 then
                return SetCEditBoxText( pFrame, text )
            endif

            if fid == 19 then
                return SetCSimpleFontText( pFrame, text )
            endif

            if fid == 27 then
                return SetCTextAreaText( pFrame, text )
            endif

            if fid == 28 or fid == 33 or fid == 29 or fid == 38 then
                return SetCTextFrameText( pFrame, text )
            endif
        endif

        return 0
    endfunction
    //===========================================

    function IsReplay takes nothing returns boolean
        return GetCFrameByName( "ReplayVisionMenu", 0 ) != 0
    endfunction

    function SetAllyCheckbox takes integer mode returns nothing
        local integer i = 0
        local integer pAllyCheckBoxAddr

        loop
            exitwhen i > 11
            set pAllyCheckBoxAddr = GetCFrameByName( "UnitsCheckBox", i )

            if pAllyCheckBoxAddr > 0 then
                set pAllyCheckBoxAddr = pAllyCheckBoxAddr + 0x1D4

                if BitwiseAnd( ReadRealMemory( pAllyCheckBoxAddr ), mode ) == 0 then // BitwiseAnd( ReadRealMemory( pAllyCheckBoxAddr ), 1 ) == 0
                    call WriteRealMemory( pAllyCheckBoxAddr, BitwiseOr( ReadRealMemory( pAllyCheckBoxAddr ), mode ) )
                endif
            endif

            set i = i + 1
        endloop
    endfunction

    function EnableAllyCheckbox takes nothing returns nothing
        call SetAllyCheckbox( 1 )
    endfunction

    function DisableAllyCheckbox takes nothing returns nothing
        call SetAllyCheckbox( 0 )
    endfunction

    function DisableSaveGameMenu takes nothing returns nothing
        // SaveButton frame and menu are not rendered in the first seconds of init.
        // Thus, this function MUST be called with a delay after map init.
        local integer pSaveGameSaveButton = GetCFrameByName( "SaveGameFileEditBox" , 0 )

        if pSaveGameSaveButton > 0 then
            call WriteRealMemory( pSaveGameSaveButton + 0x1D4, 0)
            call WriteRealMemory( pSaveGameSaveButton + 0x108, 0)
            call WriteRealMemory( pSaveGameSaveButton + 0x1E8, 0)
            
            set pSaveGameSaveButton = GetCFrameByName( "FileListFrame", 0 )
            if pSaveGameSaveButton > 0 then
                call WriteRealMemory( pSaveGameSaveButton + 0x10C, 0x3B03123E )
            endif
        endif
    endfunction
    
    function Init_MemHackFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGetTooltipFrame                = pGameDLL + 0x337D80
                set pGetFrameSkinByName             = pGameDLL + 0x320070
                set pDestroyFrame                   = pGameDLL + 0x6070B0
                set pSetFrameState                  = pGameDLL + 0x602580
                set pClickFrame                     = pGameDLL + 0x6026C0
                set pUpdateFrame                    = pGameDLL + 0x606460
                set pGetUnitFramePosition           = pGameDLL + 0x334CC0
        elseif PatchVersion == "1.26a" then
                set pGetTooltipFrame                = pGameDLL + 0x337240
                set pGetFrameSkinByName             = pGameDLL + 0x31F530
                set pDestroyFrame                   = pGameDLL + 0x606910 // DestroyCFrame
                set pSetFrameState                  = pGameDLL + 0x336C20 // SetCControlState
                set pClickFrame                     = pGameDLL + 0x601F20
                set pUpdateFrame                    = pGameDLL + 0x605CC0 // UpdateCLayout
                set pGetUnitFramePosition           = pGameDLL + 0x334180 // GetCAgentScreenAxis
        elseif PatchVersion == "1.27a" then
                set pGetTooltipFrame                = pGameDLL + 0x399720 // under if ( v2[109] || !*(_DWORD *)(v5 + 464) )
                set pGetFrameSkinByName             = pGameDLL + 0x324AD0
                set pDestroyFrame                   = pGameDLL + 0x0A1870
                set pSetFrameState                  = pGameDLL + 0x0A95F0
                set pClickFrame                     = pGameDLL + 0x0BE3A0
                set pUpdateFrame                    = pGameDLL + 0x0BD630
                set pGetUnitFramePosition           = pGameDLL + 0x358CF0
        elseif PatchVersion == "1.27b" then
                set pGetTooltipFrame                = pGameDLL + 0x3B6ED0
                set pGetFrameSkinByName             = pGameDLL + 0x342220
                set pDestroyFrame                   = pGameDLL + 0x0F55D0
                set pSetFrameState                  = pGameDLL + 0x112030
                set pClickFrame                     = pGameDLL + 0x112100
                set pUpdateFrame                    = pGameDLL + 0x111390
                set pGetUnitFramePosition           = pGameDLL + 0x376490
        elseif PatchVersion == "1.28f" then
                set pGetTooltipFrame                = pGameDLL + 0x3EAFC0
                set pGetFrameSkinByName             = pGameDLL + 0x3761E0
                set pDestroyFrame                   = pGameDLL + 0x123C20
                set pSetFrameState                  = pGameDLL + 0x1406E0
                set pClickFrame                     = pGameDLL + 0x1407B0
                set pUpdateFrame                    = pGameDLL + 0x13F9B0
                set pGetUnitFramePosition           = pGameDLL + 0x3AA5A0
            endif

            if pGetTooltipFrame > 0 then
                set pUnitFramePosition = Malloc( 0x8 )
                set pTooltipFrame = fast_call_1( pGetTooltipFrame, 0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
