package;

import flixel.FlxSprite;

/**
 * A simple square that contains data on damage
 * @author <Your Name Here>
 */
class Bullet extends FlxSprite
{
	/** how much damage our bullet does **/
	public var damage(default, null):Int = 1;
	
	/** how long our bullet stays active (in frames) **/
	var lifeSpan:Int = 180;

	public function new()
	{
		super();
	}
	
	public function init(x:Float, y:Float, velX:Float, velY:Float, damage:Int)
	{
		setPosition(x, y);

		//set our damage
		this.damage = damage;

		//make a simple square
		makeGraphic(2, 2);

		//set velocity the easy way
		velocity.set(velX, velY);
	}

	override public function update(elapsed:Float):Void
	{
		lifeSpan--;
		if (lifeSpan <= 0) kill();
		super.update(elapsed);
	}
}