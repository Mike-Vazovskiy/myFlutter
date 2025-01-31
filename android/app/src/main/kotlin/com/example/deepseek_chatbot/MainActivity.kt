package com.example.offline_ai_chat

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "my_pytorch_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "loadModel" -> {
                        MyPytorchModule.loadModel(this)
                        result.success("OK - Model loaded")
                    }
                    "runModel" -> {
                        val prompt = call.argument<String>("prompt") ?: ""
                        val outputStr = MyPytorchModule.runModel(prompt)
                        result.success(outputStr)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}