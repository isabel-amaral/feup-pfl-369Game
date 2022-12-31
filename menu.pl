% map_option_to_game_type(+Option, -GameType)
map_option_to_game_type(1, h/h).
map_option_to_game_type(2, h/pc).
map_option_to_game_type(3, pc/pc).

% choose_game_type(-GameType)
choose_game_type(GameType) :- 
    repeat, nl,
    write('Choose the game type: '), nl,
    write('1 - Human-Human (H/H)'),nl,
    write('2 - Human-Computer (H/PC)'), nl,
    write('3 - Computer-Computer (PC/PC)'), nl,
    read(N),
    number(N),
    N >= 1,
    N =< 3,
    map_option_to_game_type(N, GameType).

% choose_level(-Level)
choose_level(Level) :-
    repeat, nl,
    write('Choose game level (1 or 2):'), nl,
    read(L),
    number(L),
    N >= 1,
    N =< 2,
    Level is L.

% choose_board_size(-Size)
choose_board_size(Size) :-
    repeat, nl,
    write('Choose board size:'), nl,
    read(S),
    number(S),
    Size is S.

% menu(-GameType, -Level, -Size)
menu(GameType, Level, Size) :- 
    nl, 
    choose_game_type(GameType),
    choose_level(Level),
    choose_board_size(Size).
