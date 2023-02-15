
import { NativeModules } from 'react-native'

const { RNTSplashScreen } = NativeModules

export function hide() {
  RNTSplashScreen.hide()
}
