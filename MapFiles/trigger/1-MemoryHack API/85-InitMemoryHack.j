//TESH.scrollpos=54
//TESH.alwaysfold=0
//! nocjass
function Init_MemoryHack takes nothing returns nothing
    if PatchVersion != "" then
        call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "MemHackAPI v1.7" )
        call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Patch Version: " + PatchVersion )

        // Before removing any of the Init_API functions, make sure you removed functions that depend on them!
        // Do NOT put any of the hooks or memory modifications BEFORE all of these init methods are done.
        // You can however disable and remove stuff you don't need, but some of the modules may still have connections.
        // Remove things that you don't need responsibly!

        //====================Init====================
        call Init_APITypecast( )                        // API for general value typecasting, required by some of the functions!
        call Init_APIMemory( )                          // API for general memory read/write management, everything else depends on this!
        call Init_APIMemoryCalls( )                     // API for tapping into  std/this/cdecl calls and much more, pretty much core of everything.
        call Init_APIMemoryBitwise( )                   // API for bitwise operations many other functions use this.
        call Init_APIMemoryKernel( )                    // API for accessing some of the WinAPI functions, mostly needed for VirtualProtect.
        call Init_APIMemoryMPQ( )                       // API for managing MPQs and files in general, generally this is useless to average mapmaker.
        call Init_APIMemoryString( )                    // API for getting/setting strings from/into memory, most functions use this!
        call Init_APIMemoryStormDLL( )                  // API containing some needed functions from Storm.dll, be cautious with this API.
        call Init_APIMemoryFrameData( )                 // API containing base Frame data and its checks
        call Init_APIMemoryGameData( )                  // API for getting essential data from memory.
        call Init_APIMemoryObjectData( )                // API for object data modification, Effect/Trackable and some Unit functions refer to this.
        call Init_APIMemoryGameUI( )                    // API for general UI handling, and GameUI structure, serves as a core to FrameAPI and UIAPI.
        call Init_APIMemoryGameUIButton( )              // API for Button managment and data handling, getting and even setting information is possible.
        call Init_APIMemoryGameWindow( )                // API that contains functions and data for managing Warcraft 3 game window.
        call Init_MemHackConstantsAPI( )                // API for editing of constants in Warcraft 3, at the moment only OPLimit added.
        call Init_MemHackCFrameAPI( )                   // API Containing base functions for frames of CFrame type.
        call Init_MemHackCLayerAPI( )                   // API Containing base functions for frames of CLayer type.
        call Init_MemHackCBackDropFrameAPI( )           // API Containing base functions for frames of CBackDropFrame type.
        call Init_MemHackCEditBoxAPI( )                 // API Containing base functions for frames of CEditBox type.
        call Init_MemHackCLayoutFrameAPI( )             // API Containing base functions for frames of CLayoutFrame type.
        call Init_MemHackCModelFrameAPI( )              // API Containing base functions for frames of CModelFrame type.
        call Init_MemHackCSimpleButtonAPI( )            // API Containing base functions for frames of CSimpleButton type.
        call Init_MemHackCSimpleFontAPI( )              // API Containing base functions for frames of CSimpleFont type.
        call Init_MemHackCSimpleGlueAPI( )              // API Containing base functions for frames of CSimpleGlue type.
        call Init_MemHackCSimpleFrameAPI( )             // API Containing base functions for frames of CSimpleFrame type.
        call Init_MemHackCSimpleConsoleAPI( )           // API Containing base fucntions for frames of CSimpleConsole type.
        call Init_MemHackCSimpleMessageFrameAPI( )      // API Containing base functions for frames of CSimpleMessageFrame type.
        call Init_MemHackCSliderAPI( )                  // API Containing base functions for frames of CSlider type.
        call Init_MemHackCSpriteFrameAPI( )             // API Containing base functions for frames of CSpriteFrame type.
        call Init_MemHackCTextAreaAPI( )                // API Containing base functions for frames of CTextArea type.
        call Init_MemHackCTextFrameAPI( )               // API Containing base functions for frames of CTextFrame type.
        call Init_MemHackCSimpleStatusBarAPI( )         // API Containing base functions for frames of CSimpleStatusBar type.
        call Init_MemHackCStatusBarAPI( )               // API Containing base functions for frames of CStatusBar type.
        call Init_MemHackCSimpleTextureAPI( )           // API Containing base functions for frames of CSimpleTexture type.
        call Init_MemHackCSimpleRegionAPI( )            // API Containing base functions for frames of CSimpleRegion type.
        call Init_MemHackFrameAPI( )                    // API allowing you to modify SOME frames, peek for more information.
        call Init_MemHackUIAPI( )                       // API allowing you to modify SOME UI elements, contains mostly userfriendly API.
        call Init_MemHackPlayerAPI( )                   // Not required, simply contains some niche functions, non-userfriendly API at the moment.
        call Init_MemHackAbilityAddressAPI( )           // API allowing you to modify ability data freely, peek into the library for the functions.
        call Init_MemHackAbilityBaseAPI( )              // Refers to Init_MemHackAbilityAddressAPI and UIBaseData, contains a simple user-friendly API.
        call Init_MemHackAbilityNormalAPI( )            // Refers to Init_MemHackAbilityAddressAPI, contains a simple user-friendly API.
        call Init_MemHackAbilityUnitAPI( )              // Refers to Init_MemHackAbilityAddressAPI, contains a simple user-friendly API.
        call Init_MemHackCWidgetBaseAPI( )              // API Allowing you to modify some Widget UI/Base data, this is partially used by Base Item API and Base Unit API.
        call Init_MemHackCWidgetNormalAPI( )            // Contains a small portion of things that can be done to widgets, i.e. anything based of widget. 
        call Init_MemHackItemBaseAPI( )                 // API allowing you to modify item's base data.
        call Init_MemHackItemNormalAPI( )               // Contains a small portion of things that can be done to items.
        call Init_MemHackUnitBaseAPI( )                 // API allowing you to modify unit's base data.
        call Init_MemHackUnitNormalAPI( )               // API allowing you to modify unit data freely, peek into the library for the functions.
        call Init_MemHackGroupAPI( )                    // API allowing you to gain access to more functions involving groups, such as ForEach.
        call Init_MemHackCSpriteBaseAPI( )              // API allowing you to access base CSprite functionality, this is needed by CSpriteUber and CSpriteMini.
        call Init_MemHackCSpriteMiniAPI( )              // API allowing you to modify CSpriteMini however you want, this is needed to modify Items/Doodads/Destructables models/etc.
        call Init_MemHackCSpriteUberAPI( )              // API allowing you to modify CSPriteUber however you want, this is needed to modify Units/Effects/Trackables models/etc.
        call Init_MemHackEffectAPI( )                   // API allowing you to modify effect data freely, peek into the library for the functions. This uses Init_MemHackCSpriteUberAPI.
        call Init_MemHackTrackableAPI( )                // Since trackables share the same structure as effects they get same API as effects do. This uses Init_MemHackCSpriteUberAPI.
        call Init_MemHackCastAbility( )                 // API for ability cast, Not required if you are fine with using orders.
        call Init_MemHackMouseAPI( )                    // API for getting local World Mouse position, will cause desync if used on synced functions!
        // call Init_APIMemoryUtilityLibraryAPI( )         // API for faster function calling via UtilityLibrary.dll | tbd
        //=============================================

        //===============Additional APIs=============== // These APIs are for user to decide wherever they are needed or no, you are free to comment them out.
        call Init_APIMemoryRestorer( )                  // API that is responsible for cleaning up all memory modifications after exiting the map. I suggest leaving it UNCOMMENTED, as it cleans up memory.
        //call Init_AntiHack( )                         // Not required, this only works on 1.24e, 1.26a and a bit on 1.27b, as it states it counters hacks.
        call Init_MemHackBerserkHook( )               // Not required, please check what it does and modify or remove if you don't need/understand it!
        call Init_MemHackDamageEventHook( )           // Not required if you do not care about expanding Damage Event, i.e. for getting data pre-damage.
        //call Init_APIMemoryWenHao( )                  // Not required, this simply injects wenhao_plugin.tga with its functionality, and so on...
        call Init_MemHackCustomAbilityChargesHook( )  // Not required, adds visual charges to abilities, note, they are only visual!
        call Init_DrawAllCooldowns( )                 // Not required, this simple mimics what my WFE can do, in short, this is deprecated.
        //=============================================

        //=================Your Stuff==================

        //=============================================
    else
        call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Unsupported patch version!" )
    endif

    call DestroyTimer( GetExpiredTimer( ) )
endfunction

//===========================================================================
function InitTrig_InitMemoryHack takes nothing returns nothing
    //set gg_trg_InitMemoryHack = CreateTrigger(  )
    set bj_FORCE_PLAYER[ 0 ] = CreateForce( )
    call ForceAddPlayer( bj_FORCE_PLAYER[ 0 ], Player( 0 ) )
    call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemory ) + 0x8 ) )
    call TimerStart( CreateTimer( ), .05, false, function Init_MemoryHack )
endfunction
//! endnocjass
