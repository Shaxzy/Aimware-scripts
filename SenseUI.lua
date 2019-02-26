--[[
	SenseUI by Ruppet
	====================================
	SenseUI is Immediate-Mode GUI for Aimware which have "GameSense" cheat style.
]]

-- Anti multiload
if SenseUI ~= nil then
	return
end

local awrefer = gui.Reference("MISC", "General", "Main");
gui.Combobox(awrefer, "senseui_color", "Theme color", "Green", "Blue", "Red", "Purple", "Orange", "Pink");

SenseUI = {};
SenseUI.EnableLogs = false;

SenseUI.Keys = {
	esc = 27, f1 = 112, f2 = 113, f3 = 114, f4 = 115, f5 = 116,
	f6 = 117, f7 = 118, f8 = 119, f9 = 120, f10 = 121, f11 = 122,
	f12 = 123, tilde = 192, one = 49, two = 50, three = 51, four = 52,
	five = 53, six = 54, seven = 55, eight = 56, nine = 57, zero = 48,
	minus = 189, equals = 187, backslash = 220, backspace = 8,
	tab = 9, q = 81, w = 87, e = 69, r = 82, t = 84, y = 89, u = 85,
	i = 73, o = 79, p = 80, bracket_o = 219, bracket_c = 221,
	a = 65, s = 83, d = 68, f = 70, g = 71, h = 72, j = 74, k = 75,
	l = 76, semicolon = 186, quotes = 222, caps = 20, enter = 13,
	shift = 16, z = 90, x = 88, c = 67, v = 86, b = 66, n = 78,
	m = 77, comma = 188, dot = 190, slash = 191, ctrl = 17,
	win = 91, alt = 18, space = 32, scroll = 145, pause = 19,
	insert = 45, home = 36, pageup = 33, pagedn = 34, delete = 46,
	end_key = 35, uparrow = 38, leftarrow = 37, downarrow = 40, 
	rightarrow = 39, num = 144, num_slash = 111, num_mult = 106,
	num_sub = 109, num_7 = 103, num_8 = 104, num_9 = 105, num_plus = 107,
	num_4 = 100, num_5 = 101, num_6 = 102, num_1 = 97, num_2 = 98,
	num_3 = 99, num_enter = 13, num_0 = 96, num_dot = 110, mouse_1 = 1, mouse_2 = 2
};

SenseUI.KeyDetection = {
	always_on = 1,
	on_hotkey = 2,
	toggle = 3,
	off_hotkey = 4
};

SenseUI.Icons = {
	rage = { "C", 6 },
	legit = { "D", 5 },
	visuals = { "E", 4 },
	settings = { "F", 3 },
	skinchanger = { "G", 2 },
	playerlist = { "H", 1 },
	antiaim = { "I", 0 }
};

local gs_windows = {};		-- Contains all windows
local gs_curwindow = "";	-- Current window ID
local gs_curgroup = "";		-- Current group ID
local gs_curtab = "";		-- Current tab
local gs_curinput = "";		-- Current input

local gs_fonts = {
	verdana_12 		= draw.CreateFont( "Verdana", 12, 400 ),
	verdana_12b 	= draw.CreateFont( "Verdana", 12, 700 ),
	verdana_10 		= draw.CreateFont( "Verdana", 10, 400 ),
	astriumtabs		= draw.CreateFont( "Astriumtabs2", 42, 400 )
}

local gs_curchild = {
	id = "",
	x = 0,
	y = 0,
	elements = {},
	selected = {},
	multiselect = false,
	last_id = "",
	minimal_width = 0
};

local gs_isBlocked = false;

local gs_mx = 0;	-- Mouse X
local gs_my = 0;	-- Mouse Y

-- CUSTOM DRAWING --
local render = {};

render.outline = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.OutlinedRect( x, y, x + w, y + h );
end

render.rect = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.FilledRect( x, y, x + w, y + h );
end

render.rect2 = function( x, y, w, h )
	draw.FilledRect( x, y, x + w, y + h );
end

render.gradient = function( x, y, w, h, col1, col2, is_vertical )
	render.rect( x, y, w, h, col1 );

	local r, g, b = col2[1], col2[2], col2[3];

	if is_vertical then
		for i = 1, h do
			local a = i / h * 255;
			render.rect( x, y + i, w, 1, { r, g, b, a } );
		end
	else
		for i = 1, w do
			local a = i / w * 255;
			render.rect( x + i, y, 1, h, { r, g, b, a } );
		end
	end
end

render.text = function( x, y, text, col, font )
	if font ~= nil then
		draw.SetFont( font )
	else
		draw.SetFont( gs_fonts.verdana_12 )
	end

	draw.Color( col[1], col[2], col[3], col[4] );
	draw.Text( x, y, text );
end
-- CUSTOM DRAWING --

-- Needed for some actions
local function gs_clone( orig )
    return { table.unpack( orig ) };
end

-- Check if a and b in bounds
local function gs_inbounds( a, b, mina, minb, maxa, maxb )
	if a >= mina and a <= maxa and b >= minb and b <= maxb then
		return true;
	else
		return false;
	end
end

-- Get size of non-array table
local function gs_tablecount( T )
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- Just checks if logs are enabled
local function gs_log( text )
	if SenseUI.EnableLogs then
		print( text );
	end
end

-- Clamps value
local function gs_clamp( val, min, max )
	if val < min then return min end
	if val > max then return max end

	return val;
end

-- I'm too lazy to do shit what I moved into this func
local function gs_newelement()
	local wnd = gs_windows[gs_curwindow];
	local group = wnd.groups[gs_curgroup];

	return wnd, group;
end

