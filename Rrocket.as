class Rrocket extends MovieClip {
	
	public var used = 0;
	public var over = 0;
	
	public function onRollOver() {
		over = 1;
		if (this.used == 0) {
			this.gotoAndPlay(2);
		}
	}
	public function onRollOut() {
		over = 0;
		if (this.used == 0) {
			this.gotoAndPlay(1);
		}
	}
	
	public function onMouseUp() {
		if (this.used == 0 and over == 1) {
			this.used = 1;
			this.gotoAndPlay(3);
			trace(this);
			_root.satellite1.pullBack(5);
		}
	}
}