import "libraries/icons/icon"

local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class Hearts : pd_sprite
class("Hearts").extends(gfx.sprite)

--- Initializes the hearts
-- @param x number The x position of the hearts
-- @param y number The y position of the hearts
-- @param currentNumberOfHearts number The current number of hearts
-- @param maxNumberOfHearts number The max number of hearts
-- @return nil
function Hearts:init(x, y, gap, currentNumberOfHearts, maxNumberOfHearts)
    Hearts.super.init(self)

    self.hearts = {}
    self.brokenHearts = {}
    self.maxNumberOfHearts = maxNumberOfHearts
    self.currentNumberOfHearts = currentNumberOfHearts

    self:drawHearts(x, y, gap)
    self:moveTo(x, y)
    self:add()
end

--- Draw the hearts
--- @param x number The start x position of the hearts
--- @param y number The start y position of the hearts
--- @param gap number The gap between the hearts
--- @return nil
function Hearts:drawHearts(x, y, gap)
    self.hearts = {}
    for index = 0, self.currentNumberOfHearts - 1 do
        local heart = Icon(x, y + index * gap, IconHeart)
        table.insert(self.hearts, heart)
    end

    self.brokenHearts = {}
    for index = self.currentNumberOfHearts, self.maxNumberOfHearts - 1 do
        local brokenHeart = Icon(x, y + index * gap, IconHeartBroken)
        table.insert(self.brokenHearts, brokenHeart)
    end
end
