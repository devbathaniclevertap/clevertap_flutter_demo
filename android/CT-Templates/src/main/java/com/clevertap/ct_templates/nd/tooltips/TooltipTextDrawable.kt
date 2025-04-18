package com.clevertap.ct_templates.nd.tooltips

import android.annotation.TargetApi
import android.content.Context
import android.content.res.TypedArray
import android.graphics.*
import android.graphics.drawable.Drawable
import android.os.Build
import androidx.core.util.ObjectsCompat
import com.clevertap.ct_templates.R
import kotlin.math.floor

internal class TooltipTextDrawable(context: Context, builder: Tooltip.Builder) : Drawable() {
    private val rectF: RectF
    private val path: Path
    private val tmpPoint = PointF()
    private val outlineRect = Rect()
    private val bgPaint: Paint?
    private val stPaint: Paint?
    private val arrowRatio: Float
    private val radius: Float
    private var point: PointF? = null
    private var padding = 0
    private var arrowWeight = 0
    private var gravity: Tooltip.Gravity? = null

    init {


        val theme = context.theme.obtainStyledAttributes(
            null,
            R.styleable.TooltipLayout,
            builder.defStyleAttr,
            builder.defStyleRes
        )
        this.radius = theme.getDimensionPixelSize(R.styleable.TooltipLayout_ttlm_cornerRadius, 4).toFloat()
        val strokeWidth = theme.getDimensionPixelSize(R.styleable.TooltipLayout_ttlm_strokeWeight, 2)
//        val backgroundColor = theme.getColor(R.styleable.TooltipLayout_ttlm_backgroundColor, 0)
        val strokeColor = theme.getColor(R.styleable.TooltipLayout_ttlm_strokeColor, 0)
        this.arrowRatio = theme.getFloat(R.styleable.TooltipLayout_ttlm_arrowRatio, ARROW_RATIO_DEFAULT)
        theme.recycle()

        this.rectF = RectF()


        // Use builder-provided background color if available, else fall back to the theme-defined color
        val backgroundColor = builder.backgroundColor ?: theme.getColor(R.styleable.TooltipLayout_ttlm_backgroundColor, 0)
        bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = backgroundColor
            style = Paint.Style.FILL
        }

//        if (backgroundColor != 0) {
//            bgPaint = Paint(Paint.ANTI_ALIAS_FLAG)
//            bgPaint.color = backgroundColor
//            bgPaint.style = Paint.Style.FILL
//        } else {
//            bgPaint = null
//        }

        if (strokeColor != 0) {
            stPaint = Paint(Paint.ANTI_ALIAS_FLAG)
            stPaint.color = strokeColor
            stPaint.style = Paint.Style.STROKE
            stPaint.strokeWidth = strokeWidth.toFloat()
        } else {
            stPaint = null
        }

