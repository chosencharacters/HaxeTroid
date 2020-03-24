package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	var player:Player;
	var testPlatform:FlxSprite;
	public static var bullets:FlxTypedGroup<Bullet>;
	
	override public function create():Void
	{
		super.create();
		
		//add and assign the player variable in one line, nifty!
		add(player = new Player(100, 100));
		
		//make a simple test platform
		add(testPlatform = new FlxSprite(0, player.y + player.height));
		testPlatform.makeGraphic(FlxG.width, 100);
		testPlatform.immovable = true;
		
		//make a group of bullets
		add(bullets = new FlxTypedGroup<Bullet>());
	}

	override public function update(elapsed:Float):Void
	{
		//give the testPlatform Collision with the player
		FlxG.collide(player, testPlatform);
		
		super.update(elapsed);
	}
}
