package com.github.reactnativehero.splashscreen

import android.app.Dialog
import android.content.Context
import com.facebook.react.bridge.*

class RNTSplashScreenModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNTSplashScreen"
    }

    @ReactMethod
    fun hide() {
        RNTSplashScreenModule.hide()
    }

    companion object {

        private var sharedDialog: Dialog? = null

        @JvmStatic fun show(context: Context) {

            val dialog = Dialog(context, R.style.splash_screen_default)
            dialog.setContentView(R.layout.splash_screen_default)
            dialog.setCancelable(false)

            dialog.show()

            sharedDialog = dialog

        }

        fun hide() {

            val dialog = sharedDialog ?: return

            if (dialog.isShowing) {
                dialog.dismiss()
            }

            sharedDialog = null

        }

    }

}