package com.kglad {
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextFormat;
	import fl.controls.List;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.net.URLLoader
	import flash.net.URLRequestMethod;
	
	import com.kglad.ImageListLoader;
	import fl.events.ListEvent;
	import flash.display.Sprite;
	
	public class Draw extends MovieClip{
		
		var toolA:Array;
		var ttSA:Array;
		var toolFA:Array;
		var imageA:Array;
		
		var arial:Font;
		var tfor:TextFormat;
		
		var imageListLoader:ImageListLoader;
		var imageLoader:ImageLoader;
		var list:fl.controls.List = new List();
		var fillInstance:FillClass = new FillClass();
		
		var canvas:MovieClip = new MovieClip();
		var currentToolS:String;
		var itemA:Array = [];
		// 
		var saveImageScript:String = "saveImage.php";

		public function Draw() {
			initTextFormat();
			initImageA();
			initImageLDR();
			addEventListener(Event.ADDED_TO_STAGE,initTools);
		}
		
		function initTools(e:Event):void{
			canvasF();
			shapeToolF(null);
			toolA = [pencil_mc,eraser_mc,undo_mc,sweep_mc,shape_mc,fill_mc,text_mc,load_mc,save_mc];
			ttSA = ["Pencil tool/line thickness","Eraser tool","Undo last change","Clear all","Click to toggle ellipse tool/rectangle tool","Fill tool","Text tool","Load image tool","Save image tool"];
			toolFA = [pencilToolF,eraserToolF,undoF,sweepF,shapeToolF,fillToolF,textToolF,browseF,saveF];
			
			for(var i:uint=0;i<toolA.length;i++){
				toolA[i].ivar = i;
				toolA[i].addEventListener(MouseEvent.MOUSE_OVER,iconOverF);
				toolA[i].addEventListener(MouseEvent.MOUSE_OUT,iconOutF);
				toolA[i].addEventListener(MouseEvent.MOUSE_DOWN,toolFA[i]);
			}

			colorpicker_mc.addEventListener(MouseEvent.MOUSE_OVER,colorpickerOverF);
			colorpicker_mc.addEventListener(MouseEvent.MOUSE_OUT,iconOutF);
		}
		function canvasF(){
			canvas = new MovieClip();
			canvas.name = "canvas";
			addChild(canvas);
			with(canvas.graphics){
				beginFill(0xffffff);
				drawRect(0,0,stage.stageWidth,stage.stageHeight-bg.height);
				endFill();
			}
			canvas.addEventListener(MouseEvent.MOUSE_DOWN,canvasDownF);
			canvas.addEventListener(MouseEvent.MOUSE_UP,canvasUpF);
		}
		
		function canvasDownF(e:MouseEvent):void{
			if(currentToolS!="fill"){
				var mc:MovieClip = new MovieClip();
				canvas.addChild(mc);
				mc.x = canvas.mouseX;
				mc.y = canvas.mouseY;
				mc.lineThickness = stepper.value;
				mc.name = currentToolS+"_"+getTimer();
				itemA.push(mc);
			}
			switch(currentToolS){
				case "text":
        			//textF() called in canvasUpF to set focus
        			break;
				case "rect":
        			rectangleStartF()
        			break;
				case "ellipse":
        			ellipseStartF()
        			break;
				case "fill":
        			fillF()
        			break;
				case "pencil":
        			pencilStartF()
        			break;
				case "eraser":
        			eraserStartF()
        			break;
    			default:
					itemA.pop();
					break;
			}
		}
		function canvasUpF(e:MouseEvent):void{
			switch(currentToolS){
				case "text":
        			textF();
        			break;
				case "rect":
        			rectangleStopF()
        			break;
				case "ellipse":
        			ellipseStopF()
        			break;
				case "pencil":
        			pencilStopF()
        			break;
				case "eraser":
        			eraserStopF()
        			break;
    			default:
					break;
			}
		}
		
		function initTextFormat():void{
			arial = new ArialC();
			tfor = new TextFormat();
			tfor.font = arial.fontName;
			tfor.size = 16;
		}
		
		function initImageA():void{
			imageListLoader = new ImageListLoader();
			imageListLoader.addEventListener("imageListLoaded",imageListF);
		}
		function imageListF(e:Event):void{
			imageA = imageListLoader.imageList;
			var w:Number = 0;
			
			for(var i:uint=0;i<imageA.length;i++){
				w = Math.max(w,imageA[i].length);
				list.addItem({label:imageA[i]});
			}
			list.width = 30+w*5;
			initListComponent();
		}
		function initListComponent(){
			list.addEventListener(ListEvent.ITEM_CLICK,listClickF);
		}
		function listClickF(e:ListEvent):void{
			removeChild(list);
			imageLoader.loadImage = e.item.label;
			itemA.push("loadedImage");
			//trace(e.item.label);
		}
		function initImageLDR():void{
			imageLoader = new ImageLoader(MovieClip(this.root));
		}
		
		function colorpickerOverF(e:MouseEvent):void{
			addTTF(DisplayObject(e.currentTarget),"Color picker tool");
		}

		

		function pencilToolF(e:MouseEvent):void{
			frameF(e.currentTarget);
			currentToolS = "pencil";
		}
		function pencilStartF():void{
			pencil_mc.minX = 0;
			pencil_mc.minY = 0;
			with(itemA[itemA.length-1].graphics){
				moveTo(0,0);
				lineStyle(stepper.value,colorpicker_mc.selectedColor);
			}
			canvas.addEventListener(MouseEvent.MOUSE_MOVE,drawPencilF);
		}
		function pencilStopF():void{
			itemA[itemA.length-1].w = itemA[itemA.length-1].width;
			itemA[itemA.length-1].h = itemA[itemA.length-1].height;
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE,drawPencilF);
		}
		function drawPencilF(e:MouseEvent):void{
			pencil_mc.minX = Math.min(pencil_mc.minX,canvas.mouseX-itemA[itemA.length-1].x);
			pencil_mc.minY = Math.min(pencil_mc.minY,canvas.mouseY-itemA[itemA.length-1].y);
			//trace(pencil_mc.minX,pencil_mc.minY);
			with(itemA[itemA.length-1].graphics){
				lineTo(canvas.mouseX-itemA[itemA.length-1].x,canvas.mouseY-itemA[itemA.length-1].y);
			}
		}
		function eraserToolF(e:MouseEvent):void{
			frameF(e.currentTarget);
			currentToolS = "eraser";
		}
		function eraserStartF():void{
			with(itemA[itemA.length-1].graphics){
				moveTo(0,0);
				lineStyle(stepper.value,0xffffff);
			}
			canvas.addEventListener(MouseEvent.MOUSE_MOVE,drawEraserF);
		}
		function eraserStopF():void{
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE,drawEraserF);
		}
		function drawEraserF(e:MouseEvent):void{
			with(itemA[itemA.length-1].graphics){
				lineTo(canvas.mouseX-itemA[itemA.length-1].x,canvas.mouseY-itemA[itemA.length-1].y);
			}
		}
		function undoF(e:MouseEvent):void{
			if(e){
				frameF(e.currentTarget);
			} else {
				frameF(sweep_mc);
			}
			if(itemA.length>0){
				var item:* = itemA.pop();
				if(item=="loadedImage"){
					//imageLoader.unloadF();
				} else {
				    canvas.removeChild(item);
				    item = null;
				}
			}
		}
		function sweepF(e:MouseEvent):void{
			//frameF(e.currentTarget);
			//trace(itemA.length,canvas.numChildren);
			for(var i:int=itemA.length-1;i>=0;i--){
				undoF(null);
			}
			
		}
		///////////////////////////////////////////
		function shapeToolF(e:MouseEvent):void{
			frameF(shape_mc);
			if(!shape_mc.rect_mc.stage){
				currentToolS = "rect";
				shape_mc.addChild(shape_mc.rect_mc);
				shape_mc.removeChild(shape_mc.ellipse_mc);
			} else {
				currentToolS = "ellipse";
				shape_mc.removeChild(shape_mc.rect_mc);
				shape_mc.addChild(shape_mc.ellipse_mc);
			}
		}
		function ellipseStartF(){
			canvas.addEventListener(MouseEvent.MOUSE_MOVE,drawEllipseF);
		}
		function ellipseStopF(){
			itemA[itemA.length-1].w = itemA[itemA.length-1].width;
			itemA[itemA.length-1].h = itemA[itemA.length-1].height;
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE,drawEllipseF);
		}
		function drawEllipseF(e:MouseEvent):void{
			var mc:MovieClip = itemA[itemA.length-1];
			with(mc.graphics){
				clear();
				lineStyle(stepper.value,colorpicker_mc.selectedColor);
				drawEllipse(0,0,canvas.mouseX-mc.x,canvas.mouseY-mc.y);
			}
		}
		function rectangleStartF(){
			canvas.addEventListener(MouseEvent.MOUSE_MOVE,drawRectF);
		}
		function rectangleStopF(){
			itemA[itemA.length-1].w = itemA[itemA.length-1].width;
			itemA[itemA.length-1].h = itemA[itemA.length-1].height;
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE,drawRectF);
		}
		function drawRectF(e:MouseEvent):void{
			var mc:MovieClip = itemA[itemA.length-1];
			with(mc.graphics){
				clear();
				lineStyle(stepper.value,colorpicker_mc.selectedColor);
				drawRect(0,0,canvas.mouseX-mc.x,canvas.mouseY-mc.y);
			}
		}
		/////////////////////////////////////////
		function fillToolF(e:MouseEvent):void{
			frameF(e.currentTarget);
			currentToolS = "fill"
		}
		function fillF():void{
			for(var i:uint=0;i<itemA.length;i++){
				if(itemA[i]!="loadedImage"){
					if(itemA[i].hitTestPoint(canvas.mouseX,canvas.mouseY)){
						//trace(itemA[i].name,pencil_mc.minX,pencil_mc.minY);
						if(itemA[i].name.indexOf("pencil")>-1){
							fillInstance.fillF(itemA[i],itemA[i].mouseX,itemA[i].mouseY,colorpicker_mc.hexValue,pencil_mc.minX,pencil_mc.minY);
							fillInstance.getMC();
						} else {
							fillInstance.fillF(itemA[i],itemA[i].mouseX,itemA[i].mouseY,colorpicker_mc.hexValue,0,0);
							fillInstance.getMC();
						}
						//trace("fill");
						break;
					}
				}
			}
		}
		///////////////////////////////////////////
		function iconOverF(e:MouseEvent):void{
			addTTF(DisplayObject(e.currentTarget),ttSA[MovieClip(e.currentTarget).ivar]);
		}
		function iconOutF(e:MouseEvent):void{
			removeTTF();
		}
		function addTTF(dobj:DisplayObject,s:String):void{
			removeTTF();
			var tf:TextField = new TextField();
			tf.background = true;
			tf.backgroundColor = 0xffffff;
			tfor.color = 0x000000;
			tf.embedFonts = true;
			tf.defaultTextFormat = tfor;
			tf.name = "tt_tf";
			tf.multiline = false;
			tf.autoSize = "left";
			tf.border = true;
			tf.text = s;
			addChild(tf);
			if(dobj.x<stage.stageWidth/2){
				tf.x = dobj.x;
			} else {
				tf.x = dobj.x+dobj.width-tf.width;
			}
			tf.y = stage.stageHeight-bg.height-tf.height;
		}
		function removeTTF():void{
			var tf:TextField = TextField(getChildByName("tt_tf"));
			if(tf){
				tf.parent.removeChild(tf);
				tf = null;
			}
		}
		///////////////////////////////////////////
		function textToolF(e:MouseEvent):void{
			frameF(e.currentTarget);
			currentToolS = "text";
		}
		function textF():void{
			var tf:TextField = new TextField();
			stage.focus = tf;
			if(colorpicker_mc.selectedColor<0x808080){
				tfor.color = 0xffffff;
			} else {
				tfor.color = 0x000000;
			}
			tfor.size = 16;
			tf.defaultTextFormat = tfor;
			itemA[itemA.length-1].addChild(tf);
			tf.type = "input";
			tf.border = true;
			tf.background = true;
			tf.backgroundColor = colorpicker_mc.selectedColor;
			tf.autoSize = "left";
		}
		function saveF(e:MouseEvent):void{
			frameF(e.currentTarget);
			
        	var bmpd:BitmapData = new BitmapData(canvas.width, canvas.height, false);
         	bmpd.draw(canvas);
         	var imageByteArray:ByteArray = PNGEncoder.encode(bmpd);
         
         	var req:URLRequest = new URLRequest(saveImageScript);
         	req.contentType = "application/octet-stream";
         	req.method = URLRequestMethod.POST;
         	req.data = imageByteArray;
         
         	var loader:URLLoader = new URLLoader();
         	loader.load(req); 
			// fake save-successful message
			setTimeout(saveMessageF,1000,e.currentTarget);
			
		}
		function saveMessageF(dobj:DisplayObject):void{
			saveImageTF("Your image has been saved.\n(Click to clear this message.)");
		}
		function saveImageTF(s:String):void{
			removeSaveImageTF(null);
			canvas.visible = false;
			var sp:Sprite = new Sprite();
			sp.name = "saveImage_sp";
			var check_mc:Check = new Check();
			sp.addChild(check_mc);
			addChild(sp);
			var tf:TextField = new TextField();
			tf.background = true;
			tf.backgroundColor = 0xff4444;
			tfor.color = 0x000000;
			tfor.size = 22;
			tf.embedFonts = true;
			tf.defaultTextFormat = tfor;
			tf.name = "saveImage_tf";
			tf.multiline = true;
			tf.width = stage.stageWidth;
			tf.autoSize = "left";
			tf.border = true;
			tf.text = s;
			sp.addChild(tf);
			tf.x = check_mc.width+5;
			sp.x = (stage.stageWidth-sp.width)/2;
			sp.y = (stage.stageHeight-sp.height)/2;
			sp.mouseChildren = false;
			sp.buttonMode = true;
			sp.addEventListener(MouseEvent.CLICK,removeSaveImageTF);
		}
		function removeSaveImageTF(e:MouseEvent):void{
			canvas.visible = true;;
			var sp:Sprite = Sprite(getChildByName("saveImage_sp"));
			if(sp){
				sp.parent.removeChild(sp);
			}
		}
		function browseF(e:MouseEvent):void{
			if(!list.stage){
				frameF(e.currentTarget);
				addChild(list);
				list.x = e.currentTarget.x+e.currentTarget.width-list.width;
				list.y = stage.stageHeight-bg.height-list.height;
			} else {
				removeChild(list);
				removeChild(frame_mc);
			}
		}
		function frameF(dobj:Object):void{
			addChild(frame_mc);
			frame_mc.width = dobj.width+4;
			frame_mc.height = dobj.height+4;
			frame_mc.x = dobj.x-2;
			frame_mc.y = dobj.y-2;
		}

	}
	
}





