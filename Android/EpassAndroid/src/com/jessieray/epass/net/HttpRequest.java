package com.jessieray.epass.net;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.android.volley.AuthFailureError;
import com.android.volley.Cache;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ObjectRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.jessieray.epass.config.AppConfig;
import com.jessieray.epass.core.module.UserProperty;
import com.jessieray.epass.db.DataSaveManager;
import com.jessieray.epass.util.BitmapCache;
import com.jessieray.epass.util.Tools;
import com.mome.api.request.base.ResponseCallback;
import com.mome.api.request.base.ResponseError;
import com.mome.api.request.base.ResponseResult;

import android.text.TextUtils;

public class HttpRequest implements com.mome.api.request.base.Request {
	
	private static HttpRequest httpRequest;
	/**
	 * 图片加载器
	 */
	public ImageLoader imageLoader;
	/**
	 * 消息队列
	 */
	public RequestQueue requestQueue;
	
	public static HttpRequest getInstance() {
		if (httpRequest == null)
			httpRequest = new HttpRequest();
		return httpRequest;
	}

	private HttpRequest() {
		requestQueue = Volley.newRequestQueue(AppConfig.mainActivity);
		requestQueue.start();
		imageLoader = new ImageLoader(requestQueue, new BitmapCache());  
	}
	
	@Override
	public String getRequestUrl() {
		if(AppConfig.DEBUG) {
			AppConfig.url = AppConfig.HTTP_URL[0];
		} else {
			AppConfig.url = AppConfig.HTTP_URL[1];
		}
		return AppConfig.url;
	}

	/**
	 * 取消当前请求
	 * @param <T>
	 */
	public <T> void cancelRequest(Class<T> clazz) {
		requestQueue.cancelAll(clazz);
	}

	/**
	 * 取消所有请求
	 */
	public void cancelAllRequest() {
		requestQueue.cancelAll();
	}
	
	/**
	 * 获取缓存响应数据
	 * @param url 缓存key
	 * @param resultType 响应类型
	 * @return
	 */
	public ResponseResult<?> getCacheResult(String url,Type resultType) {
		Cache.Entry entry = requestQueue.getCache().get(url);
		if(entry == null) {
			return null;
		}
		String parsed;
		try {
			parsed = new String(entry.data, HttpHeaderParser.parseCharset(entry.responseHeaders));
		} catch (UnsupportedEncodingException e) {
			parsed = new String(entry.data);
		}
	    GsonBuilder gsonBuilder = new GsonBuilder();
	    gsonBuilder.setDateFormat("yyyy-MM-dd HH:mm:ss");
	    Gson gson = gsonBuilder.create();
	    ResponseResult<?> response = (ResponseResult<?>) gson.fromJson(parsed, resultType);
	    return response;
	}
	
