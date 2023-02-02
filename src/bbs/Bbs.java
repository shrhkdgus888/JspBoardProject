package bbs;

import java.sql.Timestamp;
import java.util.Date;

public class Bbs {
	
	private int bbsID;
	private String bbsTitle;
	private String userID;
	private Timestamp regDate;
	private String bbsContent;
	private int bbsAvailable;
	
	public int getBbsID() {
		return bbsID;
	}

	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public Timestamp getRegDate() {
		return regDate;
	}

	public void setRegDate(Timestamp regDate) {
		this.regDate = regDate;
	}

	public String getBbsContent() {
		return bbsContent;
	}

	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public int getBbsAvailable() {
		return bbsAvailable;
	}

	public void setBbsAvailable(int bbsAvailable) {
		this.bbsAvailable = bbsAvailable;
	}

	//기본(default)생성자 생성
	public Bbs() {}
	
	//필요성에 의해 사용할 수 있도록 생성자 생성
	public Bbs(int bbsID, String bbsTitle, String userID, Timestamp regDate, String bbsContent, int bbsAvailable) {
		super();
		this.bbsID = bbsID;
		this.bbsTitle = bbsTitle;
		this.userID = userID;
		this.regDate = regDate;
		this.bbsContent = bbsContent;
		this.bbsAvailable = bbsAvailable;
	}
	
	

	
	//값 확인을 편하게 하기위한 toString
	public String toString() {
		return "Bbs [bbsID=" + bbsID + ", bbsTitle=" + bbsTitle + ", userID=" + userID + ", regDate=" + regDate + ", bbsContent="
				+ bbsContent + ",bbsAvailable=" + bbsAvailable +"]";
	}
}


