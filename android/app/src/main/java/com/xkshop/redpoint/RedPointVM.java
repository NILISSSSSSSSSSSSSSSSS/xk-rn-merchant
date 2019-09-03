package com.xkshop.redpoint;

import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.ViewModel;

import java.util.List;

import cn.scshuimukeji.database.table.annotations.SessionSubType;
import cn.scshuimukeji.database.table.im.IMSessionInfo;
import cn.scshuimukeji.im.core.data.repository.IMSessionRepository;
import cn.scshuimukeji.im.core.data.repository.impl.IMSessionRepositoryImpl;

/**
 * Author:柏洲
 * Email: baizhoussr@gmail.com
 * Date:  2019/4/17 10:10
 * Desc:  获取会话信息VM
 */
public class RedPointVM extends ViewModel {

    /**
     * 『IM 会话』Repository.
     */
    private IMSessionRepository imContactRepository = new IMSessionRepositoryImpl();

    /**
     * 获取多个子类型会话.
     *
     * @param owner     生命周期的 Owner .
     * @param accountId 数据所属账号 ID.
     * @param subTypes  会话子类型数组.
     * @return 指定类型的会话集合, 按时间排序.
     */
    public LiveData<List<IMSessionInfo>> getMultipleTypeSession(LifecycleOwner owner, String accountId, @SessionSubType int[] subTypes) {
        return imContactRepository.getMultipleTypeSession(owner, accountId, subTypes);
    }
}
