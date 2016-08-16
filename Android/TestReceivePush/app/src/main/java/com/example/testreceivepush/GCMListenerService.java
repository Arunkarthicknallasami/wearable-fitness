package com.example.testreceivepush;

import com.google.android.gms.gcm.GcmListenerService;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.util.Log;

public class GCMListenerService extends GcmListenerService {
	private static final String TAG = "GCMListenerService";
	
    /**
     * Called when message is received.
     *
     * @param from SenderID of the sender.
     * @param data Data bundle containing message data as key/value pairs.
     *             For Set of keys use data.keySet().
     */
    // [START receive_message]
    @Override
    public void onMessageReceived(String from, Bundle data) {
        String message = data.getString("message");
        Log.d(TAG, "From: " + from);
        Log.d(TAG, "Message: " + message);

        if (from.startsWith("/topics/")) {
            // message received from some topic.
        } else {
            // normal downstream message.
        }

        // [START_EXCLUDE]
        /**
         * Production applications would usually process the message here.
         * Eg: - Syncing with server.
         *     - Store message in local database.
         *     - Update UI.
         */

        /**
         * In some cases it may be useful to show a notification indicating to the user
         * that a message was received.
         */
        sendNotification(message);
        // [END_EXCLUDE]
    }
    // [END receive_message]
	
    /**
     * Create and show a simple notification containing the received GCM message.
     *
     * @param message GCM message received.
     */
    private void sendNotification(String message) {
        // Build intent for notification content
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT);

        Uri defaultSoundUri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        /**
         * To build handheld notifications that are also sent to wearables,
         * use NotificationCompat.Builder, which is included in the v4 support library.
         *
         * It allows us  to create notifications using the latest notification features
         * such as action buttons and large icons, while remaining compatible
         * with Android 1.6 (API level 4) and higher.
         */

        // === wearable only code begins here ===//

        // Specify Wearable-only actions (equivalent to iOS actionable notification)
        NotificationCompat.Action action =
                new NotificationCompat.Action.Builder(
                        R.drawable.common_google_signin_btn_icon_light_normal,
                        "Accept", pendingIntent)
                        .build();

        // insert extended text content to your notification by adding one of
        // the "big view" styles to the notification. On a handheld device,
        // users can see the big view content by expanding the notification.
        // On a wearable device, the big view content is visible by default.
        NotificationCompat.BigTextStyle bigStyle = new NotificationCompat.BigTextStyle();
        bigStyle.bigText("To add the extended content to your notification, call setStyle() on the NotificationCompat.Builder object, passing it an instance of either BigTextStyle or InboxStyle.");

        // To build handheld notifications that are also sent to wearables, use NotificationCompat.Builder.
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle("GCM Message")
                .setContentText(message)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent)
                .extend(new NotificationCompat.WearableExtender().addAction(action))
                .setStyle(bigStyle)
                .setLargeIcon(BitmapFactory.decodeResource(
                getResources(), R.drawable.common_ic_googleplayservices));

        // Get an instance of the NotificationManager service
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
        //NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        // Build the notification and issues it with notification manager.
        notificationManager.notify(0 /* ID of notification */, notificationBuilder.build());
    }
}
