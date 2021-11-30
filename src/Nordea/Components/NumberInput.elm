module Nordea.Components.NumberInput exposing
    ( NumberInput
    , init
    , view
    , withError
    , withMax
    , withMin
    , withOnInput
    , withPlaceholder
    , withStep
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , disabled
        , focus
        , fontSize
        , height
        , none
        , outline
        , padding2
        , pct
        , rem
        , solid
        , width
        )
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (placeholder, step, type_, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , min : Maybe Float
    , max : Maybe Float
    , step : Maybe Float
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    , showError : Bool
    }


type NumberInput msg
    = NumberInput (Config msg)


init : String -> NumberInput msg
init value =
    NumberInput
        { value = value
        , min = Nothing
        , max = Nothing
        , step = Nothing
        , placeholder = Nothing
        , onInput = Nothing
        , showError = False
        }


withMin : Float -> NumberInput msg -> NumberInput msg
withMin min (NumberInput config) =
    NumberInput { config | min = Just min }


withMax : Float -> NumberInput msg -> NumberInput msg
withMax max (NumberInput config) =
    NumberInput { config | max = Just max }


withStep : Float -> NumberInput msg -> NumberInput msg
withStep step (NumberInput config) =
    NumberInput { config | step = Just step }


withPlaceholder : String -> NumberInput msg -> NumberInput msg
withPlaceholder placeholder (NumberInput config) =
    NumberInput { config | placeholder = Just placeholder }


withOnInput : (String -> msg) -> NumberInput msg -> NumberInput msg
withOnInput onInput (NumberInput config) =
    NumberInput { config | onInput = Just onInput }


withError : Bool -> NumberInput msg -> NumberInput msg
withError condition (NumberInput config) =
    NumberInput { config | showError = condition }



-- VIEW


view : List (Attribute msg) -> NumberInput msg -> Html msg
view attributes (NumberInput config) =
    styled input
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just "number" |> Maybe.map type_
        , Just config.value |> Maybe.map value
        , config.min |> Maybe.map String.fromFloat |> Maybe.map Attributes.min
        , config.max |> Maybe.map String.fromFloat |> Maybe.map Attributes.max
        , config.step |> Maybe.map String.fromFloat |> Maybe.map step
        , config.placeholder |> Maybe.map placeholder
        , config.onInput |> Maybe.map onInput
        ]



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else
                Colors.grayMedium
    in
    [ fontSize (rem 1)
    , height (rem 3)
    , padding2 (rem 0.75) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