        path = Path()
    }

    // Method to update background color dynamically
    fun updateBackgroundColor(color: Int) {
        bgPaint?.color = color
        invalidateSelf()
    }


    override fun draw(canvas: Canvas) {
        bgPaint?.let {
            canvas.drawPath(path, it)
        }

        stPaint?.let {
            canvas.drawPath(path, it)
        }
    }

    fun setAnchor(gravity: Tooltip.Gravity, padding: Int, point: PointF?) {
        if (gravity != this.gravity || padding != this.padding || !ObjectsCompat.equals(this.point, point)) {
            this.gravity = gravity
            this.padding = padding
            this.arrowWeight = (padding.toFloat() / arrowRatio).toInt()

            point?.let {
                this.point = PointF(it.x, it.y)
            } ?: run {
                this.point = null
            }

            if (!bounds.isEmpty) {
                calculatePath(bounds)
                invalidateSelf()
            }
        }
    }

    private fun calculatePath(outBounds: Rect) {
        val left = outBounds.left + padding
        val top = outBounds.top + padding
        val right = outBounds.right - padding
        val bottom = outBounds.bottom - padding

        val maxY = bottom - radius
        val maxX = right - radius
        val minY = top + radius
        val minX = left + radius

        if (null != point && null != gravity) {
            calculatePathWithGravity(outBounds, left, top, right, bottom, maxY, maxX, minY, minX)
        } else {
            rectF.set(left.toFloat(), top.toFloat(), right.toFloat(), bottom.toFloat())
            path.addRoundRect(rectF, radius, radius, Path.Direction.CW)
        }
    }

    private fun calculatePathWithGravity(
        outBounds: Rect,
        left: Int,
        top: Int,
        right: Int,
        bottom: Int,
        maxY: Float,
        maxX: Float,
        minY: Float,
        minX: Float
    ) {

        if (gravity == Tooltip.Gravity.LEFT || gravity == Tooltip.Gravity.RIGHT) {
            if (maxY - minY < arrowWeight * 2) {
                arrowWeight = floor((maxY - minY) / 2).toInt()
            }
        } else if (gravity == Tooltip.Gravity.BOTTOM || gravity == Tooltip.Gravity.TOP) {
            if (maxX - minX < arrowWeight * 2) {
                arrowWeight = floor((maxX - minX) / 2).toInt()
            }
        }

        val drawPoint =
            isDrawPoint(left, top, right, bottom, maxY, maxX, minY, minX, tmpPoint, point!!, gravity, arrowWeight)


        clampPoint(left, top, right, bottom, tmpPoint)

        path.reset()

        // top/left
        path.moveTo(left + radius, top.toFloat())

        if (drawPoint && gravity === Tooltip.Gravity.BOTTOM) {
            path.lineTo((left + tmpPoint.x - arrowWeight).toFloat(), top.toFloat())
            path.lineTo((left + tmpPoint.x).toFloat(), outBounds.top.toFloat())
            path.lineTo((left + tmpPoint.x + arrowWeight).toFloat(), top.toFloat())
        }

        // top/right
        path.lineTo(right - radius, top.toFloat())
        path.quadTo(right.toFloat(), top.toFloat(), right.toFloat(), top + radius)

        if (drawPoint && gravity === Tooltip.Gravity.LEFT) {
            path.lineTo(right.toFloat(), (top + tmpPoint.y - arrowWeight).toFloat())
            path.lineTo(outBounds.right.toFloat(), (top + tmpPoint.y).toFloat())
            path.lineTo(right.toFloat(), (top + tmpPoint.y + arrowWeight).toFloat())
        }

        // bottom/right
        path.lineTo(right.toFloat(), bottom - radius)
        path.quadTo(right.toFloat(), bottom.toFloat(), right - radius, bottom.toFloat())

        if (drawPoint && gravity === Tooltip.Gravity.TOP) {
            path.lineTo((left + tmpPoint.x + arrowWeight).toFloat(), bottom.toFloat())
            path.lineTo((left + tmpPoint.x).toFloat(), outBounds.bottom.toFloat())
            path.lineTo((left + tmpPoint.x - arrowWeight).toFloat(), bottom.toFloat())
        }

        // bottom/left
        path.lineTo(left + radius, bottom.toFloat())
        path.quadTo(left.toFloat(), bottom.toFloat(), left.toFloat(), bottom - radius)

        if (drawPoint && gravity === Tooltip.Gravity.RIGHT) {
            path.lineTo(left.toFloat(), (top + tmpPoint.y + arrowWeight).toFloat())
            path.lineTo(outBounds.left.toFloat(), (top + tmpPoint.y).toFloat())
            path.lineTo(left.toFloat(), (top + tmpPoint.y - arrowWeight).toFloat())
        }

        // top/left
        path.lineTo(left.toFloat(), top + radius)
        path.quadTo(left.toFloat(), top.toFloat(), left + radius, top.toFloat())
    }

    override fun onBoundsChange(bounds: Rect) {
        super.onBoundsChange(bounds)
        calculatePath(bounds)
    }

    override fun getAlpha(): Int {
        return bgPaint?.alpha ?: run { 0 }
    }

    override fun setAlpha(alpha: Int) {
        bgPaint?.alpha = alpha
        stPaint?.alpha = alpha
    }

    override fun setColorFilter(cf: ColorFilter?) {}

    override fun getOpacity(): Int {
        return PixelFormat.TRANSLUCENT
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    override fun getOutline(outline: Outline) {
        copyBounds(outlineRect)
        outlineRect.inset(padding, padding)
        outline.setRoundRect(outlineRect, radius)
        if (alpha < 255) {
            outline.alpha = 0f
        }
        //outline.setAlpha(getAlpha() / ALPHA_MAX);
    }

    companion object {
        const val ARROW_RATIO_DEFAULT = 1.4f

        private fun isDrawPoint(
            left: Int, top: Int, right: Int, bottom: Int, maxY: Float, maxX: Float, minY: Float,
            minX: Float, tmpPoint: PointF, point: PointF, gravity: Tooltip.Gravity?,
            arrowWeight: Int
        ): Boolean {
            var drawPoint = false
            tmpPoint.set(point.x, point.y)

            if (gravity == Tooltip.Gravity.RIGHT || gravity == Tooltip.Gravity.LEFT) {
                if (tmpPoint.y in top.toFloat()..bottom.toFloat()) {
                    if (top + tmpPoint.y + arrowWeight > maxY) {
                        tmpPoint.y = (maxY - arrowWeight.toFloat() - top.toFloat())
                    } else if (top + tmpPoint.y - arrowWeight < minY) {
                        tmpPoint.y = (minY + arrowWeight - top)
                    }
                    drawPoint = true
                }
            } else {
                if (tmpPoint.x in left.toFloat()..right.toFloat()) {
                    if (tmpPoint.x in left.toFloat()..right.toFloat()) {
                        if (left + tmpPoint.x + arrowWeight > maxX) {
                            tmpPoint.x = (maxX - arrowWeight.toFloat() - left.toFloat())
                        } else if (left + tmpPoint.x - arrowWeight < minX) {
                            tmpPoint.x = (minX + arrowWeight - left)
                        }
                        drawPoint = true
                    }
                }
            }
            return drawPoint
        }

        private fun clampPoint(left: Int, top: Int, right: Int, bottom: Int, tmpPoint: PointF) {
            if (tmpPoint.y < top) {
                tmpPoint.y = top.toFloat()
            } else if (tmpPoint.y > bottom) {
                tmpPoint.y = bottom.toFloat()
            }
            if (tmpPoint.x < left) {
                tmpPoint.x = left.toFloat()
            }
            if (tmpPoint.x > right) {
                tmpPoint.x = right.toFloat()
            }
        }
    }
}