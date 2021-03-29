import XMonad hiding ((|||))
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP, additionalMouseBindings)
import System.IO
import System.Exit
import XMonad.Actions.GroupNavigation
import XMonad.Layout.Tabbed
import XMonad.Hooks.InsertPosition
import XMonad.Layout.SimpleDecoration (shrinkText)
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.PhysicalScreens
import Data.Default
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.TwoPane
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Dwindle
myTabConfig = def { activeColor = "#1b1918"
                  , inactiveColor = "#1b1918"
                  , urgentColor = "#FDF6E3"
                  , activeBorderColor = "#a8a19f"
                  , inactiveBorderColor = "#1b1918"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#a8a19f"
                  , inactiveTextColor = "#a8a19f"
                  , urgentTextColor = "#1ABC9C"
                  , fontName = "xft:Ubuntu Mono:size=12"
                  }
myLayout = avoidStruts $
  noBorders (tabbed shrinkText myTabConfig)
  ||| tiled
  ||| Mirror tiled
  where
     tiled = spacing 3 $ ResizableTall nmaster delta ratio []
     twopane = spacing 3 $ TwoPane delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
myPP = def { ppCurrent = xmobarColor "#1ABC9C" "" . wrap "[" "]"
           , ppTitle = xmobarColor "#1ABC9C" "" . shorten 60
           , ppVisible = wrap "(" ")"
           , ppUrgent  = xmobarColor "red" "yellow"
           , ppSort = getSortByXineramaPhysicalRule def
           }
myManageHook = composeAll [ isFullscreen --> doFullFloat

                          ]
main = do
    spawn "~/.xmonad/autostart"
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh def
        { modMask = mod4Mask
        , manageHook = manageDocks <+> myManageHook
        , layoutHook = myLayout
        , handleEventHook = handleEventHook def <+> docksEventHook
        , logHook = dynamicLogWithPP myPP {
                                          ppOutput = hPutStrLn xmproc
                                          }
                        >> historyHook
        , terminal = "urxvt"
        , normalBorderColor  = "#007700"
        , focusedBorderColor = "#00bb00"
        }
