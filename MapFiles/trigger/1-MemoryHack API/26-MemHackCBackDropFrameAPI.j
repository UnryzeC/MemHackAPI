//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameBackDropAPI
    function AllocateCBackdropFrameMemory takes nothing returns integer
        return StormAllocateMemory( 0x1DC, "MemHackCBackdropFrame", 4, 0 )
    endfunction
    
    function CreateCBackdropFrameEx takes integer pBackDrop, integer pParent, integer createContext, integer priority returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ) )

        if addr != 0 and pBackDrop != 0 then
            return this_call_4( addr, pBackDrop, pParent, createContext, priority )
        endif

        return 0
    endfunction
    
    function CreateCBackdropFrame takes integer pParent, integer priority returns integer
        return CreateCBackdropFrameEx( AllocateCBackdropFrameMemory( ), pParent, 0, priority )
    endfunction
    
    function LoadCBackDropFrameTexture takes string texturepath, boolean create returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ) )

        if addr != 0 and texturepath != "" then
            return std_call_2( addr, GetStringAddress( texturepath ), B2I( create ) )
        endif

        return 0
    endfunction

    function SetCBackDropFrameTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CBackdropFrame" then // 1
                return this_call_6( addr, pFrame, GetStringAddress( texturepath ), 0, B2I( flag ), 0, 1 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCBackDropFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x621670 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x621780 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x621A70 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x620ED0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x620FE0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x6212D0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x0A4700 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x0A4AE0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x0A62A0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x0F8460 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x0F8840 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x0FA000 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x126AD0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x126EB0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x128670 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCBackDropFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCBackDropFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
