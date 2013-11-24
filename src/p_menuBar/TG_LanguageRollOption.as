package p_menuBar
{
	import p_engine.p_gameState.TG_GameState;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class TG_LanguageRollOption extends TG_RollOption
	{
		public function TG_LanguageRollOption(parent:DisplayObjectContainer, gameState:TG_GameState, options:Array, fontSize:Number, scaleSize:Number)
		{
			super(parent, gameState, options, fontSize, scaleSize);
		}
		
		public function reset(value:int):void
		{
			
			var textField:TextField = m_textFieldArray[m_currentOptionNumber];
			textField.visible = false;
			m_currentOptionNumber = value;
			textField = m_textFieldArray[m_currentOptionNumber];
			textField.visible = true;
		}
		
		public override function moveLeft():void
		{
			super.moveLeft();
			m_gameState.doSomething(m_textFieldArray[m_currentOptionNumber].text);
		}
		
		public override function moveRight():void
		{
			super.moveRight();
			m_gameState.doSomething(m_textFieldArray[m_currentOptionNumber].text);
		}
		
		protected override function initListeners():void
		{
			m_arrowRight.addEventListener(TouchEvent.TOUCH,onArrowRightTouch);
			m_arrowLeft.addEventListener(TouchEvent.TOUCH,onArrowLeftTouch);
		}
		
		protected override function destroyListeners():void
		{
			m_arrowRight.removeEventListener(TouchEvent.TOUCH,onArrowRightTouch);
			m_arrowLeft.removeEventListener(TouchEvent.TOUCH,onArrowLeftTouch);
		}
	}
}