package com.jessieray.epass.util;

import java.io.IOException;

import com.android.volley.toolbox.ImageLoader.ImageCache;
import com.jessieray.epass.db.DataSaveManager;

import android.graphics.Bitmap;
import android.support.v4.util.LruCache;
import android.text.TextUtils;

public class BitmapCache implements ImageCache {

	private LruCache<String, Bitmap> mCache;
	private final int MAXSIZE = 10 * 1024 * 1024;
	private String md5Url;

	public BitmapCache() {
		mCache = new LruCache<String, Bitmap>(MAXSIZE) {
			@Override
			protected int sizeOf(String key, Bitmap value) {
				return value.getRowBytes() * value.getHeight();
			}

		};
	}

	@Override
	public Bitmap getBitmap(String url) {
		if(TextUtils.isEmpty(url)) 
			return null;
		Bitmap bitmap = mCache.get(url);
    	if(bitmap == null) {
    		try {
    			md5Url = Tools.toMd5(url.substring(url.lastIndexOf("/")+1, url.length()).getBytes());
    			bitmap = DataSaveManager.getInstance().getImageFromSdcard(md5Url);
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
		return bitmap;
	}

	@Override
	public void putBitmap(String url, Bitmap bitmap) {
		mCache.put(url, bitmap);
		if(bitmap != null) {
			try {
				md5Url = Tools.toMd5(url.substring(url.lastIndexOf("/")+1, url.length()).getBytes());
				DataSaveManager.getInstance().saveImage(md5Url, bitmap);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

}
