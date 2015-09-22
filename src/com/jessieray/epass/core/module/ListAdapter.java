package com.jessieray.epass.core.module;

import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.List;

public class ListAdapter extends BaseAdapter {
	private List<ListCellBase> dataList;

	public void setDataList(List<ListCellBase> paramList) {
		this.dataList = paramList;
	}
	
	@Override
	public int getCount() {
		if(dataList != null) {
			return dataList.size();
		}
		return 0;
	}

	@Override
	public Object getItem(int position) {
		if ((dataList != null) && (!dataList.isEmpty())) {
			return dataList.get(position);
		}
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		View view = convertView;
		if ((dataList != null) && (!dataList.isEmpty())) {
			view = ((ListCellBase) dataList.get(position)).getView(convertView);
		}
		return view;
	}
}