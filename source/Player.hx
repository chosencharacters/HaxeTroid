package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player extends FlxSprite 
{
	var speed:Int = 15; //frames to reach max speed (60 frames per second)
	var maxSpeed:Int = 100; //max speed they on the X axis (horizontal)
	
	var maxHealth:Int = 100; //max health (also the default health when the player respawns)
	
	var chargeRate:Int = 30; //default is full charge after 1 second (30 frames)
	
	var lift:Int = 15; //jetpack lift acceleration
	var liftMax:Int = 60; //max jetpack lift
	
	var fuelMax:Int = 40; //max fuel, lose 1 per frame
	var fuel:Int = 0; //player's current fuel
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(20, 20); //just a simple square for now
		maxVelocity.x = maxSpeed; //set the max speed, Flixel won't let the object get any faster than this!
		
		drag.x = 200; //loss of speed when the button is let go
	}
	
	override public function update(elapsed:Float):Void 
	{
		walk();
		/*
		TODO:
		jump();
		shoot();
		Take Damage functions
		*/
		
		super.update(elapsed);
	}
	
}