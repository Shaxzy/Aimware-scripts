RunScript("nex.utils.lua");

aa = {
    ["left"] = 0,
    ["right"] = 0,
    ["backwards"] = 0,
    ["forwards"] = 0,
    ["leftback"] = 0,
    ["rightback"] = 0,
    ["leftfront"] = 0,
    ["rightfront"] = 0,
    ["disableDesync"] = false,
    ["desyncStanding"] = 0,
    ["desyncMoving"] = 0,
    ["direction"] = "auto"
};

callbacks.Register("Draw", "Nex.AA.Draw", function()
    if(aa["enabled"] and gui.GetValue("rbot_antiaim_enable")) then
        if (aa["left"] ~= 0) then
            if (input.IsButtonPressed(aa["left"])) then
                if (aa["direction"] == "left") then
                    print(aa["disableDesync"]);
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(aa["desyncStanding"], aa["desyncMoving"]); end
                    NexUtils.AntiAims.SetAuto();
                    aa["direction"] = "auto";
                else
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(0, 0); end
                    if(aa["45style"] ~= 0) then
                        if(aa["45style"] == 2) then
                            NexUtils.AntiAims.SetCustom(-45, true, true);
                        else
                            NexUtils.AntiAims.SetCustom(-45, true, false);
                            NexUtils.AntiAims.SetCustom(-90, false, true);
                        end
                    else NexUtils.AntiAims.SetLeft(); end
                    aa["direction"] = "left";
                end
            end
        end
        if (aa["right"] ~= 0) then
            if (input.IsButtonPressed(aa["right"])) then
                if (aa["direction"] == "right") then
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(aa["desyncStanding"], aa["desyncMoving"]); end
                    NexUtils.AntiAims.SetAuto();
                    aa["direction"] = "auto";
                else
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(0, 0); end
                    if(aa["45style"] ~= 0) then
                        if(aa["45style"] == 2) then
                            NexUtils.AntiAims.SetCustom(45, true, true);
                        else
                            NexUtils.AntiAims.SetCustom(45, true, false);
                            NexUtils.AntiAims.SetCustom(90, false, true);
                        end
                    else NexUtils.AntiAims.SetRight(); end
                    aa["direction"] = "right";
                end
            end
        end
        if (aa["backwards"] ~= 0) then
            if (input.IsButtonPressed(aa["backwards"])) then
                if (aa["direction"] == "backwards") then
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(aa["desyncStanding"], aa["desyncMoving"]); end
                    NexUtils.AntiAims.SetAuto();
                    aa["direction"] = "auto";
                else
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(0, 0); end
                    NexUtils.AntiAims.SetBack();
                    aa["direction"] = "backwards";
                end
            end
        end
        if (aa["forwards"] ~= 0) then
            if (input.IsButtonPressed(aa["forwards"])) then
                if (aa["direction"] == "forwards") then
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(aa["desyncStanding"], aa["desyncMoving"]); end
                    NexUtils.AntiAims.SetAuto();
                    aa["direction"] = "auto";
                else
                    if (aa["disableDesync"]) then NexUtils.AntiAims.SetDesync(0, 0); end
                    NexUtils.AntiAims.SetForward();
                    aa["direction"] = "forwards";
                end
            end
        end

        local color_r, color_g, color_b = 0, 0, 0;
        if(extras["indicators"]["manualaa"]["colortype"] == 0) then
            color_r, color_g, color_b = client.GetConVar("cl_crosshaircolor_r"), client.GetConVar("cl_crosshaircolor_g"), client.GetConVar("cl_crosshaircolor_b");
        elseif(extras["indicators"]["manualaa"]["colortype"] == 1) then
            color_r, color_g, color_b = gui.GetValue("clr_esp_crosshair");
        end

        NexUtils.newFrame();
        if (extras["indicators"]["manualaa"]["enabled"]) then
            if (extras["indicators"]["manualaa"]["style"] == 0) then
                if (aa["direction"] == "left") then
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {color_r, color_g, color_b, 255}, {color_r, color_g, color_b, 255}, 11, 4, 4)
                    if(aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 3) end
                    if(aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 2) end
                    if(aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 1) end
                elseif (aa["direction"] == "right") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 4) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {color_r, color_g, color_b, 255}, {color_r, color_g, color_b, 255}, 11, 4, 3)
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 2) end
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 1) end
                elseif (aa["direction"] == "backwards") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 3) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {color_r, color_g, color_b, 255}, {color_r, color_g, color_b, 255}, 11, 4, 2)
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 1) end           
                elseif (aa["direction"] == "forwards") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 3) end
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 2) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {color_r, color_g, color_b, 255}, {color_r, color_g, color_b, 255}, 11, 4, 1)
                else
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 3) end
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 2) end
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 255}, {color_r, color_g, color_b, 255}, 11, 4, 1) end
                end
            elseif (extras["indicators"]["manualaa"]["style"] == 1) then
                if (aa["direction"] == "left") then
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {color_r, color_g, color_b, 150}, {color_r, color_g, color_b, 150}, 11, 4, 4)
                    if(aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 3) end
                    if(aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 2) end
                    if(aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 1) end
                elseif (aa["direction"] == "right") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 4) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {color_r, color_g, color_b, 150}, {color_r, color_g, color_b, 150}, 11, 4, 3)
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 2) end
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 1) end
                elseif (aa["direction"] == "backwards") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 3) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {color_r, color_g, color_b, 150}, {color_r, color_g, color_b, 150}, 11, 4, 2)
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 1) end           
                elseif (aa["direction"] == "forwards") then
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 3) end
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 2) end
                    NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {color_r, color_g, color_b, 150}, {color_r, color_g, color_b, 150}, 11, 4, 1)
                else
                    if (aa["left"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2-extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 4) end
                    if (aa["right"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2+extras["indicators"]["manualaa"]["distance"], NexUtils.sh/2, {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 3) end
                    if (aa["backwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2+extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 2) end
                    if (aa["forwards"] ~= 0) then NexUtils.draw.TriangleOutline(NexUtils.sw/2, NexUtils.sh/2-extras["indicators"]["manualaa"]["distance"], {255, 255, 255, 150}, {255, 255, 255, 150}, 11, 4, 1) end
                end
            end
        end
    end
end)