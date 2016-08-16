package com.example.testreceivepush;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

public class MainActivity extends Activity {
	private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
	private static final String TAG = "MainActivity";
	 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
        if (checkPlayServices()) {
        	// TODO add necessary handling to UI for the asynchronous GCM registration process
        	
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(this, GCMRegistrationService.class);
            startService(intent);
        }
	}
	
	
    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
    	boolean result = false;
    	
    	try {
            GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
            int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
            Log.i(TAG, "check Google Play Service result code: " + resultCode);
            
            if (resultCode != ConnectionResult.SUCCESS) {
            	result = false;
            	
            	/* There can be many different scenarios where Google Play Services is not functioning. 
            	 * We may not want to import the Google Play Services library project in the core
            	 * mobile app source code.
            	 * 
            	 * Instead we have can consider 2 possible outcomes:
            	 * - we do NOT handle any error, just proceed with app launch and ignore the device registration with push
            	 * - if the error code is due to an outdated version of Google Play Service, we may re-direct the user to 
            	 *   Google Play while we keep our app running in background
            	 */
            	if (resultCode == ConnectionResult.SERVICE_VERSION_UPDATE_REQUIRED) {
                	startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.google.android.gms")));            		
            	}
            	
            } else {
            	result = true;
            }
            
    	} catch (Throwable t) { // catch throwable instead of exception to improve the defensive mechanism
    		result = false;
    		Log.e(TAG, t.getMessage());
    	}
    	
    	return result;
    }
}
