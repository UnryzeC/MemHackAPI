//TESH.scrollpos=6
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCSimpleTextureAPI
    globals
        integer pCreateCSimpleTexture       = 0
        integer pFillCSimpleTexture         = 0
        integer pGetCSimpleTextureByName    = 0
        integer pSetCSimpleTextureTexture   = 0
    endglobals

    function CreateCSimpleTexture takes integer pParent returns integer
        local integer baseobj = 0

        if pCreateCSimpleTexture > 0 then
            set baseobj = StormAllocateMemory( 0xE8, "", 0, 0 )

            if baseobj > 0 then
                return this_call_4( pCreateCSimpleTexture, baseobj, pParent, 2, 1 )
            endif
        endif

        return 0
    endfunction

    function FillCSimpleTexture takes integer pFrame, integer colour returns integer
        if pFillCSimpleTexture > 0 then
            call WriteRealMemory( pReservedIntArg1, colour )
            return B2I( this_call_2( pFillCSimpleTexture, pFrame, pReservedIntArg1 ) == 0 )
        endif

        return 0
    endfunction

    function GetCSimpleTextureByName takes string name, integer id returns integer
        if pGetCSimpleTextureByName > 0 then
            if name != "" then
                return fast_call_2( pGetCSimpleTextureByName, GetStringAddress( name ), id )
            endif
        endif

        return 0
    endfunction

    function SetCSimpleTextureTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer fid = GetFrameType( pFrame )

        if pSetCSimpleTextureTexture > 0 then
            if fid == 64 then
                return this_call_3( pSetCSimpleTextureTexture, pFrame, GetStringAddress( texturepath ), B2I( flag ) )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCSimpleTextureAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pCreateCSimpleTexture       = pGameDLL + 0x60E0A0
                set pFillCSimpleTexture         = pGameDLL + 0x60DB50
                set pGetCSimpleTextureByName    = pGameDLL + 0x61CF30
                set pSetCSimpleTextureTexture   = pGameDLL + 0x60E830
        elseif PatchVersion == "1.26a" then
                set pCreateCSimpleTexture       = pGameDLL + 0x60D900
                set pFillCSimpleTexture         = pGameDLL + 0x60D3B0
                set pGetCSimpleTextureByName    = pGameDLL + 0x61C790
                set pSetCSimpleTextureTexture   = pGameDLL + 0x60E090
        elseif PatchVersion == "1.27a" then
                set pCreateCSimpleTexture       = pGameDLL + 0x0C90B0
                set pGetCSimpleTextureByName    = pGameDLL + 0x324AD0
                set pFillCSimpleTexture         = pGameDLL + 0x0C1170
                set pSetCSimpleTextureTexture   = pGameDLL + 0x0C11E0
        elseif PatchVersion == "1.27b" then
                set pCreateCSimpleTexture       = pGameDLL + 0x113930
                set pGetCSimpleTextureByName    = pGameDLL + 0x342220
                set pFillCSimpleTexture         = pGameDLL + 0x114ED0
                set pSetCSimpleTextureTexture   = pGameDLL + 0x114F40
        elseif PatchVersion == "1.28f" then
                set pCreateCSimpleTexture       = pGameDLL + 0x141FE0
                set pGetCSimpleTextureByName    = pGameDLL + 0x3761E0
                set pFillCSimpleTexture         = pGameDLL + 0x143580
                set pSetCSimpleTextureTexture   = pGameDLL + 0x1435F0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackCSimpleTextureAPI takes nothing returns nothing
    //set gg_trg_MemHackCSimpleTextureAPI = CreateTrigger(  )
endfunction
//! endnocjass
