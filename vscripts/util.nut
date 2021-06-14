::Reset <- function()
{
	Players = [];	
	ScriptPrintMessageChatAll(" \x07 ALL ID'S ARE RESET");
}

::IsBot <- function(player)
{
	player.ValidateScriptScope();
	player = player.GetScriptScope();
	return player.networkid == "BOT"
}

::SettingState <- function(option, state)
{
	if(state)
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x08Off");
	else
		ScriptPrintMessageChatAll(" \x03" + option + " is: \x05On");
	return !state;
}

::PrintHelp <- function(val)
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

::RandomInt <- function(max) 
{
	local roll = rand() % max;
    return roll.tointeger();
}