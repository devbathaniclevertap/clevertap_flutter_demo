package com.clevertap.ct_templates.nd.coachmark

import android.app.Activity
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentActivity
import com.clevertap.ct_templates.R
import com.clevertap.ct_templates.databinding.CoachmarkitemCoachmarkBinding
import java.util.*

class CoachMarkSequence(private val mContext: Activity) {

    private val mSequenceQueue: Queue<CoachMarkOverlay.Builder> = LinkedList()
    var mCoachMark: CoachMarkOverlay? = null
    private var mSequenceItem: CoachMarkOverlay.Builder? = null
    private var onFinishCallback: OnFinishCallback? = null

    private val mCoachMarkSkipButtonClickListener: SkipClickListener =
        object : SkipClickListener {
            override fun onSkipClick(view: View) {
                (mContext.window.decorView as ViewGroup).removeView(view)
                mSequenceQueue.clear()
                onFinishCallback?.onFinish()
            }
        }
    private var mSequenceListener: SequenceListener = object : SequenceListener {}

    private val mCoachMarkOverlayClickListener: OverlayClickListener =
        object : OverlayClickListener {
            override fun onOverlayClick(overlay: CoachMarkOverlay, binding: CoachmarkitemCoachmarkBinding) {
                mCoachMark = overlay
                if (mSequenceQueue.isEmpty()) {
                    // This is the last item, clean up and finish
                    binding.view.visibility = View.GONE
                    (mContext.window.decorView as ViewGroup).removeView(overlay)
                    onFinishCallback?.onFinish()
                    return
                }

                // Handle next item
                mSequenceItem = mSequenceQueue.poll()
                mSequenceItem?.apply {
                    overlay.mBuilder?.let { builder ->
                        builder.setTabPosition(getTabPosition())
                        if (builder.getOverlayTargetView() != null) {
                            builder.setInfoText(getTitle(), getSubTitle(), getLimit())
                            builder.setSkipBtn(getSkipBtn(), getSkipBtnBGColor(), getSkipBtnTextColor())
                            builder.setTextBtnPositive(
                                getTextBtnPositive(), 
                                getTextBtnPositiveBGColor(), 
                                getTextBtnPositiveTextColor()
                            )
                            builder.setOverlayTargetView(getOverlayTargetView())
                            builder.setGravity(getGravity())
                            
                            // Force a redraw
                            overlay.invalidate()
                        }
                    }
                    mSequenceListener.apply {
                        onNextItem(overlay, this@CoachMarkSequence)
                    }
                }
            }
        }

    // set the data to view the next descriptions.
    fun setNextView() {
        if (mCoachMark != null && mSequenceItem != null) {
            mCoachMark?.invalidate()
        }
    }

    fun addItem(
        targetView: View,
        title: String = "",
        subTitle: String = "",
        positiveButtonText: String = mContext.getString(R.string.coachmarkNext),
        positiveButtonBGColor: Int = 0,
        positiveButtonTextColor: Int = 0,
        skipButtonText: String? = mContext.getString(R.string.coachmarkSkip),
        skipButtonBGColor: Int = 0,
        skipButtonTextColor: Int = 0,
        gravity: Gravity = Gravity.NULL,
    ) {
        CoachMarkOverlay.Builder(mContext).apply {
            setOverlayClickListener(mCoachMarkOverlayClickListener)
            setSkipClickListener(mCoachMarkSkipButtonClickListener)
            setOverlayTargetView(targetView)
            setInfoText(title, subTitle, mSequenceQueue.size)
            setTextBtnPositive(positiveButtonText, positiveButtonBGColor, positiveButtonTextColor)
            setSkipBtn(skipButtonText, skipButtonBGColor, skipButtonTextColor)
            setGravity(gravity)
            mSequenceQueue.add(this)
        }
    }

    fun start(rootView: ViewGroup? = null) {
        if (mSequenceQueue.size > 0) {
            val firstElement = mSequenceQueue.poll()
            val decorView = rootView ?: (mContext.window.decorView as ViewGroup)
            
            // Ensure we're on the main thread
            mContext.runOnUiThread {
                try {
                    decorView.post {
                        firstElement?.build(mSequenceQueue.size)?.show(decorView)
                    }
                } catch (e: Exception) {
                    Log.e("CoachMarkSequence", "Error showing coach marks: ${e.message}")
                    e.printStackTrace()
                }
            }
        }
    }

    fun setOnFinishCallback(onFinishCallback: OnFinishCallback) {
        this.onFinishCallback = onFinishCallback
    }

    fun interface OnFinishCallback {
        fun onFinish()
    }
}