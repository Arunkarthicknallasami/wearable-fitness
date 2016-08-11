package com.jeffrey.mobile.testfacebooklogin;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class MainActivity extends FragmentActivity {
    protected LoginButton loginButton;

    protected CallbackManager fbCallbackManager;
    protected AccessTokenTracker fbTokenTracker;

    protected TextView logonStatus;
    protected TextView tokenValue;

    // post logon UI
    protected EditText graphApi;
    protected Button submitMeRequestBtn;
    protected Button submitPathRequestBtn;
    protected TextView responseText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.
        initFacebookSdk();

        setContentView(R.layout.activity_main);
        logonStatus = (TextView) findViewById(R.id.logon_status);
        tokenValue = (TextView) findViewById(R.id.token_value);

        graphApi = (EditText) findViewById(R.id.graph_api);
        submitPathRequestBtn = (Button) findViewById(R.id.submit_graph_path_request);
        submitMeRequestBtn = (Button) findViewById(R.id.submit_graph_me_request);

        responseText = (TextView) findViewById(R.id.graph_response);

        if (null != AccessToken.getCurrentAccessToken()) {
            Log.d("initial token: ", AccessToken.getCurrentAccessToken().getToken());
            logonStatus.setText("facebook login success");
            tokenValue.setText(AccessToken.getCurrentAccessToken().getToken());
        } else {
            Log.d("Login required", "Token is null");
            logonStatus.setText("facebook login required");
            tokenValue.setText("token not available");
        }

        /**
         * By default, a facebook app provides the following permission by default without requiring
         * the review from facebook, including:
         *
         * 1. email - Provides access to the person's primary email address via the email property on the user object.
         *
         * 2. public_profile -  Provides access to a subset of items that are part of a person's public profile.
         * A person's public profile refers to the following properties on the user object by default:
         * id, name, first_name, last_name, age_range, link, gender, locale, picture, timezone, updated_time, verified
         *
         * 3. user_friends - Provides access the list of friends that also use your app.
         * These friends can be found on the friends edge on the user object.
         *
         * For android app to take use of the oauth access token accessing these information, the android app must pass
         * the login request along with all the permissions that it requires to read or write at runtime, the idea is
         * such that user also have the control to explicitly revoke certain permission they don't want to give away even
         * the proceed the logon with facebook granting an oauth token to the android app
         *
         * Either setting the permission to LoginButton or LoginManager will just work
         */
        Collection<String> permissions = Arrays.asList("public_profile", "user_friends", "email");
        //loginButton = (LoginButton) findViewById(R.id.login_button);
        //loginButton.setReadPermissions((List<String>) permissions);
        LoginManager.getInstance().logInWithReadPermissions(this, permissions);

        fbCallbackManager = CallbackManager.Factory.create();
        LoginManager.getInstance().registerCallback(fbCallbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        // App code
                        Log.d("facebook login", "onSuccess");
                        logonStatus.setText("facebook login success");
                    }

                    @Override
                    public void onCancel() {
                        // App code
                        Log.d("facebook login", "onCancel");
                        logonStatus.setText("facebook login cancelled");
                    }

                    @Override
                    public void onError(FacebookException exception) {
                        // App code
                        Log.d("facebook login", "onError");
                        Log.e("facebook login", exception.getMessage(), exception.fillInStackTrace());
                        logonStatus.setText("facebook login error: " + exception.getMessage());
                    }
                });

        // add tracking to the status of the User Access Tokens
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
                    logonStatus.setText("facebook login success");

                    // access token has been assigned or becomes available
                    tokenValue.setText(currentAccessToken.getToken());
                    Log.d("current token: ", currentAccessToken.getToken());
                    Log.d("user ID: ", currentAccessToken.getUserId());
                    Log.d("token expiry: ", currentAccessToken.getExpires().toString());

                    enablePostLogonUI(true);

                } else {
                    logonStatus.setText("facebook login required");
                    // access token has been destroyed or becomes unavailable
                    tokenValue.setText("token not available");

                    enablePostLogonUI(false);
                }
            }
        };


        submitPathRequestBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                //Log.d("access token: ", AccessToken.getCurrentAccessToken().getToken());
                sendPathRequest(graphApi.getText().toString());
            }
        });

        submitMeRequestBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                //Log.d("access token: ", AccessToken.getCurrentAccessToken().getToken());
                sendMeRequest();
            }
        });
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

    protected void sendMeRequest() {
        GraphRequest request = GraphRequest.newMeRequest(
                AccessToken.getCurrentAccessToken(),
                new GraphRequest.GraphJSONObjectCallback() {
                    @Override
                    public void onCompleted(
                            JSONObject object,
                            GraphResponse response)
                    {
                         /* application code handle the result */
                        if (response == null) {
                            Log.w("Graph API", "request failed");
                            responseText.setText("request failure");
                        } else {
                            FacebookRequestError error = response.getError();
                            if (error != null) {
                                Log.w("Graph API error", error.getErrorMessage());
                                responseText.setText(error.getErrorMessage());
                            } else {
                                String raw = response.getRawResponse();
                                Log.d("Graph API response: ", raw);
                                responseText.setText(raw);
                            }
                        }
                    }
                });
        Bundle parameters = new Bundle();
        parameters.putString("fields", "id, name, email, gender, age_range, timezone, picture, friends");
        request.setParameters(parameters);
        request.executeAsync();
    }

    protected void sendPathRequest(String API) {
        Log.d("API: ", API);
        /**
         * facebook graph API v2.7
         * /me                                  - get personal name and facebook ID
         * /me?fields=id,name,email             - get personal facebook ID, name, email
         * /me/friends                          - get friends
         */

        /* make the API call */
//        new GraphRequest(
//                AccessToken.getCurrentAccessToken(),
//                API,
//                null,
//                HttpMethod.GET,
//                new GraphRequest.Callback() {
//                    public void onCompleted(GraphResponse response) {
//                                /* handle the result */
//                        if (response == null) {
//                            Log.w("Graph API", "request failed");
//                        } else {
//                            FacebookRequestError error = response.getError();
//                            if (error != null) {
//                                Log.w("Graph API request", error.getErrorMessage());
//                            } else {
//                                String raw = response.getRawResponse();
//                                Log.d("Graph API response: ", raw);
//                            }
//                        }
//                    }
//                }
//        ).executeAsync();

        GraphRequest request = GraphRequest.newGraphPathRequest(
                AccessToken.getCurrentAccessToken(),
                API,
                new GraphRequest.Callback() {
                    @Override
                    public void onCompleted(GraphResponse response)
                    {
                         /* application code handle the result */
                        if (response == null) {
                            Log.w("Graph API", "request failed");
                            responseText.setText("request failure");
                        } else {
                            FacebookRequestError error = response.getError();
                            if (error != null) {
                                Log.w("Graph API error", error.getErrorMessage());
                                responseText.setText(error.getErrorMessage());
                            } else {
                                String raw = response.getRawResponse();
                                Log.d("Graph API response: ", raw);
                                responseText.setText(raw);
                            }
                        }
                    }
                });
        request.executeAsync();
    }

    protected void enablePostLogonUI(boolean visible) {
        if (visible) {
            graphApi.setVisibility(View.VISIBLE);
            submitMeRequestBtn.setVisibility(View.VISIBLE);
            submitPathRequestBtn.setVisibility(View.VISIBLE);
            responseText.setVisibility(View.VISIBLE);
        } else {
            graphApi.setVisibility(View.INVISIBLE);
            submitMeRequestBtn.setVisibility(View.INVISIBLE);
            submitPathRequestBtn.setVisibility(View.INVISIBLE);
            responseText.setVisibility(View.INVISIBLE);
        }
    }
}
