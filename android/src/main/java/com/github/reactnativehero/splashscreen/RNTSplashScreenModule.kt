package com.github.reactnativehero.splashscreen

import android.app.Dialog
import android.content.Context
import android.os.Build
import android.view.View
import android.view.WindowManager
import android.graphics.Color
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
            if (sharedDialog != null) {
                return
            }

            val dialog = Dialog(context, R.style.splash_screen_dialog)
            dialog.setContentView(R.layout.splash_screen_default)
            dialog.setCancelable(false)
            dialog.setCanceledOnTouchOutside(false)

            dialog.window?.let { window ->
                // 1. 铺满屏幕（包括状态栏区域）
                window.setLayout(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT
                )

                // 2. 关键 Flags 设置
                // 确保绘制系统栏背景（配合透明颜色使用）
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)

                    // 显式设置透明色
                    window.statusBarColor = Color.TRANSPARENT
                    window.navigationBarColor = Color.TRANSPARENT
                }

                // 3. 布局行为：让内容延伸到系统栏下方
                // 移除 SYSTEM_UI_FLAG_FULLSCREEN，这样状态栏才会显示
                // 保留 LAYOUT_STABLE 和 LAYOUT_FULLSCREEN，这样布局内容会顶到最上面
                @Suppress("DEPRECATION")
                window.decorView.systemUiVisibility = (
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                )
            }

            try {
                dialog.show()
                sharedDialog = dialog
            }
            catch (e: Exception) {
                // 防止鸿蒙崩溃
            }
        }

        fun hide() {
            try {
                sharedDialog?.takeIf { it.isShowing }?.dismiss()
            }
            catch (e: Exception) {
            }
            finally {
                sharedDialog = null
            }
        }
    }
}
