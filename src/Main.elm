module Main exposing (..)

import Html exposing (..)
import Type exposing (..)
import Render exposing (..)
import Logic exposing (..)
import Control exposing (..)
import Time exposing (..)


main : Program Never Game Msg
main =
    Html.program
        { init = ( init, Cmd.none )
        , update = update
        , view = render
        , subscriptions = subscriptions
        }


update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        Tick time ->
            gameUpdate game

        KeyPressed key ->
            keyPressedUpdate game key

        --
        KeyReleased key ->
            keyReleasedUpdate game key

        ChangeState state ->
            ( { game | state = state }, Cmd.none )

        Restart ->
            ( { init | state = Playing }, Cmd.none )

        ShootBullet ->
            ( shootBullet game, Cmd.none )

        _ ->
            ( game, Cmd.none )


subscriptions : Game -> Sub Msg
subscriptions game =
    case game.state of
        Menu ->
            Sub.none

        Playing ->
            Sub.batch [ keyPressedBind, keyReleasedBind, tick ]

        Boss ->
            Sub.batch [ keyPressedBind, keyReleasedBind, tick ]

        _ ->
            Sub.none



-- Subscriptions Listen in background


tick : Sub Msg
tick =
    Time.every ((1000 / 60) * Time.millisecond) Tick
