package com.github.reactnativehero.splashscreen

import android.app.Dialog
import android.content.Context
import android.os.Build
import android.view.View
import android.view.WindowManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

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

        @JvmStatic
        fun show(context: Context) {

            val dialog = Dialog(context, R.style.splash_screen_default)
            dialog.setContentView(R.layout.splash_screen_default)
            dialog.setCancelable(false)

            dialog.window?.let { window ->
                // 全屏布局
                window.setLayout(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT
                )

                // 沉浸式状态栏（替代废弃的 systemUiVisibility）
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
                    window.statusBarColor = android.graphics.Color.TRANSPARENT
                }

                // Android 11+ 新API：全屏沉浸
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    window.setDecorFitsSystemWindows(false)
                } else {
                    @Suppress("DEPRECATION")
                    window.decorView.systemUiVisibility = (
                        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    )
                }

                // Android 4.4 兼容
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT
                    && Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                    @Suppress("DEPRECATION")
                    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
                }
            }

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
