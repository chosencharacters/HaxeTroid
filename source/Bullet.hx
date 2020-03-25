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
	var lifeSpan:Int;

	public function new()
	{
		super();

		//make a simple square
		makeGraphic(2, 2);
	}
	
	public function init(x:Float, y:Float, velX:Float, velY:Float, damage:Int)
	{
		lifeSpan = 180;

		setPosition(x, y);

		//set our damage
		this.damage = damage;

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