package p_menuBar
{
	import flash.geom.Rectangle;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.Button;
	import starling.display.ButtonExtended;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class TG_StatusInfoBar extends TG_MenuBar
	{
		private var m_title:TextField;
		private var m_desc:TextField;
		private var m_ribbon:Scale9Image;
		private var m_ribbonSprite:Sprite;
		private var m_bg:Scale9Image;
		
		private var m_bgQuad:Quad;
		private var m_descSprite:Sprite;
		private var m_nextSprite:Sprite;
		private var m_nextButton:ButtonExtended;
		public function TG_StatusInfoBar(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			super(parent, gameState);
		}
		
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			var rect:Rectangle;
			
			//CREATE BACKGROUND
			rect = new Rectangle(97.25,90,20,20);
			var bg:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGFrame"),rect);
			bg.width = 300;
			bg.height = 200;
			m_sprite.addChild(bg);
			m_bg = bg;
			
			//CREATE RIBBON
			var ribbonSprite:Sprite = new Sprite();
			rect = new Rectangle(126.5,16,5,5);
			var ribbon:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGRibbon"),rect);
			var title:TextField = new TextField(100,100,"COBACOBACOBA","Londrina",30,0xFFFF00);
			title.touchable = false;
			title.kerning = false;
			title.autoSize = TextFieldAutoSize.HORIZONTAL;
			title.hAlign = HAlign.CENTER;
			m_title = title;
			ribbon.width = title.width + 50;
			title.x = (ribbon.width - title.width) * 0.5;
			title.y = (ribbon.height - title.height) * 0.5;
			title.y -= 5;
			ribbonSprite.addChild(ribbon);
			ribbonSprite.addChild(title);
			ribbonSprite.y = -10;
			ribbonSprite.x = (bg.width - ribbonSprite.width) * 0.5;
			m_sprite.addChild(ribbonSprite);
			m_ribbon = ribbon;
			m_ribbonSprite = ribbonSprite;
			
			//CREATE DESC BG
			var descSprite:Sprite = new Sprite();
			
			var bgQuad:Quad = new Quad(bg.width - 100,100,0xBE8F41);
			bgQuad.alpha = 0.7;
			descSprite.addChild(bgQuad);
			var desc:TextField = new TextField(bgQuad.width - 10,100,"attack\nhealth\nsada\nasdad\nasdfad\nsafas\nasrda\nsadfa","Londrina",20,0xFFFFFF);
			desc.touchable = false;
			desc.kerning = false;
			desc.autoSize = TextFieldAutoSize.VERTICAL;
			desc.hAlign = HAlign.LEFT;
			m_desc = desc;
			
			bgQuad.height = desc.height + 10;
			desc.x = (bgQuad.width - desc.width) * 0.5;
			desc.y = (bgQuad.height - desc.height) * 0.5;
			descSprite.addChild(desc);
			
			bg.height = bgQuad.height + 100;
			
			descSprite.x = (bg.width - descSprite.width) * 0.5;
			descSprite.y = (bg.height - descSprite.height) * 0.5;
			descSprite.y -= 10;
			
			m_sprite.addChild(descSprite);
			m_descSprite = descSprite;
			m_bgQuad = bgQuad;
			
			//CREATE BUTTON NEXT
			var nextSprite:Sprite = new Sprite();
			var label:TextField = new TextField(50,50,"NEXT","Londrina",30,0xFFFF00);
			label.autoSize = TextFieldAutoSize.HORIZONTAL;
			nextSprite.addChild(label);
			var nextButton:ButtonExtended = new ButtonExtended(TG_World.assetManager.getTextures("buttonNext")[0],"",TG_World.assetManager.getTextures("buttonNext")[2],TG_World.assetManager.getTextures("buttonNext")[1]);
			nextButton.scaleX = nextButton.scaleY = 1.5;
			nextButton.x = label.width + 5;
			nextButton.y = (label.height - nextButton.height) * 0.5;
			nextSprite.addChild(nextButton);
			
			nextSprite.y = bg.height - nextSprite.height;
			nextSprite.y -= 10;
			nextSprite.x = (bg.width - nextSprite.width) * 0.5;
			m_sprite.addChild(nextSprite);
			m_nextSprite = nextSprite;
			m_nextButton = nextButton;
			
			resize();
		}
		
		public override function resize():void
		{
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
		}
		
		public function changeTexts(title:String,descs:Array):void
		{
			m_title.text = title;
			m_desc.text = "";
			
			var i:int = 0;
			var size:int = 0;
			
			m_descSprite.removeChildren(0,-1,true);
			
			i = 0;
			size = descs["desc"].length;
			var textFields:Array = [];
			for(i;i<size;i++)
			{
				var textField:TextField = new TextField(50,50,descs["desc"][i],"Londrina",20,0xFFFFFF);
				//textField.border = true;
				textField.touchable = false;
				textField.kerning = false;
				textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				textField.hAlign = HAlign.LEFT;
				textFields.push(textField);
				
				if(i>0)
				{
					textField.y = textFields[i-1].y + textFields[i-1].height + 2;
				}
				var textField2:TextField;
				var image:Image;
				if(descs["diff"][i] == -1 || descs["diff"][i] == -100) 
				{
					textField2 = new TextField(50,50,"New","Londrina",20,0x00CCCC);
					
					//textField2.border = true;
					textField2.touchable = false;
					textField2.kerning = false;
					textField2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					textField2.hAlign = HAlign.LEFT;
					
					textField2.x = textField.x + textField.width + 5;
					textField2.y = textField.y;
					
					textField.color = 0x00CCCC;
				}
				else if(descs["diff"][i] != 0)
				{
					var tempValue:Number = descs["diff"][i];
					tempValue = int(tempValue * 100) / 100;
					textField2 = new TextField(50,50,""+tempValue,"Londrina",20,0x00CCCC);
					
					//textField2.border = true;
					textField2.touchable = false;
					textField2.kerning = false;
					textField2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					textField2.hAlign = HAlign.LEFT;
				
					image = new Image(TG_World.assetManager.getTexture("ArrowIncrease"));
					image.x = textField.x + textField.width + 5;
					image.y = textField.y + 5;
					image.color = 0x0000AA;
					
					textField2.y = textField.y;
					textField2.x = image.x + image.width + 5;
				}
				
				m_descSprite.addChild(textField);
				if(textField2)
				{
					m_descSprite.addChild(textField2);
				}
				if(image)
				{
					m_descSprite.addChild(image);
				}
				
			}
			
			m_ribbon.width = m_title.width + 50;
			m_title.x = (m_ribbon.width - m_title.width) * 0.5;
			m_title.y = (m_ribbon.height - m_title.height) * 0.5;
			m_title.y -= 5;
			
			
			
			
			i = 0;
			size = textFields.length;
			for(i;i<size;i++)
			{
				//textFields[i].x = (m_bgQuad.width - textFields[i].width) * 0.5;
				//textFields[i].y = (m_bgQuad.height - textFields[i].height) * 0.5;
			}
			
			m_bgQuad.height = m_descSprite.height + 10;
			
			m_bg.height = m_bgQuad.height + 120;
			
			m_descSprite.x = (m_bg.width - m_descSprite.width) * 0.5;
			m_descSprite.y = (m_bg.height - m_descSprite.height) * 0.5;
			m_descSprite.y -= 15;
			
			m_nextSprite.y = m_bg.height - m_nextSprite.height;
			m_nextSprite.y -= 15;
			m_nextSprite.x = (m_bg.width - m_nextSprite.width) * 0.5;
			
			m_ribbonSprite.y = -10;
			m_ribbonSprite.x = (m_bg.width - m_ribbonSprite.width) * 0.5;
			
		}
		public function changeText(title:String,desc:String):void
		{
			m_title.text = title;
			m_desc.text = desc;
			
			m_ribbon.width = m_title.width + 50;
			m_title.x = (m_ribbon.width - m_title.width) * 0.5;
			m_title.y = (m_ribbon.height - m_title.height) * 0.5;
			m_title.y -= 5;
			
			
			m_bgQuad.height = m_desc.height + 10;
			m_desc.x = (m_bgQuad.width - m_desc.width) * 0.5;
			m_desc.y = (m_bgQuad.height - m_desc.height) * 0.5;
			m_descSprite.addChild(m_desc);
			
			m_bg.height = m_bgQuad.height + 120;
			
			m_descSprite.x = (m_bg.width - m_descSprite.width) * 0.5;
			m_descSprite.y = (m_bg.height - m_descSprite.height) * 0.5;
			m_descSprite.y -= 15;
			
			m_nextSprite.y = m_bg.height - m_nextSprite.height;
			m_nextSprite.y -= 15;
			m_nextSprite.x = (m_bg.width - m_nextSprite.width) * 0.5;
			
			m_ribbonSprite.y = -10;
			m_ribbonSprite.x = (m_bg.width - m_ribbonSprite.width) * 0.5;
		}
		
		public function get nextButton():ButtonExtended
		{
			return m_nextButton;
		}
		public function get nextLabel():Sprite
		{
			return m_nextSprite;
		}
	}
}