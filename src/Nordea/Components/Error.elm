module Nordea.Components.Error exposing (..)

import Css exposing (pct, rem, vh)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (href)
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes as SvgAttrs exposing (d)


type alias Translation =
    { no : String, se : String, dk : String } -> String


type alias ErrorConfig =
    { errorType : ErrorType, translate : Translation }


type ErrorType
    = InternalServerError
    | PageNotFound


type Error msg
    = Error ErrorConfig


internalServerError : Translation -> Error msg
internalServerError translate =
    init { errorType = InternalServerError, translate = translate }


pageNotFound : Translation -> Error msg
pageNotFound locale =
    init { errorType = PageNotFound, translate = locale }


init : ErrorConfig -> Error msg
init config =
    Error { translate = config.translate, errorType = config.errorType }


view : List (Attribute msg) -> List (Html msg) -> Error msg -> Html msg
view attributes children (Error config) =
    let
        errorDescription =
            if config.errorType == PageNotFound then
                texts.pageNotFound.description |> config.translate

            else
                texts.internalServerError.description |> config.translate
    in
    Html.div
        [ Attributes.css
            [ Css.backgroundColor Colors.white
            , Css.width (pct 100)
            , Css.height (vh 100)
            , Css.padding (rem 1.5)
            , Css.displayFlex
            , Css.flexDirection Css.column
            , Css.alignItems Css.center
            ]
        ]
        ([ Html.div [ Attributes.css [ Css.marginBottom (rem 1) ] ]
            [ Text.headlineTwo
                |> Text.withHtmlTag Html.h1
                |> Text.view
                    [ Attributes.css [ Css.textAlign Css.center ]
                    ]
                    [ Html.text (texts.heading |> config.translate) ]
            ]
         , Html.div
            [ Attributes.css
                [ Css.marginBottom (rem 2)
                , Css.maxWidth (rem 30)
                , Css.textAlign Css.center
                ]
            ]
            [ Text.bodyTextLight
                |> Text.view []
                    [ Html.text errorDescription
                    ]
            ]
         , Html.div [] [ errorSvg ]
         , viewActionForInternalServerError config
            |> showIf
                (config.errorType
                    == InternalServerError
                )
         ]
            ++ children
        )


viewActionForInternalServerError : ErrorConfig -> Html msg
viewActionForInternalServerError config =
    let
        errorActionText =
            texts.internalServerError.action |> config.translate
    in
    Text.bodyTextLight
        |> Text.view
            [ Attributes.css
                [ Css.maxWidth (rem 30)
                , Css.paddingRight (rem 0.25)
                , Css.textAlign Css.center
                ]
            ]
            [ Html.text errorActionText
            , FlatLink.default
                |> FlatLink.view
                    [ href "mailto: kundeservice.nfe@nordea.com"
                    , Attributes.css
                        [ Css.display Css.inlineBlock
                        ]
                    ]
                    [ Html.text "kundeservice.nfe@nordea.com." ]
            ]


texts =
    { heading =
        { no = "Oops! Her var det ikke mye å hente"
        , se = "Oops! Här fanns inte mycket att hämta"
        , dk = "Oops! Her var ikke meget at hente"
        }
    , internalServerError =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noen nettverksproblemer eller at noe er galt hos oss."
            , se = "Anledningen till att du har kommit hit kan vara att det är några nätverksproblem eller att något är fel på oss."
            , dk = "Grunden til at du er kommet hertil kan være at der er nogle netværksproblemer eller at der er noget galt med os."
            }
        , action =
            { no = "Prøv å oppdatere siden eller kontakt oss på "
            , se = "Försök att uppdatera sidan eller kontakta oss på "
            , dk = "Prøv å oppdatere siden eller kontakt oss på "
            }
        }
    , pageNotFound =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noe feil med linken, eller at siden er slettet."
            , se = "Anledningen till att du har kommit hit kan vara att det är något fel på länken, eller att sidan har raderats."
            , dk = "Grunden til at du er kommet hertil kan være, at der er noget galt med linket, eller at siden er blevet slettet."
            }
        }
    }


