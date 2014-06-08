-- TunedVehicles by ING

class 'TunedVehicles'

function TunedVehicles:__init(library, presets)
	self.library = library or {}
	self.presets = presets or "Default"
	
	self.active  = false
	self.sub     = nil
	self.type    = nil
	self.model   = nil
	
	Network:Subscribe("ChangeTunePresets", self, self.SetPresets)
	Events:Subscribe("ChangeTunePresets", self, self.SetPresets)
	
	Events:Subscribe("LocalPlayerEnterVehicle", self, self.EnterVehicle)
	Events:Subscribe("LocalPlayerExitVehicle", self, self.ExitVehicle)
end

function TunedVehicles:SetPresets(args)
	--Chat:Print("set client presets: " .. args, Color(255,255,255))
	self.presets = args or "Default"
end

-- #################################################################################################################################

function TunedVehicles:EnterVehicle(args)
	self.model = args.vehicle:GetModelId()
	self.type  = self.library[self.presets][self.model]
	if self.type and self.type[self.model] then
		self.sub = self.sub or Events:Subscribe("Render", self, self.Render)
	end
end

function TunedVehicles:ExitVehicle(args)
	if self.active then
		Network:Send("TuneStop")
		self.active = false
	end
	if self.sub then
		Events:Unsubscribe(self.sub)
		self.sub = nil
	end
end

-- #################################################################################################################################

function TunedVehicles:Render()
	vehicle = LocalPlayer:GetVehicle()
	if vehicle then
		if Input:GetValue(self.type.KEY) > 0 then
			velocity = (-vehicle:GetAngle() * -vehicle:GetLinearVelocity()).z
			if not self.active then
				if self.type[self.model].UP and velocity > self.type[self.model].UP then
					Network:Send("TuneStart", {presets = self.presets, trigger = true})
					self.active = true
				elseif self.type[self.model].DOWN and velocity < self.type[self.model].DOWN then
					Network:Send("TuneStart", {presets = self.presets})
					self.active = true
				end
			end
		else
			if self.active then
				Network:Send("TuneStop")
				self.active = false
			end
		end
	end
end

-- #################################################################################################################################

tunedVehicles = TunedVehicles(TunesLibrary)
