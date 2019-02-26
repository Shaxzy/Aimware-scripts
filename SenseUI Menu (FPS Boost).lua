-- Check if SenseUI was loaded.--- SenseUI Menu by uglych discord is Uglych#1515
if SenseUI == nil then
	RunScript( "senseui.lua" );
end

configs = {}

local selected = 1
local scroll = 0

local configname = ""

local load_pressed = false
local save_pressed = false
local add_pressed = false
local remove_pressed = false

local old_load_pressed, old_save_pressed, old_add_pressed, old_remove_pressed

local pselect = 1;
local aa_choose = 1;
local weapon_select = 1;
-------------- for normal work
local window_moveable = true;
local bind_button = SenseUI.Keys.home;
local bind_active = false;
local bind_detect = SenseUI.KeyDetection.on_hotkey;
local show_gradient = true;
local window_bkey = SenseUI.Keys.delete;
local window_bact = false;
local window_bdet = SenseUI.KeyDetection.on_hotkey;

local enemy_flags	= {
	["Has C4"] = gui.GetValue("esp_enemy_hasc4"),
	["Has Defuser"] = gui.GetValue("esp_enemy_hasdefuser"),
	["Is Defusing"] = gui.GetValue("esp_enemy_defusing"),
	["Is Flashed"] = gui.GetValue("esp_enemy_flashed"),
	["Is Scoped"] = gui.GetValue("esp_enemy_scoped"),
	["Is Reloading"] = gui.GetValue("esp_enemy_reloading"),
	["Competitive Rank"] = gui.GetValue("esp_enemy_comprank"),
	["Money"] = gui.GetValue("esp_enemy_money")
}
local team_flags	= {
	["Has C4"] = gui.GetValue("esp_team_hasc4"),
	["Has Defuser"] = gui.GetValue("esp_team_hasdefuser"),
	["Is Defusing"] = gui.GetValue("esp_team_defusing"),
	["Is Flashed"] = gui.GetValue("esp_team_flashed"),
	["Is Scoped"] = gui.GetValue("esp_team_scoped"),
	["Is Reloading"] = gui.GetValue("esp_team_reloading"),
	["Competitive Rank"] = gui.GetValue("esp_team_comprank"),
	["Money"] = gui.GetValue("esp_team_money")
}
local self_flags	= {
	["Has C4"] = gui.GetValue("esp_self_hasc4"),
	["Has Defuser"] = gui.GetValue("esp_self_hasdefuser"),
	["Is Defusing"] = gui.GetValue("esp_self_defusing"),
	["Is Flashed"] = gui.GetValue("esp_self_flashed"),
	["Is Scoped"] = gui.GetValue("esp_self_scoped"),
	["Is Reloading"] = gui.GetValue("esp_self_reloading"),
	["Competitive Rank"] = gui.GetValue("esp_self_comprank"),
	["Money"] = gui.GetValue("esp_self_money")
}
local removals = {
	["Flash"] = gui.GetValue("vis_noflash"),
	["Smoke"] = gui.GetValue("vis_nosmoke"),
	["Recoil"] = gui.GetValue("vis_norecoil")
}
local render = {
	["Teammate"] = gui.GetValue("vis_norender_teammates"),
	["Enemy"] = gui.GetValue("vis_norender_enemies"),
	["Weapon"] = gui.GetValue("vis_norender_weapons"),
	["Ragdoll"] = gui.GetValue("vis_norender_ragdolls")
}
local pistol_hitboxes = {
	["Head"] = gui.GetValue("rbot_pistol_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_pistol_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_pistol_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_pistol_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_pistol_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_pistol_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_pistol_hitbox_legs")
}
local revolver_hitboxes = {
	["Head"] = gui.GetValue("rbot_revolver_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_revolver_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_revolver_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_revolver_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_revolver_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_revolver_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_revolver_hitbox_legs")
}
local smg_hitboxes = {
	["Head"] = gui.GetValue("rbot_smg_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_smg_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_smg_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_smg_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_smg_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_smg_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_smg_hitbox_legs")
}
local rifle_hitboxes = {
	["Head"] = gui.GetValue("rbot_rifle_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_rifle_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_rifle_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_rifle_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_rifle_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_rifle_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_rifle_hitbox_legs")
}
local shotgun_hitboxes = {
	["Head"] = gui.GetValue("rbot_shotgun_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_shotgun_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_shotgun_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_shotgun_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_shotgun_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_shotgun_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_shotgun_hitbox_legs")
}
local scout_hitboxes = {
	["Head"] = gui.GetValue("rbot_scout_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_scout_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_scout_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_scout_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_scout_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_scout_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_scout_hitbox_legs")
}
local autosniper_hitboxes = {
	["Head"] = gui.GetValue("rbot_autosniper_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_autosniper_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_autosniper_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_autosniper_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_autosniper_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_autosniper_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_autosniper_hitbox_legs")
}
local sniper_hitboxes = {
	["Head"] = gui.GetValue("rbot_sniper_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_sniper_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_sniper_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_sniper_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_sniper_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_sniper_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_sniper_hitbox_legs")
}
local lmg_hitboxes = {
	["Head"] = gui.GetValue("rbot_lmg_hitbox_head"),
	["Neck"] = gui.GetValue("rbot_lmg_hitbox_neck"),
	["Chest"] = gui.GetValue("rbot_lmg_hitbox_chest"),
	["Stomach"] = gui.GetValue("rbot_lmg_hitbox_stomach"),
	["Pelvis"] = gui.GetValue("rbot_lmg_hitbox_pelvis"),
	["Arms"] = gui.GetValue("rbot_lmg_hitbox_arms"),
	["Legs"] = gui.GetValue("rbot_lmg_hitbox_legs")
}
local pistol_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_pistol_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_pistol_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_pistol_hitbox_optbacktrack")
}
local revolver_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_revolver_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_revolver_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_revolver_hitbox_optbacktrack")
}
local smg_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_smg_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_smg_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_smg_hitbox_optbacktrack")
}
local rifle_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_rifle_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_rifle_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_rifle_hitbox_optbacktrack")
}
local shotgun_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_shotgun_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_shotgun_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_shotgun_hitbox_optbacktrack")
}
local scout_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_scout_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_scout_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_scout_hitbox_optbacktrack")
}
local autosniper_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_autosniper_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_autosniper_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_autosniper_hitbox_optbacktrack")
}
local sniper_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_sniper_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_sniper_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_sniper_hitbox_optbacktrack")
}
local lmg_optimization = {
	["Adaptive hitboxes"] = gui.GetValue("rbot_lmg_hitbox_adaptive"),
	["Nearby points"] = gui.GetValue("rbot_lmg_hitbox_optpoints"),
	["Backtracking"] = gui.GetValue("rbot_lmg_hitbox_optbacktrack")
}
local condition_aa = {
	["Dormant"] = gui.GetValue("rbot_antiaim_on_dormant"),
	["On freeze period"] = gui.GetValue("rbot_antiaim_on_freezeperiod"),
	["On grenades"] = gui.GetValue("rbot_antiaim_on_grenades"),
	["On knife"] = gui.GetValue("rbot_antiaim_on_knife"),
	["On use"] = gui.GetValue("rbot_antiaim_on_use"),
	["On ladder"] = gui.GetValue("rbot_antiaim_ladder")
}

SenseUI.EnableLogs = false;

