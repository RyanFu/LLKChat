package com.llk.gamehall.entity;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable
public class User implements Comparable<User>{

	/** 用户 */
	@DatabaseField(id = true)
	private Integer userId;
	/** 当前用户消息未读数 */
	@DatabaseField
	private Integer unReadNum;
	/** 最新消息的时间 */
	@DatabaseField
	private Integer datetime;
	/** 最新消息的Id */
	@DatabaseField
	private Integer messageId;

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getUnReadNum() {
		return unReadNum;
	}

	public void setUnReadNum(Integer unReadNum) {
		this.unReadNum = unReadNum;
	}

	public Integer getDatetime() {
		return datetime;
	}

	public void setDatetime(Integer datetime) {
		this.datetime = datetime;
	}

	public Integer getMessageId() {
		return messageId;
	}

	public void setMessageId(Integer messageId) {
		this.messageId = messageId;
	}

	@Override
	public int compareTo(User another) {
		return this.getDatetime().compareTo(another.getDatetime());
	}

}
