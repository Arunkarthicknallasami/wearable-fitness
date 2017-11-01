package com.jeffrey.testlocalnotification.notification.local;

import android.app.IntentService;
import android.content.Intent;
import android.support.annotation.Nullable;
import android.util.Log;

/**
 * Created by Jeffrey Garcia Wong on 11/1/2017.
 */

public class LocalNotificationService extends IntentService {
    private static final String TAG = LocalNotificationService.class.getSimpleName();

    public LocalNotificationService() {
        super(TAG);
        Log.d(TAG, "instantiated");
    }

    @Override
    protected void onHandleIntent(@Nullable Intent intent) {
        Log.d(TAG, "onHandleIntent: " + intent);

        // invoke the work routine and retrieve the result
        int resultCode = doWork();

        // notify the UI via Local Notification and passed the resultCode
        LocalNotificationManager.create(getApplicationContext(), resultCode);
    }

    /**
     * Execute the lenghty operation
     * @return the result code based on the decision logic
     */
    protected int doWork() {
        // TODO: put all the lengthy operation here, such as network call, device I/O, computations ...

        // TODO: change the return value based on the decision logic, default to 0
        return 0;
    }
}
