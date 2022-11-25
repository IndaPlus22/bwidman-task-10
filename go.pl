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
    liberty(Row, Column, Board, Stone).

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
liberty(Row, Column, Board, Stone) :-
    liberty(Row, Column, Board, e);         % Check for empty slot around stone
    (nth1_2d(Row, Column, Board, Stone),    % Check if new slot if same color (redundant on first iteration)
    Up is Row - 1,
    Down is Row + 1,
    Left is Column - 1,
    Right is Column + 1,
    liberty(Up, Column, Board, Stone);
    liberty(Down, Column, Board, Stone);
    liberty(Row, Left, Board, Stone);
    liberty(Row, Right, Board, Stone)).

main(Row, Column) :-
    load_board('alive_example.txt', Board),     % Load example
    is_alive(Row, Column, Board).