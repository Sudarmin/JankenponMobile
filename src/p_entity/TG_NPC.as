package p_entity
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.LoaderMax;
	
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.factorys.StarlingFactory;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import p_engine.p_singleton.TG_World;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class TG_NPC extends TG_Entity
	{
		/** PROTECTED VARIABLES **/
		protected var m_assetsToLoad:Array;
		protected var m_loadDone:Boolean = false;
		protected var m_health:int = 100;
		protected var m_initialHealth:int = 100;
		
		/** PRIVATE VARIABLES **/
		private var m_factory:StarlingFactory;
		private var m_armature:Armature;
		private var m_charXML:XML;
		private var m_pivot:Array;
		private var m_lastAnimation:String = "";
		private var m_balloonChat:Sprite;
		private var m_chat:TextField;
		private var m_balloonImage:Scale9Image;
		
		public static const LOADED:String = "loaded";
		
		
		private var loaderMax:LoaderMax;
		
		
		public function TG_NPC(parent:DisplayObjectContainer, direction:String = "left",no:int = 0)
		{
			super(parent);
			
			loaderMax = new LoaderMax();
			
			m_direction = direction;
			
			var xml:XML = TG_World.assetManager.getXml("NPC");
			m_charXML = xml.NPC[no];
			initBeforeLoad();
		}
		
		
		
		public function initBeforeLoad():void
		{
			CONFIG::MOBILE
			{
				describeAssets();
				loadAssets();
			}
			CONFIG::WEB
			{
				init();
			}
		}
		
		protected function loadAssets():void
		{
			if(m_assetsToLoad == null)
			{
				m_loadDone = true;
				init();
			}
			else
			{
				var i:int = 0;
				var size:int = m_assetsToLoad.length;
				var obj:Object;
				for(i;i<size;i++)
				{
					obj = m_assetsToLoad[i];
					loaderMax.append(new BinaryDataLoader(obj.url,{name:obj.itemName,estimatedBytes:obj.kbTotal}));
				}
				loaderMax.addEventListener(LoaderEvent.COMPLETE,onComplete);
				loaderMax.load(true);
			}
		}
		
		protected function onComplete(e:LoaderEvent):void
		{
			loaderMax.removeEventListener(LoaderEvent.COMPLETE,onComplete);
			m_loadDone = true;
			init();
		}
		
		public override function init():void
		{
			super.init();
			initSkeleton();
		}
		
		public override function destroy():void
		{
			super.destroy();
			destroySkeleton();
			if(loaderMax)
			loaderMax.dispose(true);
			loaderMax = null;
		}
		
		public function hide():void
		{
			TweenMax.to(m_sprite,2,{alpha:0.1,onComplete:destroy});
		}
		
		public function get id():String
		{
			return m_charXML.id;
		}
		
		public function update(elapsedTime:int):void
		{
			
		}
		//STEP BY STEP IMPLEMENTATION
		
		//STEP 1 DEFINE EMBEDDED PNG AND XML FOR WEB PURPOSE
		CONFIG::WEB
		{
			[Embed(source="/assets/chars/CharBlackSmith.png",mimeType="application/octet-stream")]
			public static const CharBlackSmith:Class;
		}
		
		//STEP 2 DESCRIBE ASSETS TO LOAD DYNAMICALLY FOR MOBILE PURPOSE
		protected function describeAssets():void
		{
			CONFIG::MOBILE
			{
				m_assetsToLoad = [];
				var obj:Object;
				
				obj = new Object();
				obj.url = m_charXML.pngUrl;
				obj.itemName = m_charXML.id;
				//obj.type = TG_AssetsLoader.BINARY;
				obj.kbTotal = m_charXML.size;
				m_assetsToLoad.push(obj);
			}
		}
		
		//STEP 3 INIT DRAGON BONES
		protected function initSkeleton():void
		{
			if(m_factory == null)
			{
				m_factory = new StarlingFactory();
			}
			m_factory.addEventListener(flash.events.Event.COMPLETE, textureCompleteHandler);
			CONFIG::WEB
			{
				clase = CharBlackSmith();
				m_factory.parseData(new clase());
			}
			CONFIG::MOBILE
			{
				m_factory.parseData(loaderMax.getLoader(m_charXML.id).content);
			}
		}
		
		//STEP 4 DESTROY DRAGON BONES
		protected function destroySkeleton():void
		{
			if(m_armature)
			{
				m_armature.dispose();
				WorldClock.clock.remove(m_armature);
			}
			if(m_factory)
			{
				m_factory.dispose(true)
			}
		}
		
		private function textureCompleteHandler(e:flash.events.Event):void
		{
			m_factory.removeEventListener(flash.events.Event.COMPLETE, textureCompleteHandler);
			m_armature = m_factory.buildArmature(m_charXML.name);
			m_sprite = m_armature.display as Sprite;
			
			
			m_pivot = m_charXML.pivot.split(",");
			
			m_sprite.pivotX = m_pivot[0] * 2 /m_charXML.scale;
			m_sprite.pivotY = m_pivot[1] * 2 /m_charXML.scale;
			m_sprite.scaleX = m_sprite.scaleY = m_charXML.scale;
			
			changeDirection(m_direction);
			
			m_parent.addChild(m_sprite);
			WorldClock.clock.add(m_armature);
			
			var rect:Rectangle = new Rectangle(40,30,5,5);
			m_balloonImage = new Scale9Image(TG_World.assetManager.getTexture("txtBubble"),rect,true);
			m_chat = new TextField(90,50,"Thank you for saving me","Londrina",20,0xFFFF00);
			m_chat.autoSize = TextFieldAutoSize.VERTICAL;
			m_balloonChat = new Sprite();
			m_balloonChat.addChild(m_balloonImage);
			m_balloonChat.addChild(m_chat);
			m_balloonChat.y = -(m_sprite.height);
			m_balloonChat.x = -5;
			m_sprite.addChild(m_balloonChat);
			
			m_balloonChat.visible = false;
			dispatchEvent(new starling.events.Event(LOADED));
		}
		
		public function showText(text:String,visible:Boolean = true):void
		{
			m_chat.text = text;
			m_balloonImage.height = m_chat.height + 50;
			m_chat.x = (m_balloonImage.width - m_chat.width) * 0.5;
			m_chat.y = (m_balloonImage.height - m_chat.height) * 0.5;
			m_chat.y -= 20;
			
			m_balloonChat.y = -(m_sprite.height + (m_balloonChat.height-50));
			
			m_balloonChat.visible = visible;
			
			
		}
		
		public function playAnimation(label:String,loop:int = 0,duration:Number = -1):void
		{
			if(m_armature)
			{
				if(m_armature.animation.gotoAndPlay(label,0,duration,loop) == null)
				{
					m_armature.animation.gotoAndPlay("idle",0,duration,loop)
				}
			}
			m_lastAnimation = label;
		}
		
		public function get xml():XML
		{
			return m_charXML;
		}
		
		
		public function get name():String
		{
			var str:String;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = m_charXML.nameEnglish;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = m_charXML.nameIndonesia;
			}
			
			return str;
		}
		
		
		
		
	}
}