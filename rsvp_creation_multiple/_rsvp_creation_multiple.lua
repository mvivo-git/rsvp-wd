CreateMultiple = { }

CreateMultiple.Defaults = T{
    X_Pos   = 100,
    Y_Pos   = 100,
    Visible = { false },
}

CreateMultiple.Table_Flags = bit.bor(ImGuiSelectableFlags_None)

CreateMultiple.ALIAS          = 'createmultiple'
CreateMultiple.Scaling_Set    = false
CreateMultiple.Reset_Position = true

CreateMultiple.Type = {
    Normal = 1,
    King   = 2,
    Wyrm   = 3,
    Custom = 4,
}

require('rsvp_creation_multiple.buttons')

-- ------------------------------------------------------------------------------------------------------
-- Show the multi-creation window.
-- ------------------------------------------------------------------------------------------------------

CreateMultiple.ShorterNamesState = T{
	checked = true,
	enabled = true,
	clicked = true,
	selected = true
}


CreateMultiple.Display = function()
    if RSVP.CreateMultiple.Visible[1] then
        if CreateMultiple.Reset_Position then
            UI.SetNextWindowPos({ RSVP.CreateMultiple.X_Pos, RSVP.CreateMultiple.Y_Pos }, ImGuiCond_Always)
            CreateMultiple.Reset_Position = false
        end

        UI.PushStyleColor(ImGuiCol_WindowBg, Window.Colors.DEFAULT)
        Window.SetScaling()

        if UI.Begin('RSVP Multi-Creation', RSVP.CreateMultiple.Visible, Window.Window_Flags) then
            RSVP.CreateMultiple.X_Pos, RSVP.CreateMultiple.Y_Pos = UI.GetWindowPos()
            Window.SetLegacyScaling()

            Inputs.DateField()
            Inputs.MultipleField()

			if (UI.Checkbox("Short names", {CreateMultiple.ShorterNames})) then
				CreateMultiple.ShorterNames = not CreateMultiple.ShorterNames
				Ashita.Chat.Echo('Clicked. '.. tostring(CreateMultiple.ShorterNames))
			end
	
            if UI.Button('Add') then
                Inputs.ParseInput('creation', CreateMultiple.ShorterNames)
            end

            Window.SetLegacyScaling(Config.GetScale())
            UI.End()
        end

        Window.SetScaling(Config.GetScale())
        UI.PopStyleColor(1)
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create timers from a scheduled date/time.
-- ------------------------------------------------------------------------------------------------------
---@param type integer
---@param name string
---@param date table
---@param time table
---@param customInfo? table
-- ------------------------------------------------------------------------------------------------------
CreateMultiple.Schedule = function(type, name, date, time, customInfo, day)
    local timestamp = Timers.MakeTimeTable(date, time)

    if type == CreateMultiple.Type.Normal then
        local futureMinutes = (timestamp - os.time()) / 60
        Timers.Start(name, futureMinutes)
    elseif type == CreateMultiple.Type.King then
		local futureMinutes = (timestamp - os.time()) / 60
        for i = 0, 6, 1 do
            local timerName
            if day then
                timerName = name .. ' D' .. day .. ' (' .. tostring(i + 1) .. '/7)'
            else
                timerName = name .. ' (' .. tostring(i + 1) .. '/7)'
            end
            Timers.Start(timerName, futureMinutes + (10 * i), name)
        end
    elseif type == CreateMultiple.Type.Wyrm then
        local futureMinutes = (timestamp - os.time()) / 60
        for i = 0, 24, 1 do
            local timerName = name .. ' (' .. tostring(i + 1) .. '/25)'
            Timers.Start(timerName, futureMinutes + (60 * i), name)
        end

    elseif type == CreateMultiple.Type.Custom then
        local futureMinutes = (timestamp - os.time()) / 60
        for i = 0, customInfo.count, 1 do
            local timerName = name .. ' (' .. tostring(i + 1) .. '/' .. tostring(customInfo.count + 1) .. ')'
            Timers.Start(timerName, futureMinutes + (customInfo.gap * i), name)
        end
    end
end
