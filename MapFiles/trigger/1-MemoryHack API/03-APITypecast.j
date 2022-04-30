//TESH.scrollpos=240
//TESH.alwaysfold=0
//! nocjass
library APIAllTypecast
    globals
        code Code               // This is not used, it's here just to fool Jasshelper
        code l__Code
        integer Int             // This is not used, it's here just to fool Jasshelper
        integer l__Int
        string Str              // This is not used, it's here just to fool Jasshelper
        string l__Str
        boolean Bool            // This is not used, it's here just to fool Jasshelper
        boolean l__Bool
        handle Handle           // This is not used, it's here just to fool Jasshelper
        handle l__Handle
        unit Unit               // This is not used, it's here just to fool Jasshelper
        unit l__Unit
        ability Abil            // This is not used, it's here just to fool Jasshelper
        ability l__Abil
        trigger Trig            // This is not used, it's here just to fool Jasshelper
        trigger l__Trig
        integer Array           // This is not used, it's here just to fool Jasshelper
        integer array l__Array
        integer ArrayA          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayA
        integer ArrayB          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayB
        integer ArrayC          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayC
        integer ArrayD          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayD
        integer ArrayE          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayE
        integer bytecode        // This is not used, it's here just to fool Jasshelper
        integer array l__bytecode
        integer pbytecode

        hashtable MemHackTable = InitHashtable( )
    endglobals

    //# +nosemanticerror
    function InitBytecode takes integer id, integer k returns nothing
        set l__bytecode[  0 ] = 0x0C010900  // op: 0C(LITERAL), type: 09(integer array), reg: 01,
        set l__bytecode[  1 ] = k           // value: 0x2114D008
        set l__bytecode[  2 ] = 0x11010000  // op: 11(SETVAR), reg: 01
        set l__bytecode[  3 ] = id          // id of variable l__Memory
        set l__bytecode[  4 ] = 0x0C010400  // op: 0C(LITERAL), type: 04(integer), reg: 01, value: 0
        set l__bytecode[  6 ] = 0x27000000  // op: 27(RETURN)
        set l__bytecode[  8 ] = 0x07090000  // op: 07(GLOBAL), type: 09 (integer array) //Create new array
        set l__bytecode[  9 ] = 0x005E      // name: 5E("i") | old: C5F("stand")
        set l__bytecode[ 10 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 //Obtain the desired amount of bytes
        set l__bytecode[ 11 ] = id + 0x1    // id of variable bytecodedata (variable ids are sequential)
        set l__bytecode[ 12 ] = 0x12010100  // op: 12(SETARRAY), index=reg01, value=reg01 //Set index of the array, forcing allocation of memory
        set l__bytecode[ 13 ] = 0x005E      // name: 5E("i")
        set l__bytecode[ 14 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 //Read array variable as an integer
        set l__bytecode[ 15 ] = 0x005E      // name: 5E("i")
        set l__bytecode[ 16 ] = 0x11010000  // op: 11(SETVAR), reg: 01 //pass the value to the jass world
        set l__bytecode[ 17 ] = id + 0x1    // id of variable bytecodedata
        set l__bytecode[ 18 ] = 0x27000000  // op: 27(RETURN)
    endfunction
    //# +nosemanticerror
    function Typecast takes nothing returns nothing
        local integer bytecode // Jasshelper will implicitly rename this to l__bytecode
    endfunction
    //# +nosemanticerror
    function GetBytecodeAddress takes nothing returns integer
        loop
            return l__bytecode
        endloop
        
        return 0
    endfunction
    //# +nosemanticerror
    function InitArray takes integer vtable returns nothing
        set l__Array[ 4 ] = 0
        set l__Array[ 1 ] = vtable
        set l__Array[ 2 ] = -1
        set l__Array[ 3 ] = -1
    endfunction
    //# +nosemanticerror
    function InitArrayA takes integer index, integer valueA returns nothing
        set l__ArrayA[ 1000 ]        = 0
        set l__ArrayA[ index + 3 ] = valueA
        set l__ArrayA[ index + 2 ] = valueA
        set l__ArrayA[ index + 1 ] = valueA
        set l__ArrayA[ index     ] = valueA
        set l__ArrayA[ index - 1 ] = valueA
        set l__ArrayA[ index - 2 ] = valueA
        set l__ArrayA[ index - 3 ] = valueA
    endfunction

    //# +nosemanticerror
    function InitArrayB takes integer index, integer valueB returns nothing
        set l__ArrayB[ 1000 ]  = 0
        set l__ArrayB[ index ] = valueB
    endfunction

    //# +nosemanticerror
    function WriteArrayBMemory takes integer addr, integer value returns nothing
        local integer ii    = addr
        set l__ArrayB[ ii ] = value
    endfunction

    //# +nosemanticerror
    function InitArrayC takes integer valueC returns nothing
        set l__ArrayC[ 4 ] = 0
        set l__ArrayC[ 3 ] = valueC
        set l__ArrayC[ 2 ] = valueC
        set l__ArrayC[ 1 ] = valueC
        set l__ArrayC[ 0 ] = valueC
    endfunction

    //# +nosemanticerror
    function InitArrayD takes integer index, integer valueD returns nothing
        set l__ArrayD[ 1001 ]  = 0
        set l__ArrayD[ index ] = valueD
    endfunction

    //# +nosemanticerror
    function InitArrayE takes integer valueE returns nothing
        set l__ArrayE[ 4 ] = 0
        set l__ArrayE[ 3 ] = valueE
        set l__ArrayE[ 2 ] = valueE
        set l__ArrayE[ 1 ] = valueE
        set l__ArrayE[ 0 ] = valueE
    endfunction

    //# +nosemanticerror
    function TypecastArray takes nothing returns nothing //typecast Array to integer
        local integer Array // Jasshelper will implicitly rename this to l__Array
    endfunction

    //# +nosemanticerror
    function GetArrayAddress takes nothing returns integer
        loop
            return l__Array 
        endloop
        
        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayA takes nothing returns nothing
        local integer ArrayA // Jasshelper will implicitly rename this to l__ArrayA
    endfunction

    //# +nosemanticerror
    function GetArrayAAddress takes nothing returns integer
        loop
            return l__ArrayA
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayB takes nothing returns nothing
        local integer ArrayB // Jasshelper will implicitly rename this to l__ArrayB
    endfunction

    //# +nosemanticerror
    function GetArrayBAddress takes nothing returns integer
        loop
             return l__ArrayB
        endloop
        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayC takes nothing returns nothing
        local integer ArrayC // Jasshelper will implicitly rename this to l__ArrayC
    endfunction 

    //# +nosemanticerror
    function GetArrayCAddress takes nothing returns integer
        loop
            return l__ArrayC
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayD takes nothing returns nothing
        local integer ArrayD // Jasshelper will implicitly rename this to l__ArrayD
    endfunction 

    //# +nosemanticerror
    function GetArrayDAddress takes nothing returns integer
        loop
            return l__ArrayD
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayE takes nothing returns nothing
        local integer ArrayE // Jasshelper will implicitly rename this to l__ArrayE
    endfunction 

    //# +nosemanticerror
    function GetArrayEAddress takes nothing returns integer
        loop
            return l__ArrayE
        endloop

        return 0
    endfunction
    
    //# +nosemanticerror
    function setCode takes code c returns nothing
        set l__Code = c

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setInt takes integer i returns nothing
        set l__Int = i

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setStr takes string s returns nothing
        set l__Str = s

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setBool takes boolean b returns nothing
        set l__Bool = b

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setHandle takes handle h returns nothing
        set l__Handle = h

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setUnit takes unit u returns nothing
        set l__Unit = u

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setAbility takes ability a returns nothing
        set l__Abil = a

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setTrig takes trigger t returns nothing
        set l__Trig = t

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function Typecast1 takes nothing returns nothing
        local integer Code // Jasshelper will implicitly rename this to l__Code
        local code Int     // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function C2I takes code c returns integer
        call setCode( c )
        
        loop
            return l__Code
        endloop
        
        return 0
    endfunction
    //# +nosemanticerror
    function I2C takes integer i returns code
        call setInt( i )

        loop 
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast2 takes nothing returns nothing
        local integer Str   // Jasshelper will implicitly rename this to l__Str
        local string Int    // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function SH2I takes string s returns integer
        call setStr( s )

        loop
            return l__Str
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2SH takes integer i returns string
        call setInt( i )

        loop 
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast3 takes nothing returns nothing
        local integer Bool // Jasshelper will implicitly rename this to l__Bool
        local boolean Int  // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function B2I takes boolean b returns integer
        call setBool( b )

        loop 
            return l__Bool
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2B takes integer i returns boolean
        call setInt( i )

        loop
            return l__Int
        endloop

        return false
    endfunction
    //# +nosemanticerror
    function Typecast4 takes nothing returns nothing
        local integer Handle    // Jasshelper will implicitly rename this to l__Handle
        local handle Int        // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function H2I takes handle h returns integer
        call setHandle( h )

        loop  
            return l__Handle
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2H takes integer i returns handle
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast5 takes nothing returns nothing
        local integer Unit  // Jasshelper will implicitly rename this to l__Unit
        local unit Int      // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function U2I takes unit u returns integer
        call setUnit( u )

        loop  
            return l__Unit
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2U takes integer i returns unit
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast6 takes nothing returns nothing
        local integer Abil  // Jasshelper will implicitly rename this to l__Abil
        local ability Int   // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function A2I takes ability a returns integer
        call setAbility( a )

        loop  
            return l__Abil
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2A takes integer i returns ability
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast7 takes nothing returns nothing
        local integer Trig // Jasshelper will implicitly rename this to l__Trig
        local trigger Int  // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function T2I takes trigger t returns integer
        call setTrig( t )

        loop  
            return l__Trig
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2T takes integer i returns trigger
        call setInt( i )

        return l__Int
    endfunction
    //# +nosemanticerror
    function RealToIndex takes real r returns integer
        loop
            return r
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function CleanInt takes integer i returns integer
        return i
    endfunction
    //# +nosemanticerror
    function IndexToReal takes integer i returns real
        loop
            return i
        endloop

        return 0.
    endfunction
    //# +nosemanticerror
    function CleanReal takes real r returns real
        return r
    endfunction
    //# +nosemanticerror
    function GetRealFromMemory takes integer i returns real
        return CleanReal( IndexToReal( i ) )
    endfunction
    //# +nosemanticerror
    function SetRealIntoMemory takes real r returns integer
        return CleanInt( RealToIndex( r ) )
    endfunction
    //# +nosemanticerror
    function BitwiseNot takes integer i returns integer
        return 0xFFFFFFFF - i
    endfunction
    
    function Init_APITypecast takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APITypecast takes nothing returns nothing
    //set gg_trg_APITypecast = CreateTrigger(  )
endfunction
//! endnocjass
