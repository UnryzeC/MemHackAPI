//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleRegionAPI
    function SetCSimpleRegionVertexColour takes integer pFrame, integer colour returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer fid  = 0

        if addr != 0 and arg != 0 then
            set fid  = GetFrameType( pFrame )

            if fid == 19 or fid == 39 or fid == 64 then
                if fid == 39 then
                    set pFrame = ReadRealMemory( pFrame + 0x134 ) // if 1.29+ then 0x138
                endif

                if pFrame > 0 then
                    call WriteRealMemory( arg + 0x0, colour )
                    return this_call_2( addr, pFrame, arg + 0x0 ) 
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
                call SaveInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ), pGameDLL + 0x60EEE0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ), pGameDLL + 0x60E740 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ), pGameDLL + 0x0BFA30 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ), pGameDLL + 0x113790 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSimpleRegion" ), StringHash( "SetVertexColour" ), pGameDLL + 0x141E40 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleRegionAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleRegionAPI = CreateTrigger(  )
endfunction
//! endnocjass
