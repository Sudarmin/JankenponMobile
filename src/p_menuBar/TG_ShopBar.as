package p_menuBar
{
	import flash.geom.Rectangle;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import p_static.TG_Static;
	
	import starling.display.ButtonExtended;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class TG_ShopBar extends TG_MenuBar
	{
		private var m_title:TextField;
		private var m_desc:TextField;
		private var m_ribbon:Scale9Image;
		private var m_ribbonSprite:Sprite;
		private var m_bg:Scale9Image;
		
		private var m_bgQuad:Quad;
		private var m_descSprite:Sprite;
		
		private var m_picBoxes:Vector.<Sprite>;
		private var m_allPicBoxes:Sprite;
		private var m_buySprite:Sprite;
		private var m_nextSprite:Sprite;
		
		public static var shopItems:Array;
		public static var boughtItems:Array;
		
		public function TG_ShopBar(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			if(shopItems == null)
			{
				shopItems = [];
				boughtItems = [];
				var xml:XML = TG_World.assetManager.getXml("ShopItems");
				var i:int = 0;
				var size:int = xml.shopItem.length();
				var currXML:XML;
				for(i;i<size;i++)
				{
					currXML = xml.shopItem[i];
					var obj:Object = new Object();
					obj.id = currXML.id;
					var chosenString:String = "";
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						chosenString = currXML.nameEnglish;
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						chosenString = currXML.nameIndonesia;
					}
					obj.name = chosenString;
					
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						chosenString = currXML.descEnglish;
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						chosenString = currXML.descIndonesia;
					}
					obj.desc = chosenString;
					obj.imageName = currXML.imageName;
					obj.price = currXML.price;
					obj.priceMult = currXML.priceMult;
					obj.alwaysShow = currXML.alwaysShow;
					obj.value = currXML.value;
					obj.valueMult = currXML.valueMult;
					obj.maxValue = currXML.maxValue;
					shopItems.push(obj);
					shopItems[obj.id] = obj;
				}
			}
			
			super(parent, gameState);
		}
		
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			var rect:Rectangle;
			
			//CREATE BACKGROUND
			rect = new Rectangle(97.25,90,20,20);
			var bg:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGFrame"),rect);
			bg.width = 400;
			bg.height = 200;
			m_sprite.addChild(bg);
			m_bg = bg;
			
			//CREATE RIBBON
			var ribbonSprite:Sprite = new Sprite();
			rect = new Rectangle(126.5,16,5,5);
			var ribbon:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGRibbon"),rect);
			var title:TextField = new TextField(100,100,"BALD MARKET","Londrina",30,0xFFFF00);
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
			
			//CREATE PIC BOX
			m_picBoxes = new Vector.<Sprite>();
			m_allPicBoxes = new Sprite();
			var picBox:Sprite;
			
			
			var picImage:Image;
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			
			m_sprite.addChild(m_allPicBoxes);
			
			var i:int = 0;
			var size:int = m_picBoxes.length;
			for(i;i<size;i++)
			{
				if(i>0)
				{
					m_picBoxes[i].x = m_picBoxes[i-1].x + m_picBoxes[i-1].width + 10;
				}
				
			}
			
			m_allPicBoxes.x = (m_bg.width - m_allPicBoxes.width) * 0.5;
			m_allPicBoxes.y = 50;
			
			//CREATE DESC BG
			var descSprite:Sprite = new Sprite();
			
			var bgQuad:Quad = new Quad(bg.width - 100,100,0xBE8F41);
			bgQuad.alpha = 0.7;
			descSprite.addChild(bgQuad);
			var desc:TextField = new TextField(bgQuad.width - 10,100,"attack + 4","Londrina",20,0xFFFFFF);
			desc.touchable = false;
			desc.kerning = false;
			desc.autoSize = TextFieldAutoSize.VERTICAL;
			desc.hAlign = HAlign.CENTER;
			m_desc = desc;
			
			bgQuad.height = desc.height + 10;
			desc.x = (bgQuad.width - desc.width) * 0.5;
			desc.y = (bgQuad.height - desc.height) * 0.5;
			descSprite.addChild(desc);
			
			bg.height = bgQuad.height + 100;
			
			descSprite.x = (bg.width - descSprite.width) * 0.5;
			descSprite.y = m_allPicBoxes.y + m_allPicBoxes.height + 20;
			
			m_sprite.addChild(descSprite);
			m_descSprite = descSprite;
			m_bgQuad = bgQuad;
			
			//CREATE BUY BUTTON
			m_buySprite = new Sprite();
			rect = new Rectangle(17.5,13,3,3);
			var buyImage:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGButtonWood2"),rect);
			var buyText:TextField = new TextField(100,100,"BUY","Londrina",30,0xFFFF00);
			buyText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			buyText.hAlign = HAlign.CENTER;
			buyImage.width = buyText.width + 20;
			buyImage.height = buyText.height + 10;
			buyText.x = (buyImage.width - buyText.width) * 0.5;
			buyText.y = (buyImage.height - buyText.height) * 0.5;
			m_buySprite.addChild(buyImage);
			m_buySprite.addChild(buyText);
			
			m_buySprite.x = descSprite.x;
			m_buySprite.y = descSprite.y + descSprite.height + 10;
			
			m_sprite.addChild(m_buySprite);
			
			
			//CREATE NEXT BUTTON
			m_nextSprite = new Sprite();
			rect = new Rectangle(17.5,13,3,3);
			var nextImage:Scale9Image = new Scale9Image(TG_World.assetManager.getTexture("UI-BGButtonWood2"),rect);
			var nextText:TextField = new TextField(100,100,"NEXT","Londrina",30,0xFFFF00);
			nextText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			nextText.hAlign = HAlign.CENTER;
			nextImage.width = nextText.width + 20;
			nextImage.height = nextText.height + 10;
			nextText.x = (nextImage.width - nextText.width) * 0.5;
			nextText.y = (nextImage.height - nextText.height) * 0.5;
			m_nextSprite.addChild(nextImage);
			m_nextSprite.addChild(nextText);
			
			m_nextSprite.x = descSprite.x + (descSprite.width - m_nextSprite.width);
			m_nextSprite.y = descSprite.y + descSprite.height + 10;
			
			m_sprite.addChild(m_nextSprite);
			
			
			m_bg.height = m_buySprite.y + m_buySprite.height + 30;
		}
		
		public function getShopItems():void
		{
			
		}
		
		public override function resize():void
		{
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
		}
	}
}