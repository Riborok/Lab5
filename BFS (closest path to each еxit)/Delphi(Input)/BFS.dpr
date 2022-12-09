Program BFS;
{
 Enter the labyrinth, 0 - the cell is passable, 1 - the cell is impassable.
 Possible to move between cells that have a common side. Find closest path to each åxit
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

      //Ñhecking for an exit
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

      //Ñorrecting all variables after the shift
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

    //Ñheck if the path is found
    if not IsPathFound then
      Writeln('Entered labyrinth has no way out');
  end;

  Readln;
  Readln;
End.
