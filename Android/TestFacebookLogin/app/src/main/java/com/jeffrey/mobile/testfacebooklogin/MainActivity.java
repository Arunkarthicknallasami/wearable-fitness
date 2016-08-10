package com.jeffrey.mobile.testfacebooklogin;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.widget.TextView;

import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.Date;

public class MainActivity extends FragmentActivity {
    protected CallbackManager fbCallbackManager;
    protected AccessTokenTracker fbTokenTracker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.
        initFacebookSdk();

        setContentView(R.layout.activity_main);

        final TextView tokenValue = (TextView) findViewById(R.id.token_value);
        if (null != AccessToken.getCurrentAccessToken()) {
            Log.d("initial token: ", AccessToken.getCurrentAccessToken().getToken());
            tokenValue.setText(AccessToken.getCurrentAccessToken().getToken());
        } else {
            Log.d("Login required", "Token is null");
            tokenValue.setText("token not available, login required.");
        }

        fbCallbackManager = CallbackManager.Factory.create();
        LoginManager.getInstance().registerCallback(fbCallbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        // App code
                        Log.d("facebook login", "onSuccess");
                    }

                    @Override
                    public void onCancel() {
                        // App code
                        Log.d("facebook login", "onCancel");
                    }

                    @Override
                    public void onError(FacebookException exception) {
                        // App code
                        Log.d("facebook login", "onError");
                        Log.e("facebook login", exception.getMessage(), exception.fillInStackTrace());
                    }
                });

        fbTokenTracker = new AccessTokenTracker() {
            @Override
            protected void onCurrentAccessTokenChanged(
                    AccessToken oldAccessToken,
                    AccessToken currentAccessToken) {
                // Set the access token using
                // currentAccessToken when it's loaded or set.
                if (null != oldAccessToken)
                    Log.d("old token: ", oldAccessToken.getToken());

                if (null != currentAccessToken) {
                    // access token has been assigned or becomes available
                    tokenValue.setText(currentAccessToken.getToken());
                    Log.d("current token: ", currentAccessToken.getToken());
                    Log.d("user ID: ", currentAccessToken.getUserId());
                    Log.d("token expiry: ", currentAccessToken.getExpires().toString());

                } else {
                    // access token has been destroyed or becomes unavailable
                    tokenValue.setText("token not available, login required.");
                }
            }
        };
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        /**
         * Every activity and fragment that you integrate with the FacebookSDK Login
         * or Share should forward onActivityResult to the fbCallbackManager
         */
        Log.d("request code: ", String.valueOf(requestCode));
        Log.d("result code: ", String.valueOf(resultCode));
        fbCallbackManager.onActivityResult(requestCode, resultCode, data);
    }

    protected void initFacebookSdk() {
        /** automatically log app activation events to measure installs
         * on your mobile app ads, create high value audiences for targeting,
         * and view analytics including user demographics
         */
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);
    }
}
