package;

import flixel.FlxG;

using StringTools;

class FirstCheck extends MusicBeatState
{

    override function create():Void
    {
        // Get current version of Kade Engine

		//var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");
		var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/patchnotes/version.downloadMe");
		var returnedData:Array<String> = [];
				
		http.onData = function (data:String)
		{
			returnedData[0] = data.substring(0, data.indexOf(';'));
			returnedData[1] = data.substring(data.indexOf('-'), data.length);
		  	if (!MainMenuState.kadeEngineVer.contains(returnedData[0].trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
			{
				trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.kadeEngineVer);
				OutdatedSubState.needVer = returnedData[0];
				OutdatedSubState.currChanges = returnedData[1];
				FlxG.switchState(new OutdatedSubState());
			}
			else
			{
				FlxG.switchState(new TitleState());
			}
		}
				
		http.onError = function (error) {
		  trace('error: $error');
		  FlxG.switchState(new TitleState()); // fail but we go anyway
		}
				
		http.request();
    }
}