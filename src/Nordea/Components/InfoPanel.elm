module Nordea.Components.InfoPanel exposing (..)

import Css exposing (int, pseudoClass, rem)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Nordea.Resources.Colors as Colors


type alias InfoPanelContent =
    { label : String
    , info : String
    }


view : List InfoPanelContent -> Html msg
view panelInfoList =
    Html.div
        [ Attributes.css
            [ Css.backgroundColor (Colors.grayCool |> Colors.withAlpha 0.5)
            , Css.maxWidth (rem 25)
            , Css.boxSizing Css.borderBox
            , Css.borderRadius (rem 0.5)
            , Css.border3 (rem 0.0625) Css.solid Colors.grayMedium
            ]
        ]
        (panelInfoList |> List.map (\panelInfo -> viewLabelInfoBlock panelInfo))


viewLabelInfoBlock : InfoPanelContent -> Html msg
viewLabelInfoBlock infoPanelContent =
    Html.div
        [ Attributes.css
            [ Css.padding2 (rem 0.75) (rem 0.5)
            , Css.fontFamilies [ "Nordea Sans Small" ]
            , pseudoClass "not(:last-child)" [ Css.borderBottom3 (rem 0.0625) Css.solid Colors.grayMedium ]
            , Css.firstChild [ Css.fontWeight (int 500), Css.fontSize (rem 1.125) ]
            ]
        ]
        [ Html.div
            [ Attributes.css
                [ Css.fontSize (rem 0.875)
                , Css.fontWeight (int 200)
                , Css.marginBottom (rem 0.25)
                ]
            ]
            [ Html.text infoPanelContent.label ]
        , Html.text infoPanelContent.info
        ]