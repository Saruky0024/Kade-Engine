package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState_Return extends MusicBeatState
{
	override public function create():Void
	{
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);
		startIntro();
	}

	var logoBl:FlxSprite;
	var niceBG:FlxSprite;
	var nicegrASS:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		niceBG = new FlxSprite(0,0).loadGraphic(Paths.image('bgtitle2'));
		niceBG.scale.set(4,4);
		niceBG.antialiasing = true;
		niceBG.updateHitbox();
		niceBG.screenCenter();
		niceBG.y += 800;
		niceBG.x += 30;
		niceBG.alpha = 0;
		add(niceBG);

		nicegrASS = new FlxSprite(0,0).loadGraphic(Paths.image('bgpla1'));
		niceBG.scale.set(4,4);
		nicegrASS.antialiasing = true;
		nicegrASS.updateHitbox();
		nicegrASS.screenCenter();
		nicegrASS.y += 800;
		nicegrASS.x += 30;
		nicegrASS.alpha = 0;
		add(nicegrASS);

		logoBl = new FlxSprite(-150, -80);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.1, 0.1);
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.y = -500 - logoBl.height;
		logoBl.visible = false;
		add(logoBl);

		titleText = new FlxSprite(390, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.visible = false;
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		FlxG.mouse.visible = false;

		skipIntro();

		// credGroup.add(credTextShit);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{

			FlxTween.tween(logoBl, {'scale.x': 9, 'scale.y': 9, color: 0xFF000000}, 2.3, {ease: FlxEase.quartIn});
			FlxTween.tween(logoBl, {y: -5000, alpha: -1.5}, 1, {ease: FlxEase.quartIn});
			FlxTween.tween(titleText, {y: 800}, 1, {ease: FlxEase.quartIn});
			FlxTween.tween(FlxG.camera, {zoom: 4, alpha: 0}, 0.7, {ease: FlxEase.quartIn, startDelay: 0.5});

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1, null, true);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxTween.color(niceBG, 0.7, niceBG.color, 0xAA1F0076, {ease: FlxEase.quartInOut});
				FlxG.switchState(new MainMenuState());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			logoBl.visible = true;
			titleText.visible = true;

			FlxG.camera.flash(FlxColor.WHITE, 4, null, true);
			skippedIntro = true;

			FlxTween.tween(logoBl, {y: 290, 'scale.x': 1, 'scale.y': 1}, 2.3, {ease: FlxEase.backOut});
			niceBG.color = 0xFFFFFFFF;
			niceBG.alpha = 1;
			niceBG.scale.set(1.1,1.1);
			niceBG.updateHitbox();
			niceBG.x = -60;
			niceBG.y = -10;

			nicegrASS.color = 0xFFFFFFFF;
			nicegrASS.alpha = 1;
			nicegrASS.scale.set(1.1,1.1);
			nicegrASS.updateHitbox();
			nicegrASS.x = -60;
			nicegrASS.y = -10;
		}
	}
}
