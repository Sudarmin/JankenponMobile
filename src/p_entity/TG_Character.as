package p_entity
{
	import com.greensock.TimelineMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.LoaderMax;
	
	import dragonBones.Armature;
	import dragonBones.animation.WorldClock;
	import dragonBones.factorys.StarlingFactory;
	
	import flash.events.Event;
	
	import p_engine.p_singleton.TG_World;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;

	public class TG_Character extends TG_Entity
	{
		/** PROTECTED VARIABLES **/
		protected var m_assetsToLoad:Array;
		protected var m_loadDone:Boolean = false;
		protected var m_health:int = 100;
		protected var m_initialHealth:int = 100;
		
		/** PRIVATE VARIABLES **/
		private var m_factory:StarlingFactory;
		private var m_armature:Armature;
		private var m_charID:String = "0";
		private var m_charXML:XML;
		private var m_pivot:Array;
		private var m_speed:Number = 0.35;
		private var m_jumpSpeed:Number = 0.5;
		private var m_isMoving:Boolean = false;
		private var m_lastAnimation:String = "";
		
		/** STATUS **/
		private var m_level:int = 1;
		private var m_nextExp:int = 0;
		private var m_seizedExp:int = 0;
		private var m_currentExp:Number = 0;
		private var m_maxLevel:int = 25;
		
		private var m_damage:int = 0;
		private var m_damageRange:int = 0;
		
		private var m_critChance:Number = 0;
		private var m_critValue:Number = 0;
		
		private var m_poisonChance:Number = 0;
		private var m_poisonValue:int = 0;
		
		public var isPoisoned:Boolean = false;
		public var poisonCounter:int = 0;
		public var maxPoisonCounter:int = 3;
		
		private var m_healChance:Number = 0;
		private var m_healValue:int = 0;
		
		private var m_evadeChance:Number = 0;
		private var m_dmgReturnChance:Number = 0;
		private var m_dmgReturnValue:int = 0;
		
		private var m_lifestealValue:int = 0;
		
		private var m_magicChance:Number = 0;
		private var m_magicValue:int = 0;
		
		private var m_damageMultiplier:Number = 1;
		private var m_damageMultiplierCounter:int = 0;
		private var m_damageMultiplierMax:int = 3;
		
		private var m_strengthenChance:Number = 0;
		private var m_strengthenValue:Number = 0;
		public var isStrengthen:Boolean = false;
		public var strengthenCounter:int = 0;
		public var strengthenCounterMax:int = 3;
		
		private var m_weakenChance:Number = 0;
		private var m_weakenValue:Number = 1;
		public var isWeaken:Boolean = false;
		public var weakenCounter:int = 0;
		public var weakenCounterMax:int = 3;
		
		private var m_luck:Number = 0;
		private var m_reverseChance:Number = 0;
		private var m_reverseChanceBonus:Number = 0;
		
		//BONUS
		public var healthBonus:int = 0;
		public var damageBonus:int = 0;
		public var criticalChanceBonus:Number = 0;
		public var criticalValueBonus:Number = 0;
		public var poisonChanceBonus:Number = 0;
		public var poisonValueBonus:Number = 0;
		public var healChanceBonus:Number = 0;
		public var healValueBonus:Number = 0;
		public var evadeChanceBonus:Number = 0;
		public var dmgReturnChanceBonus:Number = 0;
		public var dmgReturnValueBonus:Number = 0;
		public var lifestealValueBonus:Number = 0;
		public var magicChanceBonus:Number = 0;
		public var magicValueBonus:Number = 0;
		public var strengthenChanceBonus:Number = 0;
		public var strengthenValueBonus:Number = 0;
		public var weakenChanceBonus:Number = 0;
		public var weakenValueBonus:Number = 0;
		public var reverseChanceBonus:Number = 0;
		
		//PERMANENT BONUS
		public var healthBonusPermanent:int = 0;
		public var damageBonusPermanent:int = 0;
		public var criticalChanceBonusPermanent:Number = 0;
		public var criticalValueBonusPermanent:Number = 0;
		public var poisonChanceBonusPermanent:Number = 0;
		public var poisonValueBonusPermanent:Number = 0;
		public var healChanceBonusPermanent:Number = 0;
		public var healValueBonusPermanent:Number = 0;
		public var evadeChanceBonusPermanent:Number = 0;
		public var dmgReturnChanceBonusPermanent:Number = 0;
		public var dmgReturnValueBonusPermanent:Number = 0;
		public var lifestealValueBonusPermanent:Number = 0;
		public var magicChanceBonusPermanent:Number = 0;
		public var magicValueBonusPermanent:Number = 0;
		public var strengthenChanceBonusPermanent:Number = 0;
		public var strengthenValueBonusPermanent:Number = 0;
		public var weakenChanceBonusPermanent:Number = 0;
		public var weakenValueBonusPermanent:Number = 0;
		public var reverseChanceBonusPermanent:Number = 0;
		
		private var m_isBoss:int = 0;
		
		public static const LOADED:String = "loaded";
		
		private static const HUMAN1:String = "0";
		private static const IMP1:String = "1";
		
		private var loaderMax:LoaderMax;
		
		private static var CHARACTERSXML:Array;
		private static var MINIONSXML:Array;
		private static var BOSSXML:Array;
		
		private var m_isLevelingUp:Boolean = false;
		private var m_reviveCounter:int = 0;
		
		private var m_points:Number = 0;
		public var isPlayer:Boolean = false;
		public function TG_Character(parent:DisplayObjectContainer, direction:String = "right",charID:String = "")
		{
			super(parent);
			
			loaderMax = new LoaderMax();
			
			m_direction = direction;
			m_charID = charID;
			
			var xml:XML;
			
			if(CHARACTERSXML == null)
			{
				indexCharacters();
			}
			
			
			var number:int = 0;
			if(m_charID == "")
			{
				var size:int = MINIONSXML.length;
				number = (Math.random() * 1000 * size) % size;
				//number = 1;
				m_charXML = MINIONSXML[number];
			}
			else
			{
				m_charXML = CHARACTERSXML[m_charID];
			}
			
			m_isBoss = int(m_charXML.isBoss);
			reviveCounter = m_charXML.revive;
			
			initBeforeLoad();
		}
		
		private function indexCharacters():void
		{
			CHARACTERSXML = new Array();
			MINIONSXML = new Array();
			BOSSXML = new Array();
			
			var xml:XML = TG_World.assetManager.getXml("Characters");
			
			var i:int = 0;
			var size:int = xml.character.length();
			for(i;i<size;i++)
			{
				CHARACTERSXML[xml.character[i].id] = xml.character[i];
				CHARACTERSXML.push(xml.character[i]);
				MINIONSXML.push(xml.character[i]);
			}
			
			xml = TG_World.assetManager.getXml("Bosses");
			i = 0;
			size = xml.boss.length();
			for(i;i<size;i++)
			{
				CHARACTERSXML[xml.boss[i].id] = xml.boss[i];
				CHARACTERSXML.push(xml.boss[i]);
				BOSSXML.push(xml.character[i]);
			}
			
		}
		
		public function initBeforeLoad():void
		{
			//TG_AssetsLoader.getInstance().clear();
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
					//TG_AssetsLoader.getInstance().append(obj.url,obj.itemName,obj.type,obj.kbTotal);
				}
				loaderMax.addEventListener(LoaderEvent.COMPLETE,onComplete);
				loaderMax.load(true);
				//loaderMax.show(false);
				//loaderMax.startLoad();
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
			initStatus();
		}
		
		public override function destroy():void
		{
			super.destroy();
			destroySkeleton();
			loaderMax.dispose(true);
			loaderMax = null;
			//TG_AssetsLoader.getInstance().dispose(true);
		}
		
		public function update(elapsedTime:int):void
		{
			
		}
		//STEP BY STEP IMPLEMENTATION
		
		//STEP 1 DEFINE EMBEDDED PNG AND XML FOR WEB PURPOSE
		CONFIG::WEB
		{
			[Embed(source="/assets/chars/CharHuman.png",mimeType="application/octet-stream")]
			public static const CharHuman:Class;
			
			[Embed(source="/assets/chars/CharImp.png",mimeType="application/octet-stream")]
			public static const CharImp:Class;
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
				var clase:Class;
				if(m_charNum == HUMAN1)
				{
					clase = CharHuman;
				}
				else if(m_charNum == IMP1)
				{
					clase = CharImp;
				}
				m_factory.parseData(new clase());
			}
			CONFIG::MOBILE
			{
				//m_factory.parseData(TG_LoaderMax.getInstance().getLoader(m_charXML.id).content);
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
			
			dispatchEvent(new starling.events.Event(LOADED));
		}
		
		protected function initStatus():void
		{
			m_health = m_charXML.baseHealth;
			m_initialHealth = m_charXML.baseHealth;
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
		
		public function get isBoss():Boolean
		{
			if(m_isBoss > 0)
			{
				return true;
			}
			return false;
		}
		
		public function set moving(value:Boolean):void
		{
			m_isMoving = value;
		}
		
		public function get xml():XML
		{
			return m_charXML;
		}
		
		public function get speed():Number
		{
			return m_speed;
		}
		public function get jumpSpeed():Number
		{
			return m_jumpSpeed;
		}
		public function get isMoving():Boolean
		{
			return m_isMoving;
		}
		
		public function get id():String
		{
			return m_charXML.id;
		}
		public function get desc():String
		{
			var str:String;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "Level "+m_level+"\n";
				str += "Health "+m_initialHealth+"\n";
				str += "Damage "+m_damage+"-"+(m_damage+m_damageRange)+"\n";
				if(m_critChance > 0)
				{
					str += "Crit Chance "+m_critChance+"%\n";
					str += "Crit Dmg "+(m_critValue*100)+"%\n";
				}
				if(m_poisonChance > 0)
				{
					str += "Poison Chance "+m_poisonChance+"%\n";
					str += "Poison Dmg "+m_poisonValue+"\n";
				}
				if(m_healChance > 0)
				{
					str += "Heal Chance "+m_healChance+"%\n";
					str += "Heal Value "+m_healValue+"\n";
				}
				if(m_evadeChance > 0)
				{
					str += "Evade Chance "+m_evadeChance+"%\n";
				}
				if(m_dmgReturnChance > 0)
				{
					str += "Dmg Return Chance "+m_dmgReturnChance+"%\n";
					str += "Dmg Return "+m_dmgReturnValue+"\n";
				}
				if(m_lifestealValue > 0)
				{
					str += "Life Steal "+(m_lifestealValue)+"%\n";
				}
				if(m_magicChance > 0)
				{
					str += "Magic Chance "+m_magicChance+"%\n";
					str += "Magic Dmg "+m_magicValue+"\n";
				}
				if(m_strengthenChance > 0)
				{
					str += "Strengthen Chance "+m_strengthenChance+"%\n";
					str += "Strengthen To "+m_strengthenValue+"X\n";
				}
				if(m_weakenChance > 0)
				{
					str += "Weaken Chance "+m_weakenChance+"%\n";
					str += "Weaken To "+m_weakenValue+"X\n";
				}
				if(m_reverseChance > 0)
				{
					str += "Reverse Chance "+m_reverseChance+"%\n";
				}
				if(m_luck > 0)
				{
					str += "Luck "+m_luck+"\n";
				}
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = m_charXML.nameIndonesia;
				
				str = "Level "+m_level+"\n";
				str += "Darah "+m_initialHealth+"\n";
				str += "Pukulan "+m_damage+"-"+(m_damage+m_damageRange)+"\n";
				if(m_critChance > 0)
				{
					str += "Krit Kans "+m_critChance+"%\n";
					str += "Krit Pklan "+(m_critValue*100)+"%\n";
				}
				if(m_poisonChance > 0)
				{
					str += "Racun Kans "+m_poisonChance+"%\n";
					str += "Racun Pklan "+m_poisonValue+"\n";
				}
				if(m_healChance > 0)
				{
					str += "Sembuh Kans "+m_healChance+"%\n";
					str += "Sembuh Nilai "+m_healValue+"\n";
				}
				if(m_evadeChance > 0)
				{
					str += "Hindar Kans "+m_evadeChance+"%\n";
				}
				if(m_dmgReturnChance > 0)
				{
					str += "Pukul Balik Kans "+m_dmgReturnChance+"%\n";
					str += "Pukul Balik "+m_dmgReturnValue+"\n";
				}
				if(m_lifestealValue > 0)
				{
					str += "Curi Darah "+(m_lifestealValue)+"%\n";
				}
				if(m_magicChance > 0)
				{
					str += "Sihir Kans "+m_magicChance+"%\n";
					str += "Sihir Pklan "+m_magicValue+"\n";
				}
				if(m_strengthenChance > 0)
				{
					str += "Menguatkan Kans "+m_strengthenChance+"%\n";
					str += "Menguatkan Ke "+m_strengthenValue+"X\n";
				}
				if(m_weakenChance > 0)
				{
					str += "Melemahkan Kans "+m_weakenChance+"%\n";
					str += "Melemahkan Ke "+m_weakenValue+"X\n";
				}
				if(m_reverseChance > 0)
				{
					str += "Membalik Kans "+m_reverseChance+"%\n";
				}
				if(m_luck > 0)
				{
					str += "Hoki "+m_luck+"%\n";
				}
			}
			return str;
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
		
		public function getDamage():Object
		{
			if(m_damageMultiplierCounter >= m_damageMultiplierMax)
			{
				m_damageMultiplier = 1;
				m_damageMultiplierCounter = 0;
			}
			
			var obj:Object = new Object();
			var rand:int = (Math.random() * 10000 * m_damageRange) % m_damageRange;
			var damage:int = rand+m_damage;
			damage *= m_damageMultiplier;
			if(damage <= 0)
			{
				damage = 1;
			}
			
			
			obj.damage = damage;
			
			if(m_critChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= m_critChance)
				{
					obj.damage = int(damage * m_critValue);
					obj.critical = true;
				}
			}
			
			if(m_poisonChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= m_poisonChance)
				{
					obj.poison = true;
				}
			}
			
			if(m_lifestealValue > 0)
			{
				obj.lifeSteal = int(obj.damage * (m_lifestealValue/100));
				if(obj.lifeSteal < 1)
				{
					obj.lifesteal = 1;
				}
			}
			
			return obj;
		}
		
		public function get reviveCounter():int
		{
			return m_reviveCounter;
		}
		public function set reviveCounter(value:int):void
		{
			m_reviveCounter = value;
		}
		public function getCriticalChance():Number
		{
			return m_critChance;
		}
		public function getCriticalDamage():Number
		{
			return m_critValue;
		}
		
		public function getPoisonChance():Number
		{
			return m_poisonChance;
		}
		
		public function getPoisonDamage():int
		{
			return m_poisonValue;
		}
		public function getHealChance():Number
		{
			return m_healChance;
		}
		public function getHealValue():int
		{
			return m_healValue;
		}
		public function getEvadeChance():Number
		{
			return m_evadeChance;
		}
		public function getDamageReturnChance():Number
		{
			return m_dmgReturnChance;
		}
		public function getDamageReturnValue():int
		{
			return m_dmgReturnValue;
		}
		public function getLifeStealValue():int
		{
			return m_lifestealValue;
		}
		public function getMagicChance():Number
		{
			return m_magicChance;
		}
		public function getMagicValue():int
		{
			return m_magicValue;
		}
		
		public function getStrengthenChance():Number
		{
			return m_strengthenChance;
		}
		
		public function getStrengthenValue():Number
		{
			var value:int = m_strengthenValue * 100;
			return value/100;
		}
		
		public function getWeakenChance():Number
		{
			return m_weakenChance;
		}
		
		public function getWeakenValue():Number
		{
			var value:int = m_weakenValue * 100;
			return value/100;
		}
		
		public function setDamageMultiplier(value:Number):void
		{
			m_damageMultiplier = value;
			m_damageMultiplierCounter = 0;
		}
		
		public function getReverseChance():Number
		{
			return m_reverseChance;
		}
		
		public function getLuck():Number
		{
			return m_luck;
		}
		
		public function get points():Number
		{
			return m_points;
		}
		
		public function set points(value:Number):void
		{
			m_points = value;
		}
		
		public function getRandomAttackNumber():int
		{
			var numOfAttack:int = m_charXML.numOfAttack;
			var rand:int = (Math.random() * 1000) % numOfAttack;
			return rand;
		}
		public function getRandomHitNumber():int
		{
			var numOfHit:int = m_charXML.numOfHit;
			var rand:int = (Math.random() * 1000) % numOfHit;
			return rand;
		}
		public function getRandomDieNumber():int
		{
			var numOfDie:int = m_charXML.numOfDie;
			var rand:int = (Math.random() * 1000) % numOfDie;
			return rand;
		}
		public function get health():int
		{
			return m_health;
		}
		
		public function set health(value:int):void
		{
			m_health = value;
			if(m_health > m_initialHealth)
			{
				m_health = m_initialHealth;
			}
		}
		public function get initialHealth():int
		{
			return m_initialHealth;
		}
		
		public function get level():int
		{
			return m_level;
		}
		
		public function set level(value:int):void
		{
			m_level = value;
			var arr:Array = m_charXML.expFormula.split(",");
			m_nextExp = calculateExp(arr,m_level);
			m_seizedExp = Math.ceil((int(m_charXML.expGainPercentage)/100) * m_nextExp);
			
			recalculateStats();
			m_health = m_initialHealth;
			
		}
		
		public function recalculateStats():void
		{
			m_initialHealth = int(m_charXML.baseHealth) + (int(m_charXML.healthBonus) * (m_level-1));
			m_initialHealth += healthBonus + healthBonusPermanent;
			
			m_damage = int(m_charXML.baseDamage) + (int(m_charXML.damageBonus) * (m_level-1));
			m_damage += damageBonus + damageBonusPermanent;
			
			m_damageRange = int(m_charXML.baseDamageRange);
			
			var maxValue:Number = 0;
			
			//CRITICAL
			m_critChance = Number(m_charXML.criticalChance) + (Number(m_charXML.criticalChanceBonus) * (level -1));
			m_critChance += criticalChanceBonus + criticalChanceBonusPermanent;
			m_critChance = int(m_critChance * 100)/100;
			
			maxValue = Number(m_charXML.criticalChanceMax);
			if(maxValue > 0)
			{
				if(m_critChance > maxValue)
				{
					m_critChance = maxValue;
				}
			}
			m_critValue = Number(m_charXML.criticalValue) + (Number(m_charXML.criticalValueBonus) * (level -1));
			m_critValue += criticalValueBonus + criticalChanceBonusPermanent;
			m_critValue = int(m_critValue * 100)/100;
			
			maxValue = Number(m_charXML.criticalValueMax);
			if(maxValue > 0)
			{
				if(m_critValue > maxValue)
				{
					m_critValue = maxValue;
				}
			}
			
			//POISON
			m_poisonChance = Number(m_charXML.poisonChance) + (Number(m_charXML.poisonChanceBonus) * (level -1));
			m_poisonChance += poisonChanceBonus + poisonChanceBonusPermanent;
			m_poisonChance = int(m_poisonChance * 100)/100;
			
			maxValue = Number(m_charXML.poisonChanceMax);
			if(maxValue > 0)
			{
				if(m_poisonChance > maxValue)
				{
					m_poisonChance = maxValue;
				}
			}
			m_poisonValue = Number(m_charXML.poisonValue) + (Number(m_charXML.poisonValueBonus) * (level -1));
			m_poisonValue += poisonValueBonus + poisonValueBonusPermanent;
			maxValue = Number(m_charXML.poisonValueMax);
			if(maxValue > 0)
			{
				if(m_poisonValue > maxValue)
				{
					m_poisonValue = maxValue;
				}
			}
			//HEAL
			m_healChance = Number(m_charXML.healChance) + (Number(m_charXML.healChanceBonus) * (level -1));
			m_healChance += healChanceBonus + healChanceBonusPermanent;
			m_healChance = int(m_healChance * 100)/100;
			
			maxValue = Number(m_charXML.healChanceMax);
			if(maxValue > 0)
			{
				if(m_healChance > maxValue)
				{
					m_healChance = maxValue;
				}
			}
			m_healValue = Number(m_charXML.healValue) + (Number(m_charXML.healValueBonus) * (level -1));
			m_healValue += healValueBonus + healValueBonusPermanent;
			maxValue = Number(m_charXML.healValueMax);
			if(maxValue > 0)
			{
				if(m_healValue > maxValue)
				{
					m_healValue = maxValue;
				}
			}
			//EVADE
			m_evadeChance = Number(m_charXML.evadeChance) + (Number(m_charXML.evadeChanceBonus) * (level -1));
			m_evadeChance += evadeChanceBonus + evadeChanceBonusPermanent;
			m_evadeChance = int(m_evadeChance * 100)/100;
			
			maxValue = Number(m_charXML.evadeChanceMax);
			if(maxValue > 0)
			{
				if(m_evadeChance > maxValue)
				{
					m_evadeChance = maxValue;
				}
			}
			//DAMAGE RETURN
			m_dmgReturnChance = Number(m_charXML.dmgReturnChance) + (Number(m_charXML.dmgReturnChanceBonus) * (level -1));
			m_dmgReturnChance += dmgReturnChanceBonus + dmgReturnChanceBonusPermanent;
			m_dmgReturnChance = int(m_dmgReturnChance * 100)/100;
			
			maxValue = Number(m_charXML.dmgReturnChanceMax);
			if(maxValue > 0)
			{
				if(m_dmgReturnChance > maxValue)
				{
					m_dmgReturnChance = maxValue;
				}
			}
			m_dmgReturnValue = Number(m_charXML.dmgReturnValue) + (Number(m_charXML.dmgReturnValue) * (level -1));
			m_dmgReturnValue += dmgReturnValueBonus + dmgReturnValueBonusPermanent;
			maxValue = Number(m_charXML.dmgReturnValueMax);
			if(maxValue > 0)
			{
				if(m_dmgReturnValue > maxValue)
				{
					m_dmgReturnValue = maxValue;
				}
			}
			//LIFE STEAL
			m_lifestealValue = Number(m_charXML.lifeStealValue) + (Number(m_charXML.lifeStealValueBonus) * (level -1));
			m_lifestealValue += lifestealValueBonus + lifestealValueBonusPermanent;
			maxValue = Number(m_charXML.lifeStealValueMax);
			if(maxValue > 0)
			{
				if(m_lifestealValue > maxValue)
				{
					m_lifestealValue = maxValue;
				}
			}
			//MAGIC 
			m_magicChance = Number(m_charXML.magicChance) + (Number(m_charXML.magicChanceBonus) * (level -1));
			m_magicChance += magicChanceBonus + magicChanceBonusPermanent;
			m_magicChance = int(m_magicChance * 100)/100;
			
			maxValue = Number(m_charXML.magicChanceMax);
			if(maxValue > 0)
			{
				if(m_magicChance > maxValue)
				{
					m_magicChance = maxValue;
				}
			}
			m_magicValue = Number(m_charXML.magicValue) + (Number(m_charXML.magicValueBonus) * (level -1));
			m_magicValue += magicValueBonus + magicValueBonusPermanent;
			maxValue = Number(m_charXML.magicValueMax);
			if(maxValue > 0)
			{
				if(m_magicValue > maxValue)
				{
					m_magicValue = maxValue;
				}
			}
			//STRENGTHEN
			m_strengthenChance = Number(m_charXML.strengthenChance) + (Number(m_charXML.strengthenChanceBonus) * (level -1));
			m_strengthenChance += strengthenChanceBonus + strengthenChanceBonusPermanent;
			m_strengthenChance = int(m_strengthenChance * 100)/100;
			
			maxValue = Number(m_charXML.strengthenChanceMax);
			if(maxValue > 0)
			{
				if(m_strengthenChance > maxValue)
				{
					m_strengthenChance = maxValue;
				}
			}
			m_strengthenValue = Number(m_charXML.strengthenValue) + (Number(m_charXML.strengthenValueBonus) * (level -1));
			m_strengthenValue += strengthenValueBonus + strengthenValueBonusPermanent;
			m_strengthenValue = int(m_strengthenValue * 100)/100;
			
			maxValue = Number(m_charXML.strengthenValueMax);
			if(maxValue > 0)
			{
				if(m_strengthenValue > maxValue)
				{
					m_strengthenValue = maxValue;
				}
			}
			//WEAKEN
			m_weakenChance = Number(m_charXML.weakenChance) + (Number(m_charXML.weakenChanceBonus) * (level -1));
			m_weakenChance += weakenChanceBonus + weakenChanceBonusPermanent;
			m_weakenChance = int(m_weakenChance * 100)/100;
			
			maxValue = Number(m_charXML.weakenChanceMax);
			if(maxValue > 0)
			{
				if(m_weakenChance > maxValue)
				{
					m_weakenChance = maxValue;
				}
			}
			m_charXML.weakenValue = 1;
			m_weakenValue = Number(m_charXML.weakenValue) - (Number(m_charXML.weakenValueBonus) * (level -1));
			m_weakenValue -= (weakenValueBonus + weakenValueBonusPermanent);
			m_weakenValue = int(m_weakenValue * 100)/100;
			
			if(m_weakenValue == 0)
			{
				m_weakenValue = 1;
			}
			
			maxValue = Number(m_charXML.weakenValueMax);
			if(maxValue > 0)
			{
				if(m_weakenValue < maxValue)
				{
					m_weakenValue = maxValue;
				}
			}
			
			//REVERSE 
			m_reverseChance = Number(m_charXML.reverseChance) + (Number(m_charXML.reverseChanceBonus) * (level -1));
			m_reverseChance += reverseChanceBonus + reverseChanceBonusPermanent;
			m_reverseChance = int(m_reverseChance * 100)/100;
			
			maxValue = Number(m_charXML.reverseChanceMax);
			if(maxValue > 0)
			{
				if(m_reverseChance > maxValue)
				{
					m_reverseChance = maxValue;
				}
			}
			
			//LUCK
			m_luck = Number(m_charXML.luck) + (Number(m_charXML.luckBonus) * (level -1));
			m_luck = int(m_luck * 100)/100;
			maxValue = Number(m_charXML.luckMax);
			if(maxValue > 0)
			{
				if(m_luck > maxValue)
				{
					m_luck = maxValue;
				}
			}
			
			//POINTS
			if(!isPlayer)
			{
				m_points = Number(m_charXML.points) + (Number(m_charXML.pointsBonus) * (level -1));
				maxValue = Number(m_charXML.pointsMax);
				if(maxValue > 0)
				{
					if(m_points > maxValue)
					{
						m_points = maxValue;
					}
				}
			}
		}
		
		public function get nextExp():int
		{
			return m_nextExp;
		}
		
		public function get seizedExp():int
		{
			return m_seizedExp;
		}
		
		public function get currentExp():Number
		{
			return m_currentExp;
		}
		public function set currentExp(value:Number):void
		{
			m_currentExp = value;
		}
		
		public function levelUp():void
		{
			m_currentExp -= m_nextExp;
			level = m_level+1;
			m_isLevelingUp = true;
		}
		
		public function get isLevelingUp():Boolean
		{
			return m_isLevelingUp;
		}
		
		public function doneLevelUp():void
		{
			m_isLevelingUp = false;
		}
		
		private function calculateExp(arr:Array,untilLevel:int):int
		{
			var i:int = 0;
			var size:int = arr.length;
			var initialExp:int = int(m_charXML.exp);
			var currExp:int = initialExp;
			for(i;i<size;i++)
			{
				if(arr[i] == "exp")
				{
					currExp *= initialExp;
				}
				else if(arr[i] == "level")
				{
					currExp *= untilLevel-1;
				}
				else
				{
					currExp *= int(arr[i]);
				}
			}
			currExp += initialExp;
			return currExp;
		}
		
	
	}
}