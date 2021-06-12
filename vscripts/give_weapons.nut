//This script allows players to change their weapons using chat commands
/*

Spawn -> Create Player -> Give Weapons

*/

/*
Color Config
-------------
Default: \x01
Dark Red: \x02
Purple: \x03
Green: \x04
Light Green: \x05
Lime Green: \x06
Red: \x07
Grey: \x08
Orange: \x09
-------------
*/

IncludeScript("vs_library")

::SMain <- this;
::mainScript <- 0;

class CSPlayer
{
	ID = null;
	Primary = "weapon_ak47";
	Secondary = "weapon_deagle";
	Knife = "weapon_knife_m9_bayonet";

	constructor(id) 
	{
		ID = id;
    }

	function GetUserID()
	{
		return ID.tostring();
	}
}

function OnPostSpawn() 
{
	mainScript = self.GetScriptScope();
}

//TODO bots could have a class that inherits from players that way 
//i don't need more funcitons and they can have the same behaviour 

::OnGameEvent_round_start <- function(data)
{
	if(ScriptGetRoundsPlayed() == 0)
		ScriptPrintMessageChatAll(" \x04 Type !help for command help!");

	//TODO why is this here?
	SendToConsole("mp_respawn_immunitytime 0")

	if(!enableBots)
		SendToConsole("bot_kick")

	foreach(player in ::VS.GetAllPlayers())
	{
		local s = _init_scope(player);
		if(AssignUserID(s.userid) && !s.bot)
		{
			Players.push(CSPlayer(s.userid));
			ScriptPrintMessageChatAll(" \x04 Assigning ID \x07"+s.userid+"\x04 to \x07"+s.name);
		}
		else if(s.bot)
			GiveBotWeapons(player);
	}

	GiveServer();
	//reminder to re-add user id validation if it's broken
}.bindenv(this);

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

function GiveBotWeapons(player)
{
	ScriptPrintMessageChatAll("giving bot weapons")
	EntFire("equip_strip", "Use", "", 0, player);
		
	EquipPlayerArmor(player);

	if(randomPrimary)
		EquipWeapon(primaryList[rndint(primaryList.len())], 60, player);
	else
		EquipWeapon(competitiveList[rndint(competitiveList.len())], 60, player);

	EquipWeapon(secondaryList[rndint(secondaryList.len())], 60, player);

	EquipWeapon(knifeList[rndint(knifeList.len())], 60, player);	
	EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
}

//Only called when the player types a weapon in chat
function GivePlayerWeapons(player, id)
{
	for(local i = 0; i < Players.len(); i++)
    {
        if(Players[i].ID == id)
        {
			EquipPlayerArmor(player);
            EquipWeapon(Players[i].Primary, 60, player)
            EquipWeapon(Players[i].Secondary, 60, player)
            EquipWeapon(Players[i].Knife, 60, player)
            EntFire("weapon_knife", "addoutput", "classname weapon_knifegg")
        }
    }
}

//WTF does this do?
::_init_scope <- function(s)
{
	s.ValidateScriptScope();
	s = s.GetScriptScope();

	if(!("userid" in s)) 
		s.userid <- "";
	if(!("networkid" in s)) 
		s.networkid <- "";
	if(!("name" in s)) 
		s.name <- "";
	if(!("bot" in s)) 
		s.bot <- s.networkid == "BOT";

	return s;
}

::OnGameEvent_player_say <- function(data)
{
	local msg = data.text
	local player = VS.GetPlayerByUserid(data.userid);

	if(msg.slice(0,1) != "!")
		return

	ParseUserInput(msg.slice(1), data.userid)
	//sometimes i don't want to update the players weapons
	if(result != null && result != "false") 
		GivePlayerWeapons(player, data.userid);

}.bindenv(this)

function settingState(option, state)
{
	if(state)
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x08Off");
	else
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x05On");

	return !state;
}

