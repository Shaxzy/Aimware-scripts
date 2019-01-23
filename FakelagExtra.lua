local SetValue = gui.SetValue;
local GetValue = gui.GetValue;

local MSC_FAKELAG_REF = gui.Reference( "MISC", "ENHANCEMENT", "Fakelag" );

local FAKELAG_EXTRA_TEXT = gui.Text( MSC_FAKELAG_REF, "Fakelag Extra" );
local FAKELAG_EXTRA = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_extra_enable", "Enable", 0 );
local FAKELAG_ON_SLOWWALK = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_slowwalk", "Disable On Slow Walk", 0 );
local FAKELAG_ON_KNIFE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_knife", "Disable On Knife", 0 );
local FAKELAG_ON_TASER = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_taser", "Disable On Taser", 0 );
local FAKELAG_ON_GRENADE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_grenade", "Disable On Grenade", 0 );
local FAKELAG_ON_PISTOL = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_pistol", "Disable On Pistol", 0 );
local FAKELAG_ON_REVOLVER = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_revolver", "Disable On R8/Deagle", 0 );
local FAKELAG_ON_PING = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_ping", "Disable Fakelag On Ping", 0 )
local FAKELAG_ON_PING_AMOUNT = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_ping_amount", "Amount", 120, 0, 1000 )

local FAKELAG_SMART_MODE_TEXT = gui.Text( MSC_FAKELAG_REF, "Fakelag Smart Mode" )
local FAKELAG_SMART_MODE = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_smartmode_enable", "Enable", 0 );
local FAKELAG_SMART_MODE_FACTOR = gui.Checkbox( MSC_FAKELAG_REF, "lua_fakelag_smartfactor", "Smart Mode Factor", 0 );
local FAKELAG_SMART_MODE_STANDING = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_standing", "While Standing", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_STANDING_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_standing_factor", "Factor", 15, 1, 15 );
local FAKELAG_SMART_MODE_MOVING = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_moving", "While Moving", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_MOVING_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_moving_factor", "Factor", 15, 1, 15 );
local FAKELAG_SMART_MODE_INAIR = gui.Combobox( MSC_FAKELAG_REF, "lua_fakelag_inair", "While In Air", "Off", "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" );
local FAKELAG_SMART_MODE_INAIR_FACTOR = gui.Slider( MSC_FAKELAG_REF, "lua_fakelag_inair_factor", "Factor", 15, 1, 15 );

local Ping = 0

local function FakelagExtra( Event )

	if FAKELAG_EXTRA:GetValue() then

		if ( Event:GetName() ~= "item_equip" ) then
			return;
		end

		local ME = client.GetLocalPlayerIndex();
		local INT_UID = Event:GetInt( "userid" );
		local PlayerIndex = client.GetPlayerIndexByUserID( INT_UID );

		local WepType = Event:GetInt( "weptype" );
		local ITEM = Event:GetString( "item" );

		if ME == PlayerIndex then
			if WepType == 0 then
				Knife = true
			else
				Knife = false
			end
			if WepType == 1 then
				Pistol = true
			else
				Pistol = false
			end
			if WepType == 8 then
				Taser = true
			else
				Taser = false
			end
			if WepType == 9 then
				Grenade = true
			else
				Grenade = false
			end
			if ITEM == "deagle" then
				Revolver = true
			else
				Revolver = false
			end
		end
		
		if ( FAKELAG_ON_KNIFE:GetValue() and Knife ) or -- On Knife
		   ( FAKELAG_ON_TASER:GetValue() and Taser ) or -- On Taser
		   ( FAKELAG_ON_GRENADE:GetValue() and Grenade ) or -- On Grenade
		   ( FAKELAG_ON_PISTOL:GetValue() and Pistol ) or -- On Pistol
		   ( FAKELAG_ON_REVOLVER:GetValue() and Revolver ) then -- On Revolver
			SetValue( "msc_fakelag_enable", 0 );
		else
			SetValue( "msc_fakelag_enable", 1 );
		end
		
	end

end

