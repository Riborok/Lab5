# Lab №5. 2D array (maze)
---
### Task:
![The task](https://i.imgur.com/szTz0Mg.png)

#### Language: Delphi

## There are 3 variants: 
### 1) Using the BFS algorithm
>The program finds the closest path to each exit
#### ⠀⠀a) Maze entry
[ ⠀⠀  ⠀ ⠀Check scheme](#algorithm-scheme-the-first-variant-maze-entry)
[ ⠀⠀  ⠀ ⠀Check code](#code-using-the-first-variant-maze-entry)
#### ⠀⠀b) Filling the maze randomly
[ ⠀⠀  ⠀ ⠀Check code](#code-using-the-first-variant-filling-the-maze-randomly)
### 2) Using the DFS algorithm
>The program finds all possible exit paths
#### ⠀⠀a) Maze entry
[ ⠀⠀  ⠀ ⠀Check scheme](#algorithm-scheme-the-second-variant-maze-entry)
[ ⠀⠀  ⠀ ⠀Check code](#code-using-the-second-variant-maze-entry)
#### ⠀⠀b) Filling the maze randomly
[ ⠀⠀  ⠀ ⠀Check code](#code-using-the-second-variant-filling-the-maze-randomly)
### 3) Using the Dijkstra algorithm
>The program finds one closest path
#### ⠀⠀ ⠀ Filling the maze randomly
[ ⠀⠀  ⠀ ⠀Check code](#code-using-the-third-variant-filling-the-maze-randomly)

---
### Algorithm scheme the first variant (maze entry)

![Algorithm schеme using the first variant Part1](https://i.imgur.com/zHYBacB.png)

![Algorithm scheme using the first variant Part2](https://i.imgur.com/cFgRC1I.png)

![Algorithm scheme using the first variant Part3](https://i.imgur.com/lawuj9n.png)

![Algorithm scheme using the first variant Part4](https://i.imgur.com/ZWTvbjM.png)

![Algorithm scheme using the first variant Part5](https://i.imgur.com/UeWRE2y.png)

![Algorithm scheme using the first variant Part6](https://i.imgur.com/3RTAaCR.png)

![Algorithm scheme using the first variant Part7](https://i.imgur.com/13k6Awb.png)

![Algorithm scheme using the first variant Part8](https://i.imgur.com/g4fSZ6M.png)

![Algorithm scheme using the first variant Part9](https://i.imgur.com/rKwah1D.png)

### Code using the first variant (maze entry):
``` pascal
Program BFS;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find closest path to each еxit
}

{$APPTYPE CONSOLE}

Uses
  System.SysUtils;

Const
  Convert = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MinSizes = 4;
  MaxSizes = length(Convert);
  //Convert - storing values 1..35 to exchange between symbols and their values and vice versa
  //MinSizes - minimal allowable sizes in a labyrinth
  //MaxSizes - maximum allowable sizes in a labyrinth

Var
  Lab, Way : array [1..MaxSizes, 1..MaxSizes] of Byte;
  SizeI, SizeJ, StartI, StartJ: Byte;
  flag, IsPathFound : Boolean;
  //Lab - an array that stores the entered labyrinth
  //Way - an array that stores path to the exit
  //SizeI - entered size by lines
  //SizeJ - entered size by columns
  //StartI - start coordinates by lines
  //StartJ - start coordinates by columns
  //flag - flag to confirm the correctness of entering numbers
  //IsPathFound - indicator of whether the path is found



//Procedure for writing input data
procedure Input;
var
  LargerSize, i, j : Byte;
  StrStartCoords : string[4];
  //LargerSize - the largest value of the sizes
  //i,j - cycle counters
  //StrStartCoords - string stores the symbols value of the starting coordinates
begin
  Writeln('Enter the size of the labyrinth (i j), i and j belongs to ',MinSizes,'..',MaxSizes);

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the flag
    flag:= False;

    //Validating the correct input data type
    Try
      Readln(SizeI, SizeJ);
    Except
      Writeln('Invalid data type entered');
      flag:= True;
    End;

    //Validate Range
    if (not (SizeI in [MinSizes..MaxSizes]) or not (SizeJ in [MinSizes..MaxSizes])) and not flag then
    begin
      Writeln('(i j) do not belong to the range!');
      flag:= True;
    end;

  Until not flag;

  Writeln;
  Writeln('Enter the labyrinth. 0 - the cell is passable, 1 - the cell is impassable.');
  Writeln('Possible to move between cells that have a common side');

  //Finding the largest size
  if SizeI > SizeJ then
    LargerSize:= SizeI
  else
    LargerSize:= SizeJ;

  //If the largest size >= 10, inform the user about the replacements
  if LargerSize >= 10 then
  begin
    Writeln;
    Writeln('For convenience, numbers consisting of two digits will be represented as follows:');
    for i := 10 to LargerSize do
      Writeln(Convert[i],' = ',i);
  end;

  //Writing columns and boundaries for understanding
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write(Convert[j],' ');
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write('__');
  Writeln;

  //Cycle for reading a labyrinth (line)
  i:= 1;
  while (i <= SizeI) and not flag do
  begin

    //Write the line number
    Write(Convert[i],'|');

    //Cycle for reading a labyrinth (column)
    j:= 1;
    while (j <= SizeJ) and not flag do
    begin

      //Validating the correct input data type
      Try
        Read(Lab[i,j]);
      Except
        Writeln('Invalid data type entered! Restart the program');
        flag:= True;
      End;

      //Validate Range
      if (Lab[i,j] <> 0) and (Lab[i,j] <> 1) then
      begin
        Writeln('Number do not belong to the range! Restart the program');
        flag:= True;
      end;

      //Modernize j
      Inc(j);
    end;

    //Modernize i
    Inc(i);
  end;

  //Input validation
  if not flag then
  begin

    Writeln;
    Writeln('Enter start position (i j). This position must be in a passable cell (0)');
    Readln;

    //Cycle with postcondition for entering correct data.
    Repeat

      //Initialize the flag
      flag:= False;

      Readln(StrStartCoords);

      //Validating the correct input data type
      StartI:= Pos(StrStartCoords[1], Convert);
      StartJ:= Pos(StrStartCoords[3], Convert);
      if (StartI = 0) or (StartJ = 0) or (length(StrStartCoords) <> 3) then
      begin
        Writeln('Invalid data type entered!');
        flag:= True;
      end

      //Checking, the position must be in the labyrinth
      else if (StartI > SizeI) or (StartJ > SizeJ) then
      begin
        Writeln('Position not in the labyrinth!');
        flag:= True;
      end

      //Checking, the position must be in a passable cell
      else if Lab[StartI, StartJ] <> 0 then
      begin
        Writeln('Position not in a passable cell!');
        flag:= True;
      end;

    Until not flag ;

  end;
end;



//Procedure to writing the path
procedure PathOutput(CoordI, CoordJ: Byte);
var
  PrevNumStep: Byte;
  //PrevNumStep - previous number step in the Way
begin

  //Find the previous number step in the Way
  //to find previous coordinates in the path
  PrevNumStep:= Way[CoordI, CoordJ] - 1;

  //Looking for a path to the starting cell
  if (CoordI <> StartI) or (CoordJ <> StartJ) then
  begin
    if Way[CoordI, CoordJ-1] = PrevNumStep then
      PathOutput(CoordI, CoordJ-1)
    else if Way[CoordI-1, CoordJ] = PrevNumStep then
      PathOutput(CoordI-1, CoordJ)
    else if Way[CoordI, CoordJ+1] = PrevNumStep then
      PathOutput(CoordI, CoordJ+1)
    else if Way[CoordI+1, CoordJ] = PrevNumStep then
      PathOutput(CoordI+1, CoordJ);
  end;

  //Write coordinates
  Write('(',Convert[CoordI],',',Convert[CoordJ],') ');

end;



//Procedure for finding a path
procedure FindExitBFS(StartI, StartJ: Byte);
var
  Queue : array [1..MaxSizes*4, 1..2] of Byte;
  CoordI, CoordJ : Byte;
  AmountInQueue, AmountSameStep, CurrPosQueue, CurrNumStep, i : Byte;
  //Queue - queue cell
  //CoordI - current coordinates by i
  //CoordJ - current coordinates by j
  //AmountInQueue - amount in the queue
  //AmountSameStep - amount in the queue that have the same step number
  //CurrPosQueue - current position in the queue
  //CurrNumStep - current number step in the Way
  //i - cycle counter
begin

  //Initializing the variables
  CurrNumStep:= 1;
  CurrPosQueue:= 1;
  Queue[CurrPosQueue,1]:= StartI;
  Queue[CurrPosQueue,2]:= StartJ;
  AmountInQueue:= 1;
  AmountSameStep:= 1;

  //Cycle to review all cells
  while AmountInQueue <> 0 do
  begin

    //Checking if this cell was taken before
    for i := CurrPosQueue-1 downto 1 do
      if (Queue[CurrPosQueue,1] = Queue[i,1]) and (Queue[CurrPosQueue,2] = Queue[i,2]) then
      begin
        Queue[CurrPosQueue,1]:= 0;
        Queue[CurrPosQueue,2]:= 0;
      end;

    //If wasnt taken before, work with it
    if (Queue[CurrPosQueue,1] <> 0) and (Queue[CurrPosQueue,2] <> 0) then
    begin

      //Assign the coordinates with which work
      CoordI:= Queue[CurrPosQueue,1];
      CoordJ:= Queue[CurrPosQueue,2];

      //On the way, assign the step number to the current cell
      Way[CoordI,CoordJ]:= CurrNumStep;

      //Сhecking for an exit
      if (CoordI = 1) or (CoordJ = 1) or (CoordI = SizeI) or (CoordJ = SizeJ) then
      begin
        Writeln;

        //Output how many steps was found the exit
        Writeln('Number of steps:',CurrNumStep);

        //Turn to the procedure PathOutput to writing the path
        PathOutput(CoordI, CoordJ);
        Writeln;

        //The way is found
        IsPathFound:= True;
      end

      //Else looking for an neighboring, available and untraveled cell.
      //And if found, add to the queue
      else
      begin
        if (Lab[CoordI, CoordJ+1] = 0) and (Way[CoordI, CoordJ+1] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI;
          Queue[AmountInQueue,2]:= CoordJ+1;
        end;
        if (Lab[CoordI+1, CoordJ] = 0) and (Way[CoordI+1, CoordJ] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI+1;
          Queue[AmountInQueue,2]:= CoordJ;
        end;
        if (Lab[CoordI, CoordJ-1] = 0) and (Way[CoordI, CoordJ-1] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI;
          Queue[AmountInQueue,2]:= CoordJ-1;
        end;
        if (Lab[CoordI-1, CoordJ] = 0) and (Way[CoordI-1, CoordJ] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI-1;
          Queue[AmountInQueue,2]:= CoordJ;
        end;
      end;
    end;

    //Decrease AmountSameStep
    Dec(AmountSameStep);

    //Checking if all cells of the same step have been taken
    if AmountSameStep = 0 then
    begin

      //Shift all next step cells to the left
      for i := CurrPosQueue+1 to AmountInQueue do
      begin
        Queue[i-CurrPosQueue, 1]:= Queue[i, 1];
        Queue[i-CurrPosQueue, 2]:= Queue[i, 2];
      end;

      //Сorrecting all variables after the shift
      AmountInQueue:= AmountInQueue - CurrPosQueue;
      AmountSameStep:= AmountInQueue;
      CurrPosQueue:= 1;

      //Increasing the current number step
      Inc(CurrNumStep);

    end

    //Else increase CurrPosQueue
    else
      Inc(CurrPosQueue);

  end;

end;



Begin

  //Call the procedure to write data
  Input;

  //If the labyrinth is entered correctly, then looking for a path
  if not flag then
  begin

    //Initialize the variables and go to the procedure FindExitBFS
    IsPathFound:= False;
    FindExitBFS(StartI, StartJ);

    //Сheck if the path is found
    if not IsPathFound then
      Writeln('Entered labyrinth has no way out');
  end;

  Readln;
  Readln;
End.
```

### Code using the first variant (filling the maze randomly):
``` pascal
Program BFSrandom;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find closest path to each еxit
}

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

Const
  Convert = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MinSizes = 4;
  MaxSizes = length(Convert);
  //Convert - storing values 1..35 to exchange between symbols and their values and vice versa
  //MinSizes - minimal allowable sizes in a labyrinth
  //MaxSizes - maximum allowable sizes in a labyrinth

Var
  Lab, Way : array [1..MaxSizes, 1..MaxSizes] of Byte;
  SizeI, SizeJ, StartI, StartJ: Byte;
  //Lab - an array that stores the entered labyrinth
  //Way - an array that stores path to the exit
  //SizeI - entered size by lines
  //SizeJ - entered size by columns
  //StartI - start coordinates by lines
  //StartJ - start coordinates by columns



//Procedure for generating a labyrinth
procedure Generator;
var
  LargerSize, i, j, PickResult, CoordI, CoordJ, AmountRotations, AmountStep : Byte;
  flag, isBorder: Boolean;
  //LargerSize - the largest value of the sizes
  //i,j - cycle counters
  //PickResult a random number that decides which step to take
  //CoordI - current position in i
  //CoordJ - current position in j
  //AmountRotations - amount of rotations to complete the labyrinth
  //AmountStep - amount of steps to be taken along a given line
  //flag - flag to confirm the correctness of entering numbers
  //isBorder - indicator of hitting the border
begin
  Writeln('Enter the size of the labyrinth (i j), i and j belongs to ',MinSizes,'..',MaxSizes);

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the flag
    flag:= False;

    //Validating the correct input data type
    Try
      Readln(SizeI, SizeJ);
    Except
      Writeln('Invalid data type entered');
      flag:= True;
    End;

    //Validate Range
    if ((SizeI < MinSizes) or (SizeJ < MinSizes) or (SizeI > MaxSizes) or (SizeJ > MaxSizes)) and not flag then
    begin
      Writeln('(i j) do not belong to the range!');
      flag:= True;
    end;

  Until not flag;

  //Finding the largest size
  if SizeI > SizeJ then
    LargerSize:= SizeI
  else
    LargerSize:= SizeJ;

  //If the largest size >= 10, inform the user about the replacements
  if LargerSize >= 10 then
  begin
    Writeln;
    Writeln('For convenience, numbers consisting of two digits will be represented as follows:');
    for i := 10 to LargerSize do
      Writeln(Convert[i],' = ',i);
  end;

  //Fill the whole labyrinth with impassable cells
  for i := 1 to SizeI do
    for j := 1 to SizeJ do
      Lab[i,j]:= 1;

  Randomize;

  //Generate which side will be the first finish
  PickResult:= 1 + Random(4);

  //Define
  case PickResult of

    //Up side
    1:
    begin

      //Generating a passable cell on the up side
      CoordI:= 1;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - down
      PickResult:= 2;
    end;

    //Left side
    2:
    begin

      //Generating a passable cell on the left side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= 1;

      //The first direction in which will go - right
      PickResult:= 1;
    end;

    //Down side
    3:
    begin

      //Generating a passable cell on the down side
      CoordI:= SizeI;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - up
      PickResult:= 4;
    end;

    //Right side
    4:
    begin

      //Generating a passable cell on the right side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= SizeJ;

      //The first direction in which will go - left
      PickResult:= 3;
    end;

  end;

  //Make the first finish passable
  Lab[CoordI, CoordJ]:= 0;

  //Generate the amount of rotations to complete the labyrinth
  AmountRotations:= SizeI + SizeJ + Random(SizeI + SizeJ);

  //Going AmountRotations times
  for i := 1 to AmountRotations do
  begin

    //Reset isBorder
    isBorder:= False;

    //Defining the rotation
    case PickResult of

      //Right
      1:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the right
          CoordJ:= CoordJ + 1;

          //Check if the border is reached
          if CoordJ = SizeJ then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin
          
            //check whether there are passable cells above or below (so as not to mold passable 
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Down
      2:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the down
          CoordI:= CoordI + 1;

          //Check if the border is reached
          if CoordI = SizeI then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable 
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Left
      3:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the left
          CoordJ:= CoordJ - 1;

          //Check if the border is reached
          if CoordJ = 1 then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells above or below (so as not to mold passable 
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Up
      4:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the up
          CoordI:= CoordI - 1;

          //Check if the border is reached
          if CoordI = 1 then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable 
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;
      
    end;

    //Choosing the next rotation
    PickResult:= 1 + Random(4);

  end;

  //Make the last point the starting point
  StartI:= CoordI;
  StartJ:= CoordJ;

  Writeln('Starting position - (',Convert[StartI],',',Convert[StartJ],')');

  //Writing columns and boundaries for understanding
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write(Convert[j],' ');
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write('__');
  Writeln;

  //Displaying the labyrinth
  for i := 1 to SizeI do
  begin
    Write(Convert[i],'|');
    for j := 1 to SizeJ do
      Write(Lab[i,j],' ');
    Writeln;
  end;

end;



//Procedure to writing the path
procedure PathOutput(CoordI, CoordJ: Byte);
var
  PrevNumStep: Byte;
  //PrevNumStep - previous number step in the Way
begin

  //Find the previous number step in the Way
  //to find previous coordinates in the path
  PrevNumStep:= Way[CoordI, CoordJ] - 1;

  //Looking for a path to the starting cell
  if (CoordI <> StartI) or (CoordJ <> StartJ) then
  begin
    if Way[CoordI, CoordJ-1] = PrevNumStep then
      PathOutput(CoordI, CoordJ-1)
    else if Way[CoordI-1, CoordJ] = PrevNumStep then
      PathOutput(CoordI-1, CoordJ)
    else if Way[CoordI, CoordJ+1] = PrevNumStep then
      PathOutput(CoordI, CoordJ+1)
    else if Way[CoordI+1, CoordJ] = PrevNumStep then
      PathOutput(CoordI+1, CoordJ);
  end;

  //Write coordinates
  Write('(',Convert[CoordI],',',Convert[CoordJ],') ');

end;



//Procedure for finding a path
procedure FindExitBFS(StartI, StartJ: Byte);
var
  Queue : array [1..MaxSizes*4, 1..2] of Byte;
  CoordI, CoordJ : Byte;
  AmountInQueue, AmountSameStep, CurrPosQueue, CurrNumStep, i : Byte;
  //Queue - queue cell
  //CoordI - current coordinates by i
  //CoordI - current coordinates by j
  //AmountInQueue - amount in the queue
  //AmountSameStep - amount in the queue that have the same step number
  //CurrPosQueue - current position in the queue
  //CurrNumStep - current number step in the Way
  //i - cycle counter
begin

  //Initializing the variables
  CurrNumStep:= 1;
  CurrPosQueue:= 1;
  Queue[CurrPosQueue,1]:= StartI;
  Queue[CurrPosQueue,2]:= StartJ;
  AmountInQueue:= 1;
  AmountSameStep:= 1;

  //Cycle to review all cells
  while AmountInQueue <> 0 do
  begin

    //Checking if this cell was taken before
    for i := CurrPosQueue-1 downto 1 do
      if (Queue[CurrPosQueue,1] = Queue[i,1]) and (Queue[CurrPosQueue,2] = Queue[i,2]) then
      begin
        Queue[CurrPosQueue,1]:= 0;
        Queue[CurrPosQueue,2]:= 0;
      end;

    //If wasnt taken before, work with it
    if (Queue[CurrPosQueue,1] <> 0) and (Queue[CurrPosQueue,2] <> 0) then
    begin

      //Assign the coordinates with which work
      CoordI:= Queue[CurrPosQueue,1];
      CoordJ:= Queue[CurrPosQueue,2];

      //On the way, assign the step number to the current cell
      Way[CoordI,CoordJ]:= CurrNumStep;

      //Сhecking for an exit
      if (CoordI = 1) or (CoordJ = 1) or (CoordI = SizeI) or (CoordJ = SizeJ) then
      begin
        Writeln;

        //Output how many steps was found the exit
        Writeln('Number of steps:',CurrNumStep);

        //Turn to the procedure PathOutput to writing the path
        PathOutput(CoordI, CoordJ);
        Writeln;

      end

      //Else looking for an neighboring, available and untraveled cell.
      //And if found, add to the queue
      else
      begin
        if (Lab[CoordI, CoordJ+1] = 0) and (Way[CoordI, CoordJ+1] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI;
          Queue[AmountInQueue,2]:= CoordJ+1;
        end;
        if (Lab[CoordI+1, CoordJ] = 0) and (Way[CoordI+1, CoordJ] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI+1;
          Queue[AmountInQueue,2]:= CoordJ;
        end;
        if (Lab[CoordI, CoordJ-1] = 0) and (Way[CoordI, CoordJ-1] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI;
          Queue[AmountInQueue,2]:= CoordJ-1;
        end;
        if (Lab[CoordI-1, CoordJ] = 0) and (Way[CoordI-1, CoordJ] = 0) then
        begin
          Inc(AmountInQueue);
          Queue[AmountInQueue,1]:= CoordI-1;
          Queue[AmountInQueue,2]:= CoordJ;
        end;
      end;
    end;

    //Decrease AmountSameStep
    Dec(AmountSameStep);

    //Checking if all cells of the same step have been taken
    if AmountSameStep = 0 then
    begin

      //Shift all next step cells to the left
      for i := CurrPosQueue+1 to AmountInQueue do
      begin
        Queue[i-CurrPosQueue, 1]:= Queue[i, 1];
        Queue[i-CurrPosQueue, 2]:= Queue[i, 2];
      end;

      //Сorrecting all variables after the shift
      AmountInQueue:= AmountInQueue - CurrPosQueue;
      AmountSameStep:= AmountInQueue;
      CurrPosQueue:= 1;

      //Increasing the current number step
      Inc(CurrNumStep);

    end

    //Else increase CurrPosQueue
    else
      Inc(CurrPosQueue);

  end;

end;



Begin

  //Call the procedure to generate labyrinth
  Generator;

  //Initialize the variables and go to the procedure FindExitBFS
  FindExitBFS(StartI, StartJ);

  Readln;
End.
```
---

### Algorithm scheme the second variant (maze entry):

![Algorithm scheme using the second variant Part1](https://i.imgur.com/mDhjr1G.png)

![Algorithm scheme using the second variant Part2](https://i.imgur.com/ORimm8F.png)

![Algorithm scheme using the second variant Part3](https://i.imgur.com/TyB0xJh.png)

![Algorithm scheme using the second variant Part4](https://i.imgur.com/2xzCa4d.png)

### Code using the second variant (maze entry):
``` pascal
Program DFS;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find all possible exits
}

{$APPTYPE CONSOLE}

Uses
  System.SysUtils;

Const
  Convert = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MinSizes = 4;
  MaxSizes = length(Convert);
  //Convert - storing values 1..35 to exchange between symbols and their values and vice versa
  //MinSizes - minimal allowable sizes in a labyrinth
  //MaxSizes - maximum allowable sizes in a labyrinth

Var
  Lab : array [1..MaxSizes, 1..MaxSizes] of Byte;
  ExitCoords : array [1..(sqr(MaxSizes) div 2), 1..2] of Byte;
  StartI, StartJ, SizeI, SizeJ, CurrNumStep, k : Byte;
  flag, IsPathFound : Boolean;
  //Lab - an array that stores the entered labyrinth
  //ExitCoords - an array which stores exit coordinates
  //StartI - start coordinates by lines
  //StartJ - start coordinates by columns
  //SizeI - entered size by lines
  //SizeJ - entered size by columns
  //CurrNumStep - current number step in the Way
  //k - cycle counter
  //flag - flag to confirm the correctness of entering numbers
  //IsPathFound - indicator of whether the path is found



//Procedure for writing input data
procedure Input;
var
  LargerSize, i, j : Byte;
  StrStartCoords : string[4];
  //LargerSize - the largest value of the sizes
  //i,j - cycle counters
  //StrStartCoords - string stores the symbols value of the starting coordinates
begin

  Writeln('Enter the size of the labyrinth (i j), i and j belongs to ',MinSizes,'..',MaxSizes);

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the flag
    flag:= False;

    //Validating the correct input data type
    Try
      Readln(SizeI, SizeJ);
    Except
      Writeln('Invalid data type entered');
      flag:= True;
    End;

    //Validate Range
    if (not (SizeI in [MinSizes..MaxSizes]) or not (SizeJ in [MinSizes..MaxSizes])) and not flag then
    begin
      Writeln('(i j) do not belong to the range!');
      flag:= True;
    end;

  Until not flag;

  Writeln;
  Writeln('Enter the labyrinth. 0 - the cell is passable, 1 - the cell is impassable.');
  Writeln('Possible to move between cells that have a common side');

  //Finding the largest size
  if SizeI > SizeJ then
    LargerSize:= SizeI
  else
    LargerSize:= SizeJ;

  //If the largest size >= 10, inform the user about the replacements
  if LargerSize >= 10 then
  begin
    Writeln;
    Writeln('For convenience, numbers consisting of two digits will be represented as follows:');
    for i := 10 to LargerSize do
      Writeln(Convert[i],' = ',i);
  end;

  //Writing columns and boundaries for understanding
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write(Convert[j],' ');
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write('__');
  Writeln;

  //Cycle for reading a labyrinth (line)
  i:= 1;
  while (i <= SizeI) and not flag do
  begin

    //Write the line number
    Write(Convert[i],'|');

    //Cycle for reading a labyrinth (column)
    j:= 1;
    while (j <= SizeJ) and not flag do
    begin

      //Validating the correct input data type
      Try
        Read(Lab[i,j]);
      Except
        Writeln('Invalid data type entered! Restart the program');
        flag:= True;
      End;

      //Validate Range
      if (Lab[i,j] <> 0) and (Lab[i,j] <> 1) then
      begin
        Writeln('Number do not belong to the range! Restart the program');
        flag:= True;
      end;

      //Modernize j
      Inc(j);
    end;

    //Modernize i
    Inc(i);
  end;

  //Input validation
  if not flag then
  begin

    Writeln;
    Writeln('Enter start position (i j). This position must be in a passable cell (0)');
    Readln;

    //Cycle with postcondition for entering correct data.
    Repeat

      //Initialize the flag
      flag:= False;

      Readln(StrStartCoords);

      //Validating the correct input data type
      StartI:= Pos(StrStartCoords[1], Convert);
      StartJ:= Pos(StrStartCoords[3], Convert);
      if (StartI = 0) or (StartJ = 0) or (length(StrStartCoords) <> 3) then
      begin
        Writeln('Invalid data type entered!');
        flag:= True;
      end

      //Checking, the position must be in the labyrinth
      else if (StartI > SizeI) or (StartJ > SizeJ) then
      begin
        Writeln('Position not in the labyrinth!');
        flag:= True;
      end

      //Checking, the position must be in a passable cell
      else if Lab[StartI, StartJ] <> 0 then
      begin
        Writeln('Position not in a passable cell!');
        flag:= True;
      end;

    Until not flag ;

  end;
end;



//Procedure for finding a path
procedure FindExitDFS(CoordI, CoordJ: Byte);
begin

  //Increase CurrNumStep and mark the passed cell and add the coordinates to ExitCoords
  Inc(CurrNumStep);
  Lab[CoordI,CoordJ]:= 1;
  ExitCoords[CurrNumStep, 1]:= CoordI;
  ExitCoords[CurrNumStep, 2]:= CoordJ;

  //Сhecking for an exit
  if (CoordI = 1) or (CoordJ = 1) or (CoordI = SizeI) or (CoordJ = SizeJ) then
  begin
    Writeln;

    //Output how many steps was found the exit
    Writeln('Number of steps:',CurrNumStep);

    //Writing the path
    for k := 1 to CurrNumStep do
      Write('(',Convert[ExitCoords[k, 1]],',',Convert[ExitCoords[k, 2]],') ');

    Writeln;

    //The way is found
    IsPathFound:= True;
  end

  //Else looking for an neighboring, available and untraveled cell.
  //And if found, go into it
  else
  begin
    if Lab[CoordI, CoordJ+1] = 0 then
      FindExitDFS(CoordI, CoordJ+1);
    if Lab[CoordI+1, CoordJ] = 0 then
      FindExitDFS(CoordI+1, CoordJ);
    if Lab[CoordI, CoordJ-1] = 0 then
      FindExitDFS(CoordI, CoordJ-1);
    if Lab[CoordI-1, CoordJ] = 0 then
      FindExitDFS(CoordI-1, CoordJ);
  end;

  //Next, decrease Dec, reset the current coordinates in the Way
  //and exit the current cell to the previous
  Dec(CurrNumStep);
  Lab[CoordI,CoordJ]:= 0;

end;



Begin

  //Call the procedure to write data
  Input;

  //If the labyrinth is entered correctly, then looking for a path
  if not flag then
  begin

    //Initialize the variables and go to the procedure FindExitDFS
    CurrNumStep:= 0;
    IsPathFound:= False;
    FindExitDFS(StartI, StartJ);

    //Сheck if the path is found
    if not IsPathFound then
      Writeln('Entered labyrinth has no way out');
  end;

  Readln;
  Readln;
End.
```

### Code using the second variant (filling the maze randomly):
``` pascal
Program DFSrandom;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find all possible exits
}

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

Const
  Convert = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MinSizes = 4;
  MaxSizes = length(Convert);
  //Convert - storing values 1..35 to exchange between symbols and their values and vice versa
  //MinSizes - minimal allowable sizes in a labyrinth
  //MaxSizes - maximum allowable sizes in a labyrinth

Var
  Lab: array [1..MaxSizes, 1..MaxSizes] of Byte;
  ExitCoords : array [1..(sqr(MaxSizes) div 2), 1..2] of Byte;
  StartI, StartJ, SizeI, SizeJ, CurrNumStep, k : Byte;
  //Lab - an array that stores the entered labyrinth
  //ExitCoords - an array which stores exit coordinates
  //StartI - start coordinates by lines
  //StartJ - start coordinates by columns
  //SizeI - entered size by lines
  //SizeJ - entered size by columns
  //CurrNumStep - current number step in the Way
  //k - cycle counter



//Procedure for generating a labyrinth
procedure Generator;
var
  LargerSize, i, j, PickResult, CoordI, CoordJ, AmountRotations, AmountStep : Byte;
  flag, isBorder: Boolean;
  //LargerSize - the largest value of the sizes
  //i,j - cycle counters
  //PickResult a random number that decides which step to take
  //CoordI - current position in i
  //CoordJ - current position in j
  //AmountRotations - amount of rotations to complete the labyrinth
  //AmountStep - amount of steps to be taken along a given line
  //flag - flag to confirm the correctness of entering numbers
  //isBorder - indicator of hitting the border
begin
  Writeln('Enter the size of the labyrinth (i j), i and j belongs to ',MinSizes,'..',MaxSizes);

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the flag
    flag:= False;

    //Validating the correct input data type
    Try
      Readln(SizeI, SizeJ);
    Except
      Writeln('Invalid data type entered');
      flag:= True;
    End;

    //Validate Range
    if ((SizeI < MinSizes) or (SizeJ < MinSizes) or (SizeI > MaxSizes) or (SizeJ > MaxSizes)) and not flag then
    begin
      Writeln('(i j) do not belong to the range!');
      flag:= True;
    end;

  Until not flag;

  //Finding the largest size
  if SizeI > SizeJ then
    LargerSize:= SizeI
  else
    LargerSize:= SizeJ;

  //If the largest size >= 10, inform the user about the replacements
  if LargerSize >= 10 then
  begin
    Writeln;
    Writeln('For convenience, numbers consisting of two digits will be represented as follows:');
    for i := 10 to LargerSize do
      Writeln(Convert[i],' = ',i);
  end;

  //Fill the whole labyrinth with impassable cells
  for i := 1 to SizeI do
    for j := 1 to SizeJ do
      Lab[i,j]:= 1;

  Randomize;

  //Generate which side will be the first finish
  PickResult:= 1 + Random(4);

  //Define
  case PickResult of

    //Up side
    1:
    begin

      //Generating a passable cell on the up side
      CoordI:= 1;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - down
      PickResult:= 2;
    end;

    //Left side
    2:
    begin

      //Generating a passable cell on the left side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= 1;

      //The first direction in which will go - right
      PickResult:= 1;
    end;

    //Down side
    3:
    begin

      //Generating a passable cell on the down side
      CoordI:= SizeI;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - up
      PickResult:= 4;
    end;

    //Right side
    4:
    begin

      //Generating a passable cell on the right side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= SizeJ;

      //The first direction in which will go - left
      PickResult:= 3;
    end;

  end;

  //Make the first finish passable
  Lab[CoordI, CoordJ]:= 0;

  //Generate the amount of rotations to complete the labyrinth
  AmountRotations:= SizeI + SizeJ + Random(SizeI + SizeJ);

  //Going AmountRotations times
  for i := 1 to AmountRotations do
  begin

    //Reset isBorder
    isBorder:= False;

    //Defining the rotation
    case PickResult of

      //Right
      1:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the right
          CoordJ:= CoordJ + 1;

          //Check if the border is reached
          if CoordJ = SizeJ then
          begin
            if Random(20) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells above or below (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Down
      2:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the down
          CoordI:= CoordI + 1;

          //Check if the border is reached
          if CoordI = SizeI then
          begin
            if Random(20) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Left
      3:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the left
          CoordJ:= CoordJ - 1;

          //Check if the border is reached
          if CoordJ = 1 then
          begin
            if Random(20) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells above or below (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Up
      4:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the up
          CoordI:= CoordI - 1;

          //Check if the border is reached
          if CoordI = 1 then
          begin
            if Random(20) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

    end;

    //Choosing the next rotation
    PickResult:= 1 + Random(4);

  end;

  //Make the last point the starting point
  StartI:= CoordI;
  StartJ:= CoordJ;

  Writeln('Starting position - (',Convert[StartI],',',Convert[StartJ],')');

  //Writing columns and boundaries for understanding
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write(Convert[j],' ');
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write('__');
  Writeln;

  //Displaying the labyrinth
  for i := 1 to SizeI do
  begin
    Write(Convert[i],'|');
    for j := 1 to SizeJ do
      Write(Lab[i,j],' ');
    Writeln;
  end;

end;



//Procedure for finding a path
procedure FindExitDFS(CoordI, CoordJ: Byte);
begin

  //Increase CurrNumStep and mark the passed cell and add the coordinates to ExitCoords
  Inc(CurrNumStep);
  Lab[CoordI,CoordJ]:= 1;
  ExitCoords[CurrNumStep, 1]:= CoordI;
  ExitCoords[CurrNumStep, 2]:= CoordJ;

  //Сhecking for an exit
  if (CoordI = 1) or (CoordJ = 1) or (CoordI = SizeI) or (CoordJ = SizeJ) then
  begin
    Writeln;

    //Output how many steps was found the exit
    Writeln('Number of steps:',CurrNumStep);

    //Writing the path
    for k := 1 to CurrNumStep do
      Write('(',Convert[ExitCoords[k, 1]],',',Convert[ExitCoords[k, 2]],') ');

    Writeln;
  end

  //Else looking for an neighboring, available and untraveled cell.
  //And if found, go into it
  else
  begin
    if Lab[CoordI, CoordJ+1] = 0 then
      FindExitDFS(CoordI, CoordJ+1);
    if Lab[CoordI+1, CoordJ] = 0 then
      FindExitDFS(CoordI+1, CoordJ);
    if Lab[CoordI, CoordJ-1] = 0 then
      FindExitDFS(CoordI, CoordJ-1);
    if Lab[CoordI-1, CoordJ] = 0 then
      FindExitDFS(CoordI-1, CoordJ);
  end;

  //Next, decrease Dec, reset the current coordinates in the Way
  //and exit the current cell to the previous
  Dec(CurrNumStep);
  Lab[CoordI,CoordJ]:= 0;

end;



Begin

  //Call the procedure to generate labyrinth
  Generator;


  //Initialize the variables and go to the procedure FindExitDFS
  CurrNumStep:= 0;
  FindExitDFS(StartI, StartJ);

  Readln(SizeI);
End.
```
---
### Code using the third variant (filling the maze randomly):
``` pascal
Program DijkstraRandom;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find closest way
}

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

Const
  Convert = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MinSizes = 4;
  MaxSizes = length(Convert);
  //Convert - storing values 1..35 to exchange between symbols and their values and vice versa
  //MinSizes - minimal allowable sizes in a labyrinth
  //MaxSizes - maximum allowable sizes in a labyrinth

Var
  Lab, Way : array [1..MaxSizes, 1..MaxSizes] of Byte;
  SizeI, SizeJ, StartI, StartJ, i, j : Byte;
  CurrNumStep, CoordExitI, CoordExitJ : Byte;
  //Lab - an array that stores the entered labyrinth
  //Way - an array that stores path to the exit
  //SizeI - entered size by lines
  //SizeJ - entered size by columns
  //StartI - start coordinates by lines
  //StartJ - start coordinates by columns
  //i,j - cycle counters
  //CurrNumStep - current number step in the Way
  //CoordExitI - nearest exit coordinate (i)
  //CoordExitJ - nearest exit coordinate (j)



//Procedure for generating a labyrinth
procedure Generator;
var
  LargerSize, i, j, PickResult, CoordI, CoordJ, AmountRotations, AmountStep : Byte;
  flag, isBorder: Boolean;
  //LargerSize - the largest value of the sizes
  //i,j - cycle counters
  //PickResult a random number that decides which step to take
  //CoordI - current position in i
  //CoordJ - current position in j
  //AmountRotations - amount of rotations to complete the labyrinth
  //AmountStep - amount of steps to be taken along a given line
  //flag - flag to confirm the correctness of entering numbers
  //isBorder - indicator of hitting the border
begin
  Writeln('Enter the size of the labyrinth (i j), i and j belongs to ',MinSizes,'..',MaxSizes);

  //Cycle with postcondition for entering correct data.
  Repeat

    //Initialize the flag
    flag:= False;

    //Validating the correct input data type
    Try
      Readln(SizeI, SizeJ);
    Except
      Writeln('Invalid data type entered');
      flag:= True;
    End;

    //Validate Range
    if ((SizeI < MinSizes) or (SizeJ < MinSizes) or (SizeI > MaxSizes) or (SizeJ > MaxSizes)) and not flag then
    begin
      Writeln('(i j) do not belong to the range!');
      flag:= True;
    end;

  Until not flag;

  //Finding the largest size
  if SizeI > SizeJ then
    LargerSize:= SizeI
  else
    LargerSize:= SizeJ;

  //If the largest size >= 10, inform the user about the replacements
  if LargerSize >= 10 then
  begin
    Writeln;
    Writeln('For convenience, numbers consisting of two digits will be represented as follows:');
    for i := 10 to LargerSize do
      Writeln(Convert[i],' = ',i);
  end;

  //Fill the whole labyrinth with impassable cells
  for i := 1 to SizeI do
    for j := 1 to SizeJ do
      Lab[i,j]:= 1;

  Randomize;

  //Generate which side will be the first finish
  PickResult:= 1 + Random(4);

  //Define
  case PickResult of

    //Up side
    1:
    begin

      //Generating a passable cell on the up side
      CoordI:= 1;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - down
      PickResult:= 2;
    end;

    //Left side
    2:
    begin

      //Generating a passable cell on the left side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= 1;

      //The first direction in which will go - right
      PickResult:= 1;
    end;

    //Down side
    3:
    begin

      //Generating a passable cell on the down side
      CoordI:= SizeI;
      CoordJ:= Random(SizeJ-2)+2;

      //The first direction in which will go - up
      PickResult:= 4;
    end;

    //Right side
    4:
    begin

      //Generating a passable cell on the right side
      CoordI:= Random(SizeI-2)+2;
      CoordJ:= SizeJ;

      //The first direction in which will go - left
      PickResult:= 3;
    end;

  end;

  //Make the first finish passable
  Lab[CoordI, CoordJ]:= 0;

  //Generate the amount of rotations to complete the labyrinth
  AmountRotations:= SizeI + SizeJ + Random(SizeI + SizeJ);

  //Going AmountRotations times
  for i := 1 to AmountRotations do
  begin

    //Reset isBorder
    isBorder:= False;

    //Defining the rotation
    case PickResult of

      //Right
      1:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the right
          CoordJ:= CoordJ + 1;

          //Check if the border is reached
          if CoordJ = SizeJ then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells above or below (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Down
      2:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the down
          CoordI:= CoordI + 1;

          //Check if the border is reached
          if CoordI = SizeI then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI - 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Left
      3:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeJ div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the left
          CoordJ:= CoordJ - 1;

          //Check if the border is reached
          if CoordJ = 1 then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordJ:= CoordJ + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells above or below (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI+1, CoordJ] = 0 then
            begin
              CoordI:= CoordI - 1;
              CoordJ:= CoordJ + 1;
              if CoordI = 1 then
              begin
                CoordI:= CoordI + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI-1, CoordJ] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordI = SizeI then
              begin
                CoordI:= CoordI - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

      //Up
      4:
      begin

        //Generate amount of steps
        AmountStep:= 1 + Random(SizeI div 2);

        //Going AmountStep times or until hit the border
        j:= 1;
        while (j <= AmountStep) and not isBorder do
        begin

          //Going one step to the up
          CoordI:= CoordI - 1;

          //Check if the border is reached
          if CoordI = 1 then
          begin
            if Random(15) = 0 then
              Lab[CoordI, CoordJ]:= 0;
            CoordI:= CoordI + 1;
            isBorder:= True;
          end

          //Checking if the cell is impassable now
          else if Lab[CoordI, CoordJ] = 1 then
          begin

            //check whether there are passable cells left or right (so as not to mold passable
            //cells). If there is, change the coordinates and check for reaching the border
            if Lab[CoordI, CoordJ+1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ - 1;
              if CoordJ = 1 then
              begin
                CoordJ:= CoordJ + 1;
                isBorder:= True;
              end;
            end
            else if Lab[CoordI, CoordJ-1] = 0 then
            begin
              CoordI:= CoordI + 1;
              CoordJ:= CoordJ + 1;
              if CoordJ = SizeJ then
              begin
                CoordJ:= CoordJ - 1;
                isBorder:= True;
              end;
            end;

            //Make the current position to the passable
            Lab[CoordI, CoordJ]:= 0;
          end;

          //Modernize j
          Inc(j);
        end;
      end;

    end;

    //Choosing the next rotation
    PickResult:= 1 + Random(4);

  end;

  //Make the last point the starting point
  StartI:= CoordI;
  StartJ:= CoordJ;

  Writeln('Starting position - (',Convert[StartI],',',Convert[StartJ],')');

  //Writing columns and boundaries for understanding
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write(Convert[j],' ');
  Writeln;
  Write('  ');
  for j := 1 to SizeJ do
    Write('__');
  Writeln;

  //Displaying the labyrinth
  for i := 1 to SizeI do
  begin
    Write(Convert[i],'|');
    for j := 1 to SizeJ do
      Write(Lab[i,j],' ');
    Writeln;
  end;

end;



//Procedure to writing the path
procedure PathOutput(CoordI, CoordJ: Byte);
var
  PrevNumStep: Byte;
  //PrevNumStep - previous number step in the Way
begin

  //Find the previous number step in the Way
  //to find previous coordinates in the path
  PrevNumStep:= Way[CoordI, CoordJ] - 1;

  //Looking for a path to the starting cell
  if (CoordI <> StartI) or (CoordJ <> StartJ) then
  begin
    if Way[CoordI, CoordJ-1] = PrevNumStep then
      PathOutput(CoordI, CoordJ-1)
    else if Way[CoordI-1, CoordJ] = PrevNumStep then
      PathOutput(CoordI-1, CoordJ)
    else if Way[CoordI, CoordJ+1] = PrevNumStep then
      PathOutput(CoordI, CoordJ+1)
    else if Way[CoordI+1, CoordJ] = PrevNumStep then
      PathOutput(CoordI+1, CoordJ);
  end;

  //Write coordinates
  Write('(',Convert[CoordI],',',Convert[CoordJ],') ');

end;



//Procedure for finding a path
procedure DijkstraClosestWay(CoordI, CoordJ: Byte);
var
  NextNumStep: Byte;
  //NextNumStep - next number step in the Way
begin

  //Increase CurrNumStep and add it to the array Way at the current coordinates
  Inc(CurrNumStep);
  NextNumStep:= CurrNumStep + 1;
  Way[CoordI,CoordJ]:= CurrNumStep;

  //Сhecking for a nearest exit
  if ((CoordI = 1) or (CoordJ = 1) or (CoordI = SizeI) or (CoordJ = SizeJ)) and (CurrNumStep < Way[CoordExitI,CoordExitJ]) then
  begin
    CoordExitI:= CoordI;
    CoordExitJ:= CoordJ;
  end

  //Else looking for an neighboring, available cell.
  //Also look for the shortest path to the cell. And if found, go into it
  else
  begin
    if (Lab[CoordI, CoordJ+1] = 0) and (Way[CoordI, CoordJ+1] > NextNumStep) then
      DijkstraClosestWay(CoordI, CoordJ+1);
    if (Lab[CoordI+1, CoordJ] = 0) and (Way[CoordI+1, CoordJ] > NextNumStep) then
      DijkstraClosestWay(CoordI+1, CoordJ);
    if (Lab[CoordI, CoordJ-1] = 0) and (Way[CoordI, CoordJ-1] > NextNumStep) then
      DijkstraClosestWay(CoordI, CoordJ-1);
    if (Lab[CoordI-1, CoordJ] = 0) and (Way[CoordI-1, CoordJ] > NextNumStep) then
      DijkstraClosestWay(CoordI-1, CoordJ);
  end;

  //Next, decrease Dec and exit the current cell to the previous
  Dec(CurrNumStep);

end;



Begin

  //Call the procedure to generate labyrinth
  Generator;

  //According to Dijkstra's algorithm, assume that initially all cells
  //can be reached by an infinitely long path
  for i := 1 to SizeI do
    for j := 1 to SizeJ do
      Way[i,j]:= 255;

  //Also assume that initially the exit coordinates are 1,1 (since this cell
  //in the labyrinth does not make sense) so that the path length is infinitely large
  CoordExitI:= 1;
  CoordExitJ:= 1;

  //Initialize the variables and go to the procedure DijkstraClosestWay
  CurrNumStep:= 0;
  DijkstraClosestWay(StartI, StartJ);

  //Write the result
  Writeln('Found the nearest way. Amount of steps: ',Way[CoordExitI,CoordExitJ]);
  PathOutput(CoordExitI, CoordExitJ);

  Readln(i);
End.
```