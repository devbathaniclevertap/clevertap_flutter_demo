package com.clevertap.ct_templates.nd.spotlights.effect

import android.animation.ObjectAnimator
import android.animation.TimeInterpolator
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.PointF
import android.view.animation.LinearInterpolator
import java.util.concurrent.TimeUnit

class EmptyEffect @JvmOverloads constructor(
    override val duration: Long = DEFAULT_DURATION,
    override val interpolator: TimeInterpolator = DEFAULT_INTERPOLATOR,
    override val repeatMode: Int = DEFAULT_REPEAT_MODE
) : Effect {

    override fun draw(canvas: Canvas, point: PointF, value: Float, paint: Paint) = Unit

    companion object {

        val DEFAULT_DURATION = TimeUnit.MILLISECONDS.toMillis(0)

        val DEFAULT_INTERPOLATOR = LinearInterpolator()

        const val DEFAULT_REPEAT_MODE = ObjectAnimator.REVERSE
    }
}