package flixel.graphics.frames;

import flash.display.BitmapData;
import flixel.system.layer.frames.FlxFrame;
import flixel.system.layer.TileSheetExt;
import flixel.util.FlxColor;

/**
 * ...
 * @author Zaphod
 */
class FlxEmptyFrame extends FlxFrame
{
	public function new(tileSheet:TileSheetExt) 
	{
		super(tileSheet);
		type = FrameType.EMPTY;
		#if FLX_RENDER_TILE
		tileID = -1;
		#end
	}
	
	override public function paintOnBitmap(bmd:BitmapData = null):BitmapData 
	{
		var result:BitmapData = null;
		
		if (bmd != null && (bmd.width == sourceSize.x && bmd.height == sourceSize.y))
		{
			result = bmd;
		}
		else if (bmd != null)
		{
			bmd.dispose();
		}
		
		if (result == null)
		{
			return new BitmapData(Std.int(sourceSize.x), Std.int(sourceSize.y), true, FlxColor.TRANSPARENT);
		}
		
		FlxFrame.RECT.x = FlxFrame.RECT.y = 0;
		FlxFrame.RECT.width = result.width;
		FlxFrame.RECT.height = result.height;
		bmd.fillRect(FlxFrame.RECT, FlxColor.TRANSPARENT);
		
		return result;
	}
	
	override public function getHReversedBitmap():BitmapData 
	{
		return getBitmap();
	}
	
	override public function getVReversedBitmap():BitmapData 
	{
		return getBitmap();
	}
	
	override public function getHVReversedBitmap():BitmapData 
	{
		return getBitmap();
	}
}