package p_singleton
{
	public class TG_Status
	{
		public var characterLevels:Array;
		public var characterExps:Array;
		private static var INSTANCE:TG_Status;
		public function TG_Status()
		{
			init();
		}
		public static function getInstance():TG_Status
		{
			if(INSTANCE == null)
			{
				INSTANCE = new TG_Status();
			}
			return INSTANCE;
		}
		private function init():void
		{
			characterLevels = [];
			characterExps = [];
		}
		
		public function saveGame():void
		{
			
		}
		
		public function loadGame():void
		{
			
		}
	}
}