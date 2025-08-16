-- 🌱 Egg Randomizer – made by ScripterX 🌱
-- Compact GUI with Egg Selector, Randomizer, Auto Ager

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clean up if already exists
if playerGui:FindFirstChild("PetRandomizerGui") then
	playerGui.PetRandomizerGui:Destroy()
end

-- 📌 Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PetRandomizerGui"
ScreenGui.Parent = playerGui

-- 📌 Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 150)
Frame.Position = UDim2.new(0.5, -110, 0.4, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true -- draggable

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "Egg Randomizer - by ScripterX"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundColor3 = Color3.fromRGB(40,40,40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

-- Buttons
local EggBtn = Instance.new("TextButton")
EggBtn.Size = UDim2.new(0.9, 0, 0, 25)
EggBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
EggBtn.Text = "Choose Egg: Common Egg"
EggBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
EggBtn.TextColor3 = Color3.fromRGB(255,255,255)
EggBtn.Font = Enum.Font.Gotham
EggBtn.TextSize = 14
EggBtn.Parent = Frame

local HatchBtn = Instance.new("TextButton")
HatchBtn.Size = UDim2.new(0.9, 0, 0, 25)
HatchBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
HatchBtn.Text = "Randomize Hatch"
HatchBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
HatchBtn.TextColor3 = Color3.fromRGB(255,255,255)
HatchBtn.Font = Enum.Font.GothamBold
HatchBtn.TextSize = 14
HatchBtn.Parent = Frame

local AutoAgerBtn = Instance.new("TextButton")
AutoAgerBtn.Size = UDim2.new(0.9, 0, 0, 25)
AutoAgerBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
AutoAgerBtn.Text = "Auto Ager: OFF"
AutoAgerBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
AutoAgerBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoAgerBtn.Font = Enum.Font.Gotham
AutoAgerBtn.TextSize = 14
AutoAgerBtn.Parent = Frame

-- 📌 Eggs + Pets
local Pets = {
	["Common Egg"] = {"Dog","Golden Lab","Bunny"},
	["Bug Egg"] = {"Caterpillar","Snail","Giant Ant","Praying Mantis","Dragonfly"},
	["Common Summer Egg"] = {"Starfish","Seagull","Crab"},
	["Rare Summer Egg"] = {"Flamingo","Toucan","Sea Turtle","Orangutan","Seal"},
	["Paradise Egg"] = {"Ostrich","Peacock","Capybara","Mimic Octopus"},
	["Mythical Egg"] = {"Grey Mouse","Brown Mouse","Squirrel","Red Giant Ant","Red Fox"},
	["Gourmet Egg"] = {"Bagel Bunny","Pancake Mole","Sushi Bear","Spaghetti Sloth","French Fry Ferret"},
	["Sprout Egg"] = {"Dairy Cow","Jackalope","Sapling","Golem","Golden Goose"},
	["Anti Bee Egg"] = {"Wasp","Tarantula Hawk","Moth","Butterfly","Disco Bee"},
	["Bee Egg"] = {"Bee","Honey Bee","Bear Bee","Petal Bee","Queen Bee"},
	["Night Egg"] = {"Hedgehog","Mole","Frog","Echo Frog","Night Owl","Raccoon"},
	["Primal Egg"] = {"Parasaurolophus","Iguanodon","Pachycephalosaurus","Dilophosaurus","Ankylosaurus","Spinosaurus"},
	["Dinosaur Egg"] = {"T-Rex","Brontosaurus","Pterodactyl","Raptor","Stegosaurus"},
	["Zen Egg"] = {"Kitsune","Kodama","Nihonzaru","Shiba Inu","Tanchozuru","Raiju","Kappa","Red Fox"}
}

-- Egg selection cycling
local eggNames = {}
for eggName,_ in pairs(Pets) do
	table.insert(eggNames, eggName)
end
table.sort(eggNames)

local currentEggIndex = 1
local currentEgg = eggNames[currentEggIndex]

EggBtn.MouseButton1Click:Connect(function()
	currentEggIndex = currentEggIndex + 1
	if currentEggIndex > #eggNames then currentEggIndex = 1 end
	currentEgg = eggNames[currentEggIndex]
	EggBtn.Text = "Choose Egg: " .. currentEgg
end)

-- Function: Billboard result above egg
local function showResultAboveEgg(petName)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Find nearest "Egg" part in workspace
	local closest, dist = nil, math.huge
	for _,obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
			local d = (obj.Position - root.Position).magnitude
			if d < dist and d < 30 then
				closest, dist = obj, d
			end
		end
	end

	if closest then
		-- BillboardGui
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.Adornee = closest
		billboard.AlwaysOnTop = true
		billboard.StudsOffset = Vector3.new(0,3,0)
		billboard.Parent = closest

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,1,0)
		label.BackgroundTransparency = 1
		label.Text = "🎉 You got: " .. petName .. "!"
		label.TextColor3 = Color3.fromRGB(0,255,0)
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = billboard

		game.Debris:AddItem(billboard, 5) -- auto remove after 5 sec
	end
end

-- Hatch randomizer
HatchBtn.MouseButton1Click:Connect(function()
	local pool = Pets[currentEgg]
	if pool then
		local pet = pool[math.random(1, #pool)]
		showResultAboveEgg(pet)
	end
end)

-- Auto Ager system
local autoAgerOn = false
local chosenAge = 1

AutoAgerBtn.MouseButton1Click:Connect(function()
	if not autoAgerOn then
		autoAgerOn = true
		chosenAge = math.random(1,100) -- can be customized to a UI picker
		AutoAgerBtn.Text = "Auto Ager: ON ("..chosenAge..")"
	else
		autoAgerOn = false
		AutoAgerBtn.Text = "Auto Ager: OFF"
	end
end)
-- Result Label
local Result = Instance.new("TextLabel")
Result.Size = UDim2.new(1, 0, 0, 50)
Result.Position = UDim2.new(0,0,0.65,0)
Result.Text = "Waiting for Egg..."
Result.TextColor3 = Color3.fromRGB(200,200,200)
Result.Font = Enum.Font.GothamBold
Result.BackgroundTransparency = 1
Result.TextScaled = true
Result.Parent = Frame

-- 🐾 Egg → Pet Data
local Pets = {
	["Anti Bee Egg"] = {"Butterfly", "Disco Bee"},
	["Bug Egg"] = {"Dragonfly"},
	["Paradise Egg"] = {"Mimic Octopus"},
	["Mythical Egg"] = {"Red Fox"},
	["Gourmet Egg"] = {"Lobster"},
	["Bee Egg"] = {"Queen Bee"}
}

-- 🎲 Function to Hatch Egg
local function hatchEgg(eggType)
	if Pets[eggType] then
		local choices = Pets[eggType]
		local petName = choices[math.random(1, #choices)]

		-- Update GUI
		Result.Text = "YOU GOT: " .. petName .. "!!!"
		Result.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		Result.Text = "Unknown Egg..."
		Result.TextColor3 = Color3.fromRGB(255, 0, 0)
	end
end

-- 📌 Example: Always hatches "Anti Bee Egg"
HatchBtn.MouseButton1Click:Connect(function()
	hatchEgg("Anti Bee Egg") -- change "Anti Bee Egg" to test other eggs
end)
