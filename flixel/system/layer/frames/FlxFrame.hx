package flixel.system.layer.frames;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.interfaces.IFlxDestroyable;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.loaders.CachedGraphics;

class FlxFrame implements IFlxDestroyable
{
	public static var POINT:Point = new Point();
	public static var MATRIX:Matrix = new Matrix();
	public static var RECT:Rectangle = new Rectangle();
	
	public var name:String;
	public var frame:Rectangle;
	
	public var parent:CachedGraphics;
	public var tileID:Int = -1;
	public var additionalAngle:Float = 0;
	
	public var sourceSize(default, null):FlxPoint;
	public var offset(default, null):FlxPoint;
	public var center(default, null):FlxPoint;
	
	public var type(default, null):FrameType;
	
	private var _bitmapData:BitmapData;
	private var _hReversedBitmapData:BitmapData;
	private var _vReversedBitmapData:BitmapData;
	private var _hvReversedBitmapData:BitmapData;
	
	public function new(parent:CachedGraphics)
	{
		this.parent = parent;
		additionalAngle = 0;
		
		sourceSize = FlxPoint.get();
		offset = FlxPoint.get();
		center = FlxPoint.get();
		
		type = FrameType.REGULAR;
	}
	
	public function paintOnBitmap(bmd:BitmapData = null):BitmapData
	{
		var result:BitmapData = null;
		
		if (bmd != null && (bmd.width == sourceSize.x && bmd.height == sourceSize.y))
		{
			result = bmd;
			
			var w:Int = bmd.width;
			var h:Int = bmd.height;
			
			if (w > frame.width || h > frame.height)
			{
				RECT.x = RECT.y = 0;
				RECT.width = w;
				RECT.height = h;
				bmd.fillRect(RECT, FlxColor.TRANSPARENT);
			}
		}
		else if (bmd != null)
		{
			bmd.dispose();
		}
		
		if (result == null)
		{
			result = new BitmapData(Std.int(sourceSize.x), Std.int(sourceSize.y), true, FlxColor.TRANSPARENT);
		}
		
		FlxFrame.POINT.x = offset.x;
		FlxFrame.POINT.y = offset.y;
		result.copyPixels(parent.bitmap, frame, FlxFrame.POINT);
		
		return result;
	}
	
	public function getBitmap():BitmapData
	{
		if (_bitmapData != null)
		{
			return _bitmapData;
		}
		
		_bitmapData = paintOnBitmap();
		
		return _bitmapData;
	}
	
	public function getHReversedBitmap():BitmapData
	{
		if (_hReversedBitmapData != null)
		{
			return _hReversedBitmapData;
		}
		
		var normalFrame:BitmapData = getBitmap();
		MATRIX.identity();
		MATRIX.scale( -1, 1);
		MATRIX.translate(Std.int(sourceSize.x), 0);
		_hReversedBitmapData = new BitmapData(Std.int(sourceSize.x), Std.int(sourceSize.y), true, FlxColor.TRANSPARENT);
		_hReversedBitmapData.draw(normalFrame, MATRIX);
		
		return _hReversedBitmapData;
	}
	
	public function getVReversedBitmap():BitmapData
	{
		if (_vReversedBitmapData != null)
		{
			return _vReversedBitmapData;
		}
		
		var normalFrame:BitmapData = getBitmap();
		MATRIX.identity();
		MATRIX.scale(1, -1);
		MATRIX.translate(0, Std.int(sourceSize.y));
		_vReversedBitmapData = new BitmapData(Std.int(sourceSize.x), Std.int(sourceSize.y), true, FlxColor.TRANSPARENT);
		_vReversedBitmapData.draw(normalFrame, MATRIX);
		
		return _vReversedBitmapData;
	}
	
	public function getHVReversedBitmap():BitmapData
	{
		if (_hvReversedBitmapData != null)
		{
			return _hvReversedBitmapData;
		}
		
		var normalFrame:BitmapData = getBitmap();
		MATRIX.identity();
		MATRIX.scale( -1, -1);
		MATRIX.translate(Std.int(sourceSize.x), Std.int(sourceSize.y));
		_hvReversedBitmapData = new BitmapData(Std.int(sourceSize.x), Std.int(sourceSize.y), true, FlxColor.TRANSPARENT);
		_hvReversedBitmapData.draw(normalFrame, MATRIX);
		
		return _hvReversedBitmapData;
	}
	
	public function destroy():Void
	{
		name = null;
		frame = null;
		parent = null;
		
		sourceSize = FlxDestroyUtil.put(sourceSize);
		offset = FlxDestroyUtil.put(offset);
		center = FlxDestroyUtil.put(center);
		
		destroyBitmaps();
	}
	
	public function destroyBitmaps():Void
	{
		_bitmapData = FlxDestroyUtil.dispose(_bitmapData);
		_hReversedBitmapData = FlxDestroyUtil.dispose(_hReversedBitmapData);
		_vReversedBitmapData = FlxDestroyUtil.dispose(_vReversedBitmapData);
		_hvReversedBitmapData = FlxDestroyUtil.dispose(_hvReversedBitmapData);
	}
}