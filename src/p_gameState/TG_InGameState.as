package p_gameState
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_singleton.TG_AssetsLoader;
	import p_engine.p_singleton.TG_GameManager;
	import p_engine.p_singleton.TG_LoaderMax;
	import p_engine.p_singleton.TG_World;
	
	import p_entity.TG_Character;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	public class TG_InGameState extends TG_GameState
	{
		private var atlasLevel:TextureAtlas;
		private var textureLevel:Texture;
		private var bitmapLevel:Bitmap;
		
		//LEVEL
		private var sky:Image;
		private var fgArray:Array; // contains 4
		private var bgArray:Array; // contains 4
		private var groundArray:Array; // contains 8
		
		public var layerDynamic:Sprite;
		public var layerStatic:Sprite;
		public var layerForeground:Sprite;
		public var layerNormalground:Sprite;
		public var layerBackground:Sprite;
		public var layerCharacter:Sprite;
		public var layerSky:Sprite;
		
		public var levelXML:XML;
		public var levelNum:int = 0;
		private static const MEADOW:int = 0;
		private static const TOWN:int = 1;
		private static const MAGICAL:int = 2;
		private static const DUNGEON:int = 3;
		private static const CASTLE:int = 4;
		
		
		protected var multiFunctionText:TextField;
		public function TG_InGameState(parent:DisplayObjectContainer)
		{
			super(parent);
			
			var xml:XML;
			xml = TG_World.assetManager.getXml("Levels");
			var size:int = xml.level.length();
			levelNum = (Math.random() * 1000) % size;
			//levelNum = 4;
			levelXML = xml.level[levelNum];
		}
		
		public override function init():void
		{
			super.init();
		}
		
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
		}
		
		protected function showStartText():void
		{
			var str:String;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "START!";
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "MULAI!";
			}
			reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
			TweenMax.fromTo(multiFunctionText,0.3,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onStartTextStarted,ease:Circ.easeOut});
		}
		
		protected function reuseText(str:String,posX:Number=0,posY:Number=0):void
		{
			multiFunctionText.alpha = 1;
			multiFunctionText.visible = true;
			multiFunctionText.text = str;
			multiFunctionText.scaleX = multiFunctionText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			if(multiFunctionText.scaleX >1)
			{
				multiFunctionText.scaleX = multiFunctionText.scaleY = 1;
			}
			multiFunctionText.pivotX = (multiFunctionText.width/multiFunctionText.scaleX) * 0.5;
			multiFunctionText.pivotY = (multiFunctionText.height/multiFunctionText.scaleY) * 0.5;
			multiFunctionText.x = posX;
			multiFunctionText.y = posY;
		}
		protected function createText(str:String,fontSize:int,color:uint,posX:Number=0,posY:Number=0):TextField
		{
			var textField:TextField;
			textField = new TextField(50,50,str,"Londrina",fontSize,color);
			textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			textField.scaleX = textField.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			if(textField.scaleX >1)
			{
				textField.scaleX = textField.scaleY = 1;
			}
			textField.pivotX = (textField.width/textField.scaleX) * 0.5;
			textField.pivotY = (textField.height/textField.scaleY) * 0.5;
			return textField;
		}
		protected function onStartTextStarted():void
		{
			TweenMax.fromTo(multiFunctionText,0.2,{alpha:1},{alpha:0.1,delay:0.3,onComplete:onStartTextCompleted});
		}
		protected function onStartTextCompleted():void
		{
			
		}
		
		protected override function destroySprite():void
		{
			super.destroySprite();
			if(multiFunctionText)
			{
				multiFunctionText.removeFromParent(true);
			}
			multiFunctionText = null;
		}
		//STEP BY STEP IMPLEMENTATION
		
		//STEP 1 DEFINE EMBEDDED PNG AND XML FOR WEB PURPOSE
		CONFIG::WEB
		{
			[Embed(source="/assets/textureAtlas/levelMeadow.png")]
			public static const levelMeadow:Class;
			
			[Embed(source="/assets/textureAtlas/levelMeadow.xml",mimeType="application/octet-stream")]
			public static const levelMeadowXML:Class;
			
			[Embed(source="/assets/textureAtlas/levelTown.png")]
			public static const levelTown:Class;
			
			[Embed(source="/assets/textureAtlas/levelTown.xml",mimeType="application/octet-stream")]
			public static const levelTownXML:Class;
			
			[Embed(source="/assets/textureAtlas/levelMagical.png")]
			public static const levelMagical:Class;
			
			[Embed(source="/assets/textureAtlas/levelMagical.xml",mimeType="application/octet-stream")]
			public static const levelMagicalXML:Class;
			
			[Embed(source="/assets/textureAtlas/levelDungeon.png")]
			public static const levelDungeon:Class;
			
			[Embed(source="/assets/textureAtlas/levelDungeon.xml",mimeType="application/octet-stream")]
			public static const levelDungeonXML:Class;
			
			[Embed(source="/assets/textureAtlas/levelCastle.png")]
			public static const levelCastle:Class;
			
			[Embed(source="/assets/textureAtlas/levelCastle.xml",mimeType="application/octet-stream")]
			public static const levelCastleXML:Class;
		}
		
		//STEP 2 DESCRIBE ASSETS TO LOAD DYNAMICALLY FOR MOBILE PURPOSE
		protected override function describeAssets():void
		{
			CONFIG::MOBILE
			{
				m_assetsToLoad = [];
				var obj:Object;
				
				obj = new Object();
				obj.url = levelXML.pngUrl;
				obj.itemName = levelXML.name;
				obj.type = TG_AssetsLoader.IMAGE;
				obj.kbTotal = levelXML.pngSize;
				m_assetsToLoad.push(obj);
				
				obj = new Object();
				obj.url = levelXML.xmlUrl;
				obj.itemName = levelXML.name +"XML";
				obj.type = TG_AssetsLoader.XML;
				obj.kbTotal = levelXML.xmlSize;
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
				var pngClase:Class;
				var xmlClase:Class;
				
				if(levelNum == MEADOW)
				{
					pngClase = levelMeadow;
					xmlClase = levelMeadowXML;
				}
				else if(levelNum == TOWN)
				{
					pngClase = levelTown;
					xmlClase = levelTownXML;
				}
				else if(levelNum == MAGICAL)
				{
					pngClase = levelMagical;
					xmlClase = levelMagicalXML;
				}
				else if(levelNum == DUNGEON)
				{
					pngClase = levelDungeon;
					xmlClase = levelDungeonXML;
				}
				else if(levelNum == CASTLE)
				{
					pngClase = levelCastle;
					xmlClase = levelCastleXML;
				}
				bitmapLevel = new pngClase();
				textureLevel = Texture.fromBitmap(bitmapLevel);
				xml = XML(new xmlClase());
				atlasLevel = new TextureAtlas(textureLevel,xml);
				
				//DONT FORGET TO PUT RESTORE FUNCTION
				textureLevel.root.onRestore = function():void
				{
					// restore the texture from its original source
					textureLevel.root.uploadBitmap(bitmapLevel);
				}
			}
			CONFIG::MOBILE
			{
				bitmapLevel = TG_LoaderMax.getInstance().getLoader(levelXML.name).rawContent;
				textureLevel = createTexture(bitmapLevel);
				xml = TG_LoaderMax.getInstance().getLoader(levelXML.name+"XML").content;
				atlasLevel = new TextureAtlas(textureLevel,xml);
				
				//IF IT'S ON APPLE DISPOSE THE BITMAP, BECAUSE WE DONT NEED IT
				if(TG_World.os == "ios")
				{
					bitmapLevel.bitmapData.dispose();
					bitmapLevel = null;
				}
				//DONT FORGET TO PUT RESTORE FUNCTION ON ANDROID
				if(TG_World.os == "android")
				{
					textureLevel.root.onRestore = function():void
					{
						// restore the texture from its original source
						textureLevel.root.uploadBitmap(bitmapLevel);
					}
				}
			}
		}
		
		//STEP 4 CREATE DESTROY TEXTURE ATLAS FUNCTION
		protected override function destroyTextureAtlas():void
		{
			super.destroyTextureAtlas();
			textureLevel.dispose();
			atlasLevel.dispose();
			if(bitmapLevel && bitmapLevel.bitmapData)
			{
				bitmapLevel.bitmapData.dispose();
				bitmapLevel = null;
			}
		}
		
		//STEP 5 INIT SPRITE
		protected override function initSprite():void
		{
			m_sprite = new Sprite();
			
			//LAYERS
			layerDynamic = new Sprite();
			layerStatic = new Sprite();
			
			m_sprite.addChild(layerStatic);
			m_sprite.addChild(layerDynamic);
			
			layerForeground = new Sprite();
			layerNormalground = new Sprite();
			layerBackground = new Sprite();
			layerCharacter = new Sprite();
			layerSky = new Sprite();
			
			layerStatic.addChild(layerSky);
			layerDynamic.addChild(layerBackground);
			layerDynamic.addChild(layerNormalground);
			layerDynamic.addChild(layerCharacter);
			layerDynamic.addChild(layerForeground);
			
			fgArray = [];
			bgArray = [];
			groundArray = [];
			
			var image:Image;
			var sprite:Sprite;
			var i:int = 0;
			var size:int = 0;
			var randNum:int = 0;
			var arr:Array;
			
			//CREATE SKY
			image = new Image(atlasLevel.getTexture("Sky"));
			image.width = TG_World.GAME_WIDTH + 20; // SO THE SKY WON'T HAVE BLANK LINES WE GIVE 20px Additional
			image.height = TG_World.GAME_HEIGHT + 20;
			image.x = -10;
			image.y = -10
			layerSky.addChild(image);
			sky = image;
			
			//CREATE BACKGROUND
			i = 0;
			size = 4;
			arr = levelXML.backgroundPivot.split(",");
			for(i;i<size;i++)
			{
				image = new Image(atlasLevel.getTexture("BG"));
				image.pivotX = arr[0] * 2;
				image.pivotY = arr[1] * 2;
				image.rotation = i * deg2rad(90);
				bgArray.push(image);
				layerBackground.addChild(image);
			}
			
			
			//CREATE NORMAL GROUND
			i = 0;
			size = 8;
			for(i;i<size;i++)
			{
				randNum = (Math.random() * 1000) % 3;
				arr = levelXML["normalgroundPivot"+randNum].split(",");
				image = new Image(atlasLevel.getTexture("Ground"+randNum));
				image.pivotX = arr[0] * 2;
				image.pivotY = arr[1] * 2;
				image.rotation = i * deg2rad(45);
				groundArray.push(image);
				layerNormalground.addChild(image);
			}
			
			//CREATE FORE GROUND
			i = 0;
			size = 4;
			arr = levelXML.foregroundPivot.split(",");
			for(i;i<size;i++)
			{
				image = new Image(atlasLevel.getTexture("FG"));
				image.pivotX = arr[0] * 2;
				image.pivotY = arr[1] * 2;
				image.rotation = i * deg2rad(90);
				fgArray.push(image);
				layerForeground.addChild(image);
			}
			
			layerForeground.scaleX = layerForeground.scaleY = 0.9;
			
			//MULTI FUNCTION TEXT
			multiFunctionText = new TextField(50,50,"START","Londrina",100,0xFFFF00);
			multiFunctionText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			TG_Static.layerText.addChild(multiFunctionText);
		}
		
		//STEP 6 CREATE RESIZE FUNCTION
		public override function resize():void
		{
			super.resize();
			sky.width = TG_World.GAME_WIDTH + 20;
			sky.height = TG_World.GAME_HEIGHT + 20;
			sky.x = -10;
			sky.y = -10;
			
			layerDynamic.scaleX = layerDynamic.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			
			layerDynamic.x = TG_World.GAME_WIDTH * 0.5;
			layerDynamic.y = TG_World.GAME_HEIGHT + (layerDynamic.height * 0.5);
			layerDynamic.y -= layerDynamic.height *  0.35;
			
			if(multiFunctionText)
			{
				multiFunctionText.scaleX = multiFunctionText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
				multiFunctionText.pivotX = multiFunctionText.width * 0.5;
				multiFunctionText.pivotY = multiFunctionText.height * 0.5;
			}
		}
		
		//STEP 7 INIT ANIMATION
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				
				
			}
			//show();
		}
		
		//STEP 8 INIT LISTENERS
		//STEP 9 DESTROY LISTENERS
		
		//UPDATE INPUT
		protected override function updateInput():void
		{
			if(m_keyPoll)
			{
				//ESCAPE
				if(m_keyPoll.isDown(27) && !m_keyArray[27])
				{
					m_keyArray[27] = true;
					TG_GameManager.getInstance().changeGameState(TG_StartMenuState,TG_Static.layerInGame);
				}
				if(m_keyPoll.isUp(27) && m_keyArray[27])
				{
					m_keyArray[27] = false;
				}
			}
		}
	}
}