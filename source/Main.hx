package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		//order is width, height, starting state, zoom, draw fps, update fps, skip the splash screen
		addChild(new FlxGame(256, 144, PlayState, 1, 60, 60, true));
	}
	
}