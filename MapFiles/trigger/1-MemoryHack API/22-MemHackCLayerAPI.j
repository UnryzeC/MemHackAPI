//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCLayerAPI
    globals
        integer pFindCLayerUnderCursor          = 0
        integer pSetCLayerOwner                 = 0
        integer pHideCLayer                     = 0
        integer pShowCLayer                     = 0
        integer pSetCLayerAlpha                 = 0
        integer pSetCLayerFont                  = 0
        integer pSetCLayerTooltip               = 0

        integer pActiveCLayer                   = 0
    endglobals

    function FindCLayerUnderCursorEx takes integer pActiveLayer, integer pMouseEvent returns integer
        local integer pData = 0
        local integer value = 0

        if pActiveLayer > 0 then
            set pData = ReadRealMemory( pActiveLayer )
            
            if pData > 0 then
                set pData = this_call_2( pFindCLayerUnderCursor, pData, pMouseEvent )

                if pData > 0 then
                    if ReadRealMemory( pData ) != pWorldFrameWar3UI then
                        return pData
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function FindCLayerUnderCursor takes nothing returns integer
        return FindCLayerUnderCursorEx( pActiveCLayer, pGlobalMouseEvent )
    endfunction
    
    function SetCLayerOwner takes integer pFrame, integer pParentFrame returns integer
        if pSetCLayerOwner > 0 then
            if pFrame > 0 and pParentFrame > 0 then
                return this_call_4( pSetCLayerOwner, pFrame, pParentFrame, 1, 0 )
            endif
        endif

        return 0
    endfunction

    function HideCLayer takes integer pFrame returns integer
        if pHideCLayer > 0 then
            if pFrame > 0 then
                return this_call_1( pHideCLayer, pFrame )
            endif
        endif

        return 0
    endfunction

    function ShowCLayer takes integer pFrame returns integer
        if pShowCLayer > 0 then
            if pFrame > 0 then
                return this_call_1( pShowCLayer, pFrame )
            endif
        endif

        return 0
    endfunction

    function SetCLayerAlpha takes integer pFrame, integer alpha returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayerAlpha > 0 then
            if fid > 0 and fid != 6 then
                return this_call_3( pSetCLayerAlpha, pFrame, alpha, 0 )
            endif
        endif

        return 0
    endfunction

    function SetCLayerFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayerFont > 0 then
            if fid != 6 and fid != 19 and fid != 23 then
                if not IsFrameLayoutByType( pFrame, fid ) then
                    return this_call_4( pSetCLayerFont, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
                endif
            endif
        endif

        return 0
    endfunction

    function SetCLayerTooltip takes integer pFrame, integer pTooltip returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCLayerTooltip > 0 then
            if fid > 0 then
                if pTooltip > 0 then
                    call WriteRealMemory( pFrame + 0x230, 1 )
                    call this_call_2( pClearCLayoutFrameAllPoints, pTooltip + 0xB4, 1 ) //if 1.29+ then 0xBC
                endif

                return this_call_2( pSetCLayerTooltip, pFrame, pTooltip )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCLayerAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pFindCLayerUnderCursor  = pGameDLL + 0x5FE1C0
                set pSetCLayerOwner         = pGameDLL + 0x5FFE70
                set pHideCLayer             = pGameDLL + 0x5FEE90
                set pShowCLayer             = pGameDLL + 0x5FEE30
                set pSetCLayerAlpha         = pGameDLL + 0x5FE660
                set pSetCLayerFont          = pGameDLL + 0x5FC100
                set pSetCLayerTooltip       = pGameDLL + 0x5FFFA0
                set pActiveCLayer           = pGameDLL + 0xAE54CC
        elseif PatchVersion == "1.26a" then
                set pFindCLayerUnderCursor  = pGameDLL + 0x5FDA20
                set pSetCLayerOwner         = pGameDLL + 0x5FF6D0
                set pHideCLayer             = pGameDLL + 0x5FE6F0
                set pShowCLayer             = pGameDLL + 0x5FE690
                set pSetCLayerAlpha         = pGameDLL + 0x5FDEC0
                set pSetCLayerFont          = pGameDLL + 0x5FB960
                set pSetCLayerTooltip       = pGameDLL + 0x5FF800
                set pActiveCLayer           = pGameDLL + 0xACE66C
        elseif PatchVersion == "1.27a" then
                set pFindCLayerUnderCursor  = pGameDLL + 0x0996E0
                set pSetCLayerOwner         = pGameDLL + 0x09D2B0
                set pHideCLayer             = pGameDLL + 0x09A320
                set pShowCLayer             = pGameDLL + 0x09D450
                set pSetCLayerAlpha         = pGameDLL + 0x09CA50
                set pSetCLayerFont          = pGameDLL + 0x09CE60
                set pSetCLayerTooltip       = pGameDLL + 0x09D3D0
                set pActiveCLayer           = pGameDLL + 0xBB9D88
        elseif PatchVersion == "1.27b" then
                set pFindCLayerUnderCursor  = pGameDLL + 0x0ED440
                set pSetCLayerOwner         = pGameDLL + 0x0F1010
                set pHideCLayer             = pGameDLL + 0x0EE080
                set pShowCLayer             = pGameDLL + 0x0F11B0
                set pSetCLayerAlpha         = pGameDLL + 0x0F07B0
                set pSetCLayerFont          = pGameDLL + 0x0F0BC0
                set pSetCLayerTooltip       = pGameDLL + 0x0F1130
                set pActiveCLayer           = pGameDLL + 0xD47820
        elseif PatchVersion == "1.28f" then
                set pFindCLayerUnderCursor  = pGameDLL + 0x11BA90
                set pSetCLayerOwner         = pGameDLL + 0x11F660
                set pHideCLayer             = pGameDLL + 0x11C6D0
                set pShowCLayer             = pGameDLL + 0x11F800
                set pSetCLayerAlpha         = pGameDLL + 0x11EE00
                set pSetCLayerFont          = pGameDLL + 0x11F210
                set pSetCLayerTooltip       = pGameDLL + 0x11F780
                set pActiveCLayer           = pGameDLL + 0xD0F600
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCLayerAPI takes nothing returns nothing
    //set gg_trg_MemHackCLayerAPI = CreateTrigger(  )
endfunction
//! endnocjass
