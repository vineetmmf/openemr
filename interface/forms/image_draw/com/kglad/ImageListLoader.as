package com.kglad{
	
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ImageListLoader extends URLLoader{
		
		var urlLDR:URLLoader;
		var imageListA:Array;

		public function ImageListLoader() {
			urlLDR = new URLLoader();
			urlLDR.addEventListener(Event.COMPLETE,imageListLoadComplete);
			urlLDR.load(new URLRequest("getimages.php"));
		}
		
		function imageListLoadComplete(e:Event){
			imageListA = e.target.data.split("<BR>");
			imageListA.pop();
			dispatchEvent(new Event("imageListLoaded"));
		}
		
		public function get imageList():Array{
			return imageListA;
		}

		/*
		
		var ldr:Loader = new Loader();
		
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