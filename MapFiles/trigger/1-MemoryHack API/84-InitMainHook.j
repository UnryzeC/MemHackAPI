//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library ZzendOpMap

function main2 takes nothing returns nothing
    // Map specific data, remove it and replace with your things, etc...
    local real map_min_x = -3328.
    local real map_min_y = -3584.
    local real map_max_x = 3328.
    local real map_max_y = 3072.
    local real c_m_l = GetCameraMargin( CAMERA_MARGIN_LEFT )
    local real c_m_b = GetCameraMargin( CAMERA_MARGIN_BOTTOM )
    local real c_m_r = GetCameraMargin( CAMERA_MARGIN_RIGHT )
    local real c_m_t = GetCameraMargin( CAMERA_MARGIN_TOP )
    call SetCameraBounds( map_min_x + c_m_l, map_min_y + c_m_b, map_max_x - c_m_r, map_max_y - c_m_t, map_min_x + c_m_l, map_max_y - c_m_t, map_max_x - c_m_r, map_min_y + c_m_b )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )

    call InitTrig_Testing( )
    // All of the above is just map specific data, replace it with yours!
    
    // Your stuff goes here...
    
    // This is just to init testing code, feel free to remove it!
endfunction

endlibrary

library InitMain
// This is where we hook "main" function that World Editor generates, so we have full control over it.
//! inject main
//! dovjassinit
// We are calling for MemHack FIRST, to ensure that it works (this is crucial on patches 1.27b and above).
// The reason is simple, apparently locals sometimes occupy the memory that we need to open WRITE functionality, hence causing a crash.
// Also, this allows you as a user to freely control what is and what is NOT needed in your map.
call InitTrig_InitMemoryHack( )
call CreateAllUnits( )
// Now that MemHack is loaded, you can call whatever functions you need. Initialisers and such, but remember, do NOT put ANYTHING above MemHack execution.
// Your stuff goes here...
// Note, if you are too lazy to re-do everything, you can check what your main function currently contains.
// Rename it to let's say main2 and just call main2 right below InitTrig_InitMemoryHack function.
call main2( ) // this is an example you can also do: call ExecuteFunc( "main2" )

// Note: If you use ExecuteFunc, make sure that there are NO SUBSEQUENT ExecuteFunc inside of main2, this could cause the threading issue.
//! endinject

// You can also hook config function in the same way and modify it if needed (which is suggested for direct control over slots and such).
endlibrary

//===========================================================================
function InitTrig_InitMainHook takes nothing returns nothing
//    set gg_trg_InitMainHook = CreateTrigger(  )
endfunction
//! endnocjass
