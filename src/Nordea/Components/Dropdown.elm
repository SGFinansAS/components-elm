module Nordea.Components.Dropdown exposing (Dropdown, init, view, withHasError, withSelectedValue)

import Css
    exposing
        ( Color
        , absolute
        , backgroundColor
        , border3
        , borderColor
        , borderRadius
        , borderStyle
        , boxShadow5
        , color
        , displayFlex
        , flexBasis
        , focus
        , fontFamilies
        , fontSize
        , height
        , hidden
        , inherit
        , lineHeight
        , none
        , outline
        , overflow
        , padding4
        , pct
        , pointerEvents
        , position
        , property
        , relative
        , rem
        , right
        , solid
        , top
        , transform
        , translateY
        , transparent
        , width
        )
import Dict
import Html.Styled as Html exposing (Attribute, Html, div, option, text)
import Html.Styled.Attributes as Attrs exposing (css, selected, value)
import Html.Styled.Events as Events exposing (on, targetValue)
import Json.Decode as Decode
import Nordea.Css exposing (colorVariable)
import Nordea.Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon


type alias Option a =
    { value : a
    , text : String
    }


type alias DropdownProperties a msg =
    { placeholder : Maybe String
    , onInput : a -> msg
    , options : List (Option a)
    , optionToString : a -> String
    , selectedValue : Maybe a
    , hasError : Bool
    }


type Dropdown a msg
    = Dropdown (DropdownProperties a msg)


init : List (Option a) -> (a -> String) -> (a -> msg) -> Dropdown a msg
init options optionToString onInput =
    Dropdown
        { placeholder = Nothing
        , onInput = onInput
        , options = options
        , optionToString = optionToString
        , selectedValue = Nothing
        , hasError = False
        }


view : List (Attribute msg) -> Dropdown a msg -> Html msg
view attrs (Dropdown config) =
    let
        placeholder =
            config.placeholder
                |> viewMaybe
                    (\placeholderTxt ->
                        option
                            [ value "", selected True, Attrs.hidden True ]
                            [ text placeholderTxt ]
                    )

        options =
            config.options
                |> List.map
                    (\dropDownOption ->
                        option
                            [ dropDownOption.value |> config.optionToString |> value
                            , selected (config.selectedValue == Just dropDownOption.value)
                            , css [ color Colors.black ]
                            ]
                            [ text dropDownOption.text ]
                    )

        optionsDict =
            config.options
                |> List.map (\opt -> ( config.optionToString opt.value, opt.value ))
                |> Dict.fromList

        decoder =
            targetValue
                |> Decode.andThen
                    (\val ->
                        case Dict.get val optionsDict of
                            Nothing ->
                                Decode.fail ""

                            Just tag ->
                                Decode.succeed tag
                    )
                |> Decode.map config.onInput
    in
    div
        (css
            [ displayFlex
            , position relative
            , flexBasis (pct 100)
            , border3 (rem 0.0625) solid Colors.grayMedium
            , borderColor Colors.redDark |> styleIf config.hasError
            , borderRadius (rem 0.25)
            , overflow hidden
            , color Colors.black
            ]
            :: attrs
        )
        [ Html.select
            [ Events.on "change" decoder
            , css
                [ height (rem 2.5)
                , width (pct 100)
                , property "appearance" "none"
                , property "-moz-appearance" "none"
                , property "-webkit-appearance" "none"
                , backgroundColor transparent
                , padding4 (rem 0.5) (rem 2) (rem 0.5) (rem 1)
                , borderStyle none
                , focus
                    [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ colorVariable "--themePrimaryColor20" Colors.blueNordea)
                    , outline none
                    ]
                , fontSize (rem 1.0)
                , lineHeight (rem 1.4)
                , fontFamilies [ "Nordea Sans Small" ]
                , color inherit
                ]
            ]
            (placeholder :: options)
        , Icon.chevronDown
            [ css
                [ position absolute
                , top (pct 50)
                , transform (translateY (pct -50))
                , right (rem 0.75)
                , width (rem 1.125) |> Css.important
                , height (rem 1.125)
                , pointerEvents none
                , color inherit
                ]
            ]
        ]


withSelectedValue : Maybe a -> Dropdown a msg -> Dropdown a msg
withSelectedValue selectedValue (Dropdown config) =
    Dropdown { config | selectedValue = selectedValue }


withHasError : Bool -> Dropdown a msg -> Dropdown a msg
withHasError hasError (Dropdown config) =
    Dropdown { config | hasError = hasError }
