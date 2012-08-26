( function( window, document, jQuery, undefined ) {

    var Draw = function( idName ) {

		this.idName = idName;
        this.canvas = jQuery( this.idName );
        this.context = this.canvas[0].getContext( '2d' );
        this.image = new Image();
		this.width = 0;
		this.height = 0;
		this.sendCanvas = function( data ) { console.log("hogehoge") };

        // canvas用データ
        this.canvas_y = this.canvas.offset().top;
        this.canvas_x = this.canvas.offset().left;
        this.ox = 0;
        this.oy = 0;
        this.imgSizeX = 0;
        this.imgSizeY = 0;
        // ラインの要素
        this.drowPointDataKey = -1;
        // ラインの座標格納
        this.drowPointData = {};
        // 一時的な座標格納
        this.tmp = [];
        // canvas実行フラグ11
        this.canvas_event = false;
        this.mouse_event = false;

        this.nodeOx = 0;
        this.nodeOy = 0;
        this.nodePx = 0;
        this.nodePy = 0;

		var self = this;

    	jQuery( idName ).bind("mousedown", function(e) {
			self.mouseDown(e);
		} );

		jQuery( idName ).bind("mousemove", function(e) {
        	self.mouseMove(e);
		});

    	jQuery( idName ).bind("mouseup", function() {
        	self.mouseUp();
        });

    	jQuery( idName ).bind("touchstart", function() {
            self.touchStart();
        });

    	jQuery( idName ).bind("touchmove", function() {
            self.touchMove();
        });

    	jQuery( idName ).bind("touchend", function() {
            self.touchEnd();
        });

        return this;
    };

    Draw.prototype = {

        setImage: function( imageUrl ) {

			this.context.clearRect( 0, 0, this.width, this.height );

			var self = this;

			if ( this.image.src !== undefined && this.image.src === imageUrl ) {

				this.drawImage();

			} else {

				this.image.src = imageUrl;

				this.image.onload = function() {

					self.drawImage();
				};
			}

		},

		drawImage: function(resizeflag) {

			var cwidth  = this.canvas.width(),
				cheight = this.canvas.height(),
				iwidth  = this.image.width,
				iheight = this.image.height,
				width   = 0,
				height  = 0,
				top     = 0,
				left    = 0,
				type    = 0;
            this.imgSizeX = cwidth;
            this.imgSizeY = cheight;
            //console.log(cwidth);
            //console.log(cheight);

            // 今まで記載してきた内容をクリア
            if (resizeflag !== 1) {
                this.context.beginPath();
            }

			if ( cwidth <= cheight ) {
				if ( iheight > iwidth ) {
					type = 1;
				} else {
					type = 0;
				}
			} else {
				if ( iwidth < iheight ) {
					type = 0;
				} else {
					type = 1;
				}
			}

			if ( type === 0 ) {

				width = cwidth;
				height = iheight * ( cwidth / iwidth );
				top = ( cheight - height ) / 2;
				left = 0;

			} else {

				height = cheight;
				width  = iwidth * ( cheight / iheight );
				left = ( cwidth - width ) / 2;
				top = 0;
			}

			//console.log( iwidth + " " + iheight + " " + left + " " + " " + top + " " + width + " " + height );

			this.context.drawImage( this.image, 0, 0, iwidth, iheight, left, top, width, height );
		},

		refresh: function(width, height, canvasMigFlag) {

			this.context.clearRect( 0, 0, this.width, this.height );

			this.drawImage(1);

            if (canvasMigFlag === true) {
                this.context.stroke();
            }
		},

        clear: function() {

            var width = this.canvas.width();
            var height = this.canvas.height();
            this.context.beginPath();
            this.context.clearRect(0, 0, this.canvas.width(), this.canvas.height());
            this.refresh(width, height, false);

            var clearData = {"t":"delete"};
			this.sendCanvas( clearData );

        },

		resize: function( width, height ) {

			this.canvas.attr( { width:  width  + 'px', height: height + 'px' } );

            var drowPointList = this.drowPointData.length;

            var len = 0;
            for (var key in this.drowPointData) {
                ++len;
            }

            var ox = 0;
            var oy = 0;
            var px = 0;
            var py = 0;
            for (i = 0; i < len; i++) {
                var drowPointDataList = this.drowPointData[i].length;
                for (k = 0; k < drowPointDataList; k++) {
                    if (this.drowPointData[i][k]['i'] !== -1) {
                        this.context.strokeStyle = this.drowPointData[i][k]['rgba'];
                        this.context.lineWidth = 3;
                        ox = this.drowPointData[i][k]['x'] * width;
                        oy = this.drowPointData[i][k]['y'] * height;
                        if (this.drowPointData[i][k]['i'] == 0) {
                            this.context.moveTo(ox,oy);
                        } else {
                            this.context.moveTo(px,py);
                        }
                        this.context.lineTo(ox, oy);
                        this.context.closePath();
                        px = ox;
                        py = oy;
                    }
                }
            }

            this.refresh(width, height, false);
		},

        setCanvas: function() {
            if (this.canvas_event === false) {
                this.canvas_event = true;
            } else {
                this.canvas_event = false;
            }
            //console.log(this.canvas_event);
        },

        mouseDown: function (e) {
                    //console.log(event.offsetX);
            if (this.canvas_event) {
               this.ox = e.pageX - this.canvas_x;
               //console.log(e.pageX);
               //console.log(this.ox);

               this.oy = e.pageY - this.canvas_y;

               this.mouse_event = true;

               this.drowPointDataKey++;
               this.drowPointData[this.drowPointDataKey] = [];
            }

        },

        mouseMove: function (e) {

					//console.log(event.pageX - this.canvas.offset().left);
            if (this.mouse_event && this.canvas_event) {

                var px = e.pageX - this.canvas_x;
                var py = e.pageY - this.canvas_y;
                this.context.strokeStyle = "#554466";
                this.context.lineWidth   = 3;
                this.context.moveTo(this.ox, this.oy);
                this.context.lineTo(px, py);
                this.context.closePath();
                this.context.stroke();
                this.ox = px;
                this.oy = py;

                var minOx = this.ox / this.imgSizeX;
                var minOy = this.oy / this.imgSizeY;

                var index = this.tmp.length;
                var drawData = {"t":"draw", "x":minOx, "y":minOy, "i":index, "c":this.context.strokeStyle};
                this.tmp.push(drawData);
                if (this.canvas.width() -10 < px) {
                    this.mouse_event = false;
                }

				this.sendCanvas( drawData );
            }
        },

        mouseUp: function() {
            if (this.canvas_event) {
                this.mouse_event = false;
                var drawData = {"t":"draw", "x":0, "y":0, "i":-1, "c":this.context.strokeStyle};
                this.tmp.push(drawData);
                this.drowPointData[this.drowPointDataKey] = this.tmp;
                this.tmp = [];

				this.sendCanvas( drawData );
            }
        },

        touchStart: function() {
            if (this.canvas_event) {
                event.preventDefault();
                this.ox = event.changedTouches[0].pageX - this.canvas_x;
                this.oy = event.changedTouches[0].pageY - this.canvas_y;
                this.mouse_event = true;
                this.drowPointDataKey++;
                this.drowPointData[this.drowPointDataKey] = [];
            }
        },

        touchMove: function() {
            event.preventDefault();
            if (this.mouse_event && this.canvas_event) {
               var px = event.changedTouches[0].pageX - this.canvas_x;
               var py = event.changedTouches[0].pageY - this.canvas_y;
               this.context.strokeStyle = "#FF0000";
               this.context.lineWidth = 3;
               this.context.moveTo(this.ox, this.oy);
               this.context.lineTo(px, py);
               this.context.closePath();
               this.context.stroke();
               this.ox = px;
               this.oy = py;
               var minOx = this.ox / this.imgSizeX;
               var minOy = this.oy / this.imgSizeY;
               var index = this.tmp.length;
               var drawData = {"t":"draw", "x":minOx, "y":minOy, "i":index, "c":this.context.strokeStyle};
               this.tmp.push(drawData);
                if (this.canvas.width() -10 < px) {
                    this.mouse_event = false;
                }

				this.sendCanvas( drawData );
            }

        },

        touchEnd: function() {
            if (this.canvas_event) {
                this.mouse_event = false;
                var drawData = {"t":'draw', "x":0, "y":0, "i":-1, "c":this.context.strokeStyle};
                this.tmp.push(drawData);
                this.drowPointData[this.drowPointDataKey] = this.tmp;
                this.tmp = [];

				this.sendCanvas( drawData );
            }
        },

		setSendCanvas: function( callback ) {

			this.sendCanvas = callback;
		},

		receiveData: function( data ) {

            if (data['t'] === 'draw') {
                cwidth  = this.canvas.width();
                cheight = this.canvas.height();

                if (data['i'] !== -1) {
                    this.context.strokeStyle = data['c'];
                    this.context.lineWidth = 3;
                    this.nodeOx = data['x'] * cwidth;
                    this.nodeOy = data['y'] * cheight;
                    if (data['i'] == 0) {
                        this.context.moveTo(this.nodeOx,this.nodeOy);
                    } else {
                        this.context.moveTo(this.nodePx,this.nodePy);
                    }
                    this.context.lineTo(this.nodeOx, this.nodeOy);
                    this.context.closePath();
                    this.context.stroke();
                    this.nodePx = this.nodeOx;
                    this.nodePy = this.nodeOy;
                } else {
                    this.nodeOx = 0;
                    this.nodeOy = 0;
                    this.nodePx = 0;
                    this.nodePy = 0;

                }
            } else {
                this.clear();
            }
        }
    }

	window.Draw = Draw;

} )( window, document, jQuery );
