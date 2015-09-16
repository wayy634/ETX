package com.jessieray.epass.core;

import java.lang.reflect.Type;

import com.jessieray.epass.R;
import com.jessieray.epass.core.anntotion.InjectProcessor;
import com.jessieray.epass.core.module.HeadRef;
import com.jessieray.epass.core.module.HeadView;
import com.jessieray.epass.core.module.HeadView.HeadViewBtnOnClickListener;
import com.jessieray.epass.util.Tools;
import com.mome.api.request.base.ResponseCallback;
import com.mome.api.request.base.ResponseError;
import com.mome.api.request.base.ResponseResult;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class BaseFragment extends Fragment implements HeadViewBtnOnClickListener,ResponseCallback{
	
	/**
	 * 页面视图
	 */
	private View rootView;
	/**
	 * 头布局
	 */
	public HeadView headView;
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
	}

	@Override
	public void onAttach(Activity activity) {
		// TODO Auto-generated method stub
		super.onAttach(activity);
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		if(rootView == null) {
			rootView = InjectProcessor.injectFragmentLayout(this,inflater, container);
			InjectProcessor.injectFragment(this, rootView);
			addHeadView(rootView);
		} else {
			ViewGroup parent = (ViewGroup) rootView.getParent();
			if (parent != null) {
				parent.removeView(rootView);
			}
		}
		return rootView;
	}
	
	/**
	 * 添加头布局
	 * @param view
	 */
	private void addHeadView(View view) {
		if(view != null) {
			HeadRef headRef = (HeadRef)rootView.findViewById(R.id.head_layout);
			if(headRef != null) {
				headView = new HeadView(headRef,this);
				FragmentTransaction transaction = this.getChildFragmentManager().beginTransaction();
				transaction.replace(R.id.head_layout, headView);
				transaction.commit();
			}
		}
	}
	
	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}

	@Override
	public void onDestroyView() {
		// TODO Auto-generated method stub
		super.onDestroyView();
	}

	@Override
	public void onDetach() {
		// TODO Auto-generated method stub
		super.onDetach();
	}

	@Override
	public void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
	}

	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	@Override
	public void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
	}

	@Override
	public void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
	}

	@Override
	public void leftOnClick() {
		Tools.pullScreen();
	}

	@Override
	public void rightOnClick() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void editTextChange() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void error(ResponseError arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public <T> void sucess(Type arg0, ResponseResult<T> arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean isRefreshNeeded() {
		// TODO Auto-generated method stub
		return false;
	}
}