-- Begins window
local function gs_beginwindow( id, x, y, w, h )
	-- Check values
	if id == nil or x < 0 or y < 0 or w < 0 or h < 25 then
		return false;
	end

	-- Check if we already have window with id
	local wnd = gs_windows[id];

	if wnd == nil then
		-- Create window
		wnd = {
			-- Position and size
			x  	= 0,
			y  	= 0,
			w  	= 0,
			h 	= 0,

			-- Needed to work
			is_opened = true,
			alpha = 255,
			dx = 0,
			dy = 0,
			drag = false,
			resize = false,
			dmx = 0,
			dmy = 0,
			tabs = {},
			groups = {},

			-- Settings
			is_movable = false,
			is_sizeable = false,
			open_key = nil,
			draw_texture = false
		};

		wnd.x = x;
		wnd.y = y;
		wnd.w = w;
		wnd.h = h;

		gs_windows[id] = wnd;

		gs_log( "Window " .. id .. " has been created" );
	end

	gs_curwindow = id;

	-- Backend
	if wnd.open_key ~= nil then
		-- Window toggle
		if input.IsButtonPressed( wnd.open_key ) then
			wnd.is_opened = not wnd.is_opened;
			gs_log( "Window " .. id .. " has been toggled" );
		end
	end

	-- Close animation
	local fade_factor = ((1.0 / 0.15) * globals.FrameTime()) * 255; -- Animation takes 150ms to finish. This helps to make it look the same on 200 fps and on 30fps

	if not wnd.is_opened and wnd.alpha ~= 0 then
		wnd.alpha = gs_clamp( wnd.alpha - fade_factor, 0, 255 );
	end

	-- Open animation
	if wnd.is_opened and wnd.alpha ~= 255 then
		wnd.alpha = gs_clamp( wnd.alpha + fade_factor, 0, 255 );
	end

	gs_windows[id] = wnd;

	-- Check if window opened
	if not wnd.is_opened and wnd.alpha == 0 then
		gs_curchild.id = "";
		return false;
	end

	-- Movement
	if wnd.is_movable then
		-- If clicked and in bounds
		if input.IsButtonDown( 1 ) then
			gs_mx, gs_my = input.GetMousePos();

			if wnd.drag then
				wnd.x = gs_mx - wnd.dx;
				wnd.y = gs_my - wnd.dy;
				wnd.x2 = wnd.x + wnd.w;
				wnd.y2 = wnd.y + wnd.h;
			end

			if gs_inbounds( gs_mx, gs_my, wnd.x, wnd.y, wnd.x + wnd.w, wnd.y + 20 ) and wnd.h > 30 then
				wnd.drag = true;
				wnd.dx = gs_mx - wnd.x;
				wnd.dy = gs_my - wnd.y;
			end

			gs_windows[id] = wnd;
		else
			gs_windows[id].drag = false;
		end
	end

	local size_changing = false;

	if wnd.is_sizeable then
		-- If clicked and in bounds
		if input.IsButtonDown( 1 ) then
			gs_mx, gs_my = input.GetMousePos();

			if wnd.resize then
				wnd.w = gs_mx - wnd.dmx;
				wnd.h = gs_my - wnd.dmy;

				if wnd.w < 50 then
					wnd.w = 50;
				end

				if wnd.h < 50 then
					wnd.h = 50;
				end
			end

			if gs_inbounds( gs_mx, gs_my, wnd.x + wnd.w - 5, wnd.y + wnd.h - 5, wnd.x + wnd.w - 1, wnd.y + wnd.h - 1 ) then
				wnd.resize = true;
				size_changing = true;
				wnd.dmx = gs_mx - wnd.w;
				wnd.dmy = gs_my - wnd.h;
			end

			gs_windows[id] = wnd;
		else
			gs_windows[id].resize = false;
		end
	end

	-- Begin draw
	local lmd_outlinehelp = function( off, col )
		render.outline( wnd.x - off, wnd.y - off, wnd.w + off * 2, wnd.h + off * 2, col );
	end

	-- Window base
	render.rect( wnd.x, wnd.y, wnd.w, wnd.h, { 19, 19, 19, wnd.alpha } );

	if wnd.draw_texture then -- This thing is very shitty rn, waiting till polak will add textures into draw.
		draw.Color( 12, 12, 12, wnd.alpha );
		for i = 1, wnd.h, 4 do
			
			local y1 = wnd.y+i;
			local y2 = y1-2;
			
			for j=0, wnd.w, 4 do
				local x1 = wnd.x+j;
				render.rect2( x1 - 2, y1, 1, 3);
				render.rect2( x1 , y2, 1, 3);
			end
		end
	end

	-- Window border
	lmd_outlinehelp( 0, { 31, 31, 31, wnd.alpha } );

	if size_changing then
		lmd_outlinehelp( 1, { 149, 184, 6, wnd.alpha } );
	else
		lmd_outlinehelp( 1, { 60, 60, 60, wnd.alpha } );
	end

	lmd_outlinehelp( 2, { 40, 40, 40, wnd.alpha } );
	lmd_outlinehelp( 3, { 40, 40, 40, wnd.alpha } );
	lmd_outlinehelp( 4, { 40, 40, 40, wnd.alpha } );
	lmd_outlinehelp( 5, { 60, 60, 60, wnd.alpha } );
	lmd_outlinehelp( 6, { 31, 31, 31, wnd.alpha } );

	-- If sizeable, draw litte triangle
	if wnd.is_sizeable then
		if size_changing then
			render.rect( wnd.x + wnd.w - 5, wnd.y + wnd.h - 1, 5, 1, { 149, 184, 6, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 4, wnd.y + wnd.h - 2, 4, 1, { 149, 184, 6, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 3, wnd.y + wnd.h - 3, 3, 1, { 149, 184, 6, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 2, wnd.y + wnd.h - 4, 2, 1, { 149, 184, 6, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 1, wnd.y + wnd.h - 5, 1, 1, { 149, 184, 6, wnd.alpha } );
		else
			render.rect( wnd.x + wnd.w - 5, wnd.y + wnd.h - 1, 5, 1, { 60, 60, 60, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 4, wnd.y + wnd.h - 2, 4, 1, { 60, 60, 60, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 3, wnd.y + wnd.h - 3, 3, 1, { 60, 60, 60, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 2, wnd.y + wnd.h - 4, 2, 1, { 60, 60, 60, wnd.alpha } );
			render.rect( wnd.x + wnd.w - 1, wnd.y + wnd.h - 5, 1, 1, { 60, 60, 60, wnd.alpha } );
		end
	end

	return true;
end

local function gs_addgradient(  )
	local wnd = gs_windows[gs_curwindow];

	render.gradient( wnd.x, wnd.y, wnd.w / 2, 1, { 59, 175, 222, wnd.alpha }, { 202, 70, 205, wnd.alpha }, false );
	render.gradient( wnd.x + ( wnd.w / 2 ), wnd.y, wnd.w / 2, 1, { 202, 70, 205, wnd.alpha }, { 201, 227, 58, wnd.alpha }, false );
end

local function gs_endwindow(  )
	if gs_curchild.id ~= "" then
		gs_mx, gs_my = input.GetMousePos();

		local highest_w = 0;

		draw.SetFont( gs_fonts.verdana_12b );

		for i = 1, #gs_curchild.elements do
			local textw, texth = draw.GetTextSize( gs_curchild.elements[i] );

			if highest_w < textw then
				highest_w = textw;
			end
		end

		if highest_w < gs_curchild.minimal_width then
			highest_w = gs_curchild.minimal_width;
		end

		if input.IsButtonPressed( 1 ) and not gs_inbounds( gs_mx, gs_my, gs_curchild.x, gs_curchild.y - 20, gs_curchild.x + 20 + highest_w, gs_curchild.y + 20 * #gs_curchild.elements + #gs_curchild.elements ) then
			gs_curchild.id = "";
			gs_curchild.minimal_width = 0;
			gs_isBlocked = false;
		end

		render.rect( gs_curchild.x, gs_curchild.y, 20 + highest_w, 20 * #gs_curchild.elements + #gs_curchild.elements, { 36, 36, 36, 255 } );

		local text_offset = 0;

		for i = 1, #gs_curchild.elements do
			local r, g, b = 181, 181, 181;
			local fnt = gs_fonts.verdana_12;

			if gs_inbounds( gs_mx, gs_my, gs_curchild.x, gs_curchild.y + text_offset, gs_curchild.x + 20 + highest_w, gs_curchild.y + text_offset + 20 ) then
				if input.IsButtonPressed( 1 ) then
					if gs_curchild.multiselect then
						if gs_curchild.selected[gs_curchild.elements[i]] == nil then
							gs_curchild.selected[gs_curchild.elements[i]] = true;
						else
							if gs_curchild.selected[gs_curchild.elements[i]] then
								gs_curchild.selected[gs_curchild.elements[i]] = false;
							else
								gs_curchild.selected[gs_curchild.elements[i]] = true;
							end
						end
					else
						gs_curchild.selected = { i };
						gs_curchild.minimal_width = 0;
						gs_curchild.last_id = gs_curchild.id;
						gs_curchild.id = "";
						gs_isBlocked = false;
					end
				end

				render.rect( gs_curchild.x, gs_curchild.y + text_offset, 20 + highest_w, 21, { 28, 28, 28, 255 } );
				fnt = gs_fonts.verdana_12b;
			end
			
			local r12, g12, b12 = 149, 184, 6;
			if gui.GetValue("senseui_color") == 0 then
				r12, g12, b12 = 149, 184, 6;
			elseif gui.GetValue("senseui_color") == 1 then
				r12, g12, b12 = 6, 132, 182;
			elseif gui.GetValue("senseui_color") == 2 then
				r12, g12, b12 = 182, 6, 6;
			elseif gui.GetValue("senseui_color") == 3 then
				r12, g12, b12 = 146, 6, 182;
			elseif gui.GetValue("senseui_color") == 4 then
				r12, g12, b12 = 205, 107, 8;
			elseif gui.GetValue("senseui_color") == 5 then
				r12, g12, b12 = 214, 10, 193;
			end
			
			if not gs_curchild.multiselect then
				for k = 1, #gs_curchild.selected do
					if gs_curchild.selected[k] == i then
						if gui.GetValue("senseui_color") == 0 then
							r, g, b = 149, 184, 6;
						elseif gui.GetValue("senseui_color") == 1 then
							r, g, b = 6, 132, 182;
						elseif gui.GetValue("senseui_color") == 2 then
							r, g, b = 182, 6, 6;
						elseif gui.GetValue("senseui_color") == 3 then
							r, g, b = 146, 6, 182;
						elseif gui.GetValue("senseui_color") == 4 then
							r, g, b = 205, 107, 8;
						elseif gui.GetValue("senseui_color") == 5 then
							r, g, b = 214, 10, 193;
						end
						fnt = gs_fonts.verdana_12b;
					end
				end
			else
				if gs_curchild.selected[gs_curchild.elements[i]] ~= nil and gs_curchild.selected[gs_curchild.elements[i]] == true then
					if gui.GetValue("senseui_color") == 0 then
						r, g, b = 149, 184, 6;
					elseif gui.GetValue("senseui_color") == 1 then
						r, g, b = 6, 132, 182;
					elseif gui.GetValue("senseui_color") == 2 then
						r, g, b = 182, 6, 6;
					elseif gui.GetValue("senseui_color") == 3 then
						r, g, b = 146, 6, 182;
					elseif gui.GetValue("senseui_color") == 4 then
						r, g, b = 205, 107, 8;
					elseif gui.GetValue("senseui_color") == 5 then
						r, g, b = 214, 10, 193;
					end
					fnt = gs_fonts.verdana_12b;
				end
			end

			render.text( gs_curchild.x + 10, gs_curchild.y + text_offset + 4, gs_curchild.elements[i], { r, g, b, 255 }, fnt );

			text_offset = text_offset + 20 + 1;
		end

		render.outline( gs_curchild.x, gs_curchild.y, 20 + highest_w, 20 * #gs_curchild.elements + #gs_curchild.elements, { 5, 5, 5, 255 } );
	end

	gs_curwindow = "";
end

local function gs_setwindowmovable( val )
	if gs_windows[gs_curwindow].is_movable ~= val then
		gs_windows[gs_curwindow].is_movable = val;

		if val then val = "true" else val = "false" end
		gs_log("SetWindowMoveable has been set to " .. val);
	end
end

local function gs_setwindowsizeable( val )
	if gs_windows[gs_curwindow].is_sizeable ~= val then
		gs_windows[gs_curwindow].is_sizeable = val;

		if val then val = "true" else val = "false" end
		gs_log("SetWindowSizeable has been set to " .. val);
	end
end

local function gs_setwindowdrawtexture( val )
	if gs_windows[gs_curwindow].draw_texture ~= val then
		gs_windows[gs_curwindow].draw_texture = val;

		if val then val = "true" else val = "false" end
		gs_log("SetWindowDrawTexture has been set to " .. val);
	end
end

local function gs_setwindowopenkey( val )
	if gs_windows[gs_curwindow].open_key ~= val then
		gs_windows[gs_curwindow].open_key = val;

		local txt = "nil";

		if val ~= nil then
			txt = val;
		end

		gs_log("SetWindowOpenKey has been set to " .. txt);
	end
end

local function gs_begingroup( id, title, x, y, w, h )
	local wnd = gs_windows[gs_curwindow];
	local tab = wnd.tabs[gs_curtab];
	local tx = 0;

	if tab ~= nil then
		tx = 80;
	end

	-- Checks
	if id == nil then return false end

	-- Check if we already have window with id
	local group = wnd.groups[id];

	if group == nil then
		-- Create window
		group = {
			-- Position and size
			x  	= 0,
			y  	= 0,
			w  	= 0,
			h 	= 0,

			-- Other stuff
			title = nil,
			is_moveable = false,
			is_sizeable = false,

			-- Stuff needed to work
			is_nextline = true,
			nextline_offset = 15,
			dx = 0,
			dy = 0,
			drag = false,
			resize = false,
			highest_w = 0,
			highest_h = 0,
			last_y = 20
		};

		group.x = x + tx;
		group.y = y;
		group.w = w;
		group.h = h;

		group.title = title;

		wnd.groups[id] = group;

		gs_log( "Group " .. id .. " has been created" );
	end

	if group.x + wnd.x < wnd.x or group.y + wnd.y < wnd.y or wnd.x + group.x + group.w + 15 > wnd.x + wnd.w or wnd.y + group.y + group.h + 15 > wnd.y + wnd.h then
		return false;
	end

	gs_curgroup = id;

	draw.SetFont( gs_fonts.verdana_12b );
	local textw, texth = draw.GetTextSize( group.title );
	local oldw, oldh = draw.GetTextSize( title );
	local groupaftertext = group.w - 18 - textw - 3;
	local groupaftertext_n = group.w - 18 - oldw - 3;

	local size_changing = false;

	-- Movement
	if not gs_isBlocked then
		if group.is_moveable then
			-- If clicked and in bounds
			if input.IsButtonDown( 1 ) then
				gs_mx, gs_my = input.GetMousePos();

				if group.drag then
					group.x = gs_mx - group.dx;
					group.y = gs_my - group.dy;

					if group.x < 25 then
						group.x = 25;
					end

					if wnd.w < group.x + group.w + 25 then
						group.x = group.x - ((group.x + group.w + 25) - wnd.w);
					end

					if wnd.h < group.y + group.h + 25 then
						group.y = group.y - ((group.y + group.h + 25) - wnd.h);
					end

					if group.y < 25 then
						group.y = 25;
					end
				end

				if gs_inbounds( gs_mx, gs_my, wnd.x + group.x + 15, wnd.y + group.y, wnd.x + group.x + 15 + textw, wnd.y + group.y + texth ) and group.h > 30 then
					group.drag = true;
					size_changing = true;
					group.dx = gs_mx - group.x;
					group.dy = gs_my - group.y;
				end

				wnd.groups[id] = group;
			else
				wnd.groups[id].drag = false;
			end
		end

		if group.is_sizeable then
			-- If clicked and in bounds
			if input.IsButtonDown( 1 ) then
				gs_mx, gs_my = input.GetMousePos();

				if group.resize then
					group.w = gs_mx - group.dmx;
					group.h = gs_my - group.dmy;

					if group.w < 50 then
						group.w = 50;
					end

					if group.w < group.highest_w + 50 then
						group.w = group.highest_w + 50;
					end

					if group.h < 50 then
						group.h = 50;
					end

					if group.h < group.highest_h + 25 then
						group.h = group.highest_h + 25;
					end

					if group.w + group.x + 25 > wnd.w then
						group.w = group.w - ((group.w + group.x + 25) - wnd.w);
					end

					if group.h + group.y + 25 > wnd.h then
						group.h = group.h - ((group.h + group.y + 25) - wnd.h);
					end
				end

				if gs_inbounds( gs_mx, gs_my, wnd.x + group.x + group.w - 5, wnd.y + group.y + group.h - 5, wnd.x + group.x + group.w - 1, wnd.y + group.y + group.h - 1 )  then
					group.resize = true;
					size_changing = true;
					group.dmx = gs_mx - group.w;
					group.dmy = gs_my - group.h;
				end

				wnd.groups[id] = group;
			else
				wnd.groups[id].resize = false;
			end
		end
	end

	wnd.groups[id].highest_h = 0;

	-- Draw
	if groupaftertext_n > 15 then
		group.title = title;
	end

	-- Subtract title if width more than 15
	if groupaftertext < 15 then
		while groupaftertext < 15 do
			group.title = group.title:sub( 1, -2 );

			textw, texth = draw.GetTextSize( group.title );
			groupaftertext = w - 18 - textw - 3;
		end

		group.title = group.title:sub( 1, -5 );
		group.title = group.title .. "...";
	end

	local r, g, b = 65, 65, 65;

	if size_changing then
		r, g, b = 149, 184, 6;
	end

	render.rect( wnd.x + group.x, wnd.y + group.y, group.w, group.h, { 19, 19, 19, wnd.alpha } );

	render.rect( wnd.x + group.x, wnd.y + group.y, 1, group.h, { r, g, b, wnd.alpha } );
	render.rect( wnd.x + group.x - 1, wnd.y + group.y - 1, 1, group.h + 2, { 5, 5, 5, wnd.alpha } );

	render.rect( wnd.x + group.x, wnd.y + group.y + group.h, group.w + 1, 1, { r, g, b, wnd.alpha } );
	render.rect( wnd.x + group.x - 1, wnd.y + group.y + group.h + 1, group.w + 3, 1, { 5, 5, 5, wnd.alpha } );

	render.rect( wnd.x + group.x + group.w, wnd.y + group.y, 1, group.h, { r, g, b, wnd.alpha } );
	render.rect( wnd.x + group.x + group.w + 1, wnd.y + group.y - 1, 1, group.h + 2, { 5, 5, 5, wnd.alpha } );

	if group.title ~= nil and groupaftertext >= 15 then
		render.rect( wnd.x + group.x, wnd.y + group.y, 15, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + 1, wnd.y + group.y - 1, 14, 1, { 5, 5, 5, wnd.alpha } );

		if size_changing then
			render.text( wnd.x + group.x + 18, wnd.y + group.y - 6, group.title, { r, g, b, wnd.alpha }, gs_fonts.verdana_12b );
		else
			render.text( wnd.x + group.x + 18, wnd.y + group.y - 6, group.title, { 181, 181, 181, wnd.alpha }, gs_fonts.verdana_12b );
		end

		render.rect( wnd.x + group.x + 18 + textw + 3, wnd.y + group.y, groupaftertext, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + 18 + textw + 3, wnd.y + group.y - 1, groupaftertext + 1, 1, { 5, 5, 5, wnd.alpha } );
	else
		render.rect( wnd.x + group.x, wnd.y + group.y, group.w, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + 1, wnd.y + group.y - 1, group.w + 1, 1, { 5, 5, 5, wnd.alpha } );
	end

	-- If sizeable, draw litte triangle
	if group.is_sizeable then
		render.rect( wnd.x + group.x + group.w - 5, wnd.y + group.y + group.h - 1, 5, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + group.w - 4, wnd.y + group.y + group.h - 2, 4, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + group.w - 3, wnd.y + group.y + group.h - 3, 3, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + group.w - 2, wnd.y + group.y + group.h - 4, 2, 1, { r, g, b, wnd.alpha } );
		render.rect( wnd.x + group.x + group.w - 1, wnd.y + group.y + group.h - 5, 1, 1, { r, g, b, wnd.alpha } );
	end

	return true;
end

local function gs_endgroup(  )
	local wnd = gs_windows[gs_curwindow];
	local group = wnd.groups[gs_curgroup];

	if group.w + group.x + 25 > wnd.w then
		group.w = gs_clamp( group.w - ((group.w + group.x + 25) - wnd.w), 50, wnd.w - 50 );
	end

	if group.h + group.y + 25 > wnd.h then
		group.h = gs_clamp( group.h - ((group.h + group.y + 25) - wnd.h), 50, wnd.h - 50 );
	end

	if wnd.x + wnd.w < wnd.x + group.x + group.w + 25 then
		group.x = group.x - ((group.x + group.w + 25) - wnd.w);
	end

	if wnd.y + wnd.h < wnd.y + group.y + group.h + 25 then
		group.y = group.y - ((group.y + group.h + 25) - wnd.h);
	end

	if group.x < 25 then
		group.x = 25;
	end

	if group.y < 25 then
		group.y = 25;
	end

	if group.is_sizeable then
		if group.w < group.highest_w + 50 then
			group.w = group.highest_w + 50;
		end

		if group.h < group.highest_h + 25 then
			group.h = group.highest_h + 25;
		end

		if group.h + 15 < group.x + group.nextline_offset then
			group.h = group.nextline_offset + 15;
		end
	end

	wnd.groups[gs_curgroup] = group;

	wnd.groups[gs_curgroup].nextline_offset = 15;
	wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].highest_h + 20;
	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].last_y = 20;

	gs_curgroup = "";
end

local function gs_setgroupmoveable( val )
	local wnd = gs_windows[gs_curwindow];

	if wnd.groups[gs_curgroup].is_moveable ~= val then
		wnd.groups[gs_curgroup].is_moveable = val;

		if val then val = "true" else val = "false" end
		gs_log("SetGroupMoveable has been set to " .. val);
	end
end

local function gs_setgroupsizeable( val )
	local wnd = gs_windows[gs_curwindow];

	if wnd.groups[gs_curgroup].is_sizeable ~= val then
		wnd.groups[gs_curgroup].is_sizeable = val;

		if val then val = "true" else val = "false" end
		gs_log("SetGroupSizeable has been set to " .. val);
	end
end

local function gs_checkbox( title, var , is_alt)
	local wnd, group = gs_newelement();

	local textw, texth = draw.GetTextSize( title );
	local x, y = wnd.x + group.x + 10, wnd.y + group.y + group.nextline_offset;

	-- Backend
	if input.IsButtonPressed( 1 ) and gs_inbounds( gs_mx, gs_my, x, y, x + 15 + textw, y + texth ) and not gs_isBlocked then
		-- Update value
		var = not var;
	end

	-- Draw
	render.outline( x, y, 8, 8, { 5, 5, 5, wnd.alpha } );
	
	local r12, g12, b12 = 149, 184, 6;
	if gui.GetValue("senseui_color") == 0 then
		r12, g12, b12 = 149, 184, 6;
	elseif gui.GetValue("senseui_color") == 1 then
		r12, g12, b12 = 6, 132, 182;
	elseif gui.GetValue("senseui_color") == 2 then
		r12, g12, b12 = 182, 6, 6;
	elseif gui.GetValue("senseui_color") == 3 then
		r12, g12, b12 = 146, 6, 182;
	elseif gui.GetValue("senseui_color") == 4 then
		r12, g12, b12 = 205, 107, 8;
	elseif gui.GetValue("senseui_color") == 5 then
		r12, g12, b12 = 214, 10, 193;
	end
	
	local r11, g11, b11 = 80, 99, 3;
	if gui.GetValue("senseui_color") == 0 then
		r11, g11, b11 = 80, 99, 3;
	elseif gui.GetValue("senseui_color") == 1 then
		r11, g11, b11 = 3, 79, 98;
	elseif gui.GetValue("senseui_color") == 2 then
		r11, g11, b11 = 98, 3, 3;
	elseif gui.GetValue("senseui_color") == 3 then
		r11, g11, b11 = 68, 3, 98;
	elseif gui.GetValue("senseui_color") == 4 then
		r11, g11, b11 = 123, 57, 4;
	elseif gui.GetValue("senseui_color") == 5 then
		r11, g11, b11 = 112, 4, 94;
	end
	
	if var then
		render.gradient( x + 1, y + 1, 6, 5, { r12, g12, b12, wnd.alpha }, { r11, g11, b11, wnd.alpha }, true );
	else
		render.gradient( x + 1, y + 1, 6, 5, { 65, 65, 65, wnd.alpha }, { 45, 45, 45, wnd.alpha }, true );
	end
	
	local r1, g1, b1 = 181, 181, 181;
	
	if is_alt then
		r1, g1, b1 = 190, 190, 110;
	end
	
	render.text( x + 13, y - 3, title, { r1, g1, b1, wnd.alpha } );

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + 17;

	if group.highest_w < 15 + textw then
		wnd.groups[gs_curgroup].highest_w = 15 + textw;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	return var;
end

local function gs_button( title, w, h )
	local wnd, group = gs_newelement();

	local textw, texth = draw.GetTextSize( title );
	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset;

	-- Backend
	local var = false;

	if input.IsButtonDown( 1 ) and gs_inbounds( gs_mx, gs_my, x, y, x + w, y + h ) and not gs_isBlocked then
		var = true;
	end

	-- Draw
	render.outline( x, y, w, h, { 5, 5, 5, wnd.alpha } );
	render.outline( x + 1, y + 1, w - 2, h - 2, { 65, 65, 65, wnd.alpha } );

	local r, g, b = 181, 181, 181;

	if var then
		r, g, b = 255, 255, 255;
		render.gradient( x + 2, y + 2, w - 4, h - 5, { 45, 45, 45, wnd.alpha }, { 55, 55, 55, wnd.alpha }, true );
	else
		render.gradient( x + 2, y + 2, w - 4, h - 5, { 55, 55, 55, wnd.alpha }, { 45, 45, 45, wnd.alpha }, true );
	end

	render.text( x + (w / 2 - textw / 2), y + (h / 2 - texth / 2), title, { r, g, b, wnd.alpha }, gs_fonts.verdana_12b );

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + h + 5;

	if group.highest_w < w then
		wnd.groups[gs_curgroup].highest_w = w;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	return var;
end

local function gs_slider( title, min, max, fmt, min_text, max_text, show_buttons, var )
	local wnd, group = gs_newelement();

	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset - 3;
	local textw, texth = 0, 0;

	gs_mx, gs_my = input.GetMousePos();

	if title ~= nil then
		textw, texth = draw.GetTextSize( title );
		texth = texth + 2;
	end

	-- Backend
	local m = 0;

	if min ~= 0 then
		m = min;

		var = var - m;
		min = min - m;
		max = max - m;
	end

	if not gs_isBlocked then
		if input.IsButtonDown( 1 ) and gs_inbounds( gs_mx, gs_my, x, y + texth, x + 155, y + texth + 8 ) then
			local relative_x = gs_clamp( gs_mx - x, 0, 153 );
			local ratio = relative_x / 153;

			var = math.floor( min + ((max - min) * ratio) );
		end

		-- Handle -/+ buttons
		if input.IsButtonPressed( 1 ) and gs_inbounds( gs_mx, gs_my, x - 5, y + texth + 1, x - 2, y + texth + 4 ) and show_buttons then
			var = var - 1;
		end

		if input.IsButtonPressed( 1 ) and gs_inbounds( gs_mx, gs_my, x + 155 + 2, y + texth + 1, x + 155 + 5, y + texth + 4 ) and show_buttons then
			var = var + 1;
		end
	end

	-- Clamp final value
	var = math.ceil( gs_clamp( var, min, max ) );

	local w = 153 / max * var;

	var = var + m;
	min = min + m;
	max = max + m;

	-- Draw
	if title ~= nil then
		render.text( x, y - 2, title, { 181, 181, 181, wnd.alpha } );
	end
	
	local r12, g12, b12 = 149, 184, 6;
	if gui.GetValue("senseui_color") == 0 then
		r12, g12, b12 = 149, 184, 6;
	elseif gui.GetValue("senseui_color") == 1 then
		r12, g12, b12 = 6, 132, 182;
	elseif gui.GetValue("senseui_color") == 2 then
		r12, g12, b12 = 182, 6, 6;
	elseif gui.GetValue("senseui_color") == 3 then
		r12, g12, b12 = 146, 6, 182;
	elseif gui.GetValue("senseui_color") == 4 then
		r12, g12, b12 = 205, 107, 8;
	elseif gui.GetValue("senseui_color") == 5 then
		r12, g12, b12 = 214, 10, 193;
	end
	
	local r11, g11, b11 = 80, 99, 3;
	if gui.GetValue("senseui_color") == 0 then
		r11, g11, b11 = 80, 99, 3;
	elseif gui.GetValue("senseui_color") == 1 then
		r11, g11, b11 = 3, 79, 98;
	elseif gui.GetValue("senseui_color") == 2 then
		r11, g11, b11 = 98, 3, 3;
	elseif gui.GetValue("senseui_color") == 3 then
		r11, g11, b11 = 68, 3, 98;
	elseif gui.GetValue("senseui_color") == 4 then
		r11, g11, b11 = 123, 57, 4;
	elseif gui.GetValue("senseui_color") == 5 then
		r11, g11, b11 = 112, 4, 94;
	end
	
	render.outline( x, y + texth, 155, 4, { 5, 5, 5, wnd.alpha } );
	render.gradient( x + 1, y + texth + 1, 153, 4, { 45, 45, 45, wnd.alpha }, { 65, 65, 65, wnd.alpha }, true );
	render.gradient( x + 1, y + texth + 1, w, 4, { r12, g12, b12, wnd.alpha }, { r11, g11, b11, wnd.alpha }, true );

	if show_buttons then
		if var ~= min then
			render.rect( x - 5, y + texth + 3, 3, 1, { 181, 181, 181, wnd.alpha } );
		end

		if var ~= max then
			render.rect( x + 155 + 2, y + texth + 3, 3, 1, { 181, 181, 181, wnd.alpha } );
			render.rect( x + 155 + 3, y + texth + 2, 1, 3, { 181, 181, 181, wnd.alpha } );
		end
	end

	local vard = var;

	if fmt ~= nil then
		vard = vard .. fmt;
	end

	if min_text ~= nil and var == min then
		vard = min_text;
	end

	if max_text ~= nil and var == max then
		vard = max_text;
	end

	draw.SetFont( gs_fonts.verdana_12b );
	local varw, varh = draw.GetTextSize( vard );

	render.text( x + w - varw / 2, y + texth + varh / 6, vard, { 181, 181, 181, wnd.alpha }, gs_fonts.verdana_12b );

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + texth + 14;

	if group.highest_w < 155 then
		wnd.groups[gs_curgroup].highest_w = 155;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	return var;
end

local function gs_label( text, is_alt )
	local wnd, group = gs_newelement();

	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset - 3;
	local textw, texth = draw.GetTextSize( text );
	local r, g, b = 181, 181, 181;

	if is_alt then
		r, g, b = 190, 190, 120;
	end

	render.text( x, y, text, { r, g, b, wnd.alpha } );

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + 17;

	if group.highest_w < textw then
		wnd.groups[gs_curgroup].highest_w = textw;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;
end

local gs_curbind = {
	id = "",
	is_selecting = false
};

local gs_keytable = {
	esc = { 27, "[ESC]" }, f1 = { 112, "[F1]" }, f2 = { 113, "[F2]" }, f3 = { 114, "[F3]" }, f4 = { 115, "[F4]" }, f5 = { 116, "[F5]" },
	f6 = { 117, "[F6]" }, f7 = { 118, "[F7]" }, f8 = { 119, "[F8]" }, f9 = { 120, "[F9]" }, f10 = { 121, "[F10]" }, f11 = { 122, "[F11]" },
	f12 = { 123, "[F12]" }, tilde = { 192, "[~]" }, one = { 49, "[1]" }, two = { 50, "[2]" }, three = { 51, "[3]" }, four = { 52, "[4]" },
	five = { 53, "[5]" }, six = { 54, "[6]" }, seven = { 55, "[7]" }, eight = { 56, "[8]" }, nine = { 57, "[9]" }, zero = { 48, "[0]" },
	minus = { 189, "[_]" }, equals = { 187, "[=]" }, backslash = { 220, "[\\]" }, backspace = { 8, "[BKSP]" },
	tab = { 9, "[TAB]" }, q = { 81, "[Q]" }, w = { 87, "[W]" }, e = { 69, "[E]" }, r = { 82, "[R]" }, t = { 84, "[T]" }, y = { 89, "[Y]" }, u = { 85, "[U]" },
	i = { 73, "[I]" }, o = { 79, "[O]" }, p = { 80, "[P]" }, bracket_o = { 219, "[[]" }, bracket_c = { 221, "[]]" },
	a = { 65, "[A]" }, s = { 83, "[S]" }, d = { 68, "[D]" }, f = { 70, "[F]" }, g = { 71, "[G]" }, h = { 72, "[H]" }, j = { 74, "[J]" }, k = { 75, "[K]" },
	l = { 76, "[L]" }, semicolon = { 186, "[;]" }, quotes = { 222, "[']" }, caps = { 20, "[CAPS]" }, enter = { 13, "[RETN]" },
	shift = { 16, "[SHI]" }, z = { 90, "[Z]" }, x = { 88, "[X]" }, c = { 67, "[C]" }, v = { 86, "[V]" }, b = { 66, "[B]" }, n = { 78, "[N]" },
	m = { 77, "[M]" }, comma = { 188, "[,]" }, dot = { 190, "[.]" }, slash = { 191, "[/]" }, ctrl = { 17, "[CTRL]" },
	win = { 91, "[WIN]" }, alt = { 18, "[ALT]" }, space = { 32, "[SPC]" }, scroll = { 145, "[SCRL]" }, pause = { 19, "[PAUS]" },
	insert = { 45, "[INS]" }, home = { 36, "[HOME]" }, pageup = { 33, "[PGUP]" }, pagedn = { 34, "[PGDN]" }, delete = { 46, "[DEL]" },
	end_key = { 35, "[END]" }, uparrow = { 38, "[UP]" }, leftarrow = { 37, "[LEFT]" }, downarrow = { 40, "[DOWN]" }, 
	rightarrow = { 39, "[RGHT]" }, num = { 144, "[NUM]" }, num_slash = { 111, "[/]" }, num_mult = { 106, "[*]" },
	num_sub = { 109, "[-]" }, num_7 = { 103, "[7]" }, num_8 = { 104, "[8]" }, num_9 = { 105, "[9]" }, num_plus = { 107, "[+]" },
	num_4 = { 100, "[4]" }, num_5 = { 101, "[5]" }, num_6 = { 102, "[6]" }, num_1 = { 97, "[1]" }, num_2 = { 98, "[2]" },
	num_3 = { 99, "[3]" }, num_enter = { 13, "[ENT]" }, num_0 = { 96, "[0]" }, num_dot = { 110, "[.]" }, mouse_1 = { 1, "[M1]" }, mouse_2 = { 2, "[M2]" }
};

local function gs_key2name( key )
	local ktxt = "[-]";

	for k, v in pairs( gs_keytable ) do
		if v[1] == key then
			ktxt = v[2];
		end
	end

	return ktxt;
end

local function gs_bind( id, detect_editable, var, key_held, detect_type )
	local wnd, group = gs_newelement();

	local x, y = wnd.x + group.x + group.w - 10, group.last_y;
	local r, g, b = 96, 96, 96;

	if gs_curbind.id == id then
		if gs_curbind.is_selecting then
			r, g, b = 255, 0, 0;
		end
	end

	local did_select = false;

	-- Backend
	if gs_curbind.id == id and gs_curbind.is_selecting and not gs_isBlocked then
		for k, v in pairs( SenseUI.Keys ) do
			if input.IsButtonPressed( v ) and v ~= SenseUI.Keys.esc then
				var = v;
				gs_curbind.is_selecting = false;

				did_select = true;
				break;
			else 
				if input.IsButtonPressed( v ) and v == SenseUI.Keys.esc then
					var = nil;
					gs_curbind.is_selecting = false;

					did_select = true;
					break;
				end
			end
		end

		if not did_select then
			gs_curbind.is_selecting = true;
		end
	end

	local text = gs_key2name( var );

	draw.SetFont( gs_fonts.verdana_10 );
	local textw, texth = draw.GetTextSize( text );

	x = x - textw;

	gs_mx, gs_my = input.GetMousePos();

	if input.IsButtonPressed( 1 ) then
		if gs_inbounds( gs_mx, gs_my, x, y, x + textw, y + texth ) then
			gs_curbind.id = id;
			gs_curbind.is_selecting = true;
		end
	end

	if input.IsButtonPressed( 2 ) and detect_editable and not gs_isBlocked then
		if not gs_curbind.is_selecting then
			if gs_inbounds( gs_mx, gs_my, x, y, x + textw, y + texth ) then
				gs_curchild.minimal_width = 0;
				gs_curchild.id = id .. "_child";
				gs_curchild.x = x;
				gs_curchild.multiselect = false;
				gs_curchild.y = y + texth + 2;
				gs_curchild.elements = { "Always on", "On hotkey", "Toggle", "Off hotkey" };
				gs_curchild.selected = { detect_type };
				gs_isBlocked = true;
			end
		end
	end

	if gs_curchild.last_id == id .. "_child" then
		detect_type = gs_curchild.selected[1];
	end

	local held_done = false;

	if detect_type == 3 or detect_type == 1 then
		held_done = true;
	end

	if var ~= nil and var ~= 0 then
		if detect_type == 2 and input.IsButtonDown( var ) then
			held_done = true;
			key_held = true;
		end

		if detect_type == 4 and input.IsButtonDown( var ) then
			held_done = true;
			key_held = false;
		end

		if detect_type == 3 and input.IsButtonPressed( var ) then
			key_held = not key_held;
		end

		if detect_type == 1 then
			key_held = true;
		end

		if not held_done then
			if detect_type ~= 4 then
				key_held = false;
			else
				key_held = true;
			end
		end
	end

	-- Draw
	render.text( x, y, text, { r, g, b, wnd.alpha }, gs_fonts.verdana_10 );

	return var, key_held, detect_type;
end

function gs_drawtabbar( )
	local wnd = gs_newelement();
	local tab = nil;

	for k, v in pairs( wnd.tabs ) do
		if v.selected then
			tab = v;
		end
	end

	if tab ~= nil then
		local tabNumeric = 0;

		for k, v in pairs( wnd.tabs ) do
			if v.id == tab.id then
				tabNumeric = v.numID;
			end
		end

		render.rect( wnd.x, wnd.y, 79, 24 + tabNumeric * 80, { 12, 12, 12, wnd.alpha } );
		render.rect( wnd.x, wnd.y + 24 + (tabNumeric + 1) * 80, 79, wnd.h - (24 + (tabNumeric + 1) * 80), { 12, 12, 12, wnd.alpha } );

		render.rect( wnd.x + 80, wnd.y, 1, 25 + tabNumeric * 80, { 75, 75, 75, wnd.alpha } );
		render.rect( wnd.x, wnd.y + 25 + tabNumeric * 80, 81, 1, { 75, 75, 75, wnd.alpha } );
		render.rect( wnd.x, wnd.y + 25 + (tabNumeric + 1) * 80, 80, 1, { 75, 75, 75, wnd.alpha } );
		render.rect( wnd.x + 80, wnd.y + 25 + (tabNumeric + 1) * 80, 1, wnd.h - (25 + (tabNumeric + 1) * 80), { 75, 75, 75, wnd.alpha } );
	end
end

function gs_begintab( id, icon )
	local wnd = gs_newelement();

	if wnd.tabs[id] == nil then
		local gs_tab = {
			id = "",
			icon = "",
			numID = 0,

			selected = false,

			groups = {}
		};

		gs_tab.id = id;
		gs_tab.icon = icon;
		gs_tab.numID = gs_tablecount( wnd.tabs );

		wnd.tabs[id] = gs_tab;
	end

	gs_curtab = id;

	local tab = wnd.tabs[gs_curtab];

	-- Backend

	local r, g, b = 90, 90, 90;
	if tab.selected then
		r, g, b = 210, 210, 210;
	end

	local tabNumeric = 0;

	for k, v in pairs( wnd.tabs ) do
		if v.id == id then
			tabNumeric = v.numID;
		end
	end

	gs_mx, gs_my = input.GetMousePos();
	if gs_inbounds( gs_mx, gs_my, wnd.x, wnd.y + (25 + tabNumeric * 80), wnd.x + 80, wnd.y + (25 + tabNumeric * 80) + 80 ) and not gs_isBlocked then
		r, g, b = 210, 210, 210;

		if input.IsButtonPressed( 1 ) then
			for k, v in pairs( wnd.tabs ) do
				wnd.tabs[k].selected = false;

				if v.id == id then
					wnd.tabs[k].selected = true;
				end
			end
		end
	end

	-- Draw

	draw.SetFont( gs_fonts.astriumtabs );
	local textw, texth = draw.GetTextSize( tab.icon[1] );

	render.text( wnd.x + (40 - textw / 2), wnd.y + (25 + tabNumeric * 80) + (40 - texth / 2) - tab.icon[2], tab.icon[1], { r, g, b, wnd.alpha }, gs_fonts.astriumtabs );

	return tab.selected;
end

local function gs_endtab( )
	local wnd = gs_newelement();
	local smthselected = false;

	for k, v in pairs( wnd.tabs ) do
		if v.selected then
			smthselected = true;
			break;
		end
	end

	if not smthselected then
		wnd.tabs[gs_curtab].selected = true;
	end

	gs_curtab = "";
end

local function gs_combo( title, elements, var )
	local wnd, group = gs_newelement();
	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset - 3;
	local bg_col = { 26, 26, 26, wnd.alpha };
	local textw, texth = 0, 0;

	if title ~= nil then
		draw.GetTextSize( title );
	end

	local is_up = false;

	local ltitle = elements[1] .. var;

	if title ~= nil then
		ltitle = title;
	end

	-- Backend
	gs_mx, gs_my = input.GetMousePos();
	if gs_inbounds( gs_mx, gs_my, x, y + texth + 2, x + 155, y + texth + 22 ) and not gs_isBlocked then
		bg_col = { 36, 36, 36, wnd.alpha };

		if input.IsButtonPressed( 1 ) then
			gs_curchild.id = ltitle .. "_child";
			gs_curchild.x = x;
			gs_curchild.y = y + texth + 22;
			gs_curchild.minimal_width = 135;
			gs_curchild.multiselect = false;
			gs_curchild.elements = elements;
			gs_curchild.selected = { var };
			gs_isBlocked = true;
		end
	end

	if gs_curchild.id == ltitle .. "_child" then
		is_up = true;
	end

	if gs_curchild.last_id == ltitle .. "_child" then
		var = gs_curchild.selected[1];
		gs_curchild.last_id = "";
	end

	-- Drawing
	if title ~= nil then
		render.text( x, y, title, { 181, 181, 181, wnd.alpha } );
	end

	render.gradient( x, y + texth + 2, 155, 19, bg_col, { 36, 36, 36, wnd.alpha }, true );
	render.outline( x, y + texth + 2, 155, 20, { 5, 5, 5, wnd.alpha } );

	render.text( x + 10, y + 6 + texth , elements[var], { 181, 181, 181, wnd.alpha } );

	if not is_up then
		render.rect( x + 150 - 9, y + texth + 11, 5, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 8, y + texth + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 7, y + texth + 13, 1, 1, { 181, 181, 181, wnd.alpha } );
	else
		render.rect( x + 150 - 7, y + texth + 11, 1, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 8, y + texth + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 9, y + texth + 13, 5, 1, { 181, 181, 181, wnd.alpha } );
	end

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + texth + 27;

	if group.highest_w < 155 then
		wnd.groups[gs_curgroup].highest_w = 155;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	return var;
end

local function gs_multicombo( title, elements, var )
	local wnd, group = gs_newelement();
	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset - 3;
	local bg_col = { 26, 26, 26, wnd.alpha };
	local textw, texth = draw.GetTextSize( title );
	local is_up = false;

	-- Backend
	gs_mx, gs_my = input.GetMousePos();
	if gs_inbounds( gs_mx, gs_my, x, y + texth + 2, x + 155, y + texth + 22 ) and not gs_isBlocked then
		bg_col = { 36, 36, 36, wnd.alpha };

		if input.IsButtonPressed( 1 ) then
			gs_curchild.id = title .. "_child";
			gs_curchild.x = x;
			gs_curchild.y = y + texth + 22;
			gs_curchild.minimal_width = 135;
			gs_curchild.multiselect = true;
			gs_curchild.elements = elements;
			gs_curchild.selected = var;
			gs_isBlocked = true;
		end
	end

	if gs_curchild.id == title .. "_child" then
		is_up = true;
	end

	if gs_curchild.last_id == title .. "_child" then
		var = gs_curchild.selected;
		gs_curchild.last_id = "";
	end

	-- Drawing
	render.text( x, y, title, { 181, 181, 181, wnd.alpha } );

	render.gradient( x, y + texth + 2, 155, 19, bg_col, { 36, 36, 36, wnd.alpha }, true );
	render.outline( x, y + texth + 2, 155, 20, { 5, 5, 5, wnd.alpha } );

	local fmt = "";
	for i = 1, #elements do
		local f_len = #fmt < 16;
		local f_frst = #fmt <= 0;

		if var[elements[i]] and f_len then
			if not f_frst then
				fmt = fmt .. ", ";
			end

			fmt = fmt .. elements[i];
		else
			if not f_len then
				local selected = 0;

				for k = 1, #elements do
					if var[elements[k]] then
						selected = selected + 1;
					end
				end

				fmt = selected .. " selected";
				break;
			end
		end
	end

	if fmt == "" then
		fmt = "-";
	end

	render.text( x + 10, y + 6 + texth , fmt, { 181, 181, 181, wnd.alpha } );

	if not is_up then
		render.rect( x + 150 - 9, y + texth + 11, 5, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 8, y + texth + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 7, y + texth + 13, 1, 1, { 181, 181, 181, wnd.alpha } );
	else
		render.rect( x + 150 - 7, y + texth + 11, 1, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 8, y + texth + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
		render.rect( x + 150 - 9, y + texth + 13, 5, 1, { 181, 181, 181, wnd.alpha } );
	end

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + texth + 27;

	if group.highest_w < 155 then
		wnd.groups[gs_curgroup].highest_w = 155;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	return var;
end

-- it's like
-- [ normal, with shift ]
local gs_textTable = {
	[SenseUI.Keys.tilde] = { "`", "~" },
	[SenseUI.Keys.one] = { "1", "!" },
	[SenseUI.Keys.two] = { "2", "@" },
	[SenseUI.Keys.three] = { "3", "#" },
	[SenseUI.Keys.four] = { "4", "$" },
	[SenseUI.Keys.five] = { "5", "%" },
	[SenseUI.Keys.six] = { "6", "^" },
	[SenseUI.Keys.seven] = { "7", "&" },
	[SenseUI.Keys.eight] = { "8", "*" },
	[SenseUI.Keys.nine] = { "9", "(" },
	[SenseUI.Keys.zero] = { "0", ")" },
	[SenseUI.Keys.minus] = { "-", "_" },
	[SenseUI.Keys.equals] = { "=", "+" },
	[SenseUI.Keys.backslash] = { "\\", "|" },
	[SenseUI.Keys.q] = { "q", "Q" },
	[SenseUI.Keys.w] = { "w", "W" },
	[SenseUI.Keys.e] = { "e", "E" },
	[SenseUI.Keys.r] = { "r", "R" },
	[SenseUI.Keys.t] = { "t", "T" },
	[SenseUI.Keys.y] = { "y", "Y" },
	[SenseUI.Keys.u] = { "u", "U" },
	[SenseUI.Keys.i] = { "i", "I" },
	[SenseUI.Keys.o] = { "o", "O" },
	[SenseUI.Keys.p] = { "p", "P" },
	[SenseUI.Keys.bracket_o] = { "[", "{" },
	[SenseUI.Keys.bracket_c] = { "]", "}" },
	[SenseUI.Keys.a] = { "a", "A" },
	[SenseUI.Keys.s] = { "s", "S" },
	[SenseUI.Keys.d] = { "d", "D" },
	[SenseUI.Keys.f] = { "f", "F" },
	[SenseUI.Keys.g] = { "g", "G" },
	[SenseUI.Keys.h] = { "h", "H" },
	[SenseUI.Keys.j] = { "j", "J" },
	[SenseUI.Keys.k] = { "k", "K" },
	[SenseUI.Keys.l] = { "l", "L" },
	[SenseUI.Keys.semicolon] = { ";", ":" },
	[SenseUI.Keys.quotes] = { "'", "\"" },
	[SenseUI.Keys.z] = { "z", "Z" },
	[SenseUI.Keys.x] = { "x", "X" },
	[SenseUI.Keys.c] = { "c", "C" },
	[SenseUI.Keys.v] = { "v", "V" },
	[SenseUI.Keys.b] = { "b", "B" },
	[SenseUI.Keys.n] = { "n", "N" },
	[SenseUI.Keys.m] = { "m", "M" },
	[SenseUI.Keys.comma] = { ",", "<" },
	[SenseUI.Keys.dot] = { ".", ">" },
	[SenseUI.Keys.slash] = { "/", "?" },
	[SenseUI.Keys.space] = { " ", " " }
};

local function gs_listbox( elements, maxElements, showSearch, var, searchVar, scrollVar )
	local wnd, group = gs_newelement();
	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset - 3;

	if showSearch then
		render.outline( x, y, 155, 20, { 5, 5, 5, wnd.alpha } );
		render.outline( x + 1, y + 1, 153, 18, { 28, 28, 28, wnd.alpha } );
		render.rect( x + 2, y + 2, 151, 16, { 36, 36, 36, wnd.alpha } );

		gs_mx, gs_my = input.GetMousePos();
		if input.IsButtonDown( 1 ) then
			if gs_inbounds( gs_mx, gs_my, x, y, x + 155, y + 20 ) then
				gs_curinput = elements[1] .. maxElements .. var .. elements[#elements];
				gs_isBlocked = true;
			elseif not gs_inbounds( gs_mx, gs_my, x, y, x + 155, y + 20 ) and gs_curinput == elements[1] .. maxElements .. var .. elements[#elements] then
				gs_curinput = "";
				gs_isBlocked = false;
			end
		end

		if gs_curinput == elements[1] .. maxElements .. var .. elements[#elements] then
			if input.IsButtonPressed( SenseUI.Keys.esc ) then
				gs_curinput = "";
				gs_isBlocked = false;
			end

			if input.IsButtonPressed( SenseUI.Keys.backspace ) then
				searchVar = searchVar:sub( 1, -2 );
			end

			for k, v in pairs( gs_textTable ) do
				if input.IsButtonPressed( k ) then
					if input.IsButtonDown( SenseUI.Keys.shift ) then
						if draw.GetTextSize( searchVar .. v[2] ) <= 135 then
							searchVar = searchVar .. v[2];
						end
					else
						if draw.GetTextSize( searchVar .. v[1] ) <= 135 then
							searchVar = searchVar .. v[1];
						end
					end
				end
			end
		end

		if gs_curinput == elements[1] .. maxElements .. var .. elements[#elements] then
			render.text( x + 8, y + 4, searchVar .. "_", { 181, 181, 181, wnd.alpha } );
		else
			render.text( x + 8, y + 4, searchVar, { 181, 181, 181, wnd.alpha } );
		end

		-- Do search thingy
		if searchVar ~= "" then
			local newElements = {};

			for i = 1, #elements do
				if elements[i]:sub( 1, #searchVar ) == searchVar then
					newElements[#newElements + 1] = elements[i];
				end
			end

			elements = newElements;
		end

		y = y + 20;
	end

	-- Prevent bugs here
	if ( #elements - maxElements ) * 20 >= maxElements * 20 then
		while ( #elements - maxElements ) * 20 >= maxElements * 20 do
			maxElements = maxElements + 1;
		end
	end

	local h = maxElements * 20;

	render.outline( x, y, 155, h + 2, { 5, 5, 5, wnd.alpha } );
	render.rect( x + 1, y + 1, 153, h, { 36, 36, 36, wnd.alpha } );

	local bottomElements = 0;
	local topElements = 0;
	local shouldDrawScroll = false;

	for i = 1, #elements do
		local r, g, b = 181, 181, 181;
		local font = gs_fonts.verdana_12;

		local elementY = ( y + i * 20 - 19 ) - scrollVar * 20;
		local shouldDraw = true;

		if elementY > y + h then
			shouldDraw = false;
			bottomElements = bottomElements + 1;
			shouldDrawScroll = true;
		elseif elementY < y then
			shouldDraw = false;
			topElements = topElements + 1;
			shouldDrawScroll = true;
		end

		if shouldDraw then
			gs_mx, gs_my = input.GetMousePos();
			if gs_inbounds( gs_mx, gs_my, x + 1, elementY, x + 149, elementY + 20 ) and not gs_isBlocked then
				font = gs_fonts.verdana_12b;
				render.rect( x + 1, elementY, 153, 20, { 28, 28, 28, wnd.alpha } );

				if input.IsButtonPressed( 1 ) then
					var = i;
				end
			end

			if var == i then
				if gui.GetValue("senseui_color") == 0 then
					r, g, b = 149, 184, 6;
				elseif gui.GetValue("senseui_color") == 1 then
					r, g, b = 6, 132, 182;
				elseif gui.GetValue("senseui_color") == 2 then
					r, g, b = 182, 6, 6;
				elseif gui.GetValue("senseui_color") == 3 then
					r, g, b = 146, 6, 182;
				elseif gui.GetValue("senseui_color") == 4 then
					r, g, b = 205, 107, 8;
				elseif gui.GetValue("senseui_color") == 5 then
					r, g, b = 214, 10, 193;
				end
				font = gs_fonts.verdana_12b;

				render.rect( x + 1, elementY, 153, 20, { 28, 28, 28, wnd.alpha } );
			end

			render.text( x + 10, elementY + 3, elements[i], { r, g, b, wnd.alpha }, font );
		end
	end

	if shouldDrawScroll then
		render.rect( x + 149, y + 1, 5, h, { 32, 32, 32, wnd.alpha } );

		local c = 38;
		local scrY = y + scrollVar + scrollVar * 20 + 1;
		local scrH = ( h - ( ( #elements - maxElements ) * 20 ) ) - scrollVar;

		gs_mx, gs_my = input.GetMousePos();
		if gs_inbounds( gs_mx, gs_my, x + 149, scrY, x + 154, scrY + scrH ) and not gs_isBlocked then
			c = 46;

			if input.IsButtonDown( 1 ) then
				c = 28;
			end
		end

		if gs_inbounds( gs_mx, gs_my, x + 149, y, x + 154, y + h ) and input.IsButtonDown( 1 ) and not gs_isBlocked then
			local relative_y = gs_clamp( gs_my - y, 0, h );
			local ratio = relative_y / h + ( relative_y / h ) / 2;

			scrollVar = gs_clamp( math.floor( ( #elements - maxElements ) * ratio ), 0, #elements - maxElements );
		end

		render.outline( x + 149, scrY, 5, scrH, { c, c, c, wnd.alpha } );
		render.rect( x + 150, scrY + 1, 3, scrH - 1, { c + 8, c + 8, c + 8, wnd.alpha } );

		if bottomElements ~= 0 then
			render.rect( x + 150 - 9, y + h - 18 + 11, 5, 1, { 181, 181, 181, wnd.alpha } );
			render.rect( x + 150 - 8, y + h - 18 + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
			render.rect( x + 150 - 7, y + h - 18 + 13, 1, 1, { 181, 181, 181, wnd.alpha } );
		end

		if topElements ~= 0 then
			render.rect( x + 150 - 7, y - 5 + 11, 1, 1, { 181, 181, 181, wnd.alpha } );
			render.rect( x + 150 - 8, y - 5 + 12, 3, 1, { 181, 181, 181, wnd.alpha } );
			render.rect( x + 150 - 9, y - 5 + 13, 5, 1, { 181, 181, 181, wnd.alpha } );
		end
	end

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + h + 5;

	if showSearch then
		wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + 20;
	end

	if group.highest_w < 155 then
		wnd.groups[gs_curgroup].highest_w = 155;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	if showSearch then
		wnd.groups[gs_curgroup].last_y = wnd.groups[gs_curgroup].last_y - 20;
	end

	return var, scrollVar, searchVar;
end

local function gs_textbox( id, title, var )
	local wnd, group = gs_newelement();
	local x, y = wnd.x + group.x + 25, wnd.y + group.y + group.nextline_offset;

	if title ~= nil then
		render.text( x, y, title, { 181, 181, 181, wnd.alpha } );

		y = y + 13;
	end

	render.outline( x, y, 155, 20, { 5, 5, 5, wnd.alpha } );
	render.outline( x + 1, y + 1, 153, 18, { 28, 28, 28, wnd.alpha } );
	render.rect( x + 2, y + 2, 151, 16, { 36, 36, 36, wnd.alpha } );

	gs_mx, gs_my = input.GetMousePos();
	if input.IsButtonDown( 1 ) then
		if gs_inbounds( gs_mx, gs_my, x, y, x + 155, y + 20 ) then
			gs_curinput = id;
			gs_isBlocked = true;
		elseif not gs_inbounds( gs_mx, gs_my, x, y, x + 155, y + 20 ) and gs_curinput == id then
			gs_curinput = "";
			gs_isBlocked = false;
		end
	end

	if gs_curinput == id then
		if input.IsButtonPressed( SenseUI.Keys.esc ) then
			gs_curinput = "";
			gs_isBlocked = false;
		end

		if input.IsButtonPressed( SenseUI.Keys.backspace ) then
			var = var:sub( 1, -2 );
		end

		for k, v in pairs( gs_textTable ) do
			if input.IsButtonPressed( k ) then
				if input.IsButtonDown( SenseUI.Keys.shift ) then
					if draw.GetTextSize( var .. v[2] ) <= 135 then
						var = var .. v[2];
					end
				else
					if draw.GetTextSize( var .. v[1] ) <= 135 then
						var = var .. v[1];
					end
				end
			end
		end
	end

	if gs_curinput == id then
		render.text( x + 8, y + 4, var .. "_", { 181, 181, 181, wnd.alpha } );
	else
		render.text( x + 8, y + 4, var, { 181, 181, 181, wnd.alpha } );
	end

	wnd.groups[gs_curgroup].is_nextline = true;
	wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + 28;

	if title ~= nil then
		wnd.groups[gs_curgroup].nextline_offset = wnd.groups[gs_curgroup].nextline_offset + 13;
	end

	if group.highest_w < 155 then
		wnd.groups[gs_curgroup].highest_w = 155;
	end

	if group.highest_h < wnd.groups[gs_curgroup].nextline_offset then
		wnd.groups[gs_curgroup].highest_h = wnd.groups[gs_curgroup].nextline_offset - wnd.groups[gs_curgroup].nextline_offset / 2;
	end

	wnd.groups[gs_curgroup].last_y = y;

	if title ~= nil then
		wnd.groups[gs_curgroup].last_y = wnd.groups[gs_curgroup].last_y + 13;
	end

	return var;
end

SenseUI.BeginWindow = gs_beginwindow;
SenseUI.AddGradient = gs_addgradient;
SenseUI.EndWindow = gs_endwindow;
SenseUI.SetWindowMoveable = gs_setwindowmovable;
SenseUI.SetWindowOpenKey = gs_setwindowopenkey;
SenseUI.SetWindowDrawTexture = gs_setwindowdrawtexture;
SenseUI.BeginGroup = gs_begingroup;
SenseUI.EndGroup = gs_endgroup;
SenseUI.Checkbox = gs_checkbox;
SenseUI.SetWindowSizeable = gs_setwindowsizeable;
SenseUI.SetGroupMoveable = gs_setgroupmoveable;
SenseUI.SetGroupSizeable = gs_setgroupsizeable;
SenseUI.Button = gs_button;
SenseUI.Slider = gs_slider;
SenseUI.Label = gs_label;
SenseUI.Bind = gs_bind;
SenseUI.BeginTab = gs_begintab;
SenseUI.DrawTabBar = gs_drawtabbar;
SenseUI.EndTab = gs_endtab;
SenseUI.Combo = gs_combo;
SenseUI.MultiCombo = gs_multicombo;
SenseUI.Listbox = gs_listbox;
SenseUI.Textbox = gs_textbox;

-- Let's add some useless hook here to make aimware think that script loaded
callbacks.Register( "CreateMove", "senseui", function( cmd ) end );
print("[SenseUI] UI has been loaded!");