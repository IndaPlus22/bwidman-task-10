% Load example
load_board('alive_example.txt', B).

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
    nth1_2d(Row, Column, Board, Stone),
    group(Row, Column, Board, Stone).

group(_, _, _, e).
group(Row, Column, Board, Stone):-
    nth1_2d(Row - 1, Column, Board, Stone);
    nth1_2d(Row + 1, Column, Board, Stone);
    nth1_2d(Row, Column - 1, Board, Stone);
    nth1_2d(Row, Column + 1, Board, Stone);
    group(Row, Column, Board, e).