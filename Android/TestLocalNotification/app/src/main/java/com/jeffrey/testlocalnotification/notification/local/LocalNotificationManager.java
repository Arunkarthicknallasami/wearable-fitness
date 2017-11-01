package com.jeffrey.testlocalnotification.notification.local;

import android.app.NotificationManager;
import android.content.Context;
import android.support.v7.app.NotificationCompat;
import android.support.v7.view.ContextThemeWrapper;
import android.util.Log;

/**
 * Created by Jeffrey Garcia Wong on 11/1/2017.
 */

public class LocalNotificationManager {
    private static final String TAG = LocalNotificationManager.class.getSimpleName();

    public static final int LOCAL_NOTIFICATION_ID = TAG.hashCode();

    protected static NotificationManager mNotificationManager;

    /**
     * Utility method to create the local notification UI and present it
     * @param context
     */
    public static void create(final Context context, final int resultCode) {
        Log.d(TAG, "context is null? " + Boolean.valueOf(context==null?true:false));
        Log.d(TAG, "result code: " + resultCode);

        // make sure any running notification task is been cancelled before generating a new one
        cancel();

        // Instantiate a builder object
        mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
                new ContextThemeWrapper(context, android.R.style.Theme_Holo));

        // TODO: depends on the resultCode value, load the customized handling here ...
        switch (resultCode) {
            case 0:
                // type-0 notification ...
                break;
            case 1:
                // type-1 notification ...
                break;
            case 2:
                // type-2 notification ...
                break;
            case 3:
                // type-3 notification ...
                break;
            case 4:
                // type-4 notification ...
                break;
            case 5:
                // type-5 notification ...
                break;
            case 6:
                // type-6 notification ...
                break;
            default:
                break;
        }

        // TODO: title should be externalized
        mBuilder.setContentTitle(context.getApplicationInfo().loadLabel(context.getPackageManager()).toString());

        // TODO: content should be externalized
        mBuilder.setContentText("This is a testing local notification");

        // TODO: icon should be externalized
        mBuilder.setSmallIcon(android.R.drawable.stat_notify_sync);

        mNotificationManager.notify(LOCAL_NOTIFICATION_ID, mBuilder.build());
    }

    /**
     * Utility method to interrupt a running local notification UI and dismiss it
     */
    public static void interrupt() {
        // TODO: implement this if needed
    }

    /**
     * Utility method to cancel a running local notification UI and dismiss it
     */
    public static void cancel() {
        // TODO: implement this if needed
    }
}
