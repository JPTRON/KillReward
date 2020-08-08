#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "JPTRON"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <string>
#include <functions>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "KillReward",
	author = PLUGIN_AUTHOR,
	description = "Recebe pontos ao matar ou ajudar a matar alguém.",
	version = PLUGIN_VERSION,
	url = ""
};

Handle g_hPointCookie;
int messagePoints;

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
	g_hPointCookie = RegClientCookie("give_points", "Give Points", CookieAccess_Protected);
}


public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) {

    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    int assist = GetClientOfUserId(event.GetInt("assister"));
    char victimName[40], attackerName[40], assistName[40];
    
    GetClientName(victim, victimName, sizeof(victimName));
    GetClientName(attacker, attackerName, sizeof(attackerName));
    GetClientName(assist, assistName, sizeof(assistName));
    
  
    if(victim == attacker || attacker == 0){	
  		return;
  	}
	
	GivePoints(attacker, 10);

    PrintToChatAll("\x01 \x0B%s \x02matou \x10%s \x01| \x03Pontos: \x0E%i", attackerName, victimName, messagePoints);

	if(assist){
		GivePoints(assist, 2);
 	    PrintToChatAll("\x01 \x0B%s \x05ajudou a matar \x10%s \x01| \x03Pontos: \x0E%i", assistName, victimName, messagePoints);
	}	
}

public void GivePoints(int targetID, int points) {
	
	if (AreClientCookiesCached(targetID))
	{
	
		char sCookieValue[12];
		GetClientCookie(targetID, g_hPointCookie, sCookieValue, sizeof(sCookieValue));
		int Points = StringToInt(sCookieValue);
		Points += points;
		
 		messagePoints = Points;
 
		IntToString(Points, sCookieValue, sizeof(sCookieValue));
 
		SetClientCookie(targetID, g_hPointCookie, sCookieValue);
	}
}

