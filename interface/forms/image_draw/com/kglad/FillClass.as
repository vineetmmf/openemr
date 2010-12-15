package com.kglad{
	
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.MovieClip;
	
	public class FillClass {
		
		var mc:MovieClip;
		var bmpd:BitmapData;
		
		var registrationX:int;
		var registrationY:int;

		public function FillClass() {
			// singleton
		}
		
		public function fillF(dobj:DisplayObject,x:int,y:int,col:String,regX:int,regY:int):void{
			mc = MovieClip(dobj);
			//trace(dobj.width+mc.lineThickness);
			if(!mc.filled){
				bmpd = new BitmapData(mc.w+mc.lineThickness,mc.h+mc.lineThickness,true,0x00000000);
				var mat:Matrix = mc.transform.matrix;
				var shift:Number = mc.lineThickness/2;
			
				mat.tx=-regX+shift;
				mat.ty=-regY+shift;
				bmpd.draw(dobj,mat);
				registrationX = regX-shift;
				registrationY = regY-shift;
				bmpd.floodFill(x+mat.tx,y+mat.ty,int("0xff"+col));
				mc.filled = true;
			} else {
				bmpd = new BitmapData(mc.w+mc.lineThickness,mc.h+mc.lineThickness,true,0x00000000);
				mat = mc.transform.matrix;
				shift = 0;
			
				mat.tx=-regX+shift;
				mat.ty=-regY+shift;
				bmpd.draw(dobj,mat);
				registrationX = regX-shift;
				registrationY = regY-shift;
				bmpd.floodFill(x+mat.tx,y+mat.ty,int("0xff"+col));
				mc.filled = true;
			}
		}
		
		function getMC():MovieClip{
			var bmp:Bitmap = new Bitmap(bmpd);
			bmp.x = registrationX;
			bmp.y = registrationY;
			mc.graphics.clear();
			mc.addChild(bmp);
			return mc;
		}
		
		/*
		function lineFill(x1:int,x2:int,y:int){
			var xL:int;
			var xR:int;
			if(y<minY || y>maxY+1){
				return;
			}
			for(xL=x1;xL>=minX;--xL){
				//scan left
				if(bmpd.getPixel(xL,y)!= seedColor){
					break;
				} else {
					bmpd.setPixel(xL,y,fillcolor);
				}
			}
			if(xL<x1){
				x1++;
				lineFill(xL,x1,y-1);
				lineFill(xL,x1,y+1);
				
			}
			for(xR=x2;xR<=maxX;++xR){
				//scan right
				if(bmpd.getPixel(xR,y)!= seedColor){
					break;
				}
				bmpd.setPixel(xR,y,fillcolor);
			}
			if(xR>x2){
				lineFill(x2,xR,y-1);
				lineFill(x2,xR,y+1);
				x2--;
			}
			for(xR=x1;xR<=Math.min(x2,maxX);++xR){
				//scan betweens
				if(bmpd.getPixel(xR,y)==seedColor){
					bmpd.setPixel(xR,y,fillcolor);
				} else {
					if(x1<xR){
						//fill child
						//x1=xR;
						lineFill(x1,xR-1,y-1);
						lineFill(x1,xR-1,y+1);
						x1=xR;
					}
					for(xR=x1;xR <= Math.min(x2,maxX); ++xR) { 
						// skip over border
                		if( bmpd.getPixel(xR,y) == seedColor ) {
                    		x1 = xR--;
                    		break;
                		}
            		}

				}
			}
		}
		*/
		
	}
}
