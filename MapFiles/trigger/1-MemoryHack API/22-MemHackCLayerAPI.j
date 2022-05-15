//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCLayerAPI
    function FindCLayerUnderCursorEx takes integer pActiveLayer, integer pMouseEvent returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ) )
        local integer pData = 0
        local integer value = 0

        if addr != 0 and pActiveLayer != 0 and pMouseEvent != 0 then
            set pData = ReadRealMemory( pActiveLayer )

            if pData != 0 then
                set pData = this_call_2( addr, pData, pMouseEvent )

                if pData != 0 then
                    if ReadRealMemory( pData ) != pWorldFrameWar3 then
                        return pData
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function FindCLayerUnderCursor takes nothing returns integer
        return FindCLayerUnderCursorEx( LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ) ), LoadInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ) ) )
    endfunction
    
    function SetCLayerOwner takes integer pFrame, integer pParentFrame returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ) )

        if addr != 0 and pFrame != 0 and pParentFrame != 0 then
            return this_call_4( addr, pFrame, pParentFrame, 1, 0 )
        endif

        return 0
    endfunction

    function HideCLayer takes integer pFrame returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ) )

        if addr != 0 and pFrame !=0 then
            return this_call_1( addr, pFrame )
        endif

        return 0
    endfunction

    function ShowCLayer takes integer pFrame returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ) )

        if addr != 0 and pFrame != 0 then
            return this_call_1( addr, pFrame )
        endif

        return 0
    endfunction

    function SetCLayerAlpha takes integer pFrame, integer alpha returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid != 0 and fid != 6 then
                return this_call_3( addr, pFrame, alpha, 0 )
            endif
        endif

        return 0
    endfunction

    function SetCLayerFont takes integer pFrame, string filename, real height, integer flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ) )
        local integer fid  = 0

        if addr != 0 and pFrame != 0 then
            set fid = GetFrameType( pFrame )

            if fid != 6 and fid != 19 and fid != 23 then
                if not IsFrameLayoutByType( pFrame, fid ) then
                    return this_call_4( addr, pFrame, GetStringAddress( filename ), SetRealIntoMemory( height ), flag )
                endif
            endif
        endif

        return 0
    endfunction

    function SetCLayerTooltip takes integer pFrame, integer pTooltip returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLayoutFrame" ), StringHash( "SetAllPoints" ) )
        local integer fid  = 0

        if addr != 0 then
            set fid = GetFrameType( pFrame )

            if fid > 0 then
                if pTooltip > 0 then
                    call WriteRealMemory( pFrame + 0x230, 1 )
                    call this_call_2( addr, pTooltip + 0xB4, 1 ) //if 1.29+ then 0xBC
                endif
                
                set addr = LoadInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ) )

                if addr != 0 then
                    return this_call_2( addr, pFrame, pTooltip )
                endif
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCLayerAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ), pGameDLL + 0x5FE1C0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ),        pGameDLL + 0x5FFE70 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ),            pGameDLL + 0x5FEE90 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ),            pGameDLL + 0x5FEE30 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ),        pGameDLL + 0x5FE660 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ),         pGameDLL + 0x5FC100 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ),      pGameDLL + 0x5FFFA0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ),     pGameDLL + 0xAE54CC )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ), pGameDLL + 0x5FDA20 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ),        pGameDLL + 0x5FF6D0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ),            pGameDLL + 0x5FE6F0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ),            pGameDLL + 0x5FE690 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ),        pGameDLL + 0x5FDEC0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ),         pGameDLL + 0x5FB960 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ),      pGameDLL + 0x5FF800 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ),     pGameDLL + 0xACE66C )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ), pGameDLL + 0x0996E0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ),        pGameDLL + 0x09D2B0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ),            pGameDLL + 0x09A320 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ),            pGameDLL + 0x09D450 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ),        pGameDLL + 0x09CA50 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ),         pGameDLL + 0x09CE60 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ),      pGameDLL + 0x09D3D0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ),     pGameDLL + 0xBB9D88 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ), pGameDLL + 0x0ED440 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ),        pGameDLL + 0x0F1010 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ),            pGameDLL + 0x0EE080 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ),            pGameDLL + 0x0F11B0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ),        pGameDLL + 0x0F07B0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ),         pGameDLL + 0x0F0BC0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ),      pGameDLL + 0x0F1130 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ),     pGameDLL + 0xD47820 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "FindUnderCursor" ), pGameDLL + 0x11BA90 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetOwner" ),        pGameDLL + 0x11F660 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Hide" ),            pGameDLL + 0x11C6D0 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "Show" ),            pGameDLL + 0x11F800 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetAlpha" ),        pGameDLL + 0x11EE00 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetFont" ),         pGameDLL + 0x11F210 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "SetTooltip" ),      pGameDLL + 0x11F780 )
                call SaveInteger( MemHackTable, StringHash( "CLayer" ), StringHash( "ActiveFrame" ),     pGameDLL + 0xD0F600 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCLayerAPI takes nothing returns nothing
    //set gg_trg_MemHackCLayerAPI = CreateTrigger(  )
endfunction
//! endnocjass
