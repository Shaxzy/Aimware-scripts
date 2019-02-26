client.AllowListener("round_start");
client.AllowListener("player_hurt");
client.AllowListener("item_purchase");
client.AllowListener("bomb_beginplant");
client.AllowListener("bomb_abortplant");
client.AllowListener("bomb_planted");
client.AllowListener("bomb_begindefuse");
client.AllowListener("bomb_abortdefuse");
client.AllowListener("bomb_defused");
client.AllowListener("bomb_exploded");

function HitGroup(INT_HITGROUP)
    if INT_HITGROUP == nil then 
        return;
    elseif INT_HITGROUP == 0 then
        return "body";
    elseif INT_HITGROUP == 1 then
        return "head";
    elseif INT_HITGROUP == 2 then
        return "chest";
    elseif INT_HITGROUP == 3 then
        return "stomach";
    elseif INT_HITGROUP == 4 then 
        return "left arm";
    elseif INT_HITGROUP == 5 then 
        return "right arm";
    elseif INT_HITGROUP == 6 then 
        return "left leg";
    elseif INT_HITGROUP == 7 then 
        return "right leg";
    elseif INT_HITGROUP == 10 then 
        return "body";
    else
        return "unknown";
    end
end

local ents = {};
local prefix = "[AIMWARE]";
local logs = {};
local delay = 5;
local spacing = 15;
local nameCharLimit = 15;
local textOffsetX = 5;
local textOffsetY = 2;

events = {
    ["enabled"] = false,
    ["purchases"] = false,
    ["purchaseDelay"] = 1,
    ["damages"] = false,
    ["damageDelay"] = 5,
    ["bombActivity"] = false,
    ["bombActivityDelay"] = 5,
    ["color_r"] = 0,
    ["color_g"] = 0,
    ["color_b"] = 0
}

callbacks.Register("FireGameEvent", "Nex.Events.FGE", function(Event)
    if (events["enabled"]) then

        local eventType = Event:GetName();
        local pLocal = client.GetLocalPlayerIndex();

        local Victim = entities.GetByIndex(client.GetPlayerIndexByUserID(Event:GetInt("userid")));

        if (eventType == "player_hurt" and events["damages"]) then
            local iAttacker = client.GetPlayerIndexByUserID(Event:GetInt("attacker"));
            local victimName = client.GetPlayerNameByUserID(Event:GetInt("userid"));

            if (Victim) then remainingHealth = Victim:GetHealth()-Event:GetInt("dmg_health");
            else
                if (ents[victimName]) then remainingHealth = ents[victimName]-Event:GetInt("dmg_health");
                else remainingHealth = 0; end
            end

            if (remainingHealth < 0) then remainingHealth = 0; end

            local logObj = {
                ["time"] = globals.RealTime(),
                ["type"] = eventType,
                ["name"] = client.GetPlayerNameByUserID(Event:GetInt("userid")),
                ["hitbox"] = HitGroup(Event:GetInt("hitgroup")),
                ["damage"] = Event:GetInt("dmg_health"),
                ["remaining"] = remainingHealth,
                ["delay"] = events["damageDelay"],

                -- for the fade out animations, I was going to implement the "slide out" meme but that would be too much for a simple event log,
                -- plus, it looks better with just the fade, especially at it's current value
                ["alpha"] = 255
            };
            
            if (pLocal == iAttacker) then
                table.insert(logs, logObj);
                local echoText = prefix .. " Hurt " .. logObj["name"] .. " in the " .. logObj["hitbox"] .. " for " .. logObj["damage"] .. " damage (" .. logObj["remaining"] .. " health remaining)";
                client.Command("echo \"".. echoText .."\"", true);
            end
        elseif (eventType == "item_purchase" and events["purchases"]) then
            local Purchaser = client.GetPlayerIndexByUserID(Event:GetInt("userid"));

            local logObj = {
                ["time"] = globals.RealTime(),
                ["type"] = eventType,
                ["name"] = client.GetPlayerNameByUserID(Event:GetInt("userid")),
                ["weapon"] = Event:GetString("weapon"),
                ["delay"] = events["purchaseDelay"],
                ["alpha"] = 255
            };
            
            table.insert(logs, logObj);
            local echoText = string.format(prefix .. " %s purchased %s", logObj["name"], logObj["weapon"]);
            client.Command("echo \"".. echoText .."\"", true);
        elseif (events["bombActivity"]) then
            if(
            eventType == "bomb_beginplant" or 
            eventType == "bomb_abortplant" or 
            eventType == "bomb_planted" or
            eventType == "bomb_exploded" or
            eventType == "bomb_begindefuse" or 
            eventType == "bomb_abortdefuse" or 
            eventType == "bomb_defused"
            ) then
                local iPlayer = client.GetPlayerIndexByUserID(Event:GetInt("userid"));
                
                local logObj = {
                    ["time"] = globals.RealTime(),
                    ["type"] = eventType,
                    ["name"] = client.GetPlayerNameByUserID(Event:GetInt("userid")),
                    ["site"] = Event:GetInt("site"),
                    ["delay"] = events["bombActivityDelay"],
                    ["alpha"] = 255
                };
                
                table.insert(logs, logObj);
                local echoText = "";

                if (eventType == "bomb_beginplant") then
                    echoText = string.format(prefix .. " %s has begun planting the bomb", logObj["name"]);
                elseif (eventType == "bomb_abortplant") then
                    echoText = string.format(prefix .. " %s has stopped planting the bomb", logObj["name"]);
                elseif (eventType == "bomb_planted") then
                    echoText = string.format(prefix .. " %s has planted the bomb", logObj["name"]);
                elseif (eventType == "bomb_exploded") then
                    echoText = string.format(prefix .. " The bomb has exploded");
                elseif (eventType == "bomb_begindefuse") then
                    echoText = string.format(prefix .. " %s has begun to defuse the bomb", logObj["name"]);
                elseif (eventType == "bomb_abortdefuse") then
                    echoText = string.format(prefix .. " %s has stopped defusing the bomb", logObj["name"]);
                elseif (eventType == "bomb_defused") then
                    echoText = string.format(prefix .. " %s has defused the bomb", logObj["name"]);
                end

                client.Command("echo \"".. echoText .."\"", true);
            elseif (eventType == "round_start") then
                logs = {}
            end
        end
    end
end);

