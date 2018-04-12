package testwebview.jeffrey.com.testwebview;

import android.util.Log;
import android.webkit.JavascriptInterface;

import java.util.concurrent.CountDownLatch;

public class CustomJsBridge {
    private static final String NAME = "jsBridge";
    private static CustomJsBridge mInstance;

    private CustomWebView webView;
    private Callback callback;

    public static class Builder {
        public static CustomJsBridge build(CustomWebView webView) {
            if (mInstance == null) {
                mInstance = new CustomJsBridge(webView);
            }
            return mInstance;
        }
    }

    private CustomJsBridge(CustomWebView webView) {
        this.webView = webView;
    }

    public String getName() {
        return NAME;
    }

    protected synchronized String getDataFromJs(final String js) {
        final CountDownLatch latch = new CountDownLatch(1);
        final StringBuilder jsData = new StringBuilder();

        callback = new Callback() {
            @Override
            public void onComplete(String value) {
                latch.countDown();
                jsData.append(value);
            }
        };

        webView.post(new Runnable() {
            @Override
            public void run() {
                /**
                 * shouldInterceptRequest() is executed on a background (i.e. non-UI) thread,
                 * while WebView related methods are required to run on UI thread
                 */
                webView.loadUrl("javascript:" + js + "()");
            }
        });

        try {
            latch.await();
        } catch (InterruptedException e) {
            Log.e("error! ", e.getMessage(), e);
        }
        return jsData.toString();
    }

    @JavascriptInterface
    public void onData(String value) {
        Log.d("onData: ", value);
        callback.onComplete(value);
    }

    interface Callback {
        void onComplete(String value);
    }
}
