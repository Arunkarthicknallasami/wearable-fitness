package com.jeffrey.mobile.fit;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Looper;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.result.DataReadResult;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import static java.text.DateFormat.getDateInstance;
import static java.text.DateFormat.getTimeInstance;

public class MainActivity extends AppCompatActivity {
    protected final String TAG = MainActivity.this.getClass().getName();

    // Google API Client instance
    protected GoogleApiClient mGoogleApiClient = null;

    protected TextView content_text;

    // For manual connection management and error resolving
    protected static final int REQUEST_RESOLVE_ERROR = 1001;

    // Unique tag for the error dialog fragment
    private static final String REQUEST_RESOLVE_ERROR_DIALOG = "dialog_error";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        content_text = (TextView) findViewById(R.id.content_text);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mGoogleApiClient == null) {
                    if (!checkNetworkStatus()) {
                        /**
                         * Flow to network settings and abort the building of Google Fit if no
                         * network as the Google Play Services will fail to validate the APK anyway
                         */
                        content_text.setText("No network");
                        Snackbar.make(view, "Network connection is not available", Snackbar.LENGTH_SHORT)
                                .setAction("Settings", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        // launch to wifi settings page
                                        startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
                                    }
                                }).show();
                        return;
                    }
                    buildFitnessClient();

                } else if (mGoogleApiClient.isConnected()){
                    // Get the current step count and display it
                    getStepCount();

                } else {
                    // Make sure the app is not already connected or attempting to connect
                    if (!mGoogleApiClient.isConnecting() && !mGoogleApiClient.isConnected()) {
                        mGoogleApiClient.connect();
                    }
                }
            }
        });
    }

    @Override
    protected void onDestroy() {
        if (mGoogleApiClient != null && mGoogleApiClient.isConnected()) {
            Log.d(TAG, "Disconnecting Google Fit API client  ...");
            /*
             * Closes the connection to Google Play services.
             * No calls can be made using this client after calling this method.
             * Any method calls that haven't executed yet will be canceled,
             * and their onResult(Result) callbacks won't be called.
             */
            mGoogleApiClient.disconnect();
        }
        super.onDestroy();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    /**
     *  Make a connection to one of the Google APIs provided in the Google Play services library
     *  and to create an instance of GoogleApiClient ("Google API Client"). The Google API Client
     *  provides a common entry point to all the Google Play services and manages the network
     *  connection between the user's device and each Google service.
     *
     *  If the Google API you want to use is not included in the Google Play services library,
     *  you can connect using the appropriate REST API, but you must obtain an OAuth 2.0 token.
     *  For more information, read Authorizing with Google for REST APIs
     *
     *  If you are adding the Wearable API together with other APIs to a GoogleApiClient,
     *  you may run into client connection errors on devices that do not have the Android Wear
     *  app installed. To avoid connection errors, call the addApiIfAvailable() method and pass
     *  in the Wearable API to allow your client to gracefully handle the missing API.
     *  For more information, see Access the Wearable API.
     *
     *  This methods is used to check and request permissions, and will authenticate the user
     *  and allow the application to connect to following Google Fit APIs.
     *  - History API
     *  - Sensors API
     *  - Recording API
     *  - Session API
     *  - Bluetooth Low Energy API
     *
     *  The desired OAuth 2.0 scopes (READ/WRITE) should match the scopes your app needs
     *  (see documentation for details).
     *
     *  The access permission of the app to access google fit data is configured in the
     *  device > settings > Google > Google Fit > Connected apps & devices
     *
     *  Authentication will occasionally fail intentionally, and there will be a known
     *  resolution, which the OnConnectionFailedListener() can address.
     *
     *  Examples of this includes:
     *  1. the user never having grant the app to access data on Google Fit before
     *     (regardless whether the user have installed Google Fit app or not, this
     *     has been verified on Nexus devices but not Samsung stock devices)
     *  2. having multiple accounts on the device and needing to specify which account to use, etc.
     *
     *  See:
     *  https://developers.google.com/android/guides/overview
     *  https://developers.google.com/fit/android/?hl=zh-TW
     *  https://developers.google.com/fit/android/get-started?hl=zh-TW#step_5_connect_to_the_fitness_service
     *  https://developers.google.com/fit/android/authorization
     *  https://developers.google.com/android/guides/api-client
     *  https://developers.google.com/fit/android/samples
     *
     *  Others:
     *  https://developers.google.com/android/guides/http-auth
     *  https://developers.google.com/android/guides/api-client#access_the_wearable_api
     *
     */
    protected void buildFitnessClient() {
        Log.d(TAG, "Building Google Fit API client ...");

        // Create the Google API Client
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addApi(Fitness.HISTORY_API)
                .addScope(new Scope(Scopes.FITNESS_ACTIVITY_READ_WRITE))
                .addConnectionCallbacks(
                        new GoogleApiClient.ConnectionCallbacks() {
                            @Override
                            public void onConnected(Bundle bundle) {
                                Log.i(TAG, "Connected!!!");
                                // Get the current step count and display it
                                getStepCount();
                            }

                            @Override
                            public void onConnectionSuspended(int i) {
                                // If your connection to the sensor gets lost at some point,
                                // you'll be able to determine the reason and react to it here.
                                if (i == GoogleApiClient.ConnectionCallbacks.CAUSE_NETWORK_LOST) {
                                    Log.i(TAG, "Connection lost.  Cause: Network Lost.");
                                    content_text.setText("Connection lost.  Cause: Network Lost.");

                                } else if (i == GoogleApiClient.ConnectionCallbacks.CAUSE_SERVICE_DISCONNECTED) {
                                    Log.i(TAG, "Connection lost.  Reason: Service Disconnected");
                                    content_text.setText("Connection lost.  Reason: Service Disconnected");
                                }
                            }
                        }
                )
                .addOnConnectionFailedListener(new GoogleApiClient.OnConnectionFailedListener() {
                    @Override
                    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
                        Log.d(TAG, "Google Fit API client connection failed. Cause: " +  connectionResult.toString());

                        // clear all previous contents
                        content_text.setText("Google Fit API client connection failed. Cause: " +  connectionResult.toString());

                        if (connectionResult.hasResolution()) {
                            try {
                                // there is a resolution to the error, request that the user take immediate action to resolve
                                connectionResult.startResolutionForResult(MainActivity.this, REQUEST_RESOLVE_ERROR);
                            } catch (IntentSender.SendIntentException e) {
                                Log.e(TAG, e.getMessage(), e);
                                // There was an error with the resolution intent, simply retry connection again
                                mGoogleApiClient.connect();
                            }

                        } else {
                            Bundle bundle = new Bundle();
                            bundle.putInt(REQUEST_RESOLVE_ERROR_DIALOG, connectionResult.getErrorCode());

                            // attempt to show dialog using GoogleApiAvailability.getErrorDialog() ...
                            DialogFragment errorDialog = new DialogFragment() {
                                @Override
                                public Dialog onCreateDialog(Bundle savedInstanceState) {
                                    // Get the error code and retrieve the appropriate dialog
                                    int errorCode = this.getArguments().getInt(REQUEST_RESOLVE_ERROR_DIALOG);
                                    return GoogleApiAvailability.getInstance().getErrorDialog(
                                            this.getActivity(), errorCode, REQUEST_RESOLVE_ERROR);
                                }
                                @Override
                                public void onDismiss(DialogInterface dialog) {
                                    Snackbar.make(
                                            MainActivity.this.findViewById(R.id.main_activity_view),
                                            "Exception while connecting to Google Fit API client ",
                                            Snackbar.LENGTH_SHORT).show();
                                }
                            };
                            errorDialog.setArguments(bundle);
                            errorDialog.show(getSupportFragmentManager(), "error dialog");
                        }
                    }
                }).build();

                mGoogleApiClient.connect();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_RESOLVE_ERROR) {
            Log.d(TAG, "Callback from resolving error...");
            if (resultCode == RESULT_OK) {
                Log.d(TAG, "-> OK");
                // Make sure the app is not already connected or attempting to connect
                if (!mGoogleApiClient.isConnecting() &&
                        !mGoogleApiClient.isConnected()) {
                    mGoogleApiClient.connect();
                }
            } else {
                Log.d(TAG, "-> FAIL");
                Snackbar.make(
                        MainActivity.this.findViewById(R.id.main_activity_view),
                        "Exception while connecting to Google Fit API client ",
                        Snackbar.LENGTH_SHORT).show();
            }
        }
    }

    protected void getStepCount() {
        /**
         * Either wait the result synchronously or provide a callback method to process the data
         */

        // To read data from the fitness history, first create a DataReadRequest instance
        DataReadRequest readRequest = createReadRequest();

        if (Looper.myLooper() == Looper.getMainLooper()) {
            Log.d(TAG, "In the Main (UI) Thread");
            getStepCount_Async(readRequest);
        } else {
            Log.d(TAG, "In the Looper Thread");
            getStepCount_Sync(readRequest);
        }
    }

    protected void getStepCount_Async(DataReadRequest request) {
        // Sets the callback to get the result asynchronously.
        Fitness.HistoryApi.readData(mGoogleApiClient, request).setResultCallback(new ResultCallback<DataReadResult>() {
            @Override
            public void onResult(@NonNull DataReadResult dataReadResult) {
                printData(dataReadResult);
            }
        });
    }

    protected void getStepCount_Sync(DataReadRequest request) {
        // Blocks the thread until the task is completed.
        DataReadResult dataReadResult = Fitness.HistoryApi.readData(mGoogleApiClient, request).await(1, TimeUnit.MINUTES);
        printData(dataReadResult);
    }

    /**
     * Return all step count changes from midnight of current date to current time stamp.
     *
     * See:
     * https://developers.google.com/fit/android/history?hl=zh-TW
     */
    protected DataReadRequest createReadRequest() {
        // [START build_read_data_request]
        // Setting a start and end date using a range from midnight of current date to current time stamp.
        Calendar cal = Calendar.getInstance();
        Date now = new Date();
        cal.setTime(now);
        long endTime = cal.getTimeInMillis();

        // reset hour, minutes, seconds and millis to today midnight 00:00
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        long startTime = cal.getTimeInMillis();

        java.text.DateFormat dateFormat = getDateInstance();
        Log.i(TAG, "Range Start: " + dateFormat.format(startTime));
        Log.i(TAG, "Range End: " + dateFormat.format(endTime));

        DataReadRequest readRequest = new DataReadRequest.Builder()
                // The data request can specify multiple data types to return, effectively
                // combining multiple data queries into one call.
                // In this example, it's very unlikely that the request is for several hundred
                // datapoints each consisting of a few steps and a timestamp.  The more likely
                // scenario is wanting to see how many steps were walked per day, for 7 days.
                .aggregate(DataType.TYPE_STEP_COUNT_DELTA, DataType.AGGREGATE_STEP_COUNT_DELTA)
                // Analogous to a "Group By" in SQL, defines how data should be aggregated.
                // bucketByTime allows for a time span, whereas bucketBySession would allow
                // bucketing by "sessions", which would need to be defined in code.
                .bucketByTime(1, TimeUnit.DAYS)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build();

        return readRequest;
    }


    /**
     * Log a record of the query result. It's possible to get more constrained data sets by
     * specifying a data source or data type, but for demonstrative purposes here's how one would
     * dump all the data. In this sample, logging also prints to the device screen, so we can see
     * what the query returns, but your app should not log fitness information as a privacy
     * consideration. A better option would be to dump the data you receive to a local data
     * directory to avoid exposing it to other applications.
     */
    protected void printData(DataReadResult dataReadResult) {
        // If the DataReadRequest object specified aggregated data, dataReadResult will be returned
        // as buckets containing DataSets, instead of just DataSets.
        if (dataReadResult.getStatus().isSuccess()) {
            if (dataReadResult.getBuckets().size() > 0) {
                Log.i(TAG, "Number of returned buckets of DataSets is: "
                        + dataReadResult.getBuckets().size());
                for (Bucket bucket : dataReadResult.getBuckets()) {
                    List<DataSet> dataSets = bucket.getDataSets();
                    for (DataSet dataSet : dataSets) {
                        dumpDataSet(dataSet);
                    }
                }
            } else if (dataReadResult.getDataSets().size() > 0) {
                Log.i(TAG, "Number of returned DataSets is: "
                        + dataReadResult.getDataSets().size());
                for (DataSet dataSet : dataReadResult.getDataSets()) {
                    dumpDataSet(dataSet);
                }
            }
        } else {
            Log.i(TAG, "Get history failed. Cause: " + dataReadResult.getStatus().toString());

            // clear all previous contents
            content_text.setText("Get history failed. Cause: " +  dataReadResult.getStatus().toString());

            Snackbar.make(
                    MainActivity.this.findViewById(R.id.main_activity_view),
                    "Exception while getting history API: " + dataReadResult.getStatus().getStatusMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }

    protected void dumpDataSet(final DataSet dataSet) {
        runOnUiThread (new Thread(new Runnable() {
            @Override
            public void run() {
                String lineBreak = System.getProperty("line.separator");

                // clear all previous contents
                content_text.setText("");

                Log.i(TAG, "Data returned for Data type: " + dataSet.getDataType().getName());
                content_text.setText("Data returned for Data type: " + dataSet.getDataType().getName());

                DateFormat dateFormat = getTimeInstance();

                for (DataPoint dp : dataSet.getDataPoints()) {
                    Log.i(TAG, "Data point:");
                    content_text.setText(content_text.getText() + lineBreak + "Data point:");

                    Log.i(TAG, "\tType: " + dp.getDataType().getName());
                    content_text.setText(content_text.getText() + lineBreak + "\tType: " + dp.getDataType().getName());

                    Log.i(TAG, "\tStart: " + dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)));
                    content_text.setText(content_text.getText() + lineBreak + "\tStart: " + dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)));

                    Log.i(TAG, "\tEnd: " + dateFormat.format(dp.getEndTime(TimeUnit.MILLISECONDS)));
                    content_text.setText(content_text.getText() + lineBreak + "\tEnd: " + dateFormat.format(dp.getEndTime(TimeUnit.MILLISECONDS)));

                    for(Field field : dp.getDataType().getFields()) {
                        Log.i(TAG, "\tField: " + field.getName() + " Value: " + dp.getValue(field));
                        content_text.setText(content_text.getText() + lineBreak + "\tField: " + field.getName() + " Value: " + dp.getValue(field));
                    }
                }
            }
        }));
    }

    protected boolean checkNetworkStatus() {
        ConnectivityManager cm = (ConnectivityManager) getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

        boolean isConnected = activeNetwork != null && activeNetwork.isConnectedOrConnecting();
        return isConnected;
    }
}