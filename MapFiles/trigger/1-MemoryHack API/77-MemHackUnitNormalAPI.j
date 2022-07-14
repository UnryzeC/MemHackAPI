//TESH.scrollpos=461
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUnitNormalAPI
    function CUnitApplyUpgrades takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUnapplyUpgrades takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUpdateInfoBar takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUpdateHeroBar takes integer pUnit, integer unk1 returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, unk1 )
        endif
    endfunction
    
    function CUnitRefreshPortraitOnSelect takes integer pUnit, integer unk1 returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, unk1 )
        endif
    endfunction
    
    function CUnitRefreshInfoBarOnSelect takes integer pUnit returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ) )

        if addr != 0 and pUnit != 0 then
            return this_call_1( addr, pUnit )
        endif

        return 0
    endfunction

    function CUnitAddAbilityEx takes integer pUnit, integer aid, boolean checkduplicate returns nothing
        local boolean flag = false

        if pUnit != 0 and aid != 0 then
            if not ( checkduplicate and GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 ) != 0 ) then
                call CUnitUnapplyUpgrades( pUnit )
                set flag = CUnitAddAbility( pUnit, aid )
                call CUnitApplyUpgrades( pUnit )
                
                if flag then
                    call CUnitUpdateInfoBar( pUnit )
                endif
            endif
        endif
    endfunction

    function CUnitRemoveAbilityEx takes integer pUnit, integer aid, boolean removeduplicates returns nothing
        local integer pAbil = 0
        local boolean flag = false

        if pUnit != 0 and aid != 0 then
            loop
                set pAbil = GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 )

                if pAbil != 0 then
                    set flag = CUnitRemoveAbility( pUnit, pAbil )

                    if not removeduplicates then
                        set pAbil = 0
                    endif
                endif

                exitwhen pAbil == 0
            endloop

            if flag then
                call CUnitUpdateInfoBar( pUnit )
            endif
        endif
    endfunction

    function CUnitMorphToTypeIdEx takes integer pUnit, integer id, integer unk1, integer unk2, integer unk3, integer unk4, integer unk5, integer unk6, integer unk7, integer unk8, integer unk9 returns boolean
        // This function imitates spells like Metamorphosis etc, but without additional leaks.
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ) )

        if addr != 0 and pUnit != 0 then
            if ReadRealMemory( pUnit + 0x30 ) != id then
                return this_call_11( addr, pUnit, id, unk1, unk2, unk3, unk4, unk5, unk6, unk7, unk8, unk9 ) != 0
            endif
        endif

        return false
    endfunction
    
    function CUnitMorphToTypeId takes integer pUnit, integer id returns boolean
        return CUnitMorphToTypeIdEx( pUnit, id, 1282, 0, 0, 2, 2, 1, 0, 0, 0 )
    endfunction
    //===========================================
    
    // jUnit API
    function GetUnitTypeIdReal takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x30 )
        endif

        return 0
    endfunction

    function SetUnitTypeId takes unit u, integer i returns nothing
        // Note: This is simply change for portrait and some cosmetic stuff!
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0x30, i )
        endif
    endfunction

    function MorphUnitToTypeId takes unit u, integer id returns boolean
        return CUnitMorphToTypeId( ConvertHandle( u ), id )
    endfunction
    
    function UpdateHeroBar takes unit u returns nothing
        call CUnitUpdateHeroBar( ConvertHandle( u ), 0 )
    endfunction
    
    function RefreshUnitPortraitOnSelect takes unit u returns nothing
        call CUnitRefreshPortraitOnSelect( ConvertHandle( u ), 1 )
    endfunction

    function RefreshUnitInfoBarOnSelect takes unit u returns nothing
        call CUnitRefreshInfoBarOnSelect( ConvertHandle( u ) )
    endfunction
    
    function MorphUnitToTypeIdEx takes unit u, integer id returns integer
        // This function imitates spells like Metamorphosis etc, but without additional leaks.
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            if ReadRealMemory( pUnit + 0x30 ) != id then
                call CUnitMorphToTypeId( pUnit, id )
                call CUnitUpdateHeroBar( pUnit, 0 )
                call CUnitRefreshPortraitOnSelect( pUnit, 1 )
                return CUnitRefreshInfoBarOnSelect( pUnit )
            endif
        endif

        return 0
    endfunction

    function GetHeroNeededXPForLevel takes unit u, integer level returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            if IsUnitType( u, UNIT_TYPE_HERO ) then
                return this_call_2( addr, pUnit, level )
            endif
        endif

        return 0
    endfunction

    function ApplyUnitUpgrades takes unit u returns nothing
        call CUnitApplyUpgrades( ConvertHandle( u ) )
    endfunction
    
    function UnapplyUnitUpgrades takes unit u returns nothing
        call CUnitUnapplyUpgrades( ConvertHandle( u ) )
    endfunction
    
    function UpdateUnitInfoBar takes unit u returns nothing
        call CUnitUpdateInfoBar( ConvertHandle( u ) )
    endfunction
    
    function AddUnitAbilityEx takes unit u, integer aid, boolean checkduplicate returns nothing
        call CUnitAddAbilityEx( ConvertHandle( u ), aid, checkduplicate )
    endfunction
    
    function RemoveUnitAbilityEx takes unit u, integer aid, boolean removeduplicates returns nothing
        call CUnitRemoveAbilityEx( ConvertHandle( u ), aid, removeduplicates )
    endfunction

    function GetHeroNeededXP takes unit u returns integer
        return GetHeroNeededXPForLevel( u, GetUnitLevel( u ) )
    endfunction

    function GetUnitVertexColour takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x2D4 )
        endif

        return 0
    endfunction

    function GetUnitVertexColourA takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 1 )
    endfunction

    function GetUnitVertexColourR takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 2 )
    endfunction

    function GetUnitVertexColourG takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 3 )
    endfunction

    function GetUnitVertexColourB takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 4 )
    endfunction

    function SetUnitModel takes unit u, string model, boolean flag returns nothing
        call SetObjectModel( ConvertHandle( u ), model, flag )
    endfunction

    function SetUnitTexture takes unit u, string texturepath, integer textureId returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ) )
        local integer pUnit = ConvertHandle( u )
        local integer pTexture = 0

        if addr != 0 and pUnit != 0 then
            if texturepath != "" then
                set pTexture = LoadCBackDropFrameTexture( texturepath, false )

                if pTexture > 0 and textureId > 0 then
                    return fast_call_3( addr, ReadRealMemory( pUnit + 0x28 ), pTexture, textureId )
                endif
            endif
        endif

        return 0
    endfunction
    
    function GetUnitImpactZ takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0x228 )
        endif

        return 0.
    endfunction

    function SetUnitImpactZ takes unit u, real impactZ returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealFloat( pData + 0x228, impactZ )
        endif
    endfunction

    function RedrawUnit takes unit u returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ) )
        local integer pData = ConvertHandle( u )

        if addr != 0 and pData != 0 then
            call this_call_1( addr, pData )
        endif
    endfunction

    function IsAttackDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                return ReadRealMemory( pData + 0x40 ) > 0
            endif
        endif

        return false
    endfunction

    function UnitDisableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 0 )
            endif
        endif
    endfunction
    
    function UnitEnableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 1 )
            endif
        endif
    endfunction

    function GetUnitCritterFlag takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            // 0 - normal | 1 - critter
            return ReadRealMemory( pData + 0x60 )
        endif

        return -1
    endfunction

    function SetUnitCritterFlag takes unit u, integer id returns nothing
        // Acts similar to 'Amec', meaning if unit has flag equal to 1
        // then he is considered a creep and will be ignored by autoattacks.
        // However, an attack may still be forced with 'A' key or rightclick
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if id >= 0 and id <= 1 then
                call WriteRealMemory( pData + 0x60, id )
            endif
        endif
    endfunction
    
    function GetUnitTimedLife takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    return ReadRealFloat( pData + 0x4 )
                endif
            endif
        endif

        return 0.
    endfunction

    function SetUnitTimedLife takes unit u, real dur returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x4, dur )
                endif
            endif
        endif
    endfunction

    function SetUnitPhased takes unit u returns nothing
        // Must be used with a slight delay AFTER cast, the minimum is one frame after successful cast!
        local integer data  = GetUnitBaseDataById( GetUnitTypeId( u ) ) + 0x1AC
        local integer p1    = ReadRealMemory( data )
        local integer p2    = ReadRealMemory( data + 0x4 )

        call WriteRealMemory( data, 0x8 )
        call WriteRealMemory( data + 0x4, 0x10 )
        call SetUnitPathing( u, true )
        call WriteRealMemory( data, p1 )
        call WriteRealMemory( data + 0x4, p2 )
    endfunction

    function UnitApplySilence takes unit u, boolean flag returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, B2I( flag ) )
        endif
    endfunction

    function UnitDisableAbilities takes unit u, boolean flag returns nothing
        // Visually equal to pause: all skills are hidden and silenced
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            call this_call_5( addr, pUnit, 1, B2I( flag ), 0, 0 )
        endif
    endfunction
    
    function UnitSetStunFlag takes unit u, boolean add returns nothing
        local integer addr  = 0
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            if add then
                set addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ) )

                if addr != 0 then
                    call this_call_2( addr, ConvertHandle( u ), ConvertHandle( u ) )
                endif
            else
                set addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ) )

                if addr != 0 then
                    call this_call_1( addr, ConvertHandle( u ) )
                endif
            endif
        endif
    endfunction

    function IsUnitStunned takes unit u returns boolean
        local integer pHandle = ConvertHandle( u )
        
        if pHandle > 0 then
            return ReadRealMemory( pHandle + 0x198 ) > 0
        endif

        return false
    endfunction

    function UnitApplyStun takes unit u returns nothing //unsafe, do not use unless you tested it through
        local integer pHandle = ConvertHandle( u )

        if pHandle > 0 then
            call WriteRealMemory( pHandle + 0x198, 0 )
        endif
    endfunction

    function IsUnitMovementDisabled takes unit u returns boolean
        local integer pdata = GetHandleId( u )

        if pdata > 0 then
            set pdata = ConvertHandle( u )

            if pdata > 0 then
                set pdata = ReadRealMemory( pdata + 0x1EC )

                if pdata > 0 then
                    return ReadRealMemory( pdata + 0x7C ) > 0
                endif
            endif
        endif

        return false
    endfunction

    function SetUnitControl takes unit u, integer flagval, integer moveval, integer atackval, integer invval returns nothing
        local boolean isFlag = false
        local integer pUnit = ConvertHandle( u )
        local integer flags = 0
        local integer Amov  = 0
        local integer Aatk  = 0
        local integer AInv  = 0

        if pUnit > 0 then
            set flags  = ReadRealMemory( pUnit + 0x248 )
            set Aatk   = ReadRealMemory( pUnit + 0x1E8 )
            set Amov   = ReadRealMemory( pUnit + 0x1EC )
            set AInv   = ReadRealMemory( pUnit + 0x1F8 )
            set isFlag = not IsFlagBitSet( flags, absI( flagval ) ) // 512
            
            if flagval < 0 then
                set isFlag = not isFlag
            endif

            if isFlag then
                call WriteRealMemory( pUnit + 0x248, flags + flagval )
            endif
            
            if Amov > 0 then
                call WriteRealMemory( Amov + 0x40, ReadRealMemory( Amov + 0x40 ) + moveval )
            endif

            if Aatk > 0 then
                call WriteRealMemory( Aatk + 0x40, ReadRealMemory( Aatk + 0x40 ) + atackval )
            endif

            if AInv > 0 then
                call WriteRealMemory( AInv + 0x3C, ReadRealMemory( AInv + 0x3C ) + invval )
            endif
        endif
    endfunction

    function UnitDisableControl takes unit u returns nothing
        //Hides all command buttons and sets the Ward flag. Unit will keep its current order, and player can’t give new orders
        //Notice the the unit can’t be ordered with triggers as well. To issue an order you need to temporarily reenable control
        call SetUnitControl( u, 512, 1, 1, 1 )
    endfunction

    function UnitEnableControl takes unit u returns nothing
        //Removes the Ward flag and reenables Amov and Aatk
        call SetUnitControl( u, -512, -1, -1, -1 )
    endfunction

    function UnitRemoveMovementDisables takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( ReadRealMemory( pData + 0x1EC ) + 0x7C, 0 )
            endif
        endif
    endfunction

    function SetUnitMovement takes integer pData, boolean flag returns nothing
        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( pData + 0x7C, B2I( not flag ) ) //  ReadRealMemory( pdata ) + d
            endif
        endif
    endfunction

    function UnitEnableMovement takes unit u returns nothing
        if u == null then
            return
        endif

        call SetUnitMovement( ConvertHandle( u ), false )
    endfunction

    function UnitDisableMovement takes unit u returns nothing
        if u == null then
            return
        endif

        call SetUnitMovement( ConvertHandle( u ), true )
    endfunction

    function UnitDisableMovementEx takes unit u, boolean disable returns nothing
        local integer i = 2
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if not disable then
                set i = 1
            endif

            call PauseUnit( u, true )
            set pData = ReadRealMemory( pData + 0x1EC )
            
            if pData > 0 then
                call SetAddressAbilityDisabled( pData, i ) //pointer to 'Amov' is located at offset 123 of unit object, Aatk is at offset 122, and AInv is offset 124
            endif

            call PauseUnit( u, false )
        endif
    endfunction

    function IsUnitInventoryDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                return I2B( ReadRealMemory( pData + 0x3C ) )
            endif
        endif
    
        return false
    endfunction
    
    function UnitEnableInventory takes unit u, boolean flag returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                set pData = pData + 0x3C
                call WriteRealMemory( pData, B2I( not flag ) )
            endif
        endif
    endfunction

    function GetAddressLocustFlags takes integer pHash1, integer pHash2 returns integer
        local integer pObj = GetCObjectFromHash( pHash1, pHash2 )

        if pObj > 0 then
            return ReadRealMemory( pObj + 0x94 )
        endif

        return 0
    endfunction

    function SetLocustFlags takes unit u, integer i returns nothing //These flags can make unit immune to truesight
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = pData + 0x16C
            set pData = GetAddressLocustFlags( ReadRealMemory( pData ), ReadRealMemory( pData + 4 ) )

            if pData > 0 then
                call WriteRealMemory( pData + 0x34, i )
            endif
        endif
    endfunction

    function UnitEnableTruesightImmunity takes unit u returns nothing
        call SetLocustFlags( u, 0x08000000 ) //I don’t really know what other side effects may be caused by this, at least GroupEnum is not affected
    endfunction

    function UnitDisableTruesightImmunity takes unit u returns nothing
        call SetLocustFlags( u, 0 )
    endfunction

    function GetUnitFlags takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return 0
    endfunction

    function SetUnitFlags takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x20, i )
        endif
    endfunction

    function AddUnitFlags takes unit u, integer i returns nothing
        call SetUnitFlags( u, GetUnitFlags( u ) + i )
    endfunction
    
    function GetUnitFlags_2 takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x5C )
        endif

        return 0
    endfunction

    function SetUnitFlags_2 takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x5C, i )
        endif
    endfunction

    function AddUnitFlags_2 takes unit u, integer i returns nothing
        call SetUnitFlags_2( u, GetUnitFlags_2( u ) + i )
    endfunction

    function GetUnitVisibilityClass takes unit u returns integer
        local integer a = ConvertHandle( u )
        local integer res = 0

        if a > 0 then
            set res = ReadRealMemory( a + 0x130 )

            if res > 0 then
                set res = GetCAgentFromHash( res, ReadRealMemory( a + 0x134 ) )
            endif
        endif

        return res
    endfunction

    function SetUnitVisibleByPlayer takes unit u, player p, integer c returns nothing
        local integer a = GetUnitVisibilityClass( u )

        if a > 0 then
            call WriteRealMemory( a + 0x2C + 4 * GetPlayerId( p ), c )
            if c > 0 and not IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
                call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) + Player2Flag( p ) )
            elseif c==0 and IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
                call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) - Player2Flag( p ) )
            endif
        endif
    endfunction

    function IsUnitInvulnerable takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return IsFlagBitSet( ReadRealMemory( pData + 0x20 ), 8 )
        endif

        return false
    endfunction

    function GetUnitInvulnerableCounter takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE8 )
        endif

        return 0
    endfunction

    function SetUnitInvulnerableCounter takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE8, i )
        endif
    endfunction

    function ModifyInvulnerableCounter takes unit u, integer diff returns nothing
        if u != null then
            call SetUnitInvulnerableCounter( u, GetUnitInvulnerableCounter( u ) + diff )
        endif
    endfunction

    function IsUnitInvulnerable2 takes unit u returns boolean
        return GetUnitInvulnerableCounter( u ) > 0
    endfunction

    function SetUnitFacingEx takes unit u, real facing, boolean isinstant returns nothing
        local integer pObject   = ConvertHandle( u )
        local integer vtable    = 0
        local integer pSmartPos = 0
        local integer pPosPos   = 0
        local integer arg       = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pObject != 0 and arg != 0 then
            set vtable = ReadRealMemory( pObject )

            if vtable != 0 then
                set pSmartPos = this_call_1( ReadRealMemory( vtable + 0xB8 ), pObject )

                if pSmartPos != 0 then
                    set pPosPos = GetCObjectFromHashGroup( pSmartPos + 0x08 )
                    
                    if pPosPos != 0 then
                        set vtable = ReadRealMemory( pPosPos )
                        
                        if vtable != 0 then
                            set facing = Deg2Rad( facing )
                            call WriteRealFloat( arg + 0x0, facing )
                            call this_call_2( ReadRealMemory( vtable + 0x4C ), pPosPos, arg + 0x0 )

                            if isinstant then
                                call this_call_1( ReadRealMemory( vtable + 0x58 ), pPosPos )
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endfunction

    function SetUnitFacingInstantOld takes unit u, real angle returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x28 )

                if pData > 0 then
                    call SetUnitFacing( u, angle )
                    call WriteRealFloat( pData + 0xA4, Deg2Rad( angle ) )
                endif
            endif
        endif
    endfunction

    function GetUnitMoveType takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x16C )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    return ReadRealMemory( pData + 0x9C )
                endif
            endif
        endif

        return 0
    endfunction

    function SetUnitMoveType takes unit u, integer m_type returns nothing
        // foot = 33554434 | fly = 67108868 | amph = -2147483520
        // This method only properly works if unit has FLY movement as default, els.
        // Meaning only a unit with default move type of flying can lose flying pathing and gain it back.
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x16C )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0x9C, m_type )
                endif
            endif
        endif
    endfunction

    function GetHeroPrimaryAttribute takes unit u returns integer //1 = str, 2 = int, 3 = agi
        local integer a = ConvertHandle( u )

        if a > 0 then
            set a = ReadRealMemory( a + 0x1F0 )

            if a > 0 then
                return ReadRealMemory( a + 0xCC )
            endif
        endif

        return 0
    endfunction

    function SetHeroPrimaryAttribute takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if IsUnitIdType( GetUnitTypeId( u ), UNIT_TYPE_HERO ) then
                set pData = ReadRealMemory( pData + 0x1F0 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0xCC, i )
                endif
            endif
        endif
    endfunction

    function GetUnitAttackAbility takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x1E8 )
        endif
        
        return 0
    endfunction

    function SetUnitAttackAbility takes unit u, integer pAddr returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x1E8, pAddr )
        endif
    endfunction
    
    function GetUnitAttackOffsetValue takes unit u, integer pOff returns integer
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            return ReadRealMemory( pData + pOff )
        endif

        return 0
    endfunction

    function GetUnitNextAttackTimestamp takes unit u returns real
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x4 )
            endif
        endif

        return -1.
    endfunction

    function UnitResetAttackCooldown takes unit u returns boolean
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1E4, 0 )
                return true
            endif
        endif

        return false
    endfunction

    function UnitNullifyCurrentAttack takes unit u returns string
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1F4, 0 )
                return "nulled"
            else
                return "already empty"
            endif
        else
            return "cannot attack"
        endif

        return "no attack has been found"
    endfunction

    function AddUnitExtraAttack takes unit u returns boolean
        local integer pData = GetUnitAttackAbility( u )
        local real attackdelay

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                set attackdelay = CleanReal( IndexToReal( ReadRealMemory( pData + 0x8 )  ) )

                if attackdelay > 0 then
                    call WriteRealMemory( pData + 0x4, CleanInt( RealToIndex( GetUnitNextAttackTimestamp( u ) - attackdelay ) ) )
                    return true
                endif
            endif
        endif

        return false
    endfunction

    function GetUnitAttackTypeByIndex takes unit u, integer index returns integer
        if index == 0 or index == 1 then
            return GetUnitAttackOffsetValue( u, 0xF4 + 4 * index )
        endif

        return -1
    endfunction

    function GetUnitAttackType1 takes unit u returns integer
        return GetUnitAttackTypeByIndex( u, 0 )
    endfunction

    function GetUnitAttackType2 takes unit u returns integer
        return GetUnitAttackTypeByIndex( u, 1 )
    endfunction

    function SetUnitAttackOffsetValue takes unit u, integer offset, integer val returns nothing
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            call WriteRealMemory( pData + offset, val )
        endif
    endfunction
    
    function SetUnitAttackTypeByIndex takes unit u, integer i, integer attacknum returns nothing
        //6 = hero, 5 = chaos, 4 = magic, 3 = siege, 2 = piercing, 1 = normal, 0 = spell?
        //values over 6 takes incorrect multipliers from nearby memory, do not use them
        call SetUnitAttackOffsetValue( u, 0xF4 + 4 * attacknum, i )
    endfunction

    function SetUnitAttackType1 takes unit u, integer i returns nothing
        call SetUnitAttackTypeByIndex( u, i, 0 )
    endfunction

    function SetUnitAttackType2 takes unit u, integer i returns nothing
        call SetUnitAttackTypeByIndex( u, i, 1 )
    endfunction

    function GetUnitWeaponSound takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xE8 )
    endfunction

    function SetUnitWeaponSound takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xE8, i )
    endfunction
    
    function GetUnitWeaponType takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xDC )
    endfunction
    
    function SetUnitWeaponType takes unit u, integer i returns nothing
        // unit's weapon type is melee, ranged, splash, artillery, etc -> 0 = melee, 1 = instant, 2 = ranger, 5 = splash, 6 = mbounce | up to 8
        call SetUnitAttackOffsetValue( u, 0xDC, i )
    endfunction

    function GetUnitBaseDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xA0 )
    endfunction

    function SetUnitBaseDamage takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xA0, i )
    endfunction

    function AddUnitBaseDamage takes unit u, integer bonus returns nothing
        call SetUnitBaseDamage( u, GetUnitBaseDamage( u ) + bonus )
    endfunction

    function GetUnitBonusDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xAC )
    endfunction

    function SetUnitBonusDamage takes unit u, integer i returns nothing
        //setting green bonus automatically adjusts base damage to fit
        call SetUnitAttackOffsetValue( u, 0xAC, i )
    endfunction

    function AddUnitBonusDamage takes unit u, integer i returns nothing
        call SetUnitBonusDamage( u, GetUnitBonusDamage( u ) + i )
    endfunction

    function GetUnitTotalDamage takes unit u returns integer
        return GetUnitBaseDamage( u ) + GetUnitBonusDamage( u )
    endfunction

    function GetUnitBaseAttributeDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xA4 )
    endfunction

    function SetUnitBaseAttributeDamage takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xA4, i )
    endfunction

    function GetUnitDamageDicesSideCount takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x94 )
    endfunction

    function SetUnitDamageDicesSideCount takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0x94, i )
    endfunction

    function GetUnitDamageDicesCount takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x88 )
    endfunction
    
    function SetUnitDamageDicesCount takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0x88, i )
    endfunction

    function GetUnitAttackRangeByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x258 + 0x24 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackRangeByIndex takes unit u, integer index, real range returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x258 + 0x24 * index, SetRealIntoMemory( range ) )
        endif
    endfunction
    
    function GetUnitAttackRange1 takes unit u returns real
        return GetUnitAttackRangeByIndex( u, 0 )
    endfunction 

    function SetUnitAttackRange1 takes unit u, real range returns nothing
        call SetUnitAttackRangeByIndex( u, 0, range )
    endfunction

    function GetUnitAttackRange2 takes unit u returns real
        return GetUnitAttackRangeByIndex( u, 1 )
    endfunction

    function SetUnitAttackRange2 takes unit u, real range returns nothing
       call SetUnitAttackRangeByIndex( u, 1, range )
    endfunction

    function GetUnitBATByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x158 + 0x8 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitBATByIndex takes unit u, integer index, real baseas returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x158 + 0x8 * index, SetRealIntoMemory( baseas ) )
        endif
    endfunction

    function GetUnitBAT1 takes unit u returns real
        return GetUnitBATByIndex( u, 0 )
    endfunction

    function SetUnitBAT1 takes unit u, real baseas returns nothing
        call SetUnitBATByIndex( u, 0, baseas )
    endfunction

    function GetUnitBAT2 takes unit u returns real
        return GetUnitBATByIndex( u, 1 )
    endfunction
    
    function SetUnitBAT2 takes unit u, real baseas returns nothing
        call SetUnitBATByIndex( u, 1, baseas )
    endfunction

    function GetUnitAttackPointByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x16C + 0x10 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackPointByIndex takes unit u, integer index, real atckpoint returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x16C + 0x10 * index, SetRealIntoMemory( atckpoint ) )
        endif
    endfunction
    
    function GetUnitAttackPoint1 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 0 )
    endfunction
    
    function SetUnitAttackPoint1 takes unit u, real atckpoint returns nothing
        call SetUnitAttackPointByIndex( u, 0, atckpoint )
    endfunction

    function GetUnitAttackPoint2 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 1 )
    endfunction

    function SetUnitAttackPoint2 takes unit u, real atckpoint returns nothing
        call SetUnitAttackPointByIndex( u, 1, atckpoint )
    endfunction

    function GetUnitAttackEnabledIndex takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x104 )
    endfunction

    function GetUnitAttackBackswing takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x190 ) )
    endfunction 

    function SetUnitAttackBackswing takes unit u, real backswing returns nothing
        call SetUnitAttackOffsetValue( u, 0x190, SetRealIntoMemory( backswing ) )
    endfunction

    function GetUnitAttackSpeed takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x1B0 ) )
    endfunction
    
    function SetUnitAttackSpeed takes unit u, real atckspeed returns nothing
        call SetUnitAttackOffsetValue( u, 0x1B0, SetRealIntoMemory( atckspeed ) )
    endfunction

    function AddUnitAttackSpeed takes unit u, real atckspeed returns nothing
        call SetUnitAttackSpeed( u, GetUnitAttackSpeed( u ) + atckspeed )
    endfunction

    function GetUnitAttackDamage takes unit u returns real
        local integer dmg = GetUnitDamageDicesCount( u )
        local integer spread = GetRandomInt( dmg, dmg * GetUnitDamageDicesSideCount( u ) )

        return I2R( GetUnitBaseDamage( u ) + GetUnitBonusDamage( u ) + spread )
    endfunction
    
    function GetUnitArmourType takes unit u returns integer
        //armor types: 0 - Light; 1 - Medium; 2 - Heavy; 3 - Fortified; 4 - Normal; 5 - Hero; 6 - Divine; 7 - unarmored; | rest seems to have Light properties
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE4 )
        endif

        return 0
    endfunction

    function SetUnitArmourType takes unit u, integer id returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE4, id )
        endif
    endfunction

    function GetUnitArmour takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0xE0 )
        endif
        
        return 0.
    endfunction

    function SetUnitArmour takes unit u, real armour returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealFloat( pData + 0xE0, armour )
        endif
    endfunction

    function AddUnitArmour takes unit u, real value returns nothing
        call SetUnitArmour( u, GetUnitArmour( u ) + value )
    endfunction

    function GetUnitTimeScale takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0x300 )
        endif

        return 0.
    endfunction

    function GetUnitBaseMoveSpeed takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return ReadRealFloat( pData + 0x70 )
            endif
        endif

        return 0.
    endfunction

    function GetUnitBonusMoveSpeed takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return ReadRealFloat( pData + 0x78 )
            endif
        endif

        return -1000. // To ensure we failed to get Bonus MoveSpeed.
    endfunction

    function SetUnitBonusMoveSpeed takes unit u, real bonusms returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                call WriteRealFloat( pData + 0x78, bonusms )
                call SetUnitMoveSpeed( u, ReadRealFloat( pData + 0x70 ) ) //required to update ms instantly
                return true
            endif
        endif

        return false
    endfunction

    function AddUnitBonusMovespeed takes unit u, real bonusms returns nothing
        call SetUnitBonusMoveSpeed( u, GetUnitBonusMoveSpeed( u ) + bonusms )
    endfunction

    function GetUnitCurrentSight takes unit u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x104 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x78 )
            endif
        endif

        return 0.
    endfunction

    function SetUnitCurrentSight takes unit u, real newsight returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x104 )

            if pData > 0 then
                call UnitAddAbility( u, 'AIsi' )
                call UnitRemoveAbility( u, 'AIsi' )
                call WriteRealFloat( pData + 0x78, newsight )
            endif
        endif
    endfunction
    
    function SetUnitMaxLife takes unit u, real newhp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                call WriteRealFloat( pData + 0x84, newhp )
            endif
        endif
    endfunction

    function AddUnitMaxLife takes unit u, real value returns nothing
        call SetUnitMaxLife( u, GetUnitState( u, UNIT_STATE_MAX_LIFE ) + value )
    endfunction

    function SetUnitMaxMana takes unit u, real newmp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xC0 )

            if pData > 0 then
                call WriteRealFloat( pData + 0x84, newmp )
            endif
        endif
    endfunction

    function AddUnitMaxMana takes unit u, real value returns nothing
        call SetUnitMaxMana( u, GetUnitState( u, UNIT_STATE_MAX_MANA ) + value )
    endfunction

    function GetWidgetLifeRegen takes widget u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x7C )
            endif
        endif

        return 0.
    endfunction

    function GetUnitLifeRegen takes unit u returns real
        return GetWidgetLifeRegen( u )
    endfunction

    function SetUnitLifeRegen takes unit u, real regen returns nothing
        local integer pData = ConvertHandle( u )
        local real curhp    = GetWidgetLife( u )

        if pData > 0 then
            if curhp > 0 then
                set pData = GetCObjectFromHashGroup( pData + 0xA0 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x7C, regen )
                    call SetWidgetLife( u, curhp )
                endif
            endif
        endif
    endfunction

    function AddUnitLifeRegen takes unit u, real regen returns nothing
        call SetUnitLifeRegen( u, GetUnitLifeRegen( u ) + regen )
    endfunction

    function GetUnitManaRegen takes unit u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xC0 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x7C )
            endif
        endif

        return 0.
    endfunction

    function SetUnitManaRegen takes unit u, real regen returns nothing
        local integer pData = ConvertHandle( u )
        local real curmp = GetUnitState( u, UNIT_STATE_MANA )

        if pData > 0 then
            if curmp > 0 then
                set pData = GetCObjectFromHashGroup( pData + 0xC0 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x7C, regen )
                    call SetUnitState( u, UNIT_STATE_MANA, curmp )
                endif
            endif
        endif
    endfunction

    function AddUnitManaRegen takes unit u, real regen returns nothing
        call SetUnitManaRegen( u, GetUnitManaRegen( u ) + regen )
    endfunction
    //===========================================

    function Init_MemHackUnitNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0x943A94 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x285350 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x0773A0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x077420 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x270420 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x283650 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x4D3DE0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x208270 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x333370 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x2A2A40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x270970 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x2B3FC0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x2B3FF0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x270930 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x270940 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0x931934 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x284830 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x076770 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x0767F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x2A6440 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x282B30 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x4D32E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x26EB50 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x332830 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x2A1F20 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x26FE50 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x2B34A0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x2B34D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x26FE10 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x26FE20 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xA4A704 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x67FB00 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x471C40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x46F180 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x66B600 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x65AE60 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x186F40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x668050 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x3598C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x653220 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x67FA80 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6AA8E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6AD4E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x676610 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x676600 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xB77EB0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x69D240 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x48F380 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x48C8C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x688D30 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x678590 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x1A4C60 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x685780 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x377060 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x670950 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x69D1C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6C8020 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6CAC20 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x693D40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x693D30 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xB68914 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x6D13F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x4C3490 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x4C09D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x6BCEC0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x6AC6C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x1D74F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x6B9910 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x3AB170 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x6A4A80 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x6D1370 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6FC1D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6FEDD0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x6C7F00 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x6C7EF0 )
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackUnitNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackUnitNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass
