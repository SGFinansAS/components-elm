module Nordea.Components.RadioButton exposing
    ( Appearance(..)
    , RadioButton
    , init
    , view
    , withAppearance
    , withHasError
    , withIsSelected
    , withOnBlur
    )

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderColor
        , borderRadius
        , borderTopColor
        , borderTopLeftRadius
        , borderTopRightRadius
        , boxSizing
        , center
        , cursor
        , display
        , flex
        , flexBasis
        , height
        , hover
        , inlineFlex
        , left
        , minHeight
        , none
        , num
        , opacity
        , padding2
        , pct
        , pointer
        , position
        , pseudoClass
        , relative
        , rem
        , solid
        , top
        , transform
        , translate2
        , transparent
        , width
        )
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css, disabled, name, type_)
import Html.Styled.Events as Events
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias InputProperties msg =
    { name : String
    , label : Html msg
    , onCheck : msg
    , onBlur : Maybe msg
    , isSelected : Bool
    , appearance : Appearance
    , showError : Bool
    }


type RadioButton msg
    = RadioButton (InputProperties msg)


type Appearance
    = Standard
    | Simple
    | ListStyle
    | Small


init : String -> Html msg -> msg -> RadioButton msg
init name label onCheck =
    RadioButton
        { name = name
        , label = label
        , onCheck = onCheck
        , onBlur = Nothing
        , isSelected = False
        , appearance = Standard
        , showError = False
        }


view : List (Attribute msg) -> RadioButton msg -> Html msg
view attrs (RadioButton config) =
    let
        isDisabled =
            List.member (Attrs.disabled True) attrs

        radiomark =
            Html.span
                [ Attrs.class "nfe-radiomark"
                , css
                    [ position relative
                    , width (rem 1.375)
                    , height (rem 1.375)
                    , flex none
                    , backgroundColor Colors.white
                    , border3 (rem 0.125) solid Css.transparent
                    , if isDisabled then
                        borderColor Colors.grayMedium

                      else
                        Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
                    , borderColor Colors.redDark
                        |> styleIf (config.showError && config.appearance == Simple)
                    , borderColor Colors.grayMedium
                        |> styleIf (config.showError && List.member config.appearance [ Standard, ListStyle ])
                    , borderRadius (pct 50)
                    , boxSizing borderBox
                    , after
                        [ Css.property "content" "''"
                        , position absolute
                        , top (pct 50)
                        , left (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , width (rem 0.75)
                        , height (rem 0.75)
                        , if isDisabled then
                            backgroundColor Colors.grayNordea

                          else
                            Themes.backgroundColor Themes.PrimaryColorLight Colors.blueNordea
                        , borderRadius (pct 50)
                        , boxSizing borderBox
                        , display none
                        ]
                    ]
                ]
                []

        appearanceStyle =
            let
                topBottomPadding =
                    case config.appearance of
                        Small ->
                            rem 0.5

                        _ ->
                            rem 0.75

                commonNonSimpleStyles =
                    Css.batch
                        [ padding2 topBottomPadding (rem 1)
                        , border3 (rem 0.0625) solid transparent
                        , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud |> styleIf config.isSelected
                        , transition [ Css.Transitions.borderColor 100, Css.Transitions.boxShadow 100 ]
                        ]
            in
            case config.appearance of
                ListStyle ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , flexBasis (pct 100)
                        , borderColor Colors.grayMedium
                        , borderColor Colors.redDark |> styleIf config.showError
                        , Css.firstOfType [ borderTopLeftRadius (rem 0.5), borderTopRightRadius (rem 0.5) ]
                        , Css.lastOfType [ borderBottomLeftRadius (rem 0.5), borderBottomRightRadius (rem 0.5) ]
                        , pseudoClass "not(label:first-of-type):not(:hover)" [ borderTopColor transparent ] |> styleIf (not config.isSelected)
                        , pseudoClass "not(label:first-of-type)" [ Css.marginTop (rem -0.0625) ]
                        , hover [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud ] |> styleIf (not isDisabled)
                        ]

                Simple ->
                    Css.batch []

                _ ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , borderRadius (rem 0.25)
                        , minHeight (rem 2.5)
                        , borderColor Colors.grayMedium |> styleIf (not config.isSelected)
                        , borderColor Colors.redDark |> styleIf config.showError
                        , hover
                            [ Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea |> styleIf (not config.showError)
                            , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
                            ]
                            |> styleIf (not isDisabled)
                        ]

        notDisabledSpecificStyling =
            let
                hoverShadow =
                    Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueMedium)
            in
            Css.batch
                [ pseudoClass "hover .nfe-radiomark:before" [ hoverShadow ]
                , pseudoClass "focus-within .nfe-radiomark:before" [ hoverShadow ]
                , cursor pointer
                ]
                |> styleIf (not isDisabled)
    in
    Html.label
        (css
            [ display inlineFlex
            , Css.property "gap" "0.5rem"
            , alignItems center
            , boxSizing borderBox
            , position relative
            , notDisabledSpecificStyling
            , appearanceStyle
            ]
            :: attrs
        )
        [ Html.input
            [ type_ "radio"
            , name config.name
            , Attrs.checked config.isSelected
            , Events.onCheck (\_ -> config.onCheck)
            , disabled isDisabled
            , css
                [ position absolute
                , opacity (num 0)
                , height (rem 0)
                , width (rem 0)

                -- when <input> is checked, show radiomark
                , pseudoClass "checked ~ .nfe-radiomark::after" [ display block ]
                ]
            ]
            []
        , radiomark
        , config.label
        ]


withOnBlur : msg -> RadioButton msg -> RadioButton msg
withOnBlur msg (RadioButton config) =
    RadioButton { config | onBlur = Just msg }


withIsSelected : Bool -> RadioButton msg -> RadioButton msg
withIsSelected isSelected (RadioButton config) =
    RadioButton { config | isSelected = isSelected }


withAppearance : Appearance -> RadioButton msg -> RadioButton msg
withAppearance appearance (RadioButton config) =
    RadioButton { config | appearance = appearance }


withHasError : Bool -> RadioButton msg -> RadioButton msg
withHasError showError (RadioButton config) =
    RadioButton { config | showError = showError }
