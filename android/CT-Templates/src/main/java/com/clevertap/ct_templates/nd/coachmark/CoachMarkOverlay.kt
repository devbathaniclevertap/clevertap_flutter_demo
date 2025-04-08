package com.clevertap.ct_templates.nd.coachmark


import android.content.Context
import android.graphics.*
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.clevertap.ct_templates.R
import com.clevertap.ct_templates.databinding.CoachmarkitemCoachmarkBinding
import kotlin.math.roundToInt

class CoachMarkOverlay : FrameLayout {

    var mBuilder: Builder? = null
    private var mContext: Context? = context
    private var mBaseBitmap: Bitmap? = null
    private var mLayer: Canvas? = null
    private val mOverlayTintPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mOverlayTransparentPaint = Paint()

    private val binding =
        CoachmarkitemCoachmarkBinding.inflate(LayoutInflater.from(mContext), this, true)

    constructor(context: Context) : super(context) {
        init()
    }

    constructor(context: Context, builder: Builder) : super(context) {
        init()
        mBuilder = builder
    }

    private fun init() {
        binding.view.visibility = View.VISIBLE
        binding.view.setOnClickListener(null)
        this.setWillNotDraw(false)
        mOverlayTransparentPaint.color = Color.TRANSPARENT
        mOverlayTransparentPaint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_OUT)
        // hide
        binding.btnNext.setOnClickListener {
            mBuilder?.getOverlayClickListener()?.apply {
                onOverlayClick(this@CoachMarkOverlay, binding)
            }
        }

