( function( window, document, jQuery, undefined ) {

		// 0: viewer
		// 1: presenter
	var slideTypeId = 0,

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

						drawImage( socket.getSlideUrl( pageId ) );

					} else {
						drawImage( socket.current() );
					}

				},
				receiveCanvas: function( data ) {

					draw.receiveData( data.canvas.data );
				}
				,

				receivePageId: function( data ) {

					drawImage( socket.getSlideUrl( data.pageId ) );

				}
			});

			if ( slideTypeId === 1 ) {

				draw.setSendCanvas( function( data ) {

					socket.sendCanvas( data );

				} );
			}

		},

		drawImage = function( imageUrl ) {

			if ( imageUrl === null ) {

				return;
			}

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

	$("#blackButton").click(function(){ draw.changeColor("black")});
	$("#whiteButton").click(function(){ draw.changeColor("white")});
	$("#redButton").click(function(){ draw.changeColor("red")});
	$("#blueButton").click(function(){ draw.changeColor("blue")});
	$("#orangeButton").click(function(){ draw.changeColor("orange")});
	$("#greenButton").click(function(){ draw.changeColor("green")});
	$("#lineWidth").change(function(){ draw.changeLineWidth($("#lineWidth").val())});


	jQuery( window ).resize( function() {
		jQuery( '#slide' ).width( jQuery('#slideMain').width() );
		jQuery( '#slide' ).height( window.innerHeight - 210 );

		draw.resize( jQuery( '#slide' ).width(), jQuery( '#slide' ).height() );
		jQuery( '#slide-list' ).height( jQuery('#slideMain').height() - 2 );
	} );

	init();

	jQuery( window ).resize();

} )( window, document, jQuery );
