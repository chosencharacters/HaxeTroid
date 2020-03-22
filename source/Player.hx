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
	
	/** default is full charge after 1/2 second (30/60 frames) **/
	var chargeRate:Int = 30;
	
	/** our intial jump, negative is up **/
	var initialJump:Int = -100;
	
	/** jetpack lift acceleration **/
	var lift:Int = 15;
	
	/** max jetpack lift **/
	var liftMax:Int = 60;
	
	/** max fuel, lose 1 per frame **/
	var fuelMax:Int = 40;
	
	/** frames until fuel is recharged **/
	var fuelRechargeRate:Int = 20;
	
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
	
	/** Press UP to jump! **/
	function jump() {
		//1. Detect we're on the floor
		var onGround:Bool = isTouching(FlxObject.FLOOR);
		
		//2. If we're on the ground...
		if (onGround) 
		{
			//We can jump if the UP key is pressed!
			if (FlxG.keys.anyJustPressed(["UP"])){
				velocity.y = initialJump;
			}
		}
		
		//Jetpack handler
		//J1. If we hold UP and we have fuel
		if (FlxG.keys.anyPressed(["UP"]) && fuel > 0) 
		{
			//J2. Add lift and decrease fuel
			velocity.y -= lift;
			fuel--;
			//Max velocity so they don't go flying infinitely faster
			if (velocity.y < -liftMax) {
				velocity.y = -liftMax;
			}
		}
		//J3. When they're on the floor, add fuel back.
		if (onGround) 
		{
			//They'll recharge in fuelRechargeRate frames
			fuel += Math.ceil(fuelMax / fuelRechargeRate);
			if (fuel > fuelMax) {
				fuel = fuelMax;
			}
		}
	}
}