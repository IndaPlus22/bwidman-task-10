% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).

% Reads a file and retrieves the Board from it.
load_board(BoardFileName, Board) :-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen.                   % Closes the io-stream

% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
is_alive(Row, Column, Board) :-
    nth1_2d(Row, Column, Board, Stone),     % Get stone at x,y
    pathfind(Row, Column, Board, Stone, []).

% Checks if any surrounding stone is empty
liberty(Row, Column, Board, e) :-
    Up is Row - 1,
    Down is Row + 1,
    Left is Column - 1,
    Right is Column + 1,
    (nth1_2d(Up, Column, Board, e);
    nth1_2d(Down, Column, Board, e);
    nth1_2d(Row, Left, Board, e);
    nth1_2d(Row, Right, Board, e)),
    !.

pathfind(Row, Column, Board, Stone, Visited) :-
    \+ member((Row, Column), Visited),          % Make sure cell has not already been checked
    append(Visited, (Row, Column), NewVisited), % Add current cell to list of visited cells

    liberty(Row, Column, Board, e);         % Check for empty slot around stone
    (nth1_2d(Row, Column, Board, Stone),    % Check if new slot is same color (redundant on first iteration)
    Up is Row - 1,
    Down is Row + 1,
    Left is Column - 1,
    Right is Column + 1,
    % Branch in all orthogonal directions
    pathfind(Up, Column, Board, Stone, NewVisited);
    pathfind(Down, Column, Board, Stone, NewVisited);
    pathfind(Row, Left, Board, Stone, NewVisited);
    pathfind(Row, Right, Board, Stone, NewVisited)).

main(Row, Column) :-
    load_board('alive_example.txt', Board),     % Load example
    is_alive(Row, Column, Board).