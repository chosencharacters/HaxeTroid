package;

import flixel.FlxObject;

/**
 * A spicy missile
 * @author <Your Name Here>
 */
class Missile extends Bullet 
{
	static inline var MAX_MISSILE_VELOCITY:Int = 200;
	
	public function new() 
	{
		super();
		
		loadGraphic(AssetPaths.missile__png);
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		maxVelocity.x = MAX_MISSILE_VELOCITY;
		
		if (velocity.x > 0){
			facing = FlxObject.LEFT;
			x -= 3; //difference in size between a missile and a bullet is 3
		}
		
		//missile starts slow
		velocity.x = velocity.x / 10;
	}
	
	override public function update(elapsed:Float):Void 
	{
		//then gets rapidly faster
		velocity.x = velocity.x * 1.2;
		super.update(elapsed);
	}
	
}