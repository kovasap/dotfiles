import qualified Data.Map as M

import XMonad
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Util.Dzen
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Layout.ResizableTile
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Grid
-- import qualified XMonad.Layout.Spacing as S
-- import qualified XMonad.Layout.ToggleLayouts as TL

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

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
    [ (mod1Mask, xK_h)
    , (mod1Mask, xK_l)
    , (mod1Mask, xK_p)
    ] `additionalKeys`
    [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/pictures/screenshots/'")
    , ((0, xK_Print), spawn "scrot -e 'mv $f ~/pictures/screenshots/'")
    , ((0, xK_F7), toggleMute >> return())
    , ((0, xK_F8), lowerVolume 4 >>= alert)
    , ((0, xK_F9), raiseVolume 4 >>= alert)
    -- slave (vertical when in tall mode) resizing in resizableTile layout
    , ((controlMask .|. mod1Mask, xK_k), sendMessage ShrinkSlave)
    , ((controlMask .|. mod1Mask, xK_j), sendMessage ExpandSlave)
    -- master (horizontal when in tall mode) resizing in resizableTile layout
    , ((controlMask .|. mod1Mask, xK_h), sendMessage Shrink)
    , ((controlMask .|. mod1Mask, xK_l), sendMessage Expand)
    -- reflect layouts
    , ((mod1Mask, xK_h), sendMessage $ Toggle REFLECTX)
    , ((mod1Mask, xK_l), sendMessage $ Toggle REFLECTY)
    , ((mod1Mask, xK_Escape), spawn "/usr/share/goobuntu-desktop-files/xsecurelock.sh")
    , ((mod1Mask, xK_p), spawn "j4-dmenu-desktop")
    , ((mod1Mask, xK_Return), spawn "terminator")
    , ((mod1Mask, xK_backslash), spawn "google-chrome")
    -- , ((mod1Mask, xK_f), sendMessage TL.ToggleLayout)
    ]
