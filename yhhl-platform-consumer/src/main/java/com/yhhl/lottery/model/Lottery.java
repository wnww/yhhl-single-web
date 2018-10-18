package com.yhhl.lottery.model;

import java.util.Date;

import org.codehaus.jackson.map.annotate.JsonSerialize;

import com.yhhl.common.CustomDateTimeSerializer;
/**
 * 
 * <br>
 * <b>功能：</b>LotteryEntity<br>
 * <b>作者：</b>www.yhsoft.top<br>
 * <b>日期：</b> June 15, 2015 <br>
 * <b>版权所有：<b>版权所有(C) 2013，瀛海互联<br>
 */
public class Lottery {
	
	
	
	@Override
	public int hashCode() {
		Lottery lty = (Lottery) this;
		System.out.println("Hash的原内容：" + lty.getExpectId());
		return expectId.hashCode();
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Lottery) {
			Lottery lty = (Lottery) obj;
            System.out.println("equal"+ lty.getExpectId());
            return (expectId.equals(lty.getExpectId()));
        }
        return super.equals(obj);
	}
	
	
}
