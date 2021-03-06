package p_gameState.p_inGameState
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import dragonBones.animation.WorldClock;
	
	import flash.profiler.showRedrawRegions;
	
	import p_engine.p_singleton.TG_GameManager;
	import p_engine.p_singleton.TG_World;
	
	import p_entity.TG_Character;
	import p_entity.TG_NPC;
	import p_entity.TG_TreasureChest;
	
	import p_gameState.TG_InGameState;
	import p_gameState.TG_StartMenuState;
	
	import p_menuBar.TG_QuestionTypeA;
	import p_menuBar.TG_RPSBar;
	import p_menuBar.TG_ShopBar;
	import p_menuBar.TG_StatusBar;
	import p_menuBar.TG_StatusInfoBar;
	import p_menuBar.TG_Warning;
	
	import p_singleton.TG_Status;
	
	import p_static.TG_Static;
	
	import starling.core.Starling;
	import starling.display.ButtonExtended;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	
	public class TG_SinglePlayerState extends TG_InGameState
	{
		private var m_createTreasureTest:Boolean = false;
		private var m_counterTime:int = 0;
		private var m_distanceCounter:Number = 0;
		private var m_distanceBeforeFindSomething:Number = 0.5;
		private var m_distancePause:Boolean = false;
		private var m_rpsBar:TG_RPSBar;
		private var m_statusBar1:TG_StatusBar;
		private var m_statusBar2:TG_StatusBar;
		private var m_question:TG_QuestionTypeA;
		
		private var m_char:TG_Character;
		private var m_owedRotation:Number = 0;
		private var m_enemy:TG_Character;
		private var m_npc:TG_NPC;
		private var m_princess:TG_NPC;
		private var m_princessCounter:int = 0;
		
		private var m_callBackFunc:Function;
		private var m_callBackFunc2:Function;
		private var m_callBackParams:Array;
		private var m_level:int = 2;
		private var m_quad:Quad;
		
		private var m_surprisedStrings:Array;
		private var m_distanceDifference:Number = 1;
		private var m_NPCdistanceDifference:Number = 0.5;
		private var m_PrincessdistanceDifference:Number = 0.5;
		private var m_treasureDistanceDifference:Number = 0.3;
		private var m_attackDistance:Number = 0.4;
		private var m_charRotationCounter:Number = 0;
		private var m_enemyRotationCounter:Number = 0;
		
		private var m_princessID:int = 0;
		
		private var m_animationCounter:int = 0;
		private var m_animationTime:int = 500;
		
		private var m_currentDynamicLayerRotationCounter:Number = 0;
		private var m_currentCharRotationCounter:Number = 0;
		
		private var m_charRotOffset:Number = 0.02;
		private var m_enemyRotOffset:Number = -0.02;
		
		private var m_clipAreaFX:MovieClip;
		private var m_clipAreaFX2:MovieClip;
		private var m_clipLevelUpFX:MovieClip;
		private var m_clipPoofFX:MovieClip;
		
		private var m_bulletNumCreated:int = 0;
		
		private var m_quadTop:Quad;
		private var m_quadBot:Quad;
		
		private var m_enemyCounter:int = 0;
		private var m_ableToShowNPC:Boolean = true;
		private var m_ableToChangeBG:Boolean = true;
		private var m_eventsXML:XML;
		private var m_eventCounter:int = 0;
		
		private var m_statusInfo:TG_StatusInfoBar;
		private var m_treasureChest:TG_TreasureChest;
		private var m_treasureChest2:TG_TreasureChest;
		private var m_currTreasureChest:TG_TreasureChest;
		private var m_warning:TG_Warning;
		
		private var m_shopBar:TG_ShopBar;
		private var m_rpsBarHided:Boolean = false;
		
		private var m_prevCharRotationBeforeBGChange:Number = 0;
		public function TG_SinglePlayerState(parent:DisplayObjectContainer)
		{
			super(parent);
		}
		
		protected function createBlackQuads():void
		{
			m_quadTop = new Quad(TG_World.GAME_WIDTH,60 * TG_World.SCALE_ROUNDED,0x000000);
			m_quadBot = new Quad(TG_World.GAME_WIDTH,60 * TG_World.SCALE_ROUNDED,0x000000);
			
			m_quadTop.visible = false;
			m_quadBot.visible = false;
			
			m_sprite.addChild(m_quadTop);
			m_sprite.addChild(m_quadBot);
			
		}
		
		protected function showBlackQuads():void
		{
			TweenMax.fromTo(m_quadTop,0.5,{y:-m_quadTop.height,visible:true},{y:0,ease:Circ.easeOut});
			TweenMax.fromTo(m_quadBot,0.5,{y:TG_World.GAME_HEIGHT,visible:true},{y:TG_World.GAME_HEIGHT-m_quadBot.height,ease:Circ.easeOut});
		}
		protected function hideBlackQuads():void
		{
			TweenMax.fromTo(m_quadTop,2,{y:0},{y:-m_quadTop.height,visible:false,ease:Circ.easeOut});
			TweenMax.fromTo(m_quadBot,2,{y:TG_World.GAME_HEIGHT-m_quadBot.height},{y:TG_World.GAME_HEIGHT,visible:false,ease:Circ.easeOut});
		}
		public override function init():void
		{
			super.init();
			
			m_enemyCounter = 0;
			m_eventCounter = 0;
			
			m_eventsXML = TG_World.assetManager.getXml("Events");
			
			
			m_shopBar = new TG_ShopBar(TG_Static.layerMenuBar,this);
			m_shopBar.sprite.visible = false;
			
			m_statusInfo = new TG_StatusInfoBar(TG_Static.layerMenuBar,this);
			m_statusInfo.sprite.visible = false;
			
			m_warning = new TG_Warning(TG_Static.layerMenuBar,this);
			m_warning.sprite.visible = false;
			
			
			
			m_clipPoofFX = new MovieClip(TG_World.assetManager.getTextures("FxPoofsAnim"));
			m_clipPoofFX.stop();
			m_clipPoofFX.pivotX = 55;
			m_clipPoofFX.pivotY = 120;
			m_clipPoofFX.visible = false;
			Starling.juggler.add(m_clipPoofFX);
			m_clipPoofFX.loop = false;
			
			m_clipAreaFX = new MovieClip(TG_World.assetManager.getTextures("FxHealPowerUp"));
			m_clipAreaFX.stop();
			m_clipAreaFX.pivotX = 43;
			m_clipAreaFX.pivotY = 84.5;
			m_clipAreaFX.visible = false;
			Starling.juggler.add(m_clipAreaFX);
			m_clipAreaFX.loop = false;
			
			m_clipAreaFX2 = new MovieClip(TG_World.assetManager.getTextures("FxHealPowerUp"));
			m_clipAreaFX2.stop();
			m_clipAreaFX2.pivotX = 43;
			m_clipAreaFX2.pivotY = 84.5;
			m_clipAreaFX2.visible = false;
			Starling.juggler.add(m_clipAreaFX2);
			m_clipAreaFX2.loop = false;
			
			m_clipLevelUpFX = new MovieClip(TG_World.assetManager.getTextures("FxLevelUp"));
			m_clipLevelUpFX.stop();
			m_clipLevelUpFX.pivotX = 185;
			m_clipLevelUpFX.pivotY = 280;
			m_clipLevelUpFX.visible = false;
			Starling.juggler.add(m_clipLevelUpFX);
			m_clipLevelUpFX.loop = false;
			
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				m_surprisedStrings = ["!!","Huh?!","Danger!","What's That?!","Enemy Sighted!"];
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				m_surprisedStrings = ["!!","Hah?!","Bahaya!","Apa itu?!","Musuh Terlihat!"];
			}
			m_char = new TG_Character(layerCharacter,"right","0");
			m_char.addEventListener(TG_Character.LOADED,onCharLoaded);
			m_char.isPlayer = true;
			createBlackQuads();
		}
		
		public override function destroy():void
		{
			super.destroy();
			if(m_quad)
			{
				m_quad.removeFromParent(true);
			}
			if(m_clipPoofFX)
			{
				if(Starling.juggler.contains(m_clipPoofFX))
				{
					Starling.juggler.remove(m_clipPoofFX);
				}
				if(m_clipPoofFX.parent)
				{
					m_clipPoofFX.parent.removeChild(m_clipPoofFX);
				}
			}
			
			if(m_clipAreaFX)
			{
				if(Starling.juggler.contains(m_clipAreaFX))
				{
					Starling.juggler.remove(m_clipAreaFX);
				}
				if(m_clipAreaFX.parent)
				{
					m_clipAreaFX.parent.removeChild(m_clipAreaFX);
				}
			}
			
			if(m_clipAreaFX2)
			{
				if(Starling.juggler.contains(m_clipAreaFX2))
				{
					Starling.juggler.remove(m_clipAreaFX2);
				}
				if(m_clipAreaFX2.parent)
				{
					m_clipAreaFX2.parent.removeChild(m_clipAreaFX2);
				}
			}
			
			if(m_clipLevelUpFX)
			{
				if(Starling.juggler.contains(m_clipLevelUpFX))
				{
					Starling.juggler.remove(m_clipLevelUpFX);
				}
				if(m_clipLevelUpFX.parent)
				{
					m_clipLevelUpFX.parent.removeChild(m_clipLevelUpFX);
				}
			}
			
			if(m_treasureChest)
			{
				m_treasureChest.destroy();
			}
			if(m_treasureChest2)
			{
				m_treasureChest2.destroy();
			}
			if(m_npc)
			{
				m_npc.destroy();
			}
			if(m_shopBar)
			{
				m_shopBar.destroy();
			}
		}
		
		private function onCharLoaded(e:Event):void
		{
			m_char.removeEventListener(TG_Character.LOADED,onCharLoaded);
			m_char.playAnimation("idle",0);
			m_char.moving = false;
			m_statusBar1.setChar(m_char);
			if(TG_Status.getInstance().characterExps[m_char.id] == null)
			{
				TG_Status.getInstance().characterExps[m_char.id] = 0;
			}
			var currentExp:int = TG_Status.getInstance().characterExps[m_char.id];
			if(TG_Status.getInstance().characterLevels[m_char.id] == null)
			{
				TG_Status.getInstance().characterLevels[m_char.id] = 1;
			}
			var currentLevel:int = TG_Status.getInstance().characterLevels[m_char.id];
			m_char.setLevel(currentLevel,true);
			m_statusBar1.setExp(currentExp,m_char.nextExp);
			m_statusBar1.setLevel(m_char.getLevel());
			showStartText();
		}
		protected override function onStartTextCompleted():void
		{
			super.onStartTextCompleted();
			if(multiFunctionText)
			{
				multiFunctionText.visible = false;
			}
			if(m_char)
			{
				m_char.playAnimation("walk",0);
				m_char.moving = true;
			}
			
		}
		
		protected override function initMenuBars():void
		{
			super.initMenuBars();
			m_rpsBar = new TG_RPSBar(m_sprite,this);
			m_rpsBar.invisible();
			m_statusBar1 = new TG_StatusBar(m_sprite,this,"left");
			m_statusBar2 = new TG_StatusBar(m_sprite,this,"right");
			m_statusBar2.invisible();
			m_question = new TG_QuestionTypeA(m_sprite,this);
			m_question.invisible();
		}
		
		protected function levelingUp():void
		{
			var textField:TextField;
			m_char.levelUp();
			m_statusBar1.setExp(m_char.currentExp,m_char.nextExp);
			m_statusBar1.setLevel(m_char.getLevel());
			textField = createText("Level Up",75,0x00FF00);
			layerCharacter.addChild(textField);
			textField.rotation = m_char.rotation;
			textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:(textField.pivotY+(250*textField.scaleY))/textField.scaleY,alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
			
			levelUpFX(m_char);
			
		}
		
		protected function levelUpFX(char:TG_Character):void
		{
			m_clipLevelUpFX.visible = true;
			m_clipLevelUpFX.currentFrame = 1;
			m_clipLevelUpFX.play();
			m_clipLevelUpFX.scaleX = char.sprite.scaleX * 2;
			m_clipLevelUpFX.scaleY = char.sprite.scaleY * 2;
			//m_clipLevelUpFX.color = 0xEEEE00;
			char.sprite.addChild(m_clipLevelUpFX);
			m_char.playAnimation("celebrate");
			var posX:Number = 0;
			var posY:Number = 0;
			m_statusInfo.changeTexts("STATUS",m_char.descs);
			posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width);
			posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
			if(!m_statusInfo.sprite.visible)
			{
				TweenMax.fromTo(m_statusInfo.sprite,0.5,{x:posX,y:-m_statusInfo.sprite.height,visible:true},{x:posX,y:posY});
				m_statusInfo.nextSprite.visible = false;
				m_statusInfo.nextSprite.addEventListener(Event.TRIGGERED,onPlayerStatsClicked);
			}
			
			
		}
		protected function onPlayerStatsClicked(e:Event = null):void
		{
			m_statusInfo.nextSprite.removeEventListener(Event.TRIGGERED,onPlayerStatsClicked);
			TweenMax.to(m_statusInfo.sprite,0.5,{y:TG_World.GAME_HEIGHT,visible:false});
			m_char.playAnimation("walk");
			m_callBackFunc = moveUntilPlayerAtTheMiddle;
			m_char.doneLevelUp();
		}
		
		public override function doSomething(str:String):void
		{
			switch(str)
			{
				case"rockPressed":
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(0);
					break;
				case"paperPressed":
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(1);
					break;
				case"scissorPressed":
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(2);
					break;
				case"levelUp":
					levelingUp();
					break;
			}
		}
		
		protected override function updateInput():void
		{
			super.updateInput();
			if(m_keyPoll)
			{
				//Q
				if(m_keyPoll.isDown(81) && !m_keyArray[81])
				{
					m_keyArray[81] = true;
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(0);
				}
				if(m_keyPoll.isUp(81) && m_keyArray[81])
				{
					m_keyArray[81] = false;
				}
				
				//W
				if(m_keyPoll.isDown(87) && !m_keyArray[87])
				{
					m_keyArray[87] = true;
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(1);
				}
				if(m_keyPoll.isUp(87) && m_keyArray[87])
				{
					m_keyArray[87] = false;
				}
				
				//E
				if(m_keyPoll.isDown(69) && !m_keyArray[69])
				{
					m_keyArray[69] = true;
					if(!m_question.isTimeOut())
					m_question.putNextAnswer(2);
				}
				if(m_keyPoll.isUp(69) && m_keyArray[69])
				{
					m_keyArray[69] = false;
				}
			}
		}
	
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
			WorldClock.clock.advanceTime(elapsedTime/1000);
			if(m_char)
			{
				m_char.update(elapsedTime);
				if(m_char.isMoving)
				{
					m_char.rotation += m_char.speed * elapsedTime/1000;
					layerNormalground.rotation -= (m_char.speed) * elapsedTime/1000;
					layerCharacter.rotation -= (m_char.speed) * elapsedTime/1000;
					layerForeground.rotation -= (m_char.speed * 1.75) * elapsedTime/1000;
					layerBackground.rotation -= (m_char.speed * 0.25) * elapsedTime/1000;
					checkLayersRotation();
					checkCharRotation();
					if(!m_distancePause)
					{
						m_distanceCounter += m_char.speed * elapsedTime/1000;
						if(m_distanceCounter >= m_distanceBeforeFindSomething)
						{
							m_distancePause = true;
							m_distanceCounter = 0;
							
							/*if(m_createTreasureTest)
							{
								createSomething("treasure");
							}
							else
							{
								createSomething("enemy");
							}
							m_createTreasureTest = !m_createTreasureTest;*/
							//createSomething("princess");
							//createSomething("treasure");
							if(m_enemyCounter % 2 == 0 && m_enemyCounter != 0 && m_ableToShowNPC)
							{
								createSomething("npc");
								m_ableToShowNPC = false;
							}
							else if(m_enemyCounter % 1 == 0 && m_enemyCounter != 0 &&  m_ableToChangeBG)
							{
								changeBGInit();
								m_ableToChangeBG = false;
							}
							else
							{
								trace("ke sini 3");
								var rand:Number = (Math.random() * 10000) % 200;
								if(rand < m_char.luck)
								{
									createSomething("treasure");
								}
								else
								{
									createSomething("enemy");
									m_ableToShowNPC = true;
									m_ableToChangeBG = true;
								}
							}
							
							
						}
					}
				}
			}
			
			if(m_enemy)
			{
				m_enemy.update(elapsedTime);
			}
			
			if(m_callBackFunc != null)
			{
				m_callBackFunc(elapsedTime);
			}
			if(m_callBackFunc2 != null)
			{
				m_callBackFunc2(elapsedTime);
			}
		}
		
		protected function changeBGInit():void
		{
			if(m_quad == null)
			{
				m_quad = new Quad(100,100,0x000000);
				m_sprite.addChild(m_quad);
				/*if(m_quadTop)
				{
					m_sprite.swapChildren(m_quad,m_quadTop);
				}*/
			}
			
			
			m_quad.width = TG_World.GAME_WIDTH;
			m_quad.height = TG_World.GAME_HEIGHT;
			m_quad.alpha = 0;
			m_quad.visible = true;
			showBlackQuads();
			m_char.moving = false;
			m_prevCharRotationBeforeBGChange = m_char.rotation;
			m_callBackFunc = charMoveBGInit;
			TweenMax.to(m_quad,3,{alpha:1,onComplete:changeBGMid});
		}
		protected function charMoveBGInit(elapsedTime:int):void
		{
			m_char.rotation += m_char.speed * elapsedTime/1000;
		}
		protected function changeBGMid():void
		{
			restartBackground();
			m_callBackFunc = checkLoadBGDone;
		}
		protected function checkLoadBGDone(elapsedTime:int):void
		{
			if(loadBGDone)
			{
				TweenMax.to(m_quad,2,{alpha:0.1,onComplete:changeBGEnd});
				m_char.rotation = m_prevCharRotationBeforeBGChange - 1.5;
				m_callBackFunc = charMoveBGEnd;
			}
		}
		protected function changeBGEnd():void
		{
			m_quad.visible = false;
			
		}
		protected function charMoveBGEnd(elapsedTime:int):void
		{
			m_char.rotation += m_char.speed * elapsedTime/1000;
			if(m_char.rotation >= m_prevCharRotationBeforeBGChange)
			{
				m_char.rotation = m_prevCharRotationBeforeBGChange;
				m_distancePause = false;
				m_callBackFunc = null;
				m_char.moving = true;
				hideBlackQuads();
			}
		}
		
		protected function checkLayersRotation():void
		{
			checkRotation(layerNormalground);
			checkRotation(layerCharacter);
			checkRotation(layerForeground);
			checkRotation(layerBackground);
		}
		
		protected function checkRotation(displayObj:DisplayObject):void
		{
			if(displayObj.rotation >= TG_Static.fullCircleRad)
			{
				displayObj.rotation = displayObj.rotation - TG_Static.fullCircleRad;
			}
			else if(displayObj.rotation <= -TG_Static.fullCircleRad)
			{
				displayObj.rotation = displayObj.rotation - TG_Static.fullCircleRad;
			}
		}
		
		protected function checkCharRotation():void
		{
			if(m_char)
			{
				var refreshRotation:Boolean = false;
				if(m_char.rotation >= TG_Static.fullCircleRad)
				{
					refreshRotation = true;
					
				}
				else if(m_char.rotation <= -TG_Static.fullCircleRad)
				{
					refreshRotation = true;
				}
				
				if(refreshRotation)
				{
					m_char.rotation = m_char.rotation - TG_Static.fullCircleRad;
					if(m_enemy)
					{
						m_enemy.rotation = m_enemy.rotation - TG_Static.fullCircleRad;
					}
					if(m_npc)
					{
						m_npc.rotation = m_npc.rotation - TG_Static.fullCircleRad;
					}
					if(m_treasureChest)
					{
						m_treasureChest.rotation = m_treasureChest.rotation - TG_Static.fullCircleRad;
					}
					if(m_treasureChest2)
					{
						m_treasureChest2.rotation = m_treasureChest2.rotation - TG_Static.fullCircleRad;
					}
				}
			}
		}
		
		private function createSomething(command:String):void
		{
			m_princessID = 0;
			if(m_eventsXML.event[m_eventCounter])
			{
				trace("after battle = "+int(m_eventsXML.event[m_eventCounter].afterBattles));
			}
			if(command == "enemy")
			{
				var charID:String = "";
				if(m_eventsXML.event[m_eventCounter])
				{
					if(m_enemyCounter >= int(m_eventsXML.event[m_eventCounter].afterBattles))
					{
						trace("boss is coming");
						charID = m_eventsXML.event[m_eventCounter].charID;
						m_princessID = int(m_eventsXML.event[m_eventCounter].princessID);
						m_eventCounter++;
					}
				}
				createEnemy(charID);
			}
			else if(command == "treasure")
			{
				if(m_treasureChest == null)
				{
					m_treasureChest = new TG_TreasureChest(layerCharacter);
					m_treasureChest.sprite.pivotY = m_char.sprite.pivotY + 100;
					m_treasureChest.sprite.visible = false;
				}
				if(m_treasureChest2 == null)
				{
					m_treasureChest2 = new TG_TreasureChest(layerCharacter);
					m_treasureChest2.sprite.pivotY = m_char.sprite.pivotY + 100;
					m_treasureChest2.sprite.visible = false;
				}
				
				m_currTreasureChest = m_treasureChest;
				if(m_treasureChest.sprite.visible)
				{
					m_currTreasureChest = m_treasureChest2;
				}
				m_currTreasureChest.show();
				m_currTreasureChest.rotation = m_char.rotation + 1.2;
				m_callBackFunc = checkTreasureDistance;
			}
			else if(command == "npc")
			{
				createNPC();
			}
			else if(command == "princess")
			{
				createPrincess(1);
			}
		}
		
		private function createPrincess(no:int):void
		{
			if(m_princess)
			{
				m_princess.destroy();
			}
			m_princess = new TG_NPC(layerCharacter,"left",no);
			m_princess.addEventListener(TG_Character.LOADED,onPrincessLoaded);
		}
		private function onPrincessLoaded(e:Event = null):void
		{
			m_princess.removeEventListener(TG_Character.LOADED,onPrincessLoaded);
			
			m_princess.playAnimation("idle",0);
			m_princess.rotation = m_char.rotation + 0.6;
			
			m_princess.sprite.alpha = 0;
			TweenMax.fromTo(m_princess.sprite,2,{alpha:1},{alpha:1,ease:Circ.easeIn,onComplete:showPrincessText});
			
			m_clipPoofFX.visible = true;
			m_clipPoofFX.currentFrame = 1;
			m_clipPoofFX.play();
			m_clipPoofFX.scaleX = m_princess.sprite.scaleX * 1.5;
			m_clipPoofFX.scaleY = m_princess.sprite.scaleY * 1.5;
			m_princess.sprite.addChild(m_clipPoofFX);
			
			
			
			
			
			
			m_callBackFunc = checkCharPrincessDistance;
		}
		
		private function checkCharPrincessDistance(elapsedTime:int):void
		{
			if(m_princess && m_char)
			{
				var difference:Number = 0;
				if(m_princess.rotation > m_char.rotation)
				{
					difference = m_princess.rotation - m_char.rotation;
				}
				else
				{
					difference = m_char.rotation - m_princess.rotation;
				}
				if(difference <= m_PrincessdistanceDifference)
				{
					m_char.moving = false;
					m_char.playAnimation("idle");
					m_callBackFunc = updateDynamicLayerRotationPrincess;
					
					m_charRotationCounter = 0;
					m_currentCharRotationCounter = 0;
					m_currentDynamicLayerRotationCounter = 0;
					
					showBlackQuads();
				}
			}
			
		}
		
		private function updateDynamicLayerRotationPrincess(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_princess.rotation - m_char.rotation;
			if(difference < m_PrincessdistanceDifference)
			{
				difference = m_PrincessdistanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_PrincessdistanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 0.5;
			m_callBackFunc = null;
			TweenMax.fromTo(layerDynamic,0.4,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 0.5)});
			
		}
		
		private function showPrincessText():void
		{
			hideBlackQuads();
			if(m_clipPoofFX && m_clipPoofFX.parent)
			{
				m_clipPoofFX.stop();
				m_clipPoofFX.parent.removeChild(m_clipPoofFX);
			}
			var str:String = "";
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = m_princess.xml.chatEnglish;
			}
			else
			{
				str = m_princess.xml.chatIndonesia;
			}
			m_princess.showText(str,true);
			m_callBackFunc = princessIdle;
		}
		
		private function princessIdle(elapsedTime:int):void
		{
			m_counterTime += elapsedTime;
			if(m_counterTime >= 500)
			{
				m_counterTime = 0;
				m_princess.playAnimation("walk");
				m_callBackFunc = null;
				m_callBackFunc2 = princessMove;
				
				var str:String = "";
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You saved "+m_princess.xml.nameEnglish;
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu menyelamatkan "+m_princess.xml.nameIndonesia;
				}
				
				var textField:TextField = createText(str,40,0xFFFF00);
				layerCharacter.addChild(textField);
				textField.rotation = m_char.rotation + m_charRotOffset * 10;
				textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
				if(TG_Status.getInstance().princessSaved[m_char.charNo] == null)
				{
					TG_Status.getInstance().princessSaved[m_char.charNo] = [];
				}
				if(TG_Status.getInstance().princessSaved[m_char.charNo][m_princessCounter] == null)
				{
					TG_Status.getInstance().princessSaved[m_char.charNo][m_princessCounter] = 1;
					textField = createText(getBonusText(),40,0xFFFF00);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation + m_charRotOffset * 10;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					textField.visible = false;
					TweenMax.to(textField,1,{onComplete:showPrincessBonusText,onCompleteParams:[textField]});
					
				}
				
				var posX:Number = 0;
				var posY:Number = 0;
				m_statusInfo.changeTexts("STATUS",m_char.descs);
				posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width);
				posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
				if(!m_statusInfo.sprite.visible)
				{
					TweenMax.fromTo(m_statusInfo.sprite,0.5,{x:posX,y:-m_statusInfo.sprite.height,visible:true},{x:posX,y:posY});
					m_statusInfo.nextSprite.addEventListener(Event.TRIGGERED,onPrincessStatsBonusClicked);
				}
			}
		}
		
		private function showPrincessBonusText(textField:TextField):void
		{
			textField.visible = true;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
		}
		
		private function getBonusText():String
		{
			var str:String = "";
			if(m_princessCounter == 0)
			{
				str = parseBonusText(m_char.xml.bonus0id,Number(m_char.xml.bonus0value1),Number(m_char.xml.bonus0value2));
			}
			else if(m_princessCounter == 1)
			{
				str = parseBonusText(m_char.xml.bonus1id,Number(m_char.xml.bonus1value1),Number(m_char.xml.bonus1value2));
			}
			else if(m_princessCounter == 2)
			{
				str = parseBonusText(m_char.xml.bonus2id,Number(m_char.xml.bonus2value1),Number(m_char.xml.bonus2value2));
			}
			else if(m_princessCounter == 3)
			{
				str = parseBonusText(m_char.xml.bonus3id,Number(m_char.xml.bonus3value1),Number(m_char.xml.bonus3value2));
			}
			else if(m_princessCounter == 4)
			{
				str = parseBonusText(m_char.xml.bonus4id,Number(m_char.xml.bonus4value1),Number(m_char.xml.bonus4value2));
			}
			else if(m_princessCounter == 5)
			{
				str = parseBonusText(m_char.xml.bonus5id,Number(m_char.xml.bonus5value1),Number(m_char.xml.bonus5value2));
			}
			return str;
		}
		private function parseBonusText(text:String,value1:Number,value2:Number):String
		{
			var str:String = "";
			if(text == "damage")
			{
				m_char.damageBonusPermanent += value1;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+" permanent damage";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+" pukulan permanen";
				}
				m_char.recalculateStats();
			}
			else if(text == "health")
			{
				m_char.healthBonusPermanent += value1;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+" permanent health";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+" darah permanen";
				}
				m_char.recalculateStats();
			}
			else if(text == "critical")
			{
				m_char.criticalChanceBonusPermanent += value1;
				m_char.criticalValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent critical chance and +"+value2+"% critical damage";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans kritikal permanen dan +"+value2+"% pukulan kritikal";
				}
				m_char.recalculateStats();
			}
			else if(text == "poison")
			{
				m_char.poisonChanceBonusPermanent += value1;
				m_char.poisonValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent poison chance and +"+value2+" poison damage";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans racun permanen dan +"+value2+" pukulan racun";
				}
				m_char.recalculateStats();
			}
			else if(text == "heal")
			{
				m_char.healChanceBonusPermanent += value1;
				m_char.healValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent heal chance and +"+value2+" heal value";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans sembuh permanen dan +"+value2+" nilai sembuh";
				}
				m_char.recalculateStats();
			}
			else if(text == "evade")
			{
				m_char.evadeChanceBonusPermanent += value1;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent evade chance";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans menghindar permanen";
				}
				m_char.recalculateStats();
			}
			else if(text == "lifeSteal")
			{
				m_char.lifestealValueBonusPermanent += value1;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent life steal";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% curi darah permanen";
				}
				m_char.recalculateStats();
			}
			else if(text == "magic")
			{
				m_char.magicChanceBonusPermanent += value1;
				m_char.magicValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent magic chance and +"+value2+" magic damage";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans sihir permanen dan +"+value2+" pukulan sihir";
				}
				m_char.recalculateStats();
			}
			else if(text == "reversed")
			{
				m_char.reverseChanceBonusPermanent += value1;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent counter attack";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% pukulan balik permanen";
				}
				m_char.recalculateStats();
			}
			else if(text == "strengthen")
			{
				m_char.strengthenChanceBonusPermanent += value1;
				m_char.strengthenValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent strengthen chance and +"+value2+"% strengthen value";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans menguatkan permanen dan +"+value2+"% nilai menguatkan";
				}
				m_char.recalculateStats();
			}
			else if(text == "weaken")
			{
				m_char.weakenChanceBonusPermanent += value1;
				m_char.weakenValueBonusPermanent += value2;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "You gained +"+value1+"% permanent weaken chance and +"+value2+"% weaken value";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Kamu mendapatkan +"+value1+"% kans melemahkan permanen dan +"+value2+"% nilai melemahkan";
				}
				m_char.recalculateStats();
			}
			return str;
		}
		
		private function princessMove(elapsedTime:int):void
		{
			
			m_counterTime += elapsedTime;
			if(m_counterTime >= 5000)
			{
				m_counterTime = 0;
				m_princess.playAnimation("idle");
				m_princess.hide();
				m_callBackFunc2 = null;
			}
			else
			{
				m_princess.rotation -= m_char.speed * 0.5 * elapsedTime/1000;
			}
		}
		
		private function onPrincessStatsBonusClicked(e:Event):void
		{
			m_statusInfo.nextSprite.removeEventListener(Event.TRIGGERED,onPrincessStatsBonusClicked);
			TweenMax.to(m_statusInfo.sprite,0.5,{y:TG_World.GAME_HEIGHT,visible:false});
			m_char.playAnimation("walk");
			m_princessID = 0;
			m_callBackFunc = moveUntilPlayerAtTheMiddle;
		}
		
		private function createNPC():void
		{
			if(m_npc == null)
			{
				m_npc = new TG_NPC(layerCharacter,"left",0);
				m_npc.addEventListener(TG_Character.LOADED,onNPCLoaded);
			}
			else
			{
				onNPCLoaded();
			}
		}
		
		private function onNPCLoaded(e:Event = null):void
		{
			m_npc.removeEventListener(TG_Character.LOADED,onNPCLoaded);
			
			m_npc.playAnimation("idle",0);
			m_npc.rotation = m_char.rotation + 1.4;
			
			m_npc.sprite.alpha = 0;
			TweenMax.fromTo(m_npc.sprite,1,{alpha:0.1},{alpha:1,ease:Circ.easeIn});
			layerCharacter.swapChildren(m_npc.sprite,m_char.sprite);
			
			m_callBackFunc = checkCharNPCDistance;
		}
		
		private function checkCharNPCDistance(elapsedTime:int):void
		{
			if(m_npc && m_char)
			{
				var difference:Number = 0;
				if(m_npc.rotation > m_char.rotation)
				{
					difference = m_npc.rotation - m_char.rotation;
				}
				else
				{
					difference = m_char.rotation - m_npc.rotation;
				}
				if(difference <= m_NPCdistanceDifference)
				{
					m_char.moving = false;
					m_char.playAnimation("idle");
					m_callBackFunc = updateDynamicLayerRotationNPC;
					
					m_charRotationCounter = 0;
					m_currentCharRotationCounter = 0;
					m_currentDynamicLayerRotationCounter = 0;
				}
			}
			
		}
		
		private function updateDynamicLayerRotationNPC(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_npc.rotation - m_char.rotation;
			if(difference < m_NPCdistanceDifference)
			{
				difference = m_NPCdistanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_NPCdistanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 0.5;
			m_callBackFunc = null;
			TweenMax.fromTo(layerDynamic,0.4,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 0.5),onComplete:onDynamicLayerRotatedNPC});
			
		}
		
		private function onDynamicLayerRotatedNPC():void
		{
			m_char.recalculateStats();
			m_shopBar.setChar(m_char);
			m_shopBar.initShopItems();
			
			var nextSprite:Sprite = m_shopBar.getNextButton();
			var buySprite:Sprite = m_shopBar.getBuyButton();
			
			nextSprite.addEventListener(TouchEvent.TOUCH,onBMNextClicked);
			buySprite.addEventListener(TouchEvent.TOUCH,onBMBuyClicked);
			
			var middleX:Number = (TG_World.GAME_WIDTH - m_shopBar.sprite.width) * 0.5;
			var middleY:Number = 20 * TG_World.SCALE;
		
			TweenMax.fromTo(m_shopBar.sprite,0.5,{visible:true,x:middleX,y:-m_shopBar.sprite.height},{x:middleX,y:middleY});
		
			var posX:Number = 0;
			var posY:Number = 0;
			//m_statusInfo.changeText("STATUS",m_char.desc);
			m_statusInfo.changeTexts("STATUS",m_char.descs);
			posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width);
			posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
			if(!m_statusInfo.sprite.visible)
			{
				TweenMax.fromTo(m_statusInfo.sprite,0.5,{x:posX,y:-m_statusInfo.sprite.height,visible:true},{x:posX,y:posY});
				m_statusInfo.nextSprite.visible = false;
			}
		}
		
		private function onBMNextClicked(e:TouchEvent):void
		{
			var nextSprite:Sprite = m_shopBar.getNextButton();
			var buySprite:Sprite = m_shopBar.getBuyButton();
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var num:int = int(Sprite(e.currentTarget).name);
			
			if(touch)
			{
				var touchPhase:String = touch.phase;
				if(touchPhase == TouchPhase.ENDED)
				{
					nextSprite.removeEventListener(TouchEvent.TOUCH,onBMNextClicked);
					buySprite.removeEventListener(TouchEvent.TOUCH,onBMBuyClicked);
					m_char.playAnimation("walk");
					m_char.recalculateStats();
					m_callBackFunc = moveUntilPlayerAtTheMiddle;
					
					var middleX:Number = (TG_World.GAME_WIDTH - m_shopBar.sprite.width) * 0.5;
					var middleY:Number = 20 * TG_World.SCALE;
					
					TweenMax.to(m_shopBar.sprite,0.5,{x:middleX,y:-m_shopBar.sprite.height,visible:true});
					
					if(m_statusInfo.sprite.visible)
					{
						TweenMax.to(m_statusInfo.sprite,0.5,{y:TG_World.GAME_HEIGHT,visible:false});
					}
				}
				
			}
			
		}
		
		private function onBMBuyClicked(e:TouchEvent):void
		{
			var nextSprite:Sprite = m_shopBar.getNextButton();
			var buySprite:Sprite = m_shopBar.getBuyButton();
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var num:int = int(Sprite(e.currentTarget).name);
			
			if(touch)
			{
				var touchPhase:String = touch.phase;
				if(touchPhase == TouchPhase.ENDED)
				{
					var obj:Object = m_shopBar.buyCurrentItem();
					var textField:TextField;
					if(obj)
					{
						m_shopBar.addBonusToUser(obj);
						levelUpFX(m_char);
						textField = createText(obj.name,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation + m_charRotOffset * -10;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					else
					{
						textField = createText("NOT ENOUGH GOLD",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation + m_charRotOffset * -10;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
				}
				
			}
		}
		
		private function createEnemy(charID:String = "",exceptionID:String = ""):void
		{
			m_enemy = new TG_Character(layerCharacter,"left",charID,m_char.id);
			m_enemy.addEventListener(TG_Character.LOADED,onEnemyLoaded);
		}
		
		private function onEnemyLoaded(e:Event):void
		{
			m_enemy.removeEventListener(TG_Character.LOADED,onEnemyLoaded);
			
			m_enemy.playAnimation("idle",0);
			m_enemy.rotation = m_char.rotation + 1.2;
			m_enemy.sprite.alpha = 0;
			m_statusBar2.setChar(m_enemy);
			
			if(m_enemy.isBoss)
			{
				m_enemy.setLevel(m_enemy.xml.level,true);
			}
			else
			{
				m_enemy.setLevel(((Math.random() * 100000) % 4) + m_char.getLevel(),true);
			}
			
			m_statusBar2.setSeizedExp(m_enemy.seizedExp);
			m_statusBar2.setLevel(m_enemy.getLevel());
			m_statusBar2.calculateReduceExp();
			
			TweenMax.fromTo(m_enemy.sprite,1,{alpha:0.1},{alpha:1,ease:Circ.easeIn});
			layerCharacter.swapChildren(m_enemy.sprite,m_char.sprite);
			m_callBackFunc = checkCharEnemyDistance;
		}
		
		private function checkCharEnemyDistance(elapsedTime:int):void
		{
			if(m_enemy && m_char)
			{
				var difference:Number = 0;
				if(m_enemy.rotation > m_char.rotation)
				{
					difference = m_enemy.rotation - m_char.rotation;
				}
				else
				{
					difference = m_char.rotation - m_enemy.rotation;
				}
				
				if(difference <= m_distanceDifference)
				{
					m_char.moving = false;
					m_char.playAnimation("battle");
					m_enemy.playAnimation("battle");
					var randNum:int = (Math.random() * 10000) % m_surprisedStrings.length;
					var string:String = m_surprisedStrings[randNum];
					reuseText(string,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
					TweenMax.fromTo(multiFunctionText,0.1,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onSurprisedTextCreated,ease:Circ.easeOut});
					m_callBackFunc = null;
					
					m_charRotationCounter = 0;
					m_currentCharRotationCounter = 0;
					m_currentDynamicLayerRotationCounter = 0;
					
				}
			}
		}
		
		private function checkTreasureDistance(elapsedTime:int):void
		{
			if(m_currTreasureChest && m_char)
			{
				var difference:Number = 0;
				if(m_currTreasureChest.rotation > m_char.rotation)
				{
					difference = m_currTreasureChest.rotation - m_char.rotation;
				}
				else
				{
					difference = m_char.rotation - m_currTreasureChest.rotation;
				}
				
				if(difference <= m_treasureDistanceDifference)
				{
					m_char.moving = false;
					m_char.playAnimation("idle");
					m_callBackFunc = updateDynamicLayerRotationTreasureChest;
				}
			}
		}
		
		private function updateDynamicLayerRotationTreasureChest(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_currTreasureChest.rotation - m_char.rotation;
			if(difference < m_treasureDistanceDifference)
			{
				difference = m_treasureDistanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_treasureDistanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 0.5;
			TweenMax.fromTo(layerDynamic,0.4,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 0.5),onComplete:onDynamicLayerRotatedTreasureChest});
			m_callBackFunc = null;
			
		}
		
		private function onDynamicLayerRotatedTreasureChest():void
		{
			m_warning.showCommand("Do you want to open the treasure chest?",true);
			m_warning.okButton.addEventListener(Event.TRIGGERED,onTreasureChestOkButton);
			m_warning.cancelButton.addEventListener(Event.TRIGGERED,onTreasureChestCancelButton);
		}
		
		private function onTreasureChestOkButton(e:Event):void
		{
			m_currTreasureChest.treasureChestClip.currentFrame = 1;
			m_char.playAnimation("celebrate");
			m_warning.hide();
			
			m_warning.okButton.removeEventListener(Event.TRIGGERED,onTreasureChestOkButton);
			m_warning.cancelButton.removeEventListener(Event.TRIGGERED,onTreasureChestCancelButton);
			openTreasureChest();
		}
		
		private function onTreasureChestCancelButton(e:Event):void
		{
			m_currTreasureChest.hide();
			m_warning.hide();
			m_char.playAnimation("walk");
			m_callBackFunc = moveUntilPlayerAtTheMiddle;
			m_warning.okButton.removeEventListener(Event.TRIGGERED,onTreasureChestOkButton);
			m_warning.cancelButton.removeEventListener(Event.TRIGGERED,onTreasureChestCancelButton);
		}
		
		private function openTreasureChest():void
		{
			var obj:Object = m_currTreasureChest.getBonus(m_char);
			obj.image.x = (m_currTreasureChest.treasureChestClip.width - obj.image.width) * 0.5;
			obj.image.y = (m_currTreasureChest.treasureChestClip.height - obj.image.height) * 0.5;
			m_currTreasureChest.sprite.addChild(obj.image);
			m_currTreasureChest.itemClip = obj.image;
			TweenMax.to(obj.image,0.5,{y:obj.image.y-(50 * TG_World.SCALE_ROUNDED),onComplete:addTreasureBonus,onCompleteParams:[obj]});
			
		}
		
		private function addTreasureBonus(obj:Object):void
		{
			var str:String = obj.id;
			var textField:TextField;
			var objName:String = "";
			var text:String = "";
			var diff:Number = 0;
			var showStat:Boolean = false;
			var showValue1:Boolean = true;
			var showValue2:Boolean = true;
			var delayTime:Number = 0;
			var duration:Number = 4;
			var usedValue1:Number = 0;
			var usedValue2:Number = 0;
			var offsetY:Number = 50;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				objName = obj.nameEnglish;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				objName = obj.nameIndonesia;
			}
			switch(str)
			{
				case "gold": 
					obj.value1 = int(obj.value1);
					m_char.points += obj.value1;
					
					textField = createText(""+objName+" + "+obj.value1,50,0xFFFF00);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					showStat = false;
					break;
				case "bomb": 
					obj.value1 = int(obj.value1);
					m_char.health -= obj.value1;
					m_char.playAnimation("hit"+m_char.getRandomHitNumber(),1,m_animationTime/2000);
					
					textField = createText(""+objName+" "+obj.value1,50,0xFF0000);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					showStat = false;
					break;
				case "addhealth": 
					obj.value1 = int(obj.value1);
					m_char.health += obj.value1;
					healAnimation(m_char);
					
					textField = createText(""+objName+" + "+obj.value1,50,0x0000CC);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					showStat = false;
					break;
				case "health": 
					obj.value1 = int(obj.value1);
					m_char.healthBonus += obj.value1;
					m_char.recalculateStats();
					
					textField = createText(""+objName+" + "+obj.value1,50,0x0000CC);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					showStat = true;
					break;
				case "damage": 
					obj.value1 = int(obj.value1);
					m_char.damageBonus += obj.value1;
					m_char.recalculateStats();
					
					textField = createText(""+objName+" + "+obj.value1,50,0x0000CC);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation;
					textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					showStat = true;
					break;
				case "critical": 
					if(m_char.critChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					if(m_char.critChance < m_char.critChanceMax)
					{
						diff = m_char.critChanceMax - m_char.critChance;
						if(diff < obj.value1)
						{
							m_char.criticalChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.criticalChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.critValue < m_char.critValueMax)
					{
						diff = m_char.critValueMax - m_char.critValue;
						if(diff < obj.value2)
						{
							m_char.criticalValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.criticalValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "CRITICAL CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KRITIKAL KANS";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "CRITICAL DAMAGE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KRITIKAL PKLAN";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2+"X",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
				case "critical": 
					if(m_char.dmgReturnChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					if(m_char.dmgReturnChance < m_char.dmgReturnChanceMax)
					{
						diff = m_char.dmgReturnChanceMax - m_char.dmgReturnChance;
						if(diff < obj.value1)
						{
							m_char.dmgReturnChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.dmgReturnChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.dmgReturnValue < m_char.dmgReturnValueMax)
					{
						diff = m_char.dmgReturnValueMax - m_char.dmgReturnValue;
						if(diff < obj.value2)
						{
							m_char.dmgReturnValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.dmgReturnValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "DMG RETURN CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KEMBALIKAN PUKULAN KANS";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "DMG RETURN VALUE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "NILAI KEMBALIKAN PUKULAN";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2+"X",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
				case "heal":
					if(m_char.healChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					
					if(m_char.healChance < m_char.healChanceMax)
					{
						diff = m_char.healChanceMax - m_char.healChance;
						if(diff < obj.value1)
						{
							m_char.healChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.healChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.healValue < m_char.healValueMax)
					{
						diff = m_char.healValueMax - m_char.healValue;
						if(diff < obj.value2)
						{
							m_char.healValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.healValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "HEAL CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KANS SEMBUH";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "HEAL VALUE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "NILAI SEMBUH";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2,50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					
					break;
				case "evade":
					if(m_char.evadeChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					if(m_char.evadeChance < m_char.evadeChanceMax)
					{
						diff = m_char.evadeChanceMax - m_char.evadeChance;
						if(diff < obj.value1)
						{
							m_char.evadeChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.evadeChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "EVADE CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "HINDAR KANS";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
				case "poison":
					
					if(m_char.poisonChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					
					if(m_char.poisonChance < m_char.poisonChanceMax)
					{
						diff = m_char.poisonChanceMax - m_char.poisonChance;
						if(diff < obj.value1)
						{
							m_char.poisonChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.poisonChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.poisonValue < m_char.poisonValueMax)
					{
						diff = m_char.poisonValueMax - m_char.poisonValue;
						if(diff < obj.value2)
						{
							m_char.poisonValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.poisonValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "POISON CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KANS RACUN";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "POISON DAMAGE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "NILAI RACUN";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2,50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					
					break;
				case "lifesteal":
					
					if(m_char.lifestealValue <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					if(m_char.lifestealValue < m_char.lifestealValueMax)
					{
						diff = m_char.lifestealValueMax - m_char.lifestealValue;
						if(diff < obj.value1)
						{
							m_char.lifestealValueBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.lifestealValueBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "LIFE STEAL";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "CURI DARAH";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					
					break;
				case "magic":
					if(m_char.magicChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					
					if(m_char.magicChance < m_char.magicChanceMax)
					{
						diff = m_char.magicChanceMax - m_char.magicChance;
						if(diff < obj.value1)
						{
							m_char.magicChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.magicChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.magicValue < m_char.magicValueMax)
					{
						diff = m_char.magicValueMax - m_char.magicValue;
						if(diff < obj.value2)
						{
							m_char.magicValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.magicValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "MAGIC CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KANS SIHIR";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "MAGIC DAMAGE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "PUKULAN SIHIR";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2,50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
				case "strengthen":
					
					if(m_char.strengthenChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					
					if(m_char.strengthenChance < m_char.strengthenChanceMax)
					{
						diff = m_char.strengthenChanceMax - m_char.strengthenChance;
						if(diff < obj.value1)
						{
							m_char.strengthenChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.strengthenChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.strengthenValue < m_char.strengthenValueMax)
					{
						diff = m_char.strengthenValueMax - m_char.strengthenValue;
						if(diff < obj.value2)
						{
							m_char.strengthenValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.strengthenValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "STRENGTHEN CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KANS MENGUATKAN";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "STRENGTHEN VALUE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "NILAI MENGUATKAN";
						}
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" + "+usedValue2+"X",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
				case "weaken":
					
					if(m_char.weakenChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					
					if(m_char.weakenChance < m_char.weakenChanceMax)
					{
						diff = m_char.weakenChanceMax - m_char.weakenChance;
						if(diff < obj.value1)
						{
							m_char.weakenChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.weakenChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					if(m_char.weakenValue > m_char.weakenValueMax)
					{
						diff = m_char.weakenValue - m_char.weakenValueMax;
						if(diff < obj.value2)
						{
							m_char.weakenValueBonus += diff;
							usedValue2 = diff;
						}
						else
						{
							m_char.weakenValueBonus += obj.value2;
							usedValue2 = obj.value2;
						}
						showValue2 = true;
					}
					else
					{
						showValue2 = false;
					}
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "WEAKEN CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "KANS MELEMAHKAN";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					if(showValue2)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "WEAKEN VALUE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "NILAI MELEMAHKAN";
						}
						
						usedValue2 = int(usedValue2*100)/100;
						textField = createText(""+text+" - "+usedValue2+"X",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						textField.visible = false;
						TweenMax.fromTo(textField,duration,{visible:true},{delay:0.5+delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					
					break;
				case "reversed": 
					if(m_char.reverseChance <= 0 && obj.value1 > 0)
					{
						textField = createText("UNLOCKED SKILL "+objName,60,0xFF0000);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
						delayTime = 0.5;						
					}
					else
					{
						delayTime = 0;
					}
					if(m_char.reverseChance < m_char.reverseChanceMax)
					{
						diff = m_char.reverseChanceMax - m_char.reverseChance;
						if(diff < obj.value1)
						{
							m_char.reverseChanceBonus += diff;
							usedValue1 = diff;
						}
						else
						{
							m_char.reverseChanceBonus += obj.value1;
							usedValue1 = obj.value1;
						}
						showValue1 = true;
					}
					else
					{
						showValue1 = false;
					}
					
					m_char.recalculateStats();
					
					if(showValue1)
					{
						if(TG_Static.language == TG_Static.ENGLISH)
						{
							text = "COUNTER ATT CHANCE";
						}
						else if(TG_Static.language == TG_Static.INDONESIA)
						{
							text = "PUKUL BALIK KANS";
						}
						usedValue1 = int(usedValue1*100)/100;
						textField = createText(""+text+" + "+usedValue1+"%",50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation;
						textField.pivotY += ((m_char.sprite.pivotY*m_char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,duration,{delay:delayTime,pivotY:getTFPivotYGoal(textField,offsetY),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					
					showStat = true;
					break;
			}
		
			if(showStat)
			{
				var posX:Number = 0;
				var posY:Number = 0;
				m_statusInfo.changeTexts("STATUS",m_char.descs);
				posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width);
				posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
				
				if(!m_statusInfo.sprite.visible)
				{
					TweenMax.fromTo(m_statusInfo.sprite,0.5,{x:posX,y:-m_statusInfo.sprite.height,visible:true},{x:posX,y:posY});
					m_statusInfo.nextSprite.addEventListener(Event.TRIGGERED,onPlayerStatsBonusClicked);
					m_statusInfo.nextSprite.visible = true;
				}
				
			}
			else
			{
				m_callBackFunc = idleTreasureChest;
			}
			
		}
		private function onPlayerStatsBonusClicked(e:Event):void
		{
			m_statusInfo.nextSprite.removeEventListener(Event.TRIGGERED,onPlayerStatsBonusClicked);
			TweenMax.to(m_statusInfo.sprite,0.5,{y:TG_World.GAME_HEIGHT,visible:false});
			
			m_callBackFunc = null;
			hideTreasureChest();
		}
		private function idleTreasureChest(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 1000)
			{
				m_animationCounter = 0;
				m_callBackFunc = null;
				
				if(!isAnyoneDies(true))
				{
					hideTreasureChest();
				}
				
			}
		}
		
		private function hideTreasureChest():void
		{
			m_currTreasureChest.hide();
			
			if(m_clipAreaFX)
			{
				m_clipAreaFX.visible = false;
			}
			if(m_clipAreaFX2)
			{
				m_clipAreaFX2.visible = false;
			}
			m_char.playAnimation("walk");
			m_callBackFunc = moveUntilPlayerAtTheMiddle;
			trace("move");
		}
		
		
		private function onSurprisedTextCreated():void
		{
			TweenMax.fromTo(multiFunctionText,0.1,{alpha:1},{alpha:0.1,delay:0.4,onComplete:onSurpriseTextCompleted});
		}
		private function onSurpriseTextCompleted():void
		{
			multiFunctionText.visible = false;
			if(m_enemy && m_enemy.isBoss)
			{
				showBlackQuads();
				m_callBackFunc = rotateToEnemy;
			}
			else
			{
				m_callBackFunc = updateDynamicLayerRotationEnemy;
				prepareToFight();
			}
			
		}
		
		private function prepareToFight():void
		{
			
			if(m_rpsBar)
			{
				m_rpsBar.show();
				m_rpsBarHided = false;
			}
			if(m_statusBar2)
			{
				m_statusBar2.name = m_enemy.name;
				m_statusBar2.show();
			}
			if(m_question)
			{
				var level:int = m_char.getLevel()-1;
				if(m_enemy.isBoss)
				{
					level = m_enemy.xml.jkpLevel;
				}
				m_question.level = level;
				m_question.show();
			}
		}
		
		private function rotateToEnemy(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_enemy.rotation - m_char.rotation;
			if(difference < m_distanceDifference)
			{
				difference = m_distanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_distanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 1;
			TweenMax.fromTo(layerDynamic,0.8,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 1),onComplete:onRotatedToEnemy});
			m_callBackFunc = null;
		}
		
		private function rotateToNPC(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_npc.rotation - m_char.rotation;
			if(difference < m_distanceDifference)
			{
				difference = m_distanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_distanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 1;
			TweenMax.fromTo(layerDynamic,0.8,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 1),onComplete:onRotatedToEnemy});
			m_callBackFunc = null;
		}
		
		private function rotateToTreasureChest(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_currTreasureChest.rotation - m_char.rotation;
			if(difference < m_distanceDifference)
			{
				difference = m_distanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_distanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 1;
			TweenMax.fromTo(layerDynamic,0.8,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 1),onComplete:onRotatedToEnemy});
			m_callBackFunc = null;
		}
		
		private function rotateToPlayer(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_enemy.rotation - m_char.rotation;
			if(difference < m_distanceDifference)
			{
				difference = m_distanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_distanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 0.5;
			TweenMax.fromTo(layerDynamic,0.4,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * -0.5),onComplete:onRotatedToPlayer});
			hideBlackQuads();
			m_callBackFunc = null;
		}
		
		private function onRotatedToEnemy():void
		{
			var str:String;
			var posX:Number = 0;
			var posY:Number = 0;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = m_enemy.xml.nameEnglish;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = m_enemy.xml.nameIndonesia;
			}
			reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
			multiFunctionText.visible = false;
			var centerX:Number = (TG_World.GAME_WIDTH) * 0.5;
			posY = m_quadTop.height;
			TweenMax.fromTo(multiFunctionText,0.5,{x:centerX,y:-multiFunctionText.height,visible:true},{x:centerX,y:posY,ease:Circ.easeOut});
			m_enemy.playAnimation("celebrate");
			m_statusInfo.changeTexts("STATUS",m_enemy.descs);
			posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width) * 0.5;
			posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
		
			TweenMax.fromTo(m_statusInfo.sprite,0.5,{x:posX,y:-m_statusInfo.sprite.height,visible:true},{x:posX,y:posY});
			//m_callBackFunc = waitBossIdle;
			m_callBackFunc = null;
			m_statusInfo.nextSprite.addEventListener(Event.TRIGGERED,onEnemyStatsClicked);
			m_statusInfo.nextSprite.visible = true;
			
		}
		protected function onEnemyStatsClicked(e:Event):void
		{
			m_statusInfo.nextSprite.removeEventListener(Event.TRIGGERED,onEnemyStatsClicked);
			m_callBackFunc = rotateToPlayer;
			TweenMax.to(m_statusInfo.sprite,0.5,{y:TG_World.GAME_HEIGHT,visible:false});
			TweenMax.to(multiFunctionText,0.4,{y:-multiFunctionText.height,visible:false});
		}
		private function onRotatedToPlayer():void
		{
			prepareToFight();
			onDynamicLayerRotatedEnemy();
		}
		private function waitBossIdle(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 1000)
			{
				m_animationCounter = 0;
				m_callBackFunc = rotateToPlayer;
				
				TweenMax.to(multiFunctionText,0.4,{y:TG_World.GAME_HEIGHT+multiFunctionText.height,visible:false});
			}
		}
		
		private function updateDynamicLayerRotationEnemy(elapsedTime:int):void
		{
			var difference:Number = 0;
			difference = m_enemy.rotation - m_char.rotation;
			if(difference < m_distanceDifference)
			{
				difference = m_distanceDifference - difference;
				m_char.rotation -= difference;
				layerNormalground.rotation += difference;
				layerCharacter.rotation += difference;
				layerForeground.rotation += difference;
				layerBackground.rotation += difference;
			}
			difference = m_distanceDifference;
			m_currentDynamicLayerRotationCounter = difference * 0.5;
			TweenMax.fromTo(layerDynamic,0.4,{rotation:layerDynamic.rotation},{rotation:layerDynamic.rotation - (difference * 0.5),onComplete:onDynamicLayerRotatedEnemy});
			m_callBackFunc = null;
		}
		
		
		private function onDynamicLayerRotatedEnemy():void
		{
			var str:String;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "FIGHT!";
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "BERTARUNG!";
			}
			reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
			multiFunctionText.visible = false;
			TweenMax.fromTo(multiFunctionText,0.2,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5,visible:true},{delay:0.3,scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onFightTextCreated,ease:Circ.easeOut});
			m_callBackFunc = null;
		}
		
		
		private function onFightTextCreated():void
		{
			TweenMax.fromTo(multiFunctionText,0.1,{alpha:1},{alpha:0.1,delay:0.5,onComplete:onFightTextCompleted});
		}
		
		private function onFightTextCompleted():void
		{
			multiFunctionText.visible = false;
			if(m_question)
			{
				var rand:int;
				var rangeMin:int = 0;
				var rangeMax:int = 0;
				var level:int = m_char.getLevel()-1;
				if(level >= 4)
				{
					rangeMin = level - 1;
					rangeMax = level;
					rand = (Math.random() * 1000) % 2;
					rand += rangeMin;
				}
				else
				{
					rand = level;
				}
				if(m_enemy.isBoss)
				{
					level = m_enemy.xml.jkpLevel;
					rand = level;
				}
				
				m_question.showQuestion(rand);
				//m_question.showQuestion();
			}
			m_callBackFunc = checkAnswers;
		}
		
		private function checkAnswers(elapsedTime:int):void
		{
			if(m_question.isTimeOut() || m_question.isAllAnswered())
			{
				m_char.playAnimation("frontjump");
				m_enemy.playAnimation("frontjump");
				m_callBackFunc = moveBothToAttackDistance;
			}
		}
		
		/****************************** TOGETHER ***************************************************/
		private function movePlayerToMiddle(elapsedTime:int):void
		{
			var temp:Number = 0;
			if(m_charRotationCounter < m_attackDistance)
			{
				temp = m_char.jumpSpeed * elapsedTime/1000;
				m_charRotationCounter += temp;
				m_currentCharRotationCounter += temp;
				m_char.rotation += temp;
				
			}
			if(m_charRotationCounter >= m_attackDistance)
			{
				m_char.playAnimation("battle");
				temp = m_charRotationCounter - m_attackDistance;
				m_char.rotation -= temp;
				m_currentCharRotationCounter -= temp;
			}
		}
		
		private function moveEnemyToMiddle(elapsedTime:int):void
		{
			if(m_enemyRotationCounter < m_attackDistance)
			{
				m_enemy.rotation -= m_enemy.jumpSpeed * elapsedTime/1000;
				m_enemyRotationCounter += m_enemy.jumpSpeed * elapsedTime/1000;
			}
			if(m_enemyRotationCounter >= m_attackDistance)
			{
				m_enemy.playAnimation("battle");
				m_enemy.rotation += (m_enemyRotationCounter - m_attackDistance);
			}
		}
		private function moveBothToAttackDistance(elapsedTime:int):void
		{
			movePlayerToMiddle(elapsedTime);
			moveEnemyToMiddle(elapsedTime);
			if(m_charRotationCounter >= m_attackDistance && m_enemyRotationCounter >= m_attackDistance)
			{
				m_charRotationCounter = 0;
				m_enemyRotationCounter = 0;
				m_callBackFunc = checkResults;
			}
		}
		
		
		private function movePlayerBack(elapsedTime:int):void
		{
			if(m_charRotationCounter < m_attackDistance)
			{
				m_char.rotation -= m_char.jumpSpeed * elapsedTime/1000;
				m_charRotationCounter += m_char.jumpSpeed * elapsedTime/1000;
				m_currentCharRotationCounter -= m_char.jumpSpeed * elapsedTime/1000;
			}
			if(m_charRotationCounter >= m_attackDistance)
			{
				m_char.playAnimation("battle");
				m_char.rotation += (m_charRotationCounter - m_attackDistance);
				m_currentCharRotationCounter += (m_charRotationCounter - m_attackDistance);
			}
		}
		
		private function moveEnemyBack(elapsedTime:int):void
		{
			if(m_enemyRotationCounter < m_attackDistance)
			{
				m_enemy.rotation += m_enemy.jumpSpeed * elapsedTime/1000;
				m_enemyRotationCounter += m_enemy.jumpSpeed * elapsedTime/1000;
			}
			if(m_enemyRotationCounter >= m_attackDistance)
			{
				m_enemy.playAnimation("battle");
				m_enemy.rotation -= (m_enemyRotationCounter - m_attackDistance);
			}
		}
		
		private function moveBothBack(elapsedTime:int):void
		{
			
			if(m_charRotationCounter >= m_attackDistance && m_enemyRotationCounter >= m_attackDistance)
			{
				m_charRotationCounter = 0;
				m_enemyRotationCounter = 0;
				m_callBackFunc = checkPoisoned;
			}
			else
			{
				movePlayerBack(elapsedTime);
				moveEnemyBack(elapsedTime);
			}
			
		}
		
		/** CHECKING EFFECT AFTER BATTLE
		 * 1. POISON
		 * 2. HEAL
		 * 3. MAGIC
		 * 4. STRENGTHEN
		 * 5. WEAKEN
		 * ***/
		/*** POISON **/
		private function doPoison(attacker:TG_Character,victim:TG_Character,offset:Number):Boolean
		{
			var textField:TextField;
			var damage:int = 0;
			if(victim)
			{
				if(victim.isPoisoned)
				{
					damage =  attacker.poisonValue;
					victim.health -= damage;
					textField = createText(""+damage,60,0x00FF00);
					layerCharacter.addChild(textField);
					textField.rotation = victim.rotation + offset;
					textField.pivotY += (victim.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					victim.playAnimation("hit"+victim.getRandomHitNumber(),1,0.3);
					victim.poisonCounter++;
					if(victim.poisonCounter >= victim.maxPoisonCounter)
					{
						victim.poisonCounter = 0;
						victim.isPoisoned = false;
					}
					return true;
				}
			}
			return false;
		}
		private function checkPoisoned(elapsedTime:int):void
		{
			var isPoisoned1:Boolean = doPoison(m_enemy,m_char,m_charRotOffset);
			var isPoisoned2:Boolean = doPoison(m_char,m_enemy,m_enemyRotOffset);
			if(isPoisoned1 || isPoisoned2)
			{
				m_callBackFunc = idleAfterPoison;
			}
			else
			{
				m_callBackFunc = checkHeal;
			}
		}
		
		private function idleAfterPoison(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 300)
			{
				m_animationCounter = 0;
				m_callBackFunc = checkAnyoneDiesAfterPoison;
				
			}
		}
		
		private function checkAnyoneDiesAfterPoison(elapsedTime:int):void
		{
			if(isAnyoneFall())
			{
				showBlackQuads();
				m_callBackFunc = waitUntilEnemyFellAfterPoison;
			}
			else if(!isAnyoneDies())
			{
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = checkHeal;
			}
		}
		private function waitUntilEnemyFellAfterPoison(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				m_enemy.setLevel(m_enemy.getLevel()+3);
				m_statusBar2.setSeizedExp(m_enemy.seizedExp);
				m_statusBar2.setLevel(m_enemy.getLevel());
				m_statusBar2.calculateReduceExp();
				var textField:TextField;
				var str:String;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "Revived";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Hidup Kembali";
				}
				textField = createText(""+str,50,0xFFFF00);
				layerCharacter.addChild(textField);
				textField.rotation = m_enemy.rotation + m_enemyRotOffset;
				textField.pivotY += ((m_enemy.sprite.pivotY*m_enemy.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
				
				m_clipLevelUpFX.visible = true;
				m_clipLevelUpFX.currentFrame = 1;
				m_clipLevelUpFX.play();
				m_clipLevelUpFX.scaleX = m_enemy.sprite.scaleX * 2;
				m_clipLevelUpFX.scaleY = m_enemy.sprite.scaleY * 2;
				m_enemy.sprite.addChild(m_clipLevelUpFX);
				
				m_enemy.reviveChar();
				m_callBackFunc = waitUntilEnemyRevivedAfterPoison;
			}
		}
		
		private function waitUntilEnemyRevivedAfterPoison(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				hideBlackQuads();
				m_callBackFunc = checkHeal;
			}
		}
		
		
		/*************HEAL****************************/
		private function doHeal(char:TG_Character,offset:Number):Boolean
		{
			var textField:TextField;
			var healValue:int = 0;
			var rand:Number = 0;
			if(char.healChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= char.healChance)
				{
					healValue = char.healValue;
					char.health += healValue;
					if(char.health > char.initialHealth)
					{
						char.health = char.initialHealth;
					}
					textField = createText("+"+healValue,60,0x0044FF);
					layerCharacter.addChild(textField);
					textField.rotation = char.rotation + offset;
					textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					
					healAnimation(char);
					return true;
				}
			}
			return false;
		}
		
		protected function healAnimation(char:TG_Character):void
		{
			char.playAnimation("heal",1,1);
			
			var clip:MovieClip;
			clip = m_clipAreaFX;
			if(m_clipAreaFX.isPlaying)
			{
				clip = m_clipAreaFX2;
			}
			
			clip.visible = true;
			clip.currentFrame = 1;
			clip.play();
			clip.scaleX = char.sprite.scaleX * 2;
			clip.scaleY = char.sprite.scaleY * 2;
			clip.color = 0xEEEE00;
			char.sprite.addChild(clip);
		}
		private function checkHeal(elapsedTime:int):void
		{
			var isHealing1:Boolean = doHeal(m_char,m_charRotOffset);
			var isHealing2:Boolean = doHeal(m_enemy,m_enemyRotOffset);
			if(isHealing1 || isHealing2)
			{
				m_callBackFunc = idleAfterHealing;
			}
			else
			{
				m_callBackFunc = checkMagic;
			}
		}
		
		private function idleAfterHealing(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_clipAreaFX)
			{
				if(!m_clipAreaFX.isPlaying)
				{
					m_clipAreaFX.visible = false;
				}
			}
			if(m_animationCounter >= 1000)
			{
				m_animationCounter = 0;
				if(m_clipAreaFX)
				{
					m_clipAreaFX.visible = false;
				}
				if(m_clipAreaFX2)
				{
					m_clipAreaFX2.visible = false;
				}
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = checkMagic;
				
			}
		}
		/**************************************************************/
		/****************************MAGIC*****************************/
		private function doMagic(attacker:TG_Character,victim:TG_Character):Boolean
		{
			var textField:TextField;
			var damage:int = 0;
			var rand:Number = 0;
			if(attacker.magicChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= attacker.magicChance)
				{
					damage = attacker.magicValue;
					attacker.playAnimation("range attack",1,1);
					
					return true;
				}
			}
			return false;
		}
		
		private function createMagicBullet(attacker:TG_Character,victim:TG_Character):void
		{
			var clip:Image = new Image(TG_World.assetManager.getTexture("Bullet"));
			clip.pivotX = 0.5/2;
			clip.pivotY = 26.5/2;
			clip.pivotY += (attacker.sprite.pivotY) + 50;
			clip.rotation = attacker.sprite.rotation;
			clip.scaleX = attacker.sprite.scaleX;
			clip.scaleY = attacker.sprite.scaleY;
			layerCharacter.addChild(clip);
			
			var offset:Number = 0.2;
			if(clip.scaleX > 0)
			{
				offset = -0.2;
			}
			clip.rotation += offset;
			
			TweenMax.to(clip,0.5,{ease:Circ.easeIn,shortRotation:{rotation:victim.sprite.rotation,useRadians:true},onComplete:onBulletHit,onCompleteParams:[clip,victim,attacker.magicValue]});
		}
		private function checkMagic(elapsedTime:int):void
		{
			var isMagic1:Boolean = doMagic(m_char,m_enemy);
			var isMagic2:Boolean = doMagic(m_enemy,m_char);
			if(isMagic1 && isMagic2)
			{
				m_callBackFunc = idleMagicAnimationBoth;
				m_bulletNumCreated = 2;
			}
			else if(isMagic1)
			{
				m_callBackFunc = idleMagicAnimation1;
				m_bulletNumCreated = 1;
			}
			else if(isMagic2)
			{
				m_callBackFunc = idleMagicAnimation2;
				m_bulletNumCreated = 1;
			}
			else
			{
				m_callBackFunc = checkStrengthen;
			}
		}
		
		private function idleMagicAnimation1(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			
			if(m_animationCounter >= 700)
			{
				m_animationCounter = 0;
				createMagicBullet(m_char,m_enemy);
				m_callBackFunc = null;
			}
		}
		private function idleMagicAnimation2(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			
			if(m_animationCounter >= 700)
			{
				m_animationCounter = 0;
				createMagicBullet(m_enemy,m_char);
				m_callBackFunc = null;
			}
		}
		
		private function idleMagicAnimationBoth(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			
			if(m_animationCounter >= 700)
			{
				m_animationCounter = 0;
				createMagicBullet(m_char,m_enemy);
				createMagicBullet(m_enemy,m_char);
				m_callBackFunc = null;
			}
		}
		
		private function onBulletHit(clip:Image,victim:TG_Character,damage:int):void
		{
			var textField:TextField;
			var offset:Number = m_charRotOffset;
			if(clip.scaleX > 0)
			{
				offset = m_enemyRotOffset;
			}
			victim.health -= damage;
			textField = createText(""+damage,60,0x00FF00);
			layerCharacter.addChild(textField);
			textField.rotation = victim.rotation + offset;
			textField.pivotY += (victim.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
			victim.playAnimation("hit"+victim.getRandomHitNumber(),1,0.3);
			clip.parent.removeChild(clip);
			m_bulletNumCreated--;
			if(m_bulletNumCreated <= 0)
			{
				m_bulletNumCreated = 0;
				m_callBackFunc = idleAfterBulletHit;
			}
		}
		
		private function idleAfterBulletHit(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			
			if(m_animationCounter >= 300)
			{
				m_animationCounter = 0;
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = checkAnyoneDiesAfterMagic;
				
			}
		}
		
		private function checkAnyoneDiesAfterMagic(elapsedTime:int):void
		{
			if(isAnyoneFall())
			{
				showBlackQuads();
				m_callBackFunc = waitUntilEnemyFellAfterMagic;
			}
			else if(!isAnyoneDies())
			{
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = checkStrengthen;
			}
		}
		private function waitUntilEnemyFellAfterMagic(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				m_enemy.setLevel(m_enemy.getLevel()+3);
				m_statusBar2.setSeizedExp(m_enemy.seizedExp);
				m_statusBar2.setLevel(m_enemy.getLevel());
				m_statusBar2.calculateReduceExp();
				var textField:TextField;
				var str:String;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "Revived";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Hidup Kembali";
				}
				textField = createText(""+str,50,0xFFFF00);
				layerCharacter.addChild(textField);
				textField.rotation = m_enemy.rotation + m_enemyRotOffset;
				textField.pivotY += ((m_enemy.sprite.pivotY*m_enemy.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
				
				m_clipLevelUpFX.visible = true;
				m_clipLevelUpFX.currentFrame = 1;
				m_clipLevelUpFX.play();
				m_clipLevelUpFX.scaleX = m_enemy.sprite.scaleX * 2;
				m_clipLevelUpFX.scaleY = m_enemy.sprite.scaleY * 2;
				m_enemy.sprite.addChild(m_clipLevelUpFX);
				
				m_enemy.reviveChar();
				m_callBackFunc = waitUntilEnemyRevivedAfterMagic;
			}
		}
		
		private function waitUntilEnemyRevivedAfterMagic(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				hideBlackQuads();
				m_callBackFunc = checkStrengthen;
			}
		}
		
		
		
		/**************************************************************/
		
		/*** STRENGTHEN **/
		private function doStrengthen(char:TG_Character,offset:Number):Boolean
		{
			if(char.isStrengthen)return false;
			var rand:Number;
			var textField:TextField;
			var multiplier:Number = 0;
			if(char.strengthenChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= char.strengthenChance)
				{
					multiplier = char.strengthenValue;
					char.setDamageMultiplier(multiplier);
					
					var str:String;
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						str = "Damage x";
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						str = "Tenaga x";
					}
					
					textField = createText(str+multiplier,60,0x0044FF);
					layerCharacter.addChild(textField);
					textField.rotation = char.rotation + offset;
					textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					char.playAnimation("powerup",1,1);
					
					var clip:MovieClip;
					clip = m_clipAreaFX;
					if(m_clipAreaFX.isPlaying)
					{
						clip = m_clipAreaFX2;
					}
					
					clip.visible = true;
					clip.currentFrame = 1;
					clip.play();
					clip.scaleX = char.sprite.scaleX * 2;
					clip.scaleY = char.sprite.scaleY * 2;
					char.sprite.addChild(clip);
					clip.color = 0x0000DD;
					
					char.isStrengthen = true;
					char.strengthenCounter = 0;
					return true;
				}
			}
			return false;
		}
		private function checkStrengthen(elapsedTime:int):void
		{
			var isStrengthen1:Boolean = doStrengthen(m_char,m_charRotOffset);
			var isStrengthen2:Boolean = doStrengthen(m_enemy,m_enemyRotOffset);
			if(isStrengthen1 || isStrengthen2)
			{
				m_callBackFunc = idleAfterStrengthen;
			}
			else
			{
				m_callBackFunc = checkWeaken;
			}
		}
		
		private function idleAfterStrengthen(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_clipAreaFX)
			{
				if(!m_clipAreaFX.isPlaying)
				{
					m_clipAreaFX.visible = false;
				}
			}
			if(m_animationCounter >= 1000)
			{
				m_animationCounter = 0;
				if(m_clipAreaFX)
				{
					m_clipAreaFX.visible = false;
				}
				if(m_clipAreaFX2)
				{
					m_clipAreaFX2.visible = false;
				}
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = checkWeaken;
				
			}
		}
		/***********************************************************/
		
		/*** WEAKEN **/
		private function doWeaken(attacker:TG_Character,victim:TG_Character,offset:Number):Boolean
		{
			if(victim.isWeaken)return false;
			var rand:Number;
			var textField:TextField;
			var multiplier:Number = 0;
			if(attacker.weakenChance > 0)
			{
				rand = (Math.random() * 100000 ) % 100;
				if(rand <= attacker.weakenChance)
				{
					multiplier = attacker.weakenValue;
					victim.setDamageMultiplier(multiplier);
					
					var str:String;
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						str = "Damage x";
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						str = "Tenaga x";
					}
					
					textField = createText(str+multiplier,60,0xFF4400);
					layerCharacter.addChild(textField);
					textField.rotation = victim.rotation + offset;
					textField.pivotY += (victim.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					victim.playAnimation("hit"+victim.getRandomHitNumber(),1,1);
					attacker.playAnimation("powerup",1,1);
					
					var clip:MovieClip;
					clip = m_clipAreaFX;
					if(m_clipAreaFX.isPlaying)
					{
						clip = m_clipAreaFX2;
					}
					
					clip.visible = true;
					clip.currentFrame = 1;
					clip.play();
					clip.scaleX = victim.sprite.scaleX * 2;
					clip.scaleY = victim.sprite.scaleY * 2;
					victim.sprite.addChild(clip);
					clip.color = 0xDD0000;
					
					victim.isWeaken = true;
					victim.weakenCounter = 0;
					return true;
				}
			}
			return false;;
		}
		private function checkWeaken(elapsedTime:int):void
		{
			var isWeaken1:Boolean = doWeaken(m_enemy,m_char,m_charRotOffset);
			var isWeaken2:Boolean = doWeaken(m_char,m_enemy,m_enemyRotOffset);
			if(isWeaken1 || isWeaken2)
			{
				m_callBackFunc = idleAfterWeaken;
			}
			else
			{
				m_callBackFunc = takeNextQuestions;
			}
		}
		
		private function idleAfterWeaken(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_clipAreaFX)
			{
				if(!m_clipAreaFX.isPlaying)
				{
					m_clipAreaFX.visible = false;
				}
			}
			if(m_animationCounter >= 1000)
			{
				m_animationCounter = 0;
				if(m_clipAreaFX)
				{
					m_clipAreaFX.visible = false;
				}
				if(m_clipAreaFX2)
				{
					m_clipAreaFX2.visible = false;
				}
				m_char.playAnimation("battle");
				m_enemy.playAnimation("battle");
				m_callBackFunc = takeNextQuestions;
				
			}
		}
		/***********************************************************/
		
		protected function checkAfterEffect(char:TG_Character):void
		{
			if(char.isStrengthen)
			{
				char.strengthenCounter++;
				if(char.strengthenCounter >= char.strengthenCounterMax)
				{
					char.strengthenCounter = 0;
					char.setDamageMultiplier(1);
					char.isStrengthen = false;
				}
			}
			if(char.isWeaken)
			{
				char.weakenCounter++;
				if(char.weakenCounter >= char.weakenCounterMax)
				{
					char.weakenCounter = 0;
					char.setDamageMultiplier(1);
					char.isWeaken = false;
				}
			}
		}
		
		/***EVADE FUNCTION**/
		private function playerAttacksEnemyEvade(elapsedTime:int):void
		{
			m_char.playAnimation("attack"+m_char.getRandomAttackNumber(),1,m_animationTime/1000);
			m_enemy.playAnimation("backjump");
			m_animationCounter = 0;
			m_enemyRotationCounter = 0;
			m_callBackFunc = enemyEvade;
		}
		
		private function enemyAttacksPlayerEvade(elapsedTime:int):void
		{
			m_enemy.playAnimation("attack"+m_char.getRandomAttackNumber(),1,m_animationTime/1000);
			m_char.playAnimation("backjump");
			m_animationCounter = 0;
			m_charRotationCounter = 0;
			m_callBackFunc = playerEvade;
		}
		
		private function enemyEvade(elapsedTime:int):void
		{
			if(m_enemyRotationCounter < 0.2)
			{
				m_enemy.rotation += m_enemy.jumpSpeed * elapsedTime/1000;
				m_enemyRotationCounter += m_enemy.jumpSpeed * elapsedTime/1000;
			}
			if(m_enemyRotationCounter >= 0.2)
			{
				m_enemy.playAnimation("battle");
				m_enemy.rotation -= (m_enemyRotationCounter - 0.2);
				m_enemyRotationCounter = 0;
				m_enemy.playAnimation("frontjump");
				m_callBackFunc = enemyBack;
			}
		}
		
		private function enemyBack(elapsedTime:int):void
		{
			if(m_enemyRotationCounter < 0.2)
			{
				m_enemy.rotation -= m_enemy.jumpSpeed * elapsedTime/1000;
				m_enemyRotationCounter += m_enemy.jumpSpeed * elapsedTime/1000;
			}
			if(m_enemyRotationCounter >= 0.2)
			{
				m_enemy.playAnimation("battle");
				m_enemy.rotation += (m_enemyRotationCounter - 0.2);
				m_enemyRotationCounter = 0;
				m_callBackFunc = checkResults;
			}
		}
		
		private function playerEvade(elapsedTime:int):void
		{
			if(m_charRotationCounter < 0.2)
			{
				m_char.rotation -= m_char.jumpSpeed * elapsedTime/1000;
				m_charRotationCounter += m_char.jumpSpeed * elapsedTime/1000;
			}
			if(m_charRotationCounter >= 0.2)
			{
				m_char.playAnimation("battle");
				m_char.rotation += (m_charRotationCounter - 0.2);
				m_charRotationCounter = 0;
				m_char.playAnimation("frontjump");
				m_callBackFunc = playerBack;
			}
		}
		
		private function playerBack(elapsedTime:int):void
		{
			if(m_charRotationCounter < 0.2)
			{
				m_char.rotation += m_char.jumpSpeed * elapsedTime/1000;
				m_charRotationCounter += m_char.jumpSpeed * elapsedTime/1000;
			}
			if(m_charRotationCounter >= 0.2)
			{
				m_char.playAnimation("battle");
				m_char.rotation -= (m_charRotationCounter - 0.2);
				m_charRotationCounter = 0;
				m_callBackFunc = checkResults;
			}
		}
		/*************************************************************/
		
		private function takeNextQuestions(elapsedTime:int):void
		{
			checkAfterEffect(m_char);
			checkAfterEffect(m_enemy);
			m_question.showUnAnsweredIcon();
			
			var rand:int;
			var rangeMin:int = 0;
			var rangeMax:int = 0;
			var level:int = m_char.getLevel()-1;
			if(level >= 4)
			{
				rangeMin = level - 1;
				rangeMax = level;
				rand = (Math.random() * 1000) % 2;
				rand += rangeMin;
			}
			else
			{
				rand = level;
			}
			
			if(m_enemy.isBoss)
			{
				level = m_enemy.xml.jkpLevel;
				rand = level;
			}
			
			m_question.showQuestion(rand);
			//m_question.showQuestion();
			m_callBackFunc = checkAnswers;
		}
		/*******************************************************************************************/
		
		private function showEvadeText(char:TG_Character,rotationOffset:Number):void
		{
			var str:String;
			var textField:TextField;
			var multiplier:int = 1;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "EVADE!";
				multiplier = 1;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "MENGHINDAR!";
				multiplier = 1.5;
			}
			
			textField = createText(str,60,0x00FF00);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset * multiplier;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
		}
		
		private function showReverseTextPlayer(char:TG_Character,rotationOffset:Number):void
		{
			var str:String;
			var textField:TextField;
			var multiplier:int = 1;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "COUNTER ATTACK!";
				multiplier = 1;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "DIPUKUL BALIK!";
				multiplier = 1.5;
			}
			
			textField = createText(str,60,0x0044FF);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset * multiplier;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
		}
		private function showReverseTextEnemy(char:TG_Character,rotationOffset:Number):void
		{
			var str:String;
			var textField:TextField;
			var multiplier:int = 1;
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "COUNTER ATTACK!";
				multiplier = 1;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "DIPUKUL BALIK!";
				multiplier = 1.5;
			}
			
			textField = createText(str,60,0xFF4400);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset * multiplier;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
		}
		private function showDamageReturnText(char:TG_Character,rotationOffset:Number,damage:int):void
		{
			var str:String;
			var textField:TextField;
			var multiplier:int = 1;
			
			textField = createText(""+damage,50,0xFFFF00);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
			
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "DMG RETURN!";
				multiplier = -12;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "TERLUKA KEMBALI!";
				multiplier = -15;
			}
			
			textField = createText(str,60,0xFF0000);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset * multiplier;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			textField.visible = false;
			TweenMax.to(textField,0,{visible:true,onComplete:textFieldVisible,onCompleteParams:[textField]});
		}
		
		private function showLifeStealText(char:TG_Character,rotationOffset:Number,damage:int):void
		{
			var str:String;
			var textField:TextField;
			var multiplier:int = 1;
			
			if(TG_Static.language == TG_Static.ENGLISH)
			{
				str = "LIFE STEAL";
				multiplier = -3;
			}
			else if(TG_Static.language == TG_Static.INDONESIA)
			{
				str = "CURI DARAH";
				multiplier = -3;
			}
			
			textField = createText("+"+damage,50,0x0044FF);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset * multiplier;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			textField.visible = false;
			TweenMax.to(textField,0,{visible:true,onComplete:textFieldVisible,onCompleteParams:[textField]});
		}
		private function checkResults(elapsedTime:int):void
		{
			var whoWon:int = m_question.checkNextAnswer();
			var rand:Number = 0;
			
			//DRAW
			if(whoWon == 0)
			{
				rand = (Math.random() * 10000) % 100;
				if(rand <= m_enemy.evadeChance)
				{
					m_callBackFunc = playerAttacksEnemyEvade;
					showEvadeText(m_enemy,m_enemyRotOffset);
				}
				else if(rand <= m_char.evadeChance)
				{
					m_callBackFunc = enemyAttacksPlayerEvade;
					showEvadeText(m_char,m_charRotOffset);
				}
				else
				{
					m_callBackFunc = bothAttacks;
				}
				
			}
			//PLAYER WON
			else if(whoWon == 1)
			{
				rand = (Math.random() * 10000) % 100;
				if(rand <= m_enemy.evadeChance)
				{
					m_callBackFunc = playerAttacksEnemyEvade;
					showEvadeText(m_enemy,m_enemyRotOffset);
				}
				else
				{
					rand = (Math.random() * 10000) % 100;
					if(rand <= m_enemy.reverseChance)
					{
						showReverseTextEnemy(m_enemy,m_enemyRotOffset);
						m_question.reverseCurrentAnswer();
						m_callBackFunc = idleReversing;
					}
					else
					{
						m_callBackFunc = playerAttacks;
					}
				}
			}
			//ENEMY WON
			else if(whoWon == 2)
			{
				rand = (Math.random() * 10000) % 100;
				if(rand <= m_char.evadeChance)
				{
					m_callBackFunc = enemyAttacksPlayerEvade;
					showEvadeText(m_char,m_charRotOffset);
				}
				else
				{
					rand = (Math.random() * 10000) % 100;
					if(rand <= m_char.reverseChance)
					{
						showReverseTextPlayer(m_char,m_charRotOffset);
						m_question.reverseCurrentAnswer();
						m_callBackFunc = idleReversing;
						
					}
					else
					{
						m_callBackFunc = enemyAttacks;
					}
				}
			}
			//BATTLE ENDS
			else if(whoWon == -1)
			{
				m_char.playAnimation("backjump");
				m_enemy.playAnimation("backjump");
				m_callBackFunc = moveBothBack;
			}
		}
		
		private function idleReversing(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 500)
			{
				m_animationCounter = 0;
				m_callBackFunc = checkResults;
			}
		}
		
		private function playerAttacks(elapsedTime:int):void
		{
			m_char.playAnimation("attack"+m_char.getRandomAttackNumber(),1,m_animationTime/1000);
			m_animationCounter = 0;
			m_callBackFunc = waitAnimationAttackEnds;
			m_callBackParams = [m_enemy];
		}
		private function enemyAttacks(elapsedTime:int):void
		{
			m_enemy.playAnimation("attack"+m_enemy.getRandomAttackNumber(),1,m_animationTime/1000);
			m_animationCounter = 0;
			m_callBackFunc = waitAnimationAttackEnds;
			m_callBackParams = [m_char];
		}
		private function bothAttacks(elapsedTime:int):void
		{
			m_char.playAnimation("attack"+m_char.getRandomAttackNumber(),1,m_animationTime/1000);
			m_enemy.playAnimation("attack"+m_enemy.getRandomAttackNumber(),1,m_animationTime/1000);
			m_animationCounter = 0;
			m_callBackFunc = waitAnimationAttackEnds;
			m_callBackParams = null;
		}
		
		private function getTFPivotYGoal(textField:TextField,offsetY:Number = 0):Number
		{
			return(textField.pivotY+((250+offsetY)*textField.scaleY))/textField.scaleY;
		}
		private function showDamage(obj:Object,char:TG_Character,rotationOffset:Number):void
		{
			var textField:TextField;
			var delayCounter:int = 0;
			var delay:Number = 0.3;
			var str:String;
			
			textField = createText(""+obj.damage,50,0xFFFF00);
			layerCharacter.addChild(textField);
			textField.rotation = char.rotation + rotationOffset;
			textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
			if(obj.critical)
			{
				textField.color = 0xFF0000;
				
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "CRITICAL!";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "KRITIKAL!";
				}
				textField = createText(str,60,0xFF0000);
				layerCharacter.addChild(textField);
				textField.rotation = char.rotation + rotationOffset * -10;
				textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				textField.visible = false;
				TweenMax.to(textField,delayCounter*delay,{visible:true,onComplete:textFieldVisible,onCompleteParams:[textField]});
				delayCounter++;
			}
			if(obj.poison && !char.isPoisoned)
			{
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "POISONED!";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "KERACUNAN!";
				}
				
				char.isPoisoned = true;
				char.poisonCounter = 0;
				textField = createText(str,60,0x00FF00);
				layerCharacter.addChild(textField);
				textField.rotation = char.rotation + rotationOffset * -10;
				textField.pivotY += ((char.sprite.pivotY*char.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				textField.visible = false;
				TweenMax.to(textField,delayCounter*delay,{visible:true,onComplete:textFieldVisible,onCompleteParams:[textField]});
				delayCounter++;
			}
			
		}
		
		private function textFieldVisible(textField:TextField):void
		{
			TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
		}
		
		private function waitAnimationAttackEnds(elapsedTime:int):void
		{
			var damage:int = 0;
			var textField:TextField;
			var obj:Object;
			var rand:int;
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= m_animationTime * 0.5)
			{
				m_animationCounter = 0;
				if(m_callBackParams)
				{
					if(m_callBackParams[0] == m_char)
					{
						m_char.playAnimation("hit"+m_char.getRandomHitNumber(),1,m_animationTime/2000);
						obj = m_enemy.getDamage();
						damage = obj.damage;
						m_char.health -= damage;
						showDamage(obj,m_char,m_charRotOffset);
						
						rand = (Math.random() * 10000) % 100;
						if(m_char.dmgReturnChance > 0 && rand <= m_char.dmgReturnChance)
						{
							m_enemy.playAnimation("hit"+m_enemy.getRandomHitNumber(),1,m_animationTime/2000);
							damage = m_char.dmgReturnValue;
							m_enemy.health -= damage;
							showDamageReturnText(m_enemy,m_enemyRotOffset,damage);
						}
						
						if(obj.lifeSteal>0)
						{
							damage = obj.lifeSteal;
							m_enemy.health += damage;
							showLifeStealText(m_enemy,m_enemyRotOffset,damage);
						}
					}
					else if(m_callBackParams[0] == m_enemy)
					{
						m_enemy.playAnimation("hit"+m_enemy.getRandomHitNumber(),1,m_animationTime/2000);
						obj = m_char.getDamage();
						damage = obj.damage;
						m_enemy.health -= damage;
						showDamage(obj,m_enemy,m_enemyRotOffset);
						
						rand = (Math.random() * 10000) % 100;
						if(m_enemy.dmgReturnChance > 0 && rand <= m_enemy.dmgReturnChance)
						{
							m_char.playAnimation("hit"+m_enemy.getRandomHitNumber(),1,m_animationTime/2000);
							damage = m_enemy.dmgReturnValue;
							m_char.health -= damage;
							showDamageReturnText(m_char,m_charRotOffset,damage);
						}
						
						if(obj.lifeSteal>0)
						{
							damage = obj.lifeSteal;
							m_char.health += damage;
							showLifeStealText(m_char,m_charRotOffset,damage);
						}
						
					}
					m_callBackFunc = waitAnimationEnds2;
				}
				else
				{
					obj = m_enemy.getDamage();
					damage = obj.damage;
					m_char.health -= damage;
					
					showDamage(obj,m_char,m_charRotOffset);
					
					if(obj.lifeSteal>0)
					{
						damage = obj.lifeSteal;
						m_enemy.health += damage;
						showLifeStealText(m_enemy,m_enemyRotOffset,damage);
					}
					
					obj = m_char.getDamage();
					damage = obj.damage;
					m_enemy.health -= damage;
					
					showDamage(obj,m_enemy,m_enemyRotOffset);
					
					if(obj.lifeSteal>0)
					{
						damage = obj.lifeSteal;
						m_char.health += damage;
						showLifeStealText(m_char,m_charRotOffset,damage);
					}
					
					
					
					m_callBackFunc = checkAnyoneDies;
				}
			}
		}
		
		private function textFieldComplete(textField:TextField):void
		{
			textField.removeFromParent(true);
		}
		private function waitAnimationEnds(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= m_animationTime)
			{
				m_animationCounter = 0;
				m_callBackFunc = checkAnyoneDies;
			}
		}
		private function waitAnimationEnds2(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= m_animationTime * 0.5)
			{
				m_animationCounter = 0;
				m_callBackFunc = checkAnyoneDies;
			}
		}
		
		private function isAnyoneFall(charOnly:Boolean = false):Boolean
		{
			var someoneFall:Boolean = false;
			/*if(m_char.health <= 0)
			{
				m_char.playAnimation("die"+m_char.getRandomDieNumber(),1,m_animationTime/1000);
				//someoneFall = true;
			}*/
			if(m_enemy && m_enemy.health <= 0 && !charOnly && m_enemy.reviveCounter < m_enemy.reviveTimes)
			{
				m_enemy.fallChar();
				someoneFall = true;
			}
			
			if(someoneFall)
			{
				purgeAnyAilments();
			}
			
			return someoneFall;
		}
		
		private function isAnyoneDies(charOnly:Boolean = false):Boolean
		{
			var someoneDies:Boolean = false;
			if(m_char.health <= 0)
			{
				m_char.playAnimation("die"+m_char.getRandomDieNumber(),1,m_animationTime/1000);
				someoneDies = true;
			}
			if(m_enemy && m_enemy.health <= 0 && !charOnly)
			{
				m_enemy.playAnimation("die"+m_enemy.getRandomDieNumber(),1,m_animationTime/1000);
				someoneDies = true;
			}
			
			if(someoneDies)
			{
				
				purgeAnyAilments();
				if(m_char.health <= 0)
				{
					var str:String;
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						str = "YOU DIED";
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						str = "KAMU MATI!";
					}
					reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
					TweenMax.fromTo(multiFunctionText,0.3,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onDiedTextCreated,ease:Circ.easeOut});
					m_callBackFunc = null;
				}
				else
				{
					m_char.playAnimation("celebrate");
					m_statusBar2.calculateReduceExp();
					m_statusBar1.calculateAddExp(m_statusBar2.expManipulator,m_enemy.seizedExp);
					m_statusBar2.calculateReduceCoin();
					m_statusBar1.calculateAddCoin(m_statusBar2.coinManipulator,m_enemy.points);
					
					
					m_callBackFunc = waitUntilExpSeized;
					
					m_enemyCounter++;
				}
			}
			
			return someoneDies;
		}
		
		protected function purgeAnyAilments():void
		{
			if(m_char)
			{
				m_char.poisonCounter = 0;
				m_char.isPoisoned = false;
				
				m_char.isStrengthen = false;
				m_char.strengthenCounter = 0;
				
				m_char.isWeaken = false;
				m_char.weakenCounter = 0;
			}
			
			if(m_enemy)
			{
				m_enemy.poisonCounter = 0;
				m_enemy.isPoisoned = false;
				
				m_enemy.isStrengthen = false;
				m_enemy.strengthenCounter = 0;
				
				m_enemy.isWeaken = false;
				m_enemy.weakenCounter = 0;
			}
			
		}
		
		private function checkAnyoneDies(elapsedTime:int):void
		{
			if(isAnyoneFall())
			{
				showBlackQuads();
				m_rpsBar.hide();
				m_question.hide();
				m_callBackFunc = waitUntilPlayerBack;
			}
			else if(!isAnyoneDies())
			{
				m_callBackFunc = checkResults;
			}
		}
		
		private function waitUntilPlayerBack(elapsedTime:int):void
		{
			if(m_charRotationCounter < m_attackDistance)
			{
				m_char.rotation -= m_char.jumpSpeed * elapsedTime/1000;
				m_charRotationCounter += m_char.jumpSpeed * elapsedTime/1000;
				m_currentCharRotationCounter -= m_char.jumpSpeed * elapsedTime/1000;
			}
			if(m_charRotationCounter >= m_attackDistance)
			{
				m_char.playAnimation("battle");
				m_char.rotation += (m_charRotationCounter - m_attackDistance);
				m_currentCharRotationCounter += (m_charRotationCounter - m_attackDistance);
				m_charRotationCounter = 0;
				m_callBackFunc = waitUntilEnemyFell;
			}
		}
		private function waitUntilEnemyFell(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				m_enemy.setLevel(m_enemy.getLevel()+3);
				m_statusBar2.setSeizedExp(m_enemy.seizedExp);
				m_statusBar2.setLevel(m_enemy.getLevel());
				m_statusBar2.calculateReduceExp();
				var textField:TextField;
				var str:String;
				if(TG_Static.language == TG_Static.ENGLISH)
				{
					str = "Revived";
				}
				else if(TG_Static.language == TG_Static.INDONESIA)
				{
					str = "Hidup Kembali";
				}
				textField = createText(""+str,50,0xFFFF00);
				layerCharacter.addChild(textField);
				textField.rotation = m_enemy.rotation + m_enemyRotOffset;
				textField.pivotY += ((m_enemy.sprite.pivotY*m_enemy.sprite.scaleY) + (60*textField.scaleY)) / textField.scaleY;
				TweenMax.to(textField,2,{pivotY:getTFPivotYGoal(textField),alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
				
				m_clipLevelUpFX.visible = true;
				m_clipLevelUpFX.currentFrame = 1;
				m_clipLevelUpFX.play();
				m_clipLevelUpFX.scaleX = m_enemy.sprite.scaleX * 2;
				m_clipLevelUpFX.scaleY = m_enemy.sprite.scaleY * 2;
				m_enemy.sprite.addChild(m_clipLevelUpFX);
				
				m_enemy.reviveChar();
				m_callBackFunc = waitUntilEnemyRevived;
			}
		}
		
		private function waitUntilEnemyRevived(elapsedTime:int):void
		{
			m_counterTime+=elapsedTime;
			if(m_counterTime>500)
			{
				m_counterTime = 0;
				hideBlackQuads();
				m_callBackFunc = waitUntilEnemyBack;
			}
		}
		
		private function waitUntilEnemyBack(elapsedTime:int):void
		{
			if(m_enemyRotationCounter < m_attackDistance)
			{
				m_enemy.rotation += m_enemy.jumpSpeed * elapsedTime/1000;
				m_enemyRotationCounter += m_enemy.jumpSpeed * elapsedTime/1000;
			}
			if(m_enemyRotationCounter >= m_attackDistance)
			{
				m_enemy.playAnimation("battle");
				m_enemy.rotation -= (m_enemyRotationCounter - m_attackDistance);
				m_rpsBar.show();
				m_question.show();
				m_enemyRotationCounter = 0;
				m_callBackFunc = takeNextQuestions;
			}
		}
		
		private function waitUntilExpSeized(elapsedTime:int):void
		{
			var done:Boolean = true;
			if(!m_statusBar2.reduceCoin(elapsedTime))
			{
				done = false;
			}
			if(!m_statusBar2.reduceExp(elapsedTime))
			{
				done = false;
			}
			if(!m_statusBar1.addCoin(elapsedTime))
			{
				done = false;
			}
			if(!m_statusBar1.addExp(elapsedTime))
			{
				done = false;
			}
			
			if(done)
			{
				m_callBackFunc = waitUntilDieAnimationFinished;
			}
		}
		private function waitUntilDieAnimationFinished(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 100)
			{
				m_rpsBar.hide();
				m_question.hide();
				m_statusBar2.hide();
				m_animationCounter = 0;
				m_rpsBarHided = true;
				
				TweenMax.to(m_enemy.sprite,1,{alpha:0.1,visible:false,delay:4,onComplete:onEnemyKilled,onCompleteParams:[m_enemy]});
				if(!m_char.isLevelingUp)
				{
					m_char.playAnimation("walk");
					m_callBackFunc = moveUntilPlayerAtTheMiddle;
				}
				else
				{
					m_callBackFunc = checkRPSBarHide;
				}
				
				
			}
		}
		
		private function checkRPSBarHide(elapsedTime:int):void
		{
			if(m_rpsBarHided && m_statusInfo && m_statusInfo.sprite.visible)
			{
				m_statusInfo.nextSprite.visible = true;
				m_callBackFunc = null;
			}
		}
		
		private function onEnemyKilled(char:TG_Character):void
		{
			char.destroy();
		}
		
		private function moveUntilPlayerAtTheMiddle(elapsedTime:int):void
		{
			if(m_currentCharRotationCounter < m_currentDynamicLayerRotationCounter)
			{
				m_char.rotation += m_char.speed * elapsedTime/1000;
				m_currentCharRotationCounter += m_char.speed * elapsedTime/1000;
			}
			
			else if(m_currentCharRotationCounter >= m_currentDynamicLayerRotationCounter)
			{
				m_char.rotation -= (m_currentCharRotationCounter - m_currentDynamicLayerRotationCounter);
				m_distancePause = false;
				m_char.moving = true;
				m_callBackFunc = null;
				
				m_distanceBeforeFindSomething = ((Math.random() * 1000) % 0.2) + 0.5;
				m_charRotationCounter = 0;
				m_currentCharRotationCounter = 0;
				m_currentDynamicLayerRotationCounter = 0;
				
				if(m_princessID > 0)
				{
					createPrincess(m_princessID);
				}
				
			}
		}
		
		private function onDiedTextCreated():void
		{
			TweenMax.fromTo(multiFunctionText,0.5,{alpha:1},{alpha:0.1,delay:1,onComplete:onDiedTextCompleted});
		}
		private function onDiedTextCompleted():void
		{
			multiFunctionText.visible = false;
			TG_GameManager.getInstance().changeGameState(TG_StartMenuState,TG_Static.layerInGame);
		}
		
		public override function resize():void
		{
			super.resize();
			var posX:Number = 0;
			var posY:Number = 0;
			if(m_quadTop && m_quadTop.visible)
			{
				m_quadTop.width = TG_World.GAME_WIDTH;
				m_quadTop.height = 60 * TG_World.SCALE_ROUNDED;
				m_quadTop.y = 0;
			}
			if(m_quadBot && m_quadBot.visible)
			{
				m_quadBot.width = TG_World.GAME_WIDTH;
				m_quadBot.height = 60 * TG_World.SCALE_ROUNDED;
				m_quadBot.y = TG_World.GAME_HEIGHT-m_quadBot.height;
			}
			if(m_statusInfo && m_statusInfo.sprite.visible && m_quadTop && m_quadTop.visible)
			{
				posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width) * 0.5;
				posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
				m_statusInfo.sprite.x = posX;
				m_statusInfo.sprite.y = posY;
			}
			if(m_statusInfo && m_statusInfo.sprite.visible && m_quadTop && !m_quadTop.visible)
			{
				posX = (TG_World.GAME_WIDTH - m_statusInfo.sprite.width);
				posY = (TG_World.GAME_HEIGHT - m_statusInfo.sprite.height);
				m_statusInfo.sprite.x = posX;
				m_statusInfo.sprite.y = posY;
			}
			if(multiFunctionText && multiFunctionText.visible && m_quadTop && m_quadTop.visible)
			{
				posX = (TG_World.GAME_WIDTH) * 0.5;
				posY = m_quadTop.height;
				multiFunctionText.x = posX;
				multiFunctionText.y = posY;
			}
			if(m_shopBar && m_shopBar.sprite.visible)
			{
				var middleX:Number = (TG_World.GAME_WIDTH - m_shopBar.sprite.width) * 0.5;
				var middleY:Number = 50 * TG_World.SCALE;
				m_shopBar.sprite.x = middleX;
				m_shopBar.sprite.y = middleY;
			}
		}
		/******************ALTERNATIVES********************************/
		/*private function updateBackJump(elapsedTime:int):void
		{
		var jumpSpeed:Number = 0.5;
		var maxDistance:Number = 0.8;
		var difference:Number = 0;
		
		m_char.rotation -= jumpSpeed * elapsedTime/1000;
		layerNormalground.rotation += (jumpSpeed) * elapsedTime/1000;
		layerCharacter.rotation += (jumpSpeed) * elapsedTime/1000;
		layerForeground.rotation += (jumpSpeed) * elapsedTime/1000;
		layerBackground.rotation += (jumpSpeed) * elapsedTime/1000;
		layerDynamic.rotation -= jumpSpeed * elapsedTime/1000;
		
		if(m_enemy.rotation > m_char.rotation)
		{
		difference = m_enemy.rotation - m_char.rotation;
		}
		else
		{
		difference = m_char.rotation - m_enemy.rotation;
		}
		
		
		if(difference >= maxDistance )
		{
		if(difference > maxDistance)
		{
		difference = maxDistance - difference;
		if(m_enemy.rotation < m_char.rotation)
		{
		difference = -difference;
		}
		
		m_char.rotation += difference;
		layerNormalground.rotation -= difference;
		layerCharacter.rotation -= difference;
		layerForeground.rotation -= difference;
		layerBackground.rotation -= difference;
		}
		m_char.playAnimation("battle");
		createText("FIGHT!",TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
		TweenMax.fromTo(multiFunctionText,0.2,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{delay:2,scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onFightTextCreated,ease:Circ.easeOut});
		m_callBackFunc = null;
		}
		}*/
		
		/*************************************************************************/
	}
}