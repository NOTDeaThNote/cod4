// This file has been autogenerated using CoD4X 1.8 server. //
// If it contains wrong data, please create issue here:     //
//    https://github.com/callofduty4x/CoD4x_Server/issues   //
init()
{
	if( !isDefined( game[ "is_licence_valid" ] ) )
		game[ "is_licence_valid" ] = 0;

	thread code\events::addConnectEvent( ::initialSetup );
	thread check();
}

check()
{
	if( game[ "is_licence_valid" ] )
	{
		level.check_done = 1;
		return;
	}
	
	if( level.leiizko_dvars[ "promod_licence" ] == "" )
	{
		level.check_done = 1;
		thread hud();
		return;
	}
	
	realtime = GetRealTime();
	ip = getDvar( "net_ip" );
	ip_array = strTok( ip, "." );
	port = getDvar( "net_port" );
	stringtime = TimeToString( realtime, 0, "%j.%m.%Y" );
	time_array = strTok( stringtime, "." );
	
	unscrambled = "";
		
	for( i = 1; i < level.leiizko_dvars[ "promod_licence" ].size; i += 3 )
	{
		if( isSubStr( "abcdefghijxzy", level.leiizko_dvars[ "promod_licence" ][ i ] ) )
			switch( level.leiizko_dvars[ "promod_licence" ][ i ] )
			{
				case "a": unscrambled += "1"; break;
				case "b": unscrambled += "2"; break;
				case "c": unscrambled += "3"; break;
				case "d": unscrambled += "4"; break;
				case "e": unscrambled += "5"; break;
				case "f": unscrambled += "6"; break;
				case "g": unscrambled += "7"; break;
				case "h": unscrambled += "8"; break;
				case "i": unscrambled += "9"; break;
				case "j": unscrambled += "."; break;
				case "x": unscrambled += "0"; break;
				case "z": unscrambled += ";"; break;
				case "y": unscrambled += ";"; break;
			}
		else
		{
			level.nope = 1;
			break;
		}
	}
	
	if( isDefined( level.nope ) )
	{
		level.check_done = 1;
		thread hud();
		return;
	}
	
	linc_array = strTok( unscrambled, ";" );
	
	if( !isDefined( linc_array ) || linc_array.size != 8 )
	{
		level.check_done = 1;
		thread hud();
		return;
	}
	
	if( int(time_array[ 0 ]) > int(linc_array[ 0 ]) && int(time_array[ 2 ]) == int(linc_array[ 2 ]) )
		game[ "is_licence_valid" ] = 0;
		
	else if( int(time_array[ 2 ]) > int(linc_array[ 2 ]) )
		game[ "is_licence_valid" ] = 0;
	
	else if( int(time_array[ 1 ]) > int(linc_array[ 1 ]) && int(time_array[ 2 ]) == int(linc_array[ 2 ]) )
		game[ "is_licence_valid" ] = 0;
	
	else
		game[ "is_licence_valid" ] = 1;
		
	for( i=0; i<ip_array.size; i++ )
	{
		if( int( ip_array[ i ] ) != int( linc_array[ i + 3 ] ) )
		{
			game[ "is_licence_valid" ] = 0;
			break;
		}
	}
	
	if( int( port ) != int( linc_array[ 7 ] ) )
		game[ "is_licence_valid" ] = 0;
	
	level.check_done = 1;
	
	if( !game[ "is_licence_valid" ] )
		thread hud();
}

hud()
{
	level.outblack = newHudElem();
	level.outblack.x = 0;
	level.outblack.y = 0;
	level.outblack.horzAlign = "fullscreen";
	level.outblack.vertAlign = "fullscreen";
	level.outblack.foreground = false;
	level.outblack setShader("white", 640, 480);
	level.outblack.alpha = 1;
	
	while( 1 )
	{
		iprintlnbold( "Lincence not valid! Contact ^5{MiCkEy}.ViRuS  " );
		wait 5;
	}
}

initialSetup()
{
	self endon( "disconnected" );
	
	waittillframeend;
	
	while( !isDefined( level.check_done ) )
		wait .1;
		
	if( game[ "is_licence_valid" ] )
		self setClientDvar( "promod_licence_valid", "True" );
	else
		self setClientDvar( "promod_licence_valid", "False" );
}