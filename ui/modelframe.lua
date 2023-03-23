Inspector.ui.modelFrame = {};

function Inspector.ui.modelFrame:InitialiseModelFrame()
    InspectModelFrame:EnableMouse(true);
    InspectModelFrame:EnableMouseWheel(true);
    InspectModelRotateLeftButton:Hide();
    InspectModelRotateRightButton:Hide();
    Inspector:PostHookScript(InspectModelFrame, "OnMouseDown", function()
        Inspector.ui.modelFrame:OnMouseDown(this, arg1); ---@diagnostic disable-line: undefined-global
    end);
    Inspector:PostHookScript(InspectModelFrame, "OnMouseUp", function()
        Inspector.ui.modelFrame:OnMouseUp(this, arg1); ---@diagnostic disable-line: undefined-global
    end);
    Inspector:PostHookScript(InspectModelFrame, "OnMouseWheel", function()
        Inspector.ui.modelFrame:OnMouseWheel(this, arg1); ---@diagnostic disable-line: undefined-global
    end);
    Inspector:PostHookScript(InspectModelFrame, "OnUpdate", function()
        Inspector.ui.modelFrame:OnUpdate(this); ---@diagnostic disable-line: undefined-global
    end);
end

function Inspector.ui.modelFrame:OnMouseDown(modelFrame, mouseButton)
    modelFrame.curx, modelFrame.cury = GetCursorPosition();
    if (mouseButton == "LeftButton") then
        modelFrame.rotate = true;
    elseif (mouseButton == "RightButton") then
        modelFrame.pan = true;
    end
end

function Inspector.ui.modelFrame:OnMouseUp(modelFrame, mouseButton)
    if (mouseButton == "LeftButton") then
        modelFrame.rotate = nil;
    elseif (mouseButton == "RightButton") then
        modelFrame.pan = nil;
    end
end

function Inspector.ui.modelFrame:OnMouseWheel(modelFrame, scrollClicks)
    local z, x, y = modelFrame:GetPosition();
    local scale = (IsControlKeyDown() and 2 or 0.7);
    z = (scrollClicks > 0 and z + scale or z - scale);
    modelFrame:SetPosition(z, x, y);
end

function Inspector.ui.modelFrame:OnUpdate(modelFrame)
    if (modelFrame.rotate) then
        local endx, _ = GetCursorPosition();
        modelFrame.rotation = (endx - modelFrame.curx) / 34 + modelFrame:GetFacing();
        modelFrame:SetFacing(modelFrame.rotation);
        modelFrame.curx, modelFrame.cury = GetCursorPosition();
    elseif (modelFrame.pan) then
        local endx, endy = GetCursorPosition();
        local z, x, y = modelFrame:GetPosition();
        x = (endx - modelFrame.curx) / 45 + x;
        y = (endy - modelFrame.cury) / 45 + y;
        modelFrame:SetPosition(z, x, y);
        modelFrame.curx, modelFrame.cury = GetCursorPosition();
    end
end
