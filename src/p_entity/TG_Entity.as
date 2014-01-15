package p_entity
{
	import flash.geom.Point;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EventDispatcher;

	public class TG_Entity extends EventDispatcher
	{
		protected var m_parent:DisplayObjectContainer;
		protected var m_sprite:Sprite;
		
		protected var m_stageStarling:Stage;
		
		protected var m_position:Point;
		protected var m_rotation:Number = 0;
		protected var m_direction:String = "left";
		public function TG_Entity(parent:DisplayObjectContainer)
		{
			m_parent = parent;
			m_position = new Point();
		}
		public function init():void
		{
			
		}
		
		public function destroy():void
		{
			destroySprite();
		}
		
		protected function destroySprite():void
		{
			if(m_sprite)
			{
				m_sprite.removeFromParent(true);
			}
		}
		
		protected function changeDirection(dir:String):void
		{
				if(dir.toLowerCase() == "right" && m_sprite.scaleX > 0)
				{
					m_direction = "right";
					m_sprite.scaleX *= -1;
				}
				else if(dir.toLowerCase() == "left" && m_sprite.scaleX < 0)
				{
					m_direction = "left";
					m_sprite.scaleX *= -1;
				}
		}
		
		public function get sprite():Sprite
		{
			return m_sprite;
		}
		public function get position():Point
		{
			return m_position;
		}
		
		public function get rotation():Number
		{
			return m_rotation;
		}
		
		public function set rotation(value:Number):void
		{
			m_rotation = value;
			if(m_sprite)
			m_sprite.rotation = m_rotation;
		}
		
		public function get direction():String
		{
			return m_direction;
		}
	}
}