CreateMultiple.Buttons = T{}

-- ------------------------------------------------------------------------------------------------------
-- Create a quick button to set a reminder {minutes} into the future.
-- ------------------------------------------------------------------------------------------------------
---@param pass boolean
---@param minutes? number number of minutes in the future to set the timer.
---@param caption? string name of the button the user will click to create this timer (quick button).
-- ------------------------------------------------------------------------------------------------------
CreateMultiple.ShorterNames = true

CreateMultiple.Buttons.Add = function(enabled)
    local clicked = UI.Button("Add")
    return clicked
end

CreateMultiple.Buttons.Check = function(enabled)
    local clicked = UI.Button("Check")
    return clicked
end

CreateMultiple.Buttons.ShorterNames = function(enabled)
    local checked = UI.Checkbox("Shorter names", {enabled})
    return checked
end