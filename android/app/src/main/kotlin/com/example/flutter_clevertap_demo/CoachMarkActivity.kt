package com.example.flutter_clevertap_demo

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import org.json.JSONArray

class CoachMarkActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val jsonString = intent.getStringExtra("json_data")
        if (jsonString.isNullOrEmpty()) {
            Log.e("CoachMarkActivity", "Error: No JSON data received")
            finish()
            return
        }

        try {
            val jsonArray = JSONArray(jsonString)
            if (jsonArray.length() == 0) {
                Log.e("CoachMarkActivity", "Error: JSON array is empty")
                finish()
                return
            }

            val jsonObject = jsonArray.getJSONObject(0)
            val coachMarkHelper = CoachMarkHelper()

            Log.d("CoachMarkActivity", "Displaying coach marks: $jsonString")
            coachMarkHelper.renderCoachMark(this, jsonObject) {
                finish() // Close activity when completed
            }
        } catch (e: Exception) {
            Log.e("CoachMarkActivity", "Error rendering coach marks: ${e.message}")
            finish()
        }
    }
}
