import XMonad
import XMonad.Config.Kde
import qualified XMonad.StackSet as W -- to shift and float windows
import XMonad.Hooks.ManageHelpers

isNotification :: Query Bool
isNotification = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION"

main = xmonad kde4Config
  { modMask = mod4Mask -- use the Windows button as mod
  , manageHook = manageHook kdeConfig <+> myManageHook
  }

myManageHook = composeAll . concat $
  [ [ className   =? c --> doFloat           | c <- myFloats]
  , [ title       =? t --> doFloat           | t <- myOtherFloats]
  , [ className   =? c --> doF (W.shift "2") | c <- webApps]
  , [ className   =? c --> doF (W.shift "3") | c <- ircApps]
  , [ isNotification --> doIgnore ]
  ]
  where myFloats      = ["MPlayer", "Gimp"]
        myOtherFloats = ["alsamixer"]
        webApps       = ["Firefox"]
        ircApps       = ["Ksirc"]
