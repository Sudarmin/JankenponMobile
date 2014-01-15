package p_gameState.p_inGameState
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import dragonBones.animation.WorldClock;
	
	import p_engine.p_singleton.TG_GameManager;
	import p_engine.p_singleton.TG_World;
	
	import p_entity.TG_Character;
	
	import p_gameState.TG_InGameState;
	import p_gameState.TG_StartMenuState;
	
	import p_menuBar.TG_QuestionTypeB;
	import p_menuBar.TG_QuestionTypeC;
	import p_menuBar.TG_RPSBar;
	import p_menuBar.TG_RPSBarVersus;
	import p_menuBar.TG_StatusBar;
	
	import p_static.TG_Static;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class TG_LuckyBoutState extends TG_InGameState
	{
		private var m_char:TG_Character;
		private var m_enemy:TG_Character;
		private var m_callBackFunc:Function;
		private var m_callBackParams:Array;
		
		private var m_rpsBar1:TG_RPSBarVersus;
		private var m_rpsBar2:TG_RPSBarVersus;
		private var m_statusBar1:TG_StatusBar;
		private var m_statusBar2:TG_StatusBar;
		private var m_question:TG_QuestionTypeC;
		
		private var m_distanceDifference:Number = 1;
		private var m_attackDistance:Number = 0.4;
		private var m_charRotationCounter:Number = 0;
		private var m_enemyRotationCounter:Number = 0;
		
		private var m_animationCounter:int = 0;
		private var m_animationTime:int = 500;
		
		private var m_battleCounter:int = 0;
		private var m_timeInitial:int = 5000;
		private var m_levelStart:int = 4;
		
		private var m_currentDynamicLayerRotationCounter:Number = 0;
		private var m_currentCharRotationCounter:Number = 0;
		
		public function TG_LuckyBoutState(parent:DisplayObjectContainer)
		{
			super(parent);
		}
		
		public override function init():void
		{
			super.init();
			m_char = new TG_Character(layerCharacter,"right");
			m_char.addEventListener(TG_Character.LOADED,onCharLoaded);
		}
		
		protected override function initMenuBars():void
		{
			super.initMenuBars();
			m_rpsBar1 = new TG_RPSBarVersus(m_sprite,this,"left");
			m_rpsBar2 = new TG_RPSBarVersus(m_sprite,this,"right");
			m_statusBar1 = new TG_StatusBar(m_sprite,this,"left");
			m_statusBar1.blueBarInvisible();
			m_statusBar2 = new TG_StatusBar(m_sprite,this,"right");
			m_statusBar2.blueBarInvisible();
			m_question = new TG_QuestionTypeC(m_sprite,this);
			m_question.invisible();
		}
		
		private function onCharLoaded(e:Event):void
		{
			m_char.playAnimation("battle");
			m_char.rotation = -m_distanceDifference * 0.5;
			m_statusBar1.setChar(m_char);
			m_statusBar1.name = m_char.name;
			m_char.setLevel(10);
			m_statusBar1.setLevel(m_char.getLevel());
			m_statusBar1.blueText.visible = false;
			m_statusBar1.blueBarInvisible();
			
			m_enemy = new TG_Character(layerCharacter,"left");
			m_enemy.addEventListener(TG_Character.LOADED,onEnemyLoaded);
			
			
		}
		
		private function onEnemyLoaded(e:Event):void
		{
			m_enemy.playAnimation("battle");
			m_enemy.rotation = m_distanceDifference * 0.5;
			m_statusBar2.setChar(m_enemy);
			m_statusBar2.name = m_enemy.name;
			m_enemy.setLevel(10);
			m_statusBar2.setLevel(m_enemy.getLevel());
			m_statusBar2.blueText.visible = false;
			m_statusBar2.blueBarInvisible();
			
			showStartText();
		}
		
		protected override function onStartTextCompleted():void
		{
			super.onStartTextCompleted();
			if(multiFunctionText)
			{
				multiFunctionText.visible = false;
			}
			
			if(m_question)
			{
				m_question.level = 3;
				m_question.show();
			}
			
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
			if(m_question)
			{
				m_question.showQuestion();
				m_question.startBattle();
			}
			m_callBackFunc = checkAnswers;
		}
		
		private function checkAnswers(elapsedTime:int):void
		{
			if(m_question.isTimeOut() || m_question.isAllAnswered())
			{
				m_question.copyAnswers1();
				m_callBackFunc = waitCopyDone;
			}
			
		}
		private function waitCopyDone(elapsedTime:int):void
		{
			if(m_question.copyDone1 && m_question.copyDone2)
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
			movePlayerBack(elapsedTime);
			moveEnemyBack(elapsedTime);
			if(m_charRotationCounter >= m_attackDistance && m_enemyRotationCounter >= m_attackDistance)
			{
				m_charRotationCounter = 0;
				m_enemyRotationCounter = 0;
				m_callBackFunc = takeNextQuestions;
			}
		}
		
		private function takeNextQuestions(elapsedTime:int):void
		{
			m_question.showUnAnsweredIcon();
			m_question.showQuestion();
			m_question.startBattle();
			
			m_callBackFunc = checkAnswers;
		}
		
		private function checkResults(elapsedTime:int):void
		{
			var whoWon:int = m_question.checkNextAnswer();
			var rand:int;
			//DRAW
			if(whoWon == 0)
			{
				rand = (Math.random() * 1000) % 2;
				if(rand == 0)
				{
					m_callBackFunc = enemyAttacksPlayerEvade;
				}
				else
				{
					m_callBackFunc = playerAttacksEnemyEvade;
				}
				
			}
				//PLAYER WON
			else if(whoWon == 1)
			{
				m_callBackFunc = playerAttacks;
			}
				//ENEMY WON
			else if(whoWon == 2)
			{
				m_callBackFunc = enemyAttacks;
			}
				//BATTLE ENDS
			else if(whoWon == -1)
			{
				m_char.playAnimation("backjump");
				m_enemy.playAnimation("backjump");
				m_callBackFunc = moveBothBack;
			}
		}
		
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
		private function waitAnimationAttackEnds(elapsedTime:int):void
		{
			var damage:int = 0;
			var textField:TextField;
			var obj:Object;
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= m_animationTime * 0.4)
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
						textField = createText(""+damage,50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_char.rotation + 0.02;
						textField.pivotY += (m_char.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,2,{pivotY:(textField.pivotY+(250*textField.scaleY))/textField.scaleY,alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					else if(m_callBackParams[0] == m_enemy)
					{
						m_enemy.playAnimation("hit"+m_enemy.getRandomHitNumber(),1,m_animationTime/2000);
						obj = m_char.getDamage();
						damage = obj.damage;
						m_enemy.health -= damage;
						textField = createText(""+damage,50,0xFFFF00);
						layerCharacter.addChild(textField);
						textField.rotation = m_enemy.rotation - 0.02;
						textField.pivotY += (m_char.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
						TweenMax.to(textField,2,{pivotY:(textField.pivotY+(250*textField.scaleY))/textField.scaleY,alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					}
					m_callBackFunc = waitAnimationEnds2;
				}
				else
				{
					obj = m_enemy.getDamage();
					damage = obj.damage;
					m_char.health -= damage;
					
					textField = createText(""+damage,50,0xFFFF00);
					layerCharacter.addChild(textField);
					textField.rotation = m_char.rotation + 0.02;
					textField.pivotY += (m_char.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:(textField.pivotY+(250*textField.scaleY))/textField.scaleY,alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					
					
					obj = m_char.getDamage();
					damage = obj.damage;
					m_enemy.health -= damage;
					
					textField = createText(""+damage,50,0xFFFF00);
					layerCharacter.addChild(textField);
					textField.rotation = m_enemy.rotation - 0.02;
					textField.pivotY += (m_char.sprite.pivotY + (60*textField.scaleY)) / textField.scaleY;
					TweenMax.to(textField,2,{pivotY:(textField.pivotY+(250*textField.scaleY))/textField.scaleY,alpha:0.1,onComplete:textFieldComplete,onCompleteParams:[textField]});
					
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
		private function checkAnyoneDies(elapsedTime:int):void
		{
			var someoneDies:Boolean = false;
			if(m_char.health <= 0)
			{
				m_char.playAnimation("die"+m_char.getRandomDieNumber(),1,m_animationTime/1000);
				someoneDies = true;
			}
			if(m_enemy.health <= 0)
			{
				m_enemy.playAnimation("die"+m_enemy.getRandomDieNumber(),1,m_animationTime/1000);
				someoneDies = true;
			}
			
			if(someoneDies)
			{
				var str:String;
				if(m_char.health <= 0)
				{
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						str = "PLAYER 2 WINS";
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						str = "PEMAIN KE 2 MENANG";
					}
					reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
					m_enemy.playAnimation("celebrate");
					TweenMax.fromTo(multiFunctionText,0.3,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onDiedTextCreated,ease:Circ.easeOut});
					m_callBackFunc = null;
				}
				else
				{
					if(TG_Static.language == TG_Static.ENGLISH)
					{
						str = "PLAYER 1 WINS";
					}
					else if(TG_Static.language == TG_Static.INDONESIA)
					{
						str = "PEMAIN KE 1 MENANG";
					}
					reuseText(str,TG_World.GAME_WIDTH * 0.5,TG_World.GAME_HEIGHT * 0.3);
					m_char.playAnimation("celebrate");
					TweenMax.fromTo(multiFunctionText,0.3,{scaleX:TG_World.SCALE_ROUNDED * 5,scaleY:TG_World.SCALE_ROUNDED * 5},{scaleX:TG_World.SCALE_ROUNDED * 0.5,scaleY:TG_World.SCALE_ROUNDED * 0.5,onComplete:onDiedTextCreated,ease:Circ.easeOut});
					m_callBackFunc = null;
				}
			}
			else
			{
				m_callBackFunc = checkResults;
			}
			
		}
		
		private function waitUntilDieAnimationFinished(elapsedTime:int):void
		{
			m_animationCounter += elapsedTime;
			if(m_animationCounter >= 100)
			{
				m_animationCounter = 0;
				m_char.playAnimation("walk");
				m_rpsBar1.hide();
				m_question.hide();
				m_statusBar2.hide();
				TweenMax.to(m_enemy.sprite,1,{alpha:0.1,visible:false,delay:4,onComplete:onEnemyKilled,onCompleteParams:[m_enemy]});
				m_callBackFunc = null;
			}
		}
		
		private function onEnemyKilled(char:TG_Character):void
		{
			char.destroy();
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
		public override function doSomething(str:String):void
		{
			switch(str)
			{
				case"rockPressedleft":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(0,1);
					break;
				case"paperPressedleft":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(1,1);
					break;
				case"scissorPressedleft":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(2,1);
					break;
				case"rockPressedright":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(0,2);
					break;
				case"paperPressedright":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(1,2);
					break;
				case"scissorPressedright":
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(2,2);
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
						m_question.putNextAnswer(0,1);
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
						m_question.putNextAnswer(1,1);
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
						m_question.putNextAnswer(2,1);
				}
				if(m_keyPoll.isUp(69) && m_keyArray[69])
				{
					m_keyArray[69] = false;
				}
				
				
				//I
				if(m_keyPoll.isDown(73) && !m_keyArray[73])
				{
					m_keyArray[73] = true;
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(0,2);
				}
				if(m_keyPoll.isUp(73) && m_keyArray[73])
				{
					m_keyArray[73] = false;
				}
				
				//O
				if(m_keyPoll.isDown(79) && !m_keyArray[79])
				{
					m_keyArray[79] = true;
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(1,2);
				}
				if(m_keyPoll.isUp(79) && m_keyArray[79])
				{
					m_keyArray[79] = false;
				}
				
				//P
				if(m_keyPoll.isDown(80) && !m_keyArray[80])
				{
					m_keyArray[80] = true;
					if(!m_question.isTimeOut())
						m_question.putNextAnswer(2,2);
				}
				if(m_keyPoll.isUp(80) && m_keyArray[80])
				{
					m_keyArray[80] = false;
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
			}
			if(m_enemy)
			{
				m_enemy.update(elapsedTime);
			}
			if(m_callBackFunc != null)
			{
				m_callBackFunc(elapsedTime);
			}
		}
	}
}