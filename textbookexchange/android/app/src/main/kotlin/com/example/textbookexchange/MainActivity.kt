package com.example.textbookexchange

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    val database = Firebase.database
    val myRef = database.getReference("message)

    myRef.setValue("Hello World")
}
