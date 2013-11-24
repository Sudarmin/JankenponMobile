package p_asset
{
	public class TG_EmbeddedAssets
	{
		//Texture Atlas
		[Embed(source="/assets/textureAtlas/generalUI.png")]
		public static const generalUI:Class;
		
		[Embed(source="/assets/textureAtlas/generalUI.xml",mimeType="application/octet-stream")]
		public static const generalUIXML:Class;
		
		//FX Heal
		[Embed(source="/assets/textureAtlas/FXHeal.png")]
		public static const FXHeal:Class;
		
		[Embed(source="/assets/textureAtlas/FXHeal.xml",mimeType="application/octet-stream")]
		public static const FXHealXML:Class;
		
		//FX Level Up
		[Embed(source="/assets/textureAtlas/LevelUPFX.png")]
		public static const LevelUPFX:Class;
		
		[Embed(source="/assets/textureAtlas/LevelUPFX.xml",mimeType="application/octet-stream")]
		public static const LevelUPFXXML:Class;
		
		//Items
		[Embed(source="/assets/textureAtlas/Items.png")]
		public static const Items:Class;
		
		[Embed(source="/assets/textureAtlas/Items.xml",mimeType="application/octet-stream")]
		public static const ItemsXML:Class;
		
		//FONTS
		[Embed(source="/assets/textureAtlas/Londrina.png")]
		public static const Londrina:Class;
		
		[Embed(source="/assets/textureAtlas/Londrina.xml", mimeType="application/octet-stream")]
		public static const LondrinaXML:Class;
		
		
		//XML
		[Embed(source="/assets/xml/Levels.xml",mimeType="application/octet-stream")]
		public static const Levels:Class;
		
		[Embed(source="/assets/xml/Characters.xml",mimeType="application/octet-stream")]
		public static const Characters:Class;
		
		[Embed(source="/assets/xml/Bosses.xml",mimeType="application/octet-stream")]
		public static const Bosses:Class;
		
		[Embed(source="/assets/xml/Events.xml",mimeType="application/octet-stream")]
		public static const Events:Class;
		
		[Embed(source="/assets/xml/Treasures.xml",mimeType="application/octet-stream")]
		public static const Treasures:Class;
		
		public function TG_EmbeddedAssets()
		{
			
		}
	}
}