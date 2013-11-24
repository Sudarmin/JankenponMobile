package
{
	import p_asset.TG_EmbeddedAssets;
	
	import p_engine.TG_Engine;
	import p_engine.p_singleton.TG_GameManager;
	import p_engine.p_singleton.TG_World;
	
	import p_gameState.TG_StartMenuState;
	
	import p_singleton.TG_CollisionDetector;
	import p_singleton.TG_Updater;
	
	import p_static.TG_Static;
	
	import p_transition.TG_Transition;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class JankenponCore extends Sprite
	{
		public function JankenponCore()
		{
			super();
			if(stage)
			{
				startUp();
			}
			else
			{
				this.addEventListener(starling.events.Event.ADDED_TO_STAGE,startUp);
			}
		}
		public function startUp(e:starling.events.Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,startUp);
			TG_Static.initLayers(this);
			
			
			TG_World.assetManager = new AssetManager();
			TG_World.assetManager.verbose = true;
			TG_World.assetManager.enqueue(TG_EmbeddedAssets);
			TG_World.assetManager.loadQueue(onProgress);
			
		}
		
		private function onProgress(ratio:Number):void
		{
			if(ratio == 1)
			{
				TG_Engine.current.initialize(this.stage,new TG_Updater(),new TG_CollisionDetector(),new TG_Transition(TG_Static.layerTransition));
				
				/*var image:Image = new Image(TG_World.assetManager.getTexture("transition"));
				this.addChild(image);*/
				
				/*var text:TextField = new TextField(200,200,"AVAS","Londrina",40,0xFFFFFF);
				this.addChild(text);*/
				
				TG_GameManager.getInstance().changeGameState(TG_StartMenuState,TG_Static.layerMenuBar);
			}
		}
	}
}