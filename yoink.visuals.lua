RunScript("nex.utils.lua");

visuals = {
    ["modulation"] = {
        ["r"] = 0,
        ["g"] = 0,
        ["b"] = 0
    },
    ["local"] = {
        ["latency"] = false,
        ["stats"] = false,
        ["velocity"] = false,
        ["vulnerable"] = false
    },
    ["enemy"] = {
        ["latency"] = false,
        ["stats"] = false,
        ["velocity"] = false,
        ["vulnerable"] = false
    },
    ["team"] = {
        ["latency"] = false,
        ["stats"] = false,
        ["velocity"] = false,
        ["vulnerable"] = false
    },
    ["grenades"] = {
        ["timer"] = false
    },
    ["other"] = {
        ["bombDamage"] = true
    }
}

callbacks.Register("Draw", "Nex.Visuals.Draw", function()
    if(gui.GetValue("msc_restrict") ~= 1) then
        local r, g, b = client.GetConVar("mat_ambient_light_r"), client.GetConVar("mat_ambient_light_g"), client.GetConVar("mat_ambient_light_b");
        if(r ~= visuals["modulation"]["r"]) then client.SetConVar("mat_ambient_light_r", visuals["modulation"]["r"]/255, true); end
        if(g ~= visuals["modulation"]["g"]) then client.SetConVar("mat_ambient_light_g", visuals["modulation"]["g"]/255, true); end
        if(b ~= visuals["modulation"]["b"]) then client.SetConVar("mat_ambient_light_b", visuals["modulation"]["b"]/255, true); end
    end
end);

callbacks.Register("DrawESP", "Nex.Visuals.DrawESP", function(builder)
    local LocalPlayer = entities.GetLocalPlayer();
    local Entity = builder:GetEntity();

    if (Entity:IsPlayer() and Entity:IsAlive()) then
        if (Entity:GetIndex() == LocalPlayer:GetIndex()) then
            if (visuals["local"]["latency"]) then DrawLatency(Entity, builder); end
            if (visuals["local"]["stats"]) then DrawStats(Entity, builder); end
            if (visuals["local"]["velocity"]) then DrawVelocity(Entity, builder); end
            if (visuals["local"]["vulnerable"]) then DrawVulnerable(Entity, builder); end
            if (visuals["local"]["bombDamage"]) then DrawBombDamage(Entity, builder); end
        elseif (Entity:GetTeamNumber() == LocalPlayer:GetTeamNumber()) then
            if (visuals["team"]["latency"]) then DrawLatency(Entity, builder); end
            if (visuals["team"]["stats"]) then DrawStats(Entity, builder); end
            if (visuals["team"]["velocity"]) then DrawVelocity(Entity, builder); end
            if (visuals["team"]["vulnerable"]) then DrawVulnerable(Entity, builder); end
            if (visuals["team"]["bombDamage"]) then DrawBombDamage(Entity, builder); end
        elseif (Entity:GetTeamNumber() ~= LocalPlayer:GetTeamNumber()) then
            if (visuals["enemy"]["latency"]) then DrawLatency(Entity, builder); end
            if (visuals["enemy"]["stats"]) then DrawStats(Entity, builder); end
            if (visuals["enemy"]["velocity"]) then DrawVelocity(Entity, builder); end
            if (visuals["enemy"]["vulnerable"]) then DrawVulnerable(Entity, builder); end
            if (visuals["enemy"]["bombDamage"]) then DrawBombDamage(Entity, builder); end
        end
    elseif (builder:GetEntity():GetClass() == "CSmokeGrenadeProjectile" and visuals["grenades"]["timer"]) then
        DrawSmokeTimer(Entity, builder);
    end
        
end);