        binding.btnSkip.setOnClickListener {
            mBuilder?.getSkipClickListener()?.apply {
                onSkipClick(this@CoachMarkOverlay)
                binding.view.visibility = View.GONE
            }
        }
    }

    override fun onDraw(canvas: Canvas) {
        drawOverlayTint()
        drawTransparentOverlay()
        mBaseBitmap?.apply { canvas.drawBitmap(this, 0f, 0f, null) }
        super.onDraw(canvas)
    }

    private fun drawOverlayTint() = mBuilder?.apply {
        mBaseBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        mBaseBitmap?.apply {
            mLayer = Canvas(this)
            mOverlayTintPaint.color = getOverlayColor()
            val alpha = getOverlayOpacity()
            mOverlayTintPaint.alpha = alpha
            mLayer?.drawRect(Rect(0, 0, width, height), mOverlayTintPaint)
        }
    }

    private fun drawTransparentOverlay() = mBuilder?.apply {
        mLayer?.let { layer ->
            val targetViewSize = Rect()
            val targetView = getOverlayTargetView()
            
            // Get both screen location and visible rect
            val location = IntArray(2)
            targetView?.getLocationOnScreen(location)
            targetView?.getLocationInWindow(location)
            
            // Set precise target bounds
            targetViewSize.set(
                location[0],
                location[1],
                location[0] + (targetView?.width ?: 0),
                location[1] + (targetView?.height ?: 0)
            )

            val screenHeight = resources.displayMetrics.heightPixels
            val screenWidth = resources.displayMetrics.widthPixels
            
            binding.apply {
                // Set content first
                txvTitle.text = getTitle()
                txvSubTitle.text = getSubTitle()
                txvLimit.apply {
                    visibility = if (getMax() == 0) View.GONE else View.VISIBLE
                    text = if (visibility == View.VISIBLE) {
                        "(${getLimit() + 1}/${getMax() + 1})"
                    } else ""
                }

                // Measure dialog before positioning
                itemRoot.measure(
                    MeasureSpec.makeMeasureSpec(screenWidth - 64, MeasureSpec.AT_MOST),
                    MeasureSpec.makeMeasureSpec(screenHeight - 64, MeasureSpec.AT_MOST)
                )
                
                val dialogHeight = itemRoot.measuredHeight
                val dialogWidth = itemRoot.measuredWidth

                // Calculate target center and edges
                val targetTop = targetViewSize.top
                val targetBottom = targetViewSize.bottom
                val targetCenter = targetViewSize.centerX()
                
                // Calculate available space
                val spaceAbove = targetTop
                val spaceBelow = screenHeight - targetBottom
                
                // Determine optimal position
                val showBelow = when (getLimit()) {
                    0 -> true  // First item always below
                    1 -> false // Second item always above
                    else -> spaceBelow >= dialogHeight || spaceBelow > spaceAbove
                }

                // Position arrow
                itemDashed.apply {
                    visibility = View.VISIBLE
                    measure(
                        MeasureSpec.UNSPECIFIED,
                        MeasureSpec.UNSPECIFIED
                    )

                    if (showBelow) {
                        setImageResource(R.drawable.img_dashed_coachmark_top)
                        translationY = targetBottom.toFloat()
                    } else {
                        setImageResource(R.drawable.img_dashed_coachmark_bottom)
                        translationY = targetTop.toFloat() - measuredHeight
                    }
                    
                    // Center arrow horizontally with target
                    translationX = (targetCenter - measuredWidth / 2f)
                }

                // Position dialog
                itemRoot.apply {
                    visibility = View.VISIBLE
                    
                    // Calculate horizontal position
                    val minX = 32f
                    val maxX = (screenWidth - dialogWidth - 32f).coerceAtLeast(minX)
                    val idealX = targetCenter - dialogWidth / 2f
                    translationX = idealX.coerceIn(minX, maxX)
                    
                    // Calculate vertical position
                    if (showBelow) {
                        translationY = itemDashed.translationY + itemDashed.measuredHeight + 8
                    } else {
                        translationY = itemDashed.translationY - dialogHeight - 8
                    }
                    
                    // Ensure dialog stays within screen bounds
                    translationY = translationY.coerceIn(
                        32f,
                        screenHeight - dialogHeight - 32f
                    )
                }
            }

            // Draw highlight around target
            val padding = 8
            val highlightRect = Rect(
                targetViewSize.left - padding,
                targetViewSize.top - padding,
                targetViewSize.right + padding,
                targetViewSize.bottom + padding
            )
            
            layer.drawRoundRect(
                RectF(highlightRect),
                16f, 16f,
                mOverlayTransparentPaint
            )
        }
    }

    private fun positionLeftMiddleRight(left: Int, right: Int, halfWidth: Int): GravityIn {
        return if (halfWidth in left..right) {
            GravityIn.CENTER
        } else if (left in 1 until halfWidth) {
            GravityIn.START
        } else {
            GravityIn.END
        }
    }

    private fun positionTopBottom(bottom: Int, halfHeight: Int): GravityIn {
        return if (bottom in 1 until halfHeight) {
            GravityIn.TOP
        } else {
            GravityIn.BOTTOM
        }
    }

    fun show(root: ViewGroup) {
        root.addView(this)
    }

    class Builder(private val mContext: Context) {
        private var mOverlayTargetView: View? = null
        private var mOverlayColor: Int = Color.BLACK
        private var mOverlayOpacity: Int = 150
        private var mOverlayTransparentShape: Shape = Shape.BOX
        private var mOverlayTransparentCornerRadius: Float =
            mContext.resources.getDimension(R.dimen.margin_07)
        private var mOverlayTransparentMargin: Rect = Rect()
        private var mOverlayTransparentPadding: Rect = Rect()
        private var mOverlayClickListener: OverlayClickListener? = null
        private var mSkipClickListener: SkipClickListener? = null
        private var mTargetCoordinates: Rect = Rect()
        private var mBaseTabPosition: Int = -1
        private var mSetTitle: String = ""
        private var mSetSubTitle: String = ""
        private var mLimit: Int = 0
        private var mTextBtnPositive: String = ""
        private var mSkipBtn: String? = null
        private var mGravity: Gravity = Gravity.NULL
        private var mMax = 0

        private var mTextBtnPositiveBGColor: Int? = null // Store the color
        private var mTextBtnPositiveTextColor: Int? = null // Store the color
        private var mSkipBtnBGColor: Int? = null // Store the color
        private var mSkipBtnTextColor: Int? = null // Store the color

        fun getOverlayTargetView(): View? = mOverlayTargetView
        fun getOverlayColor(): Int = mOverlayColor
        fun getOverlayOpacity(): Int = mOverlayOpacity
        fun getOverlayTransparentShape(): Shape = mOverlayTransparentShape
        fun getOverlayTransparentCornerRadius(): Float = mOverlayTransparentCornerRadius
        fun getTabPosition(): Int = mBaseTabPosition
        fun getOverlayTransparentMargin(): Rect = mOverlayTransparentMargin
        fun getOverlayTransparentPadding(): Rect = mOverlayTransparentPadding
        fun getOverlayTargetCoordinates(): Rect = mTargetCoordinates
        fun getOverlayClickListener(): OverlayClickListener? = mOverlayClickListener
        fun getSkipClickListener(): SkipClickListener? = mSkipClickListener
        fun getTitle(): String = mSetTitle
        fun getSubTitle(): String = mSetSubTitle
        fun getLimit(): Int = mLimit
        fun getTextBtnPositive(): String = mTextBtnPositive
        fun getSkipBtn(): String? = mSkipBtn
        fun getGravity(): Gravity = mGravity
        fun getMax(): Int = mMax

        fun getTextBtnPositiveBGColor(): Int = mTextBtnPositiveBGColor!!
        fun getSkipBtnBGColor(): Int = mSkipBtnBGColor!!
        fun getTextBtnPositiveTextColor(): Int = mTextBtnPositiveTextColor!!
        fun getSkipBtnTextColor(): Int = mSkipBtnTextColor!!

        fun setOverlayTargetCoordinates(coordinates: Rect): Builder {
            mTargetCoordinates.set(coordinates)
            return this
        }

        fun setOverlayTargetView(view: View?): Builder {
            mOverlayTargetView = view
            return this
        }

        fun setTabPosition(position: Int): Builder {
            mBaseTabPosition = position
            return this
        }

        fun setOverlayTransparentPadding(left: Int, top: Int, right: Int, bottom: Int): Builder {
            mOverlayTransparentPadding.left = Utils.dpToPx(mContext, left).roundToInt()
            mOverlayTransparentPadding.top = Utils.dpToPx(mContext, top).roundToInt()
            mOverlayTransparentPadding.right = Utils.dpToPx(mContext, right).roundToInt()
            mOverlayTransparentPadding.bottom = Utils.dpToPx(mContext, bottom).roundToInt()
            return this
        }

        fun setOverlayClickListener(listener: OverlayClickListener): Builder {
            mOverlayClickListener = listener
            return this
        }

        fun setSkipClickListener(listener: SkipClickListener): Builder {
            mSkipClickListener = listener
            return this
        }

        fun setInfoText(title: String, subTitle: String, limit: Int): Builder {
            mSetTitle = title
            mSetSubTitle = subTitle
            mLimit = limit
            return this
        }

        fun setTextBtnPositive(text: String, bgColor: Int? = null, textColor: Int? = null): Builder {
            mTextBtnPositive = text
            mTextBtnPositiveBGColor = bgColor
            mTextBtnPositiveTextColor = textColor
            return this
        }

        fun setSkipBtn(text: String?, bgColor: Int? = null, textColor: Int? = null): Builder {
            mSkipBtn = text
            mSkipBtnBGColor = bgColor
            mSkipBtnTextColor = textColor
            return this
        }

        fun setGravity(gravity: Gravity): Builder {
            mGravity = gravity
            return this
        }

        fun build(max: Int): CoachMarkOverlay {
            mMax = max
            return CoachMarkOverlay(mContext, this)
        }
    }
}