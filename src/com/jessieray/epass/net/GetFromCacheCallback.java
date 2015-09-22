package com.jessieray.epass.net;

import com.mome.api.request.base.ResponseCallback;
import com.mome.api.request.base.ResponseError;
import com.mome.api.request.base.ResponseResult;

import java.lang.reflect.Type;

public class GetFromCacheCallback implements ResponseCallback {
	
	public void error(ResponseError paramResponseError) {
	}

	public <T> void sucess(Type paramType, ResponseResult<T> paramResponseResult) {
	}

	@Override
	public boolean isRefreshNeeded() {
		// TODO Auto-generated method stub
		return false;
	}
	
	public boolean isResponseFromCache() {
		return true;
	}
}