function draw_callback()
	if SenseUI.BeginWindow( "wnd1", 50, 50, 620, 670) then
		SenseUI.DrawTabBar();

		if show_gradient then
			SenseUI.AddGradient();
		end
		SenseUI.SetWindowDrawTexture( false ); -- Makes huge fps drop. Not recommended to use yet
		SenseUI.SetWindowMoveable( window_moveable );
		SenseUI.SetWindowOpenKey( window_bkey );

		if SenseUI.BeginTab( "aimbot", SenseUI.Icons.rage ) then
			if SenseUI.BeginGroup( "mainaim", "Aimbot", 25, 25, 235, 275 ) then
				local switch_enabled = gui.GetValue("rbot_active");
				switch_enabled = SenseUI.Checkbox( "Enabled", switch_enabled );
				if switch_enabled then
					gui.SetValue("rbot_active", 1);
					gui.SetValue("rbot_enable", 1);
					else
					gui.SetValue("rbot_enable", 0);
					gui.SetValue("rbot_active", 0);
				end
				local fov_rr = gui.GetValue("rbot_fov");
				fov_rr = SenseUI.Slider("FOV range", 0, 180, "°", "0°", "180°", false, fov_rr);
				gui.SetValue("rbot_fov", fov_rr);
				local s_limit = (gui.GetValue("rbot_speedlimit") + 1);
				SenseUI.Label("Speed limit");
				s_limit = SenseUI.Combo("Speed limit", { "Off", "On", "Auto" }, s_limit);
				gui.SetValue("rbot_speedlimit", s_limit-1);
				SenseUI.Label("Silent aim");
				local sa_rage = (gui.GetValue("rbot_silentaim") + 1);
				sa_rage = SenseUI.Combo("Sa_rage", { "Off", "Client-side", "Server-side" }, sa_rage);
				gui.SetValue("rbot_silentaim", sa_rage-1);
				local ff_rage = gui.GetValue("rbot_team");
				ff_rage = SenseUI.Checkbox("Friendly fire", ff_rage);
				gui.SetValue("rbot_team", ff_rage);
				local aimlock = gui.GetValue("rbot_aimlock");
				aimlock = SenseUI.Checkbox("Aim lock", aimlock);
				gui.SetValue("rbot_aimlock", aimlock);
				SenseUI.Label("Position adjustment");
				local pa_rage = (gui.GetValue("rbot_positionadjustment") + 1);
				pa_rage = SenseUI.Combo("PA_rage", { "Off", "Low", "Medium", "High", "Very high", "Adaptive", "Last record" }, pa_rage);
				gui.SetValue("rbot_positionadjustment", pa_rage-1);
				local override_resolver = gui.GetValue("rbot_resolver_override");
				local resolver = gui.GetValue("rbot_resolver");
				resolver = SenseUI.Checkbox("Resolver", resolver);
				gui.SetValue("rbot_resolver", resolver);
				override_resolver = SenseUI.Bind("rrresolv", true, override_resolver);
				gui.SetValue("rbot_resolver_override", override_resolver);
				local taser_hc = gui.GetValue("rbot_taser_hitchance");
				taser_hc = SenseUI.Slider("Taser hit chance", 0, 100, "%", "0%", "100%", false, taser_hc);
				gui.SetValue("rbot_taser_hitchance", taser_hc);
				SenseUI.EndGroup();
			end
			if SenseUI.BeginGroup( "otheraim", "Other", 285, 25, 235, 210 ) then
				local autorevolver = gui.GetValue("rbot_revolver_autocock");
				local autoawpbody = gui.GetValue("rbot_sniper_autoawp");
				local autopistol = gui.GetValue("rbot_pistol_autopistol");
				local autoscope = 3;
				local nospread = gui.GetValue("rbot_antispread");
				nospread = SenseUI.Checkbox("Remove spread", nospread, true);
				gui.SetValue("rbot_antispread", nospread);
				local norecoil = gui.GetValue("rbot_antirecoil");
				norecoil = SenseUI.Checkbox("Remove recoil", norecoil);
				gui.SetValue("rbot_antirecoil", norecoil);
				SenseUI.Label("Accuracy boost");	
				local delayshot = (gui.GetValue("rbot_delayshot") + 1);				
				delayshot = SenseUI.Combo("DS_rage", { "Off", "Accurate unlag", "Accurate history" }, delayshot);
				gui.SetValue("rbot_delayshot", delayshot-1);
				SenseUI.Label("Double tap", true);
				local doubletap = gui.GetValue("rbot_chargerapidfire");
				doubletap = SenseUI.Bind("doubletapss", true, doubletap);
				gui.SetValue("rbot_chargerapidfire", doubletap);
				SenseUI.Label("Auto scope");
				autoscope = SenseUI.Combo("az_rage", { "Off", "On - auto unzoom", "On - no unzoom" }, autoscope);
				gui.SetValue("rbot_autosniper_autoscope", autoscope-1);
				gui.SetValue("rbot_sniper_autoscope", autoscope-1);
				gui.SetValue("rbot_scout_autoscope", autoscope-1);
				autorevolver = SenseUI.Checkbox("Auto revolver", autorevolver);
				gui.SetValue("rbot_revolver_autocock", autorevolver);
				autoawpbody = SenseUI.Checkbox("AWP body", autoawpbody);
				gui.SetValue("rbot_sniper_autoawp", autoawpbody);
				autopistol = SenseUI.Checkbox("Auto pistol", autopistol);
				gui.SetValue("rbot_pistol_autopistol", autopistol);
				SenseUI.EndGroup();
			end
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "antiaim", SenseUI.Icons.antiaim ) then
			if SenseUI.BeginGroup( "antiaim main", "Anti-Aim Main", 25, 25, 235, 295 ) then
				local aa_enable = gui.GetValue("rbot_antiaim_enable");
				aa_enable = SenseUI.Checkbox("Enable AA", aa_enable);
				gui.SetValue("rbot_antiaim_enable", aa_enable);
				SenseUI.Label("At targets");
				local attargets = (gui.GetValue("rbot_antiaim_at_targets") + 1);
				attargets = SenseUI.Combo("attargets_rage", { "Off", "Average", "Closest" }, attargets);
				gui.SetValue("rbot_antiaim_at_targets", attargets-1);
				SenseUI.Label("Auto direction");
				local adirection = (gui.GetValue("rbot_antiaim_autodir") + 1); 
				adirection = SenseUI.Combo("adirection_rage", { "Off", "Default", "Desync", "Desync jitter" }, adirection);
				gui.SetValue("rbot_antiaim_autodir", adirection-1);
				local jitter_r = gui.GetValue("rbot_antiaim_jitter_range");
				jitter_r = SenseUI.Slider("Jitter range", 0, 180, "°", "0°", "180°", false, jitter_r);
				gui.SetValue("rbot_antiaim_jitter_range", jitter_r);
				local spinbot_s = (gui.GetValue("rbot_antiaim_spinbot_speed") * 10);
				spinbot_s = SenseUI.Slider("Spinbot speed", -200, 200, "", "-20", "20", false, spinbot_s);
				gui.SetValue("rbot_antiaim_spinbot_speed", spinbot_s / 10);
				local speedswitch = (gui.GetValue("rbot_antiaim_switch_speed") * 100);
				speedswitch = SenseUI.Slider("Switch speed", 0, 100, "%", "0%", "100%", false, speedswitch);
				gui.SetValue("rbot_antiaim_switch_speed", speedswitch / 100);
				local switch_r = gui.GetValue("rbot_antiaim_switch_range");
				switch_r = SenseUI.Slider("Switch range", 0, 180, "°", "0°", "180°", false, switch_r);
				gui.SetValue("rbot_antiaim_switch_range", switch_r);
				SenseUI.Label("Fake duck bind");
				local fakeduck_bind = gui.GetValue("rbot_antiaim_fakeduck");
				fakeduck_bind = SenseUI.Bind("fduck", true, fakeduck_bind);
				gui.SetValue("rbot_antiaim_fakeduck", fakeduck_bind);
				condition_aa = SenseUI.MultiCombo("Working", { "On use", "On freeze period", "On grenades", "On knife", "On ladder", "Dormant" }, condition_aa);
				gui.SetValue("rbot_antiaim_on_dormant", condition_aa["Dormant"]);
				gui.SetValue("rbot_antiaim_on_freezeperiod", condition_aa["On freeze period"]);
				gui.SetValue("rbot_antiaim_on_grenades", condition_aa["On grenades"]);
				gui.SetValue("rbot_antiaim_on_knife", condition_aa["On knife"]);
				gui.SetValue("rbot_antiaim_on_use", condition_aa["On use"]);
				gui.SetValue("rbot_antiaim_ladder", condition_aa["On ladder"]);
				SenseUI.EndGroup();
			end
			if SenseUI.BeginGroup( "anti-aim", "Anti-Aim", 285, 25, 235, 285 ) then
				SenseUI.Label("AA Mode Choose");
				aa_choose = SenseUI.Combo( "aa_choose_rage", { "Stand", "Move", "Edge" }, aa_choose);
				if aa_choose == 1 then
					SenseUI.Label("Pitch");
					local pitch_stand = (gui.GetValue("rbot_antiaim_stand_pitch_real") + 1);
					pitch_stand = SenseUI.Combo( "pitch_rage_stand", { "Off", "Emotion", "Down", "Up", "Zero", "Mixed", "Custom" }, pitch_stand);
					gui.SetValue("rbot_antiaim_stand_pitch_real", pitch_stand-1);
					local custom_pitch = gui.GetValue("rbot_antiaim_stand_pitch_custom");
					custom_pitch = SenseUI.Slider( "Custom pitch", -180, 180, "°", "0°", "180°", false, custom_pitch);
					gui.SetValue("rbot_antiaim_stand_pitch_custom", custom_pitch);
					SenseUI.Label("Yaw");
					local yaw_stand = (gui.GetValue("rbot_antiaim_stand_real") + 1);
					yaw_stand = SenseUI.Combo( "just choose2", { "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch" }, yaw_stand);
					gui.SetValue("rbot_antiaim_stand_real", yaw_stand-1);
					local custom_yaw = gui.GetValue("rbot_antiaim_stand_real_add");
					custom_yaw = SenseUI.Slider( "Custom yaw", -180, 180, "°", "0°", "180°", false, custom_yaw);
					gui.SetValue("rbot_antiaim_stand_real_add", custom_yaw);
					SenseUI.Label("Yaw desync");
					local desync_stand = (gui.GetValue("rbot_antiaim_stand_desync") + 1);
					desync_stand = SenseUI.Combo( "just choose3", { "Off", "Still", "Balance", "Stretch", "Jitter" }, desync_stand);
					gui.SetValue("rbot_antiaim_stand_desync", desync_stand-1);
					local stand_velocity = gui.GetValue("rbot_antiaim_stand_velocity");
					stand_velocity = SenseUI.Slider( "Stand Velocity Treshold", 0, 250, "", "0.1", "250", false, stand_velocity);
					gui.SetValue("rbot_antiaim_stand_velocity", stand_velocity);
				else if aa_choose == 2 then
					SenseUI.Label("Pitch");
					local pitch_move = (gui.GetValue("rbot_antiaim_move_pitch_real") + 1);
					pitch_move = SenseUI.Combo( "just choose4", { "Off", "Emotion", "Down", "Up", "Zero", "Mixed", "Custom" }, pitch_move);
					gui.SetValue("rbot_antiaim_move_pitch_real", pitch_move-1);
					local custom_pitch_move = gui.GetValue("rbot_antiaim_move_pitch_custom");
					custom_pitch_move = SenseUI.Slider( "Custom pitch", -180, 180, "°", "0°", "180°", false, custom_pitch_move);
					gui.SetValue("rbot_antiaim_move_pitch_custom", custom_pitch_move);
					SenseUI.Label("Yaw");
					local yaw_move = (gui.GetValue("rbot_antiaim_move_real") + 1);
					yaw_move = SenseUI.Combo( "just choose5", { "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch" }, yaw_move);
					gui.SetValue("rbot_antiaim_move_real", yaw_move-1);
					local custom_yaw_move = gui.GetValue("rbot_antiaim_move_real_add");
					custom_yaw_move = SenseUI.Slider( "Custom yaw", -180, 180, "°", "0°", "180°", false, custom_yaw_move);
					gui.SetValue("rbot_antiaim_move_real_add", custom_yaw_move);
					SenseUI.Label("Yaw desync");
					local desync_move = (gui.GetValue("rbot_antiaim_move_desync") + 1);
					desync_move = SenseUI.Combo( "just choose6", { "Off", "Still", "Balance", "Stretch", "Jitter" }, desync_move);
					gui.SetValue("rbot_antiaim_move_desync", desync_move-1);
				else if aa_choose == 3 then
					local desync_edge = (gui.GetValue("rbot_antiaim_edge_desync") + 1);
					local custom_pitch_edge = gui.GetValue("rbot_antiaim_edge_pitch_custom");
					local custom_yaw_edge = gui.GetValue("rbot_antiaim_edge_real_add");
					SenseUI.Label("Pitch");
					local pitch_edge = (gui.GetValue("rbot_antiaim_edge_pitch_real") + 1);
					pitch_edge = SenseUI.Combo( "just choose7", { "Off", "Emotion", "Down", "Up", "Zero", "Mixed", "Custom" }, pitch_edge);
					gui.SetValue("rbot_antiaim_edge_pitch_real", pitch_edge-1);
					custom_pitch_edge = SenseUI.Slider( "Custom pitch", -180, 180, "°", "0°", "180°", false, custom_pitch_edge);
					gui.SetValue("rbot_antiaim_edge_pitch_custom", custom_pitch_edge);
					SenseUI.Label("Yaw");
					local yaw_edge = (gui.GetValue("rbot_antiaim_edge_real") + 1);
					yaw_edge = SenseUI.Combo( "just choose8", { "Off", "Static", "Spinbot", "Jitter", "Zero", "Switch" }, yaw_edge);
					gui.SetValue("rbot_antiaim_edge_real", yaw_edge-1);
					custom_yaw_edge = SenseUI.Slider( "Custom yaw", -180, 180, "°", "0°", "180°", false, custom_yaw_edge);
					gui.SetValue("rbot_antiaim_edge_real_add", custom_yaw_edge);
					SenseUI.Label("Yaw desync");
					desync_edge = SenseUI.Combo( "just choose9", { "Off", "Still", "Balance", "Stretch", "Jitter" }, desync_edge);
					gui.SetValue("rbot_antiaim_edge_desync", desync_edge-1);
				end
				end
				end
				SenseUI.EndGroup();
			end
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "gunsettings", SenseUI.Icons.legit ) then
			if SenseUI.BeginGroup( "gunssettingss", "Main", 25, 25, 235, 485 ) then
				SenseUI.Label("Weapon selection");
				weapon_select = SenseUI.Combo("nvmd_rage", { "Pistol", "Revolver", "SMG", "Rifle", "Shotgun", "Scout", "AutoSniper", "AWP", "LMG" }, weapon_select );
				if weapon_select == 1 then
				
				local p_autowall = (gui.GetValue("rbot_pistol_autowall") + 1);
				local p_hitchance = gui.GetValue("rbot_pistol_hitchance");
				local p_mindamage = gui.GetValue("rbot_pistol_mindamage");
				local p_hitprior = (gui.GetValue("rbot_pistol_hitbox") + 1);
				local p_bodyaim = (gui.GetValue("rbot_pistol_hitbox_bodyaim") + 1);
				local p_method = (gui.GetValue("rbot_pistol_hitbox_method") + 1);
				local p_baimX = gui.GetValue("rbot_pistol_bodyaftershots");
				local p_baimHP = gui.GetValue("rbot_pistol_bodyifhplower");
				local p_hscale = (gui.GetValue("rbot_pistol_hitbox_head_ps") * 100);
				local p_nscale = (gui.GetValue("rbot_pistol_hitbox_neck_ps") * 100);
				local p_cscale = (gui.GetValue("rbot_pistol_hitbox_chest_ps") * 100);
				local p_sscale = (gui.GetValue("rbot_pistol_hitbox_stomach_ps") * 100);
				local p_pscale = (gui.GetValue("rbot_pistol_hitbox_pelvis_ps") * 100);
				local p_ascale = (gui.GetValue("rbot_pistol_hitbox_arms_ps") * 100);
				local p_lscale = (gui.GetValue("rbot_pistol_hitbox_legs_ps") * 100);
				local p_autoscale = gui.GetValue("rbot_pistol_hitbox_auto_ps");
				local p_autoscales = (gui.GetValue("rbot_pistol_hitbox_auto_ps_max") * 100);
				
				SenseUI.Label("Auto wall type");
				p_autowall = SenseUI.Combo("p_autowall", { "Off", "Accurate", "Optimized" }, p_autowall);
				gui.SetValue("rbot_pistol_autowall", p_autowall-1);
				SenseUI.Label("Auto stop");
				local pistol_as = (gui.GetValue("rbot_pistol_autostop") + 1);
				pistol_as = SenseUI.Combo("pistol_as", { "Off", "Full stop", "Minimal speed" }, pistol_as);
				gui.SetValue("rbot_pistol_autostop", pistol_as-1);
				SenseUI.Label("Target selection");
				local pistol_ts = (gui.GetValue("rbot_pistol_mode") + 1);
				pistol_ts = SenseUI.Combo("pistol_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, pistol_ts);
				gui.SetValue("rbot_pistol_mode", pistol_ts-1);
				p_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, p_hitchance);
				gui.SetValue("rbot_pistol_hitchance", p_hitchance);
				p_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, p_mindamage);
				gui.SetValue("rbot_pistol_mindamage", p_mindamage);
				SenseUI.Label("Hitbox priority");
				p_hitprior = SenseUI.Combo("p_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, p_hitprior);
				gui.SetValue("rbot_pistol_hitbox", p_hitprior-1);
				SenseUI.Label("Body aim hitbox");
				p_bodyaim = SenseUI.Combo("p_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, p_bodyaim);
				gui.SetValue("rbot_pistol_hitbox_bodyaim", p_bodyaim-1);
				SenseUI.Label("Hitbox selection method");
				p_method = SenseUI.Combo("p_method", { "Damage", "Accuracy" }, p_method);
				gui.SetValue("rbot_pistol_hitbox_method", p_method-1);
				p_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, p_baimX);
				gui.SetValue("rbot_pistol_bodyaftershots", p_baimX);
				p_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, p_baimHP);
				gui.SetValue("rbot_pistol_bodyifhplower", p_baimHP);
				
				pistol_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, pistol_optimization);
				gui.SetValue("rbot_pistol_hitbox_adaptive", pistol_optimization["Adaptive hitbox"]); 
				gui.SetValue("rbot_pistol_hitbox_optpoints", pistol_optimization["Nearby points"]);
				gui.SetValue("rbot_pistol_hitbox_optbacktrack", pistol_optimization["Backtracking"]);
					else if weapon_select == 2 then
					
					local rev_autowall = (gui.GetValue("rbot_revolver_autowall") + 1);
					local rev_hitchance = gui.GetValue("rbot_revolver_hitchance");
					local rev_mindamage = gui.GetValue("rbot_revolver_mindamage");
					local rev_hitprior = (gui.GetValue("rbot_revolver_hitbox") + 1);
					local rev_bodyaim = (gui.GetValue("rbot_revolver_hitbox_bodyaim") + 1);
					local rev_method = (gui.GetValue("rbot_revolver_hitbox_method") + 1);
					local rev_baimX = gui.GetValue("rbot_revolver_bodyaftershots");
					local rev_baimHP = gui.GetValue("rbot_revolver_bodyifhplower");
					local rev_hscale = (gui.GetValue("rbot_revolver_hitbox_head_ps") * 100);
					local rev_nscale = (gui.GetValue("rbot_revolver_hitbox_neck_ps") * 100);
					local rev_cscale = (gui.GetValue("rbot_revolver_hitbox_chest_ps") * 100);
					local rev_sscale = (gui.GetValue("rbot_revolver_hitbox_stomach_ps") * 100);
					local rev_pscale = (gui.GetValue("rbot_revolver_hitbox_pelvis_ps") * 100);
					local rev_ascale = (gui.GetValue("rbot_revolver_hitbox_arms_ps") * 100);
					local rev_lscale = (gui.GetValue("rbot_revolver_hitbox_legs_ps") * 100);
					local rev_autoscale = gui.GetValue("rbot_revolver_hitbox_auto_ps");
					local rev_autoscales = (gui.GetValue("rbot_revolver_hitbox_auto_ps_max") * 100);
					
					SenseUI.Label("Auto wall type");
					rev_autowall = SenseUI.Combo("rev_autowall", { "Off", "Accurate", "Optimized" }, rev_autowall);
					gui.SetValue("rbot_revolver_autowall", rev_autowall-1);
					SenseUI.Label("Auto stop");
					local revolver_as = (gui.GetValue("rbot_revolver_autostop") + 1);
					revolver_as = SenseUI.Combo("revolver_as", { "Off", "Full stop", "Minimal speed" }, revolver_as);
					gui.SetValue("rbot_revolver_autostop", revolver_as-1);
					SenseUI.Label("Target selection");
					local revolver_ts = (gui.GetValue("rbot_revolver_mode") + 1);
					revolver_ts = SenseUI.Combo("revolver_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, revolver_ts);
					gui.SetValue("rbot_revolver_mode", revolver_ts-1);
					rev_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, rev_hitchance);
					gui.SetValue("rbot_revolver_hitchance", rev_hitchance);
					rev_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, rev_mindamage);
					gui.SetValue("rbot_revolver_mindamage", rev_mindamage);
					SenseUI.Label("Hitbox priority");
					rev_hitprior = SenseUI.Combo("rev_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, rev_hitprior);
					gui.SetValue("rbot_revolver_hitbox", rev_hitprior-1);
					SenseUI.Label("Body aim hitbox");
					rev_bodyaim = SenseUI.Combo("rev_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, rev_bodyaim);
					gui.SetValue("rbot_revolver_hitbox_bodyaim", rev_bodyaim-1);
					SenseUI.Label("Hitbox selection method");
					rev_method = SenseUI.Combo("rev_method", { "Damage", "Accuracy" }, rev_method);
					gui.SetValue("rbot_revolver_hitbox_method", rev_method-1);
					rev_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, rev_baimX);
					gui.SetValue("rbot_revolver_bodyaftershots", rev_baimX);
					rev_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, rev_baimHP);
					gui.SetValue("rbot_revolver_bodyifhplower", rev_baimHP);
				
					revolver_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, revolver_optimization);
					gui.SetValue("rbot_revolver_hitbox_adaptive", revolver_optimization["Adaptive hitbox"]); 
					gui.SetValue("rbot_revolver_hitbox_optpoints", revolver_optimization["Nearby points"]);
					gui.SetValue("rbot_revolver_hitbox_optbacktrack", revolver_optimization["Backtracking"]);
						else if weapon_select == 3 then
						
						local smg_autowall = (gui.GetValue("rbot_smg_autowall") + 1);
						local smg_hitchance = gui.GetValue("rbot_smg_hitchance");
						local smg_mindamage = gui.GetValue("rbot_smg_mindamage");
						local smg_hitprior = (gui.GetValue("rbot_smg_hitbox") + 1);
						local smg_bodyaim = (gui.GetValue("rbot_smg_hitbox_bodyaim") + 1);
						local smg_method = (gui.GetValue("rbot_smg_hitbox_method") + 1);
						local smg_baimX = gui.GetValue("rbot_smg_bodyaftershots");
						local smg_baimHP = gui.GetValue("rbot_smg_bodyifhplower");
						local smg_hscale = (gui.GetValue("rbot_smg_hitbox_head_ps") * 100);
						local smg_nscale = (gui.GetValue("rbot_smg_hitbox_neck_ps") * 100);
						local smg_cscale = (gui.GetValue("rbot_smg_hitbox_chest_ps") * 100);
						local smg_sscale = (gui.GetValue("rbot_smg_hitbox_stomach_ps") * 100);
						local smg_pscale = (gui.GetValue("rbot_smg_hitbox_pelvis_ps") * 100);
						local smg_ascale = (gui.GetValue("rbot_smg_hitbox_arms_ps") * 100);
						local smg_lscale = (gui.GetValue("rbot_smg_hitbox_legs_ps") * 100);
						local smg_autoscale = gui.GetValue("rbot_smg_hitbox_auto_ps");
						local smg_autoscales = (gui.GetValue("rbot_smg_hitbox_auto_ps_max") * 100);
						
						SenseUI.Label("Auto wall type");
						smg_autowall = SenseUI.Combo("smg_autowall", { "Off", "Accurate", "Optimized" }, smg_autowall);
						gui.SetValue("rbot_smg_autowall", smg_autowall-1);
						SenseUI.Label("Auto stop");
						local smg_as = (gui.GetValue("rbot_smg_autostop") + 1);
						smg_as = SenseUI.Combo("smg_as", { "Off", "Full stop", "Minimal speed" }, smg_as);
						gui.SetValue("rbot_smg_autostop", smg_as-1);
						SenseUI.Label("Target selection");
						local smg_ts = (gui.GetValue("rbot_smg_mode") + 1);
						smg_ts = SenseUI.Combo("smg_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, smg_ts);
						gui.SetValue("rbot_smg_mode", smg_ts-1);
						smg_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, smg_hitchance);
						gui.SetValue("rbot_smg_hitchance", smg_hitchance);
						smg_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, smg_mindamage);
						gui.SetValue("rbot_smg_mindamage", smg_mindamage);
						SenseUI.Label("Hitbox priority");
						smg_hitprior = SenseUI.Combo("smg_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, smg_hitprior);
						gui.SetValue("rbot_smg_hitbox", smg_hitprior-1);
						SenseUI.Label("Body aim hitbox");
						smg_bodyaim = SenseUI.Combo("smg_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, smg_bodyaim);
						gui.SetValue("rbot_smg_hitbox_bodyaim", smg_bodyaim-1);
						SenseUI.Label("Hitbox selection method");
						smg_method = SenseUI.Combo("smg_method", { "Damage", "Accuracy" }, smg_method);
						gui.SetValue("rbot_smg_hitbox_method", smg_method-1);
						smg_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, smg_baimX);
						gui.SetValue("rbot_smg_bodyaftershots", smg_baimX);
						smg_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, smg_baimHP);
						gui.SetValue("rbot_smg_bodyifhplower", smg_baimHP);
				
						smg_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, smg_optimization);
						gui.SetValue("rbot_smg_hitbox_adaptive", smg_optimization["Adaptive hitbox"]); 
						gui.SetValue("rbot_smg_hitbox_optpoints", smg_optimization["Nearby points"]);
						gui.SetValue("rbot_smg_hitbox_optbacktrack", smg_optimization["Backtracking"]);
							else if weapon_select == 4 then
							
							local rifle_autowall = (gui.GetValue("rbot_rifle_autowall") + 1);
							local rifle_hitchance = gui.GetValue("rbot_rifle_hitchance");
							local rifle_mindamage = gui.GetValue("rbot_rifle_mindamage");
							local rifle_hitprior = (gui.GetValue("rbot_rifle_hitbox") + 1);
							local rifle_bodyaim = (gui.GetValue("rbot_rifle_hitbox_bodyaim") + 1);
							local rifle_method = (gui.GetValue("rbot_rifle_hitbox_method") + 1);
							local rifle_baimX = gui.GetValue("rbot_rifle_bodyaftershots");
							local rifle_baimHP = gui.GetValue("rbot_rifle_bodyifhplower");
							local rifle_hscale = (gui.GetValue("rbot_rifle_hitbox_head_ps") * 100);
							local rifle_nscale = (gui.GetValue("rbot_rifle_hitbox_neck_ps") * 100);
							local rifle_cscale = (gui.GetValue("rbot_rifle_hitbox_chest_ps") * 100);
							local rifle_sscale = (gui.GetValue("rbot_rifle_hitbox_stomach_ps") * 100);
							local rifle_pscale = (gui.GetValue("rbot_rifle_hitbox_pelvis_ps") * 100);
							local rifle_ascale = (gui.GetValue("rbot_rifle_hitbox_arms_ps") * 100);
							local rifle_lscale = (gui.GetValue("rbot_rifle_hitbox_legs_ps") * 100);
							local rifle_autoscale = gui.GetValue("rbot_rifle_hitbox_auto_ps");
							local rifle_autoscales = (gui.GetValue("rbot_rifle_hitbox_auto_ps_max") * 100);
							
							SenseUI.Label("Auto wall type");
							rifle_autowall = SenseUI.Combo("rifle_autowall", { "Off", "Accurate", "Optimized" }, rifle_autowall);
							gui.SetValue("rbot_rifle_autowall", rifle_autowall-1);
							SenseUI.Label("Auto stop");
							local rifle_as = (gui.GetValue("rbot_rifle_autostop") + 1);
							rifle_as = SenseUI.Combo("rifle_as", { "Off", "Full stop", "Minimal speed" }, rifle_as);
							gui.SetValue("rbot_rifle_autostop", rifle_as-1);
							SenseUI.Label("Target selection");
							local rifle_ts = (gui.GetValue("rbot_rifle_mode") + 1);
							rifle_ts = SenseUI.Combo("rifle_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, rifle_ts);
							gui.SetValue("rbot_rifle_mode", rifle_ts-1);
							rifle_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, rifle_hitchance);
							gui.SetValue("rbot_rifle_hitchance", rifle_hitchance);
							rifle_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, rifle_mindamage);
							gui.SetValue("rbot_rifle_mindamage", rifle_mindamage);
							SenseUI.Label("Hitbox priority");
							rifle_hitprior = SenseUI.Combo("rifle_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, rifle_hitprior);
							gui.SetValue("rbot_rifle_hitbox", rifle_hitprior-1);
							SenseUI.Label("Body aim hitbox");
							rifle_bodyaim = SenseUI.Combo("rifle_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, rifle_bodyaim);
							gui.SetValue("rbot_rifle_hitbox_bodyaim", rifle_bodyaim-1);
							SenseUI.Label("Hitbox selection method");
							rifle_method = SenseUI.Combo("rifle_method", { "Damage", "Accuracy" }, rifle_method);
							gui.SetValue("rbot_rifle_hitbox_method", rifle_method-1);
							rifle_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, rifle_baimX);
							gui.SetValue("rbot_rifle_bodyaftershots", rifle_baimX);
							rifle_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, rifle_baimHP);
							gui.SetValue("rbot_rifle_bodyifhplower", rifle_baimHP);
				
							rifle_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, rifle_optimization);
							gui.SetValue("rbot_rifle_hitbox_adaptive", rifle_optimization["Adaptive hitbox"]); 
							gui.SetValue("rbot_rifle_hitbox_optpoints", rifle_optimization["Nearby points"]);
							gui.SetValue("rbot_rifle_hitbox_optbacktrack", rifle_optimization["Backtracking"]);
								else if weapon_select == 5 then
								
								local shotgun_autowall = (gui.GetValue("rbot_shotgun_autowall") + 1);
								local shotgun_hitchance = gui.GetValue("rbot_shotgun_hitchance");
								local shotgun_mindamage = gui.GetValue("rbot_shotgun_mindamage");
								local shotgun_hitprior = (gui.GetValue("rbot_shotgun_hitbox") + 1);
								local shotgun_bodyaim = (gui.GetValue("rbot_shotgun_hitbox_bodyaim") + 1);
								local shotgun_method = (gui.GetValue("rbot_shotgun_hitbox_method") + 1);
								local shotgun_baimX = gui.GetValue("rbot_shotgun_bodyaftershots");
								local shotgun_baimHP = gui.GetValue("rbot_shotgun_bodyifhplower");
								local shotgun_hscale = (gui.GetValue("rbot_shotgun_hitbox_head_ps") * 100);
								local shotgun_nscale = (gui.GetValue("rbot_shotgun_hitbox_neck_ps") * 100);
								local shotgun_cscale = (gui.GetValue("rbot_shotgun_hitbox_chest_ps") * 100);
								local shotgun_sscale = (gui.GetValue("rbot_shotgun_hitbox_stomach_ps") * 100);
								local shotgun_pscale = (gui.GetValue("rbot_shotgun_hitbox_pelvis_ps") * 100);
								local shotgun_ascale = (gui.GetValue("rbot_shotgun_hitbox_arms_ps") * 100);
								local shotgun_lscale = (gui.GetValue("rbot_shotgun_hitbox_legs_ps") * 100);
								local shotgun_autoscale = gui.GetValue("rbot_shotgun_hitbox_auto_ps");
								local shotgun_autoscales = (gui.GetValue("rbot_shotgun_hitbox_auto_ps_max") * 100);
								
								SenseUI.Label("Auto wall type");
								shotgun_autowall = SenseUI.Combo("shotgun_autowall", { "Off", "Accurate", "Optimized" }, shotgun_autowall);
								gui.SetValue("rbot_shotgun_autowall", shotgun_autowall-1);
								SenseUI.Label("Auto stop");
								local shotgun_as = (gui.GetValue("rbot_shotgun_autostop") + 1);
								shotgun_as = SenseUI.Combo("shotgun_as", { "Off", "Full stop", "Minimal speed" }, shotgun_as);
								gui.SetValue("rbot_shotgun_autostop", shotgun_as-1);
								SenseUI.Label("Target selection");
								local shotgun_ts = (gui.GetValue("rbot_shotgun_mode") + 1);
								shotgun_ts = SenseUI.Combo("shotgun_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, shotgun_ts);
								gui.SetValue("rbot_shotgun_mode", shotgun_ts-1);
								shotgun_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, shotgun_hitchance);
								gui.SetValue("rbot_shotgun_hitchance", shotgun_hitchance);
								shotgun_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, shotgun_mindamage);
								gui.SetValue("rbot_shotgun_mindamage", shotgun_mindamage);
								SenseUI.Label("Hitbox priority");
								shotgun_hitprior = SenseUI.Combo("shotgun_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, shotgun_hitprior);
								gui.SetValue("rbot_shotgun_hitbox", shotgun_hitprior-1);
								SenseUI.Label("Body aim hitbox");
								shotgun_bodyaim = SenseUI.Combo("shotgun_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, shotgun_bodyaim);
								gui.SetValue("rbot_shotgun_hitbox_bodyaim", shotgun_bodyaim-1);
								SenseUI.Label("Hitbox selection method");
								shotgun_method = SenseUI.Combo("shotgun_method", { "Damage", "Accuracy" }, shotgun_method);
								gui.SetValue("rbot_shotgun_hitbox_method", shotgun_method-1);
								shotgun_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, shotgun_baimX);
								gui.SetValue("rbot_shotgun_bodyaftershots", shotgun_baimX);
								shotgun_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, shotgun_baimHP);
								gui.SetValue("rbot_shotgun_bodyifhplower", shotgun_baimHP);
				
								shotgun_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, shotgun_optimization);
								gui.SetValue("rbot_shotgun_hitbox_adaptive", shotgun_optimization["Adaptive hitbox"]); 
								gui.SetValue("rbot_shotgun_hitbox_optpoints", shotgun_optimization["Nearby points"]);
								gui.SetValue("rbot_shotgun_hitbox_optbacktrack", shotgun_optimization["Backtracking"]);
									else if weapon_select == 6 then
									
									local scout_autowall = (gui.GetValue("rbot_scout_autowall") + 1);
									local scout_hitchance = gui.GetValue("rbot_scout_hitchance");
									local scout_mindamage = gui.GetValue("rbot_scout_mindamage");
									local scout_hitprior = (gui.GetValue("rbot_scout_hitbox") + 1);
									local scout_bodyaim = (gui.GetValue("rbot_scout_hitbox_bodyaim") + 1);
									local scout_method = (gui.GetValue("rbot_scout_hitbox_method") + 1);
									local scout_baimX = gui.GetValue("rbot_scout_bodyaftershots");
									local scout_baimHP = gui.GetValue("rbot_scout_bodyifhplower");
									local scout_hscale = (gui.GetValue("rbot_scout_hitbox_head_ps") * 100);
									local scout_nscale = (gui.GetValue("rbot_scout_hitbox_neck_ps") * 100);
									local scout_cscale = (gui.GetValue("rbot_scout_hitbox_chest_ps") * 100);
									local scout_sscale = (gui.GetValue("rbot_scout_hitbox_stomach_ps") * 100);
									local scout_pscale = (gui.GetValue("rbot_scout_hitbox_pelvis_ps") * 100);
									local scout_ascale = (gui.GetValue("rbot_scout_hitbox_arms_ps") * 100);
									local scout_lscale = (gui.GetValue("rbot_scout_hitbox_legs_ps") * 100);
									local scout_autoscale = gui.GetValue("rbot_scout_hitbox_auto_ps");
									local scout_autoscales = (gui.GetValue("rbot_scout_hitbox_auto_ps_max") * 100);
									
									SenseUI.Label("Auto wall type");
									scout_autowall = SenseUI.Combo("scout_autowall", { "Off", "Accurate", "Optimized" }, scout_autowall);
									gui.SetValue("rbot_scout_autowall", scout_autowall-1);
									SenseUI.Label("Auto stop");
									local scout_as = (gui.GetValue("rbot_scout_autostop") + 1);
									scout_as = SenseUI.Combo("scout_as", { "Off", "Full stop", "Minimal speed" }, scout_as);
									gui.SetValue("rbot_scout_autostop", scout_as-1);
									SenseUI.Label("Target selection");
									local scout_ts = (gui.GetValue("rbot_scout_mode") + 1);
									scout_ts = SenseUI.Combo("scout_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, scout_ts);
									gui.SetValue("rbot_scout_mode", scout_ts-1);
									scout_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, scout_hitchance);
									gui.SetValue("rbot_scout_hitchance", scout_hitchance);
									scout_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, scout_mindamage);
									gui.SetValue("rbot_scout_mindamage", scout_mindamage);
									SenseUI.Label("Hitbox priority");
									scout_hitprior = SenseUI.Combo("scout_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, scout_hitprior);
									gui.SetValue("rbot_scout_hitbox", scout_hitprior-1);
									SenseUI.Label("Body aim hitbox");
									scout_bodyaim = SenseUI.Combo("scout_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, scout_bodyaim);
									gui.SetValue("rbot_scout_hitbox_bodyaim", scout_bodyaim-1);
									SenseUI.Label("Hitbox selection method");
									scout_method = SenseUI.Combo("scout_method", { "Damage", "Accuracy" }, scout_method);
									gui.SetValue("rbot_scout_hitbox_method", scout_method-1);
									scout_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, scout_baimX);
									gui.SetValue("rbot_scout_bodyaftershots", scout_baimX);
									scout_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, scout_baimHP);
									gui.SetValue("rbot_scout_bodyifhplower", scout_baimHP);	
				
									scout_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, scout_optimization);
									gui.SetValue("rbot_scout_hitbox_adaptive", scout_optimization["Adaptive hitbox"]); 
									gui.SetValue("rbot_scout_hitbox_optpoints", scout_optimization["Nearby points"]);
									gui.SetValue("rbot_scout_hitbox_optbacktrack", scout_optimization["Backtracking"]);								
										else if weapon_select == 7 then
										
										local autosniper_autowall = (gui.GetValue("rbot_autosniper_autowall") + 1);
										local autosniper_hitchance = gui.GetValue("rbot_autosniper_hitchance");
										local autosniper_mindamage = gui.GetValue("rbot_autosniper_mindamage");
										local autosniper_hitprior = (gui.GetValue("rbot_autosniper_hitbox") + 1);
										local autosniper_bodyaim = (gui.GetValue("rbot_autosniper_hitbox_bodyaim") + 1);
										local autosniper_method = (gui.GetValue("rbot_autosniper_hitbox_method") + 1);
										local autosniper_baimX = gui.GetValue("rbot_autosniper_bodyaftershots");
										local autosniper_baimHP = gui.GetValue("rbot_autosniper_bodyifhplower");
										local autosniper_hscale = (gui.GetValue("rbot_autosniper_hitbox_head_ps") * 100);
										local autosniper_nscale = (gui.GetValue("rbot_autosniper_hitbox_neck_ps") * 100);
										local autosniper_cscale = (gui.GetValue("rbot_autosniper_hitbox_chest_ps") * 100);
										local autosniper_sscale = (gui.GetValue("rbot_autosniper_hitbox_stomach_ps") * 100);
										local autosniper_pscale = (gui.GetValue("rbot_autosniper_hitbox_pelvis_ps") * 100);
										local autosniper_ascale = (gui.GetValue("rbot_autosniper_hitbox_arms_ps") * 100);
										local autosniper_lscale = (gui.GetValue("rbot_autosniper_hitbox_legs_ps") * 100);
										local autosniper_autoscale = gui.GetValue("rbot_autosniper_hitbox_auto_ps");
										local autosniper_autoscales = (gui.GetValue("rbot_autosniper_hitbox_auto_ps_max") * 100);
										
										SenseUI.Label("Auto wall type");
										autosniper_autowall = SenseUI.Combo("autosniper_autowall", { "Off", "Accurate", "Optimized" }, autosniper_autowall);
										gui.SetValue("rbot_autosniper_autowall", autosniper_autowall-1);
										SenseUI.Label("Auto stop");
										local autosniper_as = (gui.GetValue("rbot_autosniper_autostop") + 1);
										autosniper_as = SenseUI.Combo("autosniper_as", { "Off", "Full stop", "Minimal speed" }, autosniper_as);
										gui.SetValue("rbot_autosniper_autostop", autosniper_as-1);
										SenseUI.Label("Target selection");
										local autosniper_ts = (gui.GetValue("rbot_autosniper_mode") + 1);
										autosniper_ts = SenseUI.Combo("autosniper_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, autosniper_ts);
										gui.SetValue("rbot_autosniper_mode", autosniper_ts-1);
										autosniper_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, autosniper_hitchance);
										gui.SetValue("rbot_autosniper_hitchance", autosniper_hitchance);
										autosniper_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, autosniper_mindamage);
										gui.SetValue("rbot_autosniper_mindamage", autosniper_mindamage);
										SenseUI.Label("Hitbox priority");
										autosniper_hitprior = SenseUI.Combo("autosniper_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, autosniper_hitprior);
										gui.SetValue("rbot_autosniper_hitbox", autosniper_hitprior-1);
										SenseUI.Label("Body aim hitbox");
										autosniper_bodyaim = SenseUI.Combo("autosniper_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, autosniper_bodyaim);
										gui.SetValue("rbot_autosniper_hitbox_bodyaim", autosniper_bodyaim-1);
										SenseUI.Label("Hitbox selection method");
										autosniper_method = SenseUI.Combo("autosniper_method", { "Damage", "Accuracy" }, autosniper_method);
										gui.SetValue("rbot_autosniper_hitbox_method", autosniper_method-1);
										autosniper_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, autosniper_baimX);
										gui.SetValue("rbot_autosniper_bodyaftershots", autosniper_baimX);
										autosniper_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, autosniper_baimHP);
										gui.SetValue("rbot_autosniper_bodyifhplower", autosniper_baimHP);
				
										autosniper_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, autosniper_optimization);
										gui.SetValue("rbot_autosniper_hitbox_adaptive", autosniper_optimization["Adaptive hitbox"]); 
										gui.SetValue("rbot_autosniper_hitbox_optpoints", autosniper_optimization["Nearby points"]);
										gui.SetValue("rbot_autosniper_hitbox_optbacktrack", autosniper_optimization["Backtracking"]);										
											else if weapon_select == 8 then
											
											local sniper_autowall = (gui.GetValue("rbot_sniper_autowall") + 1);
											local sniper_hitchance = gui.GetValue("rbot_sniper_hitchance");
											local sniper_mindamage = gui.GetValue("rbot_sniper_mindamage");
											local sniper_hitprior = (gui.GetValue("rbot_sniper_hitbox") + 1);
											local sniper_bodyaim = (gui.GetValue("rbot_sniper_hitbox_bodyaim") + 1);
											local sniper_method = (gui.GetValue("rbot_sniper_hitbox_method") + 1);
											local sniper_baimX = gui.GetValue("rbot_sniper_bodyaftershots");
											local sniper_baimHP = gui.GetValue("rbot_sniper_bodyifhplower");
											local sniper_hscale = (gui.GetValue("rbot_sniper_hitbox_head_ps") * 100);
											local sniper_nscale = (gui.GetValue("rbot_sniper_hitbox_neck_ps") * 100);
											local sniper_cscale = (gui.GetValue("rbot_sniper_hitbox_chest_ps") * 100);
											local sniper_sscale = (gui.GetValue("rbot_sniper_hitbox_stomach_ps") * 100);
											local sniper_pscale = (gui.GetValue("rbot_sniper_hitbox_pelvis_ps") * 100);
											local sniper_ascale = (gui.GetValue("rbot_sniper_hitbox_arms_ps") * 100);
											local sniper_lscale = (gui.GetValue("rbot_sniper_hitbox_legs_ps") * 100);
											local sniper_autoscale = gui.GetValue("rbot_sniper_hitbox_auto_ps");
											local sniper_autoscales = (gui.GetValue("rbot_sniper_hitbox_auto_ps_max") * 100);
											
											SenseUI.Label("Auto wall type");
											sniper_autowall = SenseUI.Combo("sniper_autowall", { "Off", "Accurate", "Optimized" }, sniper_autowall);
											gui.SetValue("rbot_sniper_autowall", sniper_autowall-1);
											SenseUI.Label("Auto stop");
											local sniper_as = (gui.GetValue("rbot_sniper_autostop") + 1);
											sniper_as = SenseUI.Combo("sniper_as", { "Off", "Full stop", "Minimal speed" }, sniper_as);
											gui.SetValue("rbot_sniper_autostop", sniper_as-1);
											SenseUI.Label("Target selection");
											local sniper_ts = (gui.GetValue("rbot_sniper_mode") + 1);
											sniper_ts = SenseUI.Combo("sniper_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, sniper_ts);
											gui.SetValue("rbot_sniper_mode", sniper_ts-1);
											sniper_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, sniper_hitchance);
											gui.SetValue("rbot_sniper_hitchance", sniper_hitchance);
											sniper_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, sniper_mindamage);
											gui.SetValue("rbot_sniper_mindamage", sniper_mindamage);
											SenseUI.Label("Hitbox priority");
											sniper_hitprior = SenseUI.Combo("sniper_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, sniper_hitprior);
											gui.SetValue("rbot_sniper_hitbox", sniper_hitprior-1);
											SenseUI.Label("Body aim hitbox");
											sniper_bodyaim = SenseUI.Combo("sniper_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, sniper_bodyaim);
											gui.SetValue("rbot_sniper_hitbox_bodyaim", sniper_bodyaim-1);
											SenseUI.Label("Hitbox selection method");
											sniper_method = SenseUI.Combo("sniper_method", { "Damage", "Accuracy" }, sniper_method);
											gui.SetValue("rbot_sniper_hitbox_method", sniper_method-1);
											sniper_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, sniper_baimX);
											gui.SetValue("rbot_sniper_bodyaftershots", sniper_baimX);
											sniper_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, sniper_baimHP);
											gui.SetValue("rbot_sniper_bodyifhplower", sniper_baimHP);
				
											sniper_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, sniper_optimization);
											gui.SetValue("rbot_sniper_hitbox_adaptive", sniper_optimization["Adaptive hitbox"]); 
											gui.SetValue("rbot_sniper_hitbox_optpoints", sniper_optimization["Nearby points"]);
											gui.SetValue("rbot_sniper_hitbox_optbacktrack", sniper_optimization["Backtracking"]);
												else if weapon_select == 9 then
												
												local lmg_autowall = (gui.GetValue("rbot_lmg_autowall") + 1);
												local lmg_hitchance = gui.GetValue("rbot_lmg_hitchance");
												local lmg_mindamage = gui.GetValue("rbot_lmg_mindamage");
												local lmg_hitprior = (gui.GetValue("rbot_lmg_hitbox") + 1);
												local lmg_bodyaim = (gui.GetValue("rbot_lmg_hitbox_bodyaim") + 1);
												local lmg_method = (gui.GetValue("rbot_lmg_hitbox_method") + 1);
												local lmg_baimX = gui.GetValue("rbot_lmg_bodyaftershots");
												local lmg_baimHP = gui.GetValue("rbot_lmg_bodyifhplower");
												local lmg_hscale = (gui.GetValue("rbot_lmg_hitbox_head_ps") * 100);
												local lmg_nscale = (gui.GetValue("rbot_lmg_hitbox_neck_ps") * 100);
												local lmg_cscale = (gui.GetValue("rbot_lmg_hitbox_chest_ps") * 100);
												local lmg_sscale = (gui.GetValue("rbot_lmg_hitbox_stomach_ps") * 100);
												local lmg_pscale = (gui.GetValue("rbot_lmg_hitbox_pelvis_ps") * 100);
												local lmg_ascale = (gui.GetValue("rbot_lmg_hitbox_arms_ps") * 100);
												local lmg_lscale = (gui.GetValue("rbot_lmg_hitbox_legs_ps") * 100);
												local lmg_autoscale = gui.GetValue("rbot_lmg_hitbox_auto_ps");
												local lmg_autoscales = (gui.GetValue("rbot_lmg_hitbox_auto_ps_max") * 100);
												
												SenseUI.Label("Auto wall type");
												lmg_autowall = SenseUI.Combo("lmg_autowall", { "Off", "Accurate", "Optimized" }, lmg_autowall);
												gui.SetValue("rbot_lmg_autowall", lmg_autowall-1);
												SenseUI.Label("Auto stop");
												local lmg_as = (gui.GetValue("rbot_lmg_autostop") + 1);
												lmg_as = SenseUI.Combo("lmg_as", { "Off", "Full stop", "Minimal speed" }, lmg_as);
												gui.SetValue("rbot_lmg_autostop", lmg_as-1);
												SenseUI.Label("Target selection");
												local lmg_ts = (gui.GetValue("rbot_lmg_mode") + 1);
												lmg_ts = SenseUI.Combo("lmg_ts", { "FOV", "Distance", "Next shot", "Lowest health", "Highest damage", "Lowest latency" }, lmg_ts);
												gui.SetValue("rbot_lmg_mode", lmg_ts-1);
												lmg_hitchance = SenseUI.Slider("Hit chance", 0, 100, "%", "0%", "100%", false, lmg_hitchance);
												gui.SetValue("rbot_lmg_hitchance", lmg_hitchance);
												lmg_mindamage = SenseUI.Slider("Minimal damage", 0, 100, "", "0", "100", false, lmg_mindamage);
												gui.SetValue("rbot_lmg_mindamage", lmg_mindamage);
												SenseUI.Label("Hitbox priority");
												lmg_hitprior = SenseUI.Combo("lmg_hitprior", { "Head", "Neck", "Check", "Stomach", "Pelvis", "Center" }, lmg_hitprior);
												gui.SetValue("rbot_lmg_hitbox", lmg_hitprior-1);
												SenseUI.Label("Body aim hitbox");
												lmg_bodyaim = SenseUI.Combo("lmg_bodyaim", { "Pelvis", "Pelvis + Edges", "Center" }, lmg_bodyaim);
												gui.SetValue("rbot_lmg_hitbox_bodyaim", lmg_bodyaim-1);
												SenseUI.Label("Hitbox selection method");
												lmg_method = SenseUI.Combo("lmg_method", { "Damage", "Accuracy" }, lmg_method);
												gui.SetValue("rbot_lmg_hitbox_method", lmg_method-1);
												lmg_baimX = SenseUI.Slider("Body aim after X shots", 0, 15, "", "0", "15", false, lmg_baimX);
												gui.SetValue("rbot_lmg_bodyaftershots", lmg_baimX);
												lmg_baimHP = SenseUI.Slider("Body aim if HP lower than", 0, 100, "", "0", "100", false, lmg_baimHP);
												gui.SetValue("rbot_lmg_bodyifhplower", lmg_baimHP);	
				
												lmg_optimization = SenseUI.MultiCombo("Hitscan optimization", { "Adaptive hitbox", "Nearby points", "Backtracking" }, lmg_optimization);
												gui.SetValue("rbot_lmg_hitbox_adaptive", lmg_optimization["Adaptive hitbox"]); 
												gui.SetValue("rbot_lmg_hitbox_optpoints", lmg_optimization["Nearby points"]);
												gui.SetValue("rbot_lmg_hitbox_optbacktrack", lmg_optimization["Backtracking"]);
												end
											end
										end
									end
								end
							end
						end
					end
				end
			SenseUI.EndGroup();
			end
			if SenseUI.BeginGroup( "hitscans", "Hitscan", 285, 25, 235, 300 ) then
				if weapon_select == 1 then
				
				local p_autowall = (gui.GetValue("rbot_pistol_autowall") + 1);
				local p_hitchance = gui.GetValue("rbot_pistol_hitchance");
				local p_mindamage = gui.GetValue("rbot_pistol_mindamage");
				local p_hitprior = (gui.GetValue("rbot_pistol_hitbox") + 1);
				local p_bodyaim = (gui.GetValue("rbot_pistol_hitbox_bodyaim") + 1);
				local p_method = (gui.GetValue("rbot_pistol_hitbox_method") + 1);
				local p_baimX = gui.GetValue("rbot_pistol_bodyaftershots");
				local p_baimHP = gui.GetValue("rbot_pistol_bodyifhplower");
				local p_hscale = (gui.GetValue("rbot_pistol_hitbox_head_ps") * 100);
				local p_nscale = (gui.GetValue("rbot_pistol_hitbox_neck_ps") * 100);
				local p_cscale = (gui.GetValue("rbot_pistol_hitbox_chest_ps") * 100);
				local p_sscale = (gui.GetValue("rbot_pistol_hitbox_stomach_ps") * 100);
				local p_pscale = (gui.GetValue("rbot_pistol_hitbox_pelvis_ps") * 100);
				local p_ascale = (gui.GetValue("rbot_pistol_hitbox_arms_ps") * 100);
				local p_lscale = (gui.GetValue("rbot_pistol_hitbox_legs_ps") * 100);
				local p_autoscale = gui.GetValue("rbot_pistol_hitbox_auto_ps");
				local p_autoscales = (gui.GetValue("rbot_pistol_hitbox_auto_ps_max") * 100);
				
				pistol_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, pistol_hitboxes);
				gui.SetValue("rbot_pistol_hitbox_head", pistol_hitboxes["Head"]);
				gui.SetValue("rbot_pistol_hitbox_neck", pistol_hitboxes["Neck"]);
				gui.SetValue("rbot_pistol_hitbox_chest", pistol_hitboxes["Chest"]);
				gui.SetValue("rbot_pistol_hitbox_stomach", pistol_hitboxes["Stomach"]);
				gui.SetValue("rbot_pistol_hitbox_pelvis", pistol_hitboxes["Pelvis"]);
				gui.SetValue("rbot_pistol_hitbox_arms", pistol_hitboxes["Arms"]);
				gui.SetValue("rbot_pistol_hitbox_legs", pistol_hitboxes["Legs"]);
				
				p_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, p_hscale);
				gui.SetValue("rbot_pistol_hitbox_head_ps", p_hscale / 100);
				p_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, p_nscale);
				gui.SetValue("rbot_pistol_hitbox_neck_ps", p_nscale / 100);
				p_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, p_cscale);
				gui.SetValue("rbot_pistol_hitbox_chest_ps", p_cscale / 100);
				p_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, p_sscale);
				gui.SetValue("rbot_pistol_hitbox_stomach_ps", p_sscale / 100);
				p_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, p_pscale);
				gui.SetValue("rbot_pistol_hitbox_pelvis_ps", p_pscale / 100);
				p_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, p_ascale);
				gui.SetValue("rbot_pistol_hitbox_arms_ps", p_ascale / 100);
				p_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, p_lscale);
				gui.SetValue("rbot_pistol_hitbox_legs_ps", p_lscale / 100);
				p_autoscale = SenseUI.Checkbox("Auto scale", p_autoscale);
				gui.SetValue("rbot_pistol_hitbox_auto_ps", p_autoscale);
				p_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, p_autoscales);
				gui.SetValue("rbot_pistol_hitbox_auto_ps_max", p_autoscales / 100);
					else if weapon_select == 2 then
					
					local rev_autowall = (gui.GetValue("rbot_revolver_autowall") + 1);
					local rev_hitchance = gui.GetValue("rbot_revolver_hitchance");
					local rev_mindamage = gui.GetValue("rbot_revolver_mindamage");
					local rev_hitprior = (gui.GetValue("rbot_revolver_hitbox") + 1);
					local rev_bodyaim = (gui.GetValue("rbot_revolver_hitbox_bodyaim") + 1);
					local rev_method = (gui.GetValue("rbot_revolver_hitbox_method") + 1);
					local rev_baimX = gui.GetValue("rbot_revolver_bodyaftershots");
					local rev_baimHP = gui.GetValue("rbot_revolver_bodyifhplower");
					local rev_hscale = (gui.GetValue("rbot_revolver_hitbox_head_ps") * 100);
					local rev_nscale = (gui.GetValue("rbot_revolver_hitbox_neck_ps") * 100);
					local rev_cscale = (gui.GetValue("rbot_revolver_hitbox_chest_ps") * 100);
					local rev_sscale = (gui.GetValue("rbot_revolver_hitbox_stomach_ps") * 100);
					local rev_pscale = (gui.GetValue("rbot_revolver_hitbox_pelvis_ps") * 100);
					local rev_ascale = (gui.GetValue("rbot_revolver_hitbox_arms_ps") * 100);
					local rev_lscale = (gui.GetValue("rbot_revolver_hitbox_legs_ps") * 100);
					local rev_autoscale = gui.GetValue("rbot_revolver_hitbox_auto_ps");
					local rev_autoscales = (gui.GetValue("rbot_revolver_hitbox_auto_ps_max") * 100);
				
					revolver_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, revolver_hitboxes);
					gui.SetValue("rbot_revolver_hitbox_head", revolver_hitboxes["Head"]);
					gui.SetValue("rbot_revolver_hitbox_neck", revolver_hitboxes["Neck"]);
					gui.SetValue("rbot_revolver_hitbox_chest", revolver_hitboxes["Chest"]);
					gui.SetValue("rbot_revolver_hitbox_stomach", revolver_hitboxes["Stomach"]);
					gui.SetValue("rbot_revolver_hitbox_pelvis", revolver_hitboxes["Pelvis"]);
					gui.SetValue("rbot_revolver_hitbox_arms", revolver_hitboxes["Arms"]);
					gui.SetValue("rbot_revolver_hitbox_legs", revolver_hitboxes["Legs"]);
					
					rev_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, rev_hscale);
					gui.SetValue("rbot_revolver_hitbox_head_ps", rev_hscale / 100);
					rev_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, rev_nscale);
					gui.SetValue("rbot_revolver_hitbox_neck_ps", rev_nscale / 100);
					rev_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, rev_cscale);
					gui.SetValue("rbot_revolver_hitbox_chest_ps", rev_cscale / 100);
					rev_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, rev_sscale);
					gui.SetValue("rbot_revolver_hitbox_stomach_ps", rev_sscale / 100);
					rev_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, rev_pscale);
					gui.SetValue("rbot_revolver_hitbox_pelvis_ps", rev_pscale / 100);
					rev_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, rev_ascale);
					gui.SetValue("rbot_revolver_hitbox_arms_ps", rev_ascale / 100);
					rev_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, rev_lscale);
					gui.SetValue("rbot_revolver_hitbox_legs_ps", rev_lscale / 100);
					rev_autoscale = SenseUI.Checkbox("Auto scale", rev_autoscale);
					gui.SetValue("rbot_revolver_hitbox_auto_ps", rev_autoscale);
					rev_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, rev_autoscales);
					gui.SetValue("rbot_revolver_hitbox_auto_ps_max", rev_autoscales / 100);
						else if weapon_select == 3 then
						
						local smg_autowall = (gui.GetValue("rbot_smg_autowall") + 1);
						local smg_hitchance = gui.GetValue("rbot_smg_hitchance");
						local smg_mindamage = gui.GetValue("rbot_smg_mindamage");
						local smg_hitprior = (gui.GetValue("rbot_smg_hitbox") + 1);
						local smg_bodyaim = (gui.GetValue("rbot_smg_hitbox_bodyaim") + 1);
						local smg_method = (gui.GetValue("rbot_smg_hitbox_method") + 1);
						local smg_baimX = gui.GetValue("rbot_smg_bodyaftershots");
						local smg_baimHP = gui.GetValue("rbot_smg_bodyifhplower");
						local smg_hscale = (gui.GetValue("rbot_smg_hitbox_head_ps") * 100);
						local smg_nscale = (gui.GetValue("rbot_smg_hitbox_neck_ps") * 100);
						local smg_cscale = (gui.GetValue("rbot_smg_hitbox_chest_ps") * 100);
						local smg_sscale = (gui.GetValue("rbot_smg_hitbox_stomach_ps") * 100);
						local smg_pscale = (gui.GetValue("rbot_smg_hitbox_pelvis_ps") * 100);
						local smg_ascale = (gui.GetValue("rbot_smg_hitbox_arms_ps") * 100);
						local smg_lscale = (gui.GetValue("rbot_smg_hitbox_legs_ps") * 100);
						local smg_autoscale = gui.GetValue("rbot_smg_hitbox_auto_ps");
						local smg_autoscales = (gui.GetValue("rbot_smg_hitbox_auto_ps_max") * 100);
				
						smg_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, smg_hitboxes);
						gui.SetValue("rbot_smg_hitbox_head", smg_hitboxes["Head"]);
						gui.SetValue("rbot_smg_hitbox_neck", smg_hitboxes["Neck"]);
						gui.SetValue("rbot_smg_hitbox_chest", smg_hitboxes["Chest"]);
						gui.SetValue("rbot_smg_hitbox_stomach", smg_hitboxes["Stomach"]);
						gui.SetValue("rbot_smg_hitbox_pelvis", smg_hitboxes["Pelvis"]);
						gui.SetValue("rbot_smg_hitbox_arms", smg_hitboxes["Arms"]);
						gui.SetValue("rbot_smg_hitbox_legs", smg_hitboxes["Legs"]);
						
						smg_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, smg_hscale);
						gui.SetValue("rbot_smg_hitbox_head_ps", smg_hscale / 100);
						smg_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, smg_nscale);
						gui.SetValue("rbot_smg_hitbox_neck_ps", smg_nscale / 100);
						smg_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, smg_cscale);
						gui.SetValue("rbot_smg_hitbox_chest_ps", smg_cscale / 100);
						smg_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, smg_sscale);
						gui.SetValue("rbot_smg_hitbox_stomach_ps", smg_sscale / 100);
						smg_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, smg_pscale);
						gui.SetValue("rbot_smg_hitbox_pelvis_ps", smg_pscale / 100);
						smg_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, smg_ascale);
						gui.SetValue("rbot_smg_hitbox_arms_ps", smg_ascale / 100);
						smg_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, smg_lscale);
						gui.SetValue("rbot_smg_hitbox_legs_ps", smg_lscale / 100);
						smg_autoscale = SenseUI.Checkbox("Auto scale", smg_autoscale);
						gui.SetValue("rbot_smg_hitbox_auto_ps", smg_autoscale);
						smg_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, smg_autoscales);
						gui.SetValue("rbot_smg_hitbox_auto_ps_max", smg_autoscales / 100);						
							else if weapon_select == 4 then
							
							local rifle_autowall = (gui.GetValue("rbot_rifle_autowall") + 1);
							local rifle_hitchance = gui.GetValue("rbot_rifle_hitchance");
							local rifle_mindamage = gui.GetValue("rbot_rifle_mindamage");
							local rifle_hitprior = (gui.GetValue("rbot_rifle_hitbox") + 1);
							local rifle_bodyaim = (gui.GetValue("rbot_rifle_hitbox_bodyaim") + 1);
							local rifle_method = (gui.GetValue("rbot_rifle_hitbox_method") + 1);
							local rifle_baimX = gui.GetValue("rbot_rifle_bodyaftershots");
							local rifle_baimHP = gui.GetValue("rbot_rifle_bodyifhplower");
							local rifle_hscale = (gui.GetValue("rbot_rifle_hitbox_head_ps") * 100);
							local rifle_nscale = (gui.GetValue("rbot_rifle_hitbox_neck_ps") * 100);
							local rifle_cscale = (gui.GetValue("rbot_rifle_hitbox_chest_ps") * 100);
							local rifle_sscale = (gui.GetValue("rbot_rifle_hitbox_stomach_ps") * 100);
							local rifle_pscale = (gui.GetValue("rbot_rifle_hitbox_pelvis_ps") * 100);
							local rifle_ascale = (gui.GetValue("rbot_rifle_hitbox_arms_ps") * 100);
							local rifle_lscale = (gui.GetValue("rbot_rifle_hitbox_legs_ps") * 100);
							local rifle_autoscale = gui.GetValue("rbot_rifle_hitbox_auto_ps");
							local rifle_autoscales = (gui.GetValue("rbot_rifle_hitbox_auto_ps_max") * 100);
				
							rifle_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, rifle_hitboxes);
							gui.SetValue("rbot_rifle_hitbox_head", rifle_hitboxes["Head"]);
							gui.SetValue("rbot_rifle_hitbox_neck", rifle_hitboxes["Neck"]);
							gui.SetValue("rbot_rifle_hitbox_chest", rifle_hitboxes["Chest"]);
							gui.SetValue("rbot_rifle_hitbox_stomach", rifle_hitboxes["Stomach"]);
							gui.SetValue("rbot_rifle_hitbox_pelvis", rifle_hitboxes["Pelvis"]);
							gui.SetValue("rbot_rifle_hitbox_arms", rifle_hitboxes["Arms"]);
							gui.SetValue("rbot_rifle_hitbox_legs", rifle_hitboxes["Legs"]);
							
							rifle_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, rifle_hscale);
							gui.SetValue("rbot_rifle_hitbox_head_ps", rifle_hscale / 100);
							rifle_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, rifle_nscale);
							gui.SetValue("rbot_rifle_hitbox_neck_ps", rifle_nscale / 100);
							rifle_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, rifle_cscale);
							gui.SetValue("rbot_rifle_hitbox_chest_ps", rifle_cscale / 100);
							rifle_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, rifle_sscale);
							gui.SetValue("rbot_rifle_hitbox_stomach_ps", rifle_sscale / 100);
							rifle_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, rifle_pscale);
							gui.SetValue("rbot_rifle_hitbox_pelvis_ps", rifle_pscale / 100);
							rifle_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, rifle_ascale);
							gui.SetValue("rbot_rifle_hitbox_arms_ps", rifle_ascale / 100);
							rifle_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, rifle_lscale);
							gui.SetValue("rbot_rifle_hitbox_legs_ps", rifle_lscale / 100);
							rifle_autoscale = SenseUI.Checkbox("Auto scale", rifle_autoscale);
							gui.SetValue("rbot_rifle_hitbox_auto_ps", rifle_autoscale);
							rifle_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, rifle_autoscales);
							gui.SetValue("rbot_rifle_hitbox_auto_ps_max", rifle_autoscales / 100);
								else if weapon_select == 5 then
								
								local shotgun_autowall = (gui.GetValue("rbot_shotgun_autowall") + 1);
								local shotgun_hitchance = gui.GetValue("rbot_shotgun_hitchance");
								local shotgun_mindamage = gui.GetValue("rbot_shotgun_mindamage");
								local shotgun_hitprior = (gui.GetValue("rbot_shotgun_hitbox") + 1);
								local shotgun_bodyaim = (gui.GetValue("rbot_shotgun_hitbox_bodyaim") + 1);
								local shotgun_method = (gui.GetValue("rbot_shotgun_hitbox_method") + 1);
								local shotgun_baimX = gui.GetValue("rbot_shotgun_bodyaftershots");
								local shotgun_baimHP = gui.GetValue("rbot_shotgun_bodyifhplower");
								local shotgun_hscale = (gui.GetValue("rbot_shotgun_hitbox_head_ps") * 100);
								local shotgun_nscale = (gui.GetValue("rbot_shotgun_hitbox_neck_ps") * 100);
								local shotgun_cscale = (gui.GetValue("rbot_shotgun_hitbox_chest_ps") * 100);
								local shotgun_sscale = (gui.GetValue("rbot_shotgun_hitbox_stomach_ps") * 100);
								local shotgun_pscale = (gui.GetValue("rbot_shotgun_hitbox_pelvis_ps") * 100);
								local shotgun_ascale = (gui.GetValue("rbot_shotgun_hitbox_arms_ps") * 100);
								local shotgun_lscale = (gui.GetValue("rbot_shotgun_hitbox_legs_ps") * 100);
								local shotgun_autoscale = gui.GetValue("rbot_shotgun_hitbox_auto_ps");
								local shotgun_autoscales = (gui.GetValue("rbot_shotgun_hitbox_auto_ps_max") * 100);
				
								shotgun_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, shotgun_hitboxes);
								gui.SetValue("rbot_shotgun_hitbox_head", shotgun_hitboxes["Head"]);
								gui.SetValue("rbot_shotgun_hitbox_neck", shotgun_hitboxes["Neck"]);
								gui.SetValue("rbot_shotgun_hitbox_chest", shotgun_hitboxes["Chest"]);
								gui.SetValue("rbot_shotgun_hitbox_stomach", shotgun_hitboxes["Stomach"]);
								gui.SetValue("rbot_shotgun_hitbox_pelvis", shotgun_hitboxes["Pelvis"]);
								gui.SetValue("rbot_shotgun_hitbox_arms", shotgun_hitboxes["Arms"]);
								gui.SetValue("rbot_shotgun_hitbox_legs", shotgun_hitboxes["Legs"]);
								
								shotgun_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, shotgun_hscale);
								gui.SetValue("rbot_shotgun_hitbox_head_ps", shotgun_hscale / 100);
								shotgun_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, shotgun_nscale);
								gui.SetValue("rbot_shotgun_hitbox_neck_ps", shotgun_nscale / 100);
								shotgun_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, shotgun_cscale);
								gui.SetValue("rbot_shotgun_hitbox_chest_ps", shotgun_cscale / 100);
								shotgun_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, shotgun_sscale);
								gui.SetValue("rbot_shotgun_hitbox_stomach_ps", shotgun_sscale / 100);
								shotgun_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, shotgun_pscale);
								gui.SetValue("rbot_shotgun_hitbox_pelvis_ps", shotgun_pscale / 100);
								shotgun_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, shotgun_ascale);
								gui.SetValue("rbot_shotgun_hitbox_arms_ps", shotgun_ascale / 100);
								shotgun_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, shotgun_lscale);
								gui.SetValue("rbot_shotgun_hitbox_legs_ps", shotgun_lscale / 100);
								shotgun_autoscale = SenseUI.Checkbox("Auto scale", shotgun_autoscale);
								gui.SetValue("rbot_shotgun_hitbox_auto_ps", shotgun_autoscale);
								shotgun_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, shotgun_autoscales);
								gui.SetValue("rbot_shotgun_hitbox_auto_ps_max", shotgun_autoscales / 100);
									else if weapon_select == 6 then
									
									local scout_autowall = (gui.GetValue("rbot_scout_autowall") + 1);
									local scout_hitchance = gui.GetValue("rbot_scout_hitchance");
									local scout_mindamage = gui.GetValue("rbot_scout_mindamage");
									local scout_hitprior = (gui.GetValue("rbot_scout_hitbox") + 1);
									local scout_bodyaim = (gui.GetValue("rbot_scout_hitbox_bodyaim") + 1);
									local scout_method = (gui.GetValue("rbot_scout_hitbox_method") + 1);
									local scout_baimX = gui.GetValue("rbot_scout_bodyaftershots");
									local scout_baimHP = gui.GetValue("rbot_scout_bodyifhplower");
									local scout_hscale = (gui.GetValue("rbot_scout_hitbox_head_ps") * 100);
									local scout_nscale = (gui.GetValue("rbot_scout_hitbox_neck_ps") * 100);
									local scout_cscale = (gui.GetValue("rbot_scout_hitbox_chest_ps") * 100);
									local scout_sscale = (gui.GetValue("rbot_scout_hitbox_stomach_ps") * 100);
									local scout_pscale = (gui.GetValue("rbot_scout_hitbox_pelvis_ps") * 100);
									local scout_ascale = (gui.GetValue("rbot_scout_hitbox_arms_ps") * 100);
									local scout_lscale = (gui.GetValue("rbot_scout_hitbox_legs_ps") * 100);
									local scout_autoscale = gui.GetValue("rbot_scout_hitbox_auto_ps");
									local scout_autoscales = (gui.GetValue("rbot_scout_hitbox_auto_ps_max") * 100);
				
									scout_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, scout_hitboxes);
									gui.SetValue("rbot_scout_hitbox_head", scout_hitboxes["Head"]);
									gui.SetValue("rbot_scout_hitbox_neck", scout_hitboxes["Neck"]);
									gui.SetValue("rbot_scout_hitbox_chest", scout_hitboxes["Chest"]);
									gui.SetValue("rbot_scout_hitbox_stomach", scout_hitboxes["Stomach"]);
									gui.SetValue("rbot_scout_hitbox_pelvis", scout_hitboxes["Pelvis"]);
									gui.SetValue("rbot_scout_hitbox_arms", scout_hitboxes["Arms"]);
									gui.SetValue("rbot_scout_hitbox_legs", scout_hitboxes["Legs"]);
									
									scout_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, scout_hscale);
									gui.SetValue("rbot_scout_hitbox_head_ps", scout_hscale / 100);
									scout_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, scout_nscale);
									gui.SetValue("rbot_scout_hitbox_neck_ps", scout_nscale / 100);
									scout_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, scout_cscale);
									gui.SetValue("rbot_scout_hitbox_chest_ps", scout_cscale / 100);
									scout_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, scout_sscale);
									gui.SetValue("rbot_scout_hitbox_stomach_ps", scout_sscale / 100);
									scout_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, scout_pscale);
									gui.SetValue("rbot_scout_hitbox_pelvis_ps", scout_pscale / 100);
									scout_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, scout_ascale);
									gui.SetValue("rbot_scout_hitbox_arms_ps", scout_ascale / 100);
									scout_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, scout_lscale);
									gui.SetValue("rbot_scout_hitbox_legs_ps", scout_lscale / 100);
									scout_autoscale = SenseUI.Checkbox("Auto scale", scout_autoscale);
									gui.SetValue("rbot_scout_hitbox_auto_ps", scout_autoscale);
									scout_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, scout_autoscales);
									gui.SetValue("rbot_scout_hitbox_auto_ps_max", scout_autoscales / 100);
										else if weapon_select == 7 then
										
										local autosniper_autowall = (gui.GetValue("rbot_autosniper_autowall") + 1);
										local autosniper_hitchance = gui.GetValue("rbot_autosniper_hitchance");
										local autosniper_mindamage = gui.GetValue("rbot_autosniper_mindamage");
										local autosniper_hitprior = (gui.GetValue("rbot_autosniper_hitbox") + 1);
										local autosniper_bodyaim = (gui.GetValue("rbot_autosniper_hitbox_bodyaim") + 1);
										local autosniper_method = (gui.GetValue("rbot_autosniper_hitbox_method") + 1);
										local autosniper_baimX = gui.GetValue("rbot_autosniper_bodyaftershots");
										local autosniper_baimHP = gui.GetValue("rbot_autosniper_bodyifhplower");
										local autosniper_hscale = (gui.GetValue("rbot_autosniper_hitbox_head_ps") * 100);
										local autosniper_nscale = (gui.GetValue("rbot_autosniper_hitbox_neck_ps") * 100);
										local autosniper_cscale = (gui.GetValue("rbot_autosniper_hitbox_chest_ps") * 100);
										local autosniper_sscale = (gui.GetValue("rbot_autosniper_hitbox_stomach_ps") * 100);
										local autosniper_pscale = (gui.GetValue("rbot_autosniper_hitbox_pelvis_ps") * 100);
										local autosniper_ascale = (gui.GetValue("rbot_autosniper_hitbox_arms_ps") * 100);
										local autosniper_lscale = (gui.GetValue("rbot_autosniper_hitbox_legs_ps") * 100);
										local autosniper_autoscale = gui.GetValue("rbot_autosniper_hitbox_auto_ps");
										local autosniper_autoscales = (gui.GetValue("rbot_autosniper_hitbox_auto_ps_max") * 100);
				
										autosniper_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, autosniper_hitboxes);
										gui.SetValue("rbot_autosniper_hitbox_head", autosniper_hitboxes["Head"]);
										gui.SetValue("rbot_autosniper_hitbox_neck", autosniper_hitboxes["Neck"]);
										gui.SetValue("rbot_autosniper_hitbox_chest", autosniper_hitboxes["Chest"]);
										gui.SetValue("rbot_autosniper_hitbox_stomach", autosniper_hitboxes["Stomach"]);
										gui.SetValue("rbot_autosniper_hitbox_pelvis", autosniper_hitboxes["Pelvis"]);
										gui.SetValue("rbot_autosniper_hitbox_arms", autosniper_hitboxes["Arms"]);
										gui.SetValue("rbot_autosniper_hitbox_legs", autosniper_hitboxes["Legs"]);
										
										autosniper_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, autosniper_hscale);
										gui.SetValue("rbot_autosniper_hitbox_head_ps", autosniper_hscale / 100);
										autosniper_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, autosniper_nscale);
										gui.SetValue("rbot_autosniper_hitbox_neck_ps", autosniper_nscale / 100);
										autosniper_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, autosniper_cscale);
										gui.SetValue("rbot_autosniper_hitbox_chest_ps", autosniper_cscale / 100);
										autosniper_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, autosniper_sscale);
										gui.SetValue("rbot_autosniper_hitbox_stomach_ps", autosniper_sscale / 100);
										autosniper_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, autosniper_pscale);
										gui.SetValue("rbot_autosniper_hitbox_pelvis_ps", autosniper_pscale / 100);
										autosniper_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, autosniper_ascale);
										gui.SetValue("rbot_autosniper_hitbox_arms_ps", autosniper_ascale / 100);
										autosniper_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, autosniper_lscale);
										gui.SetValue("rbot_autosniper_hitbox_legs_ps", autosniper_lscale / 100);
										autosniper_autoscale = SenseUI.Checkbox("Auto scale", autosniper_autoscale);
										gui.SetValue("rbot_autosniper_hitbox_auto_ps", autosniper_autoscale);
										autosniper_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, autosniper_autoscales);
										gui.SetValue("rbot_autosniper_hitbox_auto_ps_max", autosniper_autoscales / 100);									
											else if weapon_select == 8 then
											
											local sniper_autowall = (gui.GetValue("rbot_sniper_autowall") + 1);
											local sniper_hitchance = gui.GetValue("rbot_sniper_hitchance");
											local sniper_mindamage = gui.GetValue("rbot_sniper_mindamage");
											local sniper_hitprior = (gui.GetValue("rbot_sniper_hitbox") + 1);
											local sniper_bodyaim = (gui.GetValue("rbot_sniper_hitbox_bodyaim") + 1);
											local sniper_method = (gui.GetValue("rbot_sniper_hitbox_method") + 1);
											local sniper_baimX = gui.GetValue("rbot_sniper_bodyaftershots");
											local sniper_baimHP = gui.GetValue("rbot_sniper_bodyifhplower");
											local sniper_hscale = (gui.GetValue("rbot_sniper_hitbox_head_ps") * 100);
											local sniper_nscale = (gui.GetValue("rbot_sniper_hitbox_neck_ps") * 100);
											local sniper_cscale = (gui.GetValue("rbot_sniper_hitbox_chest_ps") * 100);
											local sniper_sscale = (gui.GetValue("rbot_sniper_hitbox_stomach_ps") * 100);
											local sniper_pscale = (gui.GetValue("rbot_sniper_hitbox_pelvis_ps") * 100);
											local sniper_ascale = (gui.GetValue("rbot_sniper_hitbox_arms_ps") * 100);
											local sniper_lscale = (gui.GetValue("rbot_sniper_hitbox_legs_ps") * 100);
											local sniper_autoscale = gui.GetValue("rbot_sniper_hitbox_auto_ps");
											local sniper_autoscales = (gui.GetValue("rbot_sniper_hitbox_auto_ps_max") * 100);
				
											sniper_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, sniper_hitboxes);
											gui.SetValue("rbot_sniper_hitbox_head", sniper_hitboxes["Head"]);
											gui.SetValue("rbot_sniper_hitbox_neck", sniper_hitboxes["Neck"]);
											gui.SetValue("rbot_sniper_hitbox_chest", sniper_hitboxes["Chest"]);
											gui.SetValue("rbot_sniper_hitbox_stomach", sniper_hitboxes["Stomach"]);
											gui.SetValue("rbot_sniper_hitbox_pelvis", sniper_hitboxes["Pelvis"]);
											gui.SetValue("rbot_sniper_hitbox_arms", sniper_hitboxes["Arms"]);
											gui.SetValue("rbot_sniper_hitbox_legs", sniper_hitboxes["Legs"]);
											
											sniper_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, sniper_hscale);
											gui.SetValue("rbot_sniper_hitbox_head_ps", sniper_hscale / 100);
											sniper_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, sniper_nscale);
											gui.SetValue("rbot_sniper_hitbox_neck_ps", sniper_nscale / 100);
											sniper_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, sniper_cscale);
											gui.SetValue("rbot_sniper_hitbox_chest_ps", sniper_cscale / 100);
											sniper_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, sniper_sscale);
											gui.SetValue("rbot_sniper_hitbox_stomach_ps", sniper_sscale / 100);
											sniper_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, sniper_pscale);
											gui.SetValue("rbot_sniper_hitbox_pelvis_ps", sniper_pscale / 100);
											sniper_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, sniper_ascale);
											gui.SetValue("rbot_sniper_hitbox_arms_ps", sniper_ascale / 100);
											sniper_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, sniper_lscale);
											gui.SetValue("rbot_sniper_hitbox_legs_ps", sniper_lscale / 100);
											sniper_autoscale = SenseUI.Checkbox("Auto scale", sniper_autoscale);
											gui.SetValue("rbot_sniper_hitbox_auto_ps", sniper_autoscale);
											sniper_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, sniper_autoscales);
											gui.SetValue("rbot_sniper_hitbox_auto_ps_max", sniper_autoscales / 100);										
												else if weapon_select == 9 then
												
												local lmg_autowall = (gui.GetValue("rbot_lmg_autowall") + 1);
												local lmg_hitchance = gui.GetValue("rbot_lmg_hitchance");
												local lmg_mindamage = gui.GetValue("rbot_lmg_mindamage");
												local lmg_hitprior = (gui.GetValue("rbot_lmg_hitbox") + 1);
												local lmg_bodyaim = (gui.GetValue("rbot_lmg_hitbox_bodyaim") + 1);
												local lmg_method = (gui.GetValue("rbot_lmg_hitbox_method") + 1);
												local lmg_baimX = gui.GetValue("rbot_lmg_bodyaftershots");
												local lmg_baimHP = gui.GetValue("rbot_lmg_bodyifhplower");
												local lmg_hscale = (gui.GetValue("rbot_lmg_hitbox_head_ps") * 100);
												local lmg_nscale = (gui.GetValue("rbot_lmg_hitbox_neck_ps") * 100);
												local lmg_cscale = (gui.GetValue("rbot_lmg_hitbox_chest_ps") * 100);
												local lmg_sscale = (gui.GetValue("rbot_lmg_hitbox_stomach_ps") * 100);
												local lmg_pscale = (gui.GetValue("rbot_lmg_hitbox_pelvis_ps") * 100);
												local lmg_ascale = (gui.GetValue("rbot_lmg_hitbox_arms_ps") * 100);
												local lmg_lscale = (gui.GetValue("rbot_lmg_hitbox_legs_ps") * 100);
												local lmg_autoscale = gui.GetValue("rbot_lmg_hitbox_auto_ps");
												local lmg_autoscales = (gui.GetValue("rbot_lmg_hitbox_auto_ps_max") * 100);
				
												lmg_hitboxes = SenseUI.MultiCombo("Hitbox filter", { "Head", "Neck", "Chest", "Stomach", "Pelvis", "Arms", "Legs" }, lmg_hitboxes);
												gui.SetValue("rbot_lmg_hitbox_head", lmg_hitboxes["Head"]);
												gui.SetValue("rbot_lmg_hitbox_neck", lmg_hitboxes["Neck"]);
												gui.SetValue("rbot_lmg_hitbox_chest", lmg_hitboxes["Chest"]);
												gui.SetValue("rbot_lmg_hitbox_stomach", lmg_hitboxes["Stomach"]);
												gui.SetValue("rbot_lmg_hitbox_pelvis", lmg_hitboxes["Pelvis"]);
												gui.SetValue("rbot_lmg_hitbox_arms", lmg_hitboxes["Arms"]);
												gui.SetValue("rbot_lmg_hitbox_legs", lmg_hitboxes["Legs"]);
												
												lmg_hscale = SenseUI.Slider("Head scale", 0, 100, "%", "0%", "100%", false, lmg_hscale);
												gui.SetValue("rbot_lmg_hitbox_head_ps", lmg_hscale / 100);
												lmg_nscale = SenseUI.Slider("Neck scale", 0, 100, "%", "0%", "100%", false, lmg_nscale);
												gui.SetValue("rbot_lmg_hitbox_neck_ps", lmg_nscale / 100);
												lmg_cscale = SenseUI.Slider("Chest scale", 0, 100, "%", "0%", "100%", false, lmg_cscale);
												gui.SetValue("rbot_lmg_hitbox_chest_ps", lmg_cscale / 100);
												lmg_sscale = SenseUI.Slider("Stomach scale", 0, 100, "%", "0%", "100%", false, lmg_sscale);
												gui.SetValue("rbot_lmg_hitbox_stomach_ps", lmg_sscale / 100);
												lmg_pscale = SenseUI.Slider("Pelvis scale", 0, 100, "%", "0%", "100%", false, lmg_pscale);
												gui.SetValue("rbot_lmg_hitbox_pelvis_ps", lmg_pscale / 100);
												lmg_ascale = SenseUI.Slider("Arms scale", 0, 100, "%", "0%", "100%", false, lmg_ascale);
												gui.SetValue("rbot_lmg_hitbox_arms_ps", lmg_ascale / 100);
												lmg_lscale = SenseUI.Slider("Legs scale", 0, 100, "%", "0%", "100%", false, lmg_lscale);
												gui.SetValue("rbot_lmg_hitbox_legs_ps", lmg_lscale / 100);
												lmg_autoscale = SenseUI.Checkbox("Auto scale", lmg_autoscale);
												gui.SetValue("rbot_lmg_hitbox_auto_ps", lmg_autoscale);
												lmg_autoscales = SenseUI.Slider("Auto scale Max", 0, 100, "%", "0%", "100%", false, lmg_autoscales);
												gui.SetValue("rbot_lmg_hitbox_auto_ps_max", lmg_autoscales / 100);											
												end
											end
										end
									end
								end
							end
						end
					end
				end
			SenseUI.EndGroup();
			end
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "vissettings", SenseUI.Icons.visuals ) then			
			if SenseUI.BeginGroup( "visual1", "Visuals", 25, 25, 235, 630 ) then
				SenseUI.Label("Player Select");
				pselect = SenseUI.Combo("pselect", { "Enemy", "Team", "Yourself", "Weapons", "Other", "Miscellaneous" }, pselect);
				if pselect == 1 then
					local enemy_filter = gui.GetValue("esp_filter_enemy");
					enemy_filter = SenseUI.Checkbox("Enable", enemy_filter);
					gui.SetValue("esp_filter_enemy", enemy_filter);
					local enemy_dormant = gui.GetValue("esp_dormant_enemy");
					enemy_dormant = SenseUI.Checkbox("Dormant", enemy_dormant);
					gui.SetValue("esp_dormant_enemy", enemy_dormant);
					SenseUI.Label("Bounding box");
					local enemy_box = (gui.GetValue("esp_enemy_box") + 1);
					enemy_box = SenseUI.Combo("enemy_box", { "Off", "2D", "3D", "Edges", "Machine", "Pentagon", "Hexagon" }, enemy_box);
					gui.SetValue("esp_enemy_box", enemy_box-1);
					local enemy_outline = gui.GetValue("esp_enemy_box_outline");
					enemy_outline = SenseUI.Checkbox("Box outline", enemy_outline);
					gui.SetValue("esp_enemy_box_outline", enemy_outline);
					local enemy_precision = gui.GetValue("esp_enemy_box_precise");
					enemy_precision = SenseUI.Checkbox("Box precision", enemy_precision);
					gui.SetValue("esp_enemy_box_precise", enemy_precision);
					local enemy_name = gui.GetValue("esp_enemy_name");
					enemy_name = SenseUI.Checkbox("Box name", enemy_name);
					gui.SetValue("esp_enemy_name", enemy_name);
					SenseUI.Label("Box health");
					local enemy_health = (gui.GetValue("esp_enemy_health") + 1);
					enemy_health = SenseUI.Combo("esp_enemy_health", { "Off", "Bar", "Number", "Both" }, enemy_health);
					gui.SetValue("esp_enemy_health", enemy_health-1);
					local enemy_armor = gui.GetValue("esp_enemy_armor");
					enemy_armor = SenseUI.Checkbox("Box armor", enemy_armor);
					gui.SetValue("esp_enemy_armor", enemy_armor);
					SenseUI.Label("Box weapon");
					local enemy_weapon = (gui.GetValue("esp_enemy_weapon") + 1);
					enemy_weapon = SenseUI.Combo("esp_enemy_weapon", { "Off", "Show Active", "Show All" }, enemy_weapon);
					gui.SetValue("esp_enemy_weapon", enemy_weapon-1);
					local enemy_skeleton = gui.GetValue("esp_enemy_skeleton");
					enemy_skeleton = SenseUI.Checkbox("Skeleton", enemy_skeleton);
					gui.SetValue("esp_enemy_skeleton", enemy_skeleton);
					SenseUI.Label("Hitbox model");
					local enemy_hmodel = (gui.GetValue("esp_enemy_hitbox") + 1);
					enemy_hmodel = SenseUI.Combo("esp_enemy_hitbox", { "Off", "White", "Color" }, enemy_hmodel);
					gui.SetValue("esp_enemy_hitbox", enemy_hmodel-1);
					local enemy_hs = gui.GetValue("esp_enemy_headspot");
					enemy_hs = SenseUI.Checkbox("Headspot", enemy_hs);
					gui.SetValue("esp_enemy_headspot", enemy_hs);
					local enemy_aimpoints = gui.GetValue("esp_enemy_aimpoints");
					enemy_aimpoints = SenseUI.Checkbox("Aim points", enemy_aimpoints);
					gui.SetValue("esp_enemy_aimpoints", enemy_aimpoints);
					SenseUI.Label("Glow");
					local enemy_glow = (gui.GetValue("esp_enemy_glow") + 1);
					enemy_glow = SenseUI.Combo("esp_enemy_glow", { "Off", "Normal", "Health" }, enemy_glow);
					gui.SetValue("esp_enemy_glow", enemy_glow-1);
					SenseUI.Label("Chams");
					local enemy_chams = (gui.GetValue("esp_enemy_chams") + 1);
					enemy_chams = SenseUI.Combo("esp_enemy_chams", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, enemy_chams);
					gui.SetValue("esp_enemy_chams", enemy_chams-1);
					local enemy_xqz = gui.GetValue("esp_enemy_xqz");
					enemy_xqz = SenseUI.Checkbox("Chams through wall", enemy_xqz);
					gui.SetValue("esp_enemy_xqz", enemy_xqz);
					enemy_flags = SenseUI.MultiCombo("Flags", { "Has C4", "Has Defuser", "Is Defusing", "Is Flashed", "Is Scoped", "Is Reloading", "Competitive Rank", "Money" }, enemy_flags);
					gui.SetValue("esp_enemy_hasc4", enemy_flags["Has C4"]);
					gui.SetValue("esp_enemy_hasdefuser", enemy_flags["Has Defuser"]);
					gui.SetValue("esp_enemy_defusing", enemy_flags["Is Defusing"]);
					gui.SetValue("esp_enemy_flashed", enemy_flags["Is Flashed"]);
					gui.SetValue("esp_enemy_scoped", enemy_flags["Is Scoped"]);
					gui.SetValue("esp_enemy_reloading", enemy_flags["Is Reloading"]);
					gui.SetValue("esp_enemy_comprank", enemy_flags["Competitive Rank"]);
					gui.SetValue("esp_enemy_money", enemy_flags["Money"]);
					local enemy_barrel = gui.GetValue("esp_enemy_barrel");
					enemy_barrel = SenseUI.Checkbox("Line of sight", enemy_barrel);
					gui.SetValue("esp_enemy_barrel", enemy_barrel);
					SenseUI.Label("Ammo");
					local enemy_ammo = (gui.GetValue("esp_enemy_ammo") + 1);
					enemy_ammo = SenseUI.Combo("esp_enemy_ammo", { "Off", "Number", "Bar" }, enemy_ammo);
					gui.SetValue("esp_enemy_ammo", enemy_ammo-1);
					local enemy_damage = gui.GetValue("esp_enemy_damage");
					enemy_damage = SenseUI.Checkbox("Hit damage", enemy_damage);
					gui.SetValue("esp_enemy_damage", enemy_damage);
					
					elseif pselect == 2 then
						local team_filter = gui.GetValue("esp_filter_team");
						team_filter = SenseUI.Checkbox("Enable", team_filter);
						gui.SetValue("esp_filter_team", team_filter);
						local team_dormant = gui.GetValue("esp_dormant_team");
						team_dormant = SenseUI.Checkbox("Dormant", team_dormant);
						gui.SetValue("esp_dormant_team", team_dormant);
						SenseUI.Label("Bounding box");
						local team_box = (gui.GetValue("esp_team_box") + 1);
						team_box = SenseUI.Combo("team_box", { "Off", "2D", "3D", "Edges", "Machine", "Pentagon", "Hexagon" }, team_box);
						gui.SetValue("esp_team_box", team_box-1);
						local team_outline = gui.GetValue("esp_team_box_outline");
						team_outline = SenseUI.Checkbox("Box outline", team_outline);
						gui.SetValue("esp_team_box_outline", team_outline);
						local team_precision = gui.GetValue("esp_team_box_precise");
						team_precision = SenseUI.Checkbox("Box precision", team_precision);
						gui.SetValue("esp_team_box_precise", team_precision);
						local team_name = gui.GetValue("esp_team_name");
						team_name = SenseUI.Checkbox("Box name", team_name);
						gui.SetValue("esp_team_name", team_name);
						SenseUI.Label("Box health");
						local team_health = (gui.GetValue("esp_team_health") + 1);
						team_health = SenseUI.Combo("esp_team_health", { "Off", "Bar", "Number", "Both" }, team_health);
						gui.SetValue("esp_team_health", team_health-1);
						local team_armor = gui.GetValue("esp_team_armor");
						team_armor = SenseUI.Checkbox("Box armor", team_armor);
						gui.SetValue("esp_team_armor", team_armor);
						SenseUI.Label("Box weapon");
						local team_weapon = (gui.GetValue("esp_team_weapon") + 1);
						team_weapon = SenseUI.Combo("esp_team_weapon", { "Off", "Show Active", "Show All" }, team_weapon);
						gui.SetValue("esp_team_weapon", team_weapon-1);
						local team_skeleton = gui.GetValue("esp_team_skeleton");
						team_skeleton = SenseUI.Checkbox("Skeleton", team_skeleton);
						gui.SetValue("esp_team_skeleton", team_skeleton);
						SenseUI.Label("Hitbox model");
						local team_hmodel = (gui.GetValue("esp_team_hitbox") + 1);
						team_hmodel = SenseUI.Combo("esp_team_hitbox", { "Off", "White", "Color" }, team_hmodel);
						gui.SetValue("esp_team_hitbox", team_hmodel-1);
						local team_hs = gui.GetValue("esp_team_headspot");
						team_hs = SenseUI.Checkbox("Headspot", team_hs);
						gui.SetValue("esp_team_headspot", team_hs);
						local team_aimpoints = gui.GetValue("esp_team_aimpoints");
						team_aimpoints = SenseUI.Checkbox("Aim points", team_aimpoints);
						gui.SetValue("esp_team_aimpoints", team_aimpoints);
						SenseUI.Label("Glow");
						local team_glow = (gui.GetValue("esp_team_glow") + 1);
						team_glow = SenseUI.Combo("esp_team_glow", { "Off", "Normal", "Health" }, team_glow);
						gui.SetValue("esp_team_glow", team_glow-1);
						SenseUI.Label("Chams");
						local team_chams = (gui.GetValue("esp_team_chams") + 1);
						team_chams = SenseUI.Combo("esp_team_chams", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, team_chams);
						gui.SetValue("esp_team_chams", team_chams-1);
						local team_xqz = gui.GetValue("esp_team_xqz");
						team_xqz = SenseUI.Checkbox("Chams through wall", team_xqz);
						gui.SetValue("esp_team_xqz", team_xqz);
						team_flags = SenseUI.MultiCombo("Flags", { "Has C4", "Has Defuser", "Is Defusing", "Is Flashed", "Is Scoped", "Is Reloading", "Competitive Rank", "Money" }, team_flags);
						gui.SetValue("esp_team_hasc4", team_flags["Has C4"]);
						gui.SetValue("esp_team_hasdefuser", team_flags["Has Defuser"]);
						gui.SetValue("esp_team_defusing", team_flags["Is Defusing"]);
						gui.SetValue("esp_team_flashed", team_flags["Is Flashed"]);
						gui.SetValue("esp_team_scoped", team_flags["Is Scoped"]);
						gui.SetValue("esp_team_reloading", team_flags["Is Reloading"]);
						gui.SetValue("esp_team_comprank", team_flags["Competitive Rank"]);
						gui.SetValue("esp_team_money", team_flags["Money"]);
						local team_barrel = gui.GetValue("esp_team_barrel");
						team_barrel = SenseUI.Checkbox("Line of sight", team_barrel);
						gui.SetValue("esp_team_barrel", team_barrel);
						SenseUI.Label("Ammo");
						local team_ammo = (gui.GetValue("esp_team_ammo") + 1);
						team_ammo = SenseUI.Combo("esp_team_ammo", { "Off", "Number", "Bar" }, team_ammo);
						gui.SetValue("esp_team_ammo", team_ammo-1);
						local team_damage = gui.GetValue("esp_team_damage");
						team_damage = SenseUI.Checkbox("Hit damage", team_damage);
						gui.SetValue("esp_team_damage", team_damage);
						
						elseif pselect == 3 then
							local self_filter = gui.GetValue("esp_filter_self");
							self_filter = SenseUI.Checkbox("Enable", self_filter);
							gui.SetValue("esp_filter_self", self_filter);
							SenseUI.Label("Bounding box");
							local self_box = (gui.GetValue("esp_self_box") + 1);
							self_box = SenseUI.Combo("self_box", { "Off", "2D", "3D", "Edges", "Machine", "Pentagon", "Hexagon" }, self_box);
							gui.SetValue("esp_self_box", self_box-1);
							local self_outline = gui.GetValue("esp_self_box_outline");
							self_outline = SenseUI.Checkbox("Box outline", self_outline);
							gui.SetValue("esp_self_box_outline", self_outline);
							local self_precision = gui.GetValue("esp_self_box_precise");
							self_precision = SenseUI.Checkbox("Box precision", self_precision);
							gui.SetValue("esp_self_box_precise", self_precision);
							local self_name = gui.GetValue("esp_self_name");
							self_name = SenseUI.Checkbox("Box name", self_name);
							gui.SetValue("esp_self_name", self_name);
							SenseUI.Label("Box health");
							local self_health = (gui.GetValue("esp_self_health") + 1);
							self_health = SenseUI.Combo("esp_self_health", { "Off", "Bar", "Number", "Both" }, self_health);
							gui.SetValue("esp_self_health", self_health-1);
							local self_armor = gui.GetValue("esp_self_armor");
							self_armor = SenseUI.Checkbox("Box armor", self_armor);
							gui.SetValue("esp_self_armor", self_armor);
							SenseUI.Label("Box weapon");
							local self_weapon = (gui.GetValue("esp_self_weapon") + 1);
							self_weapon = SenseUI.Combo("esp_self_weapon", { "Off", "Show Active", "Show All" }, self_weapon);
							gui.SetValue("esp_self_weapon", self_weapon-1);
							local self_skeleton = gui.GetValue("esp_self_skeleton");
							self_skeleton = SenseUI.Checkbox("Skeleton", self_skeleton);
							gui.SetValue("esp_self_skeleton", self_skeleton);
							SenseUI.Label("Hitbox model");
							local self_hmodel = (gui.GetValue("esp_self_hitbox") + 1);
							self_hmodel = SenseUI.Combo("esp_self_hitbox", { "Off", "White", "Color" }, self_hmodel);
							gui.SetValue("esp_self_hitbox", self_hmodel-1);
							local self_hs = gui.GetValue("esp_self_headspot");
							self_hs = SenseUI.Checkbox("Headspot", self_hs);
							gui.SetValue("esp_self_headspot", self_hs);
							local self_aimpoints = gui.GetValue("esp_self_aimpoints");
							self_aimpoints = SenseUI.Checkbox("Aim points", self_aimpoints);
							gui.SetValue("esp_self_aimpoints", self_aimpoints);
							SenseUI.Label("Glow");
							local self_glow = (gui.GetValue("esp_self_glow") + 1);
							self_glow = SenseUI.Combo("esp_self_glow", { "Off", "Normal", "Health" }, self_glow);
							gui.SetValue("esp_self_glow", self_glow-1);
							SenseUI.Label("Chams");
							local self_chams = (gui.GetValue("esp_self_chams") + 1);
							self_chams = SenseUI.Combo("esp_self_chams", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, self_chams);
							gui.SetValue("esp_self_chams", self_chams-1);
							local self_xqz = gui.GetValue("esp_self_xqz");
							self_xqz = SenseUI.Checkbox("Chams through wall", self_xqz);
							gui.SetValue("esp_self_xqz", self_xqz);
							self_flags = SenseUI.MultiCombo("Flags", { "Has C4", "Has Defuser", "Is Defusing", "Is Flashed", "Is Scoped", "Is Reloading", "Competitive Rank", "Money" }, self_flags);
							gui.SetValue("vis_noflash", self_flags["Has C4"]);--gui.SetValue("esp_self_hasc4", removals["NoFlash"]);
							gui.SetValue("esp_self_hasdefuser", self_flags["Has Defuser"]);
							gui.SetValue("esp_self_defusing", self_flags["Is Defusing"]);
							gui.SetValue("esp_self_flashed", self_flags["Is Flashed"]);
							gui.SetValue("esp_self_scoped", self_flags["Is Scoped"]);
							gui.SetValue("esp_self_reloading", self_flags["Is Reloading"]);
							gui.SetValue("esp_self_comprank", self_flags["Competitive Rank"]);
							gui.SetValue("esp_self_money", self_flags["Money"]);
							local self_barrel = gui.GetValue("esp_self_barrel");
							self_barrel = SenseUI.Checkbox("Line of sight", self_barrel);
							gui.SetValue("esp_self_barrel", self_barrel);
							SenseUI.Label("Ammo");
							local self_ammo = (gui.GetValue("esp_self_ammo") + 1);
							self_ammo = SenseUI.Combo("esp_self_ammo", { "Off", "Number", "Bar" }, self_ammo);
							gui.SetValue("esp_self_ammo", self_ammo-1);
							local self_damage = gui.GetValue("esp_self_damage");
							self_damage = SenseUI.Checkbox("Hit damage", self_damage);
							gui.SetValue("esp_self_damage", self_damage);
							
							elseif pselect == 4 then
								local weapon_filter = gui.GetValue("esp_filter_weapon");
								weapon_filter = SenseUI.Checkbox("Enable", weapon_filter);
								gui.SetValue("esp_filter_weapon", weapon_filter);
								SenseUI.Label("Bounding box");
								local weapon_box = (gui.GetValue("esp_weapon_box") + 1);
								weapon_box = SenseUI.Combo("weapon_box", { "Off", "2D", "3D", "Edges", "Machine", "Pentagon", "Hexagon" }, weapon_box);
								gui.SetValue("esp_weapon_box", weapon_box-1);
								local weapon_outline = gui.GetValue("esp_weapon_box_outline");
								weapon_outline = SenseUI.Checkbox("Box outline", weapon_outline);
								gui.SetValue("esp_weapon_box_outline", weapon_outline);
								local weapon_precision = gui.GetValue("esp_weapon_box_precise");
								weapon_precision = SenseUI.Checkbox("Box precision", weapon_precision);
								gui.SetValue("esp_weapon_box_precise", weapon_precision);
								local weapon_name = gui.GetValue("esp_weapon_name");
								weapon_name = SenseUI.Checkbox("Box name", weapon_name);
								gui.SetValue("esp_weapon_name", weapon_name);
								SenseUI.Label("Glow");
								local weapon_glow = (gui.GetValue("esp_weapon_glow") + 1);
								weapon_glow = SenseUI.Combo("esp_weapon_glow", { "Off", "Normal", "Health" }, weapon_glow);
								gui.SetValue("esp_weapon_glow", weapon_glow-1);
								SenseUI.Label("Chams");
								local weapon_chams = (gui.GetValue("esp_weapon_chams") + 1);
								weapon_chams = SenseUI.Combo("esp_weapon_chams", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, weapon_chams);
								gui.SetValue("esp_weapon_chams", weapon_chams-1);
								local weapon_xqz = gui.GetValue("esp_weapon_xqz");
								weapon_xqz = SenseUI.Checkbox("Chams through wall", weapon_xqz);
								gui.SetValue("esp_weapon_xqz", weapon_xqz);
								SenseUI.Label("Ammo");
								local weapon_ammo = (gui.GetValue("esp_weapon_ammo") + 1);
								weapon_ammo = SenseUI.Combo("esp_weapon_ammo", { "Off", "Number", "Bar" }, weapon_ammo);
								gui.SetValue("esp_weapon_ammo", weapon_ammo-1);
								
								elseif pselect == 5 then
									local other_pc4 = gui.GetValue("esp_filter_plantedc4");
									other_pc4 = SenseUI.Checkbox("Planted C4", other_pc4);
									gui.SetValue("esp_filter_plantedc4", other_pc4);
									local other_nade = gui.GetValue("esp_filter_grenades");
									other_nade = SenseUI.Checkbox("Nades", other_nade);
									gui.SetValue("esp_filter_grenades", other_nade);
									local other_chick = gui.GetValue("esp_filter_chickens");
									other_chick = SenseUI.Checkbox("Chickens", other_chick);
									gui.SetValue("esp_filter_chickens", other_chick);
									local other_host = gui.GetValue("esp_filter_hostages");
									other_host = SenseUI.Checkbox("Hostages", other_host);
									gui.SetValue("esp_filter_hostages", other_host);
									local other_items = gui.GetValue("esp_filter_items");
									other_items = SenseUI.Checkbox("Items", other_items);
									gui.SetValue("esp_filter_items", other_items);
									SenseUI.Label("Bounding box");
									local other_box = (gui.GetValue("esp_other_box") + 1);
									other_box = SenseUI.Combo("other_box", { "Off", "2D", "3D", "Edges", "Machine", "Pentagon", "Hexagon" }, other_box);
									gui.SetValue("esp_other_box", other_box-1);
									local other_outline = gui.GetValue("esp_other_box_outline");
									other_outline = SenseUI.Checkbox("Box outline", other_outline);
									gui.SetValue("esp_other_box_outline", other_outline);
									local other_precision = gui.GetValue("esp_other_box_precise");
									other_precision = SenseUI.Checkbox("Box precision", other_precision);
									gui.SetValue("esp_other_box_precise", other_precision);
									local other_name = gui.GetValue("esp_other_name");
									other_name = SenseUI.Checkbox("Box name", other_name);
									gui.SetValue("esp_other_name", other_name);
									SenseUI.Label("Glow");
									local other_glow = (gui.GetValue("esp_other_glow") + 1);
									other_glow = SenseUI.Combo("esp_other_glow", { "Off", "Normal", "Health" }, other_glow);
									gui.SetValue("esp_other_glow", other_glow-1);
									SenseUI.Label("Chams");
									local other_chams = (gui.GetValue("esp_other_chams") + 1);
									other_chams = SenseUI.Combo("esp_other_chams", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, other_chams);
									gui.SetValue("esp_other_chams", other_chams-1);
									local other_xqz = gui.GetValue("esp_other_xqz");
									other_xqz = SenseUI.Checkbox("Chams through wall", other_xqz);
									gui.SetValue("esp_other_xqz", other_xqz);
									local other_name = gui.GetValue("esp_other_name");
									other_name = SenseUI.Checkbox("Box name", other_name);
									gui.SetValue("esp_other_name", other_name);
									
									elseif pselect == 6 then
										local vfov = gui.GetValue("vis_view_fov");
										vfov = SenseUI.Slider("Override FOV", 0, 120, "°", "0°", "120°", false, vfov);
										gui.SetValue("vis_view_fov", vfov);
										local vfovm = gui.GetValue("vis_view_model_fov");
										vfovm = SenseUI.Slider("Override model FOV", 0, 120, "°", "0°", "120°", false, vfovm);
										gui.SetValue("vis_view_model_fov", vfovm);
										SenseUI.Label("Hand chams");
										local hand_chams = (gui.GetValue("vis_chams_hands") + 1);
										hand_chams = SenseUI.Combo("vis_chams_hands", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, hand_chams);
										gui.SetValue("vis_chams_hands", hand_chams-1);
										SenseUI.Label("Weapon chams");
										local weapon_chams = (gui.GetValue("vis_chams_weapon") + 1);
										weapon_chams = SenseUI.Combo("vis_chams_weapon", { "Off", "Color", "Material", "Color Wireframe", "Mat Wireframe", "Invisible", "Metallic", "Flat" }, weapon_chams);
										gui.SetValue("vis_chams_weapon", weapon_chams-1);
										SenseUI.Label("Fake chams");
										local fakeghost = (gui.GetValue("vis_fakeghost") + 1);
										fakeghost = SenseUI.Combo("vis_fakeghost", { "Off", "Client", "Server", "Both" }, fakeghost);
										gui.SetValue("vis_fakeghost", fakeghost-1);
										removals = SenseUI.MultiCombo("Removals", { "Flash", "Smoke", "Recoil" }, removals);
										gui.SetValue("vis_noflash", removals["Flash"]);
										gui.SetValue("vis_nosmoke", removals["Smoke"]);
										gui.SetValue("vis_norecoil", removals["Recoil"]);
										SenseUI.Label("Scope remove");
										local scoperem = (gui.GetValue("vis_scoperemover") + 1);				
										scoperem = SenseUI.Combo("vis_scoperemover", { "Off", "On", "On + Lines" }, scoperem);
										gui.SetValue("vis_scoperemover", scoperem-1);
										local transparentwalls = (gui.GetValue("vis_asus") * 100);
										transparentwalls = SenseUI.Slider("Transparent walls", 0, 100, "%", "0%", "100%", false, transparentwalls);
										gui.SetValue("vis_asus", transparentwalls/100);
										gui.SetValue("vis_asustype", 0);
										local nightmode = (gui.GetValue("vis_nightmode") * 100);
										nightmode = SenseUI.Slider("Night mode", 0, 100, "%", "0%", "100%", false, nightmode);
										gui.SetValue("vis_nightmode", nightmode/100);
										local sbox = (gui.GetValue("vis_skybox") + 1);
										sbox = SenseUI.Combo("Skybox changer", { "Default", "cs_tibet", "embassy", "italy", "jungle", "office", "sky_cs15_daylight01_hdr", "sky_csgo_cloudy1", "sky_csgo_night02", "sky_csgo_night02b", "sky_day02_05_hdr", "sky_day02_05", "sky_dust", "vertigo_hdr", "vertigoblue_hdr", "vertigo", "vietnam" }, sbox);
										gui.SetValue("vis_skybox", sbox-1);
										local ch = gui.GetValue("esp_crosshair");
										ch = SenseUI.Checkbox("Crosshair", ch);
										gui.SetValue("esp_crosshair", ch);
										local gtrace = gui.GetValue("esp_nadetracer");
										gtrace = SenseUI.Checkbox("Grenade trajectory", gtrace);
										gui.SetValue("esp_nadetracer", gtrace);
										local gdamage = gui.GetValue("esp_nadedamage");
										gdamage = SenseUI.Checkbox("Grenade damage", gdamage);
										gui.SetValue("esp_nadedamage", gdamage);
										SenseUI.Label("Bullet tracers");
										local btracer = (gui.GetValue("vis_bullet_tracer") + 1);				
										btracer = SenseUI.Combo("vis_bullet_tracer", { "Off", "Everyone", "Enemy", "Team", "Yourself"}, btracer);
										gui.SetValue("vis_bullet_tracer", btracer-1);
										local wbdamage = gui.GetValue("esp_wallbangdmg");
										wbdamage = SenseUI.Checkbox("Wallbang damage", wbdamage);
										gui.SetValue("esp_wallbangdmg", wbdamage);
										local oof = gui.GetValue("esp_outofview"); --- REEEEEEEEEEEEEEEEEE oof
										oof = SenseUI.Checkbox("Out of FOV arrow", oof);
										gui.SetValue("esp_outofview", oof);
										render = SenseUI.MultiCombo("Disable rendering", { "Teammate", "Enemy", "Weapon", "Ragdoll" }, render);
										gui.SetValue("vis_norender_teammates", render["Teammate"]);
										gui.SetValue("vis_norender_enemies", render["Enemy"]);
										gui.SetValue("vis_norender_weapons", render["Weapon"]);
										gui.SetValue("vis_norender_ragdolls", render["Ragdoll"]);
										local hitmarker = gui.GetValue("msc_hitmarker_enable");
										hitmarker = SenseUI.Checkbox("Hit marker", hitmarker);
										gui.SetValue("msc_hitmarker_enable", hitmarker);
				end
				SenseUI.EndGroup();
			end
			if SenseUI.BeginGroup( "visual2", "Other", 285, 25, 235, 315 ) then
				local visenable = gui.GetValue("esp_active");
				visenable = SenseUI.Checkbox("Enable", visenable);
				gui.SetValue("esp_active", visenable);
				local vishotkey = gui.GetValue("vis_togglekey");
				vishotkey = SenseUI.Bind("tkeyvis", true, vishotkey);
				gui.SetValue("vis_togglekey", vishotkey);
				SenseUI.Label("Backtrack chams");
				local btrackchams = (gui.GetValue("vis_historyticks") + 1);
				btrackchams = SenseUI.Combo("btrack", { "Off", "All ticks", "Last tick" }, btrackchams);
				gui.SetValue("vis_historyticks", btrackchams-1);
				SenseUI.Label("Backtrack chams style");
				local btrackchamss = (gui.GetValue("vis_historyticks_style") + 1);
				btrackchamss = SenseUI.Combo("btrack2", { "Model", "Flat", "Hitbox" }, btrackchamss);
				gui.SetValue("vis_historyticks_style", btrackchamss-1);
				local glowalpha = (gui.GetValue("vis_glowalpha") * 100);
				glowalpha = SenseUI.Slider("Glow alpha", 0, 100, "", "0", "10", false, glowalpha);
				gui.SetValue("vis_glowalpha", glowalpha/100);
				local rfarmodels = gui.GetValue("vis_farmodels");
				rfarmodels = SenseUI.Checkbox("Far models", rfarmodels);
				gui.SetValue("vis_farmodels", rfarmodels);
				local tbasec = gui.GetValue("esp_teambasedcolors");
				tbasec = SenseUI.Checkbox("Team based colors", tbasec);
				gui.SetValue("esp_teambasedcolors", tbasec);
				SenseUI.Label("Team based text color");
				local tbasedtc = (gui.GetValue("esp_teambasedtextcolor") + 1);
				tbasedtc = SenseUI.Combo("tbasedtc", { "Off", "Box color", "Visible color", "Invisible color"}, tbasedtc);
				gui.SetValue("esp_teambasedtextcolor", tbasedtc-1);
				SenseUI.Label("Weapon style");
				local wstyle = (gui.GetValue("esp_weaponstyle") + 1);
				wstyle = SenseUI.Combo("wstyle", { "Icon", "Name" }, wstyle);
				gui.SetValue("esp_weaponstyle", wstyle-1);
				local ascreen = gui.GetValue("vis_antiscreenshot");
				ascreen = SenseUI.Checkbox("Anti-screenshot", ascreen);
				gui.SetValue("vis_antiscreenshot", ascreen);
				local aobs = gui.GetValue("vis_antiobs");
				aobs = SenseUI.Checkbox("Anti-obs", aobs);
				gui.SetValue("vis_antiobs", aobs);
				SenseUI.EndGroup();
			end
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "miscsettings", SenseUI.Icons.settings ) then
			if SenseUI.BeginGroup("grpsasss", "CFG Load", 285, 285, 205, 300) then
				selected, scroll = SenseUI.Listbox(configs, 5, false, selected, nil, scroll)
				
				load_pressed = SenseUI.Button("Load", 155, 25)
				save_pressed = SenseUI.Button("Save", 155, 25)
				configname = SenseUI.Textbox("ncfgtb", "Config name", configname)
				add_pressed = SenseUI.Button("Add config", 155, 25)
				remove_pressed = SenseUI.Button("Remove config", 155, 25)
			end
			SenseUI.EndGroup();
			if SenseUI.BeginGroup( "misc2", "Other", 285, 25, 235, 245 ) then
				local fakelat = gui.GetValue("msc_fakelatency_enable");
				fakelat = SenseUI.Checkbox("Fakelatency enable", fakelat);
				gui.SetValue("msc_fakelatency_enable", fakelat);
				local fakelatkey = gui.GetValue("msc_fakelatency_key");
				fakelatkey = SenseUI.Bind("flk", true, fakelatkey);
				gui.SetValue("msc_fakelatency_key", fakelatkey);
				local fakelatsl = (gui.GetValue("msc_fakelatency_amount") * 1000);
				fakelatsl = SenseUI.Slider("Fakelatency amount", 0, 1000, "ms", "0ms", "1000ms", false, fakelatsl);
				gui.SetValue("msc_fakelatency_amount", fakelatsl/1000);
				local fakelagenable = gui.GetValue("msc_fakelag_enable");
				fakelagenable = SenseUI.Checkbox("Fakelag enable", fakelagenable);
				gui.SetValue("msc_fakelag_enable", fakelagenable);
				local fakelagamount = gui.GetValue("msc_fakelag_value");
				fakelagamount = SenseUI.Slider("Fakelag amount", 1, 15, "", "1", "15", false, fakelagamount);
				gui.SetValue("msc_fakelag_value", fakelagamount);
				SenseUI.Label("Fakelag mode");
				local fakelagmode = (gui.GetValue("msc_fakelag_mode") + 1 );
				fakelagmode = SenseUI.Combo("", { "Factor", "Switch", "Adaptive", "Random", "Peek", "Rapid Peek" }, fakelagmode);
				gui.SetValue("msc_fakelag_mode", fakelagmode-1);
				local fakelagewsh = gui.GetValue("msc_fakelag_attack");
				fakelagewsh = SenseUI.Checkbox("Fakelag while shooting", fakelagewsh);
				gui.SetValue("msc_fakelag_attack", fakelagewsh);
				local fakelagwst = gui.GetValue("msc_fakelag_standing");
				fakelagwst = SenseUI.Checkbox("Fakelag while standing", fakelagwst);
				gui.SetValue("msc_fakelag_standing", fakelagwst);
				local fakelagwund = gui.GetValue("msc_fakelag_unducking");
				fakelagwund = SenseUI.Checkbox("Fakelag while unducking", fakelagwund);
				gui.SetValue("msc_fakelag_unducking", fakelagwund);
				SenseUI.Label("Fakelag style");
				local fakelagstylell = (gui.GetValue("msc_fakelag_style") + 1 );
				fakelagstylell = SenseUI.Combo("ssd", { "Always", "Avoid ground", "Hit ground" }, fakelagstylell);
				gui.SetValue("msc_fakelag_style", fakelagstylell-1);
			end
			SenseUI.EndGroup();
			if SenseUI.BeginGroup( "misc", "Miscellaneous", 25, 25, 235, 510 ) then
				local msc_active = gui.GetValue("msc_active");
				msc_active = SenseUI.Checkbox("Enable", msc_active);
				gui.SetValue("msc_active", msc_active);
				SenseUI.Label("Bunny hop");
				local bunnyhop = (gui.GetValue("msc_autojump") + 1);
				bunnyhop = SenseUI.Combo("bhop", { "Off", "Rage", "Legit" }, bunnyhop);
				gui.SetValue("msc_autojump", bunnyhop-1);
				local astrafe = gui.GetValue("msc_autostrafer_enable");
				astrafe = SenseUI.Checkbox("Air strafe", astrafe);
				gui.SetValue("msc_autostrafer_enable", astrafe);
				gui.SetValue("msc_autostrafer_airstrafe", astrafe);
				local wasdstrafe = gui.GetValue("msc_autostrafer_wasd");
				wasdstrafe = SenseUI.Checkbox("WASD strafe", wasdstrafe);
				gui.SetValue("msc_autostrafer_wasd", wasdstrafe);
				local antisp = gui.GetValue("msc_antisp");
				antisp = SenseUI.Checkbox("Anti spawn protection", antisp);
				gui.SetValue("msc_antisp", antisp);
				local revealranks = gui.GetValue("msc_revealranks");
				revealranks = SenseUI.Checkbox("Reveal competitive ranks", revealranks);
				gui.SetValue("msc_revealranks", revealranks);
				local weaplog = gui.GetValue("msc_logevents_purchases");
				weaplog = SenseUI.Checkbox("Purchases logs", weaplog);
				gui.SetValue("msc_logevents_purchases", weaplog);
				gui.SetValue("msc_logevents", 1);
				local damagelog = gui.GetValue("msc_logevents_damage");
				damagelog = SenseUI.Checkbox("Damage logs", damagelog);
				gui.SetValue("msc_logevents_damage", damagelog);
				gui.SetValue("msc_logevents", 1);
				local duckjump = gui.GetValue("msc_duckjump");
				duckjump = SenseUI.Checkbox("Duck jump", duckjump);
				gui.SetValue("msc_duckjump", duckjump);
				local fastduck = gui.GetValue("msc_fastduck");
				fastduck = SenseUI.Checkbox("Fast duck", fastduck);
				gui.SetValue("msc_fastduck", fastduck);
				local slidewalk = gui.GetValue("msc_slidewalk");
				slidewalk = SenseUI.Checkbox("Slide walk", slidewalk);
				gui.SetValue("msc_slidewalk", slidewalk);
				SenseUI.Label("Slow walk");
				local slowwalk = gui.GetValue("msc_slowwalk");
				slowwalk = SenseUI.Bind("sw", true, slowwalk);
				gui.SetValue("msc_slowwalk", slowwalk);
				local slowslider = (gui.GetValue("msc_slowwalkspeed") * 100);
				slowslider = SenseUI.Slider("Slow walk speed", 0, 100, "%", "0%", "100%", false, slowslider);
				gui.SetValue("msc_slowwalkspeed", slowslider / 100);
				local autoaccept = gui.GetValue("msc_autoaccept");
				autoaccept = SenseUI.Checkbox("Auto-accept match", autoaccept);
				gui.SetValue("msc_autoaccept", autoaccept);
				SenseUI.Label("Knifebot");
				local knifebot = (gui.GetValue("msc_knifebot") + 1);
				knifebot = SenseUI.Combo("combo1212", { "Off", "On", "Backstab only", "Trigger", "Quick" }, knifebot);
				gui.SetValue("msc_knifebot", knifebot-1);
				local clantag = gui.GetValue("msc_clantag");
				clantag = SenseUI.Checkbox("Clan-tag spammer", clantag);
				gui.SetValue("msc_clantag", clantag);
				local namespam = gui.GetValue("msc_namespam");
				namespam = SenseUI.Checkbox("Name spammer", namespam);
				gui.SetValue("msc_namespam", namespam);
				local invisiblename = gui.GetValue("msc_invisiblename");
				invisiblename = SenseUI.Checkbox("Invisible name", invisiblename);
				gui.SetValue("msc_invisiblename", invisiblename);
				local auntrusted = (gui.GetValue("msc_restrict") + 1);
				auntrusted = SenseUI.Checkbox("Anti-untrusted", auntrusted);
				if auntrusted == 1 then
					gui.SetValue("msc_restrict", 2);
				end
				SenseUI.Label( "Menu key" );
				window_bkey, window_bact, window_bdet = SenseUI.Bind( "wndToggle", false, window_bkey, window_bact, window_bdet );
				SenseUI.Label("Namestealer");
				local namesteal = (gui.GetValue("msc_namestealer_enable") + 1);
				namesteal = SenseUI.Combo("asdas", { "Off", "Team only", "Enemy only", "All" }, namesteal);
				gui.SetValue("msc_namestealer_enable", namesteal-1);
				SenseUI.Label("Menu color");
				local mcolor = (gui.GetValue("senseui_color") + 1);
				mcolor = SenseUI.Combo("uau", { "Green", "Blue", "Red", "Purple", "Orange", "Pink" }, mcolor);
				gui.SetValue("senseui_color", mcolor-1);
			end
			SenseUI.EndGroup();
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "skinc", SenseUI.Icons.skinchanger ) then
			if SenseUI.BeginGroup( "Skin Changer", "Skin Changer", 25, 25, 235, 70 ) then
				local skinc = gui.GetValue("msc_skinchanger");
				skinc = SenseUI.Checkbox("Skin changer", skinc);
				gui.SetValue("msc_skinchanger", skinc);
				SenseUI.Label("You need to open original menu of AW", true);
				SenseUI.Label("For change skins", true);
			end
			SenseUI.EndGroup();
		end
		SenseUI.EndTab();
		if SenseUI.BeginTab( "players", SenseUI.Icons.playerlist ) then
			if SenseUI.BeginGroup( "Credits", "Credits", 25, 120, 335, 85) then
				SenseUI.Label("ＵＧＬＹＣＨ - creator of SenseUI Menu", true);
				SenseUI.Label("Ruppet - creator of SenseUI", true);
				SenseUI.Label("HappyDOGE - creator of CFG Loader", true);
				SenseUI.Label("Brotgeschmack - creator of texture optimization in SenseUI", true);
			end
			SenseUI.EndGroup();
			if SenseUI.BeginGroup( "Ps", "Player List", 25, 25, 235, 70 ) then
				local playerlist = gui.GetValue("msc_playerlist");
				playerlist = SenseUI.Checkbox("Player list", playerlist);
				gui.SetValue("msc_playerlist", playerlist);
				SenseUI.Label("You need to open original menu of AW", true);
				SenseUI.Label("For change priorities in player list", true);
			end
			SenseUI.EndGroup();
			
		end
		SenseUI.EndTab();

		SenseUI.EndWindow();
	end

	if (load_pressed ~= old_load_pressed) and (#configs >= selected) then
        gui.Command("load " .. configs[selected], true)
    end
    
    if (save_pressed ~= old_save_pressed) and (#configs >= selected) then
        gui.Command("save " .. configs[selected], true)
    end
    
    if (add_pressed ~= old_add_pressed) and (configname ~= "") then
        table.insert(configs, configname)
        configname = ""
    end
    
    if (remove_pressed ~= old_remove_pressed) and (#configs >= selected) then
        configs[selected] = nil
    end
    
    old_load_pressed = load_pressed
    old_save_pressed = save_pressed
    old_add_pressed = add_pressed
    old_remove_pressed = remove_pressed

end

callbacks.Register( "Draw", "suitest", draw_callback );--- SenseUI Menu by uglych discord is Uglych#1515