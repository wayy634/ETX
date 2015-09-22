package com.jessieray.epass.core.module;

import android.view.View;

public abstract interface ListCellBase {
	
	/**
	 * 获取视图
	 * @param convertView
	 * @return
	 */
	public abstract View getView(View convertView);
}
