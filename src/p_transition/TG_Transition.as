package p_transition
{
	import p_engine.p_singleton.TG_World;
	import p_engine.p_transition.TG_TransitionTemplate;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	
	public class TG_Transition extends TG_TransitionTemplate
	{
		private var m_sprite:Sprite;
		private var m_quad:Quad;
		private var m_image:Image;
		private var m_quadBatch:QuadBatch;
		private var m_speed:int = 5000;
		
		private var m_startPosX:Number = 0;
		private var m_endPosX:Number = 0;
		private var m_midPosX:Number = 0;
		public function TG_Transition(parent:DisplayObjectContainer)
		{
			super(parent);
		}
		
		protected override function initClip():void
		{
			super.initClip();
			
			m_quad = new Quad(TG_World.GAME_WIDTH + 100,TG_World.GAME_HEIGHT + 100,0x000000,false);
			m_quad.touchable = false;
			m_image = new Image(TG_World.assetManager.getTexture("transition"));
			m_image.touchable = false;
			m_quadBatch = new QuadBatch();
			m_quadBatch.touchable = false;
			
			m_sprite = new Sprite();
			m_sprite.touchable = false;
			m_sprite.addChild(m_quad);
			m_sprite.addChild(m_quadBatch);
			
			m_image.scaleX = m_image.scaleY = TG_World.SCALE;
			
			var currentHeight:Number = 0;
			while(currentHeight < TG_World.GAME_HEIGHT)
			{
				if(currentHeight <= 0)
				{
					m_image.y = currentHeight;
					currentHeight+=(m_image.height);
				}
				else
				{
					m_image.y = currentHeight-2;
					currentHeight+=(m_image.height-2);
				}
				
				m_image.rotation = 0;
				m_image.x = TG_World.GAME_WIDTH -2;
				m_quadBatch.addImage(m_image);
				
				
				m_image.rotation = deg2rad(180);
				m_image.y += m_image.height;
				m_image.x = 2;
				m_quadBatch.addImage(m_image);
				
			}
			TG_Static.layerTransition.addChild(m_sprite);
			
			m_midPosX = 0;
			m_startPosX = -(m_sprite.width - m_image.width);
			m_endPosX = m_sprite.width + m_image.width;
			state = "idle";
		}
		
		public override function resize():void
		{
			m_quad.width = TG_World.GAME_WIDTH;
			m_quad.height = TG_World.GAME_HEIGHT;
			
			m_image.scaleX = m_image.scaleY = TG_World.SCALE;
			m_quadBatch.reset();
			
			var currentHeight:Number = 0;
			while(currentHeight < TG_World.GAME_HEIGHT)
			{
				if(currentHeight <= 0)
				{
					m_image.y = currentHeight;
					currentHeight+=(m_image.height);
				}
				else
				{
					m_image.y = currentHeight-2;
					currentHeight+=(m_image.height-2);
				}
				
				m_image.rotation = 0;
				m_image.x = TG_World.GAME_WIDTH -2;
				m_quadBatch.addImage(m_image);
				
				
				m_image.rotation = deg2rad(180);
				m_image.y += m_image.height;
				m_image.x = 2;
				m_quadBatch.addImage(m_image);
				
			}
			
			m_midPosX = 0;
			m_startPosX = -(m_sprite.width - m_image.width);
			m_endPosX = m_sprite.width + m_image.width
		}
		
		public override function fadeIn():void
		{
			timeToDestroy = false;
			timeToFinish = false;
			
			m_sprite.x = m_startPosX;
			state = "fadeIn";
			m_sprite.visible = true;
		}
		
		public override function fadeOut():void
		{
			timeToDestroy = false;
			timeToFinish = false;
			
			m_sprite.x = m_midPosX;
			state = "fadeOut";
		}
		
		public override function update(elapsedTime:int):void
		{
			if(state == "fadeIn")
			{
				m_sprite.x += m_speed * elapsedTime/1000;
				if(m_sprite.x >= m_midPosX)
				{
					m_sprite.x = m_midPosX;
					timeToDestroy = true;
					state = "idle";
				}
			}
			else if(state == "fadeOut")
			{
				m_sprite.x += m_speed * elapsedTime/1000;
				if(m_sprite.x >= m_endPosX)
				{
					m_sprite.x = m_endPosX;
					timeToFinish = true;
					m_sprite.visible = false;
					state = "idle";
				}
			}
		}
	}
}