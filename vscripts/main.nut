IncludeScript("vs_library")

::CSPlayer <- class
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

VS.ListenToGameEvent("round_start", function(data)
{
	if(printHelp)
	{
		ScriptPrintMessageChatAll(" \x04 Type !help for a list of commands!");
		printHelp = false;
	}

	if(!enableBots)
		SendToConsole("bot_kick")

	foreach(player in ::VS.GetAllPlayers())
	{
		if(IsBot(player))
			GiveBotWeapons(player);
		else
		{
			local userid = player.GetScriptScope().userid;
			local exist = false;

			for(local i = 0; i < Players.len(); i++)
			{
				if(Players[i].ID == userid)
					exist = true;
			}	
			if(!exist)
				Players.push(CSPlayer(userid));
		}
	}

	GiveWeapons(true, null, null);
}.bindenv(this), "test");

VS.ListenToGameEvent("player_say", function(data)
{
	local msg = data.text
	local userid = data.userid;
	local player = VS.GetPlayerByUserid(userid);

	if(msg.slice(0,1) != "!")
		return

	if(UserInput(msg.slice(1), userid)) 
		GiveWeapons(false, player, userid);
}.bindenv(this), "test");

function UserInput(msg, id)
{
	local buffer = split(msg, " ")
	local val, cmd = buffer[0].tolower();

	if(buffer.len() > 1)
        val = buffer[1].tolower();
	
	switch(cmd)
	{
		case "g":
		case "gun":
		case "w":
		case "weapon":
			if(SetWeapon(val, id))
				return "true";
			else 
				return false;
		case "hs":
		case "headshot":
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
			return false;
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
			return false;
		case "h":	
		case "help":
			ScriptPrintMessageChatAll(" \x04 !w ‎‎\x05 name \x04 | \x05 !w ak / !w tec9 / !w bayonet");
			ScriptPrintMessageChatAll(" \x04 !random \x05 primary / secondary / knife / competitive");
			ScriptPrintMessageChatAll(" \x04 !armor");
			ScriptPrintMessageChatAll(" \x04 !bumpmines");
			ScriptPrintMessageChatAll(" \x04 !helmets");
			ScriptPrintMessageChatAll(" \x04 !headshot");
			ScriptPrintMessageChatAll(" \x04 !bot");
			ScriptPrintMessageChatAll(" \x07 !reset"); 
			return false;
		case "helm":
		case "helmet":
		case "helmets":
			if(equipHelmet)
				equipHelmet = SettingState("Helmet", equipHelmet);
			else
				equipHelmet = SettingState("Helmet", equipHelmet);
			return false;
		case "b":
		case "bump":
		case "bumpmine":
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
			return false;
		case "reset":
			Players = [];	
			ScriptPrintMessageChatAll(" \x07 ALL ID'S ARE RESET");
			return false;
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
				SendToConsole("bot_add");
				enableBots = SettingState("Bots", enableBots);
			}
			return false;
		case "random":
		case "rand":
		case "r":
			RandomWeapons(val);
			return false;
		default:
			ScriptPrintMessageChatAll(" \x07 Invalid command.");
			return false;
	}
}

function GiveWeapons(server, player, id)
{
	if (randomPrimary)
		::p <- RandomInt(primaryList.len());
	else if(randomCompetitive)
		::p <- RandomInt(competitiveList.len());

	if(randomSecondary)
		::s <- RandomInt(secondaryList.len());

	if(randomKnife)
		::k <- RandomInt(knifeList.len());

	for(local i = 0; i < Players.len(); i++)
	{
		if(server)
		{
			if(randomPrimary)
				Players[i].Primary = primaryList[p];
			else if(randomCompetitive) 
				Players[i].Primary = competitiveList[p]; 
		
			if(randomSecondary)
				Players[i].Secondary = secondaryList[s];

			if(randomKnife)
				Players[i].Knife = knifeList[k];

			local local_player = VS.GetPlayerByUserid(Players[i].ID);
			GivePlayerEquipment(local_player, i);
		}
		else if(Players[i].ID == id)
		{
			GivePlayerEquipment(player, i);
		}
	}
}

function GiveBotWeapons(player)
{
	EntFire("equip_strip", "Use", "", 0, player);

	if(equipArmor && equipHelmet)
		Give("item_assaultsuit", player);
	else if(equipArmor)
		Give("item_kevlar", player)

	if(randomPrimary)
		Give(primaryList[RandomInt(primaryList.len())], player);
	else
		Give(competitiveList[RandomInt(competitiveList.len())], player);

	Give(secondaryList[RandomInt(secondaryList.len())], player);

	Give(knifeList[RandomInt(knifeList.len())], player);	
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
	return false;
}

