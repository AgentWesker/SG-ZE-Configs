//logicToggle <- 1;
targetToggle <- 2;
killSwitch <- 0;
unstuckSwitch <- 1;
entPlayer <- null;
entTarget <- null;
msg <- null
stopTouchForward <- 0;


//ShowMsg(activator,"<font color='#FFFF00'>这是一条红色的消息");
function ShowMsg(player, message)
{
	if(msg == null)	
		msg <- Entities.CreateByClassname("env_hudhint");	
	msg.__KeyValueFromString("message", message);
	msg.SetOwner(player);
	EntFireByHandle(msg, "ShowHudHint", "", 0, player, player);
}

function TargetPlayer() {
	local ValidPlayer = false;
	local ValidPlayerLoop = 0;
	while (ValidPlayer == false) {
		while((entPlayer = Entities.FindByClassname(entPlayer, "player")) != null)
		{
			if (IsPlayerHuman(entPlayer)) {
				ValidPlayer = true;
				break;
			}
		}
		if (ValidPlayerLoop > 1) {
			entPlayer = null;
			break;
		}
		ValidPlayerLoop++;
	}
	return entPlayer;
}

function SetTargeting(num) {
	targetToggle = num;
}

function SetKillSwitch(num) {
	killSwitch = num;
}

function InformNewTarget() {
	ShowMsg(entTarget, "Safe! For now...");
}

function BossTarget() {
	if (killSwitch == 1) {
		//MedusaThrusters(3, 0); //Off thrusters
		return;
	}
	if (targetToggle == 2) { //Select a target
		//entTarget = TargetPlayer();
		entTarget = Entities.FindByName(null, "boss");
		if (IsPlayerHuman(entTarget)) {
			targetToggle = 1; //Valid player found, continue to targeting
			//ScriptPrintMessageCenterTeam(3, "Don't Look!");
			ShowMsg(entTarget, "Don't Look! She's after you!");
			EntFireByHandle(self, "RunScriptCode", "BossTarget();", 0.5, null, null);
			//MedusaThrusters(4, 0); //Unstuck
			//EntFireByHandle(self, "RunScriptCode", "SetTargeting(3);", 16.0, null, null);
			return;
		}
		//ScriptPrintMessageCenterTeam(3, "Where are you...");
		EntFireByHandle(self, "RunScriptCode", "BossTarget();", 0.1, null, null);
	} else if (targetToggle == 1) {
		bossPos <- Vector(0.0, 0.0, 0.0);
		bossPos = self.GetOrigin();

		if (IsPlayerHuman(entTarget)) {
			self.EmitSound("c4.click");
			playerPos <- Vector(0.0, 0.0, 0.0);
			playerPos = entTarget.GetOrigin();
			
			local bossAng = self.GetForwardVector();
			bossAng.Norm();
			bossAng.x *= 10;
			bossAng.y *= 10;
			bossAng.z *= 10;
			local bossPos2 = AddVectors(bossPos, bossAng);
			
			local tYaw = GetTargetYaw(bossPos,playerPos); //Yaw to target
			local cYaw = GetTargetYaw(bossPos,bossPos2); //Yaw Origin
			local yaw = (cYaw - tYaw);
			
			bossAng.z = 15;
			
			if (abs(yaw) > 180.0) {
				if (yaw < 0) {
					yaw = (360 - abs(yaw));
				} else if (yaw > 0) {
					yaw = ((360 - abs(yaw))*-1);
				}
			}

			local vecToTarget = MakeVectorFromPoints(playerPos, bossPos);
			vecToTarget.Norm();
			vecToTarget.z = 0.0;
			
			//if (yaw < 0.0) {
			//	MedusaThrusters(1, 1, 0); //Left
			//	MedusaThrusters(1, 0, 0); //Forward
			//	if (CheckStopped(self.GetVelocity())) {
			//		if (unstuckSwitch == 1) {
			//			self.SetForwardVector(vecToTarget);
			//			unstuckSwitch = 0;
			//			EntFireByHandle(self, "RunScriptCode", "SetUnstuckSwitch(1);", 6.0, null, null);
			//		}
			//	}
			//} else if (yaw >= 0.0) {
			//	MedusaThrusters(1, 2, 0); //Right
			//	MedusaThrusters(1, 0, 0); //Forward
			//	if (CheckStopped(self.GetVelocity())) {
			//		if (unstuckSwitch == 1) {
			//			self.SetForwardVector(vecToTarget);
			//			unstuckSwitch = 0;
			//			EntFireByHandle(self, "RunScriptCode", "SetUnstuckSwitch(1);", 6.0, null, null);
			//		}
			//	}
			//}
			
			if (yaw < 40.0 && yaw > -40.0) {
				//Don't turn
				//MedusaThrusters(1, 0, 0); //Forward
				//if (CheckStopped(self.GetVelocity())) {
				//self.__KeyValueFromVector("basevelocity", ScaleVector(vecToTarget, 5000));
				//}
				EntFire("mboss_Thrust_Forward", "Activate", "", 0.0);
				EntFire("mboss_Thrust_Forward", "Deactivate", "", 0.1);
				//ScriptPrintMessageChatAll("thrusting");
				//ShowMsg(entTarget, "Don't Look! She's after you!");
				if (yaw < 16.0 && yaw > -16.0) {
					EntFire("mboss_CyTrLeft", "Disable", "", 0.0);
					EntFire("mboss_CyTrLeftB", "Disable", "", 0.0);
					EntFire("mboss_CYTrRight", "Disable", "", 0.0);
					EntFire("mboss_CyTrRightB", "Disable", "", 0.0);
					stopTouchForward = 1;
				} else if (stopTouchForward == 1) {
					EntFire("mboss_CyTrLeft", "Enable", "", 0.0);
					EntFire("mboss_CyTrLeftB", "Enable", "", 0.0);
					EntFire("mboss_CYTrRight", "Enable", "", 0.0);
					EntFire("mboss_CyTrRightB", "Enable", "", 0.0);
					stopTouchForward = 0;
				}
				EntFireByHandle(self, "RunScriptCode", "BossTarget();", 0.25, null, null);
				return;
			}

			//self.SetAngularVelocity(0.0, yaw, 0.0);
			//self.__KeyValueFromVector("basevelocity", bossAng);
			
			EntFireByHandle(self, "RunScriptCode", "BossTarget();", 0.1, null, null);
		} else {
			//Target is dead / disconnected / zombified
			//local stopVec = Vector(0.0, 0.0, 0.0);
			//self.SetAngularVelocity(0.0, 0.0, 0.0);
			//self.__KeyValueFromVector("basevelocity", stopVec);
			//MedusaThrusters(3, 0, 0); //Off thrusters
			targetToggle = 2;
			EntFireByHandle(self, "RunScriptCode", "BossTarget();", 0.1, null, null);
		}
	} else if (targetToggle == 3) {
		//Targeting has been disabled by something
		//local stopVec = Vector(0.0, 0.0, 0.0);
		//self.SetAngularVelocity(0.0, 0.0, 0.0);
		//self.__KeyValueFromVector("basevelocity", stopVec);
		//MedusaThrusters(3, 0, 0); //Off thrusters
		targetToggle = 2;
		EntFireByHandle(self, "RunScriptCode", "BossTarget();", 3.0, null, null);
	}
}