function ParseUserInput(msg, id)
{
	local buffer = split(msg, " ")
	local val, cmd = buffer[0].tolower();

	if(buffer.len() > 1)
        val = buffer[1];
	
    //TODO move some of this shit into other functions 
	for(local i = 0; i < Players.len(); i++)
    {
        if(Players[i].ID == id)
        {
            switch(cmd)
            {
                case "g":
                case "gun":
					if(SetPrimary(val,i))
						return "true";
					else 
						return "false";
				case "p":
				case "pistol":
					if(SetSecondary(val,i))
						return "true";
					else 
						return "false";
					return "true";
				case "k":
				case "knife":
					if(SetKnife(val,i))
						return "true";
					else 
						return "false";
				return "true";
				case "hs":
				case "headshot":
				case "headshotonly":
					HeadshotOnly();
					return "false";
				case "a":
				case "arm":
				case "armor":
				case "armour":
				case "kev":
				case "kevlar":
					if(equipArmor)
						equipArmor = settingState("Armor", equipArmor);
					else
						equipArmor = settingState("Armor", equipArmor);
					return "false";
				case "h":	
				case "help":
					PrintHelp(val);
					return "false";
				case "helm":
				case "helmet":
					if(equipHelmet)
						equipHelmet = settingState("Helmet", equipHelmet);
					else
						equipHelmet = settingState("Helmet", equipHelmet);
					return "false";
				case "b":
				case "bump":
				case "bumpmines":
					if(giveBumpMines)
					{
						SendToConsole("sv_falldamage_scale 1");
						giveBumpMines = settingState("Bump Mines", giveBumpMines);
					}
					else
					{
						SendToConsole("sv_falldamage_scale 0");
						giveBumpMines = settingState("Bump Mines", giveBumpMines);
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
						enableBots = settingState("Bots", enableBots);
					}
					else
					{
						SendToConsole("bot_quota 4");
						enableBots = settingState("Bots", enableBots);
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
    }
}

function SetPrimary(val, i)
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
function SetSecondary(val, i)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Pistols: ")
		ScriptPrintMessageChatAll(" \x05 USP-S, P200, Glock, Tec-9, FiveSeven, Dual Berettas, P250");
		ScriptPrintMessageChatAll(" \x05 CZ-75, Deagle, Revolver");
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

function SetKnife(val, i)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Knives: ");
		ScriptPrintMessageChatAll(" \x05 M9, Bayonet, Butterfly, Karambit, Flip, Huntsman, Shadow Daggers");
		ScriptPrintMessageChatAll(" \x05 Bowie, Ursus, Navaja, Stiletto, Talon, Classic, Skeleton, Nomad");
		ScriptPrintMessageChatAll(" \x05 Paracord, Survival, Ghost, Gold, Falchion");
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

//TODO maybe rename to equipEquipment
function EquipPlayerArmor(player)
{
	EntFire("equip_strip", "Use", "", 0, player);

	if(equipArmor && equipHelmet)
		EquipWeapon("item_assaultsuit",60,player);
	else if(equipArmor)
		EquipWeapon("item_kevlar",60,player)

	//idk why this is here?
	if(giveBumpMines)
	{
		// Drop lots of them on the floor 
		EquipWeapon("weapon_bumpmine",60,player);
		EquipWeapon("weapon_bumpmine",60,player);
	}
}

function giveServerWeapons()
//TODO RENAME THIS AND DELETE THING FROM MAP
function GiveServer()	
{
	if(randomPrimary)
		::primary <- primaryList[rndint(primaryList.len())];
	else if(randomCompetitive)
		::primary <- competitiveList[rndint(competitiveList.len())];

	if(randomSecondary)
		::secondary <- secondaryList[rndint(secondaryList.len())];

	if(randomKnife)
		::knife <- knifeList[rndint(knifeList.len())];

	for(local i = 0; i < Players.len(); i++)
	{
		local player = VS.GetPlayerByUserid(Players[i].ID);
			
		EquipPlayerArmor(player);

		if(randomPrimary || randomCompetitive)
			Players[i].Primary = primary;	
		
		EquipWeapon(Players[i].Primary, 60, player);

		if(randomSecondary)
			Players[i].Secondary = secondary;

		EquipWeapon(Players[i].Secondary, 60, player);

		if(randomKnife)
			Players[i].Knife = knife;

		EquipWeapon(Players[i].Knife, 60, player);
		EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
	}
}

// Removes player weapon configuration and userid's incase there is a problem
function Reset()
{
	Players = [];	
	ScriptPrintMessageChatAll(" \x07 ALL ID'S ARE RESET");
}

// Logic for enable random primaries, secondaries and knives
function RandomWeapons(val)
{
	switch(val)
	{
		case "p":
		case "primary":
			if(randomPrimary)
				randomPrimary = settingState("Random Primary", randomPrimary);
			else
			{
				randomCompetitive = false;
				randomPrimary = settingState("Random Primary", randomPrimary);
			}
			break;
		case "s":
		case "secondary":
		case "sec":
			if(randomSecondary)
				randomSecondary = settingState("Random Secondary", randomSecondary);
			else
				randomSecondary = settingState("Random Secondary", randomSecondary);
			break;
		case "k":
		case "knife":
			if(randomKnife)
				randomKnife = settingState("Random Knife", randomKnife);
			else
				randomKnife = settingState("Random Knife", randomKnife);
			break;
		case "c":
		case "comp":
		case "competitive":
			if(randomCompetitive)
				randomCompetitive = settingState("Random Competitive", randomCompetitive);
			else
			{
				randomPrimary = false;
				randomCompetitive = settingState("Random Competitive", randomCompetitive);
			}
			break;
		default:
			settingState("Random Primaries", !randomPrimary);
			settingState("Random Secondaries", !randomSecondary);
			settingState("Random Knives", !randomKnife);
			settingState("Random Competitive", !randomCompetitive);
			break;
	}
}

function EquipWeapon(weapon, ammo, player)
{
    //Make required entities
    local equip = Entities.CreateByClassname("game_player_equip")
    equip.__KeyValueFromInt(weapon, ammo)

    //Give weapon to the player
    EntFireByHandle(equip, "use", "", 0, player, player)
    
    //Destroy the entity so we don't end up with a bunch of them
    equip.Destroy()
}

function HeadshotOnly()
{
	if(headshotOnly)
	{
		headshotOnly = settingState("Headshot Only", headshotOnly);
		SendToConsole("mp_damage_headshot_only 0");
	}
	else
	{
		headshotOnly = settingState("Headshot Only", headshotOnly);
		SendToConsole("mp_damage_headshot_only 1");
	}
}

function PrintHelp(val)
{
	switch(val)
	{
		case "3":
			ScriptPrintMessageChatAll(" \x04 Page 3/3");
			ScriptPrintMessageChatAll(" \x04 --------------------------------------------------------------------------------------");
			ScriptPrintMessageChatAll(" \x04 !bot |\x05 toggle bots");
			ScriptPrintMessageChatAll(" \x04 !reset: \x05 Players are assigned id's on connect, however sometimes these can be broken from players reconnecting or bot's taking id's for themeselves. \x03 ¯\\_\x28ツ\x29_/¯");
			ScriptPrintMessageChatAll(" \x07 Use !reset to fix this!"); 
			break;
		case "2":
			ScriptPrintMessageChatAll(" \x04 Page 2/3");
			ScriptPrintMessageChatAll(" \x04 --------------------------------------------------------------------------------------");
			ScriptPrintMessageChatAll(" \x04 !random \x05 toggles random weapons eg. !random knife");
			ScriptPrintMessageChatAll(" \x05 - options: primary \x04|\x05  secondary \x04|\x05 knife \x04|\x05 competitive")
			ScriptPrintMessageChatAll(" \x04 !armor \x05 toggles armor");
			ScriptPrintMessageChatAll(" \x04 !bumpmines\x05 toggles bump mines");
			ScriptPrintMessageChatAll(" \x04 !helmet \x05 toggles helmets");
			ScriptPrintMessageChatAll(" \x04 !hs \x05 toggles headshot only");
			break;
		case "1":
		default:
			ScriptPrintMessageChatAll(" \x04 Page 1/3");
			ScriptPrintMessageChatAll(" \x04 --------------------------------------------------------------------------------------");
			ScriptPrintMessageChatAll(" \x04 Write the command without arguments to list weapons \x05 eg. !gun");
			ScriptPrintMessageChatAll(" \x04 !gun Name ‎‎\x05 eg. !gun ak");
			ScriptPrintMessageChatAll(" \x04 !pistol Name \x05 eg. !pistol deagle");
			ScriptPrintMessageChatAll(" \x04 !knife Name \x05 eg. !knife butterfly");
			break;
	}
}

function rndint(max) {
    // Generate a pseudo-random integer between 0 and max - 1, inclusive
	local roll = rand() % max;
    //local roll = 1.0 * max * rand() / RAND_MAX;
    return roll.tointeger();
}