function GivePlayerEquipment(player, i)
{
	EntFire("equip_strip", "Use", "", 0, player);

	if(equipArmor && equipHelmet)
		Give("item_assaultsuit", player);
	else if(equipArmor)
		Give("item_kevlar", player)

	if(giveBumpMines)
		Give("weapon_bumpmine", player);

	Give(Players[i].Primary, player)
	Give(Players[i].Secondary, player)
	Give(Players[i].Knife, player)
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
}

function Give(weapon, player)
{
    local equip = Entities.CreateByClassname("game_player_equip")
    equip.__KeyValueFromInt(weapon, 60)

    EntFireByHandle(equip, "use", "", 0, player, player)
    
    equip.Destroy()
}

function SetWeapon(val, id) {
	if (!val) 
		return PrintWeapons();
	for(::i <- 0; i < Players.len(); i++)
        if(Players[i].ID == id)
			break;
	
	local player = VS.GetPlayerByUserid(Players[i].ID);

	if (ParseWeaponName(val, i))
		if (!player.GetHealth())
			return false;
		else return true; 
}

function PrintWeapons() {
	ScriptPrintMessageChatAll(" \x04 Rifles:");
	ScriptPrintMessageChatAll(" \x05 AK-47, M4A4, M4A1-S, Aug, SG 553, Galil AR, Famas, AWP, Scar-20");
	ScriptPrintMessageChatAll(" \x05 G3SG1");
	ScriptPrintMessageChatAll(" \x04 Heavy:")
	ScriptPrintMessageChatAll(" \x05 Nova, XM1014, Sawed-Off, Mag-7, M249, Negev");
	ScriptPrintMessageChatAll(" \x04 SMGs:");
	ScriptPrintMessageChatAll(" \x05 Mac-10, MP9, MP7, MP5-SD, P90, UMP-45, PP-Bizon");
	ScriptPrintMessageChatAll(" \x04 Pistols: ")
	ScriptPrintMessageChatAll(" \x05 USP-S, P200, Glock, Tec-9, FiveSeven, Dual Berettas, P250");
	ScriptPrintMessageChatAll(" \x05 CZ-75, Deagle, Revolver");
	ScriptPrintMessageChatAll(" \x04 Knives: ");
	ScriptPrintMessageChatAll(" \x05 M9, Bayonet, Butterfly, Karambit, Flip, Huntsman, Shadow Daggers");
	ScriptPrintMessageChatAll(" \x05 Bowie, Ursus, Navaja, Stiletto, Talon, Classic, Skeleton, Nomad");
	ScriptPrintMessageChatAll(" \x05 Paracord, Survival, Ghost, Gold, Falchion");

	return false;
}

function ParseWeaponName(val, i) {
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
			break;
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
			
		//SMG
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

		//Pistol
		case "usp":
		case "usps":
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
		case "tec-9":
			Players[i].Secondary = "weapon_tec9";
			break;
		case "fiveseven":
		case "57":
		case "five":
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

		//Knife
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
		case "kar":
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
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a weapon dumbass.");
			return false;
	}
	return true;
}

function RandomWeapons(val)
{
	switch(val)
	{
		case "p":
		case "primary":
			if(!randomPrimary)
				randomCompetitive = false;

			randomPrimary = SettingState("Random Primary", randomPrimary);
			break;
		case "s":
		case "secondary":
		case "sec":
			randomSecondary = SettingState("Random Secondary", randomSecondary);
			break;
		case "k":
		case "knife":
			randomKnife = SettingState("Random Knife", randomKnife);
			break;
		case "c":
		case "comp":
		case "competitive":
			if(!randomCompetitive)
				randomPrimary = false;

			randomCompetitive = SettingState("Random Competitive", randomCompetitive);
			break;
		default:
			SettingState("Random Primaries", !randomPrimary);
			SettingState("Random Secondaries", !randomSecondary);
			SettingState("Random Knives", !randomKnife);
			SettingState("Random Competitive", !randomCompetitive);
			break;
	}
}

::IsBot <- function(player)
{
	local networkid = player.GetScriptScope().networkid;
	if (networkid == "")
	{
		ScriptPrintMessageChatAll(" \x07 Server is corrupt? Unlucky!");
		return true;
	}
	return networkid == "BOT"
}

::SettingState <- function(option, state)
{
	if(state)
		ScriptPrintMessageChatAll(" \x03" + option + ": \x08Off");
	else
		ScriptPrintMessageChatAll(" \x03" + option + ": \x05On");
	return !state;
}

::RandomInt <- function(max) 
{
	local roll = rand() % max;
    return roll.tointeger();
}