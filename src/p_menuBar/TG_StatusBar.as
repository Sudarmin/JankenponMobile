package p_menuBar
{
	import com.greensock.TweenMax;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import p_entity.TG_Character;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class TG_StatusBar extends TG_MenuBar
	{
		private var m_name:TextField;
		private var m_healthBar:Image;
		private var m_healthBarFrame:Image;
		private var m_healthText:TextField;
		private var m_healthBarWidth:Number;
		
		//BLUE HERE COULD MEAN EXP OR TIME
		private var m_blueBar:Image;
		private var m_blueBarFrame:Image;
		private var m_blueText:TextField;
		private var m_healthString:String;
		private var m_blueString:String;
		private var m_blueBarWidth:Number;
		
		private var m_levelText:TextField;
		
		private var m_blueCounter:int = 0;
		private var m_blueTotal:int = 0;
		
		private var m_coinIcon:Image;
		private var m_coinFrame:Quad;
		private var m_coinText:TextField;
		private var m_coinSprite:Sprite;
		
		private var m_align:String = "right";
		
		private var m_char:TG_Character;
		private var m_lastHealth:int = 0;
		private var m_lastCoin:int = 0;
		
		private var m_expTargetTime:int = 2000;
		private var m_expTargetTimeCounter:Number = 0;
		private var m_expTarget:Number = 0;
		private var m_expManipulator:Number = 0;
		private var m_barWidthCounter:Number = 0;
		private var m_coinManipulator:Number = 0;
		private var m_coinTarget:Number = 0;
		private var m_coinTargetTimeCounter:Number = 0;
		private var m_nextExp:int = 0;
		private var m_currentExp:Number = 0;
		private var m_timeCounter:int = 0;
		private var m_timeTotal:int = 0;
		public function TG_StatusBar(parent:DisplayObjectContainer, gameState:TG_GameState,align:String = "left")
		{
			m_align = align;
			super(parent, gameState);
		}
		
		public override function init():void
		{
			super.init();
		}
		
		public override function destroy():void
		{
			super.destroy();
			m_char = null;
		}
		
		protected override function initSprite():void
		{
			super.initSprite();
			m_sprite = new Sprite();
			//NAME
			var str:String;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "PLAYER";
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "PEMAIN";
			}
			m_name = new TextField(100,60,str,"Londrina",35,0xFFFF00);
			m_name.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			m_sprite.addChild(m_name);
			
			//HEALTH BAR FRAME
			m_healthBarFrame = new Image(TG_World.assetManager.getTexture("HealthBarFrame"));
			m_healthBarFrame.y = m_name.y + m_name.height;
			m_sprite.addChild(m_healthBarFrame);
			
			//HEALTH BAR
			m_healthBar = new Image(TG_World.assetManager.getTexture("HealthBar"));
			m_healthBar.x = ((m_healthBarFrame.width - m_healthBar.width ) * 0.5 ) + m_healthBarFrame.x;
			m_healthBar.y = ((m_healthBarFrame.height - m_healthBar.height ) * 0.5 ) + m_healthBarFrame.y;
			m_sprite.addChild(m_healthBar);
			
			//TIME BAR FRAME
			m_blueBarFrame = new Image(TG_World.assetManager.getTexture("TimeBarFrame"));
			m_blueBarFrame.y = m_healthBarFrame.y + m_healthBarFrame.height;
			m_sprite.addChild(m_blueBarFrame);
			
			//TIME BAR
			m_blueBar = new Image(TG_World.assetManager.getTexture("TimeBar"));
			m_blueBar.x = ((m_blueBarFrame.width - m_blueBar.width ) * 0.5 ) + m_blueBarFrame.x;
			m_blueBar.y = ((m_blueBarFrame.height - m_blueBar.height ) * 0.5 ) + m_blueBarFrame.y;
			m_sprite.addChild(m_blueBar);
			
			//HEALTH TEXT
			m_healthText = new TextField(50,50,"100/100","Londrina",20,0xFFFFFF);
			m_healthText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			m_healthText.x = m_healthBar.x + (m_healthBar.width * 0.75);
			m_healthText.y = m_healthBar.y;
			m_sprite.addChild(m_healthText);
			
			//TIME TEXT
			m_blueText = new TextField(50,50,"100/100","Londrina",20,0xFFFFFF);
			m_blueText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			m_blueText.x = m_blueBar.x + (m_blueBar.width * 0.75);
			m_blueText.y = m_blueBar.y;
			m_sprite.addChild(m_blueText);
			
			//LEVEL TEXT
			m_levelText = new TextField(50,50,"Lvl 99","Londrina",30,0xFFFFFF);
			m_levelText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			m_levelText.x = m_healthBar.x;
			m_levelText.y = m_healthBar.y + ((m_healthBar.height + m_blueBar.height - m_levelText.height) * 0.5);
			m_sprite.addChild(m_levelText);
			
			//COIN
			m_coinSprite = new Sprite();
			m_coinIcon = new Image(TG_World.assetManager.getTexture("UI-Coins"));
			m_coinFrame = new Quad(100,100,0x272B42);
			m_coinText = new TextField(30,30,"9999","Londrina",20,0xFFFFFF);
			m_coinText.hAlign = HAlign.LEFT;
			m_coinText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			
			m_coinFrame.width = m_coinText.width + m_coinIcon.width + 10;
			m_coinFrame.height = m_coinText.height + 10;
			
			m_coinFrame.x = 0;
			m_coinFrame.y = (m_coinIcon.height - m_coinFrame.height) * 0.5;
			
			m_coinText.x = (m_coinIcon.x+m_coinIcon.width)+((m_coinFrame.width-m_coinIcon.width) - m_coinText.width) * 0.5;
			m_coinText.x -= 5;
			m_coinText.y = m_coinFrame.y+(m_coinFrame.height - m_coinText.height) * 0.5;
			
			m_coinSprite.addChild(m_coinFrame);
			m_coinSprite.addChild(m_coinIcon);
			m_coinSprite.addChild(m_coinText);
			m_sprite.addChild(m_coinSprite);
			
		}
		
		public override function resize():void
		{
			super.resize();
			m_name.scaleX = m_name.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_healthBarFrame.scaleX = m_healthBarFrame.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_healthBar.scaleX = m_healthBar.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_healthText.scaleX = m_healthText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_blueBarFrame.scaleX = m_blueBarFrame.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_blueBar.scaleX = m_blueBar.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_blueText.scaleX = m_blueText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_levelText.scaleX = m_levelText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			if(m_align == "right")
			{
				m_name.x = TG_World.GAME_WIDTH - m_name.width;
				m_name.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_healthBarFrame.x = TG_World.GAME_WIDTH - m_healthBarFrame.width;
				m_healthBarFrame.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_healthBar.x = ((m_healthBarFrame.width - m_healthBar.width ) * 0.5 ) + m_healthBarFrame.x;
				m_healthText.x = (m_healthBar.x) + ((10 *TG_World.SCALE_ROUNDED * 0.5));
				
				m_blueBarFrame.x = TG_World.GAME_WIDTH - m_blueBarFrame.width;
				m_blueBarFrame.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_blueBar.x = ((m_blueBarFrame.width - m_blueBar.width ) * 0.5 ) + m_blueBarFrame.x;
				m_blueText.x = (m_blueBar.x) + ((10 *TG_World.SCALE_ROUNDED * 0.5));
				
				m_levelText.x = TG_World.GAME_WIDTH - m_levelText.width;
				m_levelText.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_coinSprite.x = TG_World.GAME_WIDTH - m_coinSprite.width;
				m_coinSprite.x -= 2 * TG_World.SCALE_ROUNDED;
			}
			else if(m_align == "left")
			{
				m_name.x = 0;
				m_name.x += 2 * TG_World.SCALE_ROUNDED;
				m_healthBarFrame.x = 0;
				m_healthBarFrame.x += 2 * TG_World.SCALE_ROUNDED;
				m_healthBar.x = ((m_healthBarFrame.width - m_healthBar.width ) * 0.5 ) + m_healthBarFrame.x;
				m_healthText.x = (m_healthBar.x + m_healthBar.width) - (m_healthText.width + (10 *TG_World.SCALE_ROUNDED * 0.5));
				
				m_blueBarFrame.x = 0;
				m_blueBarFrame.x += 2 * TG_World.SCALE_ROUNDED;
				m_blueBar.x = ((m_blueBarFrame.width - m_blueBar.width ) * 0.5 ) + m_blueBarFrame.x;
				m_blueText.x = (m_blueBar.x + m_blueBar.width) - (m_blueText.width + (10 *TG_World.SCALE_ROUNDED * 0.5));
				
				m_levelText.x = m_healthBar.x;
				
				m_coinSprite.x = 0;
				m_coinSprite.x += 2 * TG_World.SCALE_ROUNDED;
			}
			m_name.y = 0;
			m_healthBarFrame.y = m_name.y + m_name.height;
			m_healthBar.y = ((m_healthBarFrame.height - m_healthBar.height ) * 0.5 ) + m_healthBarFrame.y;
			m_blueBarFrame.y = m_healthBarFrame.y + m_healthBarFrame.height;
			m_blueBar.y = ((m_blueBarFrame.height - m_blueBar.height ) * 0.5 ) + m_blueBarFrame.y;
			m_healthText.y = m_healthBar.y;
			m_blueText.y = m_blueBar.y;
			m_levelText.y = m_healthBar.y + ((m_healthBar.height + m_blueBar.height - m_levelText.height) * 0.5);
			m_levelText.y = m_healthBar.y + ((m_healthBar.height + m_blueBar.height - m_levelText.height) * 0.5);
			m_coinSprite.y = m_blueBarFrame.y + m_blueBarFrame.height;
			m_healthBarWidth = m_healthBar.width;
			m_blueBarWidth = m_blueBar.width;
			
			refreshAnimation();
		}
		
		public function calculateReduceExp():void
		{
			var targetExp:int = int(m_blueText.text);
			m_expManipulator = targetExp/m_expTargetTime;
			m_expTargetTimeCounter = targetExp;
			m_barWidthCounter = m_blueBarWidth/m_expTargetTime;
		}
		
		public function calculateReduceCoin():void
		{
			var targetCoin:int = m_char.points;
			m_coinTargetTimeCounter = targetCoin;
			m_coinManipulator = targetCoin/m_expTargetTime;
		}
		
		public function calculateAddExp(value:Number,total:int):void
		{
			m_expManipulator = value;
			m_expTargetTimeCounter = 0;
			m_expTarget = total;
		}
		
		public function calculateAddCoin(value:Number,total:int):void
		{
			m_coinManipulator = value;
			m_coinTargetTimeCounter = 0;
			m_coinTarget = total;
		}
		public function get expManipulator():Number
		{
			return m_expManipulator;
		}
		
		public function get coinManipulator():Number
		{
			return m_coinManipulator;
		}
		
		public function addExp(elapsedTime:int):Boolean
		{
			if(m_expTargetTimeCounter < m_expTarget)
			{
				m_expTargetTimeCounter += m_expManipulator * elapsedTime;
				m_currentExp += m_expManipulator * elapsedTime;
				m_char.currentExp = m_currentExp;
			}
			if(m_expTargetTimeCounter >= m_expTarget)
			{
				m_expTargetTimeCounter = m_expTarget;
			}
			m_blueText.text = ""+int(m_currentExp)+"/"+m_nextExp;
			m_blueBar.width = (m_currentExp/m_nextExp) * m_blueBarWidth;
			
			if(m_currentExp >= m_nextExp)
			{
				m_gameState.doSomething("levelUp");
			}
			if(m_expTargetTimeCounter >= m_expTarget)
			{
				return true;
			}
			return false;
		}
		public function addCoin(elapsedTime:int):Boolean
		{
			if(m_coinTargetTimeCounter < m_coinTarget)
			{
				m_coinTargetTimeCounter += m_coinManipulator * elapsedTime;
				m_char.points += m_expManipulator * elapsedTime;
			}
			if(m_coinTargetTimeCounter >= m_coinTarget)
			{
				m_coinTargetTimeCounter = m_coinTarget;
			}
			m_coinText.text = ""+int(m_char.points);
			resizeCoinText();
			
			if(m_coinTargetTimeCounter >= m_coinTarget)
			{
				return true;
			}
			return false;
		}
		
		public function reduceExp(elapsedTime:int):Boolean
		{
			m_blueBar.width -= m_barWidthCounter * elapsedTime;
			if(m_blueBar.width <= 0)
			{
				m_blueBar.width = 0;
			}
			m_expTargetTimeCounter -= m_expManipulator * elapsedTime;
			if(m_expTargetTimeCounter <= 0)
			{
				m_expTargetTimeCounter = 0;
			}
			m_blueText.text = ""+int(m_expTargetTimeCounter);
			if(m_expTargetTimeCounter <= 0)
			{
				return true;
			}
			return false;
		}
		
		public function reduceCoin(elapsedTime:int):Boolean
		{
			m_char.points -= m_coinManipulator * elapsedTime;
			if(m_blueBar.width <= 0)
			{
				m_blueBar.width = 0;
			}
			m_coinTargetTimeCounter -= m_coinManipulator * elapsedTime;
			if(m_coinTargetTimeCounter <= 0)
			{
				m_coinTargetTimeCounter = 0;
			}
			m_coinText.text = ""+int(m_char.points);
			if(m_coinTargetTimeCounter <= 0)
			{
				m_coinText.text = ""+int(0);
				return true;
			}
			return false;
		}
		public function get blueText():TextField
		{
			return m_blueText;
		}
		public function blueBarInvisible():void
		{
			m_blueBar.visible = false;
			m_blueBarFrame.visible = false;
		}
		public function setTime(value:int):void
		{
			m_timeTotal = value;
			m_timeCounter = 0;
			m_blueText.text = ""+int(m_timeTotal/1000)+"s";
			m_blueBar.width =  m_blueBarWidth;
			resizeExpAndHealthText();
		}
		public function setExp(current:Number,total:int):void
		{
			m_currentExp = current;
			m_blueText.text = ""+int(current)+"/"+total;
			m_blueBar.width = (current/total) * m_blueBarWidth;
			m_nextExp = total;
			resizeExpAndHealthText();
		}
		
		public function setSeizedExp(value:int):void
		{
			m_blueText.text = ""+value;
			m_blueBar.width =  m_blueBarWidth;
			resizeExpAndHealthText();
		}
		
		public function setLevel(value:int):void
		{
			m_levelText.text = "Lvl "+value;
			resizeExpAndHealthText();
		}
		public function resizeExpAndHealthText():void
		{
			if(m_align == "right")
			{
				m_healthText.x = (m_healthBar.x) + ((10 *TG_World.SCALE_ROUNDED * 0.5));
				m_blueText.x = (m_blueBar.x) + ((10 *TG_World.SCALE_ROUNDED * 0.5));
			}
			else if(m_align == "left")
			{
				m_healthText.x = (m_healthBar.x + m_healthBarWidth) - (m_healthText.width + (10 *TG_World.SCALE_ROUNDED * 0.5));
				m_blueText.x = (m_blueBar.x + m_blueBarWidth) - (m_blueText.width + (10 *TG_World.SCALE_ROUNDED * 0.5));
			}
		}
		public function resizeCoinText():void
		{
			m_coinFrame.width = m_coinText.width + m_coinIcon.width + 10;
			m_coinFrame.height = m_coinText.height + 10;
			
			m_coinFrame.x = 0;
			m_coinFrame.y = (m_coinIcon.height - m_coinFrame.height) * 0.5;
			
			m_coinText.x = (m_coinIcon.x+m_coinIcon.width)+((m_coinFrame.width-m_coinIcon.width) - m_coinText.width) * 0.5;
			m_coinText.x -= 5;
			m_coinText.y = m_coinFrame.y+(m_coinFrame.height - m_coinText.height) * 0.5;
			
			if(m_align == "right")
			{
				m_coinSprite.x = TG_World.GAME_WIDTH - m_coinSprite.width;
				m_coinSprite.x -= 2 * TG_World.SCALE_ROUNDED;
			}
			else if(m_align == "left")
			{
				m_coinSprite.x = 0;
				m_coinSprite.x += 2 * TG_World.SCALE_ROUNDED;
			}
			
		}
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
			if(m_char)
			{
				checkCharHealth(elapsedTime);
				checkCharCoins(elapsedTime);
				m_healthText.text = ""+m_char.health+"/"+m_char.initialHealth;
			}
		}
		
		public function setChar(char:TG_Character):void
		{
			m_char = char;
			m_lastHealth = m_char.health;
			m_healthText.text = ""+m_char.health+"/"+m_char.initialHealth;
			m_coinText.text = ""+m_char.points;
			m_lastCoin = m_char.points;
			resizeCoinText();
		}
		public function checkCharHealth(elapsedTime:int):void
		{
			var currentHealth:int = m_char.health;
			if(currentHealth != m_lastHealth)
			{
				
				var tweenMax:TweenMax = TweenMax.getTweensOf(m_healthBar)[0];
				if(tweenMax != null)
				{
					tweenMax.kill();
				}
				if(currentHealth < 0) currentHealth = 0;
				if(currentHealth > m_char.initialHealth)
				{
					currentHealth = m_char.initialHealth;
					
				}
				
				TweenMax.to(m_healthBar,1,{width:(currentHealth/m_char.initialHealth) * m_healthBarWidth});
				m_lastHealth = currentHealth;
			}
		}
		
		public function checkCharCoins(elapsedTime:int):void
		{
			var currentCoin:int = m_char.points;
			if(currentCoin != m_lastCoin)
			{
				var tweenMax:TweenMax = TweenMax.getTweensOf(m_coinText)[0];
				if(tweenMax != null)
				{
					tweenMax.kill();
				}
				TweenMax.to(m_coinText,1,{text:int(currentCoin),onUpdate:txtUpdate});
				m_lastCoin = currentCoin;
			}
		}
		
		private function txtUpdate():void
		{
			m_coinText.text = ""+int(m_coinText.text);
			resizeCoinText();
		}
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				var tween:TweenMax;
				if(m_align == "left")
				{
					tween = TweenMax.fromTo(m_sprite,0.3,{x:-m_sprite.width},{x:0});
				}
				else
				{
					tween = TweenMax.fromTo(m_sprite,0.3,{x:m_sprite.width},{x:0});
				}
				m_timeline.insert(tween,0);
				m_timeline.pause();
			}
		}
		public function invisible():void
		{
			m_sprite.visible = false;
		}
		public override function show():void
		{
			super.show();
			m_sprite.visible = true;
			if(m_timeline)
			{
				m_timeline.gotoAndPlay(0);
			}
			
			m_healthBar.width = m_healthBarWidth;
		}
		public override function hide():void
		{
			super.hide();
			if(m_timeline)
			{
				m_timeline.reverse();
			}
		}
		
		public function set name(str:String):void
		{
			m_name.text = str;
			if(m_align == "right")
			{
				m_name.x = TG_World.GAME_WIDTH - m_name.width;
				m_name.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_levelText.x = TG_World.GAME_WIDTH - m_levelText.width;
				m_levelText.x -= 2 * TG_World.SCALE_ROUNDED;
				
				m_coinSprite.x = TG_World.GAME_WIDTH - m_coinSprite.width;
				m_coinSprite.x -= 2 * TG_World.SCALE_ROUNDED;
			}
			else if(m_align == "left")
			{
				m_name.x = 0;
				m_name.x += 2 * TG_World.SCALE_ROUNDED;
				
				m_levelText.x = 0;
				m_levelText.x += 2 * TG_World.SCALE_ROUNDED;
				
				m_coinSprite.x = 0;
				m_coinSprite.x += 2 * TG_World.SCALE_ROUNDED;
			}
		}
	}
}