client.AllowListener("player_death");

local sounds = {
    "buttons\\arena_switch_press_02.wav", -- to make up for the random selection
    "buttons\\arena_switch_press_02.wav",
    "buttons\\light_power_on_switch_01.wav",
    "advtools\\sounds\\knock.wav",
    "advtools\\sounds\\gnome.mp3",
    "advtools\\sounds\\yoink.wav",
    "advtools\\sounds\\roblox.wav",
    "advtools\\sounds\\minecraft - fall.wav",
    "advtools\\sounds\\minecraft - hit.wav",
    "advtools\\sounds\\mario - jump.wav",
    "advtools\\sounds\\mario - death 1.mp3",
    "advtools\\sounds\\mario - death 2.mp3",
    "advtools\\sounds\\mario - game over.mp3",
};

hitsounds = {
    ["enabled"] = false,
    ["type"] = 0,
    ["sound"] = 0
};

deathsounds = {
    ["enabled"] = false,
    ["local"] = {
        ["enabled"] = false,
        ["sound"] = 0
    },
    ["enemy"] = {
        ["enabled"] = false,
        ["sound"] = 0
    },
    ["team"] = {
        ["enabled"] = false,
        ["sound"] = 0
    }
}

callbacks.Register("FireGameEvent", "Nex.sounds.FGE", function(Event)
    if (Event:GetName() == "player_hurt" and hitsounds["enabled"]) then

        local ME = client.GetLocalPlayerIndex();
    
        local INT_UID = Event:GetInt("userid");
        local INT_ATTACKER = Event:GetInt("attacker");
    
        local NAME_Victim = client.GetPlayerNameByUserID(INT_UID);
        local INDEX_Victim = client.GetPlayerIndexByUserID(INT_UID);
    
        local NAME_Attacker = client.GetPlayerNameByUserID(INT_ATTACKER);
        local INDEX_Attacker = client.GetPlayerIndexByUserID(INT_ATTACKER);
        
        if (INDEX_Attacker == ME and INDEX_Victim ~= ME) then
            local file = "lol";

            if (hitsounds["sound"] == 0) then
                math.randomseed(globals.FrameCount());
                file = sounds[math.random(#sounds)];
            else file = sounds[hitsounds["sound"]+1]; end

            client.Command("playvol \"" .. file .. "\" 1", true);
        end
    elseif (Event:GetName() == "player_death" and deathsounds["enabled"]) then

        local LocalPlayer = entities.GetLocalPlayer(); -- local

        local Victim = entities.GetByUserID(Event:GetInt("userid")); -- user ID who died
        local Attacker = entities.GetByUserID(Event:GetInt("attacker"));

        if (Victim) then
            if (Victim:GetIndex() == LocalPlayer:GetIndex() and deathsounds["local"]["enabled"]) then
                if (deathsounds["local"]["sound"] == 0) then
                    math.randomseed(globals.FrameCount());
                    file = sounds[math.random(#sounds)];
                else file = sounds[deathsounds["local"]["sound"]+1]; end

                client.Command("playvol \"" .. file .. "\" 1", true);
            elseif (Victim:GetTeamNumber() == LocalPlayer:GetTeamNumber() and deathsounds["team"]["enabled"]) then
                if (deathsounds["team"]["sound"] == 0) then
                    math.randomseed(globals.FrameCount());
                    file = sounds[math.random(#sounds)];
                else file = sounds[deathsounds["team"]["sound"]+1]; end

                client.Command("playvol \"" .. file .. "\" 1", true);
            elseif (Victim:GetTeamNumber() ~= LocalPlayer:GetTeamNumber() and deathsounds["enemy"]["enabled"]) then
                if (deathsounds["enemy"]["sound"] == 0) then
                    math.randomseed(globals.FrameCount());
                    file = sounds[math.random(#sounds)];
                else file = sounds[deathsounds["enemy"]["sound"]+1]; end

                client.Command("playvol \"" .. file .. "\" 1", true);
            end
        else print("Couldn't get the victim entity so the sound was skipped. This is usually because the entity was dormant."); end
    end
end);