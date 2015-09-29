package com.lctvapp.lctv.Common;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.lctvapp.lctv.Activities.Video.VideoActivity;
import com.lctvapp.lctv.R;

import java.io.UnsupportedEncodingException;
import java.lang.ref.WeakReference;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;


/**
 * Created by daehyun on 15. 9. 20..
 */
public class BaseWebViewActivity extends AppCompatActivity {

    private String TAG = "BaseWebViewActivity";
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ArrayList<String> mLeftMenuList;

    private WebView webView;
    private ImageButton btn_back;
    private ImageButton btn_forward;
    private ImageButton btn_refresh;

    private String streamTitle = null;
    private String rtmp = null;
    private String chat = null;

    public BaseWebViewActivity() {
    }

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

        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);


//        mLeftMenuList = new ArrayList<String>();
//        mDrawerList.setAdapter(new DefaultAdapter(this, mLeftMenuList, R.layout.item_default));

//        ActionBar actionBar = getSupportActionBar();
//        actionBar.setCustomView(R.id.action_bar);


        // Set the drawer toggle as the DrawerListener
//        mDrawerLayout.setDrawerListener(mDrawerToggle);


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
        webView.setWebChromeClient(new CustomWebChromeViewClient());
        String url = getResources().getString(R.string.host_url_string);
        Log.d(TAG, url);
        webView.loadUrl(url);

    }

    private void playStreaming(String title, String chat, String rtmp) {
        VideoActivity.intentTo(this, rtmp, title);

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
                            URLEncoder.encode(title, "UTF-8") + "&chat=" +
                            URLEncoder.encode(chat, "UTF-8") + "&rtmp=" +
                            URLEncoder.encode(rtmpUrl, "UTF-8") + "';}}) ();";
                    webView.loadUrl(js);

                    js = "javascript:(function () { document.getElementsByClassName('" + element + "')[0].src = 'https://github.com/jabiers/lctvapp/blob/master/noflash.jpg?raw=true'}) ();";
                    webView.loadUrl(js);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private class CustomWebChromeViewClient extends WebChromeClient {
        public void onConsoleMessage(String message, int lineNumber, String sourceID) {
            Log.d("MyApplication", message + " -- From line "
                    + lineNumber + " of "
                    + sourceID);
        }
    }

    private class CustomWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {

            Log.d(TAG, "Should url : " + url);
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
                            int start = url.indexOf("rtmp:");
                            rtmp = url.substring(start);


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
            Log.d(TAG, "Page Started");

            streamTitle = null;
            chat = null;
            rtmp = null;

            removeHeaderElement(view);
            updateButtonStatus();
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void  onPageFinished(WebView view, String url) {
            Toast.makeText(getBaseContext(), "Page Finished url : " + url, Toast.LENGTH_LONG)
                    .show();

            view.loadUrl("javascript:(function () { var element = document.getElementsByClassName('update-browser-layer js-show-update-browser show')[0]; element.parentNode.removeChild(element); }) ();");

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

            Log.d(TAG, "finish javascript");

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

        @Override
        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
            Log.d(TAG, "error : " + error);
            Toast.makeText(getBaseContext(), "error : " + error, Toast.LENGTH_LONG)
                    .show();
            super.onReceivedError(view, request, error);
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

                int start = html.indexOf("rtmp://");
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
    private class DefaultAdapter extends BaseAdapter {
        private Context mContext;
        private List<WeakReference<View>> mRef = new ArrayList<WeakReference<View>>(0);
        private List<String> mData;
        private int mLayout;

        public DefaultAdapter(Context context, List<String> data, int layout) {
            super();
            mContext = context;
            mData = data;
            mLayout = layout;
        }

        public void setList(List<String> data) {
            mData = data;
        }

        @Override
        public int getCount() {
            return mData.size();
        }

        @Override
        public Object getItem(int position) {
            return mData.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ListViewHolder holder;

            if (convertView == null) {
                convertView = LayoutInflater.from(mContext).inflate(mLayout, parent, false);
                holder = new ListViewHolder();
                holder.tv_default = (TextView) convertView.findViewById(R.id.tv_default);
                convertView.setTag(holder);
            } else {
                holder = (ListViewHolder) convertView.getTag();
            }

            String str = mData.get(position);
            holder.tv_default.setText(str);

            mRef.add(new WeakReference<View>(convertView));

            return convertView;
        }

        public void removeData() {
//            for (WeakReference<View> ref : mRef) {
//                CommonUtils.removeAllView(ref.get());
//            }

            mRef.clear();
            mData.clear();
            mContext = null;
            mRef = null;
            mData = null;
        }

        public class ListViewHolder {
            TextView tv_default;
        }
    }
}
