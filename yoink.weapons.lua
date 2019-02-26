weapons = {
    ["enabled"] = false,
    ["fakelag"] = {
        ["autosniper"] = 0,
        ["awp"] = 0,
        ["scout"] = 0,
        ["revolver"] = 0,
        ["taser"] = 0,
        ["other"] = 0
    },
    ["delayshot"] = {
        ["autosniper"] = 0,
        ["awp"] = 0,
        ["scout"] = 0,
        ["revolver"] = 0,
        ["taser"] = 0,
        ["other"] = 0
    }
};

client.AllowListener("item_equip");
callbacks.Register("FireGameEvent", "Nex.Fakelag.FGE", function(Event)
    if (Event:GetName() == "item_equip" and weapons["fakelag"]["enabled"]) then
        local LocalPlayer = entities.GetLocalPlayer();

        if (LocalPlayer) then
            local UserID = Event:GetInt("userid");
            local Item = Event:GetString("item");
            
            if (LocalPlayer:GetIndex() == client.GetPlayerIndexByUserID(UserID)) then
                if (Item == "gs3g1" or Item == "scar20") then
                    if(weapons["fakelag"]["autosniper"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["autosniper"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["autosniper"]);
                elseif (Item == "awp") then
                    if(weapons["fakelag"]["awp"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["awp"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["awp"]);
                elseif (Item == "ssg08") then
                    if(weapons["fakelag"]["scout"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["scout"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["scout"]);
                elseif (Item == "deagle") then
                    if(weapons["fakelag"]["revolver"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["revolver"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["revolver"]);
                elseif (Item == "taser") then
                    if(weapons["fakelag"]["taser"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["taser"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["taser"]);
                else
                    if(weapons["fakelag"]["other"] == 0) then gui.SetValue("msc_fakelag_enable", 0);
                    else
                        gui.SetValue("msc_fakelag_enable", 1);
                        gui.SetValue("msc_fakelag_mode", weapons["fakelag"]["other"]-1);
                    end

                    gui.SetValue("rbot_delayshot", weapons["delayshot"]["other"]);
                end
            end
        end
    end
end);