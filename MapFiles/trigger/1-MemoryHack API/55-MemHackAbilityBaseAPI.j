//TESH.scrollpos=837
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityBaseAPI
    globals
        integer pGetAbilityBaseData = 0
        integer pGetAbilityBaseUI   = 0
    endglobals

    // Base Ability Data/UI Data by Id API
    function GetAbilityBaseDataById takes integer aid returns integer
        if aid > 0 then
           return this_call_1( pGetAbilityBaseData, aid )
        endif

        return 0
    endfunction

    function GetAbilityBaseDataByIdCaching takes integer aid returns integer
        // DEF_ADR_ABILITY_DATA = 0
        local integer pAbil = 0

        if HaveSavedInteger( htObjectDataPointers, 0, aid ) then 
            return LoadInteger( htObjectDataPointers, 0, aid )
        endif

        set pAbil = GetAbilityBaseDataById( aid )
        if pAbil > 0 then
            call SaveInteger( htObjectDataPointers, 0, aid, pAbil )
        endif

        return pAbil
    endfunction

    function GetAbilityBaseUIById takes integer aid returns integer
        if aid > 0 then
            return this_call_1( pGetAbilityBaseUI, aid )
        endif

        return 0
    endfunction

    function GetAbilityBaseUIByIdCaching takes integer aid returns integer
        // DEF_ADR_ABILITY_UI = 1
        local integer pAbil = 0

        if HaveSavedInteger( htObjectDataPointers, 1, aid ) then
            return LoadInteger( htObjectDataPointers, 1, aid )
        endif

        set pAbil = GetAbilityBaseUIById( aid )
        if pAbil > 0 then
            call SaveInteger( htObjectDataPointers, 1, aid, pAbil )
        endif

        return pAbil
    endfunction

    function GetAbilityBaseMaxLevelById takes integer aid returns integer
        local integer pAbil

        if aid > 0 then
            set pAbil = GetAbilityBaseDataByIdCaching( aid )

            if pAbil > 0 then
                return ReadRealMemory( pAbil + 0x50 )
            endif
        endif

        return 0
    endfunction
    //===========================================

    // Base Ability Parameters API
    function SetAbilityBaseHotkeyParam takes integer aid, integer off, integer newVal returns nothing
        local integer pAbil = GetAbilityBaseUIByIdCaching( aid )

        if pAbil > 0 then
            call WriteRealMemory( ReadRealMemory( pAbil + off ), newVal )
        endif
    endfunction

    function GetAbilityBaseHotkeyParam takes integer aid, integer off returns integer
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ReadRealMemory( pData )
            endif
        endif

        return 0
    endfunction

    function SetAbilityBaseIntegerParam takes integer aid, integer off, integer newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, newVal )
        endif
    endfunction

    function GetAbilityBaseIntegerParam takes integer aid, integer off returns integer
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return ReadRealMemory( pData + off )
        endif

        return 0
    endfunction

    function SetAbilityBaseRealParam takes integer aid, integer off, real newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, SetRealIntoMemory( newVal ) )
        endif
    endfunction

    function GetAbilityBaseRealParam takes integer aid, integer off returns real
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + off ) )
        endif

        return 0.
    endfunction

    function SetAbilityBaseBoolParam takes integer aid, integer off, boolean flag returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, B2I( flag ) )
        endif
    endfunction

    function GetAbilityBaseBoolParam takes integer aid, integer off returns boolean
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return ReadRealMemory( pData + off ) > 0
        endif

        return false
    endfunction

    function GetAbilityBasePStringParam takes integer aid, integer off returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ToJString( ReadRealMemory( pData ) )
            endif
        endif

        return null
    endfunction

    function SetAbilityBasePStringParam takes integer aid, integer off, string newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                call WriteRealMemory( pData, GetStringAddress( newVal ) )
            endif
        endif
    endfunction
    
    function GetAbilityBaseStringParam takes integer aid, integer off returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )
        
        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ToJString( pData )
            endif
        endif

        return null
    endfunction

    function SetAbilityBaseStringParam takes integer aid, integer off, string newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, GetStringAddress( newVal ) )
        endif
    endfunction

    function GetAbilityBaseStringParam2 takes integer aid, integer off, integer level returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )
            set level = level - 1

            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                if pData > 0 then
                    set pData = ReadRealMemory( pData + level * 0x4 )
                    if pData > 0 then
                        return ToJString( pData )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetAbilityBaseStringParam2 takes integer aid, integer off, string newVal, integer level returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = pData + off
            set level = level - 1

            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                if ReadRealMemory( pData ) > 0 then
                    set pData = ReadRealMemory( pData + level * 0x4 )
                    if pData > 0 then
                        call WriteRealMemory( pData, GetStringAddress( newVal ) )
                    endif
                endif
            endif
        endif
    endfunction
    //===========================================
    
    // Ability Base Data API by Id
    function GetAbilityBaseManaCostById takes integer aid, integer level returns integer
        local integer pAbil = GetAbilityBaseDataByIdCaching( aid )

        if pAbil > 0 then
            set level = level - 1
            
            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                set pAbil = ReadRealMemory( pAbil + 0x54 )

                if pAbil > 0 then
                    return ReadRealMemory( pAbil - 0x58 + level * 0x68 )
                endif
            endif
        endif

        return 0
    endfunction

    function SetAbilityBaseManaCostById takes integer aid, integer level, integer cost returns nothing
        local integer pAbil = GetAbilityBaseDataByIdCaching( aid )

        if pAbil > 0 then
            set level = level - 1
            
            if level >= 0 and level <= GetAbilityBaseMaxLevelById( aid ) then
                set pAbil = ReadRealMemory( pAbil + 0x54 )

                if pAbil > 0 then
                    call WriteRealMemory( pAbil - 0x58 + level * 0x68, cost )
                endif
            endif
        endif
    endfunction

    function GetAbilityBaseCooldownById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDataByIdCaching( aid ) // GetObjectDataCaching( pAbilityData, aid )

        if pAbil > 0 then
            set level = level - 1
            
            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                set pAbil = ReadRealMemory( pAbil + 0x54 )

                if pAbil > 0 then
                    return GetRealFromMemory( ReadRealMemory( pAbil - 0x54 + level * 0x68 ) )
                endif
            endif
        endif

        return 0.
    endfunction

    function SetAbilityBaseCooldownById takes integer aid, integer level, real cool returns nothing
        local integer pAbil = GetAbilityBaseDataByIdCaching( aid )

        if pAbil > 0 then
            set level = level - 1
            
            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                set pAbil = ReadRealMemory( pAbil + 0x54 )

                if pAbil > 0 then
                    call WriteRealMemory( pAbil - 0x54 + level * 0x68, SetRealIntoMemory( cool ) )
                endif
            endif
        endif
    endfunction

    function GetAbilityBaseEffectSoundById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x30 )
    endfunction
    
    function SetAbilityBaseEffectSoundById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x30, s )
    endfunction

    function GetAbilityBaseEffectSoundLoopedById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x34 )
    endfunction
    
    function SetAbilityBaseEffectSoundLoopedById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x34, s )
    endfunction

    function GetAbilityBaseMissingIconById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x38 )
    endfunction
    
    function SetAbilityBaseMissingIconById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x38, s )
    endfunction

    function GetAbilityBaseCurrentIconById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x3C )
    endfunction
    
    function SetAbilityBaseCurrentIconById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x3C, s )
    endfunction

    function GetAbilityBaseCursorTextureById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x44 )
    endfunction
    
    function SetAbilityBaseCursorTextureById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x44, s )
    endfunction

    function GetAbilityBaseGlobalMessageById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x48 )
    endfunction

    function SetAbilityBaseGlobalMessageById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x48, s )
    endfunction
    
    function GetAbilityBaseGlobalSoundById takes integer aid returns string
        return GetAbilityBaseStringParam( aid, 0x4C )
    endfunction
    
    function SetAbilityBaseGlobalSoundById takes integer aid, string s returns nothing
        call SetAbilityBaseStringParam( aid, 0x4C, s )
    endfunction
    
    function GetAbilityBaseButtonXById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x50 )
    endfunction
    
    function SetAbilityBaseButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x50, newX )
    endfunction
    
    function GetAbilityBaseButtonYById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x54 )
    endfunction
    
    function SetAbilityBaseButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x54, newY )
    endfunction
    
    function GetAbilityBaseUnButtonXById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x58 )
    endfunction
    
    function SetAbilityBaseUnButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x58, newX )
    endfunction
    
    function GetAbilityBaseUnButtonYById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x5C )
    endfunction
    
    function SetAbilityBaseUnButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x5C, newY )
    endfunction
    
    function GetAbilityBaseResearchButtonXById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x60 )
    endfunction
    
    function SetAbilityBaseResearchButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x60, newX )
    endfunction
    
    function GetAbilityBaseResearchButtonYById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x64 )
    endfunction
    
    function SetAbilityBaseResearchButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x64, newY )
    endfunction
    
    function GetAbilityBaseMissileSpeedById takes integer aid returns real
        return GetAbilityBaseRealParam( aid, 0x68 )
    endfunction
    
    function SetAbilityBaseMissileSpeedById takes integer aid, real speed returns nothing
        call SetAbilityBaseRealParam( aid, 0x68, speed )
    endfunction
    
    function GetAbilityBaseMissileArcById takes integer aid returns real
        return GetAbilityBaseRealParam( aid, 0x6C )
    endfunction
    
    function SetAbilityBaseMissileArcById takes integer aid, real arc returns nothing
        call SetAbilityBaseRealParam( aid, 0x6C, arc )
    endfunction
    
    function IsAbilityMissileHomingById takes integer aid returns boolean
        return GetAbilityBaseBoolParam( aid, 0x70 )
    endfunction
    
    function SetAbilityBaseMissileHomingById takes integer aid, boolean homing returns nothing
        call SetAbilityBaseBoolParam( aid, 0x70, homing )
    endfunction
    
    function GetAbilityBaseSpellDetailsById takes integer aid returns integer
        return GetAbilityBaseIntegerParam( aid, 0x74 )
    endfunction
    
    function SetAbilityBaseSpellDetailsById takes integer aid, integer det returns nothing
        call SetAbilityBaseIntegerParam( aid, 0x74, det )
    endfunction
    
    function GetAbilityBaseHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x84 )
    endfunction
    
    function SetAbilityBaseHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x84, newVal )
    endfunction
    
    function GetAbilityBaseUnHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x90 )
    endfunction
    
    function SetAbilityBaseUnHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x90, newVal )
    endfunction
    
    function GetAbilityBaseResearchHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x9C )
    endfunction
    
    function SetAbilityBaseResearchHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x9C, newVal )
    endfunction

    // New
    function GetAbilityBaseNameById takes integer aid returns string
        return GetAbilityBasePStringParam( aid, 0xA8 )
    endfunction
    
    function SetAbilityBaseNameById takes integer aid, string s returns nothing
        call SetAbilityBasePStringParam( aid, 0xA8, s )
    endfunction

    function GetAbilityBaseIconById takes integer aid returns string
        return GetAbilityBasePStringParam( aid, 0xB4 )
    endfunction
    
    function SetAbilityBaseIconById takes integer aid, string s returns nothing
        call SetAbilityBasePStringParam( aid, 0xB4, s )
    endfunction

    function GetAbilityBaseMissleArtById takes integer aid returns string
        return GetAbilityBasePStringParam( aid, 0xF0 )
    endfunction
    
    function SetAbilityBaseMissleArtById takes integer aid, string s returns nothing
        call SetAbilityBasePStringParam( aid, 0xF0, s )
    endfunction

    function GetAbilityBaseResearchTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x12C, lvl )
    endfunction
    
    function SetAbilityBaseResearchTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseStringParam2( aid, 0x12C, s, lvl )
    endfunction
    //

    function GetAbilityBaseTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x138, lvl )
    endfunction
    
    function SetAbilityBaseTipById takes integer aid, integer lvl, string s returns nothing
        call SetAbilityBaseStringParam2( aid, 0x138, s, lvl )
    endfunction
    
    function GetAbilityBaseUnTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x144, lvl )
    endfunction
    
    function SetAbilityBaseUnTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseStringParam2( aid, 0x144, s, lvl )
    endfunction
    
    function GetAbilityBaseResearchUberTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x150, lvl )
    endfunction
    
    function SetAbilityBaseResearchUberTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseStringParam2( aid, 0x150, s, lvl )
    endfunction
    
    function GetAbilityBaseUbertipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x15C, lvl )
    endfunction
    
    function SetAbilityBaseUbertipById takes integer aid, integer lvl, string s returns nothing
        call SetAbilityBaseStringParam2( aid, 0x15C, s, lvl )
    endfunction

    function GetAbilityBaseResearchUnUberTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseStringParam2( aid, 0x168, lvl )
    endfunction

    function SetAbilityBaseResearchUnUberTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseStringParam2( aid, 0x168, s, lvl )
    endfunction

    function SetAbilityBaseHotkeyCommonById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyIdById( aid, newVal )
        call SetAbilityBaseUnHotkeyIdById( aid, newVal )
        call SetAbilityBaseResearchHotkeyIdById( aid, newVal )
    endfunction
    //===========================================
    
    // Base Ability Data/UI Data API
    function GetAbilityTypeId takes ability abil returns integer
        local integer pAbil = ConvertHandle( abil )

        if pAbil > 0 then
            return GetAddressAbilityTypeId( pAbil )
        endif

        return 0
    endfunction

    function GetAbilityBaseId takes ability a returns integer
        return GetAddressAbilityBaseId( ConvertHandle( a ) )
    endfunction
    
    function GetAbilityBaseData takes ability abil returns integer
        return GetAbilityBaseDataById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseDataCaching takes ability abil returns integer
        return GetAbilityBaseDataByIdCaching( GetAbilityBaseDataById( GetAbilityTypeId( abil ) ) )
    endfunction

    function GetAbilityBaseUI takes ability abil returns integer
        return GetAbilityBaseUIById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseUICaching takes ability abil returns integer
        return GetAbilityBaseUIByIdCaching( GetAbilityTypeId( abil ) )
    endfunction
    //===========================================
    
    // Base Ability Data/UI Data API
    function GetAbilityBaseMaxLevel takes ability abil returns integer
        return GetAbilityBaseMaxLevelById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseManaCost takes ability abil, integer level returns integer
        return GetAbilityBaseManaCostById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseManaCost takes ability abil, integer level, integer cost returns nothing
        call SetAbilityBaseManaCostById( GetAbilityTypeId( abil ), level, cost )
    endfunction

    function GetAbilityBaseCooldown takes ability abil, integer level returns real
        return GetAbilityBaseCooldownById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseCooldown takes ability abil, integer level, real cool returns nothing
        call SetAbilityBaseCooldownById( GetAbilityTypeId( abil ), level, cool )
    endfunction

    function GetAbilityBaseEffectSound takes ability abil returns string
        return GetAbilityBaseEffectSoundById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseEffectSound takes ability abil, string s returns nothing
        call SetAbilityBaseEffectSoundById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseEffectSoundLooped takes ability abil returns string
        return GetAbilityBaseEffectSoundLoopedById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseEffectSoundLooped takes ability abil, string s returns nothing
        call SetAbilityBaseEffectSoundLoopedById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseMissingIcon takes ability abil returns string
        return GetAbilityBaseMissingIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissingIcon takes ability abil, string s returns nothing
        call SetAbilityBaseMissingIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseCurrentIcon takes ability abil returns string
        return GetAbilityBaseCurrentIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseCurrentIcon takes ability abil, string s returns nothing
        call SetAbilityBaseCurrentIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseCursorTexture takes ability abil returns string
        return GetAbilityBaseCursorTextureById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseCursorTexture takes ability abil, string s returns nothing
        call SetAbilityBaseCursorTextureById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseGlobalMessage takes ability abil returns string
        return GetAbilityBaseGlobalMessageById( GetAbilityTypeId( abil ) )
    endfunction

    function SetAbilityBaseGlobalMessage takes ability abil, string s returns nothing
        call SetAbilityBaseGlobalMessageById( GetAbilityTypeId( abil ), s )
    endfunction
    
    function GetAbilityBaseGlobalSound takes ability abil returns string
        return GetAbilityBaseGlobalSoundById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseGlobalSound takes ability abil, string s returns nothing
        call SetAbilityBaseGlobalSoundById( GetAbilityTypeId( abil ), s )
    endfunction
    
    function GetAbilityBaseButtonX takes ability abil returns integer
        return GetAbilityBaseButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseButtonY takes ability abil returns integer
        return GetAbilityBaseButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseUnButtonX takes ability abil returns integer
        return GetAbilityBaseUnButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseUnButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseUnButtonY takes ability abil returns integer
        return GetAbilityBaseUnButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseUnButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseResearchButtonX takes ability abil returns integer
        return GetAbilityBaseResearchButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseResearchButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseResearchButtonY takes ability abil returns integer
        return GetAbilityBaseResearchButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseResearchButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseMissileSpeed takes ability abil returns real
        return GetAbilityBaseMissileSpeedById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileSpeed takes ability abil, real speed returns nothing
        call SetAbilityBaseMissileSpeedById( GetAbilityTypeId( abil ), speed )
    endfunction
    
    function GetAbilityBaseMissileArc takes ability abil returns real
        return GetAbilityBaseMissileArcById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileArc takes ability abil, real arc returns nothing
        call SetAbilityBaseMissileArcById( GetAbilityTypeId( abil ), arc )
    endfunction
    
    function IsAbilityMissileHoming takes ability abil returns boolean
        return IsAbilityMissileHomingById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileHoming takes ability abil, boolean homing returns nothing
        call SetAbilityBaseMissileHomingById( GetAbilityTypeId( abil ), homing )
    endfunction
    
    function GetAbilityBaseSpellDetails takes ability abil returns integer
        return GetAbilityBaseSpellDetailsById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseSpellDetails takes ability abil, integer det returns nothing
        call SetAbilityBaseSpellDetailsById( GetAbilityTypeId( abil ), det )
    endfunction
    
    function GetAbilityBaseHotkeyId takes ability abil returns integer
        return GetAbilityBaseHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction
    
    function GetAbilityBaseUnHotkeyId takes ability abil returns integer
        return GetAbilityBaseUnHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseUnHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction
    
    function GetAbilityBaseResearchHotkeyId takes ability abil returns integer
        return GetAbilityBaseResearchHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseResearchHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction

    function GetAbilityBaseName takes ability abil returns string
        return GetAbilityBaseNameById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseName takes ability abil, string s returns nothing
        call SetAbilityBaseNameById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseIcon takes ability abil returns string
        return GetAbilityBaseIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseIcon takes ability abil, string s returns nothing
        call SetAbilityBaseIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseMissleArt takes ability abil returns string
        return GetAbilityBaseMissleArtById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissleArt takes ability abil, string s returns nothing
        call SetAbilityBaseMissleArtById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseResearchTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseResearchTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction

    function GetAbilityBaseTip takes ability abil, integer lvl returns string
        return GetAbilityBaseTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseTip takes ability abil, integer lvl, string s returns nothing
        call SetAbilityBaseTipById( GetAbilityTypeId( abil ), lvl, s )
    endfunction
    
    function GetAbilityBaseUnTip takes ability abil, integer lvl returns string
        return GetAbilityBaseUnTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseUnTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseUnTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction
    
    function GetAbilityBaseResearchUberTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchUberTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseResearchUberTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchUberTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction
    
    function GetAbilityBaseUbertip takes ability abil, integer lvl returns string
        return GetAbilityBaseUbertipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseUbertip takes ability abil, integer lvl, string s returns nothing
        call SetAbilityBaseUbertipById( GetAbilityTypeId( abil ), lvl, s )
    endfunction

    function GetAbilityBaseResearchUnUberTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchUnUberTipById( GetAbilityTypeId( abil ), lvl )
    endfunction

    function SetAbilityBaseResearchUnUberTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchUnUberTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction

    function SetAbilityBaseHotkeyCommon takes ability abil, integer newVal returns nothing
        call SetAbilityBaseHotkeyCommonById( GetAbilityTypeId( abil ), newVal )
    endfunction
    //===========================================
    
    function Init_MemHackAbilityBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGetAbilityBaseData = pGameDLL + 0x2669E0
                set pGetAbilityBaseUI   = pGameDLL + 0x32D420
        elseif PatchVersion == "1.26a" then
                set pGetAbilityBaseData = pGameDLL + 0x265ED0
                set pGetAbilityBaseUI   = pGameDLL + 0x32C8E0
        elseif PatchVersion == "1.27a" then
                set pGetAbilityBaseData = pGameDLL + 0x68EDF0 // sub_6F... above v5 = *(_DWORD *)(v4[21] + 104 * a3 + 24); | HeroAbilityLevelSkip first func
                set pGetAbilityBaseUI   = pGameDLL + 0x322C30 // result = *(_DWORD *)(result + 64); | 852147, (int)v2, a2, 134217732 in !v3
        elseif PatchVersion == "1.27b" then
                set pGetAbilityBaseData = pGameDLL + 0x6AC530
                set pGetAbilityBaseUI   = pGameDLL + 0x416BE0
        elseif PatchVersion == "1.28f" then
                set pGetAbilityBaseData = pGameDLL + 0x6E06E0
                set pGetAbilityBaseUI   = pGameDLL + 0x44ACC0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackAbilityBaseAPI takes nothing returns nothing
    //set gg_trg_MemHackAbilityBaseAPI = CreateTrigger(  )
endfunction
//! endnocjass
