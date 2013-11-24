package p_gameState
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_input.KeyPoll;
	import p_engine.p_singleton.TG_AssetsLoader;
	import p_engine.p_singleton.TG_GameManager;
	import p_engine.p_singleton.TG_LoaderMax;
	import p_engine.p_singleton.TG_World;
	
	import p_gameState.p_inGameState.TG_LuckyBoutState;
	import p_gameState.p_inGameState.TG_SinglePlayerState;
	import p_gameState.p_inGameState.TG_VersusState;
	
	import p_menuBar.TG_LanguageRollOption;
	import p_menuBar.TG_RollOption;
	
	import p_static.TG_Static;
	
	import starling.display.ButtonExtended;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	
	
	public class TG_StartMenuState extends TG_GameState
	{
		private var background:Scale9Image;
		private var sunBurst:Image;
		private var topFrame:Scale9Image;
		private var botFrame:Scale9Image;
		private var title:Image;
		private var shield:Image;
		private var human:Image;
		private var boar:Image;
		private var startButton:ButtonExtended;
		private var creditButton:Sprite;
		private var optionButton:Sprite;
		
		private var atlasMainMenu:TextureAtlas;
		private var textureMainMenu:Texture;
		private var bitmap:Bitmap;
		
		
		private var m_rollOption:TG_RollOption;
		private var m_languageOption:TG_LanguageRollOption;
		private var options:Array;
		private var languageOptions:Array;
		
		
		public function TG_StartMenuState(parent:DisplayObjectContainer)
		{
			super(parent);
		}
		
		//STEP BY STEP IMPLEMENTATION
		
		//STEP 1 DEFINE EMBEDDED PNG AND XML FOR WEB PURPOSE
		CONFIG::WEB
		{
			[Embed(source="/assets/textureAtlas/mainMenu.png")]
			public static const mainMenu:Class;
			
			[Embed(source="/assets/textureAtlas/mainMenu.xml",mimeType="application/octet-stream")]
			public static const mainMenuXML:Class;
		}
		
		//STEP 2 DESCRIBE ASSETS TO LOAD DYNAMICALLY FOR MOBILE PURPOSE
		protected override function describeAssets():void
		{
			CONFIG::MOBILE
			{
				m_assetsToLoad = [];
				var obj:Object;
				
				obj = new Object();
				obj.url = "assets/textureAtlas/mainMenu.png";
				obj.itemName = "UIMainMenuPNG";
				obj.type = TG_AssetsLoader.IMAGE;
				obj.kbTotal = 516;
				m_assetsToLoad.push(obj);
				
				obj = new Object();
				obj.url = "assets/textureAtlas/mainMenu.xml";
				obj.itemName = "UIMainMenuXML";
				obj.type = TG_AssetsLoader.XML;
				obj.kbTotal = 2.34;
				m_assetsToLoad.push(obj);
			}
		}
		
		//STEP 3 INIT TEXTURE ATLASES
		protected override function initTextureAtlas():void
		{
			super.initTextureAtlas();
			var xml:XML;
			CONFIG::WEB
			{
				bitmap = new mainMenu();
				textureMainMenu = Texture.fromBitmap(bitmap);
				xml = XML(new mainMenuXML());
				atlasMainMenu = new TextureAtlas(textureMainMenu,xml);
				
				//DONT FORGET TO PUT RESTORE FUNCTION
				textureMainMenu.root.onRestore = function():void
				{
					// restore the texture from its original source
					textureMainMenu.root.uploadBitmap(bitmap);
				}
			}
			
			
			CONFIG::MOBILE
			{
				bitmap = TG_LoaderMax.getInstance().getLoader("UIMainMenuPNG").rawContent;
				textureMainMenu = createTexture(bitmap);
				xml = TG_LoaderMax.getInstance().getLoader("UIMainMenuXML").content;
				atlasMainMenu = new TextureAtlas(textureMainMenu,xml);
				
				//IF IT'S ON APPLE DISPOSE THE BITMAP, BECAUSE WE DONT NEED IT
				if(TG_World.os == "ios")
				{
					bitmap.bitmapData.dispose();
					bitmap = null;
				}
				//DONT FORGET TO PUT RESTORE FUNCTION ON ANDROID
				if(TG_World.os == "android")
				{
					textureMainMenu.root.onRestore = function():void
					{
						// restore the texture from its original source
						textureMainMenu.root.uploadBitmap(bitmap);
					}
				}
				
			}
		}
		
		//STEP 4 CREATE DESTROY TEXTURE ATLAS FUNCTION
		protected override function destroyTextureAtlas():void
		{
			super.destroyTextureAtlas();
			textureMainMenu.dispose();
			atlasMainMenu.dispose();
			if(bitmap && bitmap.bitmapData)
			{
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
		}
		//STEP 5 INIT SPRITE
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			
			//Rectangle for 9 Scaling
			var rect:Rectangle;
			
			//9ScaleImage
			var image9Scale:Scale9Image;
			
			//image
			var image:Image;
			
			//sprite
			var bigContainerSprite:Sprite;
			var containerSprite:Sprite;
			var sprite:Sprite;
			
			//button
			var button:ButtonExtended;
			
			//TextField
			var textField:TextField;
			
			//Create Background
			rect = new Rectangle();
			rect.x = 160;
			rect.y = 100;
			rect.width = 160;
			rect.height = 100;
			image9Scale = new Scale9Image(atlasMainMenu.getTexture("UI-BackgroundBlue"),rect);
			image9Scale.width = TG_World.GAME_WIDTH;
			image9Scale.height = TG_World.GAME_HEIGHT;
			image9Scale.touchable = false;
			background = image9Scale;
			m_sprite.addChild(image9Scale);
			
			//Create Sunburst
			image = new Image(atlasMainMenu.getTexture("img-sunburst"));
			image.scaleX = image.scaleY = TG_World.SCALE_ROUNDED;
			image.x = (TG_World.GAME_WIDTH - image.width) * 0.5;
			image.y = (TG_World.GAME_HEIGHT - image.height) * 0.5;
			image.touchable = false;
			sunBurst = image;
			m_sprite.addChild(image);
			
			//Create Wood Frame Top
			rect = new Rectangle();
			rect.x = 119.1;
			rect.y = 8.05;
			rect.width = 240.3;
			rect.height = 17.75;
			
			image9Scale = new Scale9Image(atlasMainMenu.getTexture("UI-TopLine"),rect);
			image9Scale.width = TG_World.GAME_WIDTH;
			image9Scale.height = 35;
			image9Scale.x = 0;
			image9Scale.y = 0;
			image9Scale.touchable = false;
			topFrame = image9Scale;
			m_sprite.addChild(image9Scale);
			
			//Create Wood Frame Bottom
			rect = new Rectangle();
			rect.x = 119.1;
			rect.y = 8.05;
			rect.width = 240.3;
			rect.height = 17.75;
			
			image9Scale = new Scale9Image(atlasMainMenu.getTexture("UI-TopLine"),rect);
			image9Scale.width = TG_World.GAME_WIDTH;
			image9Scale.height = 72.2;
			image9Scale.x = TG_World.GAME_WIDTH;
			image9Scale.y = TG_World.GAME_HEIGHT;
			image9Scale.touchable = false;
			image9Scale.rotation = deg2rad(180);
			botFrame = image9Scale;
			m_sprite.addChild(image9Scale);
			
			//Title
			image = new Image(atlasMainMenu.getTexture("UI-Title"));
			image.scaleX = image.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			image.x = (TG_World.GAME_WIDTH - image.width) * 0.5;
			image.y = (TG_World.GAME_HEIGHT - image.height) * 0.5;
			image.y-= 100 * TG_World.SCALE_ROUNDED;
			title = image;
			m_sprite.addChild(image);
			
			//Shield
			image = new Image(atlasMainMenu.getTexture("LogoShield"));
			image.scaleX = image.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			image.x = (TG_World.GAME_WIDTH - image.width) * 0.5;
			image.y = title.y + title.height + 5;
			shield = image;
			m_sprite.addChild(image);
			
			//Human
			image = new Image(atlasMainMenu.getTexture("UI-CharHero"));
			image.scaleX = image.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			image.x = -60;
			image.y = ((TG_World.GAME_HEIGHT - image.height) * 0.5) + 100;
			human = image;
			m_sprite.addChild(image);
			
			//Boar
			image = new Image(atlasMainMenu.getTexture("UI-CharBoar"));
			image.scaleX = image.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			image.x = (TG_World.GAME_WIDTH - image.width) + 150;
			image.y = ((TG_World.GAME_HEIGHT - image.height) * 0.5) + 130;
			boar = image;
			m_sprite.addChild(image);
			
			//Start Button
			button = new ButtonExtended(atlasMainMenu.getTextures("ButtonStart")[0],"",atlasMainMenu.getTextures("ButtonStart")[2],atlasMainMenu.getTextures("ButtonStart")[1]);
			button.scaleX = button.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			button.x = (TG_World.GAME_WIDTH - button.width) * 0.5;
			button.y = shield.y + shield.height + 5;
			startButton = button;
			//m_sprite.addChild(button);
			
			//Credit Button
			creditButton = new Sprite();
			
			textField = new TextField(128,40,"Credits","Londrina",30,0xFFFFCC);
			textField.x = 0;
			textField.y = 94;
			textField.touchable = false;
			
			button = new ButtonExtended(atlasMainMenu.getTextures("ButtonCredits")[0],"",atlasMainMenu.getTextures("ButtonCredits")[2],atlasMainMenu.getTextures("ButtonCredits")[1]);
			creditButton.addChild(button);
			creditButton.addChild(textField);
			
			creditButton.scaleX = creditButton.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			creditButton.x = (TG_World.GAME_WIDTH - creditButton.width) * 0.5;
			creditButton.y = (TG_World.GAME_HEIGHT - creditButton.height);
			
			//m_sprite.addChild(creditButton);
			
			//Option Button
			optionButton = new Sprite();
			
			textField = new TextField(128,40,"Options","Londrina",30,0xFFFFCC);
			textField.x = 0;
			textField.y = 94;
			textField.touchable = false;
			
			button = new ButtonExtended(atlasMainMenu.getTextures("ButtonOptions")[0],"",atlasMainMenu.getTextures("ButtonOptions")[2],atlasMainMenu.getTextures("ButtonOptions")[1]);
			optionButton.addChild(button);
			optionButton.addChild(textField);
			
			optionButton.scaleX = optionButton.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			optionButton.x = (TG_World.GAME_WIDTH - button.width) * 0.5;
			optionButton.y = (TG_World.GAME_HEIGHT - button.height);
			//m_sprite.addChild(optionButton);
		}
		
		//STEP 6 CREATE RESIZE FUNCTION
		public override function resize():void
		{
			super.resize();
			//Background
			background.width = TG_World.GAME_WIDTH;
			background.height = TG_World.GAME_HEIGHT;
			
			//Sunburst
			sunBurst.scaleX = sunBurst.scaleY = TG_World.SCALE_ROUNDED;
			sunBurst.x = (TG_World.GAME_WIDTH - sunBurst.width) * 0.5;
			sunBurst.y = (TG_World.GAME_HEIGHT - sunBurst.height) * 0.5;
			
			//Top Frame
			topFrame.width = TG_World.GAME_WIDTH;
			topFrame.height = 35;
			
			//Bottom Frame
			botFrame.width = TG_World.GAME_WIDTH;
			botFrame.height = 72.2;
			botFrame.x = TG_World.GAME_WIDTH;
			botFrame.y = TG_World.GAME_HEIGHT;
			
			//Title
			title.scaleX = title.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			title.x = (TG_World.GAME_WIDTH - title.width) * 0.5;
			title.y = (TG_World.GAME_HEIGHT - title.height) * 0.5;
			title.y-= 100 * TG_World.SCALE_ROUNDED;
			
			//Shield
			shield.scaleX = shield.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			shield.x = (TG_World.GAME_WIDTH - shield.width) * 0.5;
			shield.y = title.y + title.height + (5 * (TG_World.SCALE_ROUNDED - 1));
			
			//Human
			human.scaleX = human.scaleY = TG_World.SCALE * 0.5;
			human.x = shield.x - (human.width * 0.8);
			human.y = ((TG_World.GAME_HEIGHT - human.height) * 0.5) + (50 * TG_World.SCALE);
			
			//Boar
			boar.scaleX = boar.scaleY = TG_World.SCALE * 0.5;
			boar.x = shield.x + shield.width - (boar.width * 0.2) ;
			boar.y = ((TG_World.GAME_HEIGHT - boar.height) * 0.5) + (60 * TG_World.SCALE);
			
			//Start Button
			startButton.scaleX = startButton.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			startButton.x = (TG_World.GAME_WIDTH - startButton.width) * 0.5;
			startButton.y = shield.y + shield.height + (5 * (TG_World.SCALE_ROUNDED-1));
			
			//Credit Button
			creditButton.scaleX = creditButton.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			creditButton.x = (TG_World.GAME_WIDTH - creditButton.width) * 0.5 - (30 * TG_World.SCALE_ROUNDED);
			creditButton.y = (TG_World.GAME_HEIGHT - creditButton.height);
			
			//Option Button
			optionButton.scaleX = optionButton.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			optionButton.x = (TG_World.GAME_WIDTH - optionButton.width) * 0.5 + (30 * TG_World.SCALE_ROUNDED);
			optionButton.y = (TG_World.GAME_HEIGHT - optionButton.height);
			
			//Languange Button
			m_languageOption.sprite.y = m_rollOption.sprite.y + m_rollOption.sprite.height ;
			
			refreshAnimation();
		}
		
		//STEP 7 INIT ANIMATION
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				
				var tempClip:* = shield;
				fadeAnimationPos(m_timeline,tempClip,tempClip.x,-tempClip.height,tempClip.x,tempClip.y,0.5,0);
				tempClip = human;
				fadeAnimationPos(m_timeline,tempClip,-tempClip.width,tempClip.y,tempClip.x,tempClip.y,0.5,0.2);
				tempClip = boar;
				fadeAnimationPos(m_timeline,tempClip,TG_World.GAME_WIDTH,tempClip.y,tempClip.x,tempClip.y,0.5,0.2);
				tempClip = title;
				fadeAnimationPos(m_timeline,tempClip,tempClip.x,-tempClip.height,tempClip.x,tempClip.y,0.5,0.3);
				tempClip = creditButton;
				fadeAnimationPos(m_timeline,tempClip,tempClip.x,TG_World.GAME_HEIGHT,tempClip.x,tempClip.y,0.5,0.4);
				tempClip = optionButton;
				fadeAnimationPos(m_timeline,tempClip,tempClip.x,TG_World.GAME_HEIGHT,tempClip.x,tempClip.y,0.5,0.4);
				tempClip = startButton;
				fadeAnimationPos(m_timeline,tempClip,tempClip.x,-tempClip.height,tempClip.x,tempClip.y,0.5,0.4);
				
				m_timeline.addLabel("fadeInStart",0);
				m_timeline.addLabel("fadeInEnd",0.9);
				m_timeline.pause();
			}
			show();
		}
		
		//STEP 8 INIT LISTENERS
		protected override function initListeners():void
		{
			super.initListeners();
			startButton.addEventListener(Event.TRIGGERED,onStartButtonPressed);
		}
		//STEP 9 DESTROY LISTENERS
		protected override function destroyListeners():void
		{
			super.destroyListeners();
			startButton.removeEventListener(Event.TRIGGERED,onStartButtonPressed);
		}
		
		private final function onStartButtonPressed(e:Event):void
		{
			TG_GameManager.getInstance().changeGameState(TG_SinglePlayerState,TG_Static.layerInGame);
		}
		
		
		protected override function initMenuBars():void
		{
			super.initMenuBars();
			options = [];
			options[TG_Static.ENGLISH] = ["SINGLE PLAYER","VERSUS","TEAM VERSUS","LUCKY BOUT","TEAM LUCKY BOUT","CREDITS","OPTIONS"];
			options[TG_Static.INDONESIA] = ["BERMAIN SENDIRI","LAWAN ORANG","TIM LAWAN ORANG","PERTANDINGAN UNTUNG-UNTUNGAN","TIM PERTANDINGAN UNTUNG-UNTUNGAN","KREDIT","PILIHAN"];
			
			m_rollOption = new TG_RollOption(m_sprite,this,options[TG_Static.language],25,1);
			m_languageOption = new TG_LanguageRollOption(m_sprite,this,["ENGLISH","INDONESIA"],25,0.5);
			m_languageOption.reset(TG_Static.language);
		}
		
		protected override function updateInput():void
		{
			if(m_keyPoll)
			{
				//ARROW LEFT
				if(m_keyPoll.isDown(37) && !m_keyArray[37])
				{
					m_keyArray[37] = true;
					m_rollOption.moveLeft();
				}
				if(m_keyPoll.isUp(37) && m_keyArray[37])
				{
					m_keyArray[37] = false;
				}
				//ARROW RIGHT
				if(m_keyPoll.isDown(39) && !m_keyArray[39])
				{
					m_keyArray[39] = true;
					m_rollOption.moveRight();
				}
				if(m_keyPoll.isUp(39) && m_keyArray[39])
				{
					m_keyArray[39] = false;
				}
				//ENTER
				if(m_keyPoll.isDown(13) && !m_keyArray[13])
				{
					m_keyArray[13] = true;
					if(m_rollOption.currentOption == 0)
					{
						TG_GameManager.getInstance().changeGameState(TG_SinglePlayerState,TG_Static.layerInGame);
					}
					else if(m_rollOption.currentOption == 1)
					{
						TG_GameManager.getInstance().changeGameState(TG_VersusState,TG_Static.layerInGame);
					}
					else if(m_rollOption.currentOption == 3)
					{
						TG_GameManager.getInstance().changeGameState(TG_LuckyBoutState,TG_Static.layerInGame);
					}
				}
				if(m_keyPoll.isUp(13) && m_keyArray[13])
				{
					m_keyArray[13] = false;
				}
			}
		}
		
		public override function doSomething(str:String):void
		{
			if(str == options[TG_Static.language][0])
			{
				TG_GameManager.getInstance().changeGameState(TG_SinglePlayerState,TG_Static.layerInGame);
			}
			else if(str == options[TG_Static.language][1])
			{
				TG_GameManager.getInstance().changeGameState(TG_VersusState,TG_Static.layerInGame);
			}
			else if(str == options[TG_Static.language][3])
			{
				TG_GameManager.getInstance().changeGameState(TG_LuckyBoutState,TG_Static.layerInGame);
			}
			else if(str == "ENGLISH")
			{
				TG_Static.language = TG_Static.ENGLISH;
				m_rollOption.refreshText(options[TG_Static.ENGLISH]);
			}
			else if(str == "INDONESIA")
			{
				TG_Static.language = TG_Static.INDONESIA;
				m_rollOption.refreshText(options[TG_Static.INDONESIA]);
			}
		}
	}
}