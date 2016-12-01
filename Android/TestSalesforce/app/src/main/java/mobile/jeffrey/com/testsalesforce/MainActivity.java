package mobile.jeffrey.com.testsalesforce;

import android.accounts.Account;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.salesforce.androidsdk.app.SalesforceSDKManager;
import com.salesforce.androidsdk.config.BootConfig;
import com.salesforce.androidsdk.push.PushMessaging;
import com.salesforce.androidsdk.rest.ClientManager;
import com.salesforce.androidsdk.rest.RestClient;
import com.salesforce.androidsdk.security.Encryptor;
import com.salesforce.androidsdk.security.PasscodeManager;
import com.salesforce.androidsdk.util.EventsObservable;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public class MainActivity extends Activity {

    private PasscodeManager passcodeManager;
    private RestClient restClient;
    private boolean isLogon;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initializeSalesforce();

        initUI();
    }

    protected void initializeSalesforce() {
        SalesforceSDKManager.initNative(getApplicationContext(), new SalesforceSDKManager.KeyInterface() {
            @Override
            public String getKey(String name) {
                return Encryptor.hash(name + "12s9adpahk;n12-97sdainkasd=012", name + "12kl0dsakj4-cxh1qewkjasdol8");
            }
        }, this.getClass());

        SalesforceSDKManager.getInstance().setPushNotificationReceiver(new SFPushReceiver());

        BootConfig config = BootConfig.getBootConfig(getApplicationContext());
        Log.d("@@ consumer key: ", config.getRemoteAccessConsumerKey());
        Log.d("@@ redirect URI: ", config.getOauthRedirectURI());
        Log.d("@@ selected server: ", SalesforceSDKManager.getInstance().getLoginServerManager().getSelectedLoginServer().toString());
//        Log.d("@@ oauth scopes: ", String.valueOf(SalesforceSDKManager.getInstance().getLoginOptions().oauthScopes.toString()));
//        Log.d("@@ client ID: ", SalesforceSDKManager.getInstance().getLoginOptions().oauthClientId);
//        Log.d("@@ callback URL: ", SalesforceSDKManager.getInstance().getLoginOptions().oauthCallbackUrl);

        // Gets an instance of the passcode manager.
        passcodeManager = SalesforceSDKManager.getInstance().getPasscodeManager();

        // Lets observers know that activity creation is complete.
        EventsObservable.get().notifyEvent(EventsObservable.EventType.MainActivityCreateComplete, this);

        Account account  = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentAccount();
        if (account == null) {
            isLogon = false;
            Log.d("init SF", "no account found, should trigger login flow");
        } else {
            isLogon = true;
            createRestClient();
        }
    }

    public void onResume() {
        super.onResume();
        Log.d("login state: ", String.valueOf(isLogon));
    }

    public void onResume(RestClient client) {
        // Keeping reference to rest client
        restClient = client;

        Account account  = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentAccount();
        if (account == null) {
            isLogon = false;

        } else {
            isLogon = true;

            String accountName = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser().getAccountName();
            Log.d("account name: ", accountName);
            String username = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser().getUsername();
            Log.d("user name: ", username);
            String oauthToken = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser().getAuthToken();
            Log.d("oauth token: ", oauthToken);
            String refreshToken = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser().getRefreshToken();
            Log.d("refresh token: ", refreshToken);

            // This part is asynchronous, may only return true upon next app launch or login
            boolean isRegisteredPush = PushMessaging.isRegistered(getApplicationContext(), SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser());
            Log.d("register push: ", String.valueOf(isRegisteredPush));
            if (isRegisteredPush) {
                String deviceID = PushMessaging.getDeviceId(getApplicationContext(), SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser());
                Log.d("device ID: ", String.valueOf(deviceID));
            }

        }
        Log.d("login state: ", String.valueOf(isLogon));

        Button button1 = (Button) findViewById(R.id.button1);
        if (isLogon) {
            button1.setText("Logout");
        } else {
            button1.setText("Login");
        }
    }

    protected void createRestClient() {
        // Brings up the passcode screen if needed.
        if (passcodeManager.onResume(this)) {
            // Gets login options.
            final String accountType = SalesforceSDKManager.getInstance().getAccountType();
            final ClientManager.LoginOptions loginOptions = SalesforceSDKManager.getInstance().getLoginOptions();

//			// Gets a rest client.
            new ClientManager(this, accountType, loginOptions,
                    SalesforceSDKManager.getInstance().shouldLogoutWhenTokenRevoked()).getRestClient(this, new ClientManager.RestClientCallback() {

                @Override
                public void authenticatedRestClient(RestClient client) {
                    if (client == null) {
                        SalesforceSDKManager.getInstance().logout(MainActivity.this);
                        return;
                    }
                    onResume(client);

                    // Lets observers know that rendition is complete.
                    EventsObservable.get().notifyEvent(EventsObservable.EventType.RenditionComplete);
                }
            });
        }
    }

    protected void initUI() {
        Button button1 = (Button) findViewById(R.id.button1);
        if (isLogon) {
            button1.setText("Logout");
        } else {
            button1.setText("Login");
        }

        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!isLogon) {
                    createRestClient();
                } else {
                    SalesforceSDKManager.getInstance().logout(MainActivity.this);
                }
            }
        });

        Button button2 = (Button) findViewById(R.id.button2);
        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new Thread() {
                    public void run() {
                        try {
                            URL mUrl = new URL("https", "hkmvdevd3-manulife-hongkong-community.cs31.force.com", 443, "/move3/services/apexrest/user/info");
                            HttpsURLConnection conn = (HttpsURLConnection) mUrl.openConnection();
                            conn.setReadTimeout(10000 /* milliseconds */);
                            conn.setConnectTimeout(10000 /* milliseconds */);
                            conn.setUseCaches(false);

                            // add the token to the header before sending the request
                            String oauthToken = SalesforceSDKManager.getInstance().getUserAccountManager().getCurrentUser().getAuthToken();
                            conn.addRequestProperty("Authorization", "Bearer " + oauthToken);

                            // simply request from server
                            conn.setRequestMethod("GET");
                            conn.setDoInput(true);
                            conn.connect();

                            int responseCode = conn.getResponseCode();
                            Log.d("The response code is: ", String.valueOf(responseCode));

                            if (responseCode == HttpsURLConnection.HTTP_OK) {
                                StringBuilder sb = new StringBuilder();
                                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                                String line = null;
                                while ((line = br.readLine()) != null) {
                                    sb.append(line + "\n");
                                }
                                br.close();
                                Log.d("server response: ", sb.toString());
                            } else {
                                Log.d("error response: ", conn.getResponseMessage());
                            }

                        } catch (Exception exc) {
                            Log.e("Exception", exc.getMessage(), exc);
                        }
                    }
                }.start();
            }
        });
    }


}
