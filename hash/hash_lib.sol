libary HashFun {
	function generateHash() {
		bytes memory msg = abi.encodePacked(address(this));
	}
}