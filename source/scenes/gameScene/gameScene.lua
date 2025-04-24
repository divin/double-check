import "nodes/hearts"
import "nodes/timeCounter"
import "nodes/currentScore"
import "nodes/highScoreTable"
import "scenes/gameOverScene"
import "scenes/gameScene/item"
import "scenes/gameScene/selectionMenu"
import "scenes/eventNoteScene/eventNoteScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Set seed
math.randomseed(pd.getSecondsSinceEpoch())

--- @class GameScene : pd_sprite
class("GameScene").extends(gfx.sprite)

--- Initializes the game scene
--- @return nil
function GameScene:init()
    GameScene.super.init(self)

    -- Set the time to remember the needed items
    self.time = 10000
    if 10 <= CURRENT_SCORE and CURRENT_SCORE < 30 then
        self.time = 8000
    elseif 30 <= CURRENT_SCORE and CURRENT_SCORE < 50 then
        self.time = 6500
    elseif 50 <= CURRENT_SCORE then
        self.time = 5000
    end

    -- Initialize the sprites
    self.jerry = Item("Jerry", 0, true)
    self.items = self:getNeededItemSprites()

    -- Input
    self.isInputAllowed = true

    -- Create the high score table
    local width = pd.display.getWidth()
    local height = pd.display.getHeight()
    self.highScoreTable = HighScoreTable(width / 2, height / 2, HIGH_SCORE_TABLE_FILE_NAME)

    -- Create the selection menu
    self.selectionMenu = SelectionMenu(175, 25, ITEMS, 150, 170)

    -- Score
    self.numberOfCorrectItems = 0
    self.numberOfMissingItems = #MISSING_ITEMS
    self.selectionMenu.numberOfMissingItems = #MISSING_ITEMS

    -- Add scene
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()

    -- Start timer
    self.timer = pd.timer.new(self.time, function()
        local samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/wrong.wav")
        samplePlayer:play()

        CURRENT_HEARTS -= 1

        if CURRENT_HEARTS == 0 then
            self.highScoreTable:saveScores()
            SCENE_MANAGER:switchScene(GameOverScene)
        else
            SCENE_MANAGER:switchScene(EventNoteScene)
        end
    end)

    -- UI elements
    self.timeCounter = TimeCounter(380, 220, 16, self.timer)
    self.currentScore = CurrentScore(376, 140, CURRENT_SCORE)
    self.hearts = Hearts(376, 20, 30, CURRENT_HEARTS, MAX_HEARTS)
end

--- Check if list contains item
--- @param list table The list to check
--- @param item string The item to check
--- @return boolean If the list contains the item
function GameScene:contains(list, item)
    for _, value in ipairs(list) do
        if value == item then
            return true
        end
    end

    return false
end

--- Get the needed item sprites as table
--- @return table The needed item sprites
function GameScene:getNeededItemSprites()
    local items = {}
    for _, name in ipairs(NEEDED_ITEMS) do
        local isVisible = not self:contains(MISSING_ITEMS, name)
        if name == "Bag" or name == "Bottle" or name == "Dog" then
            local item = Item(name, -1, isVisible)
            table.insert(items, item)
        elseif name == "Beard" or name == "Glasses" or name == "Headphones" or name == "Socks" then
            local item = Item(name, 1, isVisible)
            table.insert(items, item)
        elseif name == "Shoes" then
            local item = Item(name, 2, isVisible)
            table.insert(items, item)
        elseif name == "Shorts" or name == "Trousers" then
            local item = Item(name, 3, isVisible)
            table.insert(items, item)
        else
            local item = Item(name, 4, isVisible)
            table.insert(items, item)
        end
    end

    return items
end

--- Make the items visible
--- @return nil
function GameScene:makeItemsVisible(name)
    for _, item in ipairs(self.items) do
        if item.name == name then
            item:setVisible(true)
        end
    end
end

--- Update the game scene
--- @return nil
function GameScene:update()
    if not self.isInputAllowed then
        self.selectionMenu.isInputAllowed = false
        return
    end

    -- When an item is selected
    if self.selectionMenu.hasSelected and self.selectionMenu.selectedItem then
        local selectedItemName = self.selectionMenu.selectedItem

        -- Check if the selected item is correct
        if self:contains(MISSING_ITEMS, selectedItemName) or (selectedItemName == "Nothing" and #MISSING_ITEMS == 0) then
            self.numberOfCorrectItems += 1
            self.selectionMenu.numberOfCorrectItems += 1
            self.selectionMenu.needsRedraw = true
            self:makeItemsVisible(selectedItemName)
            local samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/correct.wav")
            samplePlayer:play()
        else
            local samplePlayer = pd.sound.sampleplayer.new("assets/sounds/fx/wrong.wav")
            samplePlayer:play()

            self.isInputAllowed = false

            -- TODO: Let the screen shake when the wrong item is selected
            pd.timer.new(1000, function()
                CURRENT_HEARTS -= 1

                if CURRENT_HEARTS == 0 then
                    self.highScoreTable:saveScores()
                    SCENE_MANAGER:switchScene(GameOverScene)
                else
                    SCENE_MANAGER:switchScene(EventNoteScene)
                end
            end)
        end

        self.selectionMenu.selectedItem = nil
        self.selectionMenu.hasSelected = false

        -- When all items are found
        if self.numberOfCorrectItems >= self.numberOfMissingItems and self.numberOfCorrectItems ~= 0 then
            self.isInputAllowed = false
            pd.timer.new(1000, function()
                CURRENT_SCORE += 1
                SCENE_MANAGER:switchScene(EventNoteScene)
            end)
        end
    end
end
