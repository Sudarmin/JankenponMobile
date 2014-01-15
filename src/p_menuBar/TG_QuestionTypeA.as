package p_menuBar
{
	import com.greensock.TweenMax;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	
	public class TG_QuestionTypeA extends TG_MenuBar
	{
		private var m_questionSprites:Array;
		private var m_questions:Array;
		private var m_numOfQuestion:int = 3;
		private var m_answerSprites:Array;
		private var m_answers:Array;
		private var m_timeBarFrame:Image;
		private var m_timeBar:Image;
		private var m_timeText:TextField;
		private var m_level:int = 0;
		private var m_answerCounter:int = 0;
		private var m_resultCounter:int = 0;
		
		
		private var m_timeCounter:int = 0;
		private var m_timeTotal:int = 0;
		private var m_timeBarInitialWidth:Number = 0;
		private static const ROCK:int = 0;
		private static const PAPER:int = 1;
		private static const SCISSOR:int = 2;
		
		private var m_ready:Boolean = false;
		
		private static const NORMAL:int = 0;
		private static const LAST_ONE_OPEN_LATER:int = 1;
		private static const LAST_ONE_CLOSED:int = 2;
		private static const LAST_TWO_OPEN_LATER:int = 3;
		private static const RANDOM_ONE_CLOSED:int = 4;
		private static const RANDOM_TWO_CLOSED:int = 5;
		private static const ONE_CLOSED_ONE_OPEN_LATER:int = 6;
		private static const ONE_CLOSED_TWO_OPEN_LATER:int = 7;
		private static const LAST_THREE_OPEN_LATER:int = 8;
		private static const TWO_CLOSED_ONE_OPEN_LATER:int = 9;
		private static const TWO_CLOSED_TWO_OPEN_LATER:int = 10;
		private static const LAST_FOUR_OPEN_LATER:int = 11;
		private static const RANDOM_THREE_CLOSED:int = 12;
		private static const RANDOM_FOUR_CLOSED:int = 13;
		private static const RANDOM_FOUR_CLOSED_ONE_OPEN_LATER:int = 14;
		
		private var m_state:int = NORMAL;
		private var m_openLaterArray:Array;
		private var m_closedArray:Array;
		
		private var m_chanceToReverse:int = 0;
		public function TG_QuestionTypeA(parent:DisplayObjectContainer, gameState:TG_GameState)
		{
			super(parent, gameState);
		}
		
		public override function init():void
		{
			super.init();
		}
		public function set level(value:int):void
		{
			resetLevel(value);
			
			m_timeText.text = ""+(m_timeTotal/1000)+"s";
			showUnAnsweredIcon();
			resize();
		}
		public function set chanceToReverse(num:int):void
		{
			m_chanceToReverse = num;
		}
		public function get chanceToReverse():int
		{
			return m_chanceToReverse;
		}
		public function resetLevel(value:int):void
		{
			if(value == 0)
			{
				m_numOfQuestion = 3;
				m_timeTotal = 7000;
				m_state = NORMAL;
				m_chanceToReverse = 0;
			}
			else if(value == 1)
			{
				m_numOfQuestion = 4;
				m_timeTotal = 6000;
				m_state = NORMAL;
				m_chanceToReverse = 0;
			}
			else if(value == 2)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = NORMAL;
				m_chanceToReverse = 0;
			}
			else if(value == 3)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = LAST_ONE_OPEN_LATER;
				m_chanceToReverse = 0;
			}
			else if(value == 4)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = LAST_ONE_CLOSED;
				m_chanceToReverse = 0;
			}
			else if(value == 5)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = LAST_TWO_OPEN_LATER;
				m_chanceToReverse = 10;
			}
			else if(value == 6)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = RANDOM_ONE_CLOSED;
				m_chanceToReverse = 20;
			}
			else if(value == 7)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = RANDOM_TWO_CLOSED;
				m_chanceToReverse = 20;
			}
			else if(value == 8)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = ONE_CLOSED_ONE_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 9)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = ONE_CLOSED_TWO_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 10)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = LAST_THREE_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 11)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = TWO_CLOSED_ONE_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 12)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = TWO_CLOSED_TWO_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 13)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = LAST_FOUR_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else if(value == 14)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_THREE_CLOSED;
				m_chanceToReverse = 30;
			}
			else if(value == 15)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_FOUR_CLOSED;
				m_chanceToReverse = 30;
			}
			else if(value == 16)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_FOUR_CLOSED_ONE_OPEN_LATER;
				m_chanceToReverse = 30;
			}
			else
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				var rand:int = (Math.random() * 1000) % 9;
				rand+= 5;
				m_state = rand;
				m_chanceToReverse = 30;
			}
		}
		protected override function initSprite():void
		{
			super.initSprite();
			m_sprite = new Sprite();
			
			
			m_timeBarFrame = new Image(TG_World.assetManager.getTexture("TimeBarFrame"));
			m_sprite.addChild(m_timeBarFrame);
			
			m_timeBar = new Image(TG_World.assetManager.getTexture("TimeBar"));
			m_sprite.addChild(m_timeBar);
			
			m_timeText = new TextField(50,50,"15s","Londrina",20,0xFFFFFF);
			m_timeText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			m_timeText.x = m_timeBar.x + (m_timeBar.width * 0.5);
			m_timeText.y = m_timeBar.y;
			m_sprite.addChild(m_timeText);
		}
		
		public function showUnAnsweredIcon():void
		{
			var sprite:Sprite;
			var image:Image;
			var i:int = 0;
			var size:int = 0;
			
			if(m_answerSprites)
			{
				i = 0;
				size = m_answerSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_answerSprites[i];
					sprite.removeFromParent();
				}
			}
			m_answerSprites = [];
			m_answers = [];
			m_answerCounter = 0;
			m_timeCounter = 0;
			i = 0;
			size = m_numOfQuestion;
			for(i;i<size;i++)
			{
				image = new Image(TG_World.assetManager.getTexture("IconAnswer"));
				sprite = new Sprite();
				sprite.addChild(image);
				sprite.pivotX = sprite.width * 0.5;
				sprite.pivotY = sprite.height * 0.5;
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
				m_answerSprites.push(sprite);
				m_sprite.addChild(sprite);
				if(i>0)
				{
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
				}
				sprite.x += sprite.width * 0.5;
				sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
				sprite.y += sprite.height * 0.5;
			}
			
			m_timeBar.width =  m_timeBarInitialWidth;
			m_timeText.text = ""+(int(m_timeTotal/1000))+"s";
		}
		
		private final function getRandomIndexes(source:Array,dest:Array,size:int):void
		{
			var i:int = 0;
			var rand:int = 0;
			for(i;i<size;i++)
			{
				rand = (Math.random() * 1000) % source.length;
				dest.push(source[rand]);
				source.splice(rand,1);
			}
		}
		public function showQuestion(level:int = -1,reverseChance:int = -1):void
		{
			if(level >= 0)
			{
				resetLevel(level);
			}
			if(reverseChance>-1)
			{
				m_chanceToReverse = reverseChance;
			}
			m_ready = false;
			var image:Image;
			var sprite:Sprite;
			var i:int = 0;
			var size:int = 0;
			var rand:int = 0;
			if(m_questionSprites)
			{
				i = 0;
				size = m_questionSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_questionSprites[i];
					sprite.removeFromParent();
				}
			}
			m_questionSprites = [];
			m_questions = [];
			m_openLaterArray = [];
			m_closedArray = [];
			
			var tempArray:Array = [];
			i = 0;
			size = m_numOfQuestion
			for(i;i<size;i++)
			{
				tempArray.push(i);
			}
			
			if(m_state == LAST_ONE_OPEN_LATER)
			{
				m_openLaterArray.push(4);
			}
			else if(m_state == LAST_ONE_CLOSED)
			{
				m_closedArray.push(4);
			}
			else if(m_state == LAST_TWO_OPEN_LATER)
			{
				m_openLaterArray.push(3);
				m_openLaterArray.push(4);
			}
			else if(m_state == RANDOM_ONE_CLOSED)
			{
				getRandomIndexes(tempArray,m_closedArray,1);
			}
			else if(m_state == RANDOM_TWO_CLOSED)
			{
				getRandomIndexes(tempArray,m_closedArray,2);
			}
			else if(m_state == ONE_CLOSED_ONE_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				getRandomIndexes(tempArray,m_closedArray,1);
			}
			else if(m_state == ONE_CLOSED_TWO_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				m_openLaterArray.push(3);
				tempArray.splice(3,1);
				getRandomIndexes(tempArray,m_closedArray,1);
			}
			else if(m_state == LAST_THREE_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				m_openLaterArray.push(3);
				tempArray.splice(3,1);
				m_openLaterArray.push(2);
				tempArray.splice(2,1);
			}
			else if(m_state == TWO_CLOSED_ONE_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				getRandomIndexes(tempArray,m_closedArray,2);
			}
			else if(m_state == TWO_CLOSED_TWO_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				m_openLaterArray.push(3);
				tempArray.splice(3,1);
				getRandomIndexes(tempArray,m_closedArray,2);
			}
			else if(m_state == LAST_FOUR_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				m_openLaterArray.push(3);
				tempArray.splice(3,1);
				m_openLaterArray.push(2);
				tempArray.splice(2,1);
				m_openLaterArray.push(1);
				tempArray.splice(1,1);
			}
			else if(m_state == RANDOM_THREE_CLOSED)
			{
				getRandomIndexes(tempArray,m_closedArray,3);
			}
			else if(m_state == RANDOM_FOUR_CLOSED)
			{
				getRandomIndexes(tempArray,m_closedArray,4);
			}
			else if(m_state == RANDOM_FOUR_CLOSED_ONE_OPEN_LATER)
			{
				m_openLaterArray.push(4);
				tempArray.splice(4,1);
				getRandomIndexes(tempArray,m_closedArray,4);
			}
			
			
			
			i = 0;
			size = m_numOfQuestion;
			
			var j:int = 0;
			var closedSize:int = m_closedArray.length;
			var openSize:int = m_openLaterArray.length;
			var insideState:Boolean = false;
			for(i;i<size;i++)
			{
				insideState = false;
				rand = (Math.random() * 1000) % 3;
				m_questions.push(rand);
				
				/**** OPEN LATER ***/
				j = 0;
				for(j;j<openSize;j++)
				{
					if(i == m_openLaterArray[j])
					{
						image = new Image(TG_World.assetManager.getTexture("IconQuestion"));
						insideState = true;
					}
				}
				
				/**** CLOSED FOREVER ***/
				j = 0;
				for(j;j<closedSize;j++)
				{
					if(i == m_closedArray[j])
					{
						image = new Image(TG_World.assetManager.getTexture("IconQuestion2"));
						insideState = true;
					}
				}
				
				
				if(!insideState)
				{
					image = createImageRPS(rand);
				}
				sprite = new Sprite();
				sprite.addChild(image);
				sprite.pivotX = sprite.width * 0.5;
				sprite.pivotY = sprite.height * 0.5;
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
				m_questionSprites.push(sprite);
				m_sprite.addChild(sprite);
				if(i>0)
				{
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
				}
				sprite.x += sprite.width * 0.5;
				sprite.visible = false;
				if(i == size-1)
				{
					TweenMax.fromTo(sprite,0.1,{y:-sprite.height,visible:true},{y:sprite.height * 0.5,delay:0.1*i,onComplete:questionAnimationCompleted});
				}
				else
				{
					TweenMax.fromTo(sprite,0.1,{y:-sprite.height,visible:true},{y:sprite.height * 0.5,delay:0.1*i});
				}
			}
		}
		public final function resetForNextBattle():void
		{
			var image:Image;
			var sprite:Sprite;
			var i:int = 0;
			var size:int = 0;
			if(m_questionSprites)
			{
				i = 0;
				size = m_questionSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_questionSprites[i];
					sprite.removeFromParent();
				}
			}
			m_ready = false;
			m_timeCounter = 0;
			m_answerCounter = 0;
			
			m_timeBar.width =  m_timeBarInitialWidth;
			m_timeText.text = ""+(int(m_timeTotal/1000))+"s";
		}
		private final function questionAnimationCompleted():void
		{
			m_answers = [];
			m_answerCounter = 0;
			m_resultCounter = 0;
			m_ready = true;
			m_timeCounter = 0;
		}
		
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
			if(m_ready)
			{
				if(m_timeCounter < m_timeTotal && !isAllAnswered())
				{
					m_timeCounter += elapsedTime;
					var timeLeft:int = m_timeTotal - m_timeCounter;
					m_timeBar.width = (timeLeft/m_timeTotal) * m_timeBarInitialWidth;
					m_timeText.text = ""+(int(timeLeft/1000)+1)+"s";
				}
				else if(m_timeCounter > m_timeTotal)
				{
					m_timeBar.width = 0;
					m_timeText.text = ""+0+"s";
					m_timeCounter = 0;
					m_ready = false;
				}
			}
		}
		private final function createImageRPS(value:int,answer:Boolean = false):Image
		{
			var image:Image;
			var reversed:Boolean = false;
			if(m_chanceToReverse > 0 && !answer)
			{
				var rand:int = (Math.random() * 10000) % 100;
				if(rand <= m_chanceToReverse)
				{
					reversed = true;
				}
			}
			if(value == ROCK)
			{
				if(reversed)
				{
					image = new Image(TG_World.assetManager.getTexture("IconScissorReversed"));
				}
				else
				{
					image = new Image(TG_World.assetManager.getTexture("IconRock"));
				}
				
			}
			else if(value == PAPER)
			{
				if(reversed)
				{
					image = new Image(TG_World.assetManager.getTexture("IconRockReversed"));
				}
				else
				{
					image = new Image(TG_World.assetManager.getTexture("IconPaper"));
				}
				
			}
			else if(value == SCISSOR)
			{
				if(reversed)
				{
					image = new Image(TG_World.assetManager.getTexture("IconPaperReversed"));
				}
				else
				{
					image = new Image(TG_World.assetManager.getTexture("IconScissor"));
				}
				
			}
			return image;
		}
		
		public override function resize():void
		{
			super.resize();
			var i:int;
			var size:int;
			var sprite:Sprite;
			var image:Image;
			var totalWidth:Number = 0;
			if(m_questionSprites)
			{
				i = 0;
				size = m_questionSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_questionSprites[i];
					sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
					sprite.x += sprite.width * 0.5;
					sprite.y = sprite.height * 0.5;
				}
			}
			
			//292 is the fix size of the time bar
			m_timeBarInitialWidth = (292 * TG_World.SCALE_ROUNDED * 0.5);
			//72 is the fix size of an image
			var imageSize:Number = 72 * TG_World.SCALE_ROUNDED * 0.5;
			totalWidth = (imageSize+ (5*(TG_World.SCALE_ROUNDED-1))) * m_numOfQuestion;
			m_timeBarFrame.scaleX = m_timeBarFrame.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_timeBar.scaleX = m_timeBar.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_timeText.scaleX = m_timeText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			
			m_timeBarFrame.x = (totalWidth - m_timeBarFrame.width) * 0.5;
			m_timeBarFrame.y = imageSize;
			m_timeBar.x = ((m_timeBarFrame.width - m_timeBar.width ) * 0.5 ) + m_timeBarFrame.x;
			m_timeBar.y = ((m_timeBarFrame.height - m_timeBar.height ) * 0.5 ) + m_timeBarFrame.y;
			m_timeText.x = m_timeBar.x + (m_timeBar.width * 0.5);
			m_timeText.y = m_timeBar.y + ((m_timeBar.height - m_timeText.height) * 0.5);
			
			
			if(m_answerSprites)
			{
				i = 0;
				size = m_answerSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_answerSprites[i];
					sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
					sprite.x += sprite.width * 0.5;
					sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
					sprite.y += sprite.height * 0.5;
				}
			}
			
			m_sprite.x = (TG_World.GAME_WIDTH - m_sprite.width) * 0.5;
			
			refreshAnimation();
		}
		
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				var tween:TweenMax;
				tween = TweenMax.fromTo(m_sprite,0.3,{y:-m_sprite.height},{y:0});
				m_timeline.insert(tween,0);
				m_timeline.pause();
			}
		}
		
		public function putNextAnswer(value:int):void
		{
			if(!m_ready)return;
			if(m_answerCounter > m_numOfQuestion-1)return;
			
			m_answers[m_answerCounter] = value;
			var image:Image;
			image = createImageRPS(value,true);
			var sprite:Sprite;
			sprite = new Sprite();
			sprite.addChild(image);
			sprite.pivotX = sprite.width * 0.5;
			sprite.pivotY = sprite.height * 0.5;
			sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			var prevSprite:Sprite = m_answerSprites[m_answerCounter];
			if(prevSprite)
			{
				sprite.x = prevSprite.x;
				sprite.y = prevSprite.y;
				prevSprite.removeFromParent();
			}
			m_sprite.addChild(sprite);
			m_answerSprites[m_answerCounter] = sprite;
			m_answerCounter++;
			
			var i:int = 0;
			var size:int = 0;
			var num:int = 0;
			if(m_openLaterArray.length > 0)
			{
				i = 0;
				size = m_openLaterArray.length;
				for(i;i<size;i++)
				{
					num = m_openLaterArray[i];
					if(m_answerCounter == m_openLaterArray[i])
					{
						prevSprite = m_questionSprites[num];
						image = createImageRPS(m_questions[num]);
						sprite = new Sprite();
						sprite.addChild(image);
						sprite.pivotX = sprite.width * 0.5;
						sprite.pivotY = sprite.height * 0.5;
						sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
						if(prevSprite)
						{
							sprite.x = prevSprite.x;
							sprite.y = prevSprite.y;
							prevSprite.removeFromParent();
						}
						m_sprite.addChild(sprite);
						m_questionSprites[num] = sprite;
					}
					
				}
			}
		}
		
		private function addDrawIcon(sprite:Sprite):void
		{
			var image:Image;
			if(sprite.numChildren > 1)return;
			image = new Image(TG_World.assetManager.getTexture("DrawIcon"));
			image.x = (sprite.width - (image.width * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			image.y = (sprite.height - (image.height * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			sprite.addChild(image);
			image.alpha = 0.9;
			image.name = "icon";
		}
		private function addWinIcon(sprite:Sprite):void
		{
			var image:Image;
			if(sprite.numChildren > 1)return;
			image = new Image(TG_World.assetManager.getTexture("CheckIcon"));
			image.x = (sprite.width - (image.width * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			image.y = (sprite.height - (image.height * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			sprite.addChild(image);
			image.alpha = 0.9;
			image.name = "icon";
		}
		private function addLoseIcon(sprite:Sprite):void
		{
			var image:Image;
			if(sprite.numChildren > 1)return;
			image = new Image(TG_World.assetManager.getTexture("XIcon"));
			image.x = (sprite.width - (image.width * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			image.y = (sprite.height - (image.height * (TG_World.SCALE_ROUNDED-1))) * 0.5;
			sprite.addChild(image);
			image.alpha = 0.9;
			image.name = "icon";
		}
		
		private function addABitAnimation(sprite:Sprite):void
		{
			TweenMax.fromTo(sprite,0.2,{scaleX:sprite.scaleX * 2, scaleY:sprite.scaleY * 2},{scaleX:sprite.scaleX,scaleY:sprite.scaleY});
		}
		//-1 battle ends, 0 draw, 1 player won, 2 enemy won
		public function checkNextAnswer():int
		{
			
			//if there is still an answer waiting
			if(m_answers.length > m_resultCounter)
			{
				var i:int = 0;
				var size:int = 0;
				var num:int = 0;
				
				var image:Image;
				var sprite:Sprite;
				var prevSprite:Sprite;
				
				if(m_closedArray.length > 0)
				{
					i = 0;
					size = m_closedArray.length;
					for(i;i<size;i++)
					{
						num = m_closedArray[i];
						if(m_resultCounter == m_closedArray[i])
						{
							prevSprite = m_questionSprites[num];
							image = createImageRPS(m_questions[num],true);
							sprite = new Sprite();
							sprite.addChild(image);
							sprite.pivotX = sprite.width * 0.5;
							sprite.pivotY = sprite.height * 0.5;
							sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
							if(prevSprite)
							{
								sprite.x = prevSprite.x;
								sprite.y = prevSprite.y;
								prevSprite.removeFromParent();
							}
							m_sprite.addChild(sprite);
							m_questionSprites[num] = sprite;
						}
					}
				}
				
				addABitAnimation(m_answerSprites[m_resultCounter]);
				addABitAnimation(m_questionSprites[m_resultCounter]);
				//we check who wins
				if(m_answers[m_resultCounter] == ROCK)
				{
					if(m_questions[m_resultCounter] == ROCK)
					{
						addDrawIcon(m_answerSprites[m_resultCounter]);
						addDrawIcon(m_questionSprites[m_resultCounter]);
						m_resultCounter++;
						return 0;
					}
					else if(m_questions[m_resultCounter] == PAPER)
					{
						addLoseIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 2;
					}
					else if(m_questions[m_resultCounter] == SCISSOR)
					{
						addLoseIcon(m_questionSprites[m_resultCounter]);
						//addWinIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 1;
					}
				}
				else if(m_answers[m_resultCounter] == PAPER)
				{
					if(m_questions[m_resultCounter] == ROCK)
					{
						addLoseIcon(m_questionSprites[m_resultCounter]);
						//addWinIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 1;
					}
					else if(m_questions[m_resultCounter] == PAPER)
					{
						addDrawIcon(m_answerSprites[m_resultCounter]);
						addDrawIcon(m_questionSprites[m_resultCounter]);
						m_resultCounter++;
						return 0;
					}
					else if(m_questions[m_resultCounter] == SCISSOR)
					{
						addLoseIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 2;
					}
				}
				else if(m_answers[m_resultCounter] == SCISSOR)
				{
					if(m_questions[m_resultCounter] == ROCK)
					{
						addLoseIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 2;
					}
					else if(m_questions[m_resultCounter] == PAPER)
					{
						addLoseIcon(m_questionSprites[m_resultCounter]);
						//addWinIcon(m_answerSprites[m_resultCounter]);
						m_resultCounter++;
						return 1;
					}
					else if(m_questions[m_resultCounter] == SCISSOR)
					{
						addDrawIcon(m_answerSprites[m_resultCounter]);
						addDrawIcon(m_questionSprites[m_resultCounter]);
						m_resultCounter++;
						return 0;
					}
				}
			}
			
			//if we have reached the end of question
			if(m_resultCounter >= m_questions.length)
			{
				return -1;
			}
			
			//there's no answer waiting, so enemy won by default
			addLoseIcon(m_answerSprites[m_resultCounter]);
			m_resultCounter++;
			return 2;
		}
		
		public function reverseCurrentAnswer():void
		{
			var counter:int = m_resultCounter-1;
			var sprite1:Sprite = m_answerSprites[counter];
			var sprite2:Sprite = m_questionSprites[counter];
			
			TweenMax.to(sprite1,0.5,{x:sprite2.x, y:sprite2.y,scaleX:sprite1.scaleX,scaleY:sprite1.scaleY});
			TweenMax.to(sprite2,0.5,{x:sprite1.x, y:sprite1.y,scaleX:sprite2.scaleX,scaleY:sprite2.scaleY});
			sprite1.scaleX = sprite1.scaleX * 1.5;
			sprite1.scaleY = sprite1.scaleY * 1.5;
			sprite2.scaleX = sprite2.scaleX * 1.5;
			sprite2.scaleY = sprite2.scaleY * 1.5;
			
			var answer1:int = m_questions[counter];
			var answer2:int = m_answers[counter];
			m_questionSprites[counter] = sprite1;
			m_answerSprites[counter] = sprite2;
			m_answers[counter] = answer1;
			m_questions[counter] = answer2;
			m_resultCounter = counter;
		}
		
		public function isAllAnswered():Boolean
		{
			if(m_answerCounter >= m_numOfQuestion)
			{
				m_ready = false;
				return true;
			}
			return false;
		}
		
		public function isTimeOut():Boolean
		{
			if(m_timeCounter >= m_timeTotal)
			{
				m_timeBar.width = 0;
				m_timeText.text = ""+0+"s";
				m_ready = false;
				return true;
			}
			return false;
		}
		public function invisible():void
		{
			var sprite:Sprite;
			var i:int = 0;
			var size:int = 0;
			if(m_questionSprites)
			{
				i = 0;
				size = m_questionSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_questionSprites[i];
					sprite.removeFromParent();
				}
			}
			m_sprite.visible = false;
		}
		
		public override function show():void
		{
			invisible();
			m_sprite.visible = true;
			if(m_timeline)
			{
				m_timeline.gotoAndPlay(0);
			}
			m_ready = false;
		}
		
		public override function hide():void
		{
			TweenMax.to(m_sprite,0.5,{y:-m_sprite.height});
			m_ready = false;
		}
	}
}