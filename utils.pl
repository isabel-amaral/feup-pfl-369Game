% GameState is saved in the format [BoardSize, Board, WhitePlayer, BlackPlayer, NextPlayer]

% get_board_size(+GameState, -BoardSize)
get_board_size([BoardSize, _, _, _, _], BoardSize).

% get_board(+GameState, -Board)
get_board([_, Board, _, _, _], Board).

% get_white_player_pontuation(+GameState, -WhitePlayer)
get_white_player_pontuation([_, _, WhitePlayer, _, _], WhitePlayer).

% get_black_player_pontuation(+GameState, -BlackPlayer)
get_black_player_pontuation([_, _, _, BlackPlayer, _], BlackPlayer).

% get_next_player(+GameState, -NextPlayer)
get_next_player([_, _, _, _, NextPlayer], NextPlayer).
