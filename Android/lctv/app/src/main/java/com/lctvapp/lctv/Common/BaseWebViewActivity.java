package com.lctvapp.lctv.Common;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.Toast;

import com.lctvapp.lctv.R;

import java.io.UnsupportedEncodingException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Array;
import java.net.URLEncoder;

/**
 * Created by daehyun on 15. 9. 20..
 */
public class BaseWebViewActivity extends Activity {

    private String TAG = "BaseWebViewActivity";
    private WebView webView;
    private ImageButton btn_back;
    private ImageButton btn_forward;
    private ImageButton btn_refresh;

    private String streamTitle = null;
    private String rtmp = null;
    private String chat = null;

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_base_webview);

        webView = (WebView) findViewById(R.id.webview);
        btn_back = (ImageButton) findViewById(R.id.btn_back);
        btn_forward = (ImageButton) findViewById(R.id.btn_forward);
        btn_refresh = (ImageButton) findViewById(R.id.btn_refresh);

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (webView.canGoBack()) {
                    webView.goBack();
                }
            }
        });

        btn_forward.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (webView.canGoForward()) {
                    webView.goForward();
                }
            }
        });

        btn_refresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                webView.reload();
            }

        });

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
        MyJavaScriptInterface myinterface = new MyJavaScriptInterface(this);
        webView.addJavascriptInterface(myinterface, "HtmlViewer");

        webView.setWebViewClient(new CustomWebViewClient());
        String url = getResources().getString(R.string.host_url_string);
        Log.d(TAG, url);
        webView.loadUrl(url);

    }

    private void playStreaming(String title, String chat, String rtmp) {
        Toast.makeText(this, "title : " + title + "chat : " + chat + " rtmp " + rtmp, Toast.LENGTH_LONG).show();
    }

    private void setReplaceImageSrc () {
        if (streamTitle != null && chat != null && rtmp != null) {
            replaceImageSrc("video-home--image js-noflash", streamTitle, chat, rtmp);
            replaceImageSrc("noflash-img showIt", streamTitle, chat, rtmp);
        }
    }
    private void replaceImageSrc(final String element, final String title, final String chat, final String rtmpUrl) {
        webView.post(new Runnable() {
            @Override
            public void run() {
                try {
                    String js = "javascript:(function () { document.getElementsByClassName('" + element + "')[0].onclick = function() {document.location='lctvapp://openplayer?title=" +
                            URLEncoder.encode(title, "ISO-8859-1") + "&chat=" +
                            URLEncoder.encode(chat, "ISO-8859-1") + "&rtmp=" +
                            URLEncoder.encode(rtmpUrl, "ISO-8859-1") + "';}}) ();";
                    webView.loadUrl(js);

                    js = "javascript:(function () { document.getElementsByClassName('" + element + "')[0].src = 'https://github.com/jabiers/lctvapp/blob/master/noflash.jpg?raw=true'}) ();";
                    webView.loadUrl(js);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private class CustomWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {

            Log.d(TAG, "Should");
            if (url.startsWith("lctvapp://openplayer?")) {
                String allParams = url.split("\\?")[1];
                String[] params = allParams.split("&");

                String title = null;
                String chat = null;
                String rtmp = null;

                for (String param : params) {
                    String[] keyValue = param.split("=");
                    String key = keyValue[0];
                    String value = "";
                    if (keyValue.length > 1) {
                        value = keyValue[1];
                    }

                    try {
                        if (key.equals("title")) {
                            title = value;
                        } else if (key.equals("chat")) {
                            chat = value;
                        } else if (key.equals("rtmp")) {
                            rtmp = value;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
                playStreaming(title, chat, rtmp);

                return true;
            } else {
                return super.shouldOverrideUrlLoading(view, url);
            }

//            [[APP_DELEGATE rootViewController] headerHidden:[Configs checkIfNeedRemoveHeader:request]];


        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            streamTitle = null;
            chat = null;
            rtmp = null;

            removeHeaderElement(view);
            updateButtonStatus();
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            view.loadUrl("javascript:HtmlViewer.showHTML" +
                    "('<html>'+document.getElementsByTagName('html')[0].innerHTML+'</html>');");

            view.loadUrl("javascript:HtmlViewer.getTitle" +
                    "(document.getElementsByTagName('title')[0].text);");

            view.loadUrl("javascript:HtmlViewer.getChatUrl" +
                    "(function () {var metas = document.getElementsByTagName('meta');" +
                    "for (i=0; i<metas.length; i++) {" +
                    "if (metas[i].getAttribute('property') == 'og:url') {" +
                    "return metas[i].getAttribute('content');" +
                    "}" +
                    "}" +
                    "return \"\";} ());");
//            HtmlViewer.getChatUrl(function() {var metas = document.getElementsByTagName('meta');
//                for (i=0; i<metas.length; i++) {
//                    if (metas[i].getAttribute('property') == 'og:url') {
//                        return metas[i].getAttribute('content');
//                    }
//                }
//                return "";} ());
//

//
//                return [NSString stringWithFormat:@"%@/chat%@",HOST_URL_STRING, url];
//            }

            updateButtonStatus();
            removeHeaderElement(view);

            super.onPageFinished(view, url);
        }


        private void updateButtonStatus() {
            btn_back.setEnabled(webView.canGoBack());
            btn_forward.setEnabled(webView.canGoForward());
        }

        private void removeHeaderElement(WebView view) {
            if (view != null) {

                view.loadUrl("javascript:(function () { var element = document.getElementById('topSidebar'); element.parentNode.removeChild(element); }) ()");
                view.loadUrl("javascript:(function () { var element = document.getElementById('mobSidebar'); element.parentNode.removeChild(element); }) ()");
            }
        }
    }



    class MyJavaScriptInterface {

        private Context ctx;

        MyJavaScriptInterface(Context ctx) {
            this.ctx = ctx;
        }

        @JavascriptInterface
        public void showHTML(String html) {

            try {
                int start = html.indexOf("rtmp");
                String startString = html.substring(start);

                int end =  startString.indexOf("\",");
                rtmp = startString.substring(0, end);
            } catch(Exception e) {
                Toast.makeText(getApplicationContext(), e.toString(), Toast.LENGTH_SHORT).show();
            }
            setReplaceImageSrc();


        }

        @JavascriptInterface
        public void getTitle (String title) {
            streamTitle = title;
            setReplaceImageSrc();

        }

        @JavascriptInterface
        public void getChatUrl (String chatUrl) {
            chat = chatUrl;
            setReplaceImageSrc();

        }
    }
}
