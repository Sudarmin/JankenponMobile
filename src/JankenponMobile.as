package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import p_engine.TG_Engine;
	
	[SWF(width="1024",height="768",frameRate="60",backgroundColor="#000000")]
	public class JankenponMobile extends Sprite
	{
		[Embed(source = "/assets/screenDefaultStartupLoading.png")]
		public static const Background:Class;
		
		public function JankenponMobile()
		{
			super();
			
			if(stage)
			{
				onAddedToStage();	
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
			
		}
		
		private final function onAddedToStage(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var bitmap:Bitmap = new Background();
			var engine:TG_Engine = new TG_Engine(JankenponCore,stage,480,320,bitmap,this);
		}
	}
}