#Requires AutoHotkey v1
SendMode Input

; Define default grid size
gridWidth := 12
gridHeight := 5

; Variables to store area bounds
area1Left := ""
area1Top := ""
area1Right := ""
area1Bottom := ""

area2Left := ""
area2Top := ""
area2Right := ""
area2Bottom := ""

Speed := 500

; exclude := a

; Function to get user input for area bounds
GetAreaBounds(areaName) {
    CoordMode, Mouse, Screen
    
    MsgBox, 4,, Please select the topleft bounds for %areaName% and press Enter.
    MouseGetPos, x1, y1

    IfMsgBox, No 
    {
        ExitApp
    }

    MsgBox, 4,, Please select the bottomright bounds for %areaName% and press Enter.
    MouseGetPos, x2, y2

    IfMsgBox, No 
    {
        ExitApp
    }

    ; Return the bounds
    return [x1, y1, x2, y2]
}

; devide the area1 and area2 into a grid and click each cell. alternate between area1 and area2 
clickGridPositions(area1Bounds, area2Bounds, width, height, speed := 200) {


    exclude := [[6, 2], [6, 3], [6, 4], [6, 5], [5, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5], [12, 4], [12, 3]]

    ; keep log varaible
    log := ""

    ; log params
    log .= "Grid Size: " . width . " x " . height . "`n"

    ; get area bounds
    area1Left := area1Bounds[1]
    area1Top := area1Bounds[2]
    area1Right := area1Bounds[3]
    area1Bottom := area1Bounds[4]

    area2Left := area2Bounds[1]
    area2Top := area2Bounds[2]
    area2Right := area2Bounds[3]
    area2Bottom := area2Bounds[4]

    ; log bounds
    log .= "Area 1: " . area1Left . ", " . area1Top . ", " . area1Right . ", " . area1Bottom . "`n"
    log .= "Area 2: " . area2Left . ", " . area2Top . ", " . area2Right . ", " . area2Bottom . "`n"


    ; get area width and height
    area1Width := area1Right - area1Left
    area1Height := area1Bottom - area1Top

    area2Width := area2Right - area2Left
    area2Height := area2Bottom - area2Top

    ; get cell width and height
    area1CellWidth := area1Width // width
    area1CellHeight := area1Height // height

    area2CellWidth := area2Width // width
    area2CellHeight := area2Height // height

    ; log cell width and height
    log .= "Area 1 Cell size: " . area1CellWidth . "x" . area1CellHeight . "`n"
    log .= "Area 2 Cell size: " . area2CellWidth . "x" . area2CellHeight . "`n"
    

    log .= "Now clicking: `n"

    ; click the first cell of area1
    ClickCell(area1Left, area1Top, area1CellWidth, area1CellHeight)

    Sleep speed

    
    ; loop through each cell. USe v1 syntax
    Loop, %width% {
        xIndex := A_Index
        Loop, %height% {
            yIndex := A_Index

            excludeCell := False

            ; Skip if cell is in exclude list
            Loop, % exclude.MaxIndex() {
                if (xIndex = exclude[A_Index][1] && yIndex = exclude[A_Index][2]) {
                    log .= "Skipping: " . xIndex . ", " . yIndex . "`n"
                    excludeCell := True
                    break
                }
            }

            if (excludeCell) {
                continue
            }
            

            ; get cell position
            cellX := area1Left + (xIndex - 1) * area1Width // width
            cellY := area1Top + (yIndex - 1) *  area1Height // height


            ; click the center of the cell
            ClickCell(cellX, cellY, area1CellWidth, area1CellHeight, speed)

            log .= "Area 1: " . cellX . ", " . cellY . "`n"


            ; get area2 cell position
            cellX := area2Left + (xIndex - 1) * area2Width // width
            cellY := area2Top + (yIndex - 1) * area2Height // height

            ; click cell
            ClickCell(cellX, cellY, area2CellWidth, area2CellHeight, speed)
            
            ; log cell position
            log .= "Area 2: " . cellX . ", " . cellY . "`n"

        }
    }
   
    


    ; msg everything niceley formatted
    ; MsgBox, 4,, %log%

}

; Function to click on a grid cell
ClickCell(x, y, width, height, speed := 200) {
    ; set move mode
    CoordMode, Mouse, Screen

   

    ; MouseMove, x + width // 2, y + height // 2, 0

    ; Animate mouse to position in 100ms
    MouseMove, x + width // 2, y + height // 2, 0
    
    Sleep speed
    Click
    Sleep speed
}

; Start the program on Ctrl+Shift+G
^+g::
    ; Get area bounds
    area1Bounds := GetAreaBounds("Area 1")
    area1Left := area1Bounds[1]
    area1Top := area1Bounds[2]
    area1Right := area1Bounds[3]
    area1Bottom := area1Bounds[4]
    
    
    area2Bounds := GetAreaBounds("Area 2")
    area2Left := area2Bounds[1]
    area2Top := area2Bounds[2]
    area2Right := area2Bounds[3]
    area2Bottom := area2Bounds[4]

    

    ; ; Get grid size. Default is 12x5
    InputBox, gridSize, Grid Size, Please enter the grid size in the format "12x5" (without quotes)., , 300, 150,,,,, 12x5

    ; exit if user presses cancel on InputBox
    If ErrorLevel = 1
    {
        ExitApp
    }
    
    ; speed input
    InputBox, speed, Speed, Please enter the speed in milliseconds. Default is 20., , 300, 150,,,,, 5
   
    ; exit if user presses cancel on InputBox
    If ErrorLevel = 1
    {
        ExitApp
    }
    

    gridSizeArr := StrSplit(gridSize, "x")
    gridWidth := Trim(gridSizeArr[1])
    gridHeight := Trim(gridSizeArr[2])

    ; msg everything niceley formatted
    ; MsgBox, 4,, Area 1: %area1Left%, %area1Top%, %area1Right%, %area1Bottom%`nArea 2: %area2Left%, %area2Top%, %area2Right%, %area2Bottom%`nGrid Size: %gridWidth% x %gridHeight%
    
    ; ; Create grid positions and click
    clickGridPositions(area1Bounds, area2Bounds, gridWidth, gridHeight, speed)
    
    ; End the program by pressing Esc while running
    Loop {
        GetKeyState, state, Esc, P
        if state
            break
    }
    
    ; Reset area bounds
    area1Left := ""
    area1Top := ""
    area1Right := ""
    area1Bottom := ""
    
    area2Left := ""
    area2Top := ""
    area2Right := ""
    area2Bottom := ""
return