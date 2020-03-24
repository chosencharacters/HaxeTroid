package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

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
	
	/** missile (!!!) charge **/
	var charge:Int = 0;
	
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
	
	var bullets:FlxTypedGroup<Bullet>;

	/** player's current fuel **/
	var fuel:Int = 0;
	
	/** Are we in jetpack mode? **/
	var jetpackMode:Bool = false;
	
	//Controls
	var rightButton:Bool = false;
	var leftButton:Bool = false;
	var jumpButtonPressed:Bool = false;
	var jumpButtonHeld:Bool = false;
	var jumpButtonReleased:Bool = false;
	var shootButtonPressed:Bool = false;
	var shootButtonHeld:Bool = false;
	var shootButtonReleased:Bool = false;
	
	public function new(x:Float, y:Float, bullets:FlxTypedGroup<Bullet>) 
	{
		super(x, y);
		this.bullets = bullets;
		
		//adding animations
		loadGraphic(AssetPaths.astro__png, true, 8, 9, true);
		animation.add("idle", [0]);
		animation.add("walk", [1, 2], 6, true);
		animation.add("jump", [3]);
		
		//our guy is facing right by default, so if he turns left we should flip it
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
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
		updateControl();
		walk();
		jump();
		shoot();
		/*
		TODO:
		Take Damage functions
		*/
		
		animationHandler();
		
		super.update(elapsed);
	}
	
	/** Updates controls **/
	function updateControl(){
		//1. Keyboard Controls
		rightButton = FlxG.keys.anyPressed(["RIGHT"]);
		leftButton = FlxG.keys.anyPressed(["LEFT"]);
		jumpButtonPressed = FlxG.keys.anyJustPressed(["UP", "Z"]);
		jumpButtonHeld = FlxG.keys.anyPressed(["UP", "Z"]);
		jumpButtonReleased = FlxG.keys.anyJustReleased(["UP", "Z"]);
		shootButtonPressed = FlxG.keys.anyJustPressed(["X", "SPACE"]);
		shootButtonHeld = FlxG.keys.anyPressed(["X", "SPACE"]);
		shootButtonReleased = FlxG.keys.anyJustReleased(["X", "SPACE"]);
		
		//2. Joystick Controls
		
		//joystick deadzone so minor movements don't get detected, feel free to tweak this
		var deadzone:Float = 0.1;
		
		var gamepad:FlxGamepad = FlxG.gamepads.getFirstActiveGamepad();
		
		if(gamepad != null) 
		{
			rightButton = rightButton || gamepad.analog.value.LEFT_STICK_X > deadzone || gamepad.anyPressed([FlxGamepadInputID.DPAD_RIGHT]);
			leftButton = leftButton || gamepad.analog.value.LEFT_STICK_X < deadzone || gamepad.anyPressed([FlxGamepadInputID.DPAD_LEFT]);
			jumpButtonPressed = jumpButtonPressed || gamepad.anyJustPressed([FlxGamepadInputID.A]);
			jumpButtonHeld = jumpButtonHeld || gamepad.anyPressed([FlxGamepadInputID.A]);
			jumpButtonReleased = jumpButtonReleased || gamepad.anyJustReleased([FlxGamepadInputID.A]);
			shootButtonPressed = shootButtonPressed || gamepad.anyJustPressed([FlxGamepadInputID.X]);
			shootButtonHeld = shootButtonHeld || gamepad.anyPressed([FlxGamepadInputID.X]);
			shootButtonReleased = shootButtonReleased || gamepad.anyJustReleased([FlxGamepadInputID.X]);
		}
	}
	
	/** Move left and right **/
	function walk() {
		if (leftButton) 
		{
			//move to the LEFT (negative)
			velocity.x -= maxSpeed / framesToMaxSpeed;
			//if we're going to the RIGHT, slow down the player's speed (so they turn around faster)
			if (velocity.x > 0) velocity.x * .95;
		}
		if (rightButton) 
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
			if (jumpButtonPressed){
				velocity.y = initialJump;
			}
		}
		
		//Jetpack handler
		//J1. If we hold UP and we have fuel
		if (jumpButtonHeld && fuel > 0 && jetpackMode) 
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
			//If we're on the floor, we reset jetpackMode
			jetpackMode = false;
			//They'll recharge in fuelRechargeRate frames
			fuel += Math.ceil(fuelMax / fuelRechargeRate);
			if (fuel > fuelMax) {
				fuel = fuelMax;
			}
		}
		
		//J4. Use jetpack only when the key is released and pressed again afterwards
		if (!onGround && jumpButtonReleased)
		{
			jetpackMode = true;
		}
	}
	
	/** Shoots a bullet or missile **/
	function shoot()
	{
		if (shootButtonHeld) charge++;
		
		//switch to misisles if charge is complete
		var missileMode:Bool = charge >= chargeRate;
		
		//our two conditions handle inputs for regular bullets or missiles
		if (shootButtonPressed || shootButtonReleased && missileMode) {
			var bulletSpeedX:Int = 150;
			//the edge of the sprite
			var bulletX:Float = x + width;
			//about where the arm is
			var bulletY:Float = y + 5;
			//if facing left
			if (facing == FlxObject.LEFT) {
				//reverse the speed
				bulletSpeedX = -bulletSpeedX;
				//opposite edge of the sprite - bullet width
				bulletX = x - 2;
			}
			
			if (missileMode) {
				//shoot a missile
				var missile = bullets.recycle(Missile.new);
				missile.init(bulletX, bulletY, bulletSpeedX, 0, 5);
			} else {
				//shoot a regular bullet
				var bullet = bullets.recycle(Bullet.new);
				bullet.init(bulletX, bulletY, bulletSpeedX, 0, 1);
			}
		}
		
		if (shootButtonReleased){
			charge = 0;
		}
	}
	
	/** picks an animation to play **/
	function animationHandler()
	{
		var isWalking:Bool = velocity.x != 0;
		var isJumping:Bool = !isTouching(FlxObject.FLOOR);
		
		//walking animation only when you're walking on the ground
		if (isWalking && !isJumping)
			animation.play("walk");
		
		//jumping animation is always when you're in the air
		if (isJumping)
			animation.play("jump");
		
		//idle animation only when you're on the floor
		if (!isWalking && !isJumping)
			animation.play("idle");
			
		//turn around when you're going in the opposite direction, but only if you're actually moving
		if (velocity.x != 0){
			if (velocity.x < 0){
				facing = FlxObject.LEFT;
			}else{
				facing = FlxObject.RIGHT;
			}
		}
	}
}