errorSvg : Svg msg
errorSvg =
    Svg.svg
        [ SvgAttrs.width "480"
        , SvgAttrs.height "240"
        , SvgAttrs.viewBox "0 0 480 240"
        , SvgAttrs.fill "none"
        ]
        [ Svg.path
            [ SvgAttrs.opacity
                "0.1"
            , d "M287.34 136.46C295.172 136.46 301.52 135.05 301.52 133.31C301.52 131.57 295.172 130.16 287.34 130.16C279.509 130.16 273.16 131.57 273.16 133.31C273.16 135.05 279.509 136.46 287.34 136.46Z"
            , SvgAttrs.fill "#00005E"
            ]
            []
        , Svg.path [ d "M275 132.251C275 132.251 287 110.361 302 132.001", SvgAttrs.stroke "#0F0F0F", SvgAttrs.strokeLinecap "round", SvgAttrs.strokeLinejoin "round" ] []
        , Svg.path [ d "M277.74 134.001C277.74 134.001 286.46 108.321 299.37 133.831", SvgAttrs.stroke "#0F0F0F", SvgAttrs.strokeLinecap "round", SvgAttrs.strokeLinejoin "round" ] []
        , Svg.path [ d "M281 134.781C281 134.781 286.65 107.331 296 134.621", SvgAttrs.stroke "#0F0F0F", SvgAttrs.strokeLinecap "round", SvgAttrs.strokeLinejoin "round" ] []
        , Svg.path [ d "M297.28 118.301C297.28 118.531 296.19 118.701 296.16 118.931C296.13 119.161 296.58 119.461 296.52 119.691C296.46 119.921 296.65 120.251 296.52 120.471C296.39 120.691 296.52 121.051 296.39 121.251C296.26 121.451 296.05 121.661 295.91 121.851C295.77 122.041 295.27 121.961 295.11 122.131C294.95 122.301 294.88 122.581 294.7 122.741C294.52 122.901 293.79 122.301 293.6 122.441C293.41 122.581 293.67 123.351 293.47 123.441C293.27 123.531 292.91 123.381 292.7 123.441C292.49 123.501 292.24 123.511 292.02 123.601C291.8 123.691 291.71 124.071 291.49 124.141C291.27 124.211 290.95 123.891 290.72 123.951C290.49 124.011 290.34 124.331 290.11 124.371C289.88 124.411 289.67 124.531 289.44 124.561C289.21 124.591 289.01 125.181 288.77 125.191C288.53 125.201 288.28 124.261 288.04 124.261H287.37C287.13 124.261 286.87 124.631 286.64 124.601C286.41 124.571 286.22 124.321 285.99 124.271C285.76 124.221 285.4 124.741 285.18 124.681C284.96 124.621 285.01 123.611 284.79 123.541C284.57 123.471 283.9 124.601 283.68 124.541C283.46 124.481 283.32 124.111 283.11 124.001C282.9 123.891 282.66 123.781 282.46 123.661C282.26 123.541 281.91 123.571 281.72 123.441C281.53 123.311 281.42 122.981 281.25 122.831C281.08 122.681 281.14 122.221 280.99 122.051C280.84 121.881 280.24 122.051 280.1 121.841C279.96 121.631 280.01 121.271 279.9 121.071C279.79 120.871 280.36 120.311 280.26 120.071C280.16 119.831 279.55 119.851 279.48 119.631C279.41 119.411 280.07 119.061 280.03 118.821C279.99 118.581 279.51 118.441 279.51 118.211C279.51 117.981 279.86 117.801 279.89 117.571C279.92 117.341 279.41 117.001 279.47 116.781C279.53 116.561 280.36 116.641 280.47 116.431C280.58 116.221 279.97 115.681 280.09 115.431C280.21 115.181 280.75 115.331 280.9 115.151C281.05 114.971 280.79 114.471 280.96 114.291C281.13 114.111 281.56 114.291 281.74 114.111C281.92 113.931 281.82 113.471 282.02 113.341C282.22 113.211 282.68 113.521 282.89 113.401C283.1 113.281 283.22 113.091 283.43 112.981C283.64 112.871 283.57 112.151 283.79 112.061C284.01 111.971 284.47 112.561 284.7 112.491C284.93 112.421 284.94 111.631 285.17 111.571C285.4 111.511 285.73 111.911 285.97 111.861C286.21 111.811 286.39 111.491 286.62 111.461C286.85 111.431 287.16 112.281 287.39 112.271C287.62 112.261 287.82 111.061 288.06 111.061C288.3 111.061 288.56 111.251 288.79 111.271C289.02 111.291 289.28 111.381 289.51 111.411C289.74 111.441 289.83 112.331 290.06 112.411C290.29 112.491 290.56 112.221 290.78 112.281C291 112.341 291.36 111.981 291.58 112.061C291.8 112.141 292.05 112.181 292.27 112.271C292.49 112.361 292.64 112.621 292.84 112.721C293.04 112.821 292.93 113.511 293.13 113.631C293.33 113.751 294.13 113.001 294.28 113.131C294.43 113.261 294.79 113.331 294.96 113.481C295.13 113.631 294.5 114.651 294.66 114.811C294.82 114.971 295.15 114.961 295.29 115.141C295.43 115.321 295.44 115.561 295.56 115.751C295.68 115.941 295.89 116.061 295.99 116.271C296.09 116.481 296.46 116.581 296.53 116.801C296.6 117.021 295.93 117.361 295.96 117.591C295.99 117.821 297.28 118.061 297.28 118.301Z", SvgAttrs.fill "#0F0F0F" ] []
        , Svg.path [ d "M291.49 120.58C292.644 120.58 293.58 119.645 293.58 118.49C293.58 117.336 292.644 116.4 291.49 116.4C290.336 116.4 289.4 117.336 289.4 118.49C289.4 119.645 290.336 120.58 291.49 120.58Z", SvgAttrs.fill "white" ] []
        , Svg.path [ d "M285.27 120.241C286.424 120.241 287.36 119.305 287.36 118.151C287.36 116.996 286.424 116.061 285.27 116.061C284.116 116.061 283.18 116.996 283.18 118.151C283.18 119.305 284.116 120.241 285.27 120.241Z", SvgAttrs.fill "white" ] []
        , Svg.path [ d "M285.58 119.081C285.889 119.081 286.14 118.83 286.14 118.521C286.14 118.212 285.889 117.961 285.58 117.961C285.271 117.961 285.02 118.212 285.02 118.521C285.02 118.83 285.271 119.081 285.58 119.081Z", SvgAttrs.fill "#0F0F0F" ] []
        , Svg.path [ d "M290.91 119.37C291.219 119.37 291.47 119.119 291.47 118.81C291.47 118.501 291.219 118.25 290.91 118.25C290.601 118.25 290.35 118.501 290.35 118.81C290.35 119.119 290.601 119.37 290.91 119.37Z", SvgAttrs.fill "#0F0F0F" ] []
        , Svg.path [ d "M93.1797 66.6699L93.9197 73.5199L94.1097 77.4899L91.3397 77.7999L86.1997 76.7599L93.1797 66.6699Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.1", d "M138.21 179.671C155.7 179.521 169.65 166.161 180.21 164.791C189.94 163.521 194.92 173.841 195.47 179.511C196.7 192.121 171.94 202.571 140.17 202.841C108.4 203.111 81.65 193.111 80.42 180.501C79.81 174.191 86.98 157.731 95.7 164.211C106.57 172.311 122.33 179.801 138.21 179.671Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M189.63 134.55C180.09 134.99 168.97 143.4 164.82 153.34C161.82 160.46 163.21 166.34 167.67 169.06L167.59 169.14L201.13 185.46L201.33 185.55C201.74 185.96 202.237 186.273 202.783 186.467C203.33 186.661 203.913 186.73 204.49 186.67C207.87 186.52 211.83 183.53 213.31 180.02C214.16 177.91 214.05 176.16 213.05 175.02V174.97L200.05 139.89C198.36 136.47 194.74 134.35 189.63 134.55Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.3", d "M189.63 134.55C180.09 134.99 168.97 143.4 164.82 153.34C161.82 160.46 163.21 166.34 167.67 169.06L167.59 169.14L189.73 179.91C196.495 173.981 202.414 167.15 207.32 159.61L200 139.93C198.36 136.47 194.74 134.35 189.63 134.55Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M155.21 150.441C145.67 150.861 134.56 159.281 130.4 169.211C127.4 176.331 128.79 182.211 133.25 184.941L133.17 185.011L166.76 201.351L166.91 201.431C167.318 201.841 167.813 202.154 168.358 202.348C168.903 202.541 169.485 202.611 170.06 202.551C173.46 202.401 177.41 199.401 178.88 195.911C179.74 193.781 179.58 192.001 178.59 190.911L178.44 190.491L165.59 155.831C163.89 152.321 160.31 150.211 155.21 150.441Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.3", d "M155.21 150.441C145.67 150.861 134.56 159.281 130.4 169.211C127.4 176.331 128.79 182.211 133.25 184.941L133.17 185.011L158.44 197.301C165.252 195.321 171.764 192.428 177.8 188.701L165.59 155.771C163.89 152.321 160.31 150.211 155.21 150.441Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M194.36 108.15L197.75 97.0004L177.26 60.4604L158.6 68.3504L138.73 44.1504L102.84 64.0604L100.13 72.4804C99.4199 74.6804 96.7199 76.9304 94.1299 77.4804C91.5399 78.0304 89.9699 76.7104 90.6699 74.4804L93.1999 66.6304L82.5399 68.0904L79.1499 63.6104H78.3699C75.2592 69.4093 72.6788 75.4772 70.6599 81.7404C55.2999 129.49 75.0499 178.55 114.77 191.33C152.91 203.6 195.58 177.94 212.51 133.62L194.36 108.15Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.7", d "M158.6 68.3504L138.73 44.1504L102.84 64.0604L100.13 72.4804C99.4196 74.6804 96.7196 76.9304 94.1296 77.4804C91.5396 78.0304 89.9696 76.7104 90.6696 74.4804L93.1996 66.6304L82.5396 68.0904L79.1496 63.6104H78.5396C75.5036 69.3085 72.9803 75.2653 70.9996 81.4104C55.6596 129.15 75.4096 178.22 115.13 191C126.701 194.677 139.07 195.044 150.84 192.06C165.16 180.45 176.84 163.8 183.34 143.67C192.97 113.74 188.8 83.3004 174.57 61.6004L158.6 68.3504Z", SvgAttrs.fill "#FBD9CA" ] []
        , Svg.path [ SvgAttrs.opacity "0.5", d "M120.78 68.2908C114.431 66.5972 107.721 66.8374 101.51 68.9808C99.85 74.3108 98.6999 74.7908 98.6999 74.7908C98.6999 74.7908 95.6999 78.1408 92.6399 77.5408C92.3025 77.5242 91.9734 77.4305 91.6779 77.2669C91.3823 77.1033 91.1282 76.8741 90.9351 76.597C90.742 76.3198 90.6149 76.0021 90.5638 75.6682C90.5126 75.3342 90.5387 74.993 90.6399 74.6708C81.5624 81.5401 75.0687 91.2719 72.2099 102.291C65.5899 126.571 76.6099 150.721 96.8099 156.221C117.01 161.721 138.75 146.501 145.36 122.221C151.97 97.9408 141 73.7908 120.78 68.2908Z", SvgAttrs.fill "#FDECE4" ] []
        , Svg.path [ d "M122.5 149.09C112.36 148.31 103.2 150.7 97.6 154.95C95.3134 156.208 93.572 158.266 92.71 160.73L88.71 173.23C89.3735 171.22 90.6543 169.47 92.37 168.23C94.82 176.12 105.99 182.72 119.87 183.79C126.266 184.358 132.707 183.483 138.72 181.23C140.082 183.729 140.409 186.662 139.63 189.4C139.63 189.4 150.15 172.82 150.47 168.6C151.17 159.08 138.65 150.31 122.5 149.09Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M139.593 189.55C142.185 181.415 132.9 171.192 118.855 166.718C104.81 162.244 91.3234 165.212 88.7317 173.348C86.14 181.483 95.4248 191.705 109.47 196.179C123.515 200.654 137.002 197.686 139.593 189.55Z", SvgAttrs.fill "#FDECE4" ] []
        , Svg.path [ SvgAttrs.opacity "0.8", d "M104.46 184.001C103.223 183.145 102.264 181.945 101.7 180.551C101.626 180.603 101.559 180.663 101.5 180.731C100.44 182.171 101.61 184.841 104.11 186.731C106.61 188.621 109.52 188.901 110.58 187.451C110.811 187.08 110.947 186.657 110.975 186.221C111.003 185.785 110.922 185.348 110.74 184.951C109.58 186.101 106.85 185.711 104.46 184.001Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ d "M108 181.419C105.6 179.659 102.89 179.299 101.73 180.469C102.301 181.86 103.259 183.057 104.49 183.919C106.89 185.679 109.6 186.039 110.76 184.919C110.192 183.524 109.234 182.323 108 181.46V181.419Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ SvgAttrs.opacity "0.8", d "M118.68 180.62C117.443 179.76 116.484 178.557 115.92 177.16L115.72 177.34C114.66 178.79 115.82 181.46 118.33 183.34C120.84 185.22 123.73 185.52 124.8 184.08C125.035 183.709 125.174 183.285 125.203 182.847C125.233 182.408 125.153 181.97 124.97 181.57C123.81 182.76 121.07 182.38 118.68 180.62Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ d "M122.21 178.1C119.83 176.33 117.11 175.98 115.95 177.1C116.513 178.494 117.473 179.694 118.71 180.55C121.1 182.31 123.82 182.68 125.02 181.48C124.426 180.096 123.452 178.91 122.21 178.06V178.1Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M152 89.0005C158.25 95.3805 161.46 103.37 161.36 110.57L146.42 103.79L112 94.6305C112.549 90.7249 114.357 87.1051 117.15 84.3205C125.64 75.9305 141.24 78.0005 152 89.0005Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M113.14 102.551C113.14 102.551 108.24 90.4606 117.71 88.2306C127.18 86.0006 141.44 94.4106 144.48 96.3706C147.52 98.3306 161.48 110.561 161.48 110.561C145.991 104.977 129.612 102.265 113.15 102.561L113.14 102.551Z", SvgAttrs.fill "#FDECE4" ] []
        , Svg.path [ d "M116.52 102.421C116.52 102.421 112.81 93.8511 119.52 92.1211C126.23 90.3911 136.58 96.1211 138.83 97.5711C141.08 99.0211 151.21 107.451 151.21 107.451C139.92 104.218 128.243 102.536 116.5 102.451L116.52 102.421Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ d "M66.4999 95.9312C64.7527 95.3815 62.9083 95.211 61.0899 95.4312C49.0299 95.1512 38.8099 100.381 35.9399 109.371C32.0699 121.371 79.1699 112.371 79.1699 112.371C78.821 111.272 78.4103 110.194 77.9399 109.141C75.5399 102.551 71.1099 97.6612 66.4999 95.9312Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M79.1698 112.36C79.1698 112.36 58.2998 107.2 51.3198 107.24C44.3398 107.28 36.6598 106.85 35.5698 110.71C34.4798 114.57 39.9398 119.11 44.5698 122.1C49.1998 125.09 67.7998 133.31 67.7998 133.31C67.7998 133.31 62.5298 122.45 79.1698 112.36Z", SvgAttrs.fill "#FDECE4" ] []
        , Svg.path [ d "M76.2799 114.271C76.2799 114.271 60.7599 111.001 55.4899 111.181C50.2199 111.361 44.3399 111.281 43.3899 114.181C42.4399 117.081 46.4799 120.421 49.9199 122.531C53.3599 124.641 66.9999 130.331 66.9999 130.331C66.9999 130.331 65.4099 122.001 76.2799 114.271Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ d "M316.99 111.99L336.1 98.0302L352.4 108.97L367.95 89.8202L381.93 90.6102L397.98 94.1902L402.32 72.6202L416.08 73.4002L421.2 53.6602L431.62 58.4802L439.21 77.6102L430.56 112.51L397.25 142.45L328.05 130.07L316.99 111.99Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M421.48 37.6191L419.48 40.2791L419 51.5191L430.9 63.5891C430.9 63.5891 434.97 68.8291 432.54 74.6691L438.72 68.1991L435.09 58.1391L421.48 37.6191Z", SvgAttrs.fill "#ECAF96" ] []
        , Svg.path [ d "M300.79 118.759L305.84 113.329L333.53 110.319L343.52 120.759L384.19 122.609L386.58 102.029L419.87 101.939L422.16 67.8091L425.02 66.0391L426.12 70.2291L425.01 107.159L390.46 107.669L386.75 131.299L336.57 130.459L326.81 118.239L300.79 118.759Z", SvgAttrs.fill "#ECAF96" ] []
        , Svg.path [ SvgAttrs.opacity "0.1", d "M366.17 139.069C383.66 138.919 397.6 125.559 408.17 124.189C417.9 122.919 422.87 133.249 423.42 138.919C424.65 151.529 399.89 161.969 368.12 162.239C336.35 162.509 309.6 152.509 308.38 139.899C307.76 133.599 314.93 117.139 323.65 123.609C334.52 131.709 350.28 139.209 366.17 139.069Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ SvgAttrs.opacity "0.1", d "M340.19 180C346.92 179.84 352.36 173.73 356.42 173.05C360.17 172.43 362.04 177.05 362.22 179.64C362.63 185.33 353.04 190.18 340.8 190.47C328.56 190.76 318.32 186.37 317.91 180.67C317.71 177.83 320.55 170.34 323.91 173.23C328 176.82 334.07 180.12 340.19 180Z", SvgAttrs.fill "#00005E" ] []
        , Svg.path [ d "M306.29 124.58L302.24 127.58C301.677 127.748 301.158 128.04 300.722 128.434C300.286 128.829 299.943 129.316 299.72 129.86C298.28 132.93 299.08 137.86 301.48 140.76C302.96 142.51 304.61 143.21 306.05 142.84L340.84 147.42C327.92 142.178 316.175 134.413 306.29 124.58Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.g [ SvgAttrs.opacity "0.3" ] [ Svg.path [ SvgAttrs.opacity "0.3", d "M306.29 124.58L304.39 126.58C303.25 126.91 318.56 144.89 320 144.52L340.84 147.4C327.922 142.163 316.177 134.406 306.29 124.58Z", SvgAttrs.fill "#00005E" ] [] ]
        , Svg.path [ d "M422.29 135.27C447.45 110.69 448.4 69.36 427.09 35.5L421.48 37.62L420.81 49.72L431.61 60.78C433.23 62.43 433.96 65.87 433.24 68.45C432.52 71.03 430.61 71.76 429 70.11L425 66L422.26 105.44L388 105.11L386.42 127.11L341 124.65L336.85 120.16L332.5 116.09L300.82 118.76C302.11 120.23 303.43 121.69 304.82 123.11C339.84 159 392.45 164.42 422.29 135.27Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.7", d "M388 105.109L387.06 118.169C398.015 116.483 408.377 112.095 417.21 105.399L388 105.109Z", SvgAttrs.fill "#FBD9CA" ] []
        , Svg.path [ SvgAttrs.opacity "0.7", d "M421.48 37.6208L420.81 49.7208L431.61 60.7808C433.23 62.4308 433.96 65.8708 433.24 68.4508C432.52 71.0308 430.61 71.7608 429 70.1108L425 66.0008L422.58 100.781L422.99 100.391C431.647 91.8709 437.753 81.1034 440.62 69.3008C438.181 57.3016 433.539 45.8584 426.93 35.5508L421.48 37.6208Z", SvgAttrs.fill "#FBD9CA" ] []
        , Svg.path [ d "M314.38 174.12L314.55 177.29L319.99 179.7L325.42 170.44L319.58 169.84L314.38 174.12Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ d "M312.96 188.88L312.94 192.19L346.16 186.95L349.58 196.62L355.22 176.88L360.26 173.86L360.54 171.27L325.02 170.24L312.96 188.88Z", SvgAttrs.fill "#F0C1AE" ] []
        , Svg.path [ SvgAttrs.opacity "0.7", d "M319.14 169.84L314.38 174.12L320.57 176.98L312.96 188.88L346.74 183.64L349.6 192.68L354.83 174.6L360.54 171.27L319.14 169.84Z", SvgAttrs.fill "#FBD9CA" ] []
        , Svg.path [ SvgAttrs.opacity "0.5", d "M329.6 182.131C336.641 179.312 343.254 175.525 349.25 170.881L319.14 169.881L314.39 174.161L320.57 177.021L314.85 185.961C319.933 185.443 324.907 184.151 329.6 182.131Z", SvgAttrs.fill "#FDECE4" ] []
        , Svg.path [ d "M306.23 124.4C306.23 124.4 285.98 162.87 259.73 163.4", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M306.78 125.111C306.78 125.111 296.3 153.701 267.35 175.001", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M307.45 125.781C307.45 125.781 299.45 157.211 285.45 178.181", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M308.08 126.561C308.08 126.561 301.83 168.501 303.9 172.561", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M308.55 127.16C308.55 127.16 306.55 160.01 311.9 162.57", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M268.21 161.851C268.21 161.851 275.69 161.101 274.87 168.851C274.87 168.851 285.87 164.691 289.37 171.661C289.37 171.661 296.75 162.921 303.56 165.601C303.56 165.601 305.61 158.791 309.94 159.451", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M280.6 155.191C280.6 155.191 284.95 154.821 284.77 159.191C284.77 159.191 292.54 155.691 294.77 161.241C294.77 161.241 299.01 155.701 304.17 157.451C304.17 157.451 306.05 153.631 309.01 155.451", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M290.22 146.53C290.22 146.53 293.1 145.48 293.22 149.03C293.22 149.03 297.38 147.53 299.38 150.41C299.38 150.41 301.98 148.09 305.03 149.41C305.478 149.013 306.034 148.758 306.627 148.68C307.221 148.602 307.824 148.703 308.36 148.97", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        , Svg.path [ d "M297.53 137.85C297.973 137.848 298.402 138.004 298.741 138.29C299.08 138.576 299.306 138.973 299.38 139.41C299.38 139.41 301.95 138.51 302.97 140.41C302.97 140.41 304.76 139.21 306.08 140.23C306.366 139.93 306.747 139.737 307.158 139.684C307.57 139.632 307.987 139.722 308.34 139.94", SvgAttrs.stroke "#111111", SvgAttrs.strokeWidth "0.25", SvgAttrs.strokeMiterlimit "10" ] []
        ]