callbacks.Register("Draw", "Nex.Events.Draw", function()
    local numLogs = 0;
    local pLocal = entities.GetLocalPlayer();
    
    -- This is for caching player health. Just in case their entity is dormant which
    -- makes it impossible to get their health as it requires their entity.
    if (pLocal) then
        local players = entities.FindByClass("CCSPlayer");

        for i = 1, #players do
            local Player = players[i];

            if (Player:IsAlive() and Player:GetIndex() ~= pLocal:GetIndex()) then
                ents[Player:GetName()] = Player:GetHealth();
            end
        end
    end

    -- This is for drawing the log itself. I know, it's very messy, but it works and
    -- I honestly cba making it cleaner... fight me.
    for i, log in pairs(logs) do
        draw.SetFont(draw.CreateFont("Tahoma", 13, 300));
        local prefix_w, prefix_h = draw.GetTextSize(prefix);

        if (log["name"]:len() > nameCharLimit) then 
            log["name"] = log["name"]:sub(0, nameCharLimit) .. "...";
        end

        if globals.RealTime() > log["time"] + log["delay"] then
            if (log["alpha"] > 0) then
                local top = numLogs * spacing + textOffsetY;

                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                if (log["type"] == "player_hurt") then
                    local p1, p1_w, p1_h = "Hurt ", draw.GetTextSize("Hurt ");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
    
                    local p3, p3_w, p3_h = "in the ", draw.GetTextSize("in the ");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + 5, top, p3);
    
                    local p4, p4_w, p4_h = log["hitbox"].." ", draw.GetTextSize(log["hitbox"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + 5, top, p4);
    
                    local p5, p5_w, p5_h = "for ", draw.GetTextSize("for ");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + 5, top, p5);
    
                    local p6, p6_w, p6_h = log["damage"].." ", draw.GetTextSize(log["damage"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + 5, top, p6);
    
                    local p7, p7_w, p7_h = "damage (", draw.GetTextSize("damage (");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + 5, top, p7);
    
                    local p8, p8_w, p8_h = log["remaining"].." ", draw.GetTextSize(log["remaining"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + p7_w + 5, top, p8);
    
                    local p9, p9_w, p9_h = "remaining)", draw.GetTextSize("remaining)");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + p7_w + p8_w + 5, top, p9);
                elseif (log["type"] == "item_purchase") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "purchased ", draw.GetTextSize("purchased ");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
    
                    local p3, p3_w, p3_h = log["weapon"].." ", draw.GetTextSize(log["weapon"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + 5, top, p3);
                elseif (log["type"] == "bomb_beginplant") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has begun planting the bomb", draw.GetTextSize("has begun planting the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                elseif (log["type"] == "bomb_abortplant") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has stopped planting the bomb", draw.GetTextSize("has stopped planting the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                elseif (log["type"] == "bomb_planted") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has planted the bomb", draw.GetTextSize("has planted the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                elseif (log["type"] == "bomb_exploded") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = "The bomb has exploded", draw.GetTextSize("The bomb has exploded");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
                elseif (log["type"] == "bomb_begindefuse") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has begun to defuse the bomb", draw.GetTextSize("has begun to defuse the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                elseif (log["type"] == "bomb_abortdefuse") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has stopped defusing the bomb", draw.GetTextSize("has stopped defusing the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                elseif (log["type"] == "bomb_defused") then
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX, top, prefix);
    
                    local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                    draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
    
                    local p2, p2_w, p2_h = "has defused the bomb", draw.GetTextSize("has defused the bomb");
                    draw.Color(255, 255, 255, log["alpha"]);
                    draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
                end
                
                numLogs = numLogs + 1;
                log["alpha"] = log["alpha"] - 5;
            else
                table.remove(logs, i);
            end
        else
            local top = numLogs * spacing + textOffsetY;

            draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
            draw.TextShadow(textOffsetX, top, prefix);

            if (log["type"] == "player_hurt") then
                local p1, p1_w, p1_h = "Hurt ", draw.GetTextSize("Hurt ");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);

                local p3, p3_w, p3_h = "in the ", draw.GetTextSize("in the ");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + 5, top, p3);

                local p4, p4_w, p4_h = log["hitbox"].." ", draw.GetTextSize(log["hitbox"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + 5, top, p4);

                local p5, p5_w, p5_h = "for ", draw.GetTextSize("for ");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + 5, top, p5);

                local p6, p6_w, p6_h = log["damage"].." ", draw.GetTextSize(log["damage"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + 5, top, p6);

                local p7, p7_w, p7_h = "damage (", draw.GetTextSize("damage (");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + 5, top, p7);

                local p8, p8_w, p8_h = log["remaining"].." ", draw.GetTextSize(log["remaining"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + p7_w + 5, top, p8);

                local p9, p9_w, p9_h = "remaining)", draw.GetTextSize("remaining)");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + p3_w + p4_w + p5_w + p6_w + p7_w + p8_w + 5, top, p9);
            elseif (log["type"] == "item_purchase") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "purchased ", draw.GetTextSize("purchased ");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);

                local p3, p3_w, p3_h = log["weapon"].." ", draw.GetTextSize(log["weapon"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + p2_w + 5, top, p3);
            elseif (log["type"] == "bomb_beginplant") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has begun planting the bomb", draw.GetTextSize("has begun planting the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            elseif (log["type"] == "bomb_abortplant") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has stopped planting the bomb", draw.GetTextSize("has stopped planting the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            elseif (log["type"] == "bomb_planted") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has planted the bomb", draw.GetTextSize("has planted the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            elseif (log["type"] == "bomb_exploded") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = "The bomb has exploded", draw.GetTextSize("The bomb has exploded");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);
            elseif (log["type"] == "bomb_begindefuse") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has begun to defuse the bomb", draw.GetTextSize("has begun to defuse the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            elseif (log["type"] == "bomb_abortdefuse") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has stopped defusing the bomb", draw.GetTextSize("has stopped defusing the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            elseif (log["type"] == "bomb_defused") then
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX, top, prefix);

                local p1, p1_w, p1_h = log["name"].." ", draw.GetTextSize(log["name"].." ");
                draw.Color(events["color_r"], events["color_g"], events["color_b"], log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + 5, top, p1);

                local p2, p2_w, p2_h = "has defused the bomb", draw.GetTextSize("has defused the bomb");
                draw.Color(255, 255, 255, log["alpha"]);
                draw.TextShadow(textOffsetX + prefix_w + p1_w + 5, top, p2);
            end
            
            numLogs = numLogs + 1;
        end
    end
end);