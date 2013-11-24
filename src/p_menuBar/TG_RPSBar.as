package p_menuBar
{
	import com.greensock.TimelineMax;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.ButtonExtended;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	public class TG_RPSBar extends TG_MenuBar
	{
		
		private var m_rockButton:ButtonExtended;
		private var m_rockSprite:Sprite;
		private var m_rockText:TextField;
		private var m_rockInitialPosX:Number;
		private var m_rockInitialPosY:Number;
		
		private var m_paperButton:ButtonExtended;
		private var m_paperSprite:Sprite;
		private var m_paperText:TextField;
		private var m_paperInitialPosX:Number;
		private var m_paperInitialPosY:Number;
		
		private var m_scissorButton:ButtonExtended;
		private var m_scissorSprite:Sprite;
		private var m_scissorText:TextField;
		private var m_scissorInitialPosX:Number;
		private var m_scissorInitialPosY:Number;
		
		public function TG_RPSBar(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			super(parent, gameState);
		}
		
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			var textures:Vector.<Texture>;
			
			//ROCK
			textures = TG_World.assetManager.getTextures("ButtonRock");
			m_rockButton = new ButtonExtended(textures[0],"",textures[2],textures[1]);
			m_rockSprite = new Sprite();
			m_rockText = new TextField(100,70,"Q","Londrina",50,0x00FFFF);
			m_rockText.autoSize = TextFieldAutoSize.HORIZONTAL;
			m_rockText.x = 15;
			m_rockText.touchable = false;
			
			m_rockSprite.addChild(m_rockButton);
			m_rockSprite.addChild(m_rockText);
			m_sprite.addChild(m_rockSprite);
			
			m_rockInitialPosX = m_rockSprite.x;
			m_rockInitialPosY = m_rockSprite.y;
			
			//PAPER
			textures = TG_World.assetManager.getTextures("ButtonPaper");
			m_paperButton = new ButtonExtended(textures[0],"",textures[2],textures[1]);
			m_paperSprite = new Sprite();
			m_paperText = new TextField(100,70,"W","Londrina",50,0x00FFFF);
			m_paperText.autoSize = TextFieldAutoSize.HORIZONTAL;
			m_paperText.x = 15;
			m_paperText.touchable = false;
			
			m_paperSprite.addChild(m_paperButton);
			m_paperSprite.addChild(m_paperText);
			m_sprite.addChild(m_paperSprite);
			
			m_paperSprite.x = m_rockSprite.x + m_rockSprite.width + 20;
			
			m_paperInitialPosX = m_paperSprite.x;
			m_paperInitialPosY = m_paperSprite.y;
			
			//SCISSOR
			textures = TG_World.assetManager.getTextures("ButtonScissor");
			m_scissorButton = new ButtonExtended(textures[0],"",textures[2],textures[1]);
			m_scissorSprite = new Sprite();
			m_scissorText = new TextField(100,70,"E","Londrina",50,0x00FFFF);
			m_scissorText.autoSize = TextFieldAutoSize.HORIZONTAL;
			m_scissorText.x = 15;
			m_scissorText.touchable = false;
			
			m_scissorSprite.addChild(m_scissorButton);
			m_scissorSprite.addChild(m_scissorText);
			m_sprite.addChild(m_scissorSprite);
			
			m_scissorSprite.x = m_paperSprite.x + m_paperSprite.width + 20;
			
			m_scissorInitialPosX = m_scissorSprite.x;
			m_scissorInitialPosY = m_scissorSprite.y;
		}
		
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				fadeAnimationPos(m_timeline,m_rockSprite,m_rockSprite.x,m_rockSprite.height,m_rockInitialPosX,m_rockInitialPosY,0.3,0);
				fadeAnimationPos(m_timeline,m_paperSprite,m_paperSprite.x,m_paperSprite.height,m_paperInitialPosX,m_paperInitialPosY,0.3,0.2);
				fadeAnimationPos(m_timeline,m_scissorSprite,m_scissorSprite.x,m_scissorSprite.height,m_scissorInitialPosX,m_scissorInitialPosY,0.3,0.4);
			
				m_timeline.gotoAndStop(0.7);
			}
		}
		
		public override function show():void
		{
			if(m_timeline)
			{
				m_sprite.visible = true;
				m_timeline.gotoAndPlay(0,false);
			}
		}
		public function invisible():void
		{
			m_sprite.visible = false;
		}
		
		public override function hide():void
		{
			if(m_timeline)
			{
				m_timeline.reverse(false);
			}
		}
		
		public override function resize():void
		{
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_sprite.x = (TG_World.GAME_WIDTH - m_sprite.width ) * 0.5;
			m_sprite.y = (TG_World.GAME_HEIGHT - m_sprite.height );
			refreshAnimation();
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			m_rockSprite.addEventListener(Event.TRIGGERED,onRockPressed);
			m_paperSprite.addEventListener(Event.TRIGGERED,onPaperPressed);
			m_scissorSprite.addEventListener(Event.TRIGGERED,onScissorPressed);
		}
		
		protected override function destroyListeners():void
		{
			super.destroyListeners();
			m_rockSprite.removeEventListener(Event.TRIGGERED,onRockPressed);
			m_paperSprite.removeEventListener(Event.TRIGGERED,onPaperPressed);
			m_scissorSprite.removeEventListener(Event.TRIGGERED,onScissorPressed);
		}
		
		private function onRockPressed(e:Event):void
		{
			m_gameState.doSomething("rockPressed");
		}
		private function onPaperPressed(e:Event):void
		{
			m_gameState.doSomething("paperPressed");
		}
		private function onScissorPressed(e:Event):void
		{
			m_gameState.doSomething("scissorPressed");
		}
	}
}