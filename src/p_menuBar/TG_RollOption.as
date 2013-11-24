package p_menuBar
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import p_engine.p_gameState.TG_GameState;
	import p_engine.p_menuBar.TG_MenuBar;
	import p_engine.p_singleton.TG_World;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	
	public class TG_RollOption extends TG_MenuBar
	{
		protected var m_options:Array;
		protected var m_currentOptionNumber:int = 0;
		protected var m_textFieldArray:Array;
		protected var m_currentTextField:TextField;
		protected var m_speed:int = 0;
		protected var m_arrowRight:Button;
		protected var m_arrowLeft:Button;
		protected var m_fontSize:Number;
		protected var m_scaleSize:Number;
		public function TG_RollOption(parent:DisplayObjectContainer, gameState:TG_GameState,options:Array,fontSize:Number,scaleSize:Number)
		{
			m_fontSize = fontSize;
			m_scaleSize = scaleSize;
			m_options = options;
			super(parent, gameState);
		}
		
		public override function init():void
		{
			super.init();
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
		
		protected override function initAnimation():void
		{
			super.initAnimation();
			if(m_timeline)
			{
				var tweenMax:TweenMax;
				tweenMax = TweenMax.fromTo(m_sprite,0.3,{alpha:0.1},{alpha:1});
				m_sprite.alpha = 0;
				m_timeline.insert(tweenMax,0.5);
			}
		}
		
		protected override function destroyAnimation():void
		{
			super.destroyAnimation();
		}
		public override function resize():void
		{
			super.resize();
			m_sprite.scaleX = m_sprite.scaleY = TG_World.SCALE * m_scaleSize;
			m_sprite.x = TG_World.GAME_WIDTH * 0.5;
			
			m_sprite.y = (TG_World.GAME_HEIGHT - ( m_sprite.height * 0.5)) -  (55 * TG_World.SCALE * m_scaleSize);
		}
		protected override function initSprite():void
		{
			m_textFieldArray = [];
			m_sprite = new Sprite();
			var i:int = 0;
			var size:int = m_options.length;
			
			var textField:TextField;
			for(i;i<size;i++)
			{
				textField = new TextField(200,30,m_options[i],"Londrina",m_fontSize,0xFFFF00);
				m_sprite.addChild(textField);
				if(i> 0)
				{
					textField.visible = false;
				}
				textField.autoSize = TextFieldAutoSize.HORIZONTAL;
				textField.pivotX = textField.width * 0.5;
				textField.pivotY = textField.height * 0.5;
				m_textFieldArray.push(textField);
			}
			
			m_currentTextField = m_textFieldArray[m_currentOptionNumber];
			
			m_arrowRight = new Button(TG_World.assetManager.getTexture("ArrowUp"));
			m_arrowRight.pivotX = m_arrowRight.width * 0.5;
			m_arrowRight.pivotY = m_arrowRight.height;
			m_arrowRight.rotation = deg2rad(90);
			m_arrowLeft = new Button(TG_World.assetManager.getTexture("ArrowUp"));
			m_arrowLeft.pivotX = m_arrowLeft.width * 0.5;
			m_arrowLeft.pivotY = m_arrowLeft.height;
			m_arrowLeft.rotation = deg2rad(-90);
			
			
			m_sprite.addChild(m_arrowRight);
			m_sprite.addChild(m_arrowLeft);
			
			var textSize:int = m_currentTextField.text.length * m_currentTextField.fontSize;
			m_arrowRight.x += 10;
			m_arrowLeft.x += -10;
			
			
			m_arrowRight.y += 30;
			m_arrowLeft.y += 30;
			
		}
		
		private final function checkMaxPage():void
		{
			if(m_currentOptionNumber < 0)
			{
				m_currentOptionNumber = m_textFieldArray.length-1;
			}
			if(m_currentOptionNumber > m_textFieldArray.length-1)
			{
				m_currentOptionNumber = 0;
			}
		}
		
		public override function update(elapsedTime:int):void
		{
			super.update(elapsedTime);
			
		}
		
		public function get currentOption():int
		{
			return m_currentOptionNumber;
		}
		
		public final function refreshText(options:Array):void
		{
			m_options = options;
			var i:int = 0;
			var size:int = m_textFieldArray.length;
			var textField:TextField;
			for(i;i<size;i++)
			{
				textField = m_textFieldArray[i];
				textField.text = options[i];
				textField.autoSize = TextFieldAutoSize.HORIZONTAL;
				textField.pivotX = textField.width * 0.5;
				textField.pivotY = textField.height * 0.5;
			}
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			m_arrowRight.addEventListener(TouchEvent.TOUCH,onArrowRightTouch);
			m_arrowLeft.addEventListener(TouchEvent.TOUCH,onArrowLeftTouch);
			
			var i:int = 0;
			var size:int = m_textFieldArray.length;
			var textField:TextField;
			for(i;i<size;i++)
			{
				textField = m_textFieldArray[i];
				textField.addEventListener(TouchEvent.TOUCH,onTextTouch);
			}
		}
		
		protected override function destroyListeners():void
		{
			super.destroyListeners();
			m_arrowRight.removeEventListener(TouchEvent.TOUCH,onArrowRightTouch);
			m_arrowLeft.removeEventListener(TouchEvent.TOUCH,onArrowLeftTouch);
			
			var i:int = 0;
			var size:int = m_textFieldArray.length;
			var textField:TextField;
			for(i;i<size;i++)
			{
				textField = m_textFieldArray[i];
				textField.removeEventListener(TouchEvent.TOUCH,onTextTouch);
			}
		}
		
		private final function onTextTouch(e:TouchEvent):void
		{
			var textField:TextField = e.currentTarget as TextField;
			var touch:Touch = e.getTouch(textField);
			if(touch)
			{
				var phase:String = touch.phase;
				if(phase == TouchPhase.HOVER)
				{
					textField.scaleX = textField.scaleY = 1.1;
				}
				else if(phase == TouchPhase.ENDED)
				{
					textField.scaleX = textField.scaleY = 1;
				}
				else if(phase == TouchPhase.BEGAN)
				{
					textField.scaleX = textField.scaleY = 0.9;
					m_gameState.doSomething(m_textFieldArray[m_currentOptionNumber].text);
					
				}
			}
			else
			{
				textField.scaleX = textField.scaleY = 1;
			}
		}
		
		
		
		public function moveRight():void
		{
			var textField:TextField = m_textFieldArray[m_currentOptionNumber];
			//Dari ada jd ga ada
			TweenMax.fromTo(textField,0.3,{x:0,alpha:1,visible:true},{x:(TG_World.GAME_WIDTH * 0.5) / TG_World.SCALE,alpha:0.1,visible:false,ease:Circ.easeOut});
			//Dari ga ada jd ada
			m_currentOptionNumber++;
			if(m_currentOptionNumber > m_textFieldArray.length-1)
			{
				m_currentOptionNumber = 0;
			}
			textField = m_textFieldArray[m_currentOptionNumber];
			TweenMax.fromTo(textField,0.3,{x:-((TG_World.GAME_WIDTH * 0.5) / TG_World.SCALE),alpha:1,visible:true},{x:0,alpha:1,visible:true,ease:Circ.easeOut});
		}
		
		public function moveLeft():void
		{
			var textField:TextField = m_textFieldArray[m_currentOptionNumber];
			//Dari ada jd ga ada
			TweenMax.fromTo(textField,0.3,{x:0,alpha:1,visible:true},{x:-((TG_World.GAME_WIDTH * 0.5) / TG_World.SCALE),alpha:0.1,visible:false,ease:Circ.easeOut});
			//Dari ga ada jd ada
			m_currentOptionNumber--;
			if(m_currentOptionNumber < 0)
			{
				m_currentOptionNumber = m_textFieldArray.length-1;
			}
			textField = m_textFieldArray[m_currentOptionNumber];
			TweenMax.fromTo(textField,0.3,{x:((TG_World.GAME_WIDTH * 0.5) / TG_World.SCALE),alpha:1,visible:true},{x:0,alpha:1,visible:true,ease:Circ.easeOut});
		}
		protected final function onArrowRightTouch(e:TouchEvent):void
		{
			var button:Button = e.currentTarget as Button;
			var touch:Touch = e.getTouch(button);
			if(touch)
			{
				var phase:String = touch.phase;
				if(phase == TouchPhase.HOVER)
				{
					button.scaleX = button.scaleY = 1.1;
				}
				else if(phase == TouchPhase.ENDED)
				{
					button.scaleX = button.scaleY = 1;
					moveRight();
				}
				
			}
			else
			{
				button.scaleX = button.scaleY = 1;
			}
		}
		
		protected final function onArrowLeftTouch(e:TouchEvent):void
		{
			var button:Button = e.currentTarget as Button;
			var touch:Touch = e.getTouch(button);
			if(touch)
			{
				var phase:String = touch.phase;
				if(phase == TouchPhase.HOVER)
				{
					button.scaleX = button.scaleY = 1.1;
				}
				else if(phase == TouchPhase.ENDED)
				{
					button.scaleX = button.scaleY = 1;
					moveLeft();
				}
			}
			else
			{
				button.scaleX = button.scaleY = 1;
			}
		}
		
	}
}