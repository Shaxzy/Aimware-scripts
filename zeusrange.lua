---------------------------------------------------- Taser ----------------------------------------------------

local function distance3d(x1, y1, z1, x2, y2, z2)
   return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end
local msc_p2 = gui.Reference("VISUALS", "Shared")
local GroupBox = gui.Groupbox( msc_p2, "Zeus Range", 0, 630, 215, 150 );
local ActiveCheckBox = gui.Checkbox(GroupBox, "Active", "Activate", false)
local Tyleline = gui.Combobox( GroupBox, 'Type_line',"Type line", "Single line","Multi line")
local colortype = gui.Combobox( GroupBox, 'Type_color',"Color", "Single color","Multi color")
local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
   local x = (x2 - x1) * percentage + x1
   local y = (y2 - y1) * percentage + y1
   local z = (z2 - z1) * percentage + z1
   return x, y, z
end
local function trace_line_skip_teammates( x1, y1, z1, x2, y2, z2, max_traces)

   local max_traces = max_traces or 10
   local fraction, entindex_hit = 0, -1
   local x_hit, y_hit, z_hit = x1, y1, z1
local contents;
   local i=1
    
    
    
        while (entindex_hit == -1 or (entindex_hit ~= 0 and 1)) and 1 > fraction and max_traces >= i do
        contents,fraction, entindex_hit = engine.TraceLine(x_hit, y_hit, z_hit, x2, y2, z2,1)
        x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, fraction)

        i = i + 1
    end
    
    
    
    
    
    
    
    
    


   local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
   local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

   return traveled_total/total_distance, entindex_hit
end

local function hsv_to_rgb(h, s, v, a)
 local r, g, b

 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);

 i = i % 6

 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end

 return r * 255, g * 255, b * 255, a * 255
end
local weapon_name_prev = nil
local last_switch = 0
local accuracy = 2.5
local is_taser;
local is_knife;
local function on_item_equip(Event)

   if (Event:GetName() ~= 'item_equip') then
       return;
   end

   local local_player, userid, item, weptype = client.GetLocalPlayerIndex(), Event:GetInt('userid'), Event:GetString('item'), Event:GetInt('weptype');


   if (local_player == client.GetPlayerIndexByUserID(userid)) then
       if (item == "taser" ) then
          is_taser=true;
          is_knife=false;
       elseif (item=="knife")then
       is_knife=true;
        is_taser=false;
       else 
       is_knife=false;
           is_taser=false;
       end
   end
end
client.AllowListener('item_equip');
callbacks.Register("FireGameEvent", "on_item_equip", on_item_equip);
local function on_paint()
if ActiveCheckBox:GetValue() then
   local local_player = entities.GetLocalPlayer();
   local curtime = globals.CurTime()
   local ranges
   local ranges_opacities
   if  is_taser then
       ranges = {167}
       ranges_opacities = {1}
elseif is_knife then
       ranges = {32}
       ranges_opacities = {1}
   end
   if ranges == nil then
       return
   end
    local Entity = entities.GetLocalPlayer();
     local Alive = Entity:IsAlive();
     if (Alive ~=true) then
     return
     
     end
   local local_x, local_y, local_z = Entity:GetAbsOrigin()

   local_z=local_z+50

   local vo_z = Entity:GetProp("localdata", "m_vecViewOffset[2]")
local range
local range2 
fade_multiplier = 1
if (Tyleline:GetValue() ==0) then
   for i=1, #ranges do
       range2=  ranges[i]
       range = ranges[i]
       
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
                
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, local_z+vo_z+20)


           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
        if gui.GetValue("vis_thirdperson_dist")==0 then
        temp_z=temp_z-50
        end
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range2-range))
    
    
    
           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
           if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
else 
   for i=1, #ranges do
       range2=  ranges[i]
       range = ranges[i]
       end
       
   while range >5 do
   for i=1, #ranges do
   
       
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, temp_z)

           --local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range2-range))

           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
                   if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
       for i=1, #ranges do
   
   
       local opacity_multiplier = ranges_opacities[i] * fade_multiplier

       local previous_world_x, previous_world_y

       for rot=0, 360, accuracy do
           local rot_temp = math.rad(rot)
           local temp_x, temp_y, temp_z = local_x + range * math.cos(rot_temp), local_y + range * math.sin(rot_temp), local_z
       
           local fraction, entindex_hit = trace_line_skip_teammates( local_x, local_y, local_z, temp_x, temp_y, temp_z)

           --local fraction_x, fraction_y = local_x+(temp_x-local_x)*fraction, local_y+(temp_y-local_y)*fraction
           local fraction_x, fraction_y = lerp_pos(local_x, local_y, local_z, temp_x, temp_y, temp_z, fraction)
           local world_x, world_y = client.WorldToScreen( fraction_x, fraction_y, temp_z+(range-range2))

           local hue_extra = globals.RealTime() % 8 / 8
           local r, g, b = hsv_to_rgb(rot/360+hue_extra, 1, 1, 255)

           local fraction_multiplier = 1
           if fraction > 0.9 then
               fraction_multiplier = 0.6
           end

           if world_x ~= nil and previous_world_x ~= nil then
                   if colortype:GetValue()==1 then
           draw.Color( r, g, b, 255*opacity_multiplier*fraction_multiplier)
           end
               draw.Line( world_x, world_y, previous_world_x, previous_world_y )
           
                        
           end
           previous_world_x, previous_world_y = world_x, world_y
       end
   end
   range =range-10
   end

   

   end
end
end
callbacks.Register( "Draw", "on_paint", on_paint);