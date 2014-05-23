package flixel.system.layer.frames;

import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.system.layer.TileSheetExt;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.loaders.CachedGraphics;

class ImageFrame extends FlxSpriteFrames
{
	public static var POINT:Point = new Point();
	public static var RECT:Rectangle = new Rectangle();
	
	public var frame:FlxFrame;
	
	private function new(parent:CachedGraphics) 
	{
		super(parent);
		type = FrameCollectionType.IMAGE;
	}
	
	// TODO: implement it
	public static function fromFrame(source:Dynamic):ImageFrame
	{
		return null;
	}
	
	public static function fromImage(source:Dynamic):ImageFrame
	{
		return fromRectangle(source, null);
	}
	
	public static function fromRectangle(source:Dynamic, region:Rectangle = null):ImageFrame
	{
		var cached:CachedGraphics = FlxSpriteFrames.resolveSource(source);
		// find ImageFrame, if there is one already
		var imageFrame:ImageFrame = null;
		
		var checkRegion:Rectangle = region;
		
		if (checkRegion == null)
		{
			checkRegion = RECT;
			checkRegion.x = checkRegion.y = 0;
			checkRegion.width = cached.width;
			checkRegion.height = cached.height;
		}
		
		for (imageFrame in cached.imageFrames)
		{
			if (imageFrame.equals(checkRegion))
			{
				return imageFrame;
			}
		}
		
		// or create it, if there is no such object
		imageFrame = new ImageFrame(cached);
		
		if (region == null)
		{
			region = new Rectangle(0, 0, cached.width, cached.height);
		}
		else
		{
			if (region.width == 0)
			{
				region.width = cached.width - region.x;
			}
			
			if (region.height == 0)
			{
				region.height = cached.height - region.y;
			}
		}
		
		imageFrame.frame = imageFrame.addSpriteSheetFrame(region);
		
		cached.imageFrames.push(imageFrame);
		return imageFrame;
	}
	
	public function equals(rect:Rectangle = null):Bool
	{
		return (rect.equals(frame.frame));
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		frame = FlxDestroyUtil.destroy(frame);
	}
}