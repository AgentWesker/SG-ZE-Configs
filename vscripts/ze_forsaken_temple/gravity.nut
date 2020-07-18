self.ConnectOutput("OnUser1", "SetOwner");
self.ConnectOutput("OnUser2", "InitGravity");

const PUSH_SCALE = 650.0;

playerOwner <- null;

function SetOwner() {
	if (activator && activator.IsValid()) {
		if (activator.GetClassname() == "player") {
			playerOwner = activator;
		}
	}
}

gravPoint <- null;
gravOrigin <- Vector(0.0, 0.0, 0.0);
lToggle <- 0;

pTable <- {};

function InitGravity() {
	gravPoint = Entities.FindByName(null, "item_gravity_teleport");

	if (gravPoint == null)
		return;
	
	lToggle = 1;
	
	gravOrigin = gravPoint.GetOrigin();
	EntFireByHandle(self, "RunScriptCode", "RunGravity();", 0.0, null, null);
	EntFireByHandle(self, "RunScriptCode", "ClearGravity();", 6.0, null, null);
}

function ClearGravity() {
	lToggle = 0;
	EntFireByHandle(self, "RunScriptCode", "SpeedUp();", 0.1, null, null);
}

function SpeedUp()
{	
	foreach(ent in pTable)
	{
		ent.__KeyValueFromVector("basevelocity", Vector(0.0, 0.0, -9999.0));
		ent.SetVelocity(Vector(0.0, 0.0, -9999.0));
		DoEntFire("speed", "modifyspeed", "1.0", 0.0, ent, ent);
	}
	pTable.clear();
}

function RunGravity() {
	if (lToggle != 1)
		return;
	
	local ent = null;
	while ((ent = Entities.FindByClassnameWithin(ent, "player", gravOrigin, 1000.0)) != null)
	{
		if (!ent.IsValid())
			continue;
		
		if (ent.GetTeam() != 2)
			continue;
		
		local a = ent.GetOrigin();
		local dir = MakeVectorFromPoints(gravOrigin, a);
		
		if (dir.Length() <= 85.0)
		{
			//ScriptPrintMessageChatAll("Entity Index: " + ent.entindex());
			DoEntFire("speed", "modifyspeed", "0.05", 0.0, ent, ent);
		
			if (!pTable.rawin(ent))
			{
				pTable.rawset(ent, ent);
			}
			continue;
		}
		dir.Norm();
		local vel = Vector(PUSH_SCALE * dir.x, PUSH_SCALE * dir.y, PUSH_SCALE * dir.z);
		ent.__KeyValueFromVector("basevelocity", vel);
	}
	EntFireByHandle(self, "RunScriptCode", "RunGravity();", 0.05, null, null);
}

//Stock - Make a directional vector
function MakeVectorFromPoints(vecA, vecB) {
	local vecDir = Vector(vecA.x - vecB.x, vecA.y - vecB.y, vecA.z - vecB.z);
	return vecDir;
}