package testwebview.jeffrey.com.testwebview;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import static testwebview.jeffrey.com.testwebview.R.id.webView;

public class MainActivity extends AppCompatActivity {

    private CustomWebView webview;
    private ProgressBar progressBar;

    private CustomJsBridge jsBridge;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        webview = (CustomWebView) findViewById(webView);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);
        progressBar.setVisibility(View.INVISIBLE);

        getWebviewVersionInfo();
        enabledRemoteDebugging();
        configureWebview();

        //final String url = "http://www.hkonlinemall.com/hkonlinemall-web/manulife/index.jsp?devicetype=android&language=en&rewardid=MOVE0001&promoclass=3&macauind=&ownername=JUN%20JUNJUN&deliverymethod=C&promocode=MYTWKQT2T7&dob=0603&skey=f0ea2a86-9735-4a4a-963f-b001dbcac3dadserwjr";
        //final String url = "http://www.hkonlinemall.com/hkonlinemall-web/manulife/index.jsp?devicetype=android&language=en&rewardid=3&promoclass=4&ownername=MOVE%20103&deliverymethod=S&macauind=0&promocode=QH2QT72DXF&dob=0101&skey=f0ea2a86-9735-4a4a-963f-b001dbcac3dadserwjr";
        //final String url = "http://www.hkonlinemall.com/";

        //Original Azure
        //final String url = "https://login.microsoftonline.com/AZAPMOVB2CTNT01.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_signin&client_id=7d98d073-8fa8-487d-bb9b-303b33be6f6d&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fmove-msal-service.apps.ext.eas.pcf.manulife.com%2Fauth%2Fmsal&scope=openid&response_type=id_token&prompt=login";

        //Move Customized
        //final String url = "https://login.microsoftonline.com/AZAPMOVB2CTNT01.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_move&client_id=7d98d073-8fa8-487d-bb9b-303b33be6f6d&nonce=defaultNonce&redirect_uri=https%3A%2F%2Fmove-msal-service.apps.ext.eas.pcf.manulife.com%2Fauth%2Fmsal&scope=openid&response_type=id_token&prompt=login";

        //final String url = "https://mymove.manulifemove.hk/move3/move_page#/move_login";

        //final String url = "https://login.salesforce.com";

        //final String url = "https://login.microsoft.com";

        final String url = "file:///android_asset/test.html";

        webview.loadUrl(url);
    }

    protected void configureWebview() {
        webview.setInitialScale(470); // enforce mobile site if website does not set viewport
        //webview.setVerticalScrollBarEnabled(true);

        webview.getSettings().setJavaScriptEnabled(true);
        webview.getSettings().setDomStorageEnabled(true);
        webview.getSettings().setAllowContentAccess(true);
        webview.getSettings().setAllowFileAccess(true);
        webview.getSettings().setSaveFormData(false);
        webview.getSettings().setAppCacheEnabled(true);
        webview.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);

        // configure JS interface
        jsBridge = CustomJsBridge.Builder.build(webview);
        webview.addJavascriptInterface(jsBridge, jsBridge.getName());

        webview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(final WebView webview, final String url) {
                Log.d("load url: ", url);

//                if (url.indexOf("manulifemove://") >= 0) {
//                    webview.loadUrl("javascript:moveCallback()");
//                    return true;
//                }

                return super.shouldOverrideUrlLoading(webview, url);
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(final WebView webView, WebResourceRequest request) {
                // disable CORS for Android Webview by intercepting the preflight request
                if (request.getMethod().equalsIgnoreCase("OPTIONS")) {
                    Date date = new Date();
                    final String dateString = new SimpleDateFormat("dd-MMM-yyyy kk:mm:ss").format(date);
                    Map<String, String> headers = new HashMap<String, String>() {{
                        put("Connection", "close");
                        put("Content-Type", "text/plain");
                        put("Date", dateString + TimeZone.getDefault().getDisplayName());
                        put("Access-Control-Allow-Origin", "*"); // allow any domain
                        put("Access-Control-Allow-Methods", "GET, POST, DELETE, PUT, PATCH, OPTIONS"); // allow any method
                        put("Access-Control-Max-Age", "600");
                        put("Access-Control-Allow-Credentials", "true");
                        put("Access-Control-Allow-Headers", "accept, authorization, Content-Type, method"); // allow a list of pre-define custom headers
                    }};
                    return new WebResourceResponse("text/plain", "UTF-8", 200, "OK", headers, null);
                }

                String postData = null;
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    postData = jsBridge.getDataFromJs("getData");
                }
                return super.shouldInterceptRequest(webView, request);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                super.onReceivedError(view, errorCode, description, failingUrl);
            }

            @Override
            public void onPageStarted(final WebView view, final String url, final Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
//                progressBar.setVisibility(View.VISIBLE);
            }

            @Override
            public void onPageFinished(final WebView view, final String url) {
                super.onPageFinished(view, url);
//                progressBar.setVisibility(View.INVISIBLE);
            }
        });
    }

    protected void getWebviewVersionInfo() {
        Log.d("webview user agent: ", webview.getSettings().getUserAgentString());

        PackageManager pm = getPackageManager();
        String result = "";
        try {
            PackageInfo pi = pm.getPackageInfo("com.google.android.webview", 0);
            Log.d("version name: ", pi.versionName);
            Log.d("version code: ", String.valueOf(pi.versionCode));
        } catch (PackageManager.NameNotFoundException e) {
            Log.e("Error: ", "Android System WebView is not found");
        }
    }

    protected void enabledRemoteDebugging() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE))
            { WebView.setWebContentsDebuggingEnabled(true); }
        }
    }
}
