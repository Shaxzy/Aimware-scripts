assistance = {
    ["hitchance"] = {
        ["key"] = 0,
        ["original"] = 0,
        ["modified"] = 0,
        ["current"] = 0
    },
    ["mindamage"] = {
        ["key"] = 0,
        ["original"] = 0,
        ["modified"] = 0,
        ["current"] = 0
    },
    ["aimbotMode"] = {
        ["key"] = 0,
        ["legitMode"] = {
            ["lbot_active"] = true,
            ["rbot_active"] = false,
            ["nex_esp_enemy_latency_enable"] = false,
            ["nex_esp_enemy_stats_enable"] = false,
            ["nex_esp_enemy_velocity_enable"] = false,
            ["nex_esp_enemy_vulnerable_enable"] = false,
            ["nex_esp_enemy_bombdamage_enable"] = false,
            ["nex_esp_grenade_timer_enable"] = false,
            ["esp_visibility_enemy"] = 1,
            ["esp_enemy_name"] = false,
            ["esp_enemy_weapon"] = 0,
            ["esp_enemy_skeleton"] = false,
            ["vis_scoperemover"] = 0
        },
        ["rageMode"] = {
            ["lbot_active"] = false,
            ["rbot_active"] = true,
            ["nex_esp_enemy_latency_enable"] = true,
            ["nex_esp_enemy_stats_enable"] = true,
            ["nex_esp_enemy_velocity_enable"] = true,
            ["nex_esp_enemy_vulnerable_enable"] = true,
            ["nex_esp_enemy_bombdamage_enable"] = true,
            ["nex_esp_grenade_timer_enable"] = true,
            ["esp_visibility_enemy"] = 0,
            ["esp_enemy_name"] = true,
            ["esp_enemy_weapon"] = 1,
            ["esp_enemy_skeleton"] = true,
            ["vis_scoperemover"] = 2
        },
        ["current"] = 0
    }
}

function SetHitchance(hc)
    gui.SetValue("rbot_shared_hitchance", hc);
    gui.SetValue("rbot_pistol_hitchance", hc);
    gui.SetValue("rbot_revolver_hitchance", hc);
    gui.SetValue("rbot_scout_hitchance", hc);
    gui.SetValue("rbot_autosniper_hitchance", hc);
    gui.SetValue("rbot_sniper_hitchance", hc);
end

function SetMinDamage(dmg)
    gui.SetValue("rbot_shared_mindamage", dmg);
    gui.SetValue("rbot_pistol_mindamage", dmg);
    gui.SetValue("rbot_revolver_mindamage", dmg);
    gui.SetValue("rbot_scout_mindamage", dmg);
    gui.SetValue("rbot_autosniper_mindamage", dmg);
    gui.SetValue("rbot_sniper_mindamage", dmg);
end

function SetAimbotMode(tb)
    for k, v in pairs(tb) do
        gui.SetValue(k, v);
    end
end

callbacks.Register("Draw", "Nex.Assist.Draw", function()
    if (assistance["hitchance"]["key"] ~= 0 and input.IsButtonPressed(assistance["hitchance"]["key"])) then
        if (assistance["hitchance"]["current"] == 0) then
            SetHitchance(assistance["hitchance"]["modified"]);
            assistance["hitchance"]["current"] = 1;
        else
            SetHitchance(assistance["hitchance"]["original"]);
            assistance["hitchance"]["current"] = 0;
        end
    end

    if (assistance["mindamage"]["key"] ~= 0 and input.IsButtonPressed(assistance["mindamage"]["key"])) then
        if (assistance["mindamage"]["current"] == 0) then
            SetMinDamage(assistance["mindamage"]["modified"]);
            assistance["mindamage"]["current"] = 1;
        else
            SetMinDamage(assistance["mindamage"]["original"]);
            assistance["mindamage"]["current"] = 0;
        end
    end

    if (assistance["aimbotMode"]["key"] ~= 0 and input.IsButtonPressed(assistance["aimbotMode"]["key"])) then
        if (assistance["aimbotMode"]["current"] == 0) then
            SetAimbotMode(assistance["aimbotMode"]["rageMode"]);
            assistance["aimbotMode"]["current"] = 1;
        else
            SetAimbotMode(assistance["aimbotMode"]["legitMode"]);
            assistance["aimbotMode"]["current"] = 0;
        end
    end
end);