function DrawBombDamage(Entity, Builder)
    if (visuals["other"]["bombDamage"]) then
        if (entities.FindByClass("CPlantedC4")[1] ~= nil) then
            local Bomb = entities.FindByClass("CPlantedC4")[1];
            if (Bomb:GetProp("m_bBombTicking") and Bomb:GetProp("m_bBombDefused") == 0 and globals.CurTime() < Bomb:GetProp("m_flC4Blow")) then
                local ScreenW, ScreenH = draw.GetScreenSize();
                local Player = Entity;
                HealthToTake = string.format("%.0f", (NexUtils.GetBombDamage(Bomb, Player)));
                HealthLeft = -(string.format("%.1f", (HealthToTake - Player:GetHealth())));
                if (Player:IsAlive() and globals.CurTime() < Bomb:GetProp("m_flC4Blow")) then
                    if (HealthLeft < 1) then
                        draw.Color(255, 0, 0, 255);
                        Builder:AddTextTop("FATAL");
                    else
                        local color = GetHealthColor(HealthLeft);
                        draw.Color(color[1], color[2], color[3], color[4]);
                        Builder:AddTextTop("Survivable ("..math.floor(HealthLeft).." HP)");
                    end
                end
            end
        end
    end
end

function DrawLatency(Entity, Builder)
    local latency = entities.GetPlayerResources():GetPropInt("m_iPing", Entity:GetIndex());
    local color = GetLatencyColor(latency, 1);
    Builder:Color(color[1], color[2], color[3], 255);
    Builder:AddTextBottom(latency.."MS");
    Builder:Color(255, 255, 255, 255);
end

function DrawStats(Entity, Builder)
    local Kills =  entities.GetPlayerResources():GetPropInt("m_iKills", Entity:GetIndex());
    local Deaths =  entities.GetPlayerResources():GetPropInt("m_iDeaths", Entity:GetIndex());
    local HSKills =  Entity:GetPropInt("m_iMatchStats_HeadShotKills");

    -- this is to prevent X.#INF displaying as ratio
    local rDeaths = Deaths;
    if (Deaths == 0) then rDeaths = 1; end

    local Ratio = math.floor((Kills / rDeaths) * (10^(2 or 0)) + 0.5) / (10^(2 or 0));
    if (Ratio >= 3.00) then Builder:Color(255, 20, 147, 255);
    elseif (Ratio >= 2.00) then Builder:Color(0, 255, 0, 255);
    elseif (Ratio >= 1.00) then Builder:Color(255, 255, 0, 255);
    elseif (Ratio < 1.00) then Builder:Color(255, 0, 0, 255);
    else Builder:Color(255, 255, 255, 255); end
    Builder:AddTextBottom("K: "..Kills.." | D: "..Deaths.." | R: "..Ratio);
    Builder:Color(255, 255, 255, 255);
end

function DrawVelocity(Entity, Builder)
    local velocity = GetVelocity(Entity);

    if (velocity > 250) then Builder:Color(255, 0, 0, 255); velocity = velocity;
    elseif (velocity > 20) then Builder:Color(255, 255, 0, 255);
    elseif (velocity >= 120) then Builder:Color(255, 0, 0, 255);
    else Builder:Color(0, 255, 0, 255); end

    Builder:AddTextBottom("Velocity: "..velocity);
    Builder:Color(255, 255, 255, 255);
end

function DrawVulnerable(Entity, Builder)
    local isVulnerable = false;
    local exText = "";
    local exColor = {255, 255, 255, 255};

    local velocity = GetVelocity(Entity);
    local LocalPlayer = entities.GetLocalPlayer();

    --draw.SetFont(draw.CreateFont("D3 Littlebitmapism Round", 11, 300));
    if (LocalPlayer and LocalPlayer:IsAlive()) then
        if (Entity:GetHealth() <= 50) then
            isVulnerable = true;
            Builder:Color(100, 100, 0, 255);
            Builder:AddTextTop("LOW HEALTH");
        end
    end

    if (velocity >= 130 and velocity < 180) then
        isVulnerable = true;
        Builder:Color(255, 255, 0, 255);
        Builder:AddTextTop("WALKING");
    elseif (velocity >= 180 and velocity < 260) then
        isVulnerable = true;
        Builder:Color(0, 104, 255, 255);
        Builder:AddTextTop("RUNNING");
    elseif (velocity >= 260) then
        isVulnerable = true;
        Builder:Color(255, 20, 147, 255);
        Builder:AddTextTop("BHOPPING");
    end

    --draw.SetFont(draw.CreateFont("Tahoma Bold", 12, 200));
end

