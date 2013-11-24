package p_menuBar
{
	import com.greensock.TweenMax;
	
	import flash.geom.Rectangle;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.ButtonExtended;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class TG_Warning extends TG_MenuBar
	{
		private var m_bg:Scale9Image;
		private var m_textField:TextField;
		private var m_okButton:ButtonExtended;
		private var m_cancelButton:ButtonExtended;
		public function TG_Warning(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			super(parent, gameState);
		}
		
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			var rect:Rectangle;
			//CREATE BACKGROUND
			rect = new Rectangle(58,31,20,10);
			m_bg = new Scale9Image(TG_World.assetManager.getTexture("UI-BGPaperScroll"),rect);
			m_bg.width = 300;
			m_sprite.addChild(m_bg);
			
			//CREATE TEXT
			m_textField = new TextField(m_bg.width,100,"Do you want to open this?\nOR NOT","Londrina",20,0xDDDDDD);
			m_textField.hAlign = HAlign.CENTER;
			m_textField.autoSize = TextFieldAutoSize.VERTICAL;
			m_sprite.addChild(m_textField);
			
			//CREATE OK BUTTON
			m_okButton = new ButtonExtended(TG_World.assetManager.getTextures("buttonOK")[0],"",TG_World.assetManager.getTextures("buttonOK")[2],TG_World.assetManager.getTextures("buttonOK")[1]);
			m_sprite.addChild(m_okButton);
			
			//CREATE CANCEL BUTTON
			m_cancelButton = new ButtonExtended(TG_World.assetManager.getTextures("buttonX")[0],"",TG_World.assetManager.getTextures("buttonX")[2],TG_World.assetManager.getTextures("buttonX")[1]);
			m_sprite.addChild(m_cancelButton);
		
			resize();
		}
		
		public function get okButton():ButtonExtended
		{
			return m_okButton;
		}
		
		public function get cancelButton():ButtonExtended
		{
			return m_cancelButton;
		}
		public override function show():void
		{
			var middleX:Number = (TG_World.GAME_WIDTH - m_sprite.width) * 0.5;
			var middleY:Number = (TG_World.GAME_HEIGHT - m_sprite.height) * 0.5;
			middleY -= 80 * TG_World.SCALE_ROUNDED;
			if(middleY < 0)
			{
				middleY = 0;
			}
			
			TweenMax.fromTo(m_sprite,0.3,{x:middleX,y:-m_sprite.height,visible:true},{x:middleX,y:middleY});
		}
		
		public override function hide():void
		{
			TweenMax.to(m_sprite,0.3,{y:TG_World.GAME_HEIGHT,visible:false});
		}
		
		public function showCommand(cmd:String,cancelButtonVisible:Boolean = false):void
		{
			m_textField.text = cmd;
			resize();
			
			m_sprite.touchable = true;
			show();
		}
		
		public override function resize():void
		{
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			
			m_bg.height = m_textField.height + 40 * TG_World.SCALE_ROUNDED;
			m_bg.width = m_textField.width + 10 * TG_World.SCALE_ROUNDED;
			
			m_textField.x = (m_bg.width - m_textField.width) * 0.5;
			m_textField.y = 10 * TG_World.SCALE_ROUNDED;
			
			if(m_cancelButton.visible)
			{
				var halfWidth:Number = m_bg.width * 0.5;
				m_okButton.x = (halfWidth - m_okButton.width) * 0.5;
				m_okButton.y = m_bg.height - m_okButton.height;
				m_okButton.y -= 2 * TG_World.SCALE_ROUNDED;
				
				m_cancelButton.x = halfWidth + (halfWidth - m_cancelButton.width) * 0.5;
				m_cancelButton.y = m_bg.height - m_cancelButton.height;
				m_cancelButton.y -= 2 * TG_World.SCALE_ROUNDED;
			}
			else
			{
				m_okButton.x = (m_bg.width - m_okButton.width) * 0.5;
				m_okButton.y = m_bg.height - m_okButton.height;
				m_okButton.y -= 2 * TG_World.SCALE_ROUNDED;
			}
			
			
			if(m_sprite.visible)
			{
				var middleX:Number = (TG_World.GAME_WIDTH - m_sprite.width) * 0.5;
				var middleY:Number = (TG_World.GAME_HEIGHT - m_sprite.height) * 0.5;
				middleY -= 80 * TG_World.SCALE_ROUNDED;
				if(middleY < 0)
				{
					middleY = 0;
				}
				
				m_sprite.x = middleX;
				m_sprite.y = middleY;
			}
		}
	}
}