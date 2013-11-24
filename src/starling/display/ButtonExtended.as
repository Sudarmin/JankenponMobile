
// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/** Dispatched when the user triggers the button. Bubbles. */
	[Event(name="triggered", type="starling.events.Event")]
	
	/** A simple button composed of an image and, optionally, text.
	 *  
	 *  <p>You can pass a texture for up- downstate, and hoverstate of the button. If you do not provide a down 
	 *  state or a hover state, the button is simply scaled a little when it is touched.
	 *  In addition, you can overlay a text on the button. To customize the text, almost the 
	 *  same options as those of text fields are provided. In addition, you can move the text to a 
	 *  certain position with the help of the <code>textBounds</code> property.</p>
	 *  
	 *  <p>To react on touches on a button, there is special <code>triggered</code>-event type. Use
	 *  this event instead of normal touch events - that way, users can cancel button activation
	 *  by moving the mouse/finger away from the button before releasing.</p> 
	 */ 
	public class ButtonExtended extends DisplayObjectContainer
	{
		private static const MAX_DRAG_DIST:Number = 50;
		
		private var mUpState:Texture;
		private var mDownState:Texture;
		private var mHoverState:Texture;
		
		private var mContents:Sprite;
		private var mBackground:Image;
		private var mTextField:TextField;
		private var mTextBounds:Rectangle;
		
		private var mScaleWhenDown:Number;
		private var mAlphaWhenDisabled:Number;
		private var mEnabled:Boolean;
		private var mIsDown:Boolean;
		private var mIsHovered:Boolean;
		private var mUseHandCursor:Boolean;
		
		private var textFont:String;
		private var textSize:int;
		private var textColor:uint;
		private var textBold:Boolean;
		
		/** Creates a button with textures for up- and down-state or text. */
		public function ButtonExtended(upState:Texture, text:String="", downState:Texture=null, hoverState:Texture=null, textFont:String="Verdana", textSize:int=12, textColor:uint = 0x0, textBold:Boolean = false)
		{
			if (upState == null) throw new ArgumentError("Texture cannot be null");
			
			mUpState = upState;
			mDownState = downState ? downState : upState;
			mHoverState = hoverState ? hoverState : upState;
			mBackground = new Image(upState);
			mScaleWhenDown = downState ? 1.0 : 0.9;
			mAlphaWhenDisabled = 0.5;
			mEnabled = true;
			mIsDown = false;
			mIsHovered = false;
			mUseHandCursor = true;
			mTextBounds = new Rectangle(0, 0, upState.width, upState.height);            
			
			mContents = new Sprite();
			mContents.addChild(mBackground);
			addChild(mContents);
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			this.textFont = textFont;
			this.textSize = textSize;
			this.textColor = textColor;
			this.textBold = textBold;
			
			if (text.length != 0) this.text = text;
		}
		
		/** Additional smoothing by Tana */
		public function smoothingFalse():void
		{
			Image(Sprite(this.getChildAt(0)).getChildAt(0)).smoothing = TextureSmoothing.NONE;
		}
		
		
		
		private function createTextField():void
		{
			if (mTextField == null)
			{
				mTextField = new TextField(mTextBounds.width, mTextBounds.height, "", textFont, textSize,textColor,textBold);
				mTextField.vAlign = VAlign.CENTER;
				mTextField.hAlign = HAlign.CENTER;
				mTextField.touchable = false;
				mTextField.autoScale = true;
				mContents.addChild(mTextField);
			}
			
			mTextField.width  = mTextBounds.width;
			mTextField.height = mTextBounds.height;
			mTextField.x = mTextBounds.x;
			mTextField.y = mTextBounds.y;
		}
		
		private function hoverMode():void
		{
			mBackground.texture = mHoverState;
			mContents.scaleX = mContents.scaleY = mScaleWhenDown;
			mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
			mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
			mIsDown = false;
			mIsHovered = true;
		}
		private function downMode():void
		{
			mBackground.texture = mDownState;
			mContents.scaleX = mContents.scaleY = mScaleWhenDown;
			mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
			mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
			mIsDown = true;
			mIsHovered = false;
		}
		
		private function upMode():void
		{
			mIsDown = false;
			mIsHovered = false;
			mBackground.texture = mUpState;
			mContents.x = mContents.y = 0;
			mContents.scaleX = mContents.scaleY = 1.0;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
				MouseCursor.BUTTON : MouseCursor.AUTO;
		
			var touch:Touch = event.getTouch(this);
			
			// if the button was hovered out
			if(mEnabled && mIsHovered && !event.interactsWith(this))
			{
				upMode();
			}
			
			if (!mEnabled || touch == null) return;
			
			var buttonRect:Rectangle;
			if(touch.phase == TouchPhase.HOVER && !mIsHovered)
			{
				hoverMode();
			}
			else if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				downMode();
				buttonRect = getBounds(stage);
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				// reset button when user dragged too far away after pushing
				buttonRect = getBounds(stage);
				if(!isInsideButton(touch,buttonRect))
				{
					upMode();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				upMode();
				/*buttonRect = getBounds(stage);
				if(!isInsideButton(touch,buttonRect))
				{
					upMode();
				}
				else
				{
					hoverMode();
					trace("interact = "+event.interactsWith(this));
					if(!event.interactsWith(this))
					{
						upMode();
					}
				}*/
				dispatchEventWith(Event.TRIGGERED, true);
			}
			
		}
		
		private final function isInsideButton(touch:Touch,rect:Rectangle):Boolean
		{
			if (touch.globalX < rect.x - MAX_DRAG_DIST ||
				touch.globalY < rect.y - MAX_DRAG_DIST ||
				touch.globalX > rect.x + rect.width + MAX_DRAG_DIST ||
				touch.globalY > rect.y + rect.height + MAX_DRAG_DIST)
			{
				return false;
			}
			return true;
		}
		
		/** The scale factor of the button on touch. Per default, a button with a down state 
		 * texture won't scale. */
		public function get scaleWhenDown():Number { return mScaleWhenDown; }
		public function set scaleWhenDown(value:Number):void { mScaleWhenDown = value; }
		
		/** The alpha value of the button when it is disabled. @default 0.5 */
		public function get alphaWhenDisabled():Number { return mAlphaWhenDisabled; }
		public function set alphaWhenDisabled(value:Number):void { mAlphaWhenDisabled = value; }
		
		/** Indicates if the button can be triggered. */
		public function get enabled():Boolean { return mEnabled; }
		public function set enabled(value:Boolean):void
		{
			if (mEnabled != value)
			{
				mEnabled = value;
				mContents.alpha = value ? 1.0 : mAlphaWhenDisabled;
				upMode();
			}
		}
		
		/** The text that is displayed on the button. */
		public function get text():String { return mTextField ? mTextField.text : ""; }
		public function set text(value:String):void
		{
			createTextField();
			mTextField.text = value;
		}
		
		/** The name of the font displayed on the button. May be a system font or a registered 
		 * bitmap font. */
		public function get fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
		public function set fontName(value:String):void
		{
			createTextField();
			mTextField.fontName = value;
		}
		
		/** The size of the font. */
		public function get fontSize():Number { return mTextField ? mTextField.fontSize : 12; }
		public function set fontSize(value:Number):void
		{
			createTextField();
			mTextField.fontSize = value;
		}
		
		/** The color of the font. */
		public function get fontColor():uint { return mTextField ? mTextField.color : 0x0; }
		public function set fontColor(value:uint):void
		{
			createTextField();
			mTextField.color = value;
		}
		
		/** Indicates if the font should be bold. */
		public function get fontBold():Boolean { return mTextField ? mTextField.bold : false; }
		public function set fontBold(value:Boolean):void
		{
			createTextField();
			mTextField.bold = value;
		}
		
		/** The texture that is displayed when the button is not being touched. */
		public function get upState():Texture { return mUpState; }
		public function set upState(value:Texture):void
		{
			if (mUpState != value)
			{
				mUpState = value;
				if (!mIsDown) mBackground.texture = value;
			}
		}
		
		/** The texture that is displayed while the button is touched. */
		public function get downState():Texture { return mDownState; }
		public function set downState(value:Texture):void
		{
			if (mDownState != value)
			{
				mDownState = value;
				if (mIsDown) mBackground.texture = value;
			}
		}
		
		/** The texture that is displayed while the button is hovered. */
		public function get hoverState():Texture { return mHoverState; }
		public function set hoverState(value:Texture):void
		{
			if (mHoverState != value)
			{
				mHoverState = value;
				if (mIsHovered) mBackground.texture = value;
			}
		}
		
		/** The vertical alignment of the text on the button. */
		public function get textVAlign():String { return mTextField.vAlign; }
		public function set textVAlign(value:String):void
		{
			createTextField();
			mTextField.vAlign = value;
		}
		
		/** The horizontal alignment of the text on the button. */
		public function get textHAlign():String { return mTextField.hAlign; }
		public function set textHAlign(value:String):void
		{
			createTextField();
			mTextField.hAlign = value;
		}
		
		/** The bounds of the textfield on the button. Allows moving the text to a custom position. */
		public function get textBounds():Rectangle { return mTextBounds.clone(); }
		public function set textBounds(value:Rectangle):void
		{
			mTextBounds = value.clone();
			createTextField();
		}
		
		/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
		 *  @default true */
		public override function get useHandCursor():Boolean { return mUseHandCursor; }
		public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
	}
}