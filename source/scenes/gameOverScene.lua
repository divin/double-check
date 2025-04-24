import "scenes/gameMenuScene"
import "nodes/highScoreTable"

local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class GameOverScene : pd_sprite
class("GameOverScene").extends(gfx.sprite)

--- Initializes the game over screen
-- @return nil
function GameOverScene:init(time)
    GameOverScene.super.init(self)

    -- Create the high score table
    local width = pd.display.getWidth()
    local height = pd.display.getHeight()
    self.highScoreTable = HighScoreTable(width / 2, height / 2, HIGH_SCORE_TABLE_FILE_NAME)
    self.highScoreTable:setVisible(true)

    -- Reset some values
    CURRENT_SCORE = 0
    CURRENT_HEARTS = MAX_HEARTS

    -- Sprite
    local image = self:getGameOverSceneImage()
    self:setImage(image)
    self:setCenter(0, 0)
    self:setZIndex(100)
    self:moveTo(0, 0)
    self:add()
end

--- Creates the image for the event note
-- @return pd_image The image for the event note
function GameOverScene:getGameOverSceneImage()
    -- Create image
    local width = pd.display.getWidth()
    local height = pd.display.getHeight()
    local fontHeight = gfx.getSystemFont():getHeight()

    local text = nil
    local textWidth = nil
    local image = gfx.image.new(width, height)
    gfx.pushContext(image)

    text = "*Game Over*"
    textWidth = gfx.getSystemFont():getTextWidth(text)
    gfx.drawText(text, (width - textWidth) / 2, 0.75 * fontHeight)

    text = "Press A to return to the Menu"
    textWidth = gfx.getSystemFont():getTextWidth(text)
    gfx.drawText(text, (width - textWidth) / 2, height - 1.5 * fontHeight)
    gfx.popContext()

    return image
end

--- Update the game over screen
--- @return nil
function GameOverScene:update()
    if pd.buttonJustReleased(pd.kButtonA) then
        SCENE_MANAGER:switchScene(GameMenuScene)
    end
end
