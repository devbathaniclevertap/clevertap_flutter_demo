package com.clevertap.ct_templates.nd.coachmark

import android.R
import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentActivity
import org.json.JSONException
import org.json.JSONObject


class CoachMarkHelper {

    lateinit var coachMarkSequence: CoachMarkSequence

    fun renderCoachMark(context: Activity, unit: JSONObject, onComplete: () -> Unit) {
        try {
            coachMarkSequence = CoachMarkSequence(context)
            coachMarkSequence.apply {
                var customKv = unit.optJSONObject("custom_kv")
                if (customKv != null && customKv.has("nd_json")) {
                    val ndJsonString = customKv.optString("nd_json", null)
                    if (!ndJsonString.isNullOrEmpty()) {
                        val parsedNdJson = JSONObject(ndJsonString)
                        Log.d("CoachMarkHelper", "Parsed nd_json: $parsedNdJson")
                        for (key in parsedNdJson.keys()) {
                            customKv.put(key, parsedNdJson.get(key))
                        }
                    }
                }

                Log.d("CoachMarkHelper", "Merged customKv: $customKv")
                val coachMarkCount = customKv?.optInt("nd_coachmarks_count", -1)
                if (coachMarkCount == -1) {
                    throw JSONException("'nd_coachmarks_count' is missing or invalid")
                }

                for (i in 1..coachMarkCount!!) {
                    try {
                        val titleKey = "nd_view${i}_title"
                        val subTitleKey = "nd_view${i}_subtitle"
                        val viewIdKey = "nd_view${i}_id"
                        val viewIdString = customKv.optString(viewIdKey)
                        if (viewIdString.isNullOrEmpty()) {
                            throw JSONException("'$viewIdKey' is missing or empty")
                        }

//                        val viewId = context.resources.getIdentifier(
//                            viewIdString,
//                            "tagged_view",
//                            context.packageName
//                        )

                        val viewId = resolveViewId(context, viewIdString)
                        Log.d("CoachMarkHelper", "Resolved view ID for key " + viewIdKey + ": " + viewId);

                        val isLastItem = (i == coachMarkCount)
                        addCoachMarkItem(viewId, titleKey, subTitleKey, isLastItem, context, customKv)
                    } catch (e: JSONException) {
                        Log.e(
                            "CoachMarkHelper",
                            "Error processing coach mark item $i: ${e.message}"
                        )
                    }
                }
                Log.d("CoachMarkHelper","All Views Found")
//                Toast.makeText(context, "Hello this is a testing toast", Toast.LENGTH_LONG).show()
                
                // Get the root view using android.R.id.content
                val rootView = context.findViewById<ViewGroup>(android.R.id.content)
                if (rootView != null) {
                    context.runOnUiThread {
                        try {
                            start(rootView)
                            setOnFinishCallback {
                                // Ensure we're on the main thread for cleanup
                                context.runOnUiThread {
                                    try {
                                        // Find and remove any remaining overlay views
                                        for (i in 0 until rootView.childCount) {
                                            val child = rootView.getChildAt(i)
                                            if (child is CoachMarkOverlay) {
                                                rootView.removeView(child)
                                            }
                                        }
                                        onComplete()
                                    } catch (e: Exception) {
                                        Log.e("CoachMarkHelper", "Error during cleanup: ${e.message}")
                                        onComplete()
                                    }
                                }
                            }
                        } catch (e: Exception) {
                            Log.e("CoachMarkHelper", "Error starting coach marks: ${e.message}")
                            onComplete()
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("CoachMarkHelper", "Error in renderCoachMark: ${e.message}")
            onComplete()
        }
    }

    fun findViewWithTestId(root: View?, testId: String): View? {
        if (root == null) {
            return null
        }
        // It correctly checks the view's contentDescription
        if (testId == root.contentDescription) {
            Log.d("SDK_findViewWithTestId", "Found view with contentDescription: '$testId'")
            return root
        }
        // Recursively searches children
        if (root is ViewGroup) {
            val group = root
            for (i in 0 until group.childCount) {
                val childResult = findViewWithTestId(group.getChildAt(i), testId)
                if (childResult != null) {
                    return childResult
                }
            }
        }
        return null
    }

    // THIS FUNCTION REMAINS UNCHANGED IN THE SDK
    fun resolveViewId(activity: Activity, testId: String?): Int {
        // Note: Original code had testId!! - potentially unsafe if testId could be null.
        // A safer version would check for null first, but we rely on the provided SDK code.
        if (testId == null) {
            Log.w("SDK_resolveViewId", "testId is null, cannot resolve.")
            return 0
        }
        // It correctly finds the root view
        val rootView = activity.findViewById<View>(R.id.content)?.rootView // Using android.R.id.content
        if (rootView == null) {
            Log.e("SDK_resolveViewId", "Root view is null.")
            return 0
        }
        // It calls findViewWithTestId to search using contentDescription
        Log.d("SDK_resolveViewId", "Searching for view with testId (contentDescription): '$testId'")
        val targetView = findViewWithTestId(rootView, testId) // Calls the function above
        // It returns the view's Android ID if found, otherwise 0
        val foundId = targetView!!.id
            Log.i("SDK_resolveViewId", "View found for testId '$testId', returning ID: $foundId")

        return foundId
    }

    fun addCoachMarkItem(
        viewId: Int,
        titleKey: String,
        subTitleKey: String,
        isLastItem: Boolean = false,
        context: Activity,
        customKv: JSONObject
    ) {
        try {
            coachMarkSequence.addItem(
                targetView = context.findViewById(viewId),
                title = customKv.optString(titleKey, "Default Title"),
                subTitle = customKv.optString(subTitleKey, "Default Subtitle"),
                positiveButtonText = if (isLastItem) {
                    customKv.optString("nd_final_positive_button_text", "Ready to Explore")
                } else {
                    customKv.optString("nd_positive_button_text", "Next")
                },
                skipButtonText = if (isLastItem) null else customKv.optString(
                    "nd_skip_button_text",
                    "Skip"
                ),
                positiveButtonTextColor = Color.parseColor(
                    customKv.optString("nd_positive_button_text_color", "#FFFFFF")
                ),
                positiveButtonBGColor = Color.parseColor(
                    customKv.optString("nd_positive_button_background_color", "#E83938")
                ),
                skipButtonBGColor = if (!isLastItem) {
                    Color.parseColor(
                        customKv.optString(
                            "nd_skip_button_background_color",
                            "#FFFFFF"
                        )
                    )
                } else {
                    Color.TRANSPARENT
                },
                skipButtonTextColor = if (!isLastItem) {
                    Color.parseColor(customKv.optString("nd_skip_button_text_color", "#000000"))
                } else {
                    Color.TRANSPARENT
                }
            )
        } catch (e: JSONException) {
            Log.e("CoachMarkHelper", "Error adding coach mark item: ${e.message}")
        } catch (e: Exception) {
            Log.e("CoachMarkHelper", "Unexpected error: ${e.message}")
        }
    }
}