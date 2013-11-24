package p_static
{
	import p_entity.TG_Bullet;
	
	import starling.display.Sprite;

	public class TG_Static
	{
		public static var layerTransition:Sprite = new Sprite();
		public static var layerMenuBar:Sprite = new Sprite();
		public static var layerInGame:Sprite = new Sprite();
		public static var layerText:Sprite = new Sprite();
		
		public static const ENGLISH:int = 0;
		public static const INDONESIA:int = 1;
		public static var language:int = ENGLISH;
		
		public static var BULLETS:Vector.<TG_Bullet> = new Vector.<TG_Bullet>();
		
		public static var fullCircleRad:Number = Math.PI * 2;
		public static function initLayers(parentLayer:Sprite):void
		{
			parentLayer.addChild(layerInGame);
			parentLayer.addChild(layerMenuBar);
			parentLayer.addChild(layerText);
			parentLayer.addChild(layerTransition);
		}
		public function TG_Static()
		{
		}
	}
}