	/**
	 * 获取组装签名数据后的参数
	 * 
	 * @param params
	 *            原始协议参数
	 * @param timestamp
	 *            时间戳
	 * @return
	 */
	private Map<String, String> getSignParams(Map<String, String> params, long timestamp) {
		Map<String, String> signParams = new HashMap<String, String>();
		signParams.putAll(params);
		signParams.put(AppConfig.TIMESTAMP_STRING, String.valueOf(timestamp));
		if (TextUtils.isEmpty(params.get("uid"))
				&& !TextUtils.isEmpty(UserProperty.getInstance().getUid())) {
			signParams.put("uid", UserProperty.getInstance().getUid());
		}
		signParams.put("deviceId", AppConfig.DEVICE_TOKEN);
		signParams.put("clientId", AppConfig.DEVICE_TOKEN);
		signParams.put("deviceType", AppConfig.DEVICE_TYPE);
		signParams.put("version", AppConfig.CLIENT_VERSION_VALUE);
		if (!TextUtils.isEmpty(AppConfig.DEV_APPKEY_VALUE)) {
			signParams.put("appkey", AppConfig.DEV_APPKEY_VALUE);
		} else {
			signParams.put("sourceId", AppConfig.SOURCE_ID);
			signParams.put("platform", AppConfig.PLATFORM_VALUE);
		}
		try {
			if (!TextUtils.isEmpty(AppConfig.SCRET_KEY)) {
				signParams.put(AppConfig.SIGN,	Tools.getSign(signParams, AppConfig.SCRET_KEY));
				Tools.Log("网络用户相关请求signKey：" + AppConfig.SCRET_KEY);
			} else {
				Tools.Log("网络用户无关请求signKey：" + Tools.getSecret(String.valueOf(Tools.getMogoTimestamp(timestamp))));
				signParams.put(AppConfig.SIGN, Tools.getSign(signParams, Tools.getSecret(String.valueOf(Tools.getMogoTimestamp(timestamp)))));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return signParams;
	}

	/**
	 * 构造post请求url
	 * 
	 * @param url
	 *            原始url
	 * @param signParams
	 *            签名后参数
	 * @return
	 */
	private String getPostUrl(String url, Map<String, String> signParams) {
		StringBuffer strbuf = new StringBuffer();
		strbuf.append(url);
		strbuf.append("?deviceId=");
		strbuf.append(AppConfig.DEVICE_TOKEN);
		strbuf.append("&clientId=");
		strbuf.append(AppConfig.DEVICE_TOKEN);//push没有暂时用deviceId代替
		strbuf.append("&deviceType=");
		strbuf.append(AppConfig.DEVICE_TYPE);
		if (!TextUtils.isEmpty(AppConfig.DEV_APPKEY_VALUE)) {
			strbuf.append("&appkey=");
			strbuf.append(AppConfig.DEV_APPKEY_VALUE);
		} else {
			strbuf.append("&sourceId=");
			strbuf.append(AppConfig.SOURCE_ID);
			strbuf.append("&platform=");
			strbuf.append(AppConfig.PLATFORM_VALUE);
		}
		strbuf.append("&version=");
		strbuf.append(AppConfig.CLIENT_VERSION_VALUE);
		strbuf.append("&" + AppConfig.TIMESTAMP_STRING + "=");
		strbuf.append(signParams.get(AppConfig.TIMESTAMP_STRING));
		strbuf.append("&" + AppConfig.SIGN + "=");
		strbuf.append(signParams.get(AppConfig.SIGN));
		if (TextUtils.isEmpty(signParams.get("uid")) && !TextUtils.isEmpty(UserProperty.getInstance().getUid())) {
			strbuf.append("&uid=");
			strbuf.append(UserProperty.getInstance().getUid());
		}
		Tools.Log("网络请求url:" + strbuf.toString());
		return strbuf.toString();
	}

	/**
	 * 构造Get请求url
	 * 
	 * @param url
	 * @param signParams
	 * @return
	 */
	private String getGetUrl(String url, Map<String, String> signParams) {
		StringBuilder strbuf = new StringBuilder();
		for (Map.Entry<String, String> paramEntry : signParams.entrySet()) {
			if (strbuf.length() > 0) {
				strbuf.append("&");
			}
			strbuf.append(paramEntry.getKey()).append("=").append(paramEntry.getValue());
		}
		strbuf.insert(0, "?").insert(0, url);
		Tools.Log("网络请求url:" + strbuf.toString());
		return strbuf.toString();
	}
	
	@Override
	public void doRequest(String url, int method, final Map<String, String> params, final Type resultType, final ResponseCallback callback) {
		Map<String, String> signParams = new HashMap<String, String>();
		String cacheKey = url;
		signParams.putAll(params);
		try {
			if (AppConfig.updateTimestamp == 0) {
				String tempTime = DataSaveManager.getInstance().read("updateTimestamp");
				if (!TextUtils.isEmpty(tempTime)) {
					AppConfig.updateTimestamp = Long.parseLong(tempTime);
				}
			}
			long timestamp = System.currentTimeMillis() - AppConfig.updateTimestamp;
//			signParams = getSignParams(signParams, timestamp);
			
			if (method == AppConfig.HTTP_POST || method == AppConfig.HTTP_PUT) {
				url = getPostUrl(url, signParams);
			} else if (method == AppConfig.HTTP_GET) {
				url = getGetUrl(url, signParams);
			}
			
			String timestampKey = Tools.substringBetween(url, AppConfig.TIMESTAMP_STRING+"=", "&");
			String sign = Tools.substringBetween(url, AppConfig.SIGN+"=", "&");
			cacheKey = StringUtils.replace(url, timestampKey, "");
			cacheKey = StringUtils.replace(cacheKey, sign, "");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(callback instanceof GetFromCacheCallback && ((GetFromCacheCallback)callback).isResponseFromCache()) {
			ResponseResult<?> response = getCacheResult(cacheKey,resultType);
			if(response != null) {
				try {
					callback.sucess(resultType,	response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return;
			}
		}
		Response.BaseModelListener<ResponseResult<?>> succeedListener = new Response.BaseModelListener<ResponseResult<?>>() {
			public void onResponse(ResponseResult<?> response, boolean isFromCache) {
//				AppConfig.updateTimestamp = System.currentTimeMillis()	- response.getServerTimeMillis();
				DataSaveManager.getInstance().save("updateTimestamp", String.valueOf(AppConfig.updateTimestamp));
				if(AppConfig.DEBUG) {
					Gson gson = new Gson();
					String temp = gson.toJson(response);
					Tools.Log("响应成功:"+temp);
				}
				if(!isFromCache) {
//					Tools.showToastContent("来网络的数据");
					AppConfig.updateTimestamp = System.currentTimeMillis() - response.getServerTimeMillis();
					DataSaveManager.getInstance().save("updateTimestamp", String.valueOf(AppConfig.updateTimestamp));
				}
				callback.sucess(resultType,	response);
			}
		};
		Response.ErrorListener errorListener = new Response.ErrorListener() {
			public void onErrorResponse(VolleyError error) {
				ResponseError responseError = new ResponseError();
				if (error.networkResponse != null) {
					responseError.setCode(error.networkResponse.statusCode);
				}
				responseError.setMessage(error.getMessage());
				callback.error(responseError);
				Tools.Log("响应错误:" + callback +"　　"+ error.getMessage());
			}
		};
		ObjectRequest objectRequest = null;
		if (method == AppConfig.HTTP_GET) {
			objectRequest = new ObjectRequest(url,succeedListener,errorListener) {
				
				@Override
				protected Type getClassType() {
					return resultType;
				}
			};
		} else if(method == AppConfig.HTTP_POST || method == AppConfig.HTTP_PUT) {
			objectRequest = new ObjectRequest(method,url,succeedListener,errorListener) {
				
				@Override
				protected Type getClassType() {
					return resultType;
				}

				@Override
				protected Map<String, String> getParams()	throws AuthFailureError {
					return params;
				}
				
			};
		}
		objectRequest.setRetryPolicy(new DefaultRetryPolicy(20000, 1, 1f));
		objectRequest.setCacheTime(30000);
		objectRequest.setCacheKey(cacheKey);
		objectRequest.setCacheRefreshNeeded(callback.isRefreshNeeded());
		requestQueue.add(objectRequest);
	}
}