IncludeScript("vs_library")
IncludeScript("util")

class CSPlayer
{
	ID = null;
	Name = null;
	NetworkID = null;
	Primary = "weapon_ak47";
	Secondary = "weapon_deagle";
	Knife = "weapon_knife_m9_bayonet";

	constructor(id) 
	{
		local player = VS.GetPlayerByUserid(id);
		player.ValidateScriptScope();
		player = player.GetScriptScope();

		if(!("userid" in player)) 
			ID = null;
		else
			ID = id;
		if(!("networkid" in player)) 
			NetworkID  = null;
		else
			NetworkID = player.networkid;
		if(!("name" in player)) 
			Name = null;
		else
			Name = player.name;

		ScriptPrintMessageChatAll(" \x04 Assigning ID \x07" + ID + "\x04 to \x07" + Name);
    }

	function GetUserID()
	{
		return ID.tostring();
	}
}

::OnGameEvent_player_spawn <- function(data)
{
	local player = VS.GetPlayerByUserid(data.userid)

	if(IsBot(player))
		GiveBotWeapons(player)
	else if(AssignUserID(data.userid))
		Players.push(CSPlayer(data.userid));

}.bindenv(this);


::OnGameEvent_round_start <- function(data)
{
	VS.ValidateUseridAll()

	if(ScriptGetRoundsPlayed() == 0)
		ScriptPrintMessageChatAll(" \x04 Type !help for command help!");

	if(!enableBots)
		SendToConsole("bot_kick")

	foreach(player in ::VS.GetAllPlayers())
		if(IsBot(player))
			GiveBotWeapons(player);

	GiveWeapons(true, null, null);
}.bindenv(this);

::OnGameEvent_player_say <- function(data)
{
	local msg = data.text
	local player = VS.GetPlayerByUserid(data.userid);

	if(msg.slice(0,1) != "!")
		return

	local result = UserInput(msg.slice(1), data.userid)
	
	if(result != null && result != "false") 
		GiveWeapons(false, player, data.userid);
}.bindenv(this)

function UserInput(msg, id)
{
	local buffer = split(msg, " ")
	local val, cmd = buffer[0].tolower();

	if(buffer.len() > 1)
        val = buffer[1];
	
	switch(cmd)
	{
		case "g":
		case "gun":
			if(SetPrimary(val, id))
				return "true";
			else 
				return "false";
		case "p":
		case "pistol":
			if(SetSecondary(val, id))
				return "true";
			else 
				return "false";
			return "true";
		case "k":
		case "knife":
			if(SetKnife(val, id))
				return "true";
			else 
				return "false";
		return "true";
		case "hs":
		case "headshot":
		case "headshotonly":
			if(headshotOnly)
			{
				headshotOnly = SettingState("Headshot Only", headshotOnly);
				SendToConsole("mp_damage_headshot_only 0");
			}
			else
			{
				headshotOnly = SettingState("Headshot Only", headshotOnly);
				SendToConsole("mp_damage_headshot_only 1");
			}
			return "false";
		case "a":
		case "arm":
		case "armor":
		case "armour":
		case "kev":
		case "kevlar":
			if(equipArmor)
				equipArmor = SettingState("Armor", equipArmor);
			else
				equipArmor = SettingState("Armor", equipArmor);
			return "false";
		case "h":	
		case "help":
			PrintHelp(val);
			return "false";
		case "helm":
		case "helmet":
			if(equipHelmet)
				equipHelmet = SettingState("Helmet", equipHelmet);
			else
				equipHelmet = SettingState("Helmet", equipHelmet);
			return "false";
		case "b":
		case "bump":
		case "bumpmines":
			if(giveBumpMines)
			{
				SendToConsole("sv_falldamage_scale 1");
				giveBumpMines = SettingState("Bump Mines", giveBumpMines);
			}
			else
			{
				SendToConsole("sv_falldamage_scale 0");
				giveBumpMines = SettingState("Bump Mines", giveBumpMines);
			}
			return "false";
		case "reset":
			Reset();
			return "false";
		case "bot":
		case "bots":
			if(enableBots)
			{
				SendToConsole("bot_kick");
				SendToConsole("mp_restartgame 1");
				enableBots = SettingState("Bots", enableBots);
			}
			else
			{
				SendToConsole("bot_quota 4");
				enableBots = SettingState("Bots", enableBots);
			}
			return "false";
		case "random":
		case "r":
			RandomWeapons(val);
			return "false";
		default:
			ScriptPrintMessageChatAll(" \x07 Invalid command.");
			return "false";
	}
}
//TODO rename this mess jesus
function GiveWeapons(server, p, id)
{
	for(local i = 0; i < Players.len(); i++)
	{
		if(server)
		{
			local player = VS.GetPlayerByUserid(Players[i].ID);
			
			if(randomPrimary)
				Players[i].Primary = primaryList[RandomInt(primaryList.len())];
			else if(randomCompetitive)
				Players[i].Primary = competitiveList[RandomInt(competitiveList.len())]; 
		
			if(randomSecondary)
				Players[i].Secondary = secondaryList[RandomInt(secondaryList.len())];

			if(randomKnife)
				Players[i].Knife = knifeList[RandomInt(knifeList.len())];

			GiveItems(player, i);
		}
		else if(Players[i].ID == id)
		{
			GiveItems(p, i);
		}
	}
}

