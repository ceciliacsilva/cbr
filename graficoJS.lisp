(load "motores.lisp")

(defun graficoJS (matDH matDH1 matDH2 matDH3 matDH4)
  (concatenate 'string
	       "<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>
<script src='jquery.min.js'></script>
<script>
//////////////////////////////////////////////////////////////
//DEFINE MATRIX CLASS

function Matrix(ary) {
    this.mtx = ary
    this.height = ary.length;
    this.width = ary[0].length;
}
 
Matrix.prototype.toString = function() {
    var s = []
    for (var i = 0; i < this.mtx.length; i++) 
        s.push( this.mtx[i].join(',') );
    return s.join('\n');
}
 
// returns a new matrix
Matrix.prototype.transpose = function() {
    var transposed = [];
    for (var i = 0; i < this.width; i++) {
        transposed[i] = [];
        for (var j = 0; j < this.height; j++) {
            transposed[i][j] = this.mtx[j][i];
        }
    }
    return new Matrix(transposed);
}
 
// returns a new matrix
Matrix.prototype.mult = function(other) {
    if (this.width != other.height) {
        throw 'error: incompatible sizes';
    }
 
    var result = [];
    for (var i = 0; i < this.height; i++) {
        result[i] = [];
        for (var j = 0; j < other.width; j++) {
            var sum = 0;
            for (var k = 0; k < this.width; k++) {
                sum += this.mtx[i][k] * other.mtx[k][j];
            }
            result[i][j] = sum;
        }
    }
    return new Matrix(result); 
}

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
// BEGIN 3D GRAPH SECTION
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
maxVal = 40;
maxVal2 = 40;

middleX = 171;
middleY = 160;

zoomRatio = maxVal / middleX;
zoomRatio2 = maxVal2 / middleX;

tx = " (substitute #\0 #\d (write-to-string (first (pegarPosicao  matDH4))))";
ty = " (substitute #\0 #\d (write-to-string (second (pegarPosicao  matDH4))))";
tz = " (substitute #\0 #\d (write-to-string (third (pegarPosicao  matDH4))))";

tx2 = " (substitute #\0 #\d (write-to-string (first (pegarPosicao  matDH3))))";
ty2 = " (substitute #\0 #\d (write-to-string (second (pegarPosicao  matDH3))))";
tz2 = " (substitute #\0 #\d (write-to-string (third (pegarPosicao  matDH3))))";


tx3 = " (substitute #\0 #\d (write-to-string (first (pegarPosicao  matDH2))))";
ty3 = " (substitute #\0 #\d (write-to-string (second (pegarPosicao  matDH2))))";
tz3 = " (substitute #\0 #\d (write-to-string (third (pegarPosicao  matDH2))))";


tx4 = " (substitute #\0 #\d (write-to-string (first (pegarPosicao matDH1))))";
ty4 = " (substitute #\0 #\d (write-to-string (second (pegarPosicao  matDH1))))";
tz4 = " (substitute #\0 #\d (write-to-string (third (pegarPosicao  matDH1))))";


tx5 = " (substitute #\0 #\d (write-to-string (first (pegarPosicao matDH))))";
ty5 = " (substitute #\0 #\d (write-to-string (second (pegarPosicao  matDH))))";
tz5 = " (substitute #\0 #\d (write-to-string (third (pegarPosicao  matDH))))";
//////////////////////////////////////////////////////////////
// make rotation matrices

// functions to update the matrices
function RZ(phi) {
    PHI = phi;
    Rz = new Matrix([[ Math.cos(phi) , Math.sin(phi) , 0, 0],
                     [- Math.sin(phi), Math.cos(phi), 0, 0],
                     [0,0,1,0],[0,0,0,1]]);
}
function RX(theta) {
    THETA = theta;
    Rx = new Matrix([[1,0,0,0],
                     [0,Math.cos(theta),Math.sin(theta),0],
                     [0,-Math.sin(theta),Math.cos(theta),0],
                     [0,0,0,1]]);
}
function TZ(z) {
    Tz = new Matrix([[1,0,0,0],[0,1,0,0],[0,0,0,0],[0,0,z,1]]);
}

function updateR() {
    R = Rz.mult(Rx);
    R = R.mult(Tz);
}
function updateRZ(phi) {
    RZ(phi);
    updateR();
}
function updateRX(theta) {
    RX(theta);
    updateR();
}
function updateTZ(z) {
    TZ(z);
    updateR();
}



// set the default view orientation
RZ( Math.PI / 4.0 );
RX( Math.PI / 4.0 );
updateTZ(10.0);

//////////////////////////////////////////////////////////////
// point class - constructed x, y, and z
//
// used for data organization
//
// project uses the projection matrix
function Point(xx, yy, zz) {
    this.m = new Matrix([[xx,yy,zz,0]])
    
    this.project = function() {
        return this.m.mult(R)
    };
};

/////////////////////////////////////////////////////////////
// line class - constructed with two points, an 
//
// use this to add a line to the graph
//
// use update class to update the positions of 
function Line(start, end, id) {
    this.start = start; // start point
    this.end = end;     // end point
    
    this.id = id; // uniquely identifiable jquery string
    
    this.update = function() {
        // find start and end points in 2d space
        var s = this.start.project();
        var e = this.end.project();
        
        // draw line between two points
        $(this.id).attr('x1', s.mtx[0][0] + middleX );
        $(this.id).attr('y1', s.mtx[0][1] + middleY );
        $(this.id).attr('x2', e.mtx[0][0] + middleX );
        $(this.id).attr('y2', e.mtx[0][1] + middleY );
    }
    
    //update graphics when constructed
    this.update();
};

function Dot(id, p1, p2, p3) {
    var circ = document.createElementNS('http://www.w3.org/2000/svg','circle');
    
    // style the dot
    circ.setAttribute('stroke','black');
    circ.setAttribute('stroke-width','1.5');    
    circ.setAttribute('id',id+'-point');
    circ.setAttribute('r','4.5');
    circ.setAttribute('fill','rgb(200,000,000)');
    
    $('#3d-graph').append(circ);
    this.$dot = $('#3d-graph #' + id + '-point')
    
    this.hasError = false;
    
    this.update = function () {
        this.xDot.update();
        this.yDot.update();
        this.zDot.update();
        
        if ( this.hasError ) {
            this.hyp.update();
        }
        
        dotPos = this.dot.project();
        this.$dot.attr('cx',dotPos.mtx[0][0] + middleX);
        this.$dot.attr('cy',dotPos.mtx[0][1] + middleY);
    }
    this.changePoint = function() {
        this.x = p1 / zoomRatio;
        this.y = p2 / zoomRatio;
        this.z = p3 / zoomRatio2;
      
        this.xDot = new Line( new Point(0,this.y,0), new Point(this.x,this.y,0), this.xDotID );
        
        this.yDot = new Line( new Point(this.x,0,0), new Point(this.x,this.y,0), this.yDotID );
        
        this.zDot = new Line( new Point(this.x,this.y,0), new Point(this.x, this.y, this.z), this.zDotID );
        
        //change point for circle
        this.dot = new Point(this.x, this.y, this.z);
       
        this.len = Math.sqrt( this.x*this.x + this.y*this.y + this.z*this.z );
        $('#length').html( Math.round(this.len) * zoomRatio );
        
        if ( this.len > middleX && this.hasError === false ) {
            this.hasError = true;
            
            $('#length').addClass('error');
            
            this.$hyp = $(document.createElementNS('http://www.w3.org/2000/svg','line'));
            this.$hyp.attr('style','stroke:red;stroke-width:1;');
            this.$hyp.attr('id','hyp-error');
            
            $('#3d-graph').append(this.$hyp);
            
            
            this.$dot.attr('stroke','rgb(150,0,0)');
            this.$dot.attr('r','4');
            this.$dot.attr('fill','rgb(255,0,0)');
        }
        else if ( this.len <= middleX && this.hasError === true ) {
            $('#length').removeClass('error');
            
            this.hasError = false;
            
            this.$hyp.remove();
            
            this.$dot.attr('stroke','black');
            this.$dot.attr('r','3');
            this.$dot.attr('fill','rgb(200,200,200)');
        }
        
        if ( this.hasError === true ) {
            this.hyp = new Line( origin, new Point(this.x, this.y, this.z), '#hyp-error' );
        }
        
        
        this.update();
    }
    
    this.changePoint();
}

// update all lines when refreshing the display
lines = [];
function updateLines() {
    for ( l in lines ) {
        lines[l].update();
    }
}

// update all dots when refreshing the display
dots = [];
function updateDots() {
    for( d in dots ) {
        dots[d].update();
    }
}



$(document).ready(function () {
    //attach a mover for left drag and middle click
    $('#3d-graph').mousedown( function(e) {
        e.preventDefault();        
       
        /////////////////////////////////////////////////////////
        // MIDDLE MOUSE ROTATE
        if ( e.which == 1 ) {
            var startX = (e.screenX + 100 * PHI);
            var startY = e.screenY + 100 * THETA;
            
            $('html').mousemove( function(e) {
                var newPhi   = (-e.screenX + startX) / 100.0;
                var newTheta = (-e.screenY + startY) / 100.0;
                
                if (newTheta > Math.PI || newTheta < 0.0 ) { 
                    newTheta = THETA;
                }
                
                RZ( newPhi );
                updateRX( newTheta );
                updateLines();
                updateDots();
            });
        }
    });
    
    //mouse up, so stop moving or rotating
    $('html').mouseup( function( e ) {
        $('html').unbind('mousemove');
        
        if ( typeof sendPosInterval !== 'undefined' ) {
            window.clearInterval(sendPosInterval);
        }
        if ( typeof sendPosInterval !== 'undefined' ) {
            window.clearInterval(inputInterval);
        }
        
    });
    
    
    //add lines to the graph
    origin = new Point(0,0,0);
    x = new Point(middleX,0,0);
    y = new Point(0,middleX,0);
    var z = new Point(0,0,middleX);

    var nx = new Point(-middleX,0,0);
    var ny = new Point(0,-middleX,0);
    var nz = new Point(0,0,-middleX);
    
    var xAxis = new Line( origin, x, '#axis-x' );
    var yAxis = new Line( origin, y, '#axis-y' );
    var zAxis = new Line( origin, z, '#axis-z' );
    
    var nxAxis = new Line( origin, nx, '#neg-axis-x' );
    var nyAxis = new Line( origin, ny, '#neg-axis-y' );
    var nzAxis = new Line( origin, nz, '#neg-axis-z' );
	
	//add the lines to an array so they can all be updated at once on refresh
    lines.push( xAxis );
    lines.push( yAxis );
    lines.push( zAxis );
    
    lines.push( nxAxis );
    lines.push( nyAxis );
    lines.push( nzAxis );
    
    var p1 = new Point(tx/zoomRatio, ty/zoomRatio,tz/zoomRatio2);
    var p2 = new Point(tx2/zoomRatio, ty2/zoomRatio, tz2/zoomRatio2);
    var p3 = new Point(tx3/zoomRatio, ty3/zoomRatio,tz3/zoomRatio2);
    var p4 = new Point(tx4/zoomRatio, ty4/zoomRatio,tz4/zoomRatio2);
    var p5 = new Point(tx5/zoomRatio, ty5/zoomRatio,tz5/zoomRatio2);


    
    var l0 = new Line( origin, p1 ,'#ligacao');
    var l1 = new Line( p1, p2 ,'#ligacao1');
    var l2 = new Line( p2, p3 ,'#ligacao2');
    var l3 = new Line( p3, p4 ,'#ligacao3'); 
    var l4 = new Line( p4, p5 ,'#ligacao4');    

    lines.push(l0);
    lines.push(l1);
    lines.push(l2);
    lines.push(l3);
    lines.push(l4);

    // add the dots to the graph
    origem = new Dot ('graph-dot-0', 0, 0, 0);
    ponto1 = new Dot ('graph-dot-1', tx, ty, tz);
    ponto2 = new Dot ('graph-dot-2', tx2, ty2, tz2);
    ponto3 = new Dot ('graph-dot-3', tx3, ty3, tz3);
    ponto4 = new Dot ('graph-dot-4', tx4, ty4, tz4);
    ponto5 = new Dot ('graph-dot-5', tx5, ty5, tz5);
    
    dots.push(origem);
    dots.push(ponto1);
    dots.push(ponto2);
    dots.push(ponto3);
    dots.push(ponto4);
    dots.push(ponto5);

    
});


</script>

<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='320' width='352' id='3d-graph' style='height: 320px; width:342px; margin: 0 auto; padding: 5px;' >
    <!-- neg axis -->
    <line x1='100' y1='250' x2='400' y2='250' id='neg-axis-x' style='stroke:rgba(250,200,200,0.5);stroke-width:2'/>
    <line x1='100' y1='250' x2='100' y2='0'   id='neg-axis-y' style='stroke:rgba(200,250,200,0.5);stroke-width:2'/>
    <line x1='100' y1='250' x2='0' y2='400'   id='neg-axis-z' style='stroke:rgba(200,200,250,0.5);stroke-width:2'/>
    <!-- axis -->
    <line x1='100' y1='250' x2='400' y2='250' id='axis-x' style='stroke:rgb(200,0,0);stroke-width:2'/>
    <line x1='100' y1='250' x2='100' y2='0'   id='axis-y' style='stroke:rgb(0,200,0);stroke-width:2'/>
    <line x1='100' y1='250' x2='0' y2='400'   id='axis-z' style='stroke:rgb(0,0,200);stroke-width:2'/>

    <line x1='100' y1='250' x2='0' y2='400'   id='ligacao' style='stroke:rgb(0,0,0);stroke-width:2'/>                                               <line x1='100' y1='250' x2='0' y2='400'   id='ligacao1' style='stroke:rgb(0,0,0);stroke-width:2'/>                                              <line x1='100' y1='250' x2='0' y2='400'   id='ligacao2' style='stroke:rgb(0,0,0);stroke-width:2'/>                                              <line x1='100' y1='250' x2='0' y2='400'   id='ligacao3' style='stroke:rgb(0,0,0);stroke-width:2'/>                                              <line x1='100' y1='250' x2='0' y2='400'   id='ligacao4' style='stroke:rgb(0,0,0);stroke-width:2'/>
</svg>
			    
</body>
</html>"
))
