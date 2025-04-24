local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class GridView
class("GridView").extends()

--- Initializes a grid view
--- @param cellWidth number The width of the cell
--- @param cellHeight number The height of the cell
--- @param items table The items to display in the grid view
function GridView:init(cellWidth, cellHeight, items, gridWidth, gridHeight, hasBackgroundImage)
    self.items = items
    self.gridWidth = gridWidth
    self.gridHeight = gridHeight
    self.hasBackgroundImage = hasBackgroundImage
    self._gridview = pd.ui.gridview.new(cellWidth, cellHeight)
    self._gridview:setNumberOfRows(#self.items)
    self._gridview:setCellPadding(2, 2, 2, 2)

    if self.hasBackgroundImage then
        self._gridview.backgroundImage = self:createBackgroundImage(self.gridWidth, self.gridHeight)
    end

    -- Overwrite the drawCell method
    local listView = self
    function self._gridview:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRoundRect(x, y, width, height, 4)
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        else
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
        end
        local fontHeight = gfx.getSystemFont():getHeight()
        gfx.drawTextInRect(listView.items[row], x, y + (height / 2 - fontHeight / 2) + 2, width, height, nil, nil,
            kTextAlignment.center)
    end
end

--- Creates a background image
--- @param width number The width of the image
--- @param height number The height of the image
function GridView:createBackgroundImage(width, height)
    local image = gfx.image.new(width, height)
    gfx.pushContext(image)
    gfx.drawRoundRect(0, 0, width, height, 4)
    gfx.popContext()
    return image
end

--- Returns whether the grid view needs display
--- @return boolean
function GridView:isNeedingDisplay()
    return self._gridview.needsDisplay
end

--- Selects the next row
--- @param needsDisplay boolean Whether the grid view needs display
--- @return nil
function GridView:selectNextRow(needsDisplay)
    self._gridview:selectNextRow(needsDisplay)
end

--- Selects the previous row
--- @param needsDisplay boolean Whether the grid view needs display
--- @return nil
function GridView:selectPreviousRow(needsDisplay)
    self._gridview:selectPreviousRow(needsDisplay)
end

--- Draws the grid view in a rectangle
--- @param x number The x-coordinate of the rectangle
--- @param y number The y-coordinate of the rectangle
--- @param width number The width of the rectangle
--- @param height number The height of the rectangle
function GridView:drawInRect(x, y, width, height)
    self._gridview:drawInRect(x, y, width, height)
end

--- Returns the selection
--- @return number The section
--- @return number The row
--- @return number The column
function GridView:getSelection()
    return self._gridview:getSelection()
end
