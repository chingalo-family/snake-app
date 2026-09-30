package chingalo.family.snake_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Play Store's Open button, and some OEM launchers, start a second
        // MAIN/LAUNCHER activity on top of the real task. That extra activity
        // stays on the launch theme and never draws Flutter.
        if (!isTaskRoot &&
            intent?.action == Intent.ACTION_MAIN &&
            intent.hasCategory(Intent.CATEGORY_LAUNCHER)
        ) {
            finish()
        }
    }
}
