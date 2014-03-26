package com.llk.gamehall.entity;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable
public class Message {

	public static final int STATUS_TYPE_SYSTEM = 0;
	public static final int STATUS_TYPE_RECEIVE = 1;
	public static final int STATUS_TYPE_SEND = 2;

	public static final int TYPE_TEXT = 1;
	public static final int TYPE_IMAGE = 2;

	/** 自增主键 */
	@DatabaseField(generatedId = true, columnName = "_id")
	private Integer id;
	/** 发送人Id */
	@DatabaseField
	private Integer sendId;
	/** 发送人昵称 */
	@DatabaseField
	private String sendNickName;
	/** 发送人头像 */
	@DatabaseField
	private Integer sendAvatar;
	/** 接收人Id */
	@DatabaseField
	private Integer receiveId;
	/** 消息内容 */
	@DatabaseField
	private String content;
	/** 发送或接受时间戳 */
	@DatabaseField
	private Integer datetime;
	/** 发送或接受时间 */
	@DatabaseField
	private String dateStr;
	/** 0:系统 1:接收 2:发送 */
	@DatabaseField
	private Integer status;
	/** 消息类型 */
	@DatabaseField
	private Integer type;
	/** 消息图片url */
	@DatabaseField
	private String imageUrl;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getSendId() {
		return sendId;
	}

	public void setSendId(Integer sendId) {
		this.sendId = sendId;
	}

	public Integer getReceiveId() {
		return receiveId;
	}

	public void setReceiveId(Integer receiveId) {
		this.receiveId = receiveId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getDatetime() {
		return datetime;
	}

	public void setDatetime(Integer datetime) {
		this.datetime = datetime;
	}

	public String getDateStr() {
		return dateStr;
	}

	public void setDateStr(String dateStr) {
		this.dateStr = dateStr;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getSendNickName() {
		return sendNickName;
	}

	public void setSendNickName(String sendNickName) {
		this.sendNickName = sendNickName;
	}

	public Integer getSendAvatar() {
		return sendAvatar;
	}

	public void setSendAvatar(Integer sendAvatar) {
		this.sendAvatar = sendAvatar;
	}

}
