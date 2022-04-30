//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleRegionAPI
    globals
        integer pSetCSimpleRegionVertexColour   = 0
    endglobals

    function SetCSimpleRegionVertexColour takes integer pFrame, integer colour returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleRegionVertexColour > 0 then
            if fid == 19 or fid == 39 or fid == 64 then
                if fid == 39 then
                    set pFrame = ReadRealMemory( pFrame + 0x134 ) // if 1.29+ then 0x138
                endif

                if pFrame > 0 then
                    call WriteRealMemory( pReservedIntArg1, colour )
                    return this_call_2( pSetCSimpleRegionVertexColour, pFrame, pReservedIntArg1 ) 
                endif
            endif
        endif

        return 0
    endfunction

    function SetCSimpleRegionVertexColourEx takes integer pFrame, integer alpha, integer red, integer blue, integer green returns integer
        return SetCSimpleRegionVertexColour( pFrame, GetARGBColour( alpha, red, blue, green ) )
    endfunction

    function Init_MemHackCSimpleRegionAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pSetCSimpleRegionVertexColour   = pGameDLL + 0x60EEE0
        elseif PatchVersion == "1.26a" then
                set pSetCSimpleRegionVertexColour   = pGameDLL + 0x60E740
        elseif PatchVersion == "1.27a" then
                set pSetCSimpleRegionVertexColour   = pGameDLL + 0x0BFA30
        elseif PatchVersion == "1.27b" then
                set pSetCSimpleRegionVertexColour   = pGameDLL + 0x113790
        elseif PatchVersion == "1.28f" then
                set pSetCSimpleRegionVertexColour   = pGameDLL + 0x141E40
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleRegionAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleRegionAPI = CreateTrigger(  )
endfunction
//! endnocjass