function DrawSmokeTimer(Entity, Builder)
    local smokeDuration = 18;

    local ticks = Entity:GetPropInt("m_nSmokeEffectTickBegin");
    local triggerTime = globals.TickInterval() * (globals.TickCount() - ticks);

    if (triggerTime > 0 and triggerTime < smokeDuration) then
        local progress = triggerTime / smokeDuration;
        local color = GetTimerColor(100-(progress * 100));
        
        if (smokeDuration-triggerTime <= 2 and entities.GetLocalPlayer()) then
            if (entities.GetLocalPlayer():IsAlive()) then
                local weapon = tostring(entities:GetLocalPlayer():GetPropEntity("m_hActiveWeapon"));
                if (weapon == "molotov" or weapon == "incgrenade") then
                    Builder:Color(0, 255, 0, 255); 
                    Builder:AddTextBottom("Burnable");
                else print(weapon); end
            end
        end

        Builder:Color(color[1], color[2], color[3], 255);
        Builder:AddTextBottom(string.format("%.1f s", smokeDuration-triggerTime));
        Builder:AddBarBottom(1-progress);--smokeDuration / (smokeDuration-triggerTime) * 100);
    end
end

function GetLatencyColor(latency, type)
    local color = {};

    if (type == 0) then -- gui value (X.XXX)
        latency = tonumber(math.floor(latency * 1000));
    end

    if (latency <= 50) then
        color = {0, 255, 0, 255}; -- green
    elseif (latency <= 100) then
        color = {50, 255, 0, 255};
    elseif (latency <= 200) then
        color = {100, 255, 0, 255};
    elseif (latency <= 300) then
        color = {150, 255, 0, 255};
    elseif (latency <= 400) then
        color = {200, 255, 0, 255};
    elseif (latency <= 500) then
        color = {255, 255, 0, 255}; -- orange
    elseif (latency <= 600) then
        color = {255, 200, 0, 255}; 
    elseif (latency <= 700) then
        color = {255, 150, 0, 255};
    elseif (latency <= 800) then
        color = {255, 100, 0, 255};
    elseif (latency <= 900) then
        color = {255, 50, 0, 255};
    else
        color = {255, 0, 0, 255}; -- red
    end

    return color;
end

function GetTimerColor(percentage)
    local color = {};
    if (percentage <= 10) then
        color = {0, 255, 0, 255}; -- green
    elseif (percentage <= 20) then
        color = {50, 255, 0, 255};
    elseif (percentage <= 25) then
        color = {100, 255, 0, 255};
    elseif (percentage <= 30) then
        color = {150, 255, 0, 255};
    elseif (percentage <= 40) then
        color = {200, 255, 0, 255};
    elseif (percentage <= 50) then
        color = {255, 255, 0, 255}; -- orange
    elseif (percentage <= 60) then
        color = {255, 200, 0, 255}; 
    elseif (percentage <= 70) then
        color = {255, 150, 0, 255};
    elseif (percentage <= 80) then
        color = {255, 100, 0, 255};
    elseif (percentage <= 90) then
        color = {255, 50, 0, 255};
    else
        color = {255, 0, 0, 255}; -- red
    end

    return color;
end

function GetHealthColor(health)
    local color = {};
    if (health <= 100) then
        color = {0, 255, 0, 255}; -- green
    elseif (health <= 90) then
        color = {50, 255, 0, 255};
    elseif (health <= 80) then
        color = {100, 255, 0, 255};
    elseif (health <= 70) then
        color = {150, 255, 0, 255};
    elseif (health <= 60) then
        color = {200, 255, 0, 255};
    elseif (health <= 50) then
        color = {255, 255, 0, 255}; -- orange
    elseif (health <= 40) then
        color = {255, 200, 0, 255}; 
    elseif (health <= 30) then
        color = {255, 150, 0, 255};
    elseif (health <= 20) then
        color = {255, 100, 0, 255};
    elseif (health <= 10) then
        color = {255, 50, 0, 255};
    else
        color = {255, 0, 0, 255}; -- red
    end

    return color;
end

function GetVelocity(Entity)
    local velocityX = Entity:GetPropFloat("localdata", "m_vecVelocity[0]");
    local velocityY = Entity:GetPropFloat("localdata", "m_vecVelocity[1]");

    local velocity = math.sqrt(velocityX^2 + velocityY^2);
    return tonumber(math.floor(math.min(9999, velocity) + 0.2));
end