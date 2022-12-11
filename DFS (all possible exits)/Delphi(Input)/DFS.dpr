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

  //Ñhecking for an exit
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

    //Ñheck if the path is found
    if not IsPathFound then
      Writeln('Entered labyrinth has no way out');
  end;

  Readln;
  Readln;
End.
