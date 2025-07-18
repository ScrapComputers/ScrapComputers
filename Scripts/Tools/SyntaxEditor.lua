dofile("$SURVIVAL_DATA/Scripts/util.lua")
dofile("$GAME_DATA/Scripts/game/AnimationUtil.lua")

---@class SyntaxEditorClass : ToolClass
SyntaxEditorClass = class()

-- Animations --
local renderables = {
    "$CONTENT_DATA/Animations/Char_Tools/Char_connecttool/char_connecttool.rend"
}

local renderablesTp = {
    "$CONTENT_DATA/Animations/Char_Male/Animations/char_male_tp_connecttool.rend",
    "$CONTENT_DATA/Animations/Char_Tools/Char_connecttool/char_connecttool_tp_animlist.rend"
}

local renderablesFp = {
    "$CONTENT_DATA/Animations/Char_Tools/Char_connecttool/char_connecttool_fp_animlist.rend"
}

sm.tool.preloadRenderables(renderables)
sm.tool.preloadRenderables(renderablesTp)
sm.tool.preloadRenderables(renderablesFp)

local currentRenderablesTp = {}
local currentRenderablesFp = {}

function SyntaxEditorClass:cl_loadAnimations()
    self.cl.tpAnimations = createTpAnimations(
        self.tool,
        {
            idle = { "connecttool_idle" },
            pickup = { "connecttool_pickup", { nextAnimation = "idle" } },
            putdown = { "connecttool_putdown" },
        }
    )
    local movementAnimations = {
        idle = "connecttool_idle",
        idleRelaxed = "connecttool_idle_relaxed",

        sprint = "connecttool_sprint",
        runFwd = "connecttool_run_fwd",
        runBwd = "connecttool_run_bwd",

        jump = "connecttool_jump",
        jumpUp = "connecttool_jump_up",
        jumpDown = "connecttool_jump_down",

        land = "connecttool_jump_land",
        landFwd = "connecttool_jump_land_fwd",
        landBwd = "connecttool_jump_land_bwd",

        crouchIdle = "connecttool_crouch_idle",
        crouchFwd = "connecttool_crouch_fwd",
        crouchBwd = "connecttool_crouch_bwd"
    }

    for name, animation in pairs(movementAnimations) do
        self.tool:setMovementAnimation(name, animation)
    end

    setTpAnimation(self.cl.tpAnimations, "idle", 5.0)

    if self.tool:isLocal() then
        self.cl.fpAnimations = createFpAnimations(
            self.tool,
            {
                equip = { "connecttool_pickup", { nextAnimation = "idle" } },
                unequip = { "connecttool_putdown" },

                idle = { "connecttool_idle", { looping = true } },
                idleFlip = { "connecttool_idle_flip", { nextAnimation = "idle", blendNext = 0.5 } },
                idleUse = { "connecttool_use_idle", { nextAnimation = "idle", blendNext = 0.5 } },

                sprintInto = { "connecttool_sprint_into", { nextAnimation = "sprintIdle", blendNext = 5.0 } },
                sprintExit = { "connecttool_sprint_exit", { nextAnimation = "idle", blendNext = 0 } },
                sprintIdle = { "connecttool_sprint_idle", { looping = true } },
            }
        )
    end
    self.blendTime = 0.2
end

function SyntaxEditorClass:cl_animateOnEquip()
    sm.audio.play("ConnectTool - Equip", self.tool:getPosition())
    self.cl.wantEquipped = true

    for key, value in pairs(renderablesTp) do
        table.insert(currentRenderablesTp, value)
    end

    for key, value in pairs(renderablesFp) do
        table.insert(currentRenderablesFp, value)
    end

    for key, value in pairs(renderables) do
        table.insert(currentRenderablesTp, value)
        table.insert(currentRenderablesFp, value)
    end

    self.tool:setTpRenderables(currentRenderablesTp)
    self:cl_loadAnimations()

    setTpAnimation( self.cl.tpAnimations, "pickup", 0.0001 )

    if self.tool:isLocal() then
		self.tool:setFpRenderables( currentRenderablesFp )
		swapFpAnimation( self.cl.fpAnimations, "unequip", "equip", 0.2 )
	end
end

function SyntaxEditorClass:cl_animateOnUnequip()
	sm.audio.play("ConnectTool - Unequip")
    self.cl.wantEquipped = false
	self.cl.equipped = false

	if sm.exists( self.tool ) then
		setTpAnimation( self.cl.tpAnimations, "putdown" )
		if self.tool:isLocal() then
			if self.cl.fpAnimations.currentAnimation ~= "unequip" then
				swapFpAnimation( self.cl.fpAnimations, "equip", "unequip", 0.2 )
			end
		end
	end
end

function SyntaxEditorClass:cl_onAnimUpdate(deltaTime)
	local isSprinting = self.tool:isSprinting()

	if self.tool:isLocal() then
		if self.cl.equipped then
			if self.cl.fpAnimations.currentAnimation ~= "idleFlip" then
				if isSprinting and self.cl.fpAnimations.currentAnimation ~= "sprintInto" and self.cl.fpAnimations.currentAnimation ~= "sprintIdle" then
					swapFpAnimation(self.cl.fpAnimations, "sprintExit", "sprintInto", 0.0)
				elseif not self.tool:isSprinting() and (self.cl.fpAnimations.currentAnimation == "sprintIdle" or self.cl.fpAnimations.currentAnimation == "sprintInto") then
					swapFpAnimation(self.cl.fpAnimations, "sprintInto", "sprintExit", 0.0)
				end
			end
		end
		updateFpAnimations(self.cl.fpAnimations, self.cl.equipped, deltaTime)
	end

	if not self.cl.equipped then
		if self.cl.wantEquipped then
			self.cl.wantEquipped = false
			self.cl.equipped = true
		end
		return
	end

	for name, animation in pairs(self.cl.tpAnimations.animations) do
		animation.time = animation.time + deltaTime

		if name == self.cl.tpAnimations.currentAnimation then
			if animation.time >= animation.info.duration - self.blendTime then
				if name == "pickup" then
					setTpAnimation(self.cl.tpAnimations, "idle", 0.001)
				elseif animation.nextAnimation ~= "" then
					setTpAnimation(self.cl.tpAnimations, animation.nextAnimation, 0.001)
				end
			end
		end
	end
end

-- Main Code

function SyntaxEditorClass:client_onCreate()
    self.cl = {}
    
    self.cl.gui = sm.gui.createGuiFromLayout("$CONTENT_DATA/Gui/Layout/SyntaxHighlightEditor.layout", false, {backgroundAlpha = 0.8})
end

function SyntaxEditorClass:client_onEquippedUpdate(primaryState, secondaryState, forceBuild)
    sm.gui.setInteractionText("<p textShadow='true' bg='gui_keybinds_bg' color='#ffffff' spacing='5'>Press " .. sm.gui.getKeyBinding("Create", true) .. " to open #3a96ddSyntax Highlight Editor</p>")
    sm.gui.setInteractionText("")

    if not forceBuild and primaryState == 1 then
        self.cl.gui:open()
    end
    
    return true, true
end

function SyntaxEditorClass:client_onEquip()
    self:cl_animateOnEquip()
end

function SyntaxEditorClass:client_onUnequip()
    self:cl_animateOnUnequip()
end

function SyntaxEditorClass:client_onUpdate(deltaTime)
    self:cl_onAnimUpdate(deltaTime)
end

function SyntaxEditorClass:client_onRefresh()
    self:client_onCreate()
end