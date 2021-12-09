module Explorer exposing (main)

import Config exposing (Config, Msg(..))
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Nordea.Resources.Fonts as Fonts
import Stories.Accordion as Accordion
import Stories.Button as Button
import Stories.Card as Card
import Stories.Checkbox as Checkbox
import Stories.Dropdown as Dropdown
import Stories.DropdownFilter as Search
import Stories.Error as Error
import Stories.FeatureBox as FeatureBox
import Stories.FlatLink as FlatLink
import Stories.InfoPanel as InfoPanel
import Stories.Label as Label
import Stories.LottiePlayer as LottiePlayer
import Stories.Modal as Modal
import Stories.NumberInput as NumberInput
import Stories.ProgressBar as ProgressBar
import Stories.ProgressBarStepper as ProgressBarStepper
import Stories.RadioButton as RadioButton
import Stories.Spinner as Spinner
import Stories.Status as Status
import Stories.StepIndicator as StepIndicator
import Stories.Table as Table
import Stories.Text as Header
import Stories.TextInput as TextInput
import Stories.Tooltip as Tooltip
import UIExplorer
    exposing
        ( UIExplorerProgram
        , explore
        )


type alias Model =
    UIExplorer.Model Config Msg {}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | customModel = Config.update msg model.customModel }, Cmd.none )


viewEnhancer : a -> Html msg -> Html msg
viewEnhancer _ stories =
    Html.div []
        [ Fonts.globalStyle "/fonts" |> toUnstyled
        , stories
        ]


main : UIExplorerProgram Config Msg {}
main =
    explore
        { customModel = Config.init
        , customHeader = Nothing
        , update = update
        , subscriptions = \_ -> Sub.none
        , viewEnhancer = viewEnhancer
        , menuViewEnhancer = \_ v -> v
        , onModeChanged = Nothing
        }
        [ Button.stories
        , FlatLink.stories
        , TextInput.stories
        , NumberInput.stories
        , Dropdown.stories
        , Search.stories
        , Checkbox.stories
        , RadioButton.stories
        , StepIndicator.stories
        , Accordion.stories
        , Spinner.stories
        , Label.stories
        , FeatureBox.stories
        , Card.stories
        , Header.stories
        , Status.stories
        , Modal.stories
        , Table.stories
        , ProgressBar.stories
        , ProgressBarStepper.stories
        , Error.stories
        , Tooltip.stories
        , LottiePlayer.stories
        , InfoPanel.stories
        ]
