level <- 0;
twist <- 0;

function SetLevel(num) {
    level = num;
}

function SetTwist(num) {
    twist = num;
}

function GetLevel() {
	if (twist == 0) {
		EntFire("TwistSelect", "Kill", "", 0.0);
	}
	
    if (level == 0) {
		EntFire("server_map", "Command", "say **Stage 1: Helicopter Escape**", 5.0);
		EntFire("EndSelect", "InValue", "2", 0.0);
    } else if (level == 1) {
        EntFire("server_map", "Command", "say **Stage 2: Bunker Escape**", 5.0);
		EntFire("EndSelect", "InValue", "1", 0.0);
    } else if (level == 2) {
        EntFire("server_map", "Command", "say **Stage 3: Caves Escape**", 5.0);
		EntFire("EndSelect", "InValue", "3", 0.0);
    } else if (level == 3) {
        EntFire("server_map", "Command", "say **Stage 4: Sewer Escape**", 5.0);
		EntFire("EndSelect", "InValue", "4", 0.0);
    } else if (level == 4) {
        EntFire("server_map", "Command", "say **Stage 5: ZM**", 5.0);
		EntFire("EndSelect", "InValue", "5", 0.0);
    } else if (level == 5) {
        EntFire("server_map", "Command", "say **Random Stage with a Twist**", 5.0);
		EntFire("EndSelect", "PickRandom", "", 0.0);
		EntFire("TwistSelect", "PickRandomShuffle", "", 0.0);
    }
}