self.ConnectOutput("OnUser1", "SetBelmont");

playerBelmont <- null;

function SetBelmont() {
	if (activator && activator.IsValid()) {
		if (activator.GetClassname() == "player") {
			playerBelmont = activator;
		}
	}
}

function HurtBelmont() {
	if (playerBelmont && playerBelmont.IsValid()) {
		if (playerBelmont.GetClassname() == "player") {
			//DoEntFire("wesker_hurt", "Hurt", "", 0.0, playerBelmont, playerBelmont);
			//playerBelmont.SetHealth(playerBelmont.GetHealth - 50);
			EntFireByHandle(playerBelmont, "SetHealth", "" + (playerBelmont.GetHealth() - 22), 0.0, null, null);
		}
	}
}