function GiveBotWeapons(player)
{
	GiveArmor(player);

	if(randomPrimary)
		Give(primaryList[RandomInt(primaryList.len())], player);
	else
		Give(competitiveList[RandomInt(competitiveList.len())], player);

	Give(secondaryList[RandomInt(secondaryList.len())], player);

	Give(knifeList[RandomInt(knifeList.len())], player);	
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
	return false;
}

function GiveItems(player, i)
{
	GiveArmor(player);
	Give(Players[i].Primary, player)
	Give(Players[i].Secondary, player)
	Give(Players[i].Knife, player)
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
}

function GiveArmor(player)
{
	EntFire("equip_strip", "Use", "", 0, player);

	if(equipArmor && equipHelmet)
		Give("item_assaultsuit", player);
	else if(equipArmor)
		Give("item_kevlar", player)

	if(giveBumpMines)
		Give("weapon_bumpmine", player);
}

function Give(weapon, player)
{
    local equip = Entities.CreateByClassname("game_player_equip")
    equip.__KeyValueFromInt(weapon, 60)

    EntFireByHandle(equip, "use", "", 0, player, player)
    
    equip.Destroy()
}

function SetPrimary(val, id)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Rifles:");
		ScriptPrintMessageChatAll(" \x05 AK-47, M4A4, M4A1-S, Aug, SG 553, Galil AR, Famas, AWP, Scar-20");
		ScriptPrintMessageChatAll(" \x05 G3SG1");
		ScriptPrintMessageChatAll(" \x04 Heavy:")
		ScriptPrintMessageChatAll(" \x05 Nova, XM1014, Sawed-Off, Mag-7, M249, Negev");
		ScriptPrintMessageChatAll(" \x04 SMGs:");
		ScriptPrintMessageChatAll(" \x05 Mac-10, MP9, MP7, MP5-SD, P90, UMP-45, PP-Bizon");
		return false;
	}

	for(::i <- 0; i < Players.len(); i++)
    {
        if(Players[i].ID == id)
			break;
		else
			return false;
	}
	switch (val)
	{
		//Rifle
		case "ak47":
		case "ak":
			Players[i].Primary = "weapon_ak47";
			break;
		case "m4":
		case "m4a4":
			 Players[i].Primary = "weapon_m4a1";
			break;
		case "m4a1":
		case "m4a1s":
			 Players[i].Primary = "weapon_m4a1_silencer";
			break;
		case "aug":
			 Players[i].Primary = "weapon_aug";
			break;
		case "sg":
		case "sg553":
		case "codgun":
			 Players[i].Primary = "weapon_sg556";
			break;
		case "galil":
		case "gal":
			 Players[i].Primary = "weapon_galilar";
			break;
		case "fam":
		case "famas":
			 Players[i].Primary = "weapon_famas";
			break;
		case "awp":
			 Players[i].Primary = "weapon_awp";
			break;
		case "ssg":
		case "ssg08":
		case "scout":
		case "scoot":
			Players[i].Primary = "weapon_ssg08";
			break;
		case "g3sg1":
		case "dakdak":
		case "dak":
		case "g3":
			Players[i].Primary = "weapon_g3sg1";
		case "scar":
		case "scar20":
			Players[i].Primary = "weapon_scar20";
			break;
			
		//Heavy
		case "nova":
			Players[i].Primary = "weapon_nova";
			break;
		case "xm":
		case "xm1014":
			Players[i].Primary = "weapon_xm1014";
			break;
		case "saw":
		case "sawedoff":
			Players[i].Primary = "weapon_sawedoff";
			break;
		case "mag":
		case "mag7":
			Players[i].Primary = "weapon_mag7";
			break;
		case "m249":
		case "m2":
		case "m24":
			Players[i].Primary = "weapon_m249";
			break;
		case "negev":
		case "neg":
			Players[i].Primary = "weapon_negev";
			break;
			
		//Smg
		case "mac":
		case "mac10":
			Players[i].Primary = "weapon_mac10";
			break;	
		case "mp9":
			Players[i].Primary = "weapon_mp9";
			break;
		case "mp7":
			Players[i].Primary = "weapon_mp7";
			break;
		case "mp5":
		case "mp5sd":
			Players[i].Primary = "weapon_mp5sd";
			break;			
		case "p90":
			Players[i].Primary = "weapon_p90";
			break;
		case "ump":
		case "ump45":
			Players[i].Primary = "weapon_ump45";
			break;
		case "bizon":
		case "pp":
		case "ppbizon":
			Players[i].Primary = "weapon_bizon";
			break;	
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a gun dumbass.");
			return false;
	}
	ScriptPrintMessageChatAll(" \x04 Primary: \x05"+ Players[i].Primary);
	return true;
}

