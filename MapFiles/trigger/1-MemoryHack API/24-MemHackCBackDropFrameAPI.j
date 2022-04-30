//TESH.scrollpos=14
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameBackDropAPI
    globals
        integer pCreateCBackdropFrame       = 0
        integer pLoadCBackDropFrameTexture  = 0
        integer pSetCBackDropFrameTexture   = 0
    endglobals
    
    function AllocateCBackdropFrameMemory takes nothing returns integer
        return StormAllocateMemory( 0x1DC, "MemHackCBackdropFrame", 23, 0 )
    endfunction
    
    function CreateCBackdropFrameEx takes integer pBackDrop, integer pParent, integer unk1, integer priority returns integer
        if pCreateCBackdropFrame != 0 and pBackDrop != 0 then
            return this_call_4( pCreateCBackdropFrame, pBackDrop, pParent, unk1, priority )
        endif

        return 0
    endfunction
    
    function CreateCBackdropFrame takes integer pParent, integer priority returns integer
        return CreateCBackdropFrameEx( AllocateCBackdropFrameMemory( ), pParent, 0, priority )
    endfunction
    
    function LoadCBackDropFrameTexture takes string texturepath, boolean create returns integer
        if pLoadCBackDropFrameTexture > 0 then
            if texturepath != "" then
                return std_call_2( pLoadCBackDropFrameTexture, GetStringAddress( texturepath ), B2I( create ) )
            endif
        endif

        return 0
    endfunction

    function SetCBackDropFrameTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCBackDropFrameTexture > 0 then
            if fid == 1 then
                return this_call_6( pSetCBackDropFrameTexture, pFrame, GetStringAddress( texturepath ), 0, B2I( flag ), 0, 1 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCBackDropFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCreateCBackdropFrame       = pGameDLL + 0x621670
                set pLoadCBackDropFrameTexture  = pGameDLL + 0x621780
                set pSetCBackDropFrameTexture   = pGameDLL + 0x621A70
        elseif PatchVersion == "1.26a" then
                set pCreateCBackdropFrame       = pGameDLL + 0x620ED0
                set pLoadCBackDropFrameTexture  = pGameDLL + 0x620FE0
                set pSetCBackDropFrameTexture   = pGameDLL + 0x6212D0
        elseif PatchVersion == "1.27a" then
                set pCreateCBackdropFrame       = pGameDLL + 0x0A4700
                set pLoadCBackDropFrameTexture  = pGameDLL + 0x0A4AE0
                set pSetCBackDropFrameTexture   = pGameDLL + 0x0A62A0
        elseif PatchVersion == "1.27b" then
                set pCreateCBackdropFrame       = pGameDLL + 0x0F8460
                set pLoadCBackDropFrameTexture  = pGameDLL + 0x0F8840
                set pSetCBackDropFrameTexture   = pGameDLL + 0x0FA000
        elseif PatchVersion == "1.28f" then
                set pCreateCBackdropFrame       = pGameDLL + 0x126AD0
                set pLoadCBackDropFrameTexture  = pGameDLL + 0x126EB0
                set pSetCBackDropFrameTexture   = pGameDLL + 0x128670
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCBackDropFrameAPI takes nothing returns nothing
    //set gg_trg_MemHackCBackDropFrameAPI = CreateTrigger(  )
endfunction
//! endnocjass
