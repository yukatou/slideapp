( function( window, document, jQuery, undefined ) {

	var socketUrl = 'http://v.u3u.jp:10081', 
		SocketManager = function () {

			this.socket  = null;
			this.slideTypeId = null;
			this.slideId = null;
			this.pageId  = null;
			this.slideData = null;
			this.currentView = 0;
			this.slideStart = function() {};
			this.receiveCanvas = function() {};
			this.receivePageId = function() {};
		
			return this;
		};

	SocketManager.prototype = {

		_setPresenter: function () {

			var self = this;

			this.socket = io.connect( socketUrl + '/presenter' );

			if ( this.pageId === 0 ) {

				this.pageId = 1;
			}
			
			this.socket.on( 'connect', function() {
				self.socket.emit( 'init', { slideId: self.slideId, 
											pageId:  self.pageId } );
			} );


			this.socket.on( 'slideData', function( data ) {

				self.slideData = data;
				self.slideStart();
			} );
		}, 

		_setViewer: function () {

			var self = this;

			this.socket = io.connect( socketUrl + '/viewer' );

			this.socket.on( 'connect', function() {
				self.socket.emit( 'init', { slideId: self.slideId, 
											pageId:  self.pageId } );
			} );


			this.socket.on( this.slideId, function( data ) {

				if ( data.dataType === 'pageId' ) {
				
					self.receivePageId( data.data );
				
				} else if (data.dataType === 'canvas' ) {

					self.receiveCanvas( data.data );
				}

			} );

			this.socket.on( 'slideData', function( data ) {

				if ( data.currentView !== undefined ) {

					self.currentView = data.currentView;
				}
				
				self.slideData = data;
				self.slideStart();
			} );
		}, 

		init: function ( data ) {

			this.slideId = data.slideId;
			this.pageId  = data.pageId;
			this.slideTypeId = data.slideTypeId;
			this.slideStart = data.slideStart;
			this.receiveCanvas = data.receiveCanvas;
			this.receivePageId = data.receivePageId;
		
			if ( data.slideTypeId === 0 ) {

				this._setViewer();
			
			} else {

				this._setPresenter();
			}
		
		}, 

		sendCanvas: function ( data ) {

			this.socket.emit( 'canvas', { slideId: this.slideId, 
										  data: data 
										 } );
		}, 

		prev: function () {

			this.pageId--;
			var url = this.current();

			if ( url === null ) {

				this.pageId++;
			}

			return url;

		}, 

		next: function () {

			this.pageId++;
			var url = this.current();

			if ( url === null ) {

				this.pageId--;
			}

			return url;
		}, 

		current: function () {

			if ( this.slideData.data[this.pageId] !== undefined ) {

				if ( this.slideTypeId === 1 ) {
					this.socket.emit( 'currentView', { slideId: this.slideId, 
													   pageId:  this.pageId } );

					this.currentView = this.pageId;
				}

				return this.slideData.data[this.pageId].url;
			}

			return null;
		}, 

		getSlideUrl: function ( pageId ) {

			if ( this.slideData.data[pageId] !== undefined ) {

				return this.slideData.data[pageId].url;
			}

			return null;
		}, 
		
		setPageId: function ( pageId ) {

			this.pageId = pageId;

			if ( this.slideTypeId === 1 ) {
				this.socket.emit( 'currentView', { slideId: this.slideId, 
												   pageId:  this.pageId } );
			}
		}, 


		getPageId: function () {

			return this.pageId;
		}, 

		getCurrentView: function () {

			return this.currentView;
		}
	};

	window.SocketManager = SocketManager;

} )( window, document, jQuery );
