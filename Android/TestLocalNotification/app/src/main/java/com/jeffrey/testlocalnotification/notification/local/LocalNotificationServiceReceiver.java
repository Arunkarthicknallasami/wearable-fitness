package com.jeffrey.testlocalnotification.notification.local;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.Calendar;

/**
 * Created by Jeffrey Garcia Wong on 11/1/2017.
 */

public class LocalNotificationServiceReceiver extends BroadcastReceiver {
    private static final String TAG = LocalNotificationServiceReceiver.class.getSimpleName();

    public static final String START_LOCAL_NOTIFICATION_SERVICE = "START_LOCAL_NOTIFICATION_SERVICE";
    public static final String WAKEUP_LOCAL_NOTIFICATION_SERVICE = "WAKEUP_LOCAL_NOTIFICATION_SERVICE";
    public static final String STOP_LOCAL_NOTIFICATION_SERVICE = "STOP_LOCAL_NOTIFICATION_SERVICE";

    protected static final Intent WakeUpServiceIntent = new Intent(WAKEUP_LOCAL_NOTIFICATION_SERVICE);

    private static boolean ENABLED = false;

    /*
        If the app is terminated from Android Task Manager, this receiver
        will be terminated as well
     */
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "received intent: " + intent.getAction());
        Log.d(TAG, "context is null? " + Boolean.valueOf(context==null?true:false));
        Log.d(TAG, "service enabled? " + Boolean.valueOf(ENABLED));

        if (ENABLED && WAKEUP_LOCAL_NOTIFICATION_SERVICE.equals(intent.getAction())) {
            executeLocalNotificationService(context);
            return;
        }

        // if OS restarted, trigger the background service even if app is not running
        // by default only system can generate this broadcast
        if (!ENABLED && "android.intent.action.BOOT_COMPLETED".equals(intent.getAction())) {
            ENABLED = true;
            executeLocalNotificationService(context);
            return;
        }

        // backdoor to trigger the background service, for development and testing
        // this receiver must be protected by the permission declared in AndroidManifest.xml
        if (!ENABLED && START_LOCAL_NOTIFICATION_SERVICE.equals(intent.getAction())) {
            ENABLED = true;
            executeLocalNotificationService(context);
            return;
        }

        // backdoor to terminate the background service, for development and testing
        // this receiver must be protected by the permission declared in AndroidManifest.xml
        if (ENABLED && STOP_LOCAL_NOTIFICATION_SERVICE.equals(intent.getAction())) {
            ENABLED = false;
            return;
        }
    }

    protected void executeLocalNotificationService(Context context) {
        Log.d(TAG, "execute service");

        // execute the service immediately
        final Intent localNotificationService = new Intent(context, LocalNotificationService.class);
        context.startService(localNotificationService);

        // schedule the next time to wakeup service
        scheduleNextRun(context);
    }

    protected void scheduleNextRun(Context context) {
        Log.d(TAG, "schedule next run");

        // schedule next re-run using AlarmManager to wake-up the service again
        final AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        // TODO: re-run frequency (temporary set to 5s and MUST be externalized!!!)
        alarmManager.set(
                AlarmManager.RTC,
                Calendar.getInstance().getTimeInMillis() + 5000,
                getWakeUpServiceIntent(context)
        );
    }

    protected PendingIntent getWakeUpServiceIntent(Context context) {
        Log.d(TAG, "get wakeup service intent");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, WakeUpServiceIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        return pendingIntent;
    }
}