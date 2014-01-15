package p_menuBar
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	
	import flash.geom.Rectangle;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import p_entity.TG_Character;
	
	import p_static.TG_Static;
	
	import starling.display.ButtonExtended;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.Scale9Image;
	import starling.filters.ColorMatrixFilter;
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
		private var m_currShopItems:Array;
		private var m_maxItems:int = 4;
		
		private var m_currentChosen:int = 0;
		private var m_previousBox:Sprite;
		private var m_animation:TweenMax;
		
		private var m_filter:ColorMatrixFilter;
		private var m_char:TG_Character;
		public static var shopItems:Array;
		public static var boughtItems:Array;
		//public static var alreadyAtShopBar:Array;
		
		public function TG_ShopBar(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			if(shopItems == null)
			{
				shopItems = [];
				boughtItems = [];
				//alreadyAtShopBar = [];
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
					
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						chosenString = currXML.desc2English;
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						chosenString = currXML.desc2Indonesia;
					}
					obj.desc2 = chosenString;
					
					obj.imageName = currXML.imageName;
					obj.price = Number(currXML.price);
					obj.priceMult = Number(currXML.priceMult);
					obj.alwaysShow = int(currXML.alwaysShow);
					
					obj.value = Number(currXML.value);
					obj.valueMult = Number(currXML.valueMult);
					
					obj.value2 = Number(currXML.value2);
					obj.valueMult2 = Number(currXML.valueMult2);
					
					obj.boughtCounter = 0;
					obj.bought = false;
					shopItems.push(obj);
					shopItems[obj.id] = obj;
				}
			}
			
			super(parent, gameState);
			initFilter();
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
			picBox.pivotX = picBox.width * 0.5;
			picBox.pivotY = picBox.height * 0.5;
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			picBox.pivotX = picBox.width * 0.5;
			picBox.pivotY = picBox.height * 0.5;
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			picBox.pivotX = picBox.width * 0.5;
			picBox.pivotY = picBox.height * 0.5;
			
			picImage = new Image(TG_World.assetManager.getTexture("UI-BoxBag"));
			picImage.scaleX = picImage.scaleY = 0.75;
			picBox = new Sprite();
			picBox.addChild(picImage);
			m_allPicBoxes.addChild(picBox);
			m_picBoxes.push(picBox);
			picBox.pivotX = picBox.width * 0.5;
			picBox.pivotY = picBox.height * 0.5;
			
			m_sprite.addChild(m_allPicBoxes);
			
			var i:int = 0;
			var size:int = m_picBoxes.length;
			for(i;i<size;i++)
			{
				if(i>0)
				{
					m_picBoxes[i].x = m_picBoxes[i-1].x + (m_picBoxes[i-1].width * 0.5) + 10;
				}
				m_picBoxes[i].x += m_picBoxes[i].pivotX;
				m_picBoxes[i].y += m_picBoxes[i].pivotY;
			}
			
			m_allPicBoxes.x = (m_bg.width - m_allPicBoxes.width) * 0.5;
			m_allPicBoxes.y = 50;
			
			m_allPicBoxes.useHandCursor = true;
			
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
			m_buySprite.pivotX = m_buySprite.width * 0.5;
			m_buySprite.pivotY = m_buySprite.height * 0.5;
			
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
			
			m_nextSprite.pivotX = m_nextSprite.width * 0.5;
			m_nextSprite.pivotY = m_nextSprite.height * 0.5;
			
			m_nextSprite.x = descSprite.x + (descSprite.width - m_nextSprite.width);
			m_nextSprite.y = descSprite.y + descSprite.height + 10;
			
			m_sprite.addChild(m_nextSprite);
			
			m_nextSprite.useHandCursor = true;
			m_buySprite.useHandCursor = true;
			
			
			m_bg.height = m_buySprite.y + m_buySprite.height + 30;
			
		}
		
		public final function setChar(char:TG_Character):void
		{
			m_char = char;
		}
		private final function initFilter():void
		{
			m_filter = new ColorMatrixFilter();
			m_filter.adjustSaturation(-1);
		}
		private final function destroyFilter():void
		{
			if(m_filter)
			{
				m_filter.dispose();
			}
		}
		private final function reverseAnimation():void
		{
			m_animation.reverse(true);
		}
		private final function resumeAnimation():void
		{
			m_animation.play();
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			var i:int = 0;
			var size:int = m_picBoxes.length;
			var sprite:Sprite;
			for(i;i<size;i++)
			{
				sprite = m_picBoxes[i];
				sprite.addEventListener(TouchEvent.TOUCH,onPicTouched);
			}
			
			m_nextSprite.addEventListener(TouchEvent.TOUCH,onNextTouched);
			m_buySprite.addEventListener(TouchEvent.TOUCH,onBuyTouched);
		}
		
		protected override function destroyListeners():void
		{
			super.destroyListeners();
			
			var i:int = 0;
			var size:int = m_picBoxes.length;
			var sprite:Sprite;
			for(i;i<size;i++)
			{
				sprite = m_picBoxes[i];
				sprite.removeEventListener(TouchEvent.TOUCH,onPicTouched);
			}
			m_nextSprite.removeEventListener(TouchEvent.TOUCH,onNextTouched);
			m_buySprite.removeEventListener(TouchEvent.TOUCH,onBuyTouched);
		}
		
		private final function onNextTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var num:int = int(Sprite(e.currentTarget).name);
			
			if(touch)
			{
				var touchPhase:String = touch.phase;
				if(touchPhase == TouchPhase.HOVER)
				{
					m_nextSprite.scaleX = m_nextSprite.scaleY = 1.25;
				}
				else if(touchPhase == TouchPhase.BEGAN)
				{
					m_nextSprite.scaleX = m_nextSprite.scaleY = 1.1;
				}
				else
				{
					m_nextSprite.scaleX = m_nextSprite.scaleY = 1;
				}
			}
			if(!e.interactsWith(m_nextSprite))
			{
				m_nextSprite.scaleX = m_nextSprite.scaleY = 1;
			}
		}
		private final function onBuyTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var num:int = int(Sprite(e.currentTarget).name);
			if(touch)
			{
				var touchPhase:String = touch.phase;
				if(touchPhase == TouchPhase.HOVER)
				{
					m_buySprite.scaleX = m_buySprite.scaleY = 1.25;
				}
				else if(touchPhase == TouchPhase.BEGAN)
				{
					m_buySprite.scaleX = m_buySprite.scaleY = 1.1;
				}
				else
				{
					m_buySprite.scaleX = m_buySprite.scaleY = 1;
				}
			}
			
			if(!e.interactsWith(m_buySprite))
			{
				m_buySprite.scaleX = m_buySprite.scaleY = 1;
			}
		}
		private final function onPicTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var num:int = int(Sprite(e.currentTarget).name);
			if(touch)
			{
				var touchPhase:String = touch.phase;
				if(touchPhase == TouchPhase.BEGAN)
				{
					chooseOne(num);
				}
			}
			
		}
		
		public function removeMaxedItems():void
		{
			var i:int = shopItems.length-1;
			var obj:Object;
			for(i;i>=0;i--)
			{
				obj = shopItems[i];
				switch(""+obj.id)
				{
					
					case "critical":
						if(m_char.critChance >= m_char.critChanceMax && m_char.critValue >= m_char.critValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "poison":
						if(m_char.poisonChance >= m_char.poisonChanceMax && m_char.poisonValue >= m_char.poisonValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "heal":
						if(m_char.healChance >= m_char.healChanceMax && m_char.healValue >= m_char.healValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "evade":
						if(m_char.evadeChance >= m_char.evadeChanceMax )
						{
							shopItems.splice(i,1);
						}
						break;
					case "dmgReturn":
						if(m_char.dmgReturnChance >= m_char.dmgReturnChanceMax && m_char.dmgReturnValue >= m_char.dmgReturnValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "heal":
						if(m_char.healChance >= m_char.healChanceMax && m_char.healValue >= m_char.healValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "lifeSteal":
						if(m_char.lifestealValue >= m_char.lifestealValueMax)
						{
							shopItems.splice(i,1);
						}
					case "magic":
						if(m_char.magicChance >= m_char.magicChanceMax && m_char.magicValue >= m_char.magicValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "reversed":
						if(m_char.reverseChance >= m_char.reverseChanceMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "strengthen":
						if(m_char.strengthenChance >= m_char.strengthenChanceMax && m_char.strengthenValue >= m_char.strengthenValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					case "weaken":
						if(m_char.weakenChance >= m_char.weakenChanceMax && m_char.weakenValue <= m_char.weakenValueMax)
						{
							shopItems.splice(i,1);
						}
						break;
					default :
						break;
				}
			}
		}
		
		public function checkMaxValue(id:String,value1:Number,value2:Number):Object
		{
			var obj:Object = new Object();
			switch(id)
			{
				
				case "critical":
					if(m_char.critChance + value1 > m_char.critChanceMax)
					{
						obj.value1 = m_char.critChanceMax - m_char.critChance;
					}
					else
					{
						obj.value1 = value1;
					}
					
					if(m_char.critValue + value2 > m_char.critValueMax)
					{
						obj.value2 = m_char.critValueMax - m_char.critValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "poison":
					if(m_char.poisonChance + value1 > m_char.poisonChanceMax)
					{
						obj.value1 = m_char.poisonChanceMax - m_char.poisonChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.poisonValue + value2 > m_char.poisonValueMax)
					{
						obj.value2 = m_char.poisonValueMax - m_char.poisonValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "heal":
					if(m_char.healChance + value1 > m_char.healChanceMax)
					{
						obj.value1 = m_char.healChanceMax - m_char.healChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.healValue + value2 > m_char.healValueMax)
					{
						obj.value2 = m_char.healValueMax - m_char.healValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "evade":
					if(m_char.evadeChance + value1 > m_char.evadeChanceMax)
					{
						obj.value1 = m_char.evadeChanceMax - m_char.evadeChance;
					}
					else
					{
						obj.value1 = value1;
					}
					break;
				case "dmgReturn":
					if(m_char.dmgReturnChance + value1 > m_char.dmgReturnChanceMax)
					{
						obj.value1 = m_char.dmgReturnChanceMax - m_char.dmgReturnChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.dmgReturnValue + value2 > m_char.dmgReturnValueMax)
					{
						obj.value2 = m_char.dmgReturnValueMax - m_char.dmgReturnValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "heal":
					if(m_char.healChance + value1 > m_char.healChanceMax)
					{
						obj.value1 = m_char.healChanceMax - m_char.healChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.healValue + value2 > m_char.healValueMax)
					{
						obj.value2 = m_char.healValueMax - m_char.healValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "lifeSteal":
					if(m_char.lifestealValue + value1 > m_char.lifestealValueMax)
					{
						obj.value1 = m_char.lifestealValueMax - m_char.lifestealValue;
					}
					else
					{
						obj.value1 = value1;
					}
				case "magic":
					if(m_char.magicChance + value1 > m_char.magicChanceMax)
					{
						obj.value1 = m_char.magicChanceMax - m_char.magicChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.magicValue + value2 > m_char.magicValueMax)
					{
						obj.value2 = m_char.magicValueMax - m_char.magicValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "reversed":
					if(m_char.reverseChance + value1 > m_char.reverseChanceMax)
					{
						obj.value1 = m_char.reverseChanceMax - m_char.reverseChance;
					}
					else
					{
						obj.value1 = value1;
					}
					break;
				case "strengthen":
					if(m_char.strengthenChance + value1 > m_char.strengthenChanceMax)
					{
						obj.value1 = m_char.strengthenChanceMax - m_char.strengthenChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.strengthenValue + value2 > m_char.strengthenValue)
					{
						obj.value2 = m_char.strengthenValueMax - m_char.strengthenValue;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				case "weaken":
					if(m_char.weakenChance + value1 > m_char.weakenChanceMax)
					{
						obj.value1 = m_char.weakenChanceMax - m_char.weakenChance;
					}
					else
					{
						obj.value1 = value1;
					}
					if(m_char.weakenValue - value2 < m_char.weakenValueMax)
					{
						obj.value2 = m_char.weakenValue - m_char.weakenValueMax;
					}
					else
					{
						obj.value2 = value2;
					}
					break;
				default :
					obj.value1 = value1;
					obj.value2 = value2;
					break;
			}
			
			return obj;
		}
		
		public function initShopItems():void
		{
			if(m_currShopItems == null)
			{
				m_currShopItems = [];
			}
			
			var rand:int = 0;
			var obj:Object;
			
			//PUT UNBOUGHT ITEMS TO SHOP ITEMS
			while(m_currShopItems.length > 0)
			{
				obj = m_currShopItems.pop();
				if(!obj.bought)
				{
					shopItems.push(obj);
					shopItems[obj.id] = obj;
				}
			}
			//IF ALL SHOP ITEMS HAVE BEEN BOUGHT
			while(shopItems.length < m_maxItems && boughtItems.length > 0)
			{
				rand = (Math.random() * 10000) % boughtItems.length;
				obj = boughtItems[rand];
				shopItems.push(obj);
				shopItems[obj.id] = obj;
				
				boughtItems.splice(rand,1);
			}
			removeMaxedItems();
			
			//GET CURRENT SHOP ITEMS FROM SHOP ITEMS
			while(m_currShopItems.length < m_maxItems && shopItems.length > 0)
			{
				rand = (Math.random() * 10000) % shopItems.length;
				obj = shopItems[rand];
				//alreadyAtShopBar.push(obj);
				shopItems.splice(rand,1);
				
				m_currShopItems.push(obj);
				
				obj.bought = false;
			}
			
			var counter:int = 0;
			var sprite:Sprite;
			
			while(counter < m_picBoxes.length)
			{
				sprite = m_picBoxes[counter];
				sprite.scaleX = sprite.scaleY = 1;
				sprite.filter = null;
				sprite.removeFromParent();
				counter++;
			}
			
			counter = 0;
			while(counter < m_currShopItems.length)
			{
				sprite = m_picBoxes[counter];
				sprite.filter = null;
				
				var image:Image = sprite.getChildByName("image") as Image;
				if(image)image.parent.removeChild(image);
				
				obj = m_currShopItems[counter];
				image = new Image(TG_World.assetManager.getTexture(obj.imageName));
				image.x = (sprite.width - image.width) * 0.5;
				image.y = (sprite.height - image.height) * 0.5;
				
				sprite.addChild(image);
				sprite.name = ""+counter;
				image.name = "image";
				counter++;
				
				m_allPicBoxes.addChild(sprite);
			}
			m_allPicBoxes.x = (m_bg.width - m_allPicBoxes.width) * 0.5;
			m_allPicBoxes.y = 50;
			
			chooseOne(0);
		}
		
		public function doneBuyingItems():void
		{
			
		}
		
		public function chooseOne(num:int):void
		{
			if(m_animation)
			{
				m_animation.kill();
			}
			if(m_previousBox)
			{
				m_previousBox.scaleX = m_previousBox.scaleY = 1;
			}
			m_currentChosen = num;
			m_previousBox = m_picBoxes[num];
			
			if(!m_currShopItems[m_currentChosen].bought)
			{
				m_animation = new TweenMax(m_picBoxes[num],0.3,{scaleX:1.25,scaleY:1.25,onComplete:reverseAnimation,onReverseComplete:resumeAnimation});
				m_buySprite.visible = true;
			}
			else
			{
				m_buySprite.visible = false;
			}
			
			
			var str:String = showDesc(m_currShopItems[m_currentChosen]);
			m_desc.text = str;
		
			resize();
		}
		
		
		
		private function showDesc(obj:Object):String
		{
			var str:String = "";
			str = obj.name+"\n";
			if(obj.id == "healRegen")
			{
				str += obj.desc+"\n";
			}
			else
			{
				var value:Number = obj.value + (obj.value * obj.valueMult * obj.boughtCounter);
				value = int(value * 100)/100;
				
				if(obj.value2 > 0)
				{
					var value2:Number = obj.value2 + (obj.value2 * obj.valueMult2 * obj.boughtCounter);
					value2 = int(value2 * 100)/100;
				}
				
				var newObj:Object = checkMaxValue(obj.id,value,value2);
				value = int(newObj.value1 * 100)/100;
				str += obj.desc +" "+value+"\n";
				if(obj.value2 > 0)
				{
					value2 = int(newObj.value2 * 100)/100;
					str += obj.desc2 +" "+value2+"\n";
				}
				
			}
			
			var price:Number = obj.price + (obj.price * obj.priceMult * obj.boughtCounter);
			str += "Price : "+price;
			obj.currPrice = price;
			return str;
		}
		
		public override function destroy():void
		{
			super.destroy();
			destroyFilter();
			if(m_animation)
			{
				m_animation.kill();
			}
			shopItems = null;
		}
		
		public function getShopItems():Array
		{
			return m_currShopItems;
		}
		
		public override function resize():void
		{
			m_bgQuad.height = m_desc.height + 10;
			m_desc.x = (m_bgQuad.width - m_desc.width) * 0.5;
			m_desc.y = (m_bgQuad.height - m_desc.height) * 0.5;
			
			m_descSprite.x = (m_bg.width - m_descSprite.width) * 0.5;
			m_descSprite.y = m_allPicBoxes.y + m_allPicBoxes.height + 20;
			
			m_buySprite.x = m_descSprite.x;
			m_buySprite.y = m_descSprite.y +m_descSprite.height + 10;
			m_buySprite.x += m_buySprite.pivotX;
			m_buySprite.y += m_buySprite.pivotY;
			
			m_nextSprite.x = m_descSprite.x + (m_descSprite.width - m_nextSprite.width);
			m_nextSprite.y = m_descSprite.y + m_descSprite.height + 10;
			m_nextSprite.x += m_nextSprite.pivotX;
			m_nextSprite.y += m_nextSprite.pivotY;
			
			m_bg.height = m_buySprite.y + m_buySprite.height + 20;
			
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
		}
		
		public function getNextButton():Sprite
		{
			return m_nextSprite;
		}
		
		public function getBuyButton():Sprite
		{
			return m_buySprite;
		}
		
		public function buyCurrentItem():Object
		{
			var obj:Object;
			var usedObj:Object;
			usedObj = m_currShopItems[m_currentChosen];
			obj = usedObj;
			if(!obj.bought && m_char.points >= obj.currPrice)
			{
				m_char.points -= obj.currPrice;
				m_picBoxes[m_currentChosen].filter = m_filter;
				obj.bought = true;
				obj.boughtCounter++;
				m_buySprite.visible = false;
				if(m_animation)
				{
					m_animation.kill();
				}
				if(m_picBoxes[m_currentChosen])
				{
					m_picBoxes[m_currentChosen].scaleX = m_picBoxes[m_currentChosen].scaleY = 1;
				}
				
				boughtItems.push(obj);
				
				var counter:int = 0;
				var currChosen:int = m_currentChosen;
				while(counter < m_currShopItems.length && obj.bought)
				{
					currChosen++;
					if(currChosen >= m_currShopItems.length)
					{
						currChosen = 0;
					}
					obj = m_currShopItems[currChosen];
					counter++;
				}
				
				chooseOne(currChosen);
				return usedObj;
			}
			return null;
		}
		
		public function addBonusToUser(obj:Object):void
		{
			switch(""+obj.id)
			{
				
				case "healRegen":
					m_char.health = m_char.initialHealth;
					break;
				case "health":
					m_char.healthBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.healthBonus = int(m_char.healthBonus);
					m_char.recalculateStats();
					break;
				case "damage":
					m_char.damageBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.damageBonus = int(m_char.damageBonus);
					m_char.recalculateStats();
					break;
				case "critical":
					m_char.criticalChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.criticalChanceBonus = (int(m_char.criticalChanceBonus * 100) / 100);
					if(m_char.criticalChanceBonus >= obj.maxValue)
					{
						m_char.criticalChanceBonus = obj.maxValue; 
					}
					
					m_char.criticalValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.criticalValueBonus = (int(m_char.criticalValueBonus * 100) / 100);
					if(m_char.criticalValueBonus >= obj.maxValue2)
					{
						m_char.criticalValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "poison":
					m_char.poisonChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.poisonChanceBonus = (int(m_char.poisonChanceBonus * 100) / 100);
					if(m_char.poisonChanceBonus >= obj.maxValue)
					{
						m_char.poisonChanceBonus = obj.maxValue; 
					}
					
					m_char.poisonValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.poisonValueBonus = int(m_char.poisonValueBonus);
					if(m_char.poisonValueBonus >= obj.maxValue2)
					{
						m_char.poisonValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "heal":
					m_char.healChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.healChanceBonus = (int(m_char.healChanceBonus * 100) / 100);
					if(m_char.healChanceBonus >= obj.maxValue)
					{
						m_char.healChanceBonus = obj.maxValue; 
					}
					
					m_char.healValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.healValueBonus = int(m_char.healValueBonus);
					if(m_char.healValueBonus >= obj.maxValue2)
					{
						m_char.healValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "evade":
					m_char.evadeChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.evadeChanceBonus = (int(m_char.evadeChanceBonus * 100) / 100);
					if(m_char.evadeChanceBonus >= obj.maxValue)
					{
						m_char.evadeChanceBonus = obj.maxValue; 
					}
					
					m_char.recalculateStats();
					break;
				case "dmgReturn":
					m_char.dmgReturnChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.dmgReturnChanceBonus = (int(m_char.dmgReturnChanceBonus * 100) / 100);
					if(m_char.dmgReturnChanceBonus >= obj.maxValue)
					{
						m_char.dmgReturnChanceBonus = obj.maxValue; 
					}
					
					m_char.dmgReturnValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.dmgReturnValueBonus = int(m_char.dmgReturnValueBonus);
					if(m_char.dmgReturnValueBonus >= obj.maxValue2)
					{
						m_char.dmgReturnValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "heal":
					m_char.healChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.healChanceBonus = (int(m_char.healChanceBonus * 100) / 100);
					if(m_char.healChanceBonus >= obj.maxValue)
					{
						m_char.healChanceBonus = obj.maxValue; 
					}
					
					m_char.healValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.healValueBonus = int(m_char.healValueBonus);
					if(m_char.healValueBonus >= obj.maxValue2)
					{
						m_char.healValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "lifeSteal":
					m_char.lifestealValueBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.lifestealValueBonus = (int(m_char.lifestealValueBonus * 100) / 100);
					if(m_char.lifestealValueBonus >= obj.maxValue)
					{
						m_char.lifestealValueBonus = obj.maxValue; 
					}
					
					m_char.recalculateStats();
					break;
				case "magic":
					m_char.magicChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.magicChanceBonus = (int(m_char.magicChanceBonus * 100) / 100);
					if(m_char.magicChanceBonus >= obj.maxValue)
					{
						m_char.magicChanceBonus = obj.maxValue; 
					}
					
					m_char.magicValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.magicValueBonus = int(m_char.magicValueBonus);
					if(m_char.magicValueBonus >= obj.maxValue2)
					{
						m_char.magicValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "reversed":
					m_char.reverseChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.reverseChanceBonus = (int(m_char.reverseChanceBonus * 100) / 100);
					if(m_char.reverseChanceBonus >= obj.maxValue)
					{
						m_char.reverseChanceBonus = obj.maxValue; 
					}
					
					m_char.recalculateStats();
					break;
				case "strengthen":
					m_char.strengthenChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.strengthenChanceBonus = (int(m_char.strengthenChanceBonus * 100) / 100);
					if(m_char.strengthenChanceBonus >= obj.maxValue)
					{
						m_char.strengthenChanceBonus = obj.maxValue; 
					}
					
					m_char.strengthenValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.strengthenValueBonus = (int(m_char.strengthenValueBonus * 100) / 100);
					if(m_char.strengthenValueBonus >= obj.maxValue2)
					{
						m_char.strengthenValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				case "weaken":
					m_char.weakenChanceBonus += obj.value + (obj.valueMult * obj.boughtCounter * obj.value);
					m_char.weakenChanceBonus = (int(m_char.weakenChanceBonus * 100) / 100);
					if(m_char.weakenChanceBonus >= obj.maxValue)
					{
						m_char.weakenChanceBonus = obj.maxValue; 
					}
					
					m_char.weakenValueBonus += obj.value2 + (obj.valueMult2 * obj.boughtCounter * obj.value2);
					m_char.weakenValueBonus = (int(m_char.weakenValueBonus * 100) / 100);
					if(m_char.weakenValueBonus >= obj.maxValue2)
					{
						m_char.weakenValueBonus = obj.maxValue2; 
					}
					
					m_char.recalculateStats();
					break;
				default :
					break;
			}
		}
	}
}