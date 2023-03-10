local positioning = require("positioning")

local lib = {}

function lib.goAfterRelPositiveZ(relZ)
    positioning.turnSouth()

    for goZ = 0, relZ - 1 do
        while turtle.detect() do
            turtle.dig()
            sleep(0.25)
        end

        positioning.forward()
        
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end
    end
end

function lib.goAfterRelNegativeZ(relZ)
    positioning.turnNorth()

    local positiveRelZ = relZ - relZ - relZ

    for goZ = 0, positiveRelZ - 1 do
        while turtle.detect() do
            turtle.dig()
            sleep(0.25)
        end

        positioning.forward()
        
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end
    end
end

function lib.goAfterRelPositiveX(relX)
    positioning.turnEast()

    for goX = 0, relX - 1 do
        while turtle.detect() do
            turtle.dig()
            sleep(0.25)
        end

        positioning.forward()
        
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end
    end
end

function lib.goAfterRelNegativeX(relX)
    positioning.turnWest()

    local positiveRelX = relX - relX - relX

    for goX = 0, positiveRelX - 1 do
        while turtle.detect() do
            turtle.dig()
            sleep(0.25)
        end

        positioning.forward()
        
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end
    end
end

function lib.goAfterRelPositiveY(relY)
    for goY = 0, relY - 1 do
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end

        positioning.up()
        
        while turtle.detectUp() do
            turtle.digUp()
            sleep(0.25)
        end
    end
end

function lib.goAfterRelNegativeY(relY)
    local positiveRelY = relY - relY - relY

    for goY = 0, positiveRelY - 1 do
        while turtle.detectDown() do
            turtle.digDown()
            sleep(0.25)
        end

        positioning.down()
    end
end

function lib.goAfterRelBlock(relX, relY, relZ)
    --Switch to Pickaxe
    turtle.select(16)
    turtle.equipRight()

    if relY >= 1 then
        lib.goAfterRelPositiveY(relY)
    elseif relY < 0 then
        lib.goAfterRelNegativeY(relY)
    end

    if relZ >= 1 then
        lib.goAfterRelPositiveZ(relZ)
    elseif relZ < 0 then
        lib.goAfterRelNegativeZ(relZ)
    end

    if relX >= 1 then
        lib.goAfterRelPositiveX(relX)
    elseif relX < 0 then
        lib.goAfterRelNegativeX(relX)
    end

    --Switch to Scanner
    turtle.select(16)
    turtle.equipRight()
end

function lib.goAfterAbsBlock(absX, absY, absZ)
    local targetX, targetY, targetZ

    if positioning.currentAbsX < absX then
        targetX = absX - positioning.currentAbsX
    else
        targetX = -(positioning.currentAbsX - absX)
    end

    if positioning.currentAbsY < absY then
        targetY = absY - positioning.currentAbsY
    else
        targetY = -(positioning.currentAbsY - absY)
    end

    if positioning.currentAbsZ < absZ then
        targetZ = absZ - positioning.currentAbsZ
    else
        targetZ = -(positioning.currentAbsZ - absZ)
    end

    lib.goAfterRelBlock(targetX, targetY, targetZ)
end

function lib.moveOn(distance)
    --Switch to Pickaxe
    turtle.select(16)
    turtle.equipRight()
    
    for i = 1, distance do
        turtle.dig()
        positioning.forward()
        turtle.digUp()
    end

    --Switch to Scanner
    turtle.select(16)
    turtle.equipRight()
end

function lib.selectClosestTarget(results, target)
    local foundRelX = nil
    local foundRelY = nil
    local foundRelZ = nil
    local foundCost = nil

    for index, block in pairs(results) do
        if block.name == target then
            if foundRelX then
                --We already found a target, but we will now check if this target is closer
                local newTargetCost = positioning.getRelMovementCost(block.x, block.y, block.z)

                if newTargetCost < foundCost then
                    --This target is closer, so we will select it
                    foundRelX = block.x
                    foundRelY = block.y
                    foundRelZ = block.z
                    foundCost = newTargetCost
                end
            else
                foundRelX = block.x
                foundRelY = block.y
                foundRelZ = block.z
                foundCost = positioning.getRelMovementCost(foundRelX, foundRelY, foundRelZ)
            end
        end
    end

    return foundRelX, foundRelY, foundRelZ, foundCost
end

return lib