class Law extends MovieClip {
	
	private var G = 5000;
		var D:Number, A:Number, F:Number;
		var Fx:Number, Fy:Number;
	
	public function onEnterFrame() {
		D = dist(_root.satellite1, _root.earth1);
		//trace("sx = " + _root["satellite1"]._x);
		//D = Math.sqrt((_root.satellite1._x - _root.earth1._x)*(_root.satellite1._x - _root.earth1._x) + (_root.satellite1._y - _root.earth1._y)*(_root.satellite1._y - _root.earth1._y));
		A = angle(_root.satellite1, _root.earth1);
		F = -G / D / D;		
		Fx = ma2Fx(F,A);
		Fy = ma2Fy(F,A);
		trace("D=" + D + ", " + "A=" + A/Math.PI*180 + ", " + "F=" + F);
		trace("Fx=" + Fx + ", " + "Fy=" + Fy);
		_root.satellite1.pushXY(Fx,Fy);

		D = dist(_root.satellite1, _root.moon2);
		trace(_root.moon2);
		trace("moon - D=" + D + ", " + "A=" + A/Math.PI*180 + ", " + "F=" + F);
		trace("moon - Fx=" + Fx + ", " + "Fy=" + Fy);		
		A = angle(_root.satellite1, _root.moon2);
		F = -G/10 / D / D;		
		Fx = ma2Fx(F,A);
		Fy = ma2Fy(F,A);
		_root.satellite1.pushXY(Fx,Fy);
	}
	
	private function dist(obj1:MovieClip, obj2:MovieClip):Number {
		//trace("o1x " + obj1._x + " o2x " + obj2._x);
		return Math.sqrt((obj1._x - obj2._x)*(obj1._x - obj2._x) + (obj1._y - obj2._y)*(obj1._y - obj2._y));
	}

	private function angle(obj1:MovieClip, obj2:MovieClip):Number {
		if (obj1._x < obj2._x) {
			return Math.atan((obj1._y - obj2._y)/(obj1._x - obj2._x)) + Math.PI;
		} else {
			return Math.atan((obj1._y - obj2._y)/(obj1._x - obj2._x));
		}	
		
	}
	
	private function ma2Fx(mag,angle) {
		return (mag * Math.cos(angle));
	}
	private function ma2Fy(mag,angle) {
		return (mag * Math.sin(angle));
	}
}