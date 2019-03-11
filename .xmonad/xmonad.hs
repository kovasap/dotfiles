import qualified Data.Map as M

import XMonad
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.Volume
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.Dzen
import XMonad.Util.Run
-- TODO use this when xmonad-extras is upgraded to 0.15
-- import XMonad.Util.Brightness as Bright
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Layout.ResizableTile
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Grid
import XMonad.Layout.IndependentScreens
-- import qualified XMonad.Layout.Spacing as S
-- import qualified XMonad.Layout.ToggleLayouts as TL

-- The main function.
main = do
    config <- statusBar myBar myPP toggleStrutsKey myConfig
    xmonad config {modMask = mod4Mask}

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (mod4Mask, xK_b)

-- For fullscreen stuff
myEventHook = ewmhDesktopsEventHook <+> fullscreenEventHook -- <+> E.fullscreenEventHook 
myManageHook = manageHook defaultConfig <+> (isFullscreen --> doFullFloat)

-- Better Tall layout with vertical resizing
-- Two master panes, 1/10th resize increment, only show master
-- panes by default. Unlike plain 'Tall', this also allows
-- resizing the master panes, via the 'MirrorShrink' and
-- 'MirrorExpand' messages.
-- tall = ResizableTall 2 (1/10) 1 []

-- myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
--             [ ((modMask, xK_Left),  sendMessage MirrorExpand)
--             , ((modMask, xK_Up),    sendMessage MirrorExpand)
--             , ((modMask, xK_Right), sendMessage MirrorShrink)
--             , ((modMask, xK_Down),  sendMessage MirrorShrink)
--             ]

-- Show current volume on screen, CURRENTLY NOT WORKING
-- see http://dmwit.com/volume/
alert = dzenConfig return . show

-- Main configuration, override the defaults to your liking.
myConfig = defaultConfig
    { terminal    = "terminator"
    , handleEventHook = myEventHook
    , layoutHook = mkToggle (single REFLECTX) $
                   mkToggle (single REFLECTY) $
                   -- to add spacing around windows
                   -- S.smartSpacing 0 $
                   (mouseResizableTile{fracIncrement=0.02, draggerType=BordersDragger}
                    ||| Full
                    ||| mouseResizableTile{nmaster=2, fracIncrement=0.02, draggerType=BordersDragger}
                    ||| mouseResizableTile{nmaster=3, fracIncrement=0.02, draggerType=BordersDragger}
                    ||| mouseResizableTileMirrored{fracIncrement=0.02, draggerType=BordersDragger}
                    )
                   -- ||| reflectHoriz mouseResizableTile{fracIncrement=0.02}
                   -- ||| reflectVert mouseResizableTileMirrored{fracIncrement=0.02}
                   -- ||| Grid
                   -- ||| Full
    , manageHook = myManageHook
    , focusedBorderColor = "#006400"
    , normalBorderColor = "#191919"
    , borderWidth = 1
    -- , keys = myKeys
    } `removeKeys`
    -- we want to override these keys, so we remove their default actions here
    -- useful reference: http://web.mit.edu/nelhage/Public/xmonad.hs
    [ (mod4Mask, xK_h)
    , (mod4Mask, xK_l)
    , (mod4Mask, xK_p)
    , (mod4Mask, xK_w)
    , (mod4Mask, xK_e)
    , (mod4Mask, xK_r)
    ] `additionalKeys`
    -- see /usr/include/X11/keysymdef.h or /usr/include/X11/XF86keysym.h for
    -- names of keys!  also try using "xev" in terminal and press keys
    [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/pictures/screenshots/'")
    , ((0, xK_Print), spawn "scrot -e 'mv $f ~/pictures/screenshots/'")
    , ((0, xF86XK_AudioMute), toggleMute >> return())
    , ((0, xF86XK_AudioLowerVolume), lowerVolume 4 >>= alert)
    , ((0, xF86XK_AudioRaiseVolume), raiseVolume 4 >>= alert)
    , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 5%")
    , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 5%")
    -- use this when xmonad extras is upgraded
    -- , ((0, xF86XK_MonBrightnessUp), Bright.increase)
    -- , ((0, xF86XK_MonBrightnessDown), Bright.decrease)
    -- slave (vertical when in tall mode) resizing in resizableTile layout
    , ((controlMask .|. mod4Mask, xK_k), sendMessage ShrinkSlave)
    , ((controlMask .|. mod4Mask, xK_j), sendMessage ExpandSlave)
    -- master (horizontal when in tall mode) resizing in resizableTile layout
    , ((controlMask .|. mod4Mask, xK_h), sendMessage Shrink)
    , ((controlMask .|. mod4Mask, xK_l), sendMessage Expand)
    -- reflect layouts
    , ((mod4Mask, xK_e), sendMessage $ Toggle REFLECTX)
    , ((mod4Mask, xK_r), sendMessage $ Toggle REFLECTY)
    , ((mod4Mask, xK_Escape), spawn "/usr/share/goobuntu-desktop-files/xsecurelock.sh")
    , ((mod4Mask, xK_p), spawn "j4-dmenu-desktop")
    , ((mod4Mask, xK_Return), spawn "terminator")
    , ((mod4Mask, xK_backslash), spawn "google-chrome")
    , ((mod4Mask, xK_h), nextScreen)
    , ((mod4Mask, xK_l), prevScreen)
    -- , ((mod4Mask, xK_f), sendMessage TL.ToggleLayout)
    ]
