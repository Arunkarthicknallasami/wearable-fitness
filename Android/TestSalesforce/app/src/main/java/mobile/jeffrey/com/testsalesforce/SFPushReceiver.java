package mobile.jeffrey.com.testsalesforce;

import android.os.Bundle;
import android.util.Log;

import com.salesforce.androidsdk.push.PushNotificationInterface;

/**
 * Created by jeffrey on 12/2/16.
 */

public class SFPushReceiver implements PushNotificationInterface {
    @Override
    public void onPushMessageReceived(Bundle message) {
        if (message != null) {
            for (String key: message.keySet()) {
                Log.d("message:" , "key: " + key + ", value: " + message.get(key));
            }
        }
    }
}
