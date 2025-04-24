local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class SceneManager
class("SceneManager").extends()

--- Initializes the scene manager
--- @return nil
function SceneManager:init()
    self.newScene = nil
    self.sceneArgs = {}
end

--- Switch to a new scene
--- @param scene function The scene to switch to
--- @param ... any The arguments to pass to the scene
--- @return nil
function SceneManager:switchScene(scene, ...)
    self.newScene = scene
    self.sceneArgs = { ... }
    self:loadNewScene()
end

--- Load a new scene
--- @return nil
function SceneManager:loadNewScene()
    self:cleanUp()
    self.newScene(table.unpack(self.sceneArgs))
end

--- Clean up the current scene
--- @return nil
function SceneManager:cleanUp()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
end

--- Remove all timers
--- @return nil
function SceneManager:removeAllTimers()
    local timers = pd.timer.allTimers()
    for _, timer in ipairs(timers) do
        timer:remove()
    end
end
