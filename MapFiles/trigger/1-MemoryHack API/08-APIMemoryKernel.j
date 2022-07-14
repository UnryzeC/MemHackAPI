//TESH.scrollpos=364
//TESH.alwaysfold=0
//! nocjass
library APIMemoryKernel
    function IsBadReadPtr takes integer pointer, integer size returns boolean
        local integer addr = GetFuncFromDll( "Kernel32.dll", "IsBadReadPtr", true )

        if addr != 0 then
            return std_call_2( addr, pointer, size ) == 0
        endif

        return false
    endfunction
    
    // 0 - milisecond | 1 - Sec | 2 - Minutes | 3 - Hours | 4 - Day | 5 - Day of Week | 6 - Month | 7 - Year
    function GetLocalTime takes integer timeId returns integer
        local integer addr   = GetFuncFromDll( "Kernel32.dll", "GetLocalTime", true )
        local integer mem    = 0
        local integer pOff   = 0
        local integer memval = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "SysTimeMem" ) )
            
            if mem != 0 then
                call std_call_1( addr, mem )

                if timeId >= 0 and timeId <= 7 then
                    set memval = ReadRealMemory( mem + ( 0xE - timeId * 2 ) )

                    if memval > 0 then
                        return CreateInteger1( 0, 0, GetByteFromInteger( memval, 3 ), GetByteFromInteger( memval, 4 ) )
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function GetCurrentProcessId takes nothing returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetCurrentProcessId", true )

        if addr != 0 then
            return c_call_1( addr, 0 )
        endif

        return 0
    endfunction
    
    function CreateDirectory takes string directorypath, integer securityAttributes returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CreateDirectoryA", true )
        
        if addr != 0 then
            return std_call_2( addr, GetStringAddress( directorypath ), securityAttributes )
        endif
        
        return 0
    endfunction

    function CreateFile takes string filename, integer accessType, integer shareMode, integer securityAttributes, integer creationDisposition, integer flags, integer templateFile returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CreateFileA", true )

        if addr != 0 then
            // explanations here: https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
            return std_call_7( addr, GetStringAddress( filename ), accessType, shareMode, securityAttributes, creationDisposition, flags, templateFile )
        endif

        return 0
    endfunction
    
    function CreateFileSimple takes string filename returns integer
        return CreateFile( filename, 0xC0000000, 0x00000002, 0, 0x1, 0x80, 0 )
    endfunction
    
    function CloseHandle takes integer hHandle returns nothing
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CloseHandle", true )

        if addr != 0 and hHandle != 0 then
            // explanations here: https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
            call std_call_1( addr, hHandle )
        endif
    endfunction

    function ReadStringFromFile takes string sfile, string ssection, string skey, string sdefval returns string
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetPrivateProfileStringA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )
        local integer size = LoadInteger( MemHackTable, StringHash( "StringArraySize" ), 0 )

        if addr != 0 and mem != 0 and size != 0 then
            call std_call_6( addr, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sdefval ), mem, size, GetStringAddress( sfile ) )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function WriteStringToFile takes string sfile, string ssection, string skey, string sval returns nothing
        local integer addr = GetFuncFromDll( "Kernel32.dll", "WritePrivateProfileStringA", true )

        if addr != 0 then 
            call std_call_4( addr, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sval ), GetStringAddress( sfile ) )
        endif
    endfunction

    function GetFileAttributes takes string s returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetFileAttributesA", true )

        if addr != 0 then
            return std_call_1( addr, GetStringAddress( s ) )
        endif
     
        return 0
    endfunction

    function LoadLibrary takes string nDllName returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "LoadLibraryA", true )

        if addr != 0 then
            return std_call_1( addr, GetStringAddress( nDllName ) )
        endif

        return 0
    endfunction

    // Window API
    function MessageBox takes string message, string caption returns nothing
        local integer addr = GetFuncFromDll( "User32.dll", "MessageBoxA", true )

        if addr != 0 then
            call std_call_4( addr, 0, GetStringAddress( message ), GetStringAddress( caption ), 0 )
        endif
    endfunction

    function FindWindowByAddr takes integer c_addr, integer w_addr returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "FindWindowA", true )

        if addr != 0 then
            return std_call_2( addr, c_addr, w_addr )
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
        local integer addr = GetFuncFromDll( "User32.dll", "FindWindowExA", true )

        if addr != 0 then
            return std_call_4( addr, hwid1, hwid2, c_addr, w_addr )
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

    function GetActiveWindow takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetActiveWindow", true )
        
        if addr != 0 then
            return std_call_0( addr )
        endif

        return 0
    endfunction

    function GetForegroundWindow takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetForegroundWindow", true )

        if addr != 0 then
            return std_call_0( addr )
        endif

        return 0
    endfunction

    function GetWindowClassName takes integer hwid returns string
        local integer addr = GetFuncFromDll( "User32.dll", "GetClassNameA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 and mem != 0 and hwid != 0 then
            call std_call_3( addr, hwid, mem, 260 )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function GetWindowText takes integer hwid returns string
        local integer addr = GetFuncFromDll( "User32.dll", "GetWindowTextA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 and mem != 0 and hwid != 0 then
            call std_call_3( addr, hwid, mem, 260 )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function GetSystemMetrics takes integer id returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetSystemMetrics", true )

        if addr != 0 then
            return std_call_1( addr, id )
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
        local integer addr = GetFuncFromDll( "User32.dll", "GetWindowRect", true )
        local integer mem  = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ) )

            if mem != 0 then
                // RECT structure
                // 0x0 = pWindowRect.left
                // 0x4 = pWindowRect.top
                // 0x8 = pWindowRect.right
                // 0xC = pWindowRect.bottom
                return std_call_2( addr, hwnd, mem )
            endif
        endif

        return 0
    endfunction
    
    function GetWindowRectStruct takes integer hwnd returns integer
        local integer pWRect = GetWindowRect( hwnd )

        if pWRect != 0 then
            return LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ) )
        endif

        return 0
    endfunction

    function GetWindowX takes integer hwnd returns integer
        local integer pWRect = GetWindowRectStruct( hwnd )

        if pWRect != 0 then
            return ReadRealMemory( pWRect + 0x0 )
        endif

        return 0
    endfunction

    function GetWindowY takes integer hwnd returns integer
        local integer pWRect = GetWindowRectStruct( hwnd )

        if pWRect > 0 then
            return ReadRealMemory( pWRect + 0x4 )
        endif

        return 0
    endfunction
    
    function ScreenToClient takes integer hwnd, integer lpPoint returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "ScreenToClient", true )

        if addr != 0 then
            return std_call_2( addr, hwnd, lpPoint )
        endif

        return 0
    endfunction

    function PostMessage takes integer hwnd, integer msg, integer wparam, integer lparam returns nothing
        local integer addr = GetFuncFromDll( "User32.dll", "PostMessageA", true )

        if addr != 0 then
            call std_call_4( addr, hwnd, msg, wparam, lparam )
        endif

        //call PostMessage( pHWND_WC3, 0x0100, 0x0D, 0 )
        //call PostMessage( pHWND_WC3, 0x0101, 0x0D, 0 )
    endfunction
    //

    function GetCursorPos takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetCursorPos", true )
        local integer mem  = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ) )

            if mem != 0 then
                // tagPOINT structure
                // 0x0 = pCursorCoords.x
                // 0x4 = pCursorCoords.y
                return std_call_1( addr, mem )
            endif
        endif

        return 0
    endfunction

    function GetCursorPosStruct takes nothing returns integer
        if GetCursorPos( ) != 0 then
            return LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ) )
        endif

        return 0
    endfunction

    function ShellExecute takes string command, string path, string args returns nothing
        local integer addr = GetFuncFromDll( "Shell32.dll", "ShellExecuteA", true )

        if addr != 0 then // call ShellExecute( "open", url, "" )
            call std_call_6( addr, 0, GetStringAddress( command ), GetStringAddress( path ), GetStringAddress( args ), 0, 0 )
        endif
    endfunction

    function GetAsyncKeyState takes integer vk_key_code returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetAsyncKeyState", true )

        if addr != 0 then
            return std_call_1( addr, vk_key_code )
        endif

        return 0
    endfunction

    function IsKeyPressed takes integer vk_key_code returns boolean
        // IsKeyPressed( VK_LMENU ) | VK_LMENU = 0xA4 | https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
        return BitwiseAnd( GetAsyncKeyState( vk_key_code ), 0x8000 ) > 0
    endfunction

    function ClearBenchmark takes nothing returns nothing
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ), 0 )
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "EndTime" ),   0 )
    endfunction

    function StartBenchmark takes nothing returns integer
        local integer time = GetLocalTime( 0 )
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ), time )
        return time
    endfunction

    function StopBenchmark takes nothing returns integer
        local integer startime = LoadInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ) )
        local integer endtime  = GetLocalTime( 0 )
        local integer result   = endtime - startime

        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "EndTime" ), endtime )
        return result
    endfunction

    function Init_APIMemoryKernel takes nothing returns nothing
        if PatchVersion != "" then
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "SysTimeMem" ),     Malloc( 0x28 ) )
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ),  Malloc( 0x10 ) )
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ), Malloc( 0x08 ) )
            call ClearBenchmark( )
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryKernel takes nothing returns nothing
    //set gg_trg_APIMemoryKernel = CreateTrigger(  )
endfunction
//! endnocjass
