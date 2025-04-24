local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Item : pd_sprite
--- @field name string The name of the item
class("Item").extends(gfx.sprite)

--- Initializes an item
--- @param name string The name of the item
--- @param zIndex number The z-index of the item
--- @param isVisible boolean Whether the item is visible
function Item:init(name, zIndex, isVisible)
    Item.super.init(self)

    self.name = name
    isVisible = isVisible or false

    local image = gfx.image.new("assets/images/sprites/" .. name .. ".png")
    self:setCenter(0, 0)
    self:setImage(image)
    self:moveTo(-10, 0)
    self:setZIndex(zIndex)
    self:setVisible(isVisible)
    self:add()
end
