package;

import flixel.FlxSprite;
import flixel.FlxObject;

/**
 * A spicy missile
 * @author <Your Name Here>
 */
class Missile extends Bullet 
{
	var maxMissileVelocity:Int = 200;
	
	public function new(X:Float=0, Y:Float=0, velX:Float=0, velY:Float=0, team:Int=0) 
	{
		super(X, Y - 1, velX, velY, team);
		
		loadGraphic(AssetPaths.missile__png);
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		
		maxVelocity.x = maxMissileVelocity;
		
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