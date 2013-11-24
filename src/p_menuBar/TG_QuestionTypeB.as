package p_menuBar
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class TG_QuestionTypeB extends TG_MenuBar
	{
		private var m_questionSprites:Array;
		private var m_questions:Array;
		private var m_numOfQuestion:int = 3;
		private var m_neutralSprites:Array;
		private var m_answerSprites1:Array;
		private var m_answers1:Array;
		private var m_answerSprites2:Array;
		private var m_answers2:Array;
		private var m_timeBarFrame:Image;
		private var m_timeBar:Image;
		private var m_timeText:TextField;
		private var m_level:int = 0;
		private var m_answerCounter1:int = 0;
		private var m_answerCounter2:int = 0;
		private var m_resultCounter:int = 0;
		private var m_copyDone:Boolean = false;
		
		
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
		
		private var m_chosenAnswer:Array;
		private var m_chosenAnswerSprites:Array;
		private var m_playerChosen:int = 0;
		public function TG_QuestionTypeB(parent:DisplayObjectContainer, gameState:TG_GameState)
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
		public function resetLevel(value:int):void
		{
			if(value == 0)
			{
				m_numOfQuestion = 3;
				m_timeTotal = 7000;
				m_state = NORMAL;
			}
			else if(value == 1)
			{
				m_numOfQuestion = 4;
				m_timeTotal = 6000;
				m_state = NORMAL;
			}
			else if(value == 2)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = NORMAL;
			}
			else if(value == 3)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = LAST_ONE_CLOSED;
			}
			else if(value == 4)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = LAST_ONE_CLOSED;
			}
			else if(value == 5)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = RANDOM_ONE_CLOSED;
			}
			else if(value == 6)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = RANDOM_ONE_CLOSED;
			}
			else if(value == 7)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 5000;
				m_state = RANDOM_TWO_CLOSED;
			}
			else if(value == 8)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = RANDOM_TWO_CLOSED;
			}
			else if(value == 9)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = RANDOM_TWO_CLOSED;
			}
			else if(value == 10)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = RANDOM_THREE_CLOSED;
			}
			else if(value == 11)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = RANDOM_THREE_CLOSED;
			}
			else if(value == 12)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 4000;
				m_state = RANDOM_THREE_CLOSED;
			}
			else if(value == 13)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_THREE_CLOSED;
			}
			else if(value == 14)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_THREE_CLOSED;
			}
			else if(value == 15)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_FOUR_CLOSED;
			}
			else if(value == 16)
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_FOUR_CLOSED;
			}
			else
			{
				m_numOfQuestion = 5;
				m_timeTotal = 3000;
				m_state = RANDOM_FOUR_CLOSED;
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
			
			if(m_answerSprites1)
			{
				i = 0;
				size = m_answerSprites1.length;
				for(i;i<size;i++)
				{
					sprite = m_answerSprites1[i];
					sprite.removeFromParent();
				}
			}
			if(m_answerSprites2)
			{
				i = 0;
				size = m_answerSprites2.length;
				for(i;i<size;i++)
				{
					sprite = m_answerSprites2[i];
					sprite.removeFromParent();
				}
			}
			m_answerSprites1 = [];
			m_answers1 = [];
			m_answerSprites2 = [];
			m_answers2 = [];
			m_neutralSprites = [];
			m_answerCounter1 = 0;
			m_answerCounter2 = 0;
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
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
				m_answerSprites1.push(sprite);
				m_sprite.addChild(sprite);
				if(i>0)
				{
					sprite.x = sprite.width * i;
				}
				sprite.x += sprite.width * 0.5;
				sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
				sprite.y += sprite.height * 0.5;
				sprite.visible = false;
				TweenMax.fromTo(sprite,0.3,{y:-sprite.height,visible:true},{y:sprite.y,delay:0.1 * i})
			}
			
			
			size = m_numOfQuestion;
			i = size-1;
			var counter:int = 1;
			for(i;i>=0;i--)
			{
				image = new Image(TG_World.assetManager.getTexture("IconAnswer"));
				sprite = new Sprite();
				sprite.addChild(image);
				sprite.pivotX = sprite.width * 0.5;
				sprite.pivotY = sprite.height * 0.5;
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
				m_answerSprites2[i] = sprite;
				m_sprite.addChild(sprite);
				sprite.x = TG_World.GAME_WIDTH - (sprite.width*counter);
				sprite.x += sprite.width * 0.5;
				sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
				sprite.y += sprite.height * 0.5;
				counter++;
				sprite.visible = false;
				TweenMax.fromTo(sprite,0.3,{y:-sprite.height,visible:true},{y:sprite.y,delay:0.1 * i})
			}
			
			//72 is the fix size of an image
			var imageSize:Number = 72 * TG_World.SCALE_ROUNDED * 0.5;
			var totalWidth:Number = (imageSize + (5*(TG_World.SCALE_ROUNDED-1))) * m_numOfQuestion;
			var middleStartX:Number = (TG_World.GAME_WIDTH - totalWidth) * 0.5;
			
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
				m_neutralSprites.push(sprite);
				m_sprite.addChild(sprite);
				if(i>0)
				{
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
				}
				sprite.x += sprite.width * 0.5;
				sprite.x += middleStartX;
				sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
				sprite.y += sprite.height * 0.5;
				sprite.visible = false;
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
		public function showQuestion(level:int = -1):void
		{
			if(level >= 0)
			{
				resetLevel(level);
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
			m_copyDone = false;
			
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
			//72 is the fix size of an image
			var imageSize:Number = 72 * TG_World.SCALE_ROUNDED * 0.5;
			var totalWidth:Number = (imageSize + (5*(TG_World.SCALE_ROUNDED-1))) * m_numOfQuestion;
			var middleStartX:Number = (TG_World.GAME_WIDTH - totalWidth) * 0.5;
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
						image = new Image(TG_World.assetManager.getTexture("IconAnswer"));
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
				sprite.x += middleStartX;
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
			m_answerCounter1 = 0;
			m_answerCounter2 = 0;
			
			m_timeBar.width =  m_timeBarInitialWidth;
			m_timeText.text = ""+(int(m_timeTotal/1000))+"s";
		}
		private final function questionAnimationCompleted():void
		{
			m_answers1 = [];
			m_answerCounter1 = 0;
			m_answers2 = [];
			m_answerCounter2 = 0;
			m_resultCounter = 0;
			m_ready = true;
			m_timeCounter = 0;
		}
		
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
			if(m_ready)
			{
				if(m_timeCounter < m_timeTotal && !isAllAnswered1() && !isAllAnswered2())
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
		private final function createImageRPS(value:int):Image
		{
			var image:Image;
			if(value == ROCK)
			{
				image = new Image(TG_World.assetManager.getTexture("IconRock"));
			}
			else if(value == PAPER)
			{
				image = new Image(TG_World.assetManager.getTexture("IconPaper"));
			}
			else if(value == SCISSOR)
			{
				image = new Image(TG_World.assetManager.getTexture("IconScissor"));
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
			//72 is the fix size of an image
			var imageSize:Number = 72 * TG_World.SCALE_ROUNDED * 0.5;
			totalWidth = (imageSize + (5*(TG_World.SCALE_ROUNDED-1))) * m_numOfQuestion;
			var middleStartX:Number = (TG_World.GAME_WIDTH - totalWidth) * 0.5;
			
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
					sprite.x += middleStartX;
					sprite.y = sprite.height * 0.5;
				}
			}
			
			//292 is the fix size of the time bar
			m_timeBarInitialWidth = (292 * TG_World.SCALE_ROUNDED * 0.5);
			m_timeBarFrame.scaleX = m_timeBarFrame.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_timeBar.scaleX = m_timeBar.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			m_timeText.scaleX = m_timeText.scaleY = TG_World.SCALE_ROUNDED * 0.5;
			
			m_timeBarFrame.x = (totalWidth - m_timeBarFrame.width) * 0.5;
			m_timeBarFrame.x += middleStartX;
			m_timeBarFrame.y = imageSize;
			m_timeBar.x = ((m_timeBarFrame.width - m_timeBar.width ) * 0.5 ) + m_timeBarFrame.x;
			m_timeBar.y = ((m_timeBarFrame.height - m_timeBar.height ) * 0.5 ) + m_timeBarFrame.y;
			m_timeText.x = m_timeBar.x + (m_timeBar.width * 0.5);
			m_timeText.y = m_timeBar.y + ((m_timeBar.height - m_timeText.height) * 0.5);
			
			
			
			if(m_answerSprites1)
			{
				i = 0;
				size = m_answerSprites1.length;
				for(i;i<size;i++)
				{
					sprite = m_answerSprites1[i];
					sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
					sprite.x = sprite.width * i;
					sprite.x += sprite.width * 0.5;
					sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
					sprite.y += sprite.height * 0.5;
				}
			}
			
			if(m_answerSprites2)
			{
				
				size = m_answerSprites2.length;
				i = size-1;
				var counter:int = 1;
				for(i;i>=0;i--)
				{
					sprite = m_answerSprites2[i];
					sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
					sprite.x = TG_World.GAME_WIDTH - (sprite.width*counter);
					sprite.x += sprite.width * 0.5;
					sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
					sprite.y += sprite.height * 0.5;
					counter++;
				}
			}
			
			if(m_neutralSprites)
			{
				i = 0;
				size = m_neutralSprites.length;
				for(i;i<size;i++)
				{
					sprite = m_neutralSprites[i];
					sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.5;
					sprite.x = (sprite.width + (5*(TG_World.SCALE_ROUNDED-1))) * i;
					sprite.x += sprite.width * 0.5;
					sprite.x += middleStartX;
					sprite.y = m_timeBarFrame.y + m_timeBarFrame.height;
					sprite.y += sprite.height * 0.5;
				}
			}
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
		
		public function putNextAnswer(value:int,player:int):void
		{
			if(!m_ready)return;
			var image:Image;
			var sprite:Sprite;
			var prevSprite:Sprite;
			if(player == 1)
			{
				if(m_answerCounter1 > m_numOfQuestion-1)return;
				m_answers1[m_answerCounter1] = value;
				image = createImageRPS(value);
				sprite = new Sprite();
				sprite.addChild(image);
				sprite.pivotX = sprite.width * 0.5;
				sprite.pivotY = sprite.height * 0.5;
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
				prevSprite = m_answerSprites1[m_answerCounter1];
				if(prevSprite)
				{
					sprite.x = prevSprite.x;
					sprite.y = prevSprite.y;
					prevSprite.removeFromParent();
				}
				m_sprite.addChild(sprite);
				m_answerSprites1[m_answerCounter1] = sprite;
				m_answerCounter1++;
			}
			else
			{
				if(m_answerCounter2 > m_numOfQuestion-1)return;
				
				m_answers2[m_answerCounter2] = value;
				image = createImageRPS(value);
				sprite = new Sprite();
				sprite.addChild(image);
				sprite.pivotX = sprite.width * 0.5;
				sprite.pivotY = sprite.height * 0.5;
				sprite.scaleX = sprite.scaleY = TG_World.SCALE_ROUNDED * 0.4;
				prevSprite = m_answerSprites2[m_answerCounter2];
				if(prevSprite)
				{
					sprite.x = prevSprite.x;
					sprite.y = prevSprite.y;
					prevSprite.removeFromParent();
				}
				m_sprite.addChild(sprite);
				m_answerSprites2[m_answerCounter2] = sprite;
				m_answerCounter2++;
			}
			
			
		}
		
		private function addDrawIcon(sprite:Sprite):void
		{
			var image:Image;
			var sprite:Sprite;
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
			var sprite:Sprite;
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
			var sprite:Sprite;
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
			if(m_chosenAnswer.length > m_resultCounter)
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
				
				addABitAnimation(m_chosenAnswerSprites[m_resultCounter]);
				addABitAnimation(m_questionSprites[m_resultCounter]);
				//we check who wins
				if(m_chosenAnswer[m_resultCounter] == ROCK)
				{
					if(m_questions[m_resultCounter] == ROCK)
					{
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
						//addDrawIcon(m_questionSprites[m_resultCounter]);
						m_resultCounter++;
						return 0;
					}
					else if(m_questions[m_resultCounter] == PAPER)
					{
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
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
				else if(m_chosenAnswer[m_resultCounter] == PAPER)
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
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
						//addDrawIcon(m_questionSprites[m_resultCounter]);
						m_resultCounter++;
						return 0;
					}
					else if(m_questions[m_resultCounter] == SCISSOR)
					{
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
						m_resultCounter++;
						return 2;
					}
				}
				else if(m_chosenAnswer[m_resultCounter] == SCISSOR)
				{
					if(m_questions[m_resultCounter] == ROCK)
					{
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
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
						addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
						//addDrawIcon(m_questionSprites[m_resultCounter]);
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
			addLoseIcon(m_chosenAnswerSprites[m_resultCounter]);
			m_resultCounter++;
			return 2;
		}
		
		public function copyChosenAnswers():void
		{
			var image:Image;
			var sprite:Sprite;
			var prevSprite:Sprite;
			var size:int = m_chosenAnswerSprites.length;
			var i:int = 0;
			for(i;i<size;i++)
			{
				sprite = m_chosenAnswerSprites[i];
				prevSprite = m_neutralSprites[i];
				if(i == size-1)
				{
					TweenMax.to(sprite,0.5,{delay:i*0.1,onComplete:onCopyCompleted,scaleX:prevSprite.scaleX,scaleY:prevSprite.scaleY,x:prevSprite.x,y:prevSprite.y,ease:Circ.easeOut});
				}
				else
				{
					TweenMax.to(sprite,0.5,{delay:i*0.1,scaleX:prevSprite.scaleX,scaleY:prevSprite.scaleY,x:prevSprite.x,y:prevSprite.y,ease:Circ.easeOut});
				}
				
				prevSprite.removeFromParent();
				m_neutralSprites[i] = sprite;
			}
		}
		
		private function onCopyCompleted():void
		{
			m_copyDone = true;
		}
		
		public function get copyDone():Boolean
		{
			return m_copyDone;
		}
		
		public function isAllAnswered1():Boolean
		{
			if(m_answerCounter1 >= m_numOfQuestion)
			{
				m_chosenAnswer = m_answers1;
				m_chosenAnswerSprites = m_answerSprites1;
				m_playerChosen = 1;
				m_ready = false;
				copyChosenAnswers();
				return true;
			}
			return false;
		}
		
		public function isAllAnswered2():Boolean
		{
			if(m_answerCounter2 >= m_numOfQuestion)
			{
				m_chosenAnswer = m_answers2;
				m_chosenAnswerSprites = m_answerSprites2;
				m_playerChosen = 2;
				m_ready = false;
				copyChosenAnswers();
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
				if(m_answerCounter1 > m_answerCounter2)
				{
					m_chosenAnswer = m_answers1;
					m_playerChosen = 1;
					m_chosenAnswerSprites = m_answerSprites1;
					copyChosenAnswers();
				}
				else if(m_answerCounter2 > m_answerCounter1)
				{
					m_chosenAnswer = m_answers2;
					m_playerChosen = 2;
					m_chosenAnswerSprites = m_answerSprites2;
					copyChosenAnswers();
				}
				else
				{
					var rand:int = (Math.random() * 100 ) % 2;
					if(rand == 0)
					{
						m_chosenAnswer = m_answers1;
						m_playerChosen = 1;
						m_chosenAnswerSprites = m_answerSprites1;
						copyChosenAnswers();
					}
					else
					{
						m_chosenAnswer = m_answers2;
						m_playerChosen = 2;
						m_chosenAnswerSprites = m_answerSprites2;
						copyChosenAnswers();
					}
				}
				return true;
			}
			return false;
		}
		public function get playerChosen():int
		{
			return m_playerChosen;
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