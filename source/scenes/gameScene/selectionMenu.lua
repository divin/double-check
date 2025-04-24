local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class SelectionMenu : pd_sprite
--- @field items table The list of items
--- @field gridWidth number The width of the grid
--- @field gridHeight number The height of the grid
class("SelectionMenu").extends(gfx.sprite)

--- Initializes an selection option
--- @param x number The x-coordinate of the selection
--- @param y number The y-coordinate of the selection
--- @param items table The list of items
--- @param gridWidth number The width of the grid
--- @param gridHeight number The height of the grid
function SelectionMenu:init(x, y, items, gridWidth, gridHeight)
    SelectionMenu.super.init(self)

    -- Items
    self.items = items

    self.selectedItem = nil
    self.hasSelected = false
    self.needsRedraw = false
    self.isInputAllowed = true

    self.numberOfCorrectItems = 0
    self.numberOfMissingItems = nil

    -- Gridview
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight
    self.gridview = GridView(0, 32, self.items, self.gridWidth, self.gridHeight, true)

    -- Sprite
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
end

--- Update the selection
--- @return nil
function SelectionMenu:update()
    if not self.isInputAllowed then
        return
    end

    -- Update the selection if button up is pressed
    if pd.buttonJustReleased(pd.kButtonUp) then
        self.gridview:selectPreviousRow(true)
        self.selectedItem = nil
        self.hasSelected = false
    end

    -- Update the selection if button down is pressed
    if pd.buttonJustReleased(pd.kButtonDown) then
        self.gridview:selectNextRow(true)
        self.selectedItem = nil
        self.hasSelected = false
    end

    -- Update the selected item if button A is pressed
    if pd.buttonJustReleased(pd.kButtonA) then
        local _, row, _ = self.gridview:getSelection()
        self.hasSelected = true
        self.selectedItem = self.items[row]
        local samplePlayer = pd.sound.sampleplayer.new("assets/sounds/voice/" ..
        self.selectedItem:gsub("%s+", "-") .. ".wav")
        samplePlayer:play()
    end

    if self.gridview:isNeedingDisplay() or self.needsRedraw then
        local text = "Select the missing item:"

        -- Check width of the text and height of the font
        local fontHeight = gfx.getSystemFont():getHeight()
        local textWidth = gfx.getSystemFont():getTextWidth(text)
        local width = math.max(self.gridWidth, textWidth)

        -- Create and set the image
        local image = gfx.image.new(width, self.gridHeight + fontHeight)
        gfx.pushContext(image)
        gfx.drawText(text, 0, 0)
        self.gridview:drawInRect((textWidth / 2) - (self.gridWidth / 2), fontHeight, self.gridWidth, self.gridHeight)
        gfx.popContext()
        self:setImage(image)

        self.needsRedraw = false
    end
end
