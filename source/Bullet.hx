package;

import flixel.FlxSprite;

/**
 * A simple square that contains data on damage
 * @author <Your Name Here>
 */
class Bullet extends FlxSprite
{
	/** how much damage our bullet does **/
	public var dmg:Int = 1;
	
	/** how long our bullet stays active (in frames) **/
	var lifeSpan:Int = 180;
	
	public function new(X:Float = 0, Y:Float = 0, velX:Float = 0, velY:Float = 0, strength:Int = 1)
	{
		super(X, Y);
		//set our damage
		dmg = strength;
		
		//make a simple square
		makeGraphic(2, 2);
		
		//set velocity the easy way
		velocity.set(velX, velY);
		
		//add it to our bullet layer
		PlayState.bullets.add(this);
	}

	override public function update(elapsed:Float):Void
	{
		lifeSpan--;
		if (lifeSpan <= 0) kill();
		super.update(elapsed);
	}
	
	override function kill(){
		//clean up bullets a bit by removing this bullet from it
		PlayState.bullets.remove(this, true);
		super.kill();
	}

}