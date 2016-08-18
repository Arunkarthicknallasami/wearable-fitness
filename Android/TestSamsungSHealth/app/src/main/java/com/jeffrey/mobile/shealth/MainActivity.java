package com.jeffrey.mobile.shealth;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Looper;
import android.provider.Settings;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.samsung.android.sdk.healthdata.HealthConnectionErrorResult;
import com.samsung.android.sdk.healthdata.HealthConstants;
import com.samsung.android.sdk.healthdata.HealthDataResolver;
import com.samsung.android.sdk.healthdata.HealthDataService;
import com.samsung.android.sdk.healthdata.HealthDataStore;
import com.samsung.android.sdk.healthdata.HealthPermissionManager;
import com.samsung.android.sdk.healthdata.HealthResultHolder;

import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static java.text.DateFormat.getDateInstance;

public class MainActivity extends AppCompatActivity {
    protected final String TAG = MainActivity.this.getClass().getName();

    /**
     * Samsung Digital Health SDK is composed of 2 packages:
     * - Health Data Package
     * - S Health Service Package
     */
    protected HealthDataService mSHealthDataService;
    protected HealthDataStore mSHealthDataStore;

    protected TextView content_text;

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
                if (mSHealthDataService == null && mSHealthDataStore == null) {
                    if (!checkNetworkStatus()) {
                        /**
                         * Flow to network settings and abort the initialization of S Health if no
                         * network as S Health will fail to validate the APK anyway
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
                    initializeSHealth();

                } else {
                    getStepCount();
                }
            }
        });
    }

    @Override
    protected void onDestroy() {
        mSHealthDataStore.disconnectService();
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

    public void initializeSHealth() {
        Log.d(TAG, "Initialize Health Data Service ...");
        mSHealthDataService = new HealthDataService();
        try {
            mSHealthDataService.initialize(this);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }

        Log.d(TAG, "Create a HealthDataStore instance and set its listener ...");
        mSHealthDataStore = new HealthDataStore(MainActivity.this, new HealthDataStore.ConnectionListener() {
            @Override
            public void onConnected() {
                Log.d(TAG, "Health data service is connected.");
                HealthPermissionManager pmsManager = new HealthPermissionManager(mSHealthDataStore);

                try {
                    Set<HealthPermissionManager.PermissionKey> mKeySet;
                    mKeySet = new HashSet<HealthPermissionManager.PermissionKey>();
                    mKeySet.add(new HealthPermissionManager.PermissionKey(HealthConstants.StepCount.HEALTH_DATA_TYPE, HealthPermissionManager.PermissionType.READ));

                    // Check whether the permissions that this application needs are acquired
                    Map<HealthPermissionManager.PermissionKey, Boolean> resultMap = pmsManager.isPermissionAcquired(mKeySet);

                    if (resultMap.containsValue(Boolean.FALSE)) {
                        // Request the permission for reading step counts if it is not acquired
                        pmsManager.requestPermissions(mKeySet, MainActivity.this).setResultListener(new HealthResultHolder.ResultListener<HealthPermissionManager.PermissionResult>() {
                            @Override
                            public void onResult(HealthPermissionManager.PermissionResult permissionResult) {
                                Map<HealthPermissionManager.PermissionKey, Boolean> resultMap = permissionResult.getResultMap();
                                Log.d(TAG, "Permission callback is received. Permission granted? " + !resultMap.containsValue(Boolean.FALSE));

                                if (resultMap.containsValue(Boolean.FALSE)) {
                                    Log.i(TAG, "S Health connection failed. Permission not granted");

                                    // clear all previous contents
                                    content_text.setText("S Health connection failed. Permission not granted");

                                    Snackbar.make(
                                            MainActivity.this.findViewById(android.R.id.content),
                                            "S Health connection failed. Permission not granted",
                                            Snackbar.LENGTH_SHORT).show();

                                } else {
                                    Log.d(TAG, "Permission is already granted.");
                                    // Get the current step count and display it
                                    getStepCount();
                                }
                            }
                        });

                    } else {
                        Log.d(TAG, "Permission is already granted.");
                        // Get the current step count and display it
                        getStepCount();
                    }

                } catch (Exception e) {
                    Log.e(TAG, e.getMessage(), e);

                    // clear all previous contents
                    content_text.setText("S Health connection error: " + e.getMessage());

                    Snackbar.make(
                            MainActivity.this.findViewById(android.R.id.content),
                            "S Health connection error: " + e.getMessage(),
                            Snackbar.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onConnectionFailed(HealthConnectionErrorResult healthConnectionErrorResult) {
                Log.d(TAG, "S Health connection fail.");
                showConnectionFailureDialog(healthConnectionErrorResult);
            }

            @Override
            public void onDisconnected() {
                Log.d(TAG, "S Health is disconnected.");
            }
        });

        // Request the connection to the health data store
        mSHealthDataStore.connectService();
    }

    protected void showConnectionFailureDialog(final HealthConnectionErrorResult error) {
        AlertDialog.Builder alert = new AlertDialog.Builder(this);

        String message = "Connection with S Health is not available. ";

        // clear all previous contents
        content_text.setText(message);

        if (error.hasResolution()) {
            switch(error.getErrorCode()) {
                case HealthConnectionErrorResult.PLATFORM_NOT_INSTALLED:
                    message += "Please install S Health";
                    break;
                case HealthConnectionErrorResult.OLD_VERSION_PLATFORM:
                    message += "Please upgrade S Health";
                    break;
                case HealthConnectionErrorResult.PLATFORM_DISABLED:
                    message += "Please enable S Health";
                    break;
                case HealthConnectionErrorResult.USER_AGREEMENT_NEEDED:
                    message += "Please agree with S Health policy";
                    break;
                default:
                    message += "Please make S Health available";
                    break;
            }
        }

        alert.setMessage(message);

        alert.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int id) {
                if (error.hasResolution()) {
                    error.resolve(MainActivity.this);
                }
            }
        });

        if (error.hasResolution()) {
            alert.setNegativeButton("Cancel", null);
        }

        alert.show();
    }

    protected void getStepCount() {
        /**
         * Either wait the result synchronously or provide a callback method to process the data
         */
        if (Looper.myLooper() == null) {
            throw new IllegalThreadStateException("No looper for this thread");

        } else if (Looper.myLooper() == Looper.getMainLooper()) {
            Log.d(TAG, "In the Main (UI) Thread");
            getStepCount_Async();

        } else {
            Log.d(TAG, "In the Looper Thread");
            getStepCount_Sync();
        }
    }

    protected void getStepCount_Async() {
        final HealthDataResolver.ReadRequest readRequest = createReadRequest();

        HealthDataResolver resolver = new HealthDataResolver(mSHealthDataStore, null);

        // Sets the callback to get the result asynchronously.
        resolver.read(readRequest).setResultListener(new HealthResultHolder.ResultListener<HealthDataResolver.ReadResult>() {
            @Override
            public void onResult(HealthDataResolver.ReadResult readResult) {
                printData(readResult);
            }
        });
    }

    protected void getStepCount_Sync() {
        final HealthDataResolver.ReadRequest readRequest = createReadRequest();

        HealthDataResolver resolver = new HealthDataResolver(mSHealthDataStore, null);

        // Blocks the thread until the task is completed.
        HealthDataResolver.ReadResult readResult = resolver.read(readRequest).await();

        printData(readResult);
    }

    protected HealthDataResolver.ReadRequest createReadRequest() {
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

        HealthDataResolver.Filter filter = HealthDataResolver.Filter.and(HealthDataResolver.Filter.greaterThanEquals(HealthConstants.StepCount.START_TIME, startTime),
                HealthDataResolver.Filter.lessThanEquals(HealthConstants.StepCount.START_TIME, endTime));

        HealthDataResolver.ReadRequest request = new HealthDataResolver.ReadRequest.Builder()
                .setDataType(HealthConstants.StepCount.HEALTH_DATA_TYPE)
                .setProperties(new String[] {HealthConstants.StepCount.COUNT})
                .setFilter(filter)
                .build();

        return request;
    }

    protected void printData(final HealthDataResolver.ReadResult readResult) {
        runOnUiThread (new Thread(new Runnable() {
            @Override
            public void run() {
                Log.d(TAG, "read result status: " + readResult.getStatus());
                Log.d(TAG, "read result data type: " + readResult.getDataType());
                Log.d(TAG, "read result record count: " + readResult.getCount());

                int count = 0;
                Cursor c = null;

                try {
                    c = readResult.getResultCursor();
                    if (c != null) {
                        while (c.moveToNext()) {
                            //Log.d(TAG, "temp step count: " + c.getInt(c.getColumnIndex(HealthConstants.StepCount.COUNT)));
                            count += c.getInt(c.getColumnIndex(HealthConstants.StepCount.COUNT));
                        }

                    } else {
                        Log.d(TAG, "read result return null");
                    }
                } catch (Throwable t) {
                    Log.e(TAG, t.getMessage(), t);

                } finally {
                    if (c != null) {
                        c.close();
                    }
                }

                // clear all previous contents
                content_text.setText("");

                String lineBreak = System.getProperty("line.separator");
                content_text.setText("Read result status: " + readResult.getStatus());
                content_text.setText(content_text.getText() + lineBreak + "No. of record found: " + readResult.getCount());
                content_text.setText(content_text.getText() + lineBreak + "Record Type: " + readResult.getDataType());
                content_text.setText(content_text.getText() + lineBreak + "Total:" + count);
            }
        }));
    }

    protected boolean checkNetworkStatus() {
        ConnectivityManager cm = (ConnectivityManager) getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

        if (activeNetwork != null) {
            Log.d(TAG, "Active network type: " + activeNetwork.getTypeName());
        } else {
            Log.d(TAG, "No active network!");
        }

        boolean isConnected = activeNetwork != null && activeNetwork.isConnectedOrConnecting();
        return isConnected;
    }
}
