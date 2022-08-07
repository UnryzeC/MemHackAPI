//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIBasicUtils
    globals
        boolean IsPrint = false
        constant string sLetters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    endglobals

    function absI takes integer number returns integer
        if number < 0 then
            return -number
        endif

        return number
    endfunction

    function absF takes real r returns real
        if r < 0. then
            return -r
        endif

        return r
    endfunction

    function floorF takes real r returns real
        if r < 0. then
            return -I2R( R2I( -r ) )
        endif
        
        return I2R( R2I( r ) )
    endfunction

    function floorI takes integer i returns integer
        return R2I( floorF( I2R( i ) ) )
    endfunction

    function ceilF takes real r returns real
        if floorF( r ) == r then
            return r
        elseif r < 0. then
            return -( I2R( R2I( -r ) ) + 1. )
        endif
        
        return I2R( R2I( r ) ) + 1.
    endfunction

    function ceilI takes integer i returns integer
        return R2I( ceilF( I2R( i ) ) )
    endfunction

    function roundF takes real r returns real
        if r > 0. then
            return I2R( R2I( r + .5 ) )
        endif
        
        return I2R( R2I( r - .5 ) )
    endfunction

    function roundI takes integer i returns integer
        return R2I( roundF( I2R( i ) ) )
    endfunction

    function log takes integer number, integer base returns integer
        local integer id = 1

        if number > 0 then
            loop
                exitwhen number / base <= 1
                set id = id + 1
                set number = number / base
            endloop

            return id
        endif

        return 0
    endfunction

    function PowI takes integer x, integer power returns integer
        local integer y = x

        if power == 0 then
            set x = 1
    elseif power > 1 then
            loop
                set power = power - 1
                exitwhen power == 0
                set x = x * y
            endloop
        endif

        return x
    endfunction

    function B2S takes boolean flag returns string
        if flag then
            return "yes"
        endif
        
        return "no"
    endfunction

    function CharToId takes string input returns integer
        local integer pos = 0
        local string char

        loop
            set char = SubString( sLetters, pos, pos + 1 )
            exitwhen char == null or char == input
            set pos = pos + 1
        endloop

        if pos < 10 then
            return pos + 48
        elseif pos < 36 then
            return pos + 65 - 10
        endif

        return pos + 97 - 36
    endfunction

    function StringToId takes string input returns integer
        return ( ( CharToId( SubString( input, 0, 1 ) ) * 256 + CharToId( SubString( input, 1, 2 ) ) ) * 256 + CharToId( SubString( input, 2, 3 ) ) ) * 256 + CharToId( SubString( input, 3, 4 ) )
    endfunction

    function IdToChar takes integer input returns string
        local integer pos = input - 48

        if input >= 97 then
            set pos = input - 97 + 36
        elseif input >= 65 then
            set pos = input - 65 + 10
        endif

        return SubString( sLetters, pos, pos + 1 )
    endfunction

    function IdToString takes integer input returns string
        local integer result = input / 256
        local string char    = IdToChar( input - 256 * result )

        set input  = result / 256
        set char   = IdToChar( result - 256 * input ) + char
        set result = input / 256

        return IdToChar( result ) + IdToChar( input - 256 * result ) + char
    endfunction

    function GetIntHex takes integer i returns string
        local string result = ""
        local integer numb  = absI( i )

        if numb >= 0 and numb <= 15 then
            if numb <= 9 then
                set result = I2S( numb )
            elseif numb == 10 then
                set result = "A"
            elseif numb == 11 then
                set result = "B"
            elseif numb == 12 then
                set result = "C"
            elseif numb == 13 then
                set result = "D"
            elseif numb == 14 then
                set result = "E"
            elseif numb == 15 then
                set result = "F"
            endif
        endif

        return result
    endfunction

    function IntToHex takes integer i returns string
        local string result = ""
        local boolean ispos = i >= 0
        local integer numb  = absI( i )
        local integer j     = 0

        if numb != 0 then
            loop
                exitwhen numb == 0
                set j = numb - ( numb / 16 ) * 16
                set result = GetIntHex( j ) + result
                set numb = ( numb - j ) / 16
            endloop

            set result = "0x" + result

            if not ispos then
                set result = "-" + result
            endif
        else
            set result = "0x00"
        endif

        return result
    endfunction

    function PrintData takes string path, string s, boolean flag returns nothing
        if not IsPrint then
            call PreloadGenClear( )
            call PreloadGenStart( )
            set IsPrint = true
        endif

        if IsPrint then
            call Preload( s )

            if flag then
                call PreloadGenEnd( path )
                set IsPrint = false
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIBasicUtils takes nothing returns nothing
    //set gg_trg_APIBasicUtils = CreateTrigger(  )
endfunction
//! endnocjass
