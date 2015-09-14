package com.jessieray.epass.core.anntotion;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import com.jessieray.epass.config.AppConfig;

import android.app.Activity;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class InjectProcessor {
	
	private static final String METHOD_FIND_VIEW_BY_ID = "findViewById";
	private static final String METHOD_SET_CONTENT_VIEW = "setContentView";
	
	/**
	 * Activity Layout 布局注入
	 * @param activity
	 */
	public static void layoutInject(Activity activity) {
		LayoutInject layoutInject = activity.getClass().getAnnotation(LayoutInject.class);
		if(layoutInject != null) {
			int layoutId = layoutInject.layout();
			if(layoutId != -1) {
				try {
					Method method = activity.getClass().getMethod(METHOD_SET_CONTENT_VIEW, int.class);
					method.setAccessible(true);
					method.invoke(activity, layoutId);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * Activity 资源注入
	 * @param activity
	 */
	public static void viewInject(Activity activity) {
		Class<? extends Activity> clazz = activity.getClass();
		Field[] fields = clazz.getDeclaredFields();
		if(fields != null && fields.length > 0) {
			for (Field field : fields) {
				ViewInject viewInject = field.getAnnotation(ViewInject.class);
				if (viewInject != null) {
					int viewId = viewInject.id();
					if (viewId != -1) {
						try {
							Method method = clazz.getMethod(METHOD_FIND_VIEW_BY_ID, int.class);
							Object resView = method.invoke(activity, viewId);
							field.setAccessible(true);
							field.set(activity, resView);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}
	
	/**
	 * 点击事件注解
	 * @param activity Object 可以传入Activity和Fragment
	 * @param view 如果是Fragment需要传入view
	 */
	public static void eventInject(Object activity,View view) {
		Method[] methods = activity.getClass().getMethods();
		if(methods != null && methods.length > 0) {
			for(Method method : methods) {
				//拿到方法上的所有的注解  
				Annotation[] annotations = method.getAnnotations();
				for(Annotation annotation : annotations) {
					//拿到注解上的注解   
					EventBase eventBase = annotation.annotationType().getAnnotation(EventBase.class);
					if(eventBase != null) {
						//取出设置监听器的名称，监听器的类型，调用的方法名 
						Class<?> listenerType = eventBase.listenerType();
						String listenerSetter = eventBase.listenerSetter();
						String methodName = eventBase.methodName();
						try {
							//拿到Onclick注解中的id方法
							Method aMethod = annotation.annotationType().getDeclaredMethod("id");
					        //取出所有的viewId   
							int[] viewIds = (int[])aMethod.invoke(annotation, null);  
							//通过InvocationHandler设置代理   
							DynamicHandler handler = new DynamicHandler(activity);  
							handler.addMethod(methodName, method);  
							Object listener = Proxy.newProxyInstance(  
							listenerType.getClassLoader(),new Class<?>[] { listenerType }, handler);  
							//遍历所有的View，设置事件   
							for (int viewId : viewIds) { 
								View childView = null;
								if(activity.getClass().equals(Activity.class)) {
									childView = ((Activity) activity).findViewById(viewId); 
								} else {
									childView = view.findViewById(viewId); 
								}
								Method setEventListenerMethod = childView.getClass().getMethod(listenerSetter, listenerType);  
								setEventListenerMethod.invoke(childView, listener);  
							}  
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}
	
	/**
	 * Activity 资源事件注入
	 * @param activity
	 */
	public static void activityInject(Activity activity) {
		layoutInject(activity);
		viewInject(activity);
		eventInject(activity,null);
	}
	
	/**
	 * 注入Fragment布局文件
	 * @param fragment
	 * @param inflater
	 * @param container
	 * @return
	 */
	public static View injectFragmentLayout(Fragment fragment,LayoutInflater inflater,ViewGroup container) {
		View view = null;
		LayoutInject layoutInject = fragment.getClass().getAnnotation(LayoutInject.class);
		if(layoutInject != null) {
			int viewId = layoutInject.layout();
			if(viewId != -1) {
				view = inflater.inflate(viewId, container,false);
			}
		}
		return view;
	}
	
	/**
	 * 注入fragment资源
	 * @param fragment
	 * @param view
	 */
	public static void injectFragmentView(Fragment fragment,View view) {
		Field[] fields = fragment.getClass().getDeclaredFields();
	    if (fields != null && fields.length > 0) {
			for (Field field : fields) {
				ViewInject viewInject = field.getAnnotation(ViewInject.class);
				if (viewInject != null) {
					int viewId = viewInject.id();
					if (viewId != -1) {
						field.setAccessible(true);
						try {
							field.set(fragment, view.findViewById(viewId));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}
	
	/**
	 * fragment资源注入
	 * @param fragment
	 * @param view fragment布局文件
	 */
	public static void injectFragment(Fragment fragment,View view) {
		injectFragmentView(fragment,view);
	    eventInject(fragment,view);
	}
	
	/**
	 * 注解listview item
	 * @param viewHolder
	 * @return
	 */
	public static View injectListViewHolder(Object viewHolder) {
		View view = null;
		try {
			LayoutInject layoutInject = viewHolder.getClass().getAnnotation(LayoutInject.class);
			if(layoutInject != null) {
				int layoutid = layoutInject.layout();
				if(layoutid != -1) {
					LayoutInflater inflater = LayoutInflater.from(AppConfig.context);
					view = inflater.inflate(layoutid, null);
				}
			}
			if(view != null) {
				Field[] fields = viewHolder.getClass().getDeclaredFields();
				if(fields != null && fields.length > 0) {
					for(Field field : fields) {
						ViewInject viewInject = field.getAnnotation(ViewInject.class);
						if(viewInject != null) {
							int viewId = viewInject.id();
							if(viewId != -1) {
								field.setAccessible(true);
								field.set(viewHolder, view.findViewById(viewId));
							}
						}
					}
				}
			    eventInject(viewHolder,view);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return view;
	}
}
