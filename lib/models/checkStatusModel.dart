class CheckStatusModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  CheckStatusModel({this.isSuccess, this.result, this.message});

  CheckStatusModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['Result'] != null) {
      result = new List<Result>();
      json['Result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['Result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    return data;
  }
}

class Result {
  String reqNo;
  String jobStatus;
  String jobStatusName;
  String checklistId;
  String checklistName;
  String workPerform;
  String workDoc;
  String workLocation;
  String workType;

  Result(
      {this.reqNo,
      this.jobStatus,
      this.jobStatusName,
      this.checklistId,
      this.checklistName,
      this.workPerform,
      this.workDoc,
      this.workLocation,
      this.workType});

  Result.fromJson(Map<String, dynamic> json) {
    reqNo = json['req_no'];
    jobStatus = json['job_status'];
    jobStatusName = json['job_status_name'];
    checklistId = json['checklist_id'];
    checklistName = json['checklist_name'];
    workPerform = json['workPerform'];
    workDoc = json['workDoc'];
    workLocation = json['workLocation'];
    workType = json['WorkType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['req_no'] = this.reqNo;
    data['job_status'] = this.jobStatus;
    data['job_status_name'] = this.jobStatusName;
    data['checklist_id'] = this.checklistId;
    data['checklist_name'] = this.checklistName;
    data['workPerform'] = this.workPerform;
    data['workDoc'] = this.workDoc;
    data['workLocation'] = this.workLocation;
    data['WorkType'] = this.workType;
    return data;
  }
}
