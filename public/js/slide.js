( function( window, document, jQuery, undefined ) {

		// 0: viewer
		// 1: presenter
	var slideTypeId = 0,
		slideType, 

		slideTypeList = {
			viewer: 0,
			presenter: 1
		},

		prev = jQuery( '#prev' ),
		next = jQuery( '#next' ),
		showList = jQuery( '#showList' ),
		showCanvas = jQuery( '#showCanvas' ),
		clCanvas = jQuery( '#clCanvas' ),

		slideId = 0,

		pageId = 0,

		draw = null,

		socket = null,

		init = function() {

			draw = new Draw( '#slidePage' );
			getHash();
			socket = new SocketManager();

			socket.init( {
				slideTypeId: slideTypeId,
				slideId: slideId,
				pageId: pageId,

				slideStart: function() {

					if ( slideTypeId === 0 && pageId === 0 ) {

						pageId = socket.getCurrentView();

						if ( pageId === 0 ) {

							pageId = 1;
						}

						var slideUrl = socket.getSlideUrl( pageId );

						if ( slideUrl !== null ) {
							socket.setPageId( pageId );
							drawImage( slideUrl );
						}

					} else {
						drawImage( socket.current() );
					}

				},
				receiveCanvas: function( data ) {

					draw.receiveData( data.canvas.data );
				}
				,

				receivePageId: function( data ) {

					var slideUrl = socket.getSlideUrl( data.pageId );

					if ( slideUrl !== null ) {
						socket.setPageId( data.pageId );
						drawImage( slideUrl );
					}
				}
			});

			if ( slideTypeId === 1 ) {

				draw.setSendCanvas( function( data ) {

					socket.sendCanvas( data );

				} );
			}

		},

		setHash = function () {
			location.hash = '!/' + slideType + '/' + socket.getPageId();
		}, 

		drawImage = function( imageUrl ) {

			if ( imageUrl === null ) {

				return;
			}

			setHash();

			draw.setImage( imageUrl );
		},

		getHash = function() {

			var hash = location.hash;

			if ( !/^#!\//.test( hash ) ) {
				// location.href = 'http://v.u3u.jp/index.html';
				return;
			}

			hashList = hash.replace( /^#!\//, '' ).split( '/' );

			if ( hashList[0] === undefined ) {
				// location.href = 'http://v.u3u.jp/index.html';
				return;
			}

			if ( slideTypeList[hashList[0]] !== undefined ) {

				slideType = hashList[0];

				slideTypeId = slideTypeList[hashList[0]];

			} else {
				// location.href = 'http://v.u3u.jp/index.html';
				return;
			}

			console.log(document.URL);

			slideId = document.URL.split( "/#" )[0].split( "/" ).pop();

			if ( !/[0-9]/.test( slideId ) ) {
				// location.href = 'http://v.u3u.jp/index.html';
				return;
			}

			slideId = Number( slideId );

			if ( hashList[1] !== undefined ) {

				pageId = Number( hashList[1] );

				if ( isNaN( pageId ) ) {

					pageId = 0;
				}

			}
		};

	prev.click( function() {
		drawImage( socket.prev() );
	} );

	next.click( function() {
		drawImage( socket.next() );
	} );

	showCanvas.toggle( function() {
		$("#slide-list").hide();
		$("#canvas-menu").show();
		$("#showCanvas").html("<i class='icon-th-list'></i>")
		draw.setCanvas();
	},function() {
		$("#slide-list").show();
		$("#canvas-menu").hide();
		$("#showCanvas").html("<i class='icon-pencil'></i>")
		draw.setCanvas();
	} );

	clCanvas.click( function() {
		draw.clear();
	} );

	$("#screen-button").toggle(function(){
		slide.enterFullscreen('slideMain');
	},function() {
		slide.exitFullscreen();
	});

	$(".changeColor").click(function(){
		$(".changeColor").removeClass("selectedColor");
		$(this).addClass("selectedColor");
		draw.changeColor($(this).attr("color"));
	});
	$("#lineWidth").change(function(){
		draw.changeLineWidth($("#lineWidth").val())
	});

	jQuery( '#wrapper' ).bind( 'webkitfullscreenchange', function() {

		jQuery( window ).resize();
	} );

	jQuery( window ).resize( function() {
		var isFullScreen = document.mozFullScreen || document.webkitIsFullScreen;
		if ( isFullScreen ) {
			jQuery( '#slideMain' ).height( window.innerHeight - 10 );
		} else {
			jQuery( '#slideMain' ).height( window.innerHeight - 180 );
		}

		draw.resize( jQuery( '#slide' ).width(), jQuery( '#slide' ).height() );
		jQuery( '#slide-list' ).height( jQuery('#slideMain').height() - 2 );
	} );

	jQuery( window ).keyup( function( event ) {

		var code = event.keyCode;

		if ( code === 37 ) {
			drawImage( socket.prev() );
		} else if ( code === 39 ) {
			drawImage( socket.next() );
		}
	} );

	var index = 1;
	jQuery( '#sidebar tr' ).each( function() {

		var pageId = jQuery( this ).data( 'index', index++ );
	});

	jQuery( '#sidebar tr' ).click( function () {

		var pageId = jQuery( this ).data( 'index' );

		var slideUrl = socket.getSlideUrl( pageId );

		if ( slideUrl !== null ) {
			socket.setPageId( pageId );
			drawImage( slideUrl );
		}

	} );

	init();

	jQuery( window ).resize();

} )( window, document, jQuery );
