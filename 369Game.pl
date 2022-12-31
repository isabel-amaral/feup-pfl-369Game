:- use_module(library(system)).
:- use_module(library(lists)).
:- use_module(library(random)).

:- consult('utils.pl').
:- consult('menu.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('points.pl').
:- consult('move.pl').

% create_board_line(+Counter, -Line)
create_board_line(0, []).
create_board_line(Counter, Line) :-
    Counter > 0,
    CounterAux is Counter - 1,
    create_board_line(CounterAux, LineAux),
    Line = [e | LineAux].

% create_board(+Size, +Counter, -Board)
create_board(Size, 1, Board) :-
    create_board_line(Size, Line),
    Board = [Line].
create_board(Size, Counter, Board) :-
    Counter > 0,
    CounterAux is Counter - 1,
    create_board(Size, CounterAux, BoardAux),
    create_board_line(Size, Line),
    Board = [Line | BoardAux].


% GameState is saved in the format [BoardSize, Board, Level, WhitePlayer, BlackPlayer, NextPlayer]
% initial_state(+Size, +Level, -GameState)
initial_state(Size, Level, [Size, Board, Level, 0, 0, w]) :-
    create_board(Size, Size, Board).


% game_over_aux(+WhitePoints, +BlackPoints, -Winner)
game_over_aux(WPoints, BPoints, Winner) :-
    WPoints > BPoints,
    Winner = w,
    !.
game_over_aux(WPoints, BPoints, Winner) :-
    BPoints > WPoints,
    Winner = b,
    !.
game_over_aux( _, _, t).

% game_over(+GameState, -Winner)
game_over(GameState, Winner) :- 
    get_next_player(GameState, Player),
    valid_moves(GameState, Player, FreePositions),
    length(FreePositions, 0),
    value(GameState, w, WPoints),
    value(GameState, b, BPoints),
    game_over_aux(WPoints, BPoints, Winner),
    display_winner(Winner).


% game_cycle(+GameState, +GameType)
game_cycle(GameState, _) :-
    game_over(GameState, _Winner),
    !. 

game_cycle(GameState, h/h) :-
    get_next_player(GameState, NextPlayer),
    valid_moves(GameState, NextPlayer, ListOfMoves),
    read_move_until_valid(ListOfMoves, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_cycle(NewGameState, h/h).

game_cycle(GameState, h/pc) :-
    get_next_player(GameState, w),
    valid_moves(GameState, w, ListOfMoves),
    read_move_until_valid(ListOfMoves, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    sleep(3),
    game_cycle(NewGameState, h/pc).
game_cycle(GameState, h/pc) :-
    get_next_player(GameState, b),
    get_level(GameState, Level),
    choose_move(GameState, b, Level, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_cycle(NewGameState, h/pc).

game_cycle(GameState, pc/pc) :-
    get_next_player(GameState, NextPlayer),
    get_level(GameState, Level),
    choose_move(GameState, NextPlayer, Level, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    sleep(3),
    game_cycle(NewGameState, pc/pc).


% play/0
play :-
    menu(GameType, Level, Size),
    initial_state(Size, Level, GameState),
    display_game(GameState),
    game_cycle(GameState, GameType).