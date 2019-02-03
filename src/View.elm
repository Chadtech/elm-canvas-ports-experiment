module View exposing (view)

import Browser
import Css exposing (..)
import Data.Position as Position
import Html.Events.Extra.Mouse as Mouse
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Lazy
import Model exposing (Model)
import Msg exposing (Msg(..))
import Style


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Canvas Ports Experiment"
    , body =
        [ Style.globals
        , title
        , Html.Styled.Lazy.lazy drawingCanvas ()
        , summary
        ]
            |> List.map Html.toUnstyled
    }


title : Html Msg
title =
    Html.p
        [ Attrs.css [ centerTextStyle ] ]
        [ Html.text "Elm Canvas Ports Experiment" ]


summary : Html Msg
summary =
    Html.p
        [ Attrs.css [ centerTextStyle ] ]
        [ Html.text "Click on the canvas, and drag, to draw." ]


centerTextStyle : Style
centerTextStyle =
    textAlign center


{-| Html.Lazy will avoid rerendering html if the
input values have not changed, which improves performance
(yay pure functions).

But in this case, I just want to make sure its never ever
rerendered, because I dont want the canvas getting whipped
away. This is a way to protect the html I never want
altered by the virtual DOM. Html.Lazy checks every render
cycle that () == (), finding it to be true, and then doesnt
proceed any further, knowing it shouldnt change the canvas html

-}
drawingCanvas : () -> Html Msg
drawingCanvas _ =
    Html.div
        [ Attrs.css
            [ displayFlex
            , justifyContent center
            ]
        ]
        [ Html.node "elm-canvas"
            [ Attrs.id "main-canvas"
            , Attrs.css [ display block ]
            , Mouse.onDown
                (MouseDownOnCanvas << Position.onTargetFromMouseEvent)
                |> Attrs.fromUnstyled
            , Mouse.onMove
                (MouseMoveOnCanvas << Position.onTargetFromMouseEvent)
                |> Attrs.fromUnstyled
            , Mouse.onUp (always MouseUpOnCanvas)
                |> Attrs.fromUnstyled
            ]
            []
        ]
