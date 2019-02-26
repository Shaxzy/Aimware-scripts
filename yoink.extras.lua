extras = {
    ["indicators"] = {
        ["ping"] = false,
        ["doubleshot"] = false,
        ["hitchance"] = true,
        ["mindamage"] = false,
        ["aimbotMode"] = false,
        ["manualaa"] = {
            ["enabled"] = false,
            ["style"] = 0,
            ["distance"] = 50,
            ["colortype"] = 0
        }
    },
    ["baimOnDoubleShot"] = false,
    ["engineRadar"] = false,
    ["forceCrosshair"] = false,
    ["tickDefuse"] = 0
};

local lastDoubleShotPress = 0;

-- for last tick defuse
local last_command;
local plant_time = 0;
local bomb_time = 0;
local bomb_remaining = 0;

callbacks.Register("Draw", "Nex.Extras.Draw", function()
    local function canDefuse(Entity)
        if (Entity:GetTeamNumber() == 3) then
            local bomb = entities.FindByClass("CPlantedC4")[1];

            if (bomb) then
                if(bomb:GetAbsOrigin() - Entity:GetAbsOrigin() < 62) then
                    bomb_time = bomb:GetPropFloat("m_flTimerLength");

                    if(bomb_time and bomb_time > 0) then
                        bomb_remaining = (plant_time - globals.CurTime()) + bomb_time;

                        if(bomb_remaining > 0) then
                            return true;
                        end
                    end
                end
            end
        end

        return false;
    end
    local numItems = 1;
    local heightSpacing = 55;
    local widthSpacing = 10;

    local LocalPlayer = entities.GetLocalPlayer();
    if (LocalPlayer) then
        local bomb = entities.FindByClass("CPlantedC4")[1];

        if (extras["indicators"]["ping"]) then
            local color = {};
            local latency = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex());
            
            color = NexUtils.GetLatencyColor(latency, 1);

            draw.Color(color[1], color[2], color[3], 255);
            draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
            text = "PING";
            sw, sh = draw.GetScreenSize();
            tw, th = draw.GetTextSize(text);
            draw.Text(widthSpacing, sh-55-(th/2), text);

            numItems = numItems + 1;
            widthSpacing = widthSpacing + tw + 10;
        end
        
        if (extras["indicators"]["doubleshot"] and gui.GetValue("rbot_chargerapidfire") ~= 0) then
            if (globals.RealTime() > lastDoubleShotPress+10) then
                local doubleshotKey = gui.GetValue("rbot_chargerapidfire");
                if (input.IsButtonPressed(doubleshotKey)) then
                    lastDoubleShotPress = globals.RealTime();
                    draw.Color(0, 255, 0, 255);
                else draw.Color(255, 0, 0, 255); end
            else draw.Color(0, 255, 0, 255); end

            if (extras["baimOnDoubleShot"] and globals.RealTime() < lastDoubleShotPress+10) then
                gui.SetValue("rbot_autosniper_hitbox_head", 0);
                gui.SetValue("rbot_autosniper_hitbox", 4); -- Pelvis
            elseif (globals.RealTime() >= lastDoubleShotPress+10) then
                gui.SetValue("rbot_autosniper_hitbox_head", 1);
                gui.SetValue("rbot_autosniper_hitbox", 0); -- Head
            end
            
            if (extras["indicators"]["doubleshot"]) then
                draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
                text = "DS";
                sw, sh = draw.GetScreenSize();
                tw, th = draw.GetTextSize(text);
                draw.Text(widthSpacing, sh-(heightSpacing)-(th/2), text);

                numItems = numItems + 1;
                widthSpacing = widthSpacing + tw + 10;
            end
        end

        if (extras["indicators"]["tickDefuse"] and extras["tickDefuse"] ~= 0) then
            local bomb = entities.FindByClass("CPlantedC4")[1];

            if (bomb) then
                if (NexUtils.GetDistance(LocalPlayer, bomb) <= 63 and canDefuse(LocalPlayer)) then 
                    draw.Color(255, 255, 0, 255);
                    if (input.IsButtonDown(extras["tickDefuse"])) then draw.Color(0, 255, 0, 255); end
                else draw.Color(255, 0, 0, 255); end
            else draw.Color(255, 0, 0, 255); end

            draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
            text = "DEFUSE";
            sw, sh = draw.GetScreenSize();
            tw, th = draw.GetTextSize(text);
            draw.Text(widthSpacing, sh-(heightSpacing)-(th/2), text);

            numItems = numItems + 1;
            widthSpacing = widthSpacing + tw + 10;
        end

        if (extras["indicators"]["hitchance"] and assistance["hitchance"]["key"] ~= 0) then
            local color = {};

            if (assistance["hitchance"]["current"] == 0) then
                text = "HC: "..assistance["hitchance"]["original"];
                color = {255, 255, 255, 255};
            else
                text = "HC: "..assistance["hitchance"]["modified"];
                color = {255, 0, 255, 255};
            end

            draw.Color(color[1], color[2], color[3], 255);
            draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
            sw, sh = draw.GetScreenSize();
            tw, th = draw.GetTextSize(text);
            draw.Text(10, sh/2, text);

            numItems = numItems + 1;
            widthSpacing = widthSpacing + tw + 10;
        end

        if (extras["indicators"]["mindamage"] and assistance["mindamage"]["key"] ~= 0) then
            local color = {};

            if (assistance["mindamage"]["current"] == 0) then
                text = "DMG: "..assistance["mindamage"]["original"];
                color = {255, 255, 255, 255};
            else
                text = "DMG: "..assistance["mindamage"]["modified"];
                color = {255, 255, 255, 255};
            end

            draw.Color(color[1], color[2], color[3], 255);
            draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
            sw, sh = draw.GetScreenSize();
            tw, th = draw.GetTextSize(text);
            draw.Text(10, sh/2+25, text);

            numItems = numItems + 1;
            widthSpacing = widthSpacing + tw + 10;
        end

        if (extras["indicators"]["aimbotMode"] and assistance["aimbotMode"]["key"] ~= 0) then
            local color = {};
            
            if (assistance["aimbotMode"]["current"] == 0) then
                text = "AM: LEGIT";
                color = {0, 255, 0, 255};
            else
                text = "AM: RAGE";
                color = {255, 0, 255, 255};
            end

            draw.Color(color[1], color[2], color[3], 255);
            draw.SetFont(draw.CreateFont("Tahoma", 25, 800));
            sw, sh = draw.GetScreenSize();
            tw, th = draw.GetTextSize(text);
            draw.Text(10, sh/2+50, text);

            numItems = numItems + 1;
            widthSpacing = widthSpacing + tw + 10;
        end
        
        if (extras["engineRadar"]) then
            for index, Player in pairs(entities.FindByClass("CCSPlayer")) do
                -- because there's no point looping the same value on the
                -- same target over and over again even though its already set
                if(Player:GetPropInt("m_bSpotted") ~= 1) then
                    Player:SetProp("m_bSpotted", 1);
                end
            end
        end

        if (extras["forceCrosshair"]) then
            if (client.GetConVar("weapon_debug_spread_show") ~= 3) then
                client.SetConVar("weapon_debug_spread_show", 3, true);
            end
        end

        if (entities.GetLocalPlayer():IsAlive()) then
            if (extras["tickDefuse"] ~= 0) then
                if (not canDefuse(LocalPlayer)) then
                    if (last_command ~= "-use") then
                        client.Command("-use", true);
                        last_command = "-use";
                    end
                end

                if (input.IsButtonDown(extras["tickDefuse"]) and canDefuse(LocalPlayer)) then
                    local defuse = false;
                    if (LocalPlayer:GetPropBool("m_bHasDefuser") and bomb_remaining <= 5.2) then defuse = true;
                    elseif ((not LocalPlayer:GetPropBool("m_bHasDefuser")) and bomb_remaining <= 10.2) then defuse = true; end

                    if (defuse and last_command ~= "+use") then
                        client.Command("+use", true);
                        last_command = "+use";
                    end
                end
            end
        end
    end
end)

client.AllowListener("bomb_planted");
callbacks.Register("FireGameEvent", "Nex.Extras.FGE", function(Event)
    if (extras["indicators"]["doubleshot"] or extras["baimOnDoubleShot"]) then
        if (Event:GetName() == "weapon_fire") then
            local LocalPlayer = entities.GetLocalPlayer();
            local Shooter = entities.GetByUserID(Event:GetInt("userid"));

            if (Shooter) then
                if (Shooter:GetIndex() == LocalPlayer:GetIndex() and globals.RealTime() < lastDoubleShotPress+10) then lastDoubleShotPress = 0; end
            end
        end
    end

    if(Event:GetName() == "bomb_planted") then
        plant_time = globals.CurTime();
        bomb_time = 0;
        bomb_remaining = 0;
        last_command = "";
    end
end)