//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryhStormDLL
    globals
        integer pStormDLL                   = 0
        integer pStormAllocateMemory        = 0
        integer pStormFreeMemory            = 0
        integer pStormGetMemorySize         = 0
        integer pStormReallocateMemory      = 0
    endglobals

    function StormAllocateMemory takes integer size, string name, integer unk_1, integer unk_2 returns integer
        if pStormAllocateMemory > 0 then
            if size > 0 then
                return std_call_4( pStormAllocateMemory, size, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction

    function StormFreeMemory takes integer addr, string name, integer unk_1, integer unk_2 returns integer
        if pStormFreeMemory > 0 then
            if addr > 0 then
                return std_call_4( pStormFreeMemory, addr, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction

    function StormGetMemorySize takes integer addr, string name, integer unk_1 returns integer
        if pStormGetMemorySize > 0 then
            if addr > 0 then
                return std_call_3( pStormGetMemorySize, addr, GetStringAddress( name ), unk_1 )
            endif
        endif

        return 0
    endfunction

    function StormReallocateMemory takes integer addr, integer size, string name, integer unk_1, integer unk_2 returns integer
        if pStormReallocateMemory > 0 then
            if size > 0 and size > 0 then
                return std_call_5( pStormReallocateMemory, addr, size, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction
    
    function Init_APIMemoryStormDLL takes nothing returns nothing
        if PatchVersion != "" then
            set pStormDLL = GetModuleHandle( "Storm.dll" )

            if pStormDLL > 0 then
                if PatchVersion == "1.24e" then
                    set pStormAllocateMemory    = pStormDLL + 0x025F30
                    set pStormFreeMemory        = pStormDLL + 0x024880
                    set pStormGetMemorySize     = pStormDLL + 0x024AD0
                    set pStormReallocateMemory  = pStormDLL + 0x026230
            elseif PatchVersion == "1.26a" then
                    set pStormAllocateMemory    = pStormDLL + 0x025F30
                    set pStormFreeMemory        = pStormDLL + 0x024880
                    set pStormGetMemorySize     = pStormDLL + 0x024AD0
                    set pStormReallocateMemory  = pStormDLL + 0x026230
            elseif PatchVersion == "1.27a" then
                    set pStormAllocateMemory    = pStormDLL + 0x02B830 // Storm_401
                    set pStormFreeMemory        = pStormDLL + 0x02BE40 // Storm_403
                    set pStormGetMemorySize     = pStormDLL + 0x02C000 // Storm_404
                    set pStormReallocateMemory  = pStormDLL + 0x02C8B0 // Storm_405
            elseif PatchVersion == "1.27b" then
                    set pStormAllocateMemory    = pStormDLL + 0x02B6D0
                    set pStormFreeMemory        = pStormDLL + 0x02BCE0
                    set pStormGetMemorySize     = pStormDLL + 0x02BEA0
                    set pStormReallocateMemory  = pStormDLL + 0x02C760
            elseif PatchVersion == "1.28f" then
                    set pStormAllocateMemory    = pStormDLL + 0x02BC10
                    set pStormFreeMemory        = pStormDLL + 0x02C220
                    set pStormGetMemorySize     = pStormDLL + 0x02C3E0
                    set pStormReallocateMemory  = pStormDLL + 0x02CC90
                endif
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryStormDLL takes nothing returns nothing
    //set gg_trg_APIMemoryStormDLL = CreateTrigger(  )
endfunction
//! endnocjass
