package p_entity
{
	import com.greensock.TweenMax;
	
	import p_engine.p_singleton.TG_World;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class TG_TreasureChest extends TG_Entity
	{
		private var m_treasureChestClip:MovieClip;
		private var m_itemClip:Image;
		
		private static var bonusString:Array;
		private static var bonusIndexes:Array;
		private static var lastQuantity:int;
		private static var xml:XML;
		private static var bonusObjs:Array;
		public function TG_TreasureChest(parent:DisplayObjectContainer)
		{
			super(parent);
			init();
		}
		
		public function initBonus():void
		{
			if(xml == null)
			{
				xml = TG_World.assetManager.getXml("Treasures");
			}
			
			if(bonusString == null)
			{
				bonusString = new Array();
				bonusIndexes = new Array();
				bonusObjs = new Array();
				lastQuantity = 0;
				var i:int = 0;
				var size:int = 0;
				
				var obj:Object;
				i = 0;
				size = xml.treasure.length();
				for(i;i<size;i++)
				{
					var id:String = xml.treasure[i].id;
					bonusString.push(id);
					var quantity:int = int(xml.treasure[i].quantity);
					lastQuantity += quantity;
					bonusIndexes.push(lastQuantity);
					if(bonusObjs[id] == null)
					{
						obj = new Object();
						obj.id = id;
						obj.nameEnglish = xml.treasure[i].nameEnglish;
						obj.nameIndonesia = xml.treasure[i].nameIndonesia;
						obj.imageName = xml.treasure[i].imageName;
						obj.image = new Image(TG_World.assetManager.getTexture(obj.imageName));
						obj.value1 = Number(xml.treasure[i].value1);
						obj.maxValue1 = Number(xml.treasure[i].maxValue1);
						obj.randomizeValue1 = int(xml.treasure[i].randomizeValue1);
						obj.randomValue1 = int(xml.treasure[i].randomValue1);
						obj.value2 = Number(xml.treasure[i].value2);
						obj.maxValue2 = Number(xml.treasure[i].maxValue2);
						obj.quantity = int(xml.treasure[i].quantity);
						obj.type = xml.treasure[i].type;
						bonusObjs[id] = obj;
						bonusObjs.push(obj);
						
						if(obj.randomizeValue1)
						{
							obj.value1 = obj.value1 + (Math.random() * 1000000) % obj.randomValue1;
						}
						
					}
					
				}
				
				
				
			}
		}
		
		public function getBonus(char:TG_Character):Object
		{
			removeMaxBonus(char);
			var rand:int = (Math.random() * 100000000) % (lastQuantity+1);
			var i:int = 0;
			var size:int = bonusIndexes.length;
			for(i;i<size;i++)
			{
				if(i == 0)
				{
					if(rand <= bonusIndexes[i])
					{
						rand = i;
						break;
					}
				}
				else
				{
					if(rand <= bonusIndexes[i] && rand > bonusIndexes[i-1])
					{
						rand = i;
						break;
					}
				}
				
				
			}
			var strBonus:String = bonusString[rand];
			var obj:Object = bonusObjs[strBonus];
			if(obj.randomizeValue1)
			{
				obj.value1 = obj.value1 + (Math.random() * 1000000) % obj.randomValue1;
			}
			return obj;
		}
		
		
		
		private function removeMaxBonus(char:TG_Character):void
		{
			var i:int = 0;
			var size:int = 0;
			var index:int = 0;
			i = 0;
			size = bonusObjs.length;
			for(i;i<size;i++)
			{
				var obj:Object = bonusObjs[i];
				var str:String = obj.id;
				switch(str)
				{
					case "gold": 
						break;
					case "bomb": 
						break;
					case "addhealth": 
						break;
					case "health": 
						break;
					case "damage": 
						break;
					case "critical": 
						if(char.critChance >= char.critChanceMax && char.critValue >= char.critValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "dmgReturn": 
						if(char.dmgReturnChance >= char.dmgReturnChanceMax && char.dmgReturnValue >= char.dmgReturnValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "heal":
						if(char.healChance >= char.healChanceMax && char.healValue >= char.healValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "evade":
						if(char.evadeChance >= char.evadeChanceMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "poison":
						if(char.poisonChance >= char.poisonChanceMax && char.poisonValue >= char.poisonValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "lifesteal":
						if(char.lifestealValue >= char.lifestealValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "magic":
						if(char.magicChance >= char.magicChanceMax && char.magicValue >= char.magicValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "strengthen":
						if(char.strengthenChance >= char.strengthenChanceMax && char.strengthenValue >= char.strengthenValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "weaken":
						if(char.weakenChance >= char.weakenChanceMax && char.weakenValue <= char.weakenValueMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
					case "reversed": 
						if(char.reverseChance >= char.reverseChanceMax)
						{
							index = removeFromArray(bonusString,str);
							sortIndexArray(bonusIndexes,index);
						}
						break;
				}
			}
		}
		
		private final function removeFromArray (array:Array,str:String):int 
		{
			var i:int = array.length - 1;
			for(i; i >= 0; i--) 
			{
				if(array[i] == str) 
				{
					array.splice(i,1);
					return i;
				}
			}
			return -1;
		}
		
		private final function sortIndexArray(array:Array,index:int):void 
		{
			if(index<0)return;
			var i:int = index+1;
			var size:int = array.length;
			var quantity:int = 0;
			if(index == 0)
			{
				quantity =  array[index];
			}
			else
			{
				quantity =  array[index] - array[index-1];
			}
			for(i; i < size; i++) 
			{
				array[i] -= quantity;
			}
			array.splice(index,1);
			lastQuantity -= quantity;
		}
		
		public override function init():void
		{
			m_treasureChestClip = new MovieClip(TG_World.assetManager.getTextures("TreasureClip"));
			m_treasureChestClip.stop();
			
			m_sprite = new Sprite();
			m_sprite.addChild(m_treasureChestClip);
			
			m_parent.addChild(m_sprite);
			initBonus();
		}
		
		public function get treasureChestClip():MovieClip
		{
			return m_treasureChestClip;
		}
		
		public function set itemClip(value:Image):void
		{
			m_itemClip = value;
		}
		
		public function show():void
		{
			m_sprite.visible = true;
			m_sprite.alpha = 1;
			m_treasureChestClip.currentFrame = 0;
		}
		
		public function hide():void
		{
			TweenMax.to(m_sprite,1,{alpha:0.1,onComplete:onHideComplete});
		}
		private function onHideComplete():void
		{
			m_sprite.visible = false;
			if(m_itemClip && m_itemClip.parent)
			{
				m_itemClip.parent.removeChild(m_itemClip);
			}
			m_itemClip = null;
		}
		public override function destroy():void
		{
			super.destroy();
			bonusString = null;
		}
				
	}
}