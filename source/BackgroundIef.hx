package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundIef extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas("friendsth/iefdance");
		animation.addByIndices('danceLeft', 'ief dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], "", 24, true);
		animation.addByIndices('danceRight', 'ief dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], "", 24, true);
		animation.play('danceLeft');
		antialiasing = true;
	}

	var dancefrDir:Bool = false;

	public function dance():Void
	{
		dancefrDir = !dancefrDir;

		if (dancefrDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
