self.ConnectOutput("OnUser1", "SetClient");
self.ConnectOutput("OnUser2", "UpdatePosition");
 
playerSlender <- null;

function SetClient() {
	if (activator && activator.IsValid()) {
		if (activator.GetClassname() == "player") {
			playerSlender = activator;
		}
	}
}

function UpdatePosition() {
	if (playerSlender && playerSlender.IsValid()) {
		if (playerSlender.GetClassname() == "player") {
			local origin = playerSlender.GetOrigin();
			local angles = playerSlender.GetForwardVector();
			self.SetOrigin(origin);
			self.SetForwardVector(angles);
			EntFireByHandle(self, "RunScriptCode", "UpdatePosition();", 0.02, null, null);
		}
	}
}