function SetSecondary(val, id)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Pistols: ")
		ScriptPrintMessageChatAll(" \x05 USP-S, P200, Glock, Tec-9, FiveSeven, Dual Berettas, P250");
		ScriptPrintMessageChatAll(" \x05 CZ-75, Deagle, Revolver");
		return false;
	}
	
	for(::i <- 0; i < Players.len(); i++)
    {
        if(Players[i].ID == id)
			break;
		else
			return false;
	}

	switch (val)
	{
		case "usp":
		case "usp-s":
			Players[i].Secondary = "weapon_usp_silencer";
			break;
			
		case "p2000":
		case "p2k":
		case "p200":
			Players[i].Secondary = "weapon_hkp2000";
			break;
			
		case "glock":
		case "glock18":
			Players[i].Secondary = "weapon_glock";
			break;	
			
		case "tec":
		case "tec9":
			Players[i].Secondary = "weapon_tec9";
			break;
			
		case "fiveseven":
		case "57":
		case "five":
		case "seven":
			Players[i].Secondary = "weapon_fiveseven";
			break;
		
		case "dual":
		case "dualies":
		case "berettas":
		case "dualberettas":
			Players[i].Secondary = "weapon_elite";
			break;
		
		case "deagle":
		case "deag":
			Players[i].Secondary = "weapon_deagle";
			break;
		
		case "p250":
		case "p25":
		case "p2":
			Players[i].Secondary = "weapon_p250";
			break;
		
		case "cz":
		case "cz75":
		case "cz75a":
			Players[i].Secondary = "weapon_cz75a";
			break;
			
		case "rev":
		case "revolver":
		case "yeehaw":
		case "r8":
			Players[i].Secondary = "weapon_revolver";
			break;
			
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a pistol dumbass.");
			return false;
	}

	ScriptPrintMessageChatAll(" \x04 Pistol: \x05"+ Players[i].Secondary);
	return true;
}

