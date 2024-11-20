module Nordea.Components.StepIndicatorModern exposing
    ( StepIndicator
    , init
    , view
    )

import Css exposing (alignItems, backgroundColor, border3, borderRadius, boxShadow5, center, color, column, displayFlex, flexDirection, height, int, justifyContent, listStyleType, marginTop, none, pct, px, rem, solid, textAlign, width, zIndex)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (attribute, css)
import Nordea.Components.Text as NordeaText
import Nordea.Css exposing (displayGrid, gap, gridColumn, gridRow, gridTemplateColumns, gridTemplateRows)
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type StepIndicator
    = StepIndicator Config


type alias Config =
    { stepNames : List String
    , currentStep : Int
    }


init : List String -> Int -> StepIndicator
init stepNames currentStep =
    StepIndicator
        { stepNames = stepNames
        , currentStep = currentStep
        }


view : StepIndicator -> Html msg
view config =
    Html.div [ attribute "role" "group", attribute "aria-label" "Step progress" ]
        [ viewSteps config
        ]


viewSteps : StepIndicator -> Html msg
viewSteps (StepIndicator config) =
    let
        numberOfColumns =
            List.length config.stepNames * 2

        equalWidthColumns =
            "repeat(" ++ String.fromInt numberOfColumns ++ ", 1fr)"

        steps =
            List.indexedMap (\i a -> ( i, a )) config.stepNames

        connectors =
            List.range 0 <| List.length config.stepNames
    in
    Html.ol
        [ css
            [ displayGrid
            , gridTemplateColumns equalWidthColumns
            , gridTemplateRows "1fr"
            , listStyleType none
            ]
        ]
    <|
        List.map (viewConnector config.currentStep) connectors
            ++ List.map (viewStep config) steps


viewConnector : Int -> Int -> Html msg
viewConnector currentStep index =
    let
        nextStepIsCompleted =
            currentStep > index

        background =
            if nextStepIsCompleted then
                Colors.nordeaBlue

            else
                Colors.cloudBlue

        connectorHeight =
            if nextStepIsCompleted then
                0.5

            else
                0.25
    in
    Html.div
        [ attribute "aria-hidden" ""
        , css
            [ width (pct 100)
            , backgroundColor background
            , height (rem connectorHeight)
            , marginTop (rem (0.65 - (connectorHeight / 2)))
            , borderRadius (rem (connectorHeight / 2))
            , gridRow "1"
            , gridColumn <| getGridColumn index True
            ]
        ]
        []


viewStep : Config -> ( Int, String ) -> Html msg
viewStep config ( index, stepName ) =
    let
        stepIsCompleted =
            config.currentStep > index

        isCurrentStep =
            config.currentStep == index

        borderColor =
            if stepIsCompleted then
                Colors.deepBlue

            else
                Colors.cloudBlue

        background =
            if stepIsCompleted then
                Colors.deepBlue

            else
                Colors.white
    in
    Html.li
        [ attribute "aria-current" <|
            if isCurrentStep then
                "step"

            else
                "false"
        , css
            [ displayFlex
            , flexDirection column
            , alignItems center
            , gap (rem 0.5)
            , gridRow "1"
            , gridColumn <| getGridColumn index False
            , zIndex (int 1)
            ]
        ]
        [ Html.div
            [ css
                [ displayFlex
                , justifyContent center
                , alignItems center
                , height (rem 1.25)
                , width (rem 1.25)
                , borderRadius (pct 50)
                , border3 (px 2) solid borderColor
                , styleIf stepIsCompleted <| boxShadow5 (px 0) (px 0) (px 0) (px 2) Colors.white
                , backgroundColor background
                ]
            ]
            [ Icons.check
                [ css
                    [ color Colors.white
                    , width (rem 0.75)
                    , height (rem 0.75)
                    ]
                ]
            ]
        , NordeaText.textTinyLight
            |> NordeaText.view [ css [ textAlign center ] ]
                [ Html.text stepName
                ]
        ]


getGridColumn : Int -> Bool -> String
getGridColumn index isConnector =
    let
        ( width, offset ) =
            if isConnector && index == 0 then
                ( 1, 1 )

            else if isConnector then
                ( 2, index * 2 )

            else
                ( 2, 1 + (index * 2) )
    in
    String.fromInt offset ++ " / span " ++ String.fromInt width
