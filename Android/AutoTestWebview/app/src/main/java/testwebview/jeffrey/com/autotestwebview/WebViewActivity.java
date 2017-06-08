package testwebview.jeffrey.com.autotestwebview;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.WindowManager;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by jeffrey on 6/8/17.
 */

public class WebViewActivity extends AppCompatActivity {
    private static final String TAG = WebViewActivity.class.getName();
    private WebView webView;

    private final String url = "https://hkmvdevd3-manulife-hongkong-community.cs31.force.com/move3";

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);

        setContentView(R.layout.webview_activity);
        webView = (WebView) findViewById(R.id.webView);

        getWebViewVersionInfo();
        enabledRemoteDebugging();
        configureWebview();

        loadUrl();
    }

    protected void loadUrl() {
        webView.loadUrl(url);
    }

    protected void configureWebview() {
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setDomStorageEnabled(true);
        webView.getSettings().setSaveFormData(false);
        webView.getSettings().setAppCacheEnabled(false);
        webView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
        webView.setVerticalScrollBarEnabled(true);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(final WebView webView, final WebResourceRequest request) {
                return super.shouldInterceptRequest(webView, request);
            }

            @Override
            public void onPageStarted(final WebView webView, final String url, final Bitmap favicon) {
                super.onPageStarted(webView, url, favicon);
            }

            @Override
            public void onPageFinished(final WebView webView, final String url) {
                super.onPageFinished(webView, url);
            }

            @Override
            public void onReceivedError(final WebView webView, final WebResourceRequest request, final WebResourceError error) {
                super.onReceivedError(webView, request, error);
            }
        });
    }

    protected void getWebViewVersionInfo() {
        Log.d(TAG, "webView user agent: " + webView.getSettings().getUserAgentString());
        PackageManager pm = getPackageManager();
        try {
            PackageInfo pi = pm.getPackageInfo("com.google.android.webView", 0);
            Log.d(TAG, "version name: " + pi.versionName);
            Log.d(TAG, "version code: " + pi.versionCode);
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG, "Android System WebView is not found");
        }
    }

    protected void enabledRemoteDebugging() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE)) {
                Log.e(TAG, "Remote webView debugging is now enabled");
                WebView.setWebContentsDebuggingEnabled(true);
            }
        }
    }
}