local function FakelagOnPing()

	if FAKELAG_EXTRA:GetValue() then
		if FAKELAG_ON_PING:GetValue() then

			if entities.GetPlayerResources() ~= nil then
				Ping = entities.GetPlayerResources():GetPropInt( "m_iPing", client.GetLocalPlayerIndex() );
			end
			FakelagOnPingAmount = math.floor( FAKELAG_ON_PING_AMOUNT:GetValue() )

			if ( Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end

		end
	end

end		

local function FakelagOnSlowWalk()

	if FAKELAG_EXTRA:GetValue() then

		if GetValue( "msc_slowwalk" ) ~= 0 then
			SlowWalkFakelagOff = input.IsButtonDown( GetValue( "msc_slowwalk" ) )
		end

		if FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 then
			if ( SlowWalkFakelagOff ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
		end

	end

end

local function FakelagSmartMode()

	if FAKELAG_SMART_MODE:GetValue() then

		local FAKELAG_STANDING = FAKELAG_SMART_MODE_STANDING:GetValue();
		local FAKELAG_MOVING = FAKELAG_SMART_MODE_MOVING:GetValue();
		local FAKELAG_INAIR = FAKELAG_SMART_MODE_INAIR:GetValue();

		local FAKELAG_STANDING_FACTOR = math.floor( FAKELAG_SMART_MODE_STANDING_FACTOR:GetValue() )
		local FAKELAG_MOVING_FACTOR = math.floor( FAKELAG_SMART_MODE_MOVING_FACTOR:GetValue() )
		local FAKELAG_INAIR_FACTOR = math.floor( FAKELAG_SMART_MODE_INAIR_FACTOR:GetValue() )

		if entities.GetLocalPlayer() ~= nil then

			local LocalPlayerEntity = entities.GetLocalPlayer();
			local fFlags = LocalPlayerEntity:GetProp( "m_fFlags" );

			local VelocityX = LocalPlayerEntity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
			local VelocityY = LocalPlayerEntity:GetPropFloat( "localdata", "m_vecVelocity[1]" );

			local Velocity = math.sqrt( VelocityX^2 + VelocityY^2 );

			-- Standing
			if ( Velocity == 0 and ( fFlags == 257 or fFlags == 261 or fFlags == 263 ) ) then
				Standing = true
			else
				Standing = false
			end

			-- Moving
			if ( Velocity > 0 and ( fFlags == 257 or fFlags == 261 or fFlags == 263 ) ) then
				Moving = true
			else
				Moving = false
			end

			-- In Air
			if fFlags == 256 or fFlags == 262 then
				InAir = true
			else
				InAir = false
			end
		end

		if Standing then
			if ( FAKELAG_STANDING == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_STANDING == 1 then
				STANDING_MODE = 0
			elseif FAKELAG_STANDING == 2 then
				STANDING_MODE = 1
			elseif FAKELAG_STANDING == 3 then
				STANDING_MODE = 2
			elseif FAKELAG_STANDING == 4 then
				STANDING_MODE = 3
			elseif FAKELAG_STANDING == 5 then
				STANDING_MODE = 4
			elseif FAKELAG_STANDING == 6 then
				STANDING_MODE = 5
			end
			SetValue( "msc_fakelag_mode", STANDING_MODE );
		end

		if Moving then
			if ( FAKELAG_MOVING == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_MOVING == 1 then
				MOVING_MODE = 0
			elseif FAKELAG_MOVING == 2 then
				MOVING_MODE = 1
			elseif FAKELAG_MOVING == 3 then
				MOVING_MODE = 2
			elseif FAKELAG_MOVING == 4 then
				MOVING_MODE = 3
			elseif FAKELAG_MOVING == 5 then
				MOVING_MODE = 4
			elseif FAKELAG_MOVING == 6 then
				MOVING_MODE = 5
			end
			SetValue( "msc_fakelag_mode", MOVING_MODE );
		end

		if InAir then
			if ( FAKELAG_INAIR == 0 ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_KNIFE:GetValue() and Knife ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_TASER:GetValue() and Taser ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_GRENADE:GetValue() and Grenade ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PISTOL:GetValue() and Pistol ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_REVOLVER:GetValue() and Revolver ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_PING:GetValue() and Ping >= FakelagOnPingAmount ) or
			   ( FAKELAG_EXTRA:GetValue() and FAKELAG_ON_SLOWWALK:GetValue() and GetValue( "msc_slowwalk" ) ~= 0 and SlowWalkFakelagOff ) then
				SetValue( "msc_fakelag_enable", 0 );
			else
				SetValue( "msc_fakelag_enable", 1 );
			end
			if FAKELAG_INAIR == 1 then
				INAIR_MODE = 0
			elseif FAKELAG_INAIR == 2 then
				INAIR_MODE = 1
			elseif FAKELAG_INAIR == 3 then
				INAIR_MODE = 2
			elseif FAKELAG_INAIR == 4 then
				INAIR_MODE = 3
			elseif FAKELAG_INAIR == 5 then
				INAIR_MODE = 4
			elseif FAKELAG_INAIR == 6 then
				INAIR_MODE = 6
			end
			SetValue( "msc_fakelag_mode", INAIR_MODE );
		end

		if FAKELAG_SMART_MODE_FACTOR:GetValue() then
			if Standing then
				SetValue( "msc_fakelag_value", FAKELAG_STANDING_FACTOR );
			end

			if Moving then
				SetValue( "msc_fakelag_value", FAKELAG_MOVING_FACTOR );
			end

			if InAir then
				SetValue( "msc_fakelag_value", FAKELAG_INAIR_FACTOR );
			end
		end

	end

end

client.AllowListener( "item_equip" )

callbacks.Register( "FireGameEvent", "Extra Fakelag Options", FakelagExtra )
callbacks.Register( "Draw", "Fakelag On Ping", FakelagOnPing )
callbacks.Register( "Draw", "Fakelag On Slow Walk", FakelagOnSlowWalk )
callbacks.Register( "Draw", "Fakelag Smart Mode", FakelagSmartMode )