function SetKnife(val, id)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Knives: ");
		ScriptPrintMessageChatAll(" \x05 M9, Bayonet, Butterfly, Karambit, Flip, Huntsman, Shadow Daggers");
		ScriptPrintMessageChatAll(" \x05 Bowie, Ursus, Navaja, Stiletto, Talon, Classic, Skeleton, Nomad");
		ScriptPrintMessageChatAll(" \x05 Paracord, Survival, Ghost, Gold, Falchion");
		return false;
	}
	for(::i <- 0; i < Players.len(); i++)
    {
        if(Players[i].ID == id)
			break;
		else
			return false;
	}

	switch (val)
	{
		case "m9":
			Players[i].Knife = "weapon_knife_m9_bayonet";
			break;
		case "bay":
		case "bayonet":
			Players[i].Knife = "weapon_bayonet";
			break;
		case "but":
		case "butt":
		case "butterfly":
			Players[i].Knife = "weapon_knife_butterfly";
			break;
		case "karambit":
		case "kara":
			Players[i].Knife = "weapon_knife_karambit";
			break;
		case "flip":
			Players[i].Knife = "weapon_knife_flip";
			break;
		case "falcon":
		case "falchion":
		case "fal":
		case "falc":
			Players[i].Knife = "weapon_knife_falchion";
			break;
		case "gut":
			Players[i].Knife = "weapon_knife_gut";
			break;
		case "hunt":
		case "huntsman":
			Players[i].Knife = "weapon_knife_tactical";
			break;
		case "buttplugs":
		case "buttplug":
		case "shadow":
		case "daggers":
		case "dagger":
		case "shadowdaggers":
		case "shadowdagger":
			Players[i].Knife = "weapon_knife_push";
			break;
		case "bowie":
		case "bow":
			Players[i].Knife = "weapon_knife_survival_bowie";
			break;
		case "ursus":
		case "ur":
			Players[i].Knife = "weapon_knife_ursus";
			break;
		case "navaja":
		case "nava":
			Players[i].Knife = "weapon_knife_gypsy_jackknife";
			break;
		case "stiletto":
		case "stil":
			Players[i].Knife = "weapon_knife_stiletto";
			break;
		case "talon":
		case "tal":
			Players[i].Knife = "weapon_knife_widowmaker";
			break;
		case "classic":
		case "class":
		case "css":
			Players[i].Knife = "weapon_knife_css";
			break;
		case "skel":
		case "skeleton":
			Players[i].Knife = "weapon_knife_skeleton";
			break;
		case "gold":
			Players[i].Knife = "weapon_knifegg";
			break;
		case "nomad":
		case "nom":
		case "no":
			Players[i].Knife = "weapon_knife_outdoor";
			break;
		case "paracord":
		case "para":
			Players[i].Knife = "weapon_knife_cord";
			break;	
		case "survival":
		case "sur":
			Players[i].Knife = "weapon_knife_canis";
			break;			
		case "ghost":
			Players[i].Knife = "weapon_knife_ghost";
			break;
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a knife dumbass.");
			return false;
	}
	ScriptPrintMessageChatAll(" \x04 Knife: \x05"+ Players[i].Knife);
	return true;
}

function RandomWeapons(val)
{
	switch(val)
	{
		case "p":
		case "primary":
			if(randomPrimary)
				randomPrimary = SettingState("Random Primary", randomPrimary);
			else
			{
				randomCompetitive = false;
				randomPrimary = SettingState("Random Primary", randomPrimary);
			}
			break;
		case "s":
		case "secondary":
		case "sec":
			if(randomSecondary)
				randomSecondary = SettingState("Random Secondary", randomSecondary);
			else
				randomSecondary = SettingState("Random Secondary", randomSecondary);
			break;
		case "k":
		case "knife":
			if(randomKnife)
				randomKnife = SettingState("Random Knife", randomKnife);
			else
				randomKnife = SettingState("Random Knife", randomKnife);
			break;
		case "c":
		case "comp":
		case "competitive":
			if(randomCompetitive)
				randomCompetitive = SettingState("Random Competitive", randomCompetitive);
			else
			{
				randomPrimary = false;
				randomCompetitive = SettingState("Random Competitive", randomCompetitive);
			}
			break;
		default:
			SettingState("Random Primaries", !randomPrimary);
			SettingState("Random Secondaries", !randomSecondary);
			SettingState("Random Knives", !randomKnife);
			SettingState("Random Competitive", !randomCompetitive);
			break;
	}
}

function AssignUserID(id)
{
	if(!Players.len())
		return true;
	for(local i = 0; i < Players.len(); i++)
	{
		if(Players[i].ID == id)
			return false;
		else
			return true;
	}
}

