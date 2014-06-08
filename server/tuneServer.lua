-- TunedVehicles by ING

class 'TunedVehicles'

function TunedVehicles:__init(library, presets, interval)
	self.library  = library or {}
	self.presets  = presets or "Default"
	
	self.interval = 1000 / (interval or 30)
	self.active   = {}
	self.sub      = nil
	
	self.timer    = Timer()
	self.time     = 0
	self.timing   = self.interval / 1000
	
	Network:Subscribe("TuneStart", self, self.StartTune)
	Network:Subscribe("TuneStop", self, self.StopTune)
	Events:Subscribe("PlayerJoin", self, self.PlayerJoin)
	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
	
	Events:Subscribe("ChangeTunePresets", self, self.SetPresets)
end

-- #################################################################################################################################

function TunedVehicles:SetPresets(args)
	self.presets = args or "Default"
	Network:Broadcast("TunePresets", args)
end

function TunedVehicles:StartTune(args, player)
	self:AddTune(player, args)
end

function TunedVehicles:StopTune(args, player)
	self:RemoveTune(player)
end

function TunedVehicles:PlayerJoin(args)
	Network:Send(args.player, "TunePresets", self.presets)
end

function TunedVehicles:PlayerQuit(args)
	self:RemoveTune(args.player)
end

-- #################################################################################################################################

function TunedVehicles:AddTune(player, args)
	self.active[player:GetId()] = {vehicle = player:GetVehicle(), presets = self.library[args.presets], up = args.trigger}
	if not self.sub and table.count(self.active) > 0 then
		self.sub  = Events:Subscribe("PreTick", self, self.Ticker)
	end
end

function TunedVehicles:RemoveTune(player)
	self.active[player:GetId()] = nil
	if self.sub and table.count(self.active) == 0 then
		Events:Unsubscribe(self.sub)
		self.sub = nil
	end
end

-- #################################################################################################################################

function TunedVehicles:Ticker()
	if self.timer:GetMilliseconds() > self.time then
		for playerID, data in pairs(self.active) do
			if IsValid(data.vehicle) then
				model      = data.vehicle:GetModelId()
				physics    = data.presets[model][model]
				velocity   = -data.vehicle:GetAngle() * data.vehicle:GetLinearVelocity()
				velocity.z = velocity.z - self.timing * (data.up and physics.ACC or -physics.DEC)
				if data.up and physics.MAX then 
					velocity.z = math.max(velocity.z, -physics.MAX)
				elseif not data.up and physics.MIN then 
					velocity.z = math.min(velocity.z, -physics.MIN)
				end
				data.vehicle:SetLinearVelocity(data.vehicle:GetAngle() * velocity)
			else
				self:RemovePlayer(Player.GetById(playerID))
			end
		end
		self.time = self.timer:GetMilliseconds() + self.interval
	end
end

-- #################################################################################################################################

tunedVehicles = TunedVehicles(TunesLibrary, "Demo")
