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
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

public class MainActivity extends AppCompatActivity {

    private WebView webview;
    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        webview = (WebView) findViewById(R.id.webView);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);

        getWebviewVersionInfo();
        enabledRemoteDebugging();
        configureWebview();

        final String url = "http://www.hkonlinemall.com/hkonlinemall-web/manulife/index.jsp?devicetype=android&language=en&rewardid=MOVE0001&promoclass=3&macauind=&ownername=JUN%20JUNJUN&deliverymethod=C&promocode=MYTWKQT2T7&dob=0603&skey=f0ea2a86-9735-4a4a-963f-b001dbcac3dadserwjr";
        //final String url = "http://www.hkonlinemall.com/hkonlinemall-web/manulife/index.jsp?devicetype=android&language=en&rewardid=3&promoclass=4&ownername=MOVE%20103&deliverymethod=S&macauind=0&promocode=QH2QT72DXF&dob=0101&skey=f0ea2a86-9735-4a4a-963f-b001dbcac3dadserwjr";
        //final String url = "http://www.hkonlinemall.com/";
        webview.loadUrl(url);
    }

    protected void configureWebview() {
        webview.getSettings().setJavaScriptEnabled(true);
        webview.getSettings().setDomStorageEnabled(true);
        webview.getSettings().setAllowContentAccess(true);
        webview.getSettings().setAllowFileAccess(true);
        webview.getSettings().setSaveFormData(false);
        webview.getSettings().setAppCacheEnabled(true);
        webview.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
        webview.setVerticalScrollBarEnabled(true);

        webview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(final WebView webview, final String url) {
                Log.d("load url: ", url);

                if (url.indexOf("manulifemove://") >= 0) {
                    webview.loadUrl("javascript:moveCallback()");
                    return true;
                }

                return super.shouldOverrideUrlLoading(webview, url);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                super.onReceivedError(view, errorCode, description, failingUrl);
            }

            @Override
            public void onPageStarted(final WebView view, final String url, final Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                progressBar.setVisibility(View.VISIBLE);
            }

            @Override
            public void onPageFinished(final WebView view, final String url) {
                super.onPageFinished(view, url);
                progressBar.setVisibility(View.INVISIBLE);
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
