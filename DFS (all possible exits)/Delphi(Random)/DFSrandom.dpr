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
