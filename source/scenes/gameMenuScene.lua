import "nodes/highScoreTable"
import "scenes/eventNoteScene/eventNoteScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class GameMenuScene : pd_sprite
class("GameMenuScene").extends(gfx.sprite)

--- Initializes the game menu
--- @return nil
function GameMenuScene:init()
    GameMenuScene.super.init(self)

    self.items = { "Play", "Help", "High Score" }

    -- Selection Menu
    self.gridWidth = 100
    self.gridHeight = 75
    self.position = pd.geometry.point.new(290, 160)
    self.gridview = GridView(0, 32, self.items, self.gridWidth, self.gridHeight, false)
    self.selectionMenu = gfx.sprite.new()
    self.selectionMenu:setCenter(0, 0)
    self.selectionMenu:setZIndex(1)
    self.selectionMenu:moveTo(self.position.x, self.position.y)
    self.selectionMenu:add()

    -- Create the high score table
    local width = pd.display.getWidth()
    local height = pd.display.getHeight()
    self.highScoreTable = HighScoreTable(width / 2, height / 2, HIGH_SCORE_TABLE_FILE_NAME)

    -- Help Display
    local helpDisplayImage = self:getHelpDisplayImage()
    self.helpDisplay = gfx.sprite.new(helpDisplayImage)
    self.helpDisplay:setZIndex(2)
    self.helpDisplay:setCenter(0.5, 0.5)
    self.helpDisplay:moveTo(200, 120)
    self.helpDisplay:setVisible(false)
    self.helpDisplay:add()

    -- Background
    local image = self:getBackgroundImage()
    self:setImage(image)
    self:setZIndex(0)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

--- Get background image
--- @return pd_image
function GameMenuScene:getBackgroundImage()
    local image = gfx.image.new("assets/images/title/title.png")
    gfx.pushContext(image)

    local text = "V" .. pd.metadata.version
    local textWidth = gfx.getSystemFont():getTextWidth(text)
    gfx.drawText(text, 395 - textWidth, 5)
    gfx.popContext()
    return image
end

--- Get Help Scene Image
--- @return pd_image
function GameMenuScene:getHelpDisplayImage()
    local noteWidth = 250
    local noteHeight = 200
    local image = gfx.image.new(noteWidth + 10, noteHeight + 10)
    gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(5, 5, noteWidth + 10, noteHeight + 10)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, noteWidth + 5, noteHeight + 5)

    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect(0, 0, noteWidth + 5, noteHeight + 5)

    local text =
    "Jerry is _sometimes_ forgetful. You'll see a note with the items you need, and you'll have 5 seconds to remember them.\n\nAfter that, you'll have to choose the missing item based on the items Jerry is wearing."
    gfx.drawTextInRect(text, 5, 5, noteWidth - 10, noteHeight - 10)

    gfx.popContext()
    return image
end

--- Update the game menu
--- @return nil
function GameMenuScene:update()
    if not self.helpDisplay:isVisible() and not self.highScoreTable:isVisible() then
        if pd.buttonJustReleased(pd.kButtonUp) then
            self.gridview:selectPreviousRow(true)
        end

        if pd.buttonJustReleased(pd.kButtonDown) then
            self.gridview:selectNextRow(true)
        end
    end

    if pd.buttonJustReleased(pd.kButtonA) then
        local _, row, _ = self.gridview:getSelection()
        if row == 1 then
            SCENE_MANAGER:switchScene(EventNoteScene)
        elseif row == 2 then
            self.helpDisplay:setVisible(not self.helpDisplay:isVisible())
        elseif row == 3 then
            self.highScoreTable:setVisible(not self.highScoreTable:isVisible())
        end
    end

    if pd.buttonJustReleased(pd.kButtonB) and self.helpDisplay:isVisible() then
        self.helpDisplay:setVisible(false)
    end

    if pd.buttonJustReleased(pd.kButtonB) and self.highScoreTable:isVisible() then
        self.highScoreTable:setVisible(false)
    end

    if self.gridview:isNeedingDisplay() then
        local image = gfx.image.new(self.gridWidth, self.gridHeight)
        gfx.pushContext(image)
        self.gridview:drawInRect(0, 0, self.gridWidth, self.gridHeight)
        gfx.popContext()
        self.selectionMenu:setImage(image)
    end
end
