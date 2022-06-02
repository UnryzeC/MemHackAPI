//TESH.scrollpos=9
//TESH.alwaysfold=0
//! nocjass
library APIMemoryUtilityLibraryAPI
    function GetUtilityLibraryHashtable takes nothing returns hashtable
        return LoadHashtableHandle( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "HashTable" ) )
    endfunction

    function InitHashtableListener takes hashtable ht returns boolean
        local integer addr = GetFuncFromDll( "UtilityLibrary.dll", "InitHashtableListener", true )

        if addr != 0 and ht != null then
            call c_call_1( addr, GetHandleId( ht ) )
            return true
        endif

        return false
    endfunction

    function RemoveHashtableListeners takes nothing returns boolean
        local integer addr = GetFuncFromDll( "UtilityLibrary.dll", "RemoveHashtableListeners", true )

        if addr != 0 then
            call c_call_0( addr )
            return true
        endif

        return false
    endfunction
    
    function Init_APIMemoryUtilityLibraryAPI takes nothing returns nothing
        if PatchVersion != "" then
            if LoadDllFromMPQ( "UtilityLibrary.dll" ) then
                call SaveHashtableHandle( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "HashTable" ), InitHashtable( ) )
                // call SaveInteger( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "Module" ), GetModuleHandle( "UtilityLibrary.dll" ) )
                call InitHashtableListener( GetUtilityLibraryHashtable( ) )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryUtilityLibraryAPI takes nothing returns nothing
    //set gg_trg_APIMemoryUtilityLibraryAPI = CreateTrigger(  )
endfunction
//! endnocjass
