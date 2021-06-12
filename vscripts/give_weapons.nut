//This script allows players to change their weapons using chat commands

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

function OnPostSpawn() 
{
	mainScript = self.GetScriptScope();
}

//TODO the returns may be broken?
//TODO give bots they same random weapons as us
//Maybe bots should get random comp weapons by default
::OnGameEvent_round_start <- function(data)
{
	if(ScriptGetRoundsPlayed() == 0)
		ScriptPrintMessageChatAll(" \x04 Type !help for command help!");

	SendToConsole("mp_respawn_immunitytime 0")

	if(!enableBots)
		SendToConsole("bot_kick")

	foreach(ply in ::VS.GetAllPlayers())
	{
		local s = _init_scope(ply);

		if(!s.bot && s.networkid != "BOT")
		{
			for(local i = 0; i < 13; i+=4)
			{
				if(playerEquipment[i] == s.userid)
					break;
				
				else if(playerEquipment[i] == "null" &&s.userid != "" && s.userid != null)
				{
					ScriptPrintMessageChatAll(" \x04 Assigning ID \x07"+s.userid+"\x04 to \x07"+s.name);

					playerEquipment[i] = s.userid;
					givePlayerWeapons(s.userid)
					break;
				}
			}
		}
		else giveBotWeapons(s.userid);
	}

	local ft = FrameTime();
	foreach( i,v in ::VS.GetAllPlayers() )
		::delay("::VS.Events.ForceValidateUserid(activator)", i*ft, ::ENT_SCRIPT, v);

}.bindenv(this);

function giveBotWeapons(id)
{
	local player = VS.GetPlayerByUserid(id);
			
	EntFire("equip_strip", "Use", "", 0, player);
		
	equipPlayerArmor(player);

	EquipWeapon("weapon_ak47",60,player)

	EquipWeapon("weapon_deagle",60,player)
	
	EquipWeapon("weapon_knife",60,player)
}

::_init_scope <- function(s)
{
	s.ValidateScriptScope();
	s = s.GetScriptScope();
	if( !("userid" in s) ) s.userid <- "";
	if( !("networkid" in s) ) s.networkid <- "";
	if( !("name" in s) ) s.name <- "";
	if( !("bot" in s) ) s.bot <- s.networkid == "BOT";
	return s;
}

::OnGameEvent_player_say <- function( data )
{
	local msg = data.text				// get the chat message
	if(msg.slice(0,1) != "!") return	// if the message isn't a command, leave
	
	local id = data.userid;
	
	local result = SMain.SayCommand(msg.slice(1), id);

	//sometimes i don't want to update the players weapons
	if(result != null && result != "false") 
		SMain.givePlayerWeapons(id);
}

//TODO toggle the bool on/off with out parameter would be dank
function trueIsOn(bool)
{
	if(bool) return "\x05 On";
	else return "\x08 Off";
}

function settingState(option, state)
{
	if(state)
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x08Off");
	else
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x05On");

	return !state;
}

