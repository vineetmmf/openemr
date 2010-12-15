package com.kglad{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.MovieClip;

	public class ImageLoader extends Loader{
		
		var ldr:Loader;
		var imageS:String;
		var root_mc:MovieClip;

		public function ImageLoader(mc:MovieClip) {
			root_mc = mc;
			ldr = new Loader();
			ldr.name = "ldr";
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,loadFileCompleteF);
		}
		public function set loadImage(s:String):void{
			imageS = "bgimages/"+s;
			startLoad();
		}
		function startLoad():void{
			ldr.load(new URLRequest(imageS));
		}
		
		function loadFileCompleteF(e:Event):void{
			MovieClip(root_mc.getChildByName("canvas")).addChildAt(ldr,0);
	
			var aspectRatio = ldr.width/ldr.height;
			if(aspectRatio>root_mc.stage.stageWidth/(root_mc.stage.stageHeight-root_mc.bg.height)){
				ldr.width = root_mc.stage.stageWidth;
				ldr.height = ldr.width/aspectRatio;
			} else {
				ldr.height = root_mc.stage.stageHeight-root_mc.bg.height;
				ldr.width = aspectRatio*ldr.height;
			}
			ldr.x = (root_mc.stage.stageWidth-ldr.width)/2;
			ldr.y = (root_mc.stage.stageHeight-root_mc.bg.height-ldr.height)/2;
	
		}
		
		public function unloadF():void{
			if(ldr.content){
			    ldr.unload();
			}
		}

		/*
		
		
		
		var fRef:FileReference = new FileReference();
		fRef.addEventListener(Event.SELECT,selectedF);
		fRef.addEventListener(Event.COMPLETE,loadBytesCompleteF);
		
		
		ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,loadFileCompleteF);
		
		function browseF(e:MouseEvent):void{
		fRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png;*.JPG;*.GIF;*.PNG")]);
		}
		function selectedF(e:Event):void{
		fRef.load();
		}
		function loadBytesCompleteF(e:Event):void{
		ldr.loadBytes(e.target.data);
		}
		*/

	}

}