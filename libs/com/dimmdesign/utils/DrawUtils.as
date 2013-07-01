package com.dimmdesign.utils
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class DrawUtils
	{
		public function DrawUtils()
		{
		}
		
		/**
		 * Draws a rectangle for the passed graphics
		 *  
		 * @param graphics - The graphics that will be used to draw!
		 * @param x - The x position the rectangle should start
		 * @param y - The x position the rectangle should start
		 * @param width - The width of the rectangle
		 * @param height - The height of the rectangle
		 * @param colour - (Optional) The colour of the rectangle
		 * @param colourAlpha - (Optional) The transparency of the colour
		 * 
		 */		
		public static function drawRectangleShape (graphics:Graphics, x:Number, y:Number, width:Number, height:Number, colour:Number = 0x000000, colourAlpha:Number = 1):void {
			graphics.beginFill(colour, colourAlpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
		public static function drawRoundRectangleShape (graphics:Graphics, x:Number, y:Number, width:Number, height:Number, ellipsis:Number, colour:Number = 0x000000, colourAlpha:Number = 1, hasCustomFill:Boolean = false):void {
			if (!hasCustomFill) graphics.beginFill(colour, colourAlpha);
			graphics.drawRoundRect(x, y, width, height, ellipsis, ellipsis);
			graphics.endFill();
		}
		
		public static function drawCircleShape (graphics:Graphics, x:Number, y:Number, radius:Number, colour:Number = 0, colourAlpha:Number = 1):void {
			graphics.beginFill(colour, colourAlpha);
			graphics.drawCircle(x, x, radius);
			graphics.endFill();
		}
		
		public static function drawComplexRoundRectangleShape(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, topLeftEllipsis:Number, topRightEllipsis:Number, bottomLeftEllipsis:Number, bottomRightEllipsis:Number, colour:Number = 0, colourAlpha:Number = 1):void {
			graphics.beginFill(colour, colourAlpha);
			graphics.drawRoundRectComplex(x, y, width, height, topLeftEllipsis, topRightEllipsis, bottomLeftEllipsis, bottomRightEllipsis);
			graphics.endFill();
		}
		
		/**
		 * Draws a perfect stroke... Bacause the stroke consists of 4 individuals shapes the return value is a Sprite. 
		 * @param x
		 * @param y
		 * @param strokeWeight
		 * @param width
		 * @param height
		 * @param colour
		 * @param colourAlpha
		 * @return Sprite
		 * 
		 */		
		public static function drawStroke(x:Number, y:Number, strokeWeight:Number, width:Number, height:Number, colour:Number = 0, colourAlpha:Number = 1):Sprite {
			var sprite:Sprite = new Sprite();
			
			var rectOne:Shape = new Shape();
			DrawUtils.drawRectangleShape(rectOne.graphics, 0, 0, strokeWeight, height, colour, colourAlpha);
			sprite.addChild(rectOne);
			
			var rectTwo:Shape = new Shape();
			DrawUtils.drawRectangleShape(rectTwo.graphics, strokeWeight, 0, width-strokeWeight*2, strokeWeight, colour, colourAlpha);
			sprite.addChild(rectTwo);
			
			var rectThree:Shape = new Shape();
			DrawUtils.drawRectangleShape(rectThree.graphics, width-strokeWeight, 0, strokeWeight, height, colour, colourAlpha);
			sprite.addChild(rectThree);
			
			var rectFour:Shape = new Shape();
			DrawUtils.drawRectangleShape(rectFour.graphics, strokeWeight, height-strokeWeight, width-strokeWeight*2, strokeWeight, colour, colourAlpha);
			sprite.addChild(rectFour);
			
			return sprite;
		}
				
		public static function drawPath(graphics:Graphics, points:Array):void {
			var i:uint = points.length;
			while (i--)
				if (!(points[i] is Point))
					throw new Error();
			
			if (points.length < 2)
				throw new Error('At least two Points are needed to draw a path.');
			
			graphics.moveTo(points[0].x, points[0].y);
			
			i = 0;
			while (++i < points.length)
				graphics.lineTo(points[i].x, points[i].y);
		}
		
		public static function drawShape(graphics:Graphics, points:Array):void {
			if (points.length < 3)
				throw new Error('At least three Points are needed to draw a shape.');
			
			DrawUtils.drawPath(graphics, points);
			
			graphics.lineTo(points[0].x, points[0].y);
		}
						
		/**
		 * Draws a solid arc for the passed DisplayObject
		 *  
		 * @param drawObj - A DisplayObject that the arc drawing should occur
		 * @param centerX - A number for the center x position of the arc
		 * @param centerY - A number for the center y position of the arc
		 * @param innerRadius - The inner radius of the circle
		 * @param outerRadius - The outer radius of the circle
		 * @param startAngle - The angle the should start from, in degrees
		 * @param arcAngle - The angle the should end at, in degrees
		 * @param steps - The number for the detail of the circle, the larger the number the more detail the arc will have. 40 - 60 should be enough!
		 * 
		 */		
		public static function drawSolidArc (drawObj:Object, centerX:Number,centerY:Number,innerRadius:Number,outerRadius:Number,startAngle:Number,arcAngle:Number,steps:int=20):void {
			
			//make sure angles are proper
			if (Math.abs(startAngle) > 360) startAngle %= 360
			if (Math.abs(arcAngle) > 360) arcAngle %= 360
			//convert angles to percentages
			startAngle /= 360, arcAngle /= 360
			
			// Used to convert angles [ratio] to radians.
			var twoPI:Number = 2 * Math.PI;
			
			// How much to rotate for each point along the arc.
			var angleStep:Number = arcAngle / steps;
			
			// Variables set later.
			var angle:Number, i:int, endAngle:Number;
			
			// Find the coordinates of the first point on the inner arc.
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * innerRadius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * innerRadius;
			
			//Store the coordinates.
			var xxInit:Number = xx;
			var yyInit:Number = yy;
			
			// Move to the first point on the inner arc.
			drawObj.graphics.moveTo(xx,yy);
			
			// Draw all of the other points along the inner arc.
			for(i=1; i<=steps; i++) {
				angle = (startAngle + i * angleStep) * twoPI;
				xx = centerX + Math.cos(angle) * innerRadius;
				yy = centerY + Math.sin(angle) * innerRadius;
				drawObj.graphics.lineTo(xx,yy);
			}
			
			// Determine the ending angle of the arc so you can
			// rotate around the outer arc in the opposite direction.
			endAngle = startAngle + arcAngle;
			
			// Start drawing all points on the outer arc.
			for(i=0; i<=steps; i++) {
				
				// To go the opposite direction, we subtract rather than add.
				angle = (endAngle - i * angleStep) * twoPI;
				xx = centerX + Math.cos(angle) * outerRadius;
				yy = centerY + Math.sin(angle) * outerRadius;
				drawObj.graphics.lineTo(xx,yy);
			}
			
			// Close the shape by drawing a straight
			// line back to the inner arc.
			drawObj.graphics.lineTo(xxInit,yyInit);
		};
	}
}