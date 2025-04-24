local pd <const> = playdate
local gfx <const> = pd.graphics

--- @class CurrentScore : pd_sprite
--- @field score number The current score
class("CurrentScore").extends(gfx.sprite)

--- Initializes the current score
-- @param x number The x position of the current score
-- @param y number The y position of the current score
-- @param score number The current score
-- @return nil
function CurrentScore:init(x, y, score)
    CurrentScore.super.init(self)

    self.score = score
    self.text = tostring(self.score)
    self.font = gfx.getSystemFont()
    self.textHeight = self.font:getHeight()
    self.textWidth = self.font:getTextWidth(self.text)

    self.image = gfx.image.new(self.textWidth, self.textHeight)
    gfx.pushContext(self.image)
    gfx.drawText(self.text, 0, 0)
    gfx.popContext()

    self:setImage(self.image)
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
end
