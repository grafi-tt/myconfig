import XMonad
import XMonad.Config.Kde
import qualified XMonad.StackSet as W -- to shift and float windows
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import qualified Data.Map as M

isNotification :: Query Bool
isNotification = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION"

main = xmonad kde4Config
  { modMask = mod4Mask -- use the Windows button as mod
  , keys = myKeys
  , manageHook = manageHook kde4Config <+> myManageHook
  , layoutHook = myLayoutHook
  }

myKeys conf@(XConfig {modMask = modm}) = let_z_q . let_q_p $ keys kde4Config conf
  where let_q_p = M.update (const $ M.lookup (modm, xK_p) $ keys kde4Config conf) (modm, xK_q)
        let_z_q = M.update (const $ M.lookup (modm, xK_q) $ keys kde4Config conf) (modm, xK_z)

myLayoutHook = smartBorders $ layoutHook kde4Config

myManageHook = composeAll . concat $
  [ [ className =? c --> doFloat                       | c <- myFloats ]
  , [ className =? c --> doF (W.shift "2")             | c <- webApps ]
  , [ className =? c --> doF (W.shift "3")             | c <- ircApps ]
  , [ isNotification --> doIgnore ]
  ]
  where myFloats      = ["Gimp", "MPlayer", "VirtualBox"]
        webApps       = ["Firefox"]
        ircApps       = ["Ksirc"]
