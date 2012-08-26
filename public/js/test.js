(function(window, document) {

	var Slide = function() {
		
		return this;
	};
	
	Slide.prototype = {
		//フルスクリーンに切り替え
		enterFullscreen : function(element_id) {
			
			var x = document.getElementById(element_id);
			if (x.webkitRequestFullScreen) {
				x.webkitRequestFullScreen();
			} else if (x.mozRequestFullScreen) {
				x.mozRequestFullScreen();
			} else {
				x.requestFullScreen();
			}
			// document.getElementById('screen-button').addEventListener('click', slide.exitFullscreen, false);

		},

		//フルスクリーンを解除
		exitFullscreen : function() {
			if (document.webkitCancelFullScreen) {
				document.webkitCancelFullScreen();
			} else if (document.mozCancelFullScreen) {
				document.mozCancelFullScreen();
			} else {
				document.exitFullscreen();
			}
			// document.getElementById('screen-button').addEventListener('click', slide.enterFullscreen, false);
		},

		showList : function() {
			$('#sidebar').css('display', 'block');
			$('#slide-list').css('display', 'block');
			$('#canvas-menu').css('display', 'none');
			document.getElementById('sidebar').className = 'span2';
			document.getElementById('main').className = 'span10';
		},

		showCanvas : function() {
			$('#sidebar').css('display', 'block');
			$('#slide-list').css('display', 'none');
			$('#canvas-menu').css('display', 'block');
			document.getElementById('sidebar').className = 'span2';
			document.getElementById('main').className = 'span10';
		},

		showSlide : function() {
			this.enterFullscreen('main');
		},

		prevSlide : function() {

		},

		nextSlide : function() {

		}

	};

	window.Slide = Slide;
})(window, document);

var slide = new Slide();



