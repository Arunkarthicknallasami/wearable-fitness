package testwebview.jeffrey.com.testwebview;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebView;

public class CustomWebView extends WebView {
    public CustomWebView(Context context) {
        super(context);
    }

    public CustomWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public void postUrl(String url, byte[] postData) {
        String string = new String(postData);
        Log.d("post data", string);
        super.postUrl(url, postData);
    }
}
