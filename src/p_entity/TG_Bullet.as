package p_entity
{
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	
	public class TG_Bullet extends TG_Entity
	{
		private var m_targetRotation:Number = 0;
		private var m_damage:int = 0;
		private var m_target:TG_Character;
		
		private var m_speed:int = 100;
		public function TG_Bullet(parent:DisplayObjectContainer,damage:int,target:TG_Character,targetRotation:Number)
		{
			TG_Static.BULLETS.push(this);
			super(parent);
			
			m_targetRotation = targetRotation;
			m_damage = damage;
			m_target = target;
		}
		
		public function update(elapsedTime:int):void
		{
			if(m_sprite)
			{
				
			}
		}
		
		public override function destroy():void
		{
			super.destroy();
			var index:int = TG_Static.BULLETS.indexOf(this);
			if(index >= 0)
			{
				TG_Static.BULLETS.splice(index,1);
			}
		}
	}
}