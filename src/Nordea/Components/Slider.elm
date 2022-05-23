module Nordea.Components.Slider exposing
    ( Slider
    , init
    , view
    , withError
    , withMax
    , withMin
    , withStep
    )

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , borderRadius
        , center
        , color
        , column
        , cursor
        , displayFlex
        , flex
        , flexDirection
        , height
        , int
        , marginBottom
        , marginTop
        , pct
        , pointer
        , property
        , pseudoElement
        , rem
        , row
        , transparent
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, div, input, label)
import Html.Styled.Attributes exposing (css, for, name, type_)
import Html.Styled.Events exposing (onInput)
import Nordea.Components.NumberInput as NumberInput
import Nordea.Components.Text as NordeaText
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , min : Float
    , max : Float
    , step : Maybe Float
    , onInput : String -> msg
    , showError : Bool
    , isDisabled : Bool
    , labelString : String
    , description : String
    }


type Slider msg
    = Slider (Config msg)


init : String -> Float -> Float -> String -> String -> (String -> msg) -> Slider msg
init value min max labelString description onInput =
    Slider
        { value = value
        , min = min
        , max = max
        , step = Nothing
        , onInput = onInput
        , showError = False
        , isDisabled = False
        , labelString = labelString
        , description = description
        }


withMin : Float -> Slider msg -> Slider msg
withMin min (Slider config) =
    Slider { config | min = min }


withMax : Float -> Slider msg -> Slider msg
withMax max (Slider config) =
    Slider { config | max = max }


withStep : Float -> Slider msg -> Slider msg
withStep step (Slider config) =
    Slider { config | step = Just step }


withError : Bool -> Slider msg -> Slider msg
withError condition (Slider config) =
    Slider { config | showError = condition }



-- VIEW


view : List (Attribute msg) -> Slider msg -> Html msg
view attributes (Slider config) =
    div ([] ++ attributes)
        [ div [ css [ displayFlex, flexDirection row, marginBottom (rem 1), alignItems center ] ]
            [ label [ for "rangeInput", css [ displayFlex, flexDirection column, flex (int 3) ] ]
                [ NordeaText.textSmallLight
                    |> NordeaText.view [] [ Html.text config.labelString ]
                , NordeaText.textTinyLight
                    |> NordeaText.view [ css [ color Colors.grayNordea ] ] [ Html.text config.description ]
                ]
            , NumberInput.init config.value
                |> NumberInput.withMin config.min
                |> NumberInput.withMax config.max
                |> NumberInput.withStep (config.step |> Maybe.withDefault 1)
                |> NumberInput.withOnInput config.onInput
                |> NumberInput.withError ((config.value |> String.toFloat |> Maybe.withDefault 1) > config.max || (config.value |> String.toFloat |> Maybe.withDefault 1) < config.min)
                |> NumberInput.view [ name "rangeInput", css [ flex (int 1) ] ]
            ]
        , input
            [ name "rangeInput"
            , type_ "range"
            , Html.Styled.Attributes.value config.value
            , Html.Styled.Attributes.min (config.min |> String.fromFloat)
            , Html.Styled.Attributes.max (config.max |> String.fromFloat)
            , Html.Styled.Attributes.step (config.step |> Maybe.map String.fromFloat |> Maybe.withDefault "1")
            , config.onInput |> onInput
            , css [ sliderStyle (Slider config) ]
            ]
            []
        ]


sliderStyle : Slider msg -> Style
sliderStyle (Slider config) =
    Css.batch
        [ width (pct 100)
        , property "-webkit-appearance" "none"
        , cursor pointer

        -- Webkit
        , pseudoElement "-webkit-slider-runnable-track"
            [ width (pct 100)
            , height (rem 0.25)
            , property "background-color" "transparent"
            ]
        , pseudoElement "-webkit-slider-thumb"
            [ property "-webkit-appearance" "none"
            , width (rem 1.5)
            , height (rem 1.5)
            , borderRadius (pct 100)
            , Themes.backgroundColor Themes.SecondaryColor Colors.blueDeep
            , marginTop (rem -0.625)
            ]

        -- Mozilla
        , pseudoElement "-moz-range-track"
            [ width (pct 100)
            , height (rem 0.25)
            , backgroundColor transparent
            ]
        , pseudoElement "-moz-range-thumb"
            [ width (rem 1.25)
            , height (rem 1.25)
            , borderRadius (pct 100)
            , Themes.backgroundColor Themes.SecondaryColor Colors.blueDeep
            , marginTop (rem -0.625)
            ]
        , adjustSlider (Slider config)
        ]


adjustSlider : Slider msg -> Style
adjustSlider (Slider config) =
    let
        visibleWidth =
            ((((config.value |> String.toFloat |> Maybe.withDefault 0) - config.min) * 100) / (config.max - config.min)) |> String.fromFloat

        cloudBlue =
            Themes.colorVariable Themes.SecondaryColor Colors.blueCloud

        nordeaBlue =
            Themes.colorVariable Themes.PrimaryColorLight Colors.blueNordea

        gradientValue =
            "linear-gradient(to right," ++ nordeaBlue ++ " 0% " ++ visibleWidth ++ "%, " ++ cloudBlue ++ " " ++ visibleWidth ++ "%" ++ " 100% )"
    in
    Css.batch
        [ property "background" gradientValue
        ]
