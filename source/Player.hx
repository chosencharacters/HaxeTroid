package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;


/**
 * A player that walks, jumps, jetpacks, and shoots!
 * @author <Your Name Here>
 */
class Player extends FlxSprite 
{
	/** max speed they on the X axis (horizontal) **/
	var maxSpeed:Int = 100;
	
	/** frames to reach max speed (60 frames per second) **/
	var framesToMaxSpeed:Int = 15;
	
	/** max health (also the default health when the player respawns) **/
	var maxHealth:Int = 100;
	
	/** default is full charge after 1 second (30 frames) **/
	var chargeRate:Int = 30;
	
	/** our intial jump, negative is up **/
	var initialJump:Int = -100;
	
	/** jetpack lift acceleration **/
	var lift:Int = 15;
	
	/** max jetpack lift **/
	var liftMax:Int = 60;
	
	/** max fuel, lose 1 per frame **/
	var fuelMax:Int = 40;
	
	/** player's current fuel **/
	var fuel:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		//just a simple square for now
		makeGraphic(20, 20);
		
		//set the max speed, Flixel won't let the object get any faster than this!
		maxVelocity.x = maxSpeed;
		
		//gravity, down is positive, up is negative
		acceleration.y = 200;
		
		//floor friction
		drag.x = 250;
	}
	
	/** main player loop **/
	override public function update(elapsed:Float):Void 
	{
		walk();
		jump();
		/*
		TODO:
		shoot();
		Take Damage functions
		*/
		
		super.update(elapsed);
	}
	
	/** Move left and right **/
	function walk() {
		if (FlxG.keys.anyPressed(["LEFT"])) 
		{
			//move to the LEFT (negative)
			velocity.x -= maxSpeed / framesToMaxSpeed;
			//if we're going to the RIGHT, slow down the player's speed (so they turn around faster)
			if (velocity.x > 0) velocity.x * .95;
		}
		if (FlxG.keys.anyPressed(["RIGHT"])) 
		{
			//move to the RIGHT (positive)
			velocity.x += maxSpeed / framesToMaxSpeed;
			//if we're going to the LEFT, slow down the player's speed (so they turn around faster)
			if (velocity.x < 0) velocity.x * .95;
		}
	}
	
	/** Press up to jump! **/
	function jump() {
		//easy access variable for being on the ground
		var onGround:Bool = isTouching(FlxObject.FLOOR);
		
		//if we're on the ground, we can use the jump
		if (onGround) 
		{
			//if we just pressed up, we jump
			if (FlxG.keys.anyJustPressed(["UP"])){
				velocity.y = initialJump;
			}
		}
	}
}