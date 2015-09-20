package com.lctvapp.lctv.Activities.RootActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.lctvapp.lctv.Common.BaseWebViewActivity;
import com.lctvapp.lctv.R;

/**
 * Created by daehyun on 15. 9. 20..
 */
public class RootActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_root);

        Intent intent = new Intent(this, BaseWebViewActivity.class);
        startActivity(intent);
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        Intent intent = new Intent(this, BaseWebViewActivity.class);
        startActivity(intent);
    }
}
