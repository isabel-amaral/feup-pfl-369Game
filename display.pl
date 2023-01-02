% display_points(+GameState)
% Displays the points of each player according to GameState
display_points(GameState) :-
    nl,
    value(GameState, w, WPoints),
    value(GameState, b, BPoints),
    write('Points:'), nl,
    write('White Pieces: '), 
    write(WPoints), nl,
    write('Black Pieces: '), 
    write(BPoints), nl.

% display_line_separators(+Counter)
% Displays a line of '-' characters in order to separate board lines
display_line_separators(0) :- !.
display_line_separators(Counter) :-
    write('-'),
    CounterAux is Counter - 1,
    display_line_separators(CounterAux).

% display_column_tags(+BoardSize, +Counter)
% Displays a tag for each column: 'a', 'b', 'c', etc. so that the player can choose a move
display_column_tags(BoardSize, BoardSize) :-
    write('|').
display_column_tags(BoardSize, Counter) :-
    write('| '),
    Ascii is Counter + 97,
    put_code(Ascii),
    write(' '),
    CounterAux is Counter + 1,
    display_column_tags(BoardSize, CounterAux).

% display_line(+Line)
% Displays a specific board line by adding separators and 'b'/'w' to represent a position 
% occupied by a black or white piece respectively 
display_line([]) :- write('|').
display_line([e | Rest]) :-
    write('| '),
    write(' '),
    write(' '),    
    display_line(Rest),
    !.
display_line([Column | Rest]) :-
    write('| '),
    write(Column),
    write(' '),    
    display_line(Rest).

% display_game_aux(+BoardSize, +Board, +Counter)
% Displays the game board one line at a time
display_game_aux(BoardSize, [], _) :-
    NChars is BoardSize * 4 + 3,
    display_line_separators(NChars).
display_game_aux(BoardSize, [Line | Rest], Counter) :-
    NChars is BoardSize * 4 + 3,
    display_line_separators(NChars),
    nl,
    write(Counter),
    write(' '),
    display_line(Line),
    nl,
    CounterAux is Counter + 1,
    display_game_aux(BoardSize, Rest, CounterAux).

% display_game(+GameState)
% Displays the game board
display_game(GameState) :-
    get_board_size(GameState, BoardSize),
    get_board(GameState, Board),
    nl,
    write('  '),
    display_column_tags(BoardSize, 0),
    nl,
    display_game_aux(BoardSize, Board, 1),
    nl,
    display_points(GameState).


% display_winner(+Winner)
% Displays a user-friendly message indicating the winner
display_winner(b) :- nl, write('The black pieces won the victory in this battle of wits!'), nl.
display_winner(w) :- nl, write('The white pieces won the victory in this battle of wits!'), nl.
display_winner(t) :- nl, write('No winner today. The game ends in a draw!'), nl.