function SayCommand( msg, id)
{
	local buffer = split(msg, " ")
	local val, cmd = buffer[0]

	if(buffer.len() > 1)
        val = buffer[1];
	
    //TODO move some of this shit into other functions 
	//For every player?
    for(local i = 0; i < 13; i+=4)
    {
        if(id == playerEquipment[i])
        {
            switch(cmd.tolower())
            {
                case "g":
                case "gun":
					if(SetPrimary(val,i))
						ScriptPrintMessageChatAll(" \x04 Primary: \x05"+ playerEquipment[i+1]);
					else 
						return "false";
					return "true";
				case "p":
				case "pistol":
					if(SetPistol(val,i))
						ScriptPrintMessageChatAll(" \x04 Pistol: \x05"+ playerEquipment[i+2]);
					else 
						return "false";
					return "true";
				case "k":
				case "knife":
					if(SetKnife(val,i))
						ScriptPrintMessageChatAll(" \x04 Knife: \x05"+ playerEquipment[i+3]);
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

function SetPrimary(val,i)
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

	switch (val.tolower())
	{
		//Rifle
		case "ak47":
		case "ak":
			playerEquipment[i + 1] = "weapon_ak47";
			break;
		case "m4":
		case "m4a4":
			playerEquipment[i + 1] = "weapon_m4a1";
			break;
		case "m4a1":
		case "m4a1s":
			playerEquipment[i + 1] = "weapon_m4a1_silencer";
			break;
		case "aug":
			playerEquipment[i + 1] = "weapon_aug";
			break;
		case "sg":
		case "sg553":
		case "codgun":
			playerEquipment[i + 1] = "weapon_sg556";
			break;
		case "galil":
		case "gal":
			playerEquipment[i + 1] = "weapon_galilar";
			break;
		case "fam":
		case "famas":
			playerEquipment[i + 1] = "weapon_famas";
			break;
		case "awp":
			playerEquipment[i + 1] = "weapon_awp";
			break;
		case "ssg":
		case "ssg08":
		case "scout":
		case "scoot":
			playerEquipment[i + 1] = "weapon_ssg08";
			break;
		case "g3sg1":
		case "dakdak":
		case "dak":
		case "g3":
			playerEquipment[i + 1] = "weapon_g3sg1";
		case "scar":
		case "scar20":
			playerEquipment[i + 1] = "weapon_scar20";
			break;
			
		//Heavy
		case "nova":
			playerEquipment[i + 1] = "weapon_nova";
			break;
		case "xm":
		case "xm1014":
			playerEquipment[i + 1] = "weapon_xm1014";
			break;
		case "saw":
		case "sawedoff":
			playerEquipment[i + 1] = "weapon_sawedoff";
			break;
		case "mag":
		case "mag7":
			playerEquipment[i + 1] = "weapon_mag7";
			break;
		case "m249":
		case "m2":
		case "m24":
			playerEquipment[i + 1] = "weapon_m249";
			break;
		case "negev":
		case "neg":
			playerEquipment[i + 1] = "weapon_negev";
			break;
			
		//Smg
		case "mac":
		case "mac10":
			playerEquipment[i + 1] = "weapon_mac10";
			break;	
		case "mp9":
			playerEquipment[i + 1] = "weapon_mp9";
			break;
		case "mp7":
			playerEquipment[i + 1] = "weapon_mp7";
			break;
		case "mp5":
		case "mp5sd":
			playerEquipment[i + 1] = "weapon_mp5sd";
			break;			
		case "p90":
			playerEquipment[i + 1] = "weapon_p90";
			break;
		case "ump":
		case "ump45":
			playerEquipment[i + 1] = "weapon_ump45";
			break;
		case "bizon":
		case "pp":
		case "ppbizon":
			playerEquipment[i + 1] = "weapon_bizon";
			break;	
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a gun dumbass.");
			return false;
	}
	return true;
}
function SetPistol(val,i)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Pistols: ")
		ScriptPrintMessageChatAll(" \x05 USP-S, P200, Glock, Tec-9, FiveSeven, Dual Berettas, P250");
		ScriptPrintMessageChatAll(" \x05 CZ-75, Deagle, Revolver");
		return false;
	}

	switch (val.tolower())
	{
		case "usp":
		case "usp-s":
			playerEquipment[i + 2] = "weapon_usp_silencer";
			break;
			
		case "p2000":
		case "p2k":
		case "p200":
			playerEquipment[i + 2] = "weapon_hkp2000";
			break;
			
		case "glock":
		case "glock18":
			playerEquipment[i + 2] = "weapon_glock";
			break;	
			
		case "tec":
		case "tec9":
			playerEquipment[i + 2] = "weapon_tec9";
			break;
			
		case "fiveseven":
		case "57":
		case "five":
		case "seven":
			playerEquipment[i + 2] = "weapon_fiveseven";
			break;
		
		case "dual":
		case "dualies":
		case "berettas":
		case "dualberettas":
			playerEquipment[i + 2] = "weapon_elite";
			break;
		
		case "deagle":
		case "deag":
			playerEquipment[i + 2] = "weapon_deagle";
			break;
		
		case "p250":
		case "p25":
		case "p2":
			playerEquipment[i + 2] = "weapon_p250";
			break;
		
		case "cz":
		case "cz75":
		case "cz75a":
			playerEquipment[i + 2] = "weapon_cz75a";
			break;
			
		case "rev":
		case "revolver":
		case "yeehaw":
		case "r8":
			playerEquipment[i + 2] = "weapon_revolver";
			break;
			
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a pistol dumbass.");
			return false;
	}
	return true;
}

function SetKnife(val,i)
{
	if(val == null)
	{
		ScriptPrintMessageChatAll(" \x04 Knives: ");
		ScriptPrintMessageChatAll(" \x05 M9, Bayonet, Butterfly, Karambit, Flip, Huntsman, Shadow Daggers");
		ScriptPrintMessageChatAll(" \x05 Bowie, Ursus, Navaja, Stiletto, Talon, Classic, Skeleton, Nomad");
		ScriptPrintMessageChatAll(" \x05 Paracord, Survival, Ghost, Gold, Falchion");
		return false;
	}

	switch (val.tolower())
	{
		case "m9":
			playerEquipment[i + 3] = "weapon_knife_m9_bayonet";
			break;
		case "bay":
		case "bayonet":
			playerEquipment[i + 3] = "weapon_bayonet";
			break;
		case "butt":
		case "butterfly":
			playerEquipment[i + 3] = "weapon_knife_butterfly";
			break;
		case "karambit":
		case "kara":
			playerEquipment[i + 3] = "weapon_knife_karambit";
			break;
		case "flip":
			playerEquipment[i + 3] = "weapon_knife_flip";
			break;
		case "falcon":
		case "falchion":
		case "fal":
		case "falc":
			playerEquipment[i + 3] = "weapon_knife_falchion";
			break;
		case "gut":
			playerEquipment[i + 3] = "weapon_knife_gut";
			break;
		case "hunt":
		case "huntsman":
			playerEquipment[i + 3] = "weapon_knife_tactical";
			break;
		case "buttplugs":
		case "buttplug":
		case "shadow":
		case "daggers":
		case "dagger":
		case "shadowdaggers":
		case "shadowdagger":
			playerEquipment[i + 3] = "weapon_knife_push";
			break;
		case "bowie":
		case "bow":
			playerEquipment[i + 3] = "weapon_knife_survival_bowie";
			break;
		case "ursus":
		case "ur":
			playerEquipment[i + 3] = "weapon_knife_ursus";
			break;
		case "navaja":
		case "nava":
			playerEquipment[i + 3] = "weapon_knife_gypsy_jackknife";
			break;
		case "stiletto":
		case "stil":
			playerEquipment[i + 3] = "weapon_knife_stiletto";
			break;
		case "talon":
		case "tal":
			playerEquipment[i + 3] = "weapon_knife_widowmaker";
			break;
		case "classic":
		case "class":
		case "css":
			playerEquipment[i + 3] = "weapon_knife_css";
			break;
		case "skel":
		case "skeleton":
			playerEquipment[i + 3] = "weapon_knife_skeleton";
			break;
		case "gold":
			playerEquipment[i + 3] = "weapon_knifegg";
			break;
		case "nomad":
		case "nom":
		case "no":
			playerEquipment[i + 3] = "weapon_knife_outdoor";
			break;
		case "paracord":
		case "para":
			playerEquipment[i + 3] = "weapon_knife_cord";
			break;	
		case "survival":
		case "sur":
			playerEquipment[i + 3] = "weapon_knife_canis";
			break;			
		case "ghost":
			playerEquipment[i + 3] = "weapon_knife_ghost";
			break;
		default:
			ScriptPrintMessageChatAll(" \x07 " + val + " is not a knife dumbass.");
			return false;
	}
	return true;
}

function givePlayerWeapons(id)
{
	for(local i = 0; i < 13; i+=4)
    {
        if(playerEquipment[i] != "null" && playerEquipment[i] == id)
        {
            local player = VS.GetPlayerByUserid(playerEquipment[i]);
			
			EntFire("equip_strip", "Use", "", 0, player);
			
			equipPlayerArmor(player);

			//Primary
            EquipWeapon(playerEquipment[i+1],60,player)
			
			//Secondary
            EquipWeapon(playerEquipment[i+2],60,player)

			//Knife
            EquipWeapon(playerEquipment[i+3],60,player)
            EntFire("weapon_knife", "addoutput", "classname weapon_knifegg")
			
        }
    }
}

//TODO maybe rename to equipEquipment
function equipPlayerArmor(player)
{
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
//TODO add random weapons to playerEquipment so that they can be kept after random is turned off
//TODO i think this is causing problems
//Called on player spawn - fired once - when more than one person spawns this would fire multiple times
function giveServerWeapons()	
{
	if(randomPrimary)
	{
		::primary <- primaryList[rndint(primaryList.len())];
	}
	else if(randomCompetitive)
	{
		::primary <- competitiveList[rndint(competitiveList.len())];
	}

	if(randomSecondary)
	{
		::secondary <- pistolList[rndint(pistolList.len())];
	}
	if(randomKnife)
	{
		::knife <- knifeList[rndint(knifeList.len())];
	}

	for(local i = 0; i < 13; i+=4)
	{
		if(playerEquipment[i] != "null")
		{
			local player = VS.GetPlayerByUserid(playerEquipment[i]);
				
			EntFire("equip_strip", "Use", "", 0, player);
				
			equipPlayerArmor(player);

			if(randomPrimary || randomCompetitive)
			{
				EquipWeapon(primary,60,player);
			}
			else
			{
				EquipWeapon(playerEquipment[i+1],60,player);
			}
			if(randomSecondary)
			{
				EquipWeapon(secondary,60,player);
			}
			else
			{
				EquipWeapon(playerEquipment[i+2],60,player);
			}
			if(randomKnife)
			{
				EquipWeapon(knife,60,player);
				EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
			}
			else
			{
				EquipWeapon(playerEquipment[i+3],60,player);
				EntFire("weapon_knife", "addoutput", "classname weapon_knifegg");
			}
		}
	}
}

// Removes player weapon configuration and userid's incase there is a problem
function Reset()
{
	playerEquipment = ["null", "weapon_ak47","weapon_deagle","weapon_knife_m9_bayonet",
                      "null", "weapon_ak47","weapon_deagle","weapon_knife_m9_bayonet",
                      "null", "weapon_ak47","weapon_deagle","weapon_knife_m9_bayonet",
                      "null", "weapon_ak47","weapon_deagle","weapon_knife_m9_bayonet",];
	
	ScriptPrintMessageChatAll(" \x07 ALL ID'S ARE RESET");
}

// Logic for enable random primaries, secondaries and knives
function RandomWeapons(val)
{
	switch(val)
	{
		case "p":
		case "primary":
			if(!randomPrimary)
			{
				ScriptPrintMessageChatAll(" \x03 Random Primary: \x05 On");
				randomPrimary = true;

				//both use the primary slot one needs to be off
				randomCompetitive = false;
			}
			else
			{ 
				ScriptPrintMessageChatAll(" \x03 Random Primary: \x08 Off");
				randomPrimary = false;
			}
			break;
		case "s":
		case "secondary":
		case "sec":
			if(!randomSecondary)
			{
				ScriptPrintMessageChatAll(" \x03 Random Secondary: \x05 On");
				randomSecondary = true;
			}
			else
			{
				ScriptPrintMessageChatAll(" \x03 Random Secondary: \x08 Off");
				randomSecondary = false;
			}
			break;
		case "k":
		case "knife":
			if(!randomKnife)
			{
				ScriptPrintMessageChatAll(" \x03 Random Knife: \x05 On");
				randomKnife = true;
			}
			else
			{
				ScriptPrintMessageChatAll(" \x03 Random Knife: \x08 Off");
				randomKnife = false;
			}
			break;
		case "c":
		case "comp":
		case "competitive":
			if(!randomCompetitive)
			{
				ScriptPrintMessageChatAll(" \x03 Random Competitive: \x05 On");
				randomCompetitive = true;
				randomPrimary = false;
			}
			else
			{
				ScriptPrintMessageChatAll(" \x03 Random Competitive: \x08 Off");
				randomCompetitive = false;
			}
			break;
		default:
			ScriptPrintMessageChatAll(" \x03 Random primaries is: "+trueIsOn(randomPrimary));
			ScriptPrintMessageChatAll(" \x03 Random secondaries is: "+trueIsOn(randomSecondary));
			ScriptPrintMessageChatAll(" \x03 Random knives is: "+trueIsOn(randomKnife));
			ScriptPrintMessageChatAll(" \x03 Random competitive is: "+trueIsOn(randomCompetitive));
			break;
	}
}

function rndint(max) {
    // Generate a pseudo-random integer between 0 and max - 1, inclusive
	local roll = rand() % max;
    //local roll = 1.0 * max * rand() / RAND_MAX;
    return roll.tointeger();
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
		headshotOnly = false;
		SendToConsole("mp_damage_headshot_only 0");
		ScriptPrintMessageChatAll(" \x03 Headshot Only: \x08 Off");
	}
	else
	{
		headshotOnly = true;
		SendToConsole("mp_damage_headshot_only 1");
		ScriptPrintMessageChatAll(" \x03 Headshot Only: \x05 On")
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

//This is not used because logic auto is better, good for reference though
function ServerCommands()	
{
	//invunrabiltity
	SendToConsole("mp_respawn_immunitytime 0")

	//end warmup
	SendToConsole("mp_warmup_end")
	SendToConsole("mp_warmuptime 0")

	//roundtime
	SendToConsole("mp_roundtime 60")
	SendToConsole("mp_roundtime_defuse 60")
	SendToConsole("mp_roundtime_hostage 60")
	SendToConsole("mp_timelimit 0")

	//maxrounds
	SendToConsole("mp_maxrounds 100")

	//halftime
	SendToConsole("mp_halftime 0")
	SendToConsole("mp_halftime_duration 0")

	//roundtimedelays
	SendToConsole("mp_round_restart_delay 1")
	SendToConsole("mp_freezetime 0")

	//ffa
	SendToConsole("mp_solid_teammates 1")
	SendToConsole("mp_teammates_are_enemies 1")
	SendToConsole("mp_autokick 0")
	SendToConsole("mp_autoteambalance 0")
	//nextmap
	SendToConsole("mp_endmatch_votenextmap 0")
	SendToConsole("mp_endmatch_votenextmap_keepcurrent 1")

	//spectators
	SendToConsole("mp_forcecamera 0")

	//default weapons
	SendToConsole("mp_ct_default_primary 0")
	SendToConsole("mp_ct_default_secondary 0")
	SendToConsole("mp_t_default_primary 0")
	SendToConsole("mp_t_default_secondary 0")

	//All talk
	/*
	sv_alltalk 1
	sv_auto_full_alltalk_during_warmup_half_end 1 
	sv_deadtalk 1 
	sv_full_alltalk 1
	sv_talk_after_dying_time 1 
	sv_talk_enemy_dead 1 
	sv_talk_enemy_living 1 
	*/
}