function SetUnstuckSwitch(num) {
	unstuckSwitch = num;
}

function CheckStopped(vel) {
	if (vel.x == 0.0 && vel.y == 0.0) {
		//ScriptPrintMessageChatAll("stopped...");
		return true;
	} else {
		return false;
	}
}

function MedusaThrusters(choice, thruster, yaw) {
	if (choice == 0) { //Deactivate
		if (thruster == 0) { //Forward
			EntFire("mboss_t_f", "Deactivate", "", 0.2);
		} else if (thruster == 1) { //Left
			EntFire("mboss_t_l", "Deactivate", "", 0.2);
		} else if (thruster == 2) { //Right
			EntFire("mboss_t_r", "Deactivate", "", 0.2);
		}
	} else if (choice == 1) { //Activate
		if (thruster == 0) { //Forward
			EntFire("mboss_t_f", "Activate", "", 0.1);
			EntFire("mboss_t_f", "Deactivate", "", 0.2);
		} else if (thruster == 1) { //Left
			self.SetAngularVelocity(0.0, 0.0, 0.0);
			EntFire("mboss_t_l", "Activate", "", 0.1);
			EntFire("mboss_t_r", "Deactivate", "", 0.1);
			EntFire("mboss_t_l", "Deactivate", "", 0.2);
		} else if (thruster == 2) { //Right
			self.SetAngularVelocity(0.0, 0.0, 0.0);
			EntFire("mboss_t_r", "Activate", "", 0.1);
			EntFire("mboss_t_l", "Deactivate", "", 0.1);
			EntFire("mboss_t_r", "Deactivate", "", 0.2);
		}
	} else if (choice == 3) { //disable all
		EntFire("phys_thruster", "Deactivate", "", 0.1);
	} else if (choice == 4) { //disable all
		EntFire("mboss_t_r", "scale", "30", 0.1);
		EntFire("mboss_t_r", "scale", "1", 0.25);
	} else if (choice == 5) { //Scale
		local fYaw = 0.0;
		fYaw = (abs(yaw) * 0.1)*1.5;
		if (thruster == 0) { //Forward
			self.SetAngularVelocity(0.0, 0.0, 0.0);
			EntFire("mboss_t_f", "AddOutput", "force " + 2000, 0.1);
			EntFire("mboss_t_f", "AddOutput", "force " + 635, 0.3);
		} else if (thruster == 1) { //Left
			self.SetAngularVelocity(0.0, 0.0, 0.0);
			EntFire("mboss_t_l", "AddOutput", "force " + 100*fYaw, 0.1);
			EntFire("mboss_t_l", "AddOutput", "force " + 100, 0.2);
		} else if (thruster == 2) { //Right
			self.SetAngularVelocity(0.0, 0.0, 0.0);
			EntFire("mboss_t_r", "AddOutput", "force " + 100*fYaw, 0.1);
			EntFire("mboss_t_r", "AddOutput", "force " + 100, 0.2);
		}
	}
}

function IsPlayerHuman(entHandle) {
	if (entHandle && entHandle.IsValid()) {
		if (entHandle.GetClassname() == "player") {
			if ((entHandle.GetTeam() == 3) && (entHandle.GetHealth() > 0)) {
				return true;
			}
		}
	}
	return false;
}

function GetTargetYaw(start, target)
{
	local yaw = 0.00;
	local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl = sqrt(v.x*v.x+v.y*v.y);
	yaw = 180*acos(v.x/vl)/3.14159;
	yaw -= 180;
	if (v.y < 0) {
		yaw=-yaw;
	}
	return yaw;
}

function ScaleVector(vec, scale) {
	local scaleVec = Vector(vec.x * scale, vec.y * scale, vec.z * scale);
	return scaleVec;
}

function AddVectors(vecA, vecB) {
	local newVec = Vector(vecA.x + vecB.x, vecA.y + vecB.y, vecA.z + vecB.z);
	return newVec;
}

function MakeVectorFromPoints(vecA, vecB) {
	local vecDir = Vector(vecA.x - vecB.x, vecA.y - vecB.y, vecA.z - vecB.z);
	return vecDir;
}