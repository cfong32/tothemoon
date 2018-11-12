class Satellite extends MovieClip {
	
	private var v_x = 0;
	private var v_y = 2.9;
	private var pre_x = 0;
	private var pre_y = 0;
	private var M = 10;
	
	public function onEnterFrame() {
		this.moveXY(v_x, v_y);
		this._rotation = this.direction()/Math.PI*180 - 180;
		//trace("dir " + this.direction()/Math.PI*180);
	}
	
	public function pushAhead(F) {
		this.gotoAndPlay(2);
		this.pushXY(F*Math.cos(this.direction()), F*Math.sin(this.direction()));
	}
	
	public function pullBack(F) {
		this.gotoAndPlay(21);
		this.pushXY(-F*Math.cos(this.direction()), -F*Math.sin(this.direction()));
	}
	
	public function pushXY(Fx, Fy) {
		trace("pushed = " + Fx + ", " + Fy);
		v_x += Fx / M;
		v_y += Fy / M;
	}
	
	public function direction():Number {
		if (this._x < this.pre_x) {
			return Math.atan((this._y - this.pre_y)/(this._x - this.pre_x)) + Math.PI;
		} else {
			return Math.atan((this._y - this.pre_y)/(this._x - this.pre_x));
		}
	}
	
	private function moveXY(valuex, valuey) {
		moveX(valuex);
		moveY(valuey);
	}
	
	private function moveX(value) {
		pre_x = this._x;
		this._x += value;
		/*
		this["tail5"]._x = this["tail4"]._x
		this["tail4"]._x = this["tail3"]._x
		this["tail3"]._x = this["tail2"]._x
		this["tail2"]._x = this["tail1"]._x
		this["tail1"]._x += value;
		*/
	}
	private function moveY(value) {
		pre_y = this._y;
		this._y += value;
		/*
		this["tail5"]._y = this["tail4"]._y
		this["tail4"]._y = this["tail3"]._y
		this["tail3"]._y = this["tail2"]._y
		this["tail2"]._y = this["tail1"]._y
		this["tail1"]._y += value;
		*/
	}

	
}

/*	public var firstFn:FnHolder;
	public var robot:Robot;
	
	private var currentFn:FnHolder;
	private var prevFn:FnHolder;
	private var running:Boolean;
	private var waiting:Boolean;
	private var iid;
	private var stack;
	
	public function Runner() {
		running = false;
		waiting = false;
		stack = [];
	}
	
	public function onPress() {
		if (validSyntax()) {                               //----------------------
			startToRun();
		}
		else {
			this.gotoAndPlay(2);
		}
		
	}
	
	public function startToRun() {
		prevFn = null;
		currentFn = firstFn;
		running = true;
		waiting = false;
		lockAllClips();
	}
	
	public function stopToRun() {
		running = false;
		waiting = false;
		unlockAllClips();
	}
	
	public function onEnterFrame() {
		if (currentFn == null) {
			prevFn.front.dimDown();
			stopToRun();
		}
		else if (running && !waiting) {
			//bright up currentFn
			prevFn.front.dimDown();	//trace(prevFn._name + ".dimDown()");
			currentFn.front.brightUp(); //trace(currentFn._name + ".brightUp()");
			
			//determine power level
			var mvalue:Number;
			switch (currentFn.modifier.front._name) {
				case "fn_Power1":
				case "fn_Power2":
				case "fn_Power3":
				case "fn_Power4":
				case "fn_Power5":
				case "fn_Value1":
				case "fn_Value2":
				case "fn_Value3":
				case "fn_Value4":
				case "fn_Value5":
					mvalue = currentFn.modifier.front._name.charCodeAt(currentFn.modifier.front._name.length-1) - 48;
					break;
				default:
			}
			
			//perform currentFn
			switch (currentFn.front._name) {
				case "fn_LampB":
					robot.lampB(mvalue);
					break;
				case "fn_MotorA_Fd":
					robot.motorARe(mvalue);
					break;
				case "fn_MotorA_Re":
					robot.motorAFd(mvalue);
					break;
				case "fn_MotorC_Fd":
					robot.motorCRe(mvalue);
					break;
				case "fn_MotorC_Re":
					robot.motorCFd(mvalue);
					break;
				case "fn_StopA":
					robot.stopA();
					break;
				case "fn_StopB":
					robot.stopB();
					break;
				case "fn_StopC":
					robot.stopC();
					break;
				case "fn_StopABC":
					robot.stopABC();
					break;
				case "fn_Wait_1s":
					waiting = true;
					iid = setInterval(this, "run", 1000);
					break;
				case "fn_Wait_2s":
					waiting = true;
					iid = setInterval(this, "run", 2000);
					break;
				case "fn_Wait_4s":
					waiting = true;
					iid = setInterval(this, "run", 4000);
					break;
				default:
			}
			
			//advance currentFn to next
			switch (currentFn.front._name) {
				case "fn_Loop_End":
					var poppedFn =  stack.pop();
					if (poppedFn != null) {	
						prevFn = currentFn;
						currentFn = poppedFn.next;
						break;
					}
					
				case "fn_Loop_Begin":
					if (mvalue == null) {mvalue = 2};
					for (var i = 1; i<mvalue; i++) {
						stack.push(currentFn);
					}
										
				default:
					//advance currentFn to next
					prevFn = currentFn;
					trace ("prevFn <= " + currentFn._name);
					trace ("currentFn <= " + currentFn.next._name);
					currentFn = currentFn.next;
			}
		}
	}

	private function validSyntax() : Boolean {
		var nOpenLoop : Number = 0;

		currentFn = firstFn;
		while (currentFn != null) {
			if (currentFn.front._name == "fn_Loop_Begin") {
				nOpenLoop++;
			}
			else if (currentFn.front._name == "fn_Loop_End") {
				nOpenLoop--;
			}
			currentFn = currentFn.next;
			
			if (nOpenLoop <0) { return false; }
		}
		
		if (nOpenLoop > 0) { return false; }
		else { return true; }
		
	}	

	public function lock() {
		this._alpha = 50;
	}
	
	public function unlock() {
		this._alpha = 100;
	}
	
	private function run() {
		trace("run");
		waiting = false;
		clearInterval(iid);
	}
	
	private function lockAllClips() {
		for (var i in _root) {
			_root[i].lock();
		}
	}
	
	private function unlockAllClips() {
		for (var i in _root) {
			_root[i].unlock();
		}
	}
}
*/