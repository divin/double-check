import "nodes/hearts"
import "nodes/timeCounter"
import "nodes/currentScore"
import "scenes/gameScene/gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class EventNoteScene : pd_sprite
--- @field neededItems table The needed items for the event
class("EventNoteScene").extends(gfx.sprite)

--- Initializes the event screen with the needed items
-- @param neededItems table The needed items for the event
-- @return nil
function EventNoteScene:init()
    EventNoteScene.super.init(self)

    -- Audio
    self.samplePlayer = nil

    -- Set the time to remember the needed items
    self.time = 5000
    if 10 <= CURRENT_SCORE and CURRENT_SCORE < 30 then
        self.time = 4000
    elseif 30 <= CURRENT_SCORE and CURRENT_SCORE < 50 then
        self.time = 3500
    elseif 50 <= CURRENT_SCORE then
        self.time = 2000
    end

    -- Set the needed and missing items
    self.numberOfNeededItems = 4
    self.percentageOfMissingItems = 0.25
    if 10 <= CURRENT_SCORE and CURRENT_SCORE < 30 then
        self.numberOfNeededItems = 5
        self.percentageOfMissingItems = 0.5
    elseif 30 <= CURRENT_SCORE then
        self.numberOfNeededItems = 6
        self.percentageOfMissingItems = 0.75
    end

    self:setNeededItems()
    self:setMissingItems()

    -- Set the note dimensions
    self.noteWidth = 250
    self.noteHeight = 200

    -- Random events
    self.events = {
        "Job Interview",
        "Grocery Shopping",
        "First Date",
        "School Presentation",
        "Wedding",
        "Going to the Gym",
        "Walk the Dog",
    }

    -- Sprite
    local width = pd.display.getWidth()
    local height = pd.display.getHeight()
    local image = self:createImage()
    self:setImage(image)
    self:setCenter(0.5, 0.5)
    self:moveTo(width / 2, height / 2)
    self:add()

    -- Start timer
    self.timer = pd.timer.new(self.time, function()
        SCENE_MANAGER:switchScene(GameScene)
    end)

    -- UI elements
    self.timeCounter = TimeCounter(380, 220, 16, self.timer)
    self.currentScore = CurrentScore(376, 140, CURRENT_SCORE)
    self.hearts = Hearts(376, 20, 30, CURRENT_HEARTS, MAX_HEARTS)
end

--- Selects a random item from the given list
-- @param items table The list of items
-- @return ... The randomly selected item
function EventNoteScene:selectRandomItem(items)
    local randomIndex = math.random(1, #items)
    return items[randomIndex]
end

--- Set the needed items variable
--- @return nil
function EventNoteScene:setNeededItems()
    NEEDED_ITEMS = {}

    -- Body item
    local bodyItems = { "Shirt", "Longsleeve", "T-Shirt" }
    local bodyItem = self:selectRandomItem(bodyItems)
    if math.random() > 0.5 then
        table.insert(NEEDED_ITEMS, bodyItem)
    end

    -- Leg item
    local legItems = { "Shorts", "Trousers" }
    local legItem = self:selectRandomItem(legItems)
    if math.random() > 0.5 then
        table.insert(NEEDED_ITEMS, legItem)
    end

    -- Foot item
    local footItems = { "Shoes" }
    local footItem = self:selectRandomItem(footItems)
    if math.random() > 0.5 then
        table.insert(NEEDED_ITEMS, footItem)
    end

    -- Left hand item
    local leftHandItems = { "Bag", "Dog" }
    local leftHandItem = self:selectRandomItem(leftHandItems)
    if math.random() > 0.5 then
        table.insert(NEEDED_ITEMS, leftHandItem)
    end

    -- Accessoires
    local accessoires = { "Glasses", "Headphones", "Beard", "Bottle", "Socks" }
    for _, item in ipairs(accessoires) do
        if #NEEDED_ITEMS >= self.numberOfNeededItems then
            break
        end

        if math.random() > 0.5 then
            table.insert(NEEDED_ITEMS, item)
        end
    end
end

-- Set the missing items variable
-- @param items table The list of needed items
-- @return nil
function EventNoteScene:setMissingItems()
    MISSING_ITEMS = {}
    local numberOfNeededItems = #NEEDED_ITEMS

    if numberOfNeededItems == 0 then
        return
    end

    local numberOfMissingItems = math.floor(self.percentageOfMissingItems * numberOfNeededItems)
    for _ = 1, numberOfMissingItems do
        local item = self:selectRandomItem(NEEDED_ITEMS)
        table.insert(MISSING_ITEMS, item)
    end
end

--- Creates the image for the event note
-- @return pd_image The image for the event note
function EventNoteScene:createImage()
    -- Get event name and play sample
    local eventName = self:selectRandomItem(self.events)
    self.samplePlayer = pd.sound.sampleplayer.new("assets/sounds/voice/" .. eventName:gsub("%s+", "-") .. ".wav")
    self.samplePlayer:setFinishCallback(function(samplePlayer)
        samplePlayer:stop()
        -- TODO: Add a sound to give a hint how many items could be missing
    end
    )
    self.samplePlayer:play()

    -- Create image
    local fontHeight = gfx.getSystemFont():getHeight()
    local image = gfx.image.new(self.noteWidth + 5, self.noteHeight + 5)
    gfx.pushContext(image)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(5, 5, self.noteWidth, self.noteHeight)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, self.noteWidth, self.noteHeight)

    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect(0, 0, self.noteWidth, self.noteHeight)

    gfx.drawText("Event: " .. eventName, 10, 10)
    gfx.drawText("Needed Items:", 10, 10 + 1.5 * fontHeight)

    for index, name in ipairs(NEEDED_ITEMS) do
        local x = 35
        local y = index * fontHeight + 2 * fontHeight
        gfx.fillCircleAtPoint(x - 20, y + (fontHeight / 2), 5)
        gfx.drawText(name, x, y)
    end
    gfx.popContext()

    return image
end
