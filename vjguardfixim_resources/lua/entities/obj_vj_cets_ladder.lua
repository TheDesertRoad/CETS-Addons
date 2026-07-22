if (SERVER) then
	AddCSLuaFile();
end;
---------------------------------------------------------------------------------------------------------------------------------------------
DEFINE_BASECLASS("base_entity");
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.PrintName		= "Ladder (BASE)";
ENT.Category		= "Ladders";
ENT.Spawnable		= false;
ENT.AdminOnly		= false;
ENT.Model			= Model("models/props_c17/metalladder001.mdl");
ENT.RenderGroup 	= RENDERGROUP_BOTH;
---------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
	function ENT:Initialize()
		self:SetModel(self.Model);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetNoDraw(true);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
		local phys = self:GetPhysicsObject();

		if (IsValid(phys)) then
			phys:EnableMotion(false);
		end;

		self:UpdateLadder(true);
	end;
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateLadder(bCreate)
	if bCreate then
		for _, v in ipairs(self:GetChildren()) do
			SafeRemoveEntity(v)
		end

		local mins = self:OBBMins()
		local maxs = self:OBBMaxs()
		local dist = maxs.x + 17
		local dismountDist = maxs.x + 49
		local bottom = self:LocalToWorld(Vector(0, 0, mins.z))
		local top = self:LocalToWorld(Vector(0, 0, maxs.z))
		local forward = self:GetForward()

		self.ladder = ents.Create("func_useableladder")
		self.ladder:SetPos(self:LocalToWorld(Vector(dist, 0, 0)))
		self.ladder:SetAngles(self:GetAngles())
		self.ladder:SetKeyValue("point0", tostring(bottom + forward * dist))
		self.ladder:SetKeyValue("point1", tostring(top + forward * dist))
		self.ladder:SetKeyValue("targetname", "zladder_" .. self:EntIndex())
		self.ladder:SetParent(self)
		self.ladder:Spawn()

		self.bottomDismount = ents.Create("info_ladder_dismount")
		self.bottomDismount:SetPos(bottom + forward * dismountDist)
		self.bottomDismount:SetAngles(self:GetAngles())
		self.bottomDismount:SetKeyValue("laddername", "zladder_" .. self:EntIndex())
		self.bottomDismount:SetParent(self)
		self.bottomDismount:Spawn()

		self.topDismount = ents.Create("info_ladder_dismount")
		self.topDismount:SetPos(top - forward * dist)
		self.topDismount:SetAngles(self:GetAngles())
		self.topDismount:SetKeyValue("laddername", "zladder_" .. self:EntIndex())
		self.topDismount:SetParent(self)
		self.topDismount:Spawn()

		self.ladder:Activate()
	else
		if IsValid(self.ladder) then
			self.ladder:Activate()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Think()
		if (IsValid(self.ladder)) then
			self:UpdateLadder();
			self:NextThink(CurTime() + 1);
			return true;
		end;
	end;
---------------------------------------------------------------------------------------------------------------------------------------------
elseif (CLIENT) then
	function ENT:Initialize()
		self:SetSolid(SOLID_VPHYSICS);
	end;

	function ENT:Draw()
		self:DrawModel();
	end;
end;