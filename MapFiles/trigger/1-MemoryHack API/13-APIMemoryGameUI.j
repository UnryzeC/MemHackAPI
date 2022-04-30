//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameUI
    globals
        integer pGameUI                     = 0
        integer pWorldFrameWar3UI           = 0
        integer pGetGameUI                  = 0
        integer pUpdateUI                   = 0
        integer pTextureLoadImageAnyExt     = 0
        integer pTextureUnloadImage         = 0
    endglobals

    function GetGameUI takes integer bInit, integer bRelease returns integer
        return fast_call_2( pGetGameUI, bInit, bRelease )
    endfunction

    function GetRootFrame takes nothing returns integer
        if pGameUI > 0 then
            return pGameUI + 0xB4 //180
        endif

        return 0
    endfunction

    // Frame Game API Engine
    function GetUIWorldFrameWar3 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3BC ) // if ReadRealMemory( GetUIWorldFrameWar3 + 0x1AC ) == 9 ???
        endif

        return 0
    endfunction

    function GetUIMinimap takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3C0 )
        endif

        return 0
    endfunction

    function GetUIInfoBar takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3C4 )
        endif

        return 0
    endfunction

    function GetUICommandBar takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3C8 )
        endif

        return 0
    endfunction

    function GetUIResourceBarFrame takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3CC )
        endif

        return 0
    endfunction

    function GetUIUpperButtonBarFrame takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3D0 )
        endif

        return 0
    endfunction

    function GetUIUnknown1 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3D4 ) // ?
        endif

        return 0
    endfunction

    function GetUIClickableBlock takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3D8 )
        endif

        return 0
    endfunction

    function GetUIHeroBar takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3DC )
        endif

        return 0
    endfunction

    function GetUIPeonBar takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3E0 )
        endif

        return 0
    endfunction

    function GetUIMessage takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3E4 )
        endif

        return 0
    endfunction

    function GetUIUnitMessage takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3E8 )
        endif

        return 0
    endfunction

    function GetUIChatMessage takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3EC )
        endif

        return 0
    endfunction

    function GetUITopMessage takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3F0 )
        endif

        return 0
    endfunction

    function GetUIPortrait takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3F4 )
        endif

        return 0
    endfunction

    function GetUITimeOfDayIndicator takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3F8 )
        endif

        return 0
    endfunction

    function GetUIChatEditBar takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x3FC )
        endif

        return 0
    endfunction

    function GetUICinematicPanel takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x400 )
        endif

        return 0
    endfunction

    function GetUIUnknown2 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x404 ) // ?
        endif

        return 0
    endfunction

    function GetUIMinimapButton1 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x408 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton2 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x40C )
        endif

        return 0
    endfunction

    function GetUIMinimapButton3 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x410 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton4 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x414 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton5 takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x418 )
        endif

        return 0
    endfunction

    function GetUIFrameB takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x41C )
        endif

        return 0
    endfunction

    function GetUIMouseBorders takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x420 )
        endif

        return 0
    endfunction

    function GetUIFrameA takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x424 )
        endif

        return 0
    endfunction

    function GetUISimpleConsole takes nothing returns integer
        if pGameUI > 0 then
            return ReadRealMemory( pGameUI + 0x428 )
        endif

        return 0
    endfunction

    function GetPanelButton takes integer pFrame, integer row, integer column returns integer
        if pFrame > 0 then
            return ReadRealMemory( ReadRealMemory( 0x10 * row + ReadRealMemory( pFrame + 0x154 ) + 0x8 ) + 0x4 * column )
        endif

        return 0
    endfunction

    function GetMinimapButton takes integer id returns integer
        local integer pMiniMap = GetUIMinimap( )

        if pMiniMap > 0 then
            if id >= 0 and id <= 4 then 
                return ReadRealMemory( pMiniMap + id * 4 )
            endif
        endif

        return 0
    endfunction

    function GetUpperButtonBarButton takes integer id returns integer
        local integer pOff              = 0
        local integer pUpperButtonBar   = GetUIUpperButtonBarFrame( )

        if pUpperButtonBar > 0 then
            if id == 0 then
                set pOff = 0x138
            elseif id == 1 then
                set pOff = 0x130
            elseif id == 2 then
                set pOff = 0x134
            elseif id == 3 then
                set pOff = 0x160
            endif

            if pOff > 0 then
                return ReadRealMemory( pUpperButtonBar + pOff )
            endif
        endif

        return 0
    endfunction

    function GetSkillBarButtonXY takes integer row, integer column returns integer
        local integer pCommandBar = GetUICommandBar( )

        if pCommandBar > 0 then
            if row >= 0 and row <= 2 and column >= 0 and column <= 3 then
                return GetPanelButton( pCommandBar, row, column )
            endif
        endif

        return 0
    endfunction
	
    function GetSkillBarButton takes integer id returns integer
        local integer pUIBar = GetUICommandBar( )
        local integer pSkillBar = 0

        if pUIBar > 0 then
            if id >= 0 and id <= 11 then
                set pSkillBar = ReadRealMemory( pUIBar + 0x154 )

                if pSkillBar > 0 then
                    return ReadRealMemory( ReadRealMemory( pSkillBar + 0x8 ) ) + id * 0x1C0
                endif
            endif
        endif

        return 0
    endfunction

    function GetItemBarButton takes integer id returns integer
        local integer pInfoBar = GetUIInfoBar( )
        local integer pItemBar = 0

        if pInfoBar > 0 then
            if id >= 0 and id <= 5 then
                set pItemBar = ReadRealMemory( pInfoBar + 0x148 )

                if pItemBar > 0 then
                    //return ReadRealMemory( ReadRealMemory( pItemBar + 0x130 ) + id * 0x8 + 0x4 )
                    return ReadRealMemory( ReadRealMemory( pItemBar + 0x130 ) + 0x4 ) + id * 0x1C0
                endif
            endif
        endif

        return 0
    endfunction
    
    function GetCommandBarButton takes integer id returns integer
        if id >= 0 and id <= 11 then
            return GetSkillBarButton( id )
    elseif id >= 12 and id <= 17 then
            return GetSkillBarButton( id - 12 )
        endif

        return 0
    endfunction

    function GetHeroBarButton takes integer id returns integer
        local integer pHeroBar = GetUIHeroBar( )

        if pHeroBar > 0 then
            if id >= 0 and id <= 6 then
                return GetPanelButton( pHeroBar, id, 0 )
            endif
        endif

        return 0
    endfunction
    
    function GetHeroBarHealthBar takes integer id returns integer
        local integer pHeroBar = GetHeroBarButton( id )
        
        if pHeroBar > 0 then
            return ReadRealMemory( pHeroBar + 0x1CC )
        endif

        return 0
    endfunction

    function GetHeroBarManaBar takes integer id returns integer
        local integer pHeroBar = GetHeroBarButton( id )
        
        if pHeroBar > 0 then
            return ReadRealMemory( pHeroBar + 0x1D0 )
        endif

        return 0
    endfunction

    function UpdateGameUI takes nothing returns nothing
        if pUpdateUI > 0 then
            call this_call_1( pUpdateUI, 0 )
        endif
    endfunction

    function GetFrameType takes integer pFrame returns integer
        if pFrame > 0 then
            return LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), ReadRealMemory( pFrame ) )
        endif

        return 0
    endfunction

    function SetWar3MapMap takes string minimap returns integer
        local integer pMiniMap      = GetUIMinimap( )
        local integer pTexture      = 0
        local integer pOldTexture   = 0

        if pMiniMap > 0 then
            if minimap != "" then
                if pMiniMap > 0 then
                    call WriteRealMemory( pReservedIntArg1, 0 )
                    call WriteRealMemory( pReservedIntArg2, 0 )
                    set pTexture = fast_call_3( pTextureLoadImageAnyExt, GetStringAddress( minimap ), pReservedIntArg1, pReservedIntArg2 )

                    if pTexture > 0 then
                        set pOldTexture = ReadRealMemory( pMiniMap + 0x17C ) // if 1.29+ then 0x188

                        if pOldTexture > 0 then
                            call WriteRealMemory( pMiniMap + 0x17C, pTexture )
                            return this_call_1( pTextureUnloadImage, pOldTexture )
                        else
                            call this_call_1( pTextureUnloadImage, pTexture )
                        endif
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function Init_APIMemoryGameUI takes nothing returns nothing
        if PatchVersion != "" then
           if PatchVersion == "1.24e" then
                set pGetGameUI                  = pGameDLL + 0x301250
                set pUpdateUI                   = pGameDLL + 0x333240
                set pTextureLoadImageAnyExt     = pGameDLL + 0x7283A0
                set pTextureUnloadImage         = pGameDLL + 0x4DECB0
                set pWorldFrameWar3UI           = pGameDLL + 0x9536A8
        elseif PatchVersion == "1.26a" then
                set pGetGameUI                  = pGameDLL + 0x300710
                set pUpdateUI                   = pGameDLL + 0x332700
                set pTextureLoadImageAnyExt     = pGameDLL + 0x727C00
                set pTextureUnloadImage         = pGameDLL + 0x4DE1B0
                set pWorldFrameWar3UI           = pGameDLL + 0x941550
        elseif PatchVersion == "1.27a" then
                set pGetGameUI                  = pGameDLL + 0x34F3A0
                set pUpdateUI                   = pGameDLL + 0x3599F0
                set pTextureLoadImageAnyExt     = pGameDLL + 0x6FEA00 // ((int)"war3mapMap.tga", &
                set pTextureUnloadImage         = pGameDLL + 0x197AB0 // Storm_403(this, "Texture.cpp", 965, 0);
                set pWorldFrameWar3UI           = pGameDLL + 0x98DCD0 // *CWorldFrameWar3::`vftable`;
        elseif PatchVersion == "1.27b" then
                set pGetGameUI                  = pGameDLL + 0x36CB20
                set pUpdateUI                   = pGameDLL + 0x377190
                set pTextureLoadImageAnyExt     = pGameDLL + 0x71C150
                set pTextureUnloadImage         = pGameDLL + 0x1B57E0
                set pWorldFrameWar3UI           = pGameDLL + 0xABB66C
        elseif PatchVersion == "1.28f" then
                set pGetGameUI                  = pGameDLL + 0x3A0B70
                set pUpdateUI                   = pGameDLL + 0x3AB2A0
                set pTextureLoadImageAnyExt     = pGameDLL + 0x750320
                set pTextureUnloadImage         = pGameDLL + 0x1E8060 // Storm_403(this, "Texture.cpp", 901,
                set pWorldFrameWar3UI           = pGameDLL + 0xAAC008
            endif

            if pGetGameUI > 0 then
                set pGameUI = GetGameUI( 0, 0 )
            endif
        endif
    endfunction
endlibrary

function InitTrig_APIMemoryGameUI takes nothing returns nothing
    //set gg_trg_APIMemoryGameUI = CreateTrigger(  )
endfunction
//! endnocjass
