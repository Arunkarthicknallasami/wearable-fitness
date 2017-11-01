package com.jeffrey.testlocalnotification;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.jeffrey.testlocalnotification.notification.local.LocalNotificationManager;
import com.jeffrey.testlocalnotification.notification.local.LocalNotificationServiceReceiver;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Button testBtn1 = (Button) findViewById(R.id.testBtn1);
        testBtn1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                test1();
            }
        });

        final Button testBtn2 = (Button) findViewById(R.id.testBtn2);
        testBtn2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                test2();
            }
        });
    }

    protected void test1() {
        LocalNotificationManager.create(getApplicationContext(), 0);
    }

    protected void test2() {
        Intent intent = new Intent(LocalNotificationServiceReceiver.START_LOCAL_NOTIFICATION_SERVICE);
        getApplicationContext().sendBroadcast(intent);
    }
}
