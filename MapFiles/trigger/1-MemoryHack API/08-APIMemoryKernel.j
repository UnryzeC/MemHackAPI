//TESH.scrollpos=347
//TESH.alwaysfold=0
//! nocjass
library APIMemoryKernel
    globals
        integer pIsBadReadPtr               = 0
        integer pGetSystemTime              = 0
        integer pGetLocalTime               = 0
        integer pSysTimeReservedMemory      = 0
        integer pGetCurrentProcessId        = 0
        integer pGetPrivateProfileStringA   = 0
        integer pWritePrivateProfileStringA = 0
        integer pGetFileAttributesA         = 0
        integer pLoadLibraryA               = 0
        integer pShellExecuteA              = 0
        integer pMessageBoxA                = 0
        integer pFindWindowA                = 0
        integer pFindWindowExA              = 0
        integer pGetWindowClassName         = 0
        integer pGetWindowText              = 0
        integer pPostMessageA               = 0
        integer pGetAsyncKeyState           = 0
        integer pWindowRect                 = 0
        integer pGetWindowRect              = 0
        integer pGetSystemMetrics           = 0
        integer pScreenToClient             = 0
        integer pCursorCoords               = 0
        integer pGetCursorPos               = 0
        integer pHWND_WC3                   = 0

        integer BenchmarkTime               = 0
        integer BenchmarkLastTime           = 0
    endglobals

    function IsBadReadPtr takes integer pointer, integer size returns boolean
        if pIsBadReadPtr == 0 then
            set pIsBadReadPtr = GetModuleProcAddress( "Kernel32.dll", "IsBadReadPtr" )
        endif

        if pIsBadReadPtr != 0 then
            return std_call_2( pIsBadReadPtr, pointer, size ) == 0
        endif

        return false
    endfunction
    
    // 0 - milisecond | 1 - Sec | 2 - Minutes | 3 - Hours | 4 - Day | 5 - Day of Week | 6 - Month | 7 - Year
    function GetLocalTime takes integer timeId returns integer
        local integer pOff   = 0
        local integer memval = 0

        if pGetLocalTime == 0 then 
            set pGetLocalTime = GetModuleProcAddress( "Kernel32.dll", "GetLocalTime" )
        endif

        if pGetLocalTime != 0 then 
            call std_call_1( pGetLocalTime, pSysTimeReservedMemory )

            if timeId >= 0 and timeId <= 7 then
                set memval = ReadRealMemory( pSysTimeReservedMemory + ( 0xE - timeId * 2 ) )

                if memval > 0 then
                    return CreateInteger1( 0, 0, GetByteFromInteger( memval, 3 ), GetByteFromInteger( memval, 4 ) )
                endif
            endif
        endif

        return 0
    endfunction

    function GetCurrentProcessId takes nothing returns integer
        if pGetCurrentProcessId == 0 then
            set pGetCurrentProcessId = GetModuleProcAddress( "Kernel32.dll", "GetCurrentProcessId" )
        endif

        if pGetCurrentProcessId != 0 then
            return c_call_1( pGetCurrentProcessId, 0 )
        endif

        return 0
    endfunction

    function VirtualProtect takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        if pVirtualProtect == 0 then
            set pVirtualProtect = GetModuleProcAddress( "Kernel32.dll", "VirtualProtect" )
        endif

        if pVirtualProtect != 0 then
            call std_call_4( pVirtualProtect, pRealOffset, pMemSize, pProtectFlag, pReservedIntArg1 )
            return ReadRealMemory( pReservedIntArg1 )
        endif

        return 0
    endfunction

    function ReadStringFromFile takes string sfile, string ssection, string skey, string sdefval returns string
        if pGetPrivateProfileStringA == 0 then
            set pGetPrivateProfileStringA = GetModuleProcAddress( "Kernel32.dll", "GetPrivateProfileStringA" )
        endif
        
        if pGetPrivateProfileStringA != 0 then 
            // szReservedWritableMemory = 3000
            call std_call_6( pGetPrivateProfileStringA, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sdefval ), pReservedWritableMemory, 3000, GetStringAddress( sfile ) )
            return ToJString( pReservedWritableMemory )
        endif

        return ""
    endfunction

    function WriteStringToFile takes string sfile, string ssection, string skey, string sval returns nothing
        local integer nOffset1
        
        if pWritePrivateProfileStringA == 0 then
            set pWritePrivateProfileStringA = GetModuleProcAddress( "Kernel32.dll", "WritePrivateProfileStringA" )
        endif

        if pWritePrivateProfileStringA != 0 then 
            call std_call_4( pWritePrivateProfileStringA, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sval ), GetStringAddress( sfile ) )
        endif
    endfunction

    function GetFileAttributes takes string s returns integer
        if pGetFileAttributesA == 0 then
            set pGetFileAttributesA = GetModuleProcAddress( "Kernel32.dll", "GetFileAttributesA" )
        endif

        if pGetFileAttributesA != 0 then
            return std_call_1( pGetFileAttributesA, GetStringAddress( s ) )
        endif
     
        return 0
    endfunction

    function LoadLibrary takes string nDllName returns integer
        if pLoadLibraryA == 0 then
            set pLoadLibraryA = GetModuleProcAddress( "Kernel32.dll", "LoadLibraryA" )
        endif

        if pLoadLibraryA != 0 then
            return std_call_1( pLoadLibraryA, GetStringAddress( nDllName ) )
        endif

        return 0
    endfunction

    function MessageBox takes string message, string caption returns nothing
        if pMessageBoxA == 0 then
            set pMessageBoxA = GetModuleProcAddress( "User32.dll", "MessageBoxA" )
        endif

        if pMessageBoxA != 0 then
            call std_call_4( pMessageBoxA, 0, GetStringAddress( message ), GetStringAddress( caption ), 0 )
        endif
    endfunction

    function FindWindowByAddr takes integer c_addr, integer w_addr returns integer
        if pFindWindowA == 0 then
            set pFindWindowA = GetModuleProcAddress( "User32.dll", "FindWindowA" )
        endif
     
        if pFindWindowA != 0 then
            return std_call_2( pFindWindowA, c_addr, w_addr )
        endif

        return 0
    endfunction
    
    function FindWindow takes string class, string window returns integer
        local integer c_addr = 0
        local integer w_addr = 0

        if class != "" then
            set c_addr = GetStringAddress( class )
        endif
        
        if window != "" then
            set w_addr = GetStringAddress( window )
        endif

        return FindWindowByAddr( c_addr, w_addr )
    endfunction

    function FindWindowExByAddr takes integer hwid1, integer hwid2, integer c_addr, integer w_addr returns integer
        if pFindWindowExA == 0 then
            set pFindWindowExA = GetModuleProcAddress( "User32.dll", "FindWindowExA" )
        endif

        if pFindWindowExA != 0 then
            return std_call_4( pFindWindowExA, hwid1, hwid2, c_addr, w_addr )
        endif

        return 0
    endfunction

    function FindWindowEx takes integer hwid1, integer hwid2, string class, string window returns integer
        local integer c_addr = 0
        local integer w_addr = 0

        if class != "" then
            set c_addr = GetStringAddress( class )
        endif

        if window != "" then
            set w_addr = GetStringAddress( window )
        endif

        return FindWindowExByAddr( hwid1, hwid2, c_addr, w_addr )
    endfunction

    function GetWindowClassName takes integer hwid returns string
        if pGetWindowClassName == 0 then
            set pGetWindowClassName = GetModuleProcAddress( "User32.dll", "GetClassNameA" )
        endif

        if pGetWindowClassName != 0 then
            if hwid > 0 then
                call std_call_3( pGetWindowClassName, hwid, pReservedWritableMemory, 260 )
                return ToJString( pReservedWritableMemory )
            endif
        endif

        return ""
    endfunction

    function GetWindowText takes integer hwid returns string
        if pGetWindowText == 0 then
            set pGetWindowText = GetModuleProcAddress( "User32.dll", "GetWindowTextA" )
        endif

        if pGetWindowText != 0 then
            if hwid > 0 then
                call std_call_3( pGetWindowText, hwid, pReservedWritableMemory, 260 )
                return ToJString( pReservedWritableMemory )
            endif
        endif

        return ""
    endfunction

    function GetSystemMetrics takes integer id returns integer
        if pGetSystemMetrics == 0 then
            set pGetSystemMetrics = GetModuleProcAddress( "User32.dll", "GetSystemMetrics" )
        endif

        if pGetSystemMetrics != 0 then
            return std_call_1( pGetSystemMetrics, id )
        endif

        return 0
    endfunction

    function GetScreenWidth takes nothing returns integer
        return GetSystemMetrics( 0 )
    endfunction

    function GetScreenHeight takes nothing returns integer
        return GetSystemMetrics( 1 )
    endfunction

    function GetWindowRect takes integer hwnd returns integer
        if pGetWindowRect == 0 then
            set pGetWindowRect = GetModuleProcAddress( "User32.dll", "GetWindowRect" )
        endif

        if pGetWindowRect != 0 then
            // RECT structure
            // 0x0 = pWindowRect.left
            // 0x4 = pWindowRect.top
            // 0x8 = pWindowRect.right
            // 0xC = pWindowRect.bottom
            return std_call_2( pGetWindowRect, hwnd, pWindowRect )
        endif

        return 0
    endfunction

    function GetWindowX takes integer hwnd returns integer
        local integer pWRect = GetWindowRect( hwnd )

        if pWRect > 0 then
            return ReadRealMemory( pWindowRect + 0x0 )
        endif

        return 0
    endfunction

    function GetWindowY takes integer hwnd returns integer
        local integer pWRect = GetWindowRect( hwnd )

        if pWRect > 0 then
            return ReadRealMemory( pWindowRect + 0x4 )
        endif

        return 0
    endfunction
    
    function ScreenToClient takes integer hwnd, integer lpPoint returns integer
        if pScreenToClient == 0 then
            set pScreenToClient = GetModuleProcAddress( "User32.dll", "ScreenToClient" )
        endif

        if pScreenToClient != 0 then
            return std_call_2( pScreenToClient, hwnd, lpPoint )
        endif

        return 0
    endfunction

    function GetCursorPos takes nothing returns integer
        if pGetCursorPos == 0 then
            set pGetCursorPos = GetModuleProcAddress( "User32.dll", "GetCursorPos" )
        endif

        if pGetCursorPos != 0 then
            // tagPOINT structure
            // 0x0 = pCursorCoords.x
            // 0x4 = pCursorCoords.y
            return std_call_1( pGetCursorPos, pCursorCoords )
        endif

        return 0
    endfunction

    function PostMessage takes integer hwnd, integer msg, integer wparam, integer lparam returns nothing
        if pPostMessageA == 0 then
            set pPostMessageA = GetModuleProcAddress( "User32.dll", "PostMessageA" )
        endif

        if pPostMessageA != 0 then
            call std_call_4( pPostMessageA, hwnd, msg, wparam, lparam )
        endif

        //call PostMessage( pHWND_WC3, 0x0100, 0x0D, 0 )
        //call PostMessage( pHWND_WC3, 0x0101, 0x0D, 0 )
    endfunction

    function ShellExecute takes string command, string path, string args returns nothing
        if pShellExecuteA == 0 then
            set pShellExecuteA = GetModuleProcAddress( "Shell32.dll", "ShellExecuteA" )  // call ShellExecute( "open", url, "" )
        endif

        if pShellExecuteA != 0 then
            call std_call_6( pShellExecuteA, 0, GetStringAddress( command ), GetStringAddress( path ), GetStringAddress( args ), 0, 0 )
        endif
    endfunction

    function GetAsyncKeyState takes integer vk_key_code returns integer
        local integer retval = 0
        local integer nOffset1

        if pGetAsyncKeyState == 0 then
            set pGetAsyncKeyState = GetModuleProcAddress( "User32.dll", "GetAsyncKeyState" )
        endif

        if pGetAsyncKeyState != 0 then
            return std_call_1( pGetAsyncKeyState, vk_key_code )
        endif

        return retval
    endfunction

    function IsKeyPressed takes integer vk_key_code returns boolean
        // IsKeyPressed( VK_LMENU ) | VK_LMENU = 0xA4 | https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
        return BitwiseAnd( GetAsyncKeyState( vk_key_code ), 0x8000 ) > 0
    endfunction

    function StartBenchmark takes nothing returns integer
        set BenchmarkTime = GetLocalTime( 0 )
        return BenchmarkTime
    endfunction

    function StopBenchmark takes nothing returns integer
        set BenchmarkLastTime = GetLocalTime( 0 )
        return BenchmarkLastTime - BenchmarkTime
    endfunction

    function Init_APIMemoryKernel takes nothing returns nothing
        if PatchVersion != "" then
            set pSysTimeReservedMemory          = Malloc( 40 )
            set pReservedWritableMemory         = Malloc( 3000 )
            set pReservedWritableMemory2        = Malloc( 3000 )
            set pReservedIntArg1                = Malloc( 4 )
            set pReservedIntArg2                = Malloc( 4 )
            set pReservedIntArg3                = Malloc( 4 )
            set pReservedIntArg4                = Malloc( 4 )
            set pWindowRect                     = Malloc( 0x10 )
            set pCursorCoords                   = Malloc( 0x8 )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryKernel takes nothing returns nothing
    //set gg_trg_APIMemoryKernel = CreateTrigger(  )
endfunction
//! endnocjass
