import 'package:sqflite/sqflite.dart';
import 'package:wesafe/models/mastWorkListModel_test.dart';
import 'package:path/path.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/sqliteStationModel.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/my_constainDB.dart';

class SQLiteHelper {
  final int version = 1;

  SQLiteHelper() {
    initailDatabase();
  }

  Future<Null> initailDatabase() async {
    var databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, MyConstant.nameDatabase);
    await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      await database.execute(
          'CREATE TABLE ${MyConstainWorklistDB.nameTable} ( ' +
              ' id INTEGER PRIMARY KEY,' +
              ' ${MyConstainWorklistDB.columnworkID} INTEGER,' +
              ' ${MyConstainWorklistDB.columnuserID} TEXT,' +
              ' ${MyConstainWorklistDB.columnrsg} TEXT,' +
              ' ${MyConstainWorklistDB.columnownerID} TEXT ,' +
              ' ${MyConstainWorklistDB.columnmainWorkID} TEXT,' +
              ' ${MyConstainWorklistDB.columnsubWorkID} INTEGER,' +
              ' ${MyConstainWorklistDB.columnChecklistID} INTEGER,' +
              ' ${MyConstainWorklistDB.columnLat} TEXT,' +
              ' ${MyConstainWorklistDB.columnLng} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkPerform} TEXT, ' +
              ' ${MyConstainWorklistDB.columnRemark} TEXT, ' +
              ' ${MyConstainWorklistDB.columnIsChoice} INTEGER, ' +
              ' ${MyConstainWorklistDB.columnReason} TEXT, ' +
              ' ${MyConstainWorklistDB.columnMsgFromWeb} TEXT, ' +
              ' ${MyConstainWorklistDB.columnIsComplete} INTEGER, ' +
              ' ${MyConstainWorklistDB.columnUploadDate} TEXT, ' +
              ' ${MyConstainWorklistDB.columnCreateDate} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkRegion} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkProvince} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkStation} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkType} TEXT, ' +
              ' ${MyConstainWorklistDB.columnWorkDoc} TEXT, ' +
              ' ${MyConstainWorklistDB.columnImgList} TEXT ' +
              ')');

      await database.execute(
          'CREATE TABLE ${MyConstainUserProfileDB.nameUserTable} ( ' +
              ' ${MyConstainUserProfileDB.columnUserID} TEXT PRIMARY KEY,' +
              ' ${MyConstainUserProfileDB.columnFirstName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnLastName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnPosition} TEXT,' +
              ' ${MyConstainUserProfileDB.columnDeptName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnRegionCode} TEXT,' +
              ' ${MyConstainUserProfileDB.columnTeamName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnLeaderId} TEXT,' +
              ' ${MyConstainUserProfileDB.columnLeaderName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnOwnerID} TEXT,' +
              ' ${MyConstainUserProfileDB.columnOwnerName} TEXT,' +
              ' ${MyConstainUserProfileDB.columnOwnerDesc} TEXT,' +
              ' ${MyConstainUserProfileDB.columnUserRole} TEXT,' +
              ' ${MyConstainUserProfileDB.columnCanApprove} TEXT,' +
              ' ${MyConstainUserProfileDB.columnPincode} TEXT,' +
              ' ${MyConstainUserProfileDB.columnCreatedDate} TEXT' +
              ')');

      await database.execute(
          'CREATE TABLE ${MyConstainImagesDB.nameUserTable} ( ' +
              ' id INTEGER PRIMARY KEY,' +
              ' ${MyConstainImagesDB.columnworkID} TEXT ,' +
              ' ${MyConstainImagesDB.columnmainWorkID} TEXT ,' +
              ' ${MyConstainImagesDB.columnsubWorkID} INTEGER ,' +
              ' ${MyConstainImagesDB.columnChecklistID} INTEGER,' +
              ' ${MyConstainImagesDB.columnSequenceImg} INTEGER,' +
              ' ${MyConstainImagesDB.columnBase64Img} TEXT,' +
              ' ${MyConstainImagesDB.columnCreateDate} TEXT,' +
              ' ${MyConstainImagesDB.columnUploadDate} TEXT,' +
              ' ${MyConstainImagesDB.columnIsComplete} TEXT ' +
              ')');

      await database.execute(
          'CREATE TABLE ${MyConstainPercelDB.nameTable} ( ' +
              ' id INTEGER PRIMARY KEY,' +
              ' ${MyConstainPercelDB.columnworkID} TEXT,' +
              ' ${MyConstainPercelDB.columnmainWorkID} TEXT ,' +
              ' ${MyConstainPercelDB.columnsubWorkID} INTEGER ,' +
              ' ${MyConstainPercelDB.columnChecklistID} INTEGER,' +
              ' ${MyConstainPercelDB.columnItem} TEXT,' +
              ' ${MyConstainPercelDB.columnAmount} INTEGER,' +
              ' ${MyConstainPercelDB.columnCreateDate} TEXT,' +
              ' ${MyConstainPercelDB.columnIsComplete} INTEGER ' +
              ')');

      await database.execute(
          'CREATE TABLE ${MyConstainStationInfoDB.nameStationTable} ( ' +
              ' id INTEGER PRIMARY KEY,' +
              ' ${MyConstainStationInfoDB.columnRegionCode} TEXT,' +
              ' ${MyConstainStationInfoDB.columnRegionName} TEXT ,' +
              ' ${MyConstainStationInfoDB.columnProvince} TEXT ,' +
              ' ${MyConstainStationInfoDB.columnStationId} TEXT,' +
              ' ${MyConstainStationInfoDB.columnStationName} TEXT,' +
              ' ${MyConstainStationInfoDB.columnCreateDate} TEXT,' +
              ' ${MyConstainStationInfoDB.columnUpdatedDate} TEXT ' +
              ')');
    });
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), MyConstant.nameDatabase));
  }

// user
  Future<Null> insertUserDatebase(SQLiteUserModel sqLiteUserModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        MyConstainUserProfileDB.nameUserTable,
        sqLiteUserModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insertUserDatebase database SQLite success');
    } catch (e) {}
  }

  Future<List<SQLiteUserModel>> readUserDatabase() async {
    Database database = await connectedDatabase();
    List<SQLiteUserModel> models = [];
    List<Map<String, dynamic>> maps =
        await database.query(MyConstainUserProfileDB.nameUserTable);

    for (var item in maps) {
      SQLiteUserModel model = SQLiteUserModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

//*********  WORKLIST  *************************************/
  Future<List<SQLiteWorklistModel>> selectLastestWorkID() async {
    Database database = await connectedDatabase();
    List<SQLiteWorklistModel> models = [];
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT ${MyConstainWorklistDB.columnworkID}  " +
            "FROM ${MyConstainWorklistDB.nameTable}  " +
            "ORDER BY ${MyConstainWorklistDB.columnworkID} DESC  " +
            "LIMIT 1");

    for (var item in maps) {
      SQLiteWorklistModel model = SQLiteWorklistModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> insertWorkDatebase(
      SQLiteWorklistModel sqLiteWorklistModel) async {
    Map<String, dynamic> maps = sqLiteWorklistModel.toMap();

    print("#### insertWorkDatebase ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        MyConstainWorklistDB.nameTable,
        sqLiteWorklistModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insertWorkDatebase database SQLite success');
    } catch (e) {}
  }

  Future<List<SQLiteWorklistModel>> readWorkDatabase() async {
    Database database = await connectedDatabase();
    List<SQLiteWorklistModel> models = [];
    try {
      List<Map<String, dynamic>> maps =
          await database.query(MyConstainWorklistDB.nameTable);
      for (var item in maps) {
        SQLiteWorklistModel model = SQLiteWorklistModel.fromMap(item);
        models.add(model);
      }
    } catch (e) {
      print("########## readWorkDatabase()  Error : ${e.toString()}");
    }

    return models;
  }

  Future<Null> deleteWorkAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(MyConstainWorklistDB.nameTable);
      print('====> delete work success');
    } catch (e) {}
  }

//*********  STATION  *************************************/

  Future<Null> insertStation(SQLiteStationModel sqLiteStationModel) async {
    Map<String, dynamic> maps = sqLiteStationModel.toMap();

    print("#### insertWorkDatebase ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        MyConstainStationInfoDB.nameStationTable,
        sqLiteStationModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insertWorkDatebase database SQLite success');
    } catch (e) {}
  }

  Future<List<SQLiteStationModel>> readStation() async {
    Database database = await connectedDatabase();
    List<SQLiteStationModel> models = [];
    List<Map<String, dynamic>> maps = await database.query(
        MyConstainStationInfoDB.nameStationTable,
        distinct: true,
        columns: [MyConstainStationInfoDB.columnRegionName]);
    for (var item in maps) {
      SQLiteStationModel model = SQLiteStationModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<SQLiteStationModel>> readStationByRegion(String region) async {
    Database database = await connectedDatabase();
    List<SQLiteStationModel> models = [];
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT ${MyConstainStationInfoDB.columnProvince}  " +
            "FROM ${MyConstainStationInfoDB.nameStationTable}  " +
            "WHERE ${MyConstainStationInfoDB.columnRegionName}=?",
        ['$region']);
    for (var item in maps) {
      SQLiteStationModel model = SQLiteStationModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<SQLiteStationModel>> readStationByProvince(
      String province) async {
    Database database = await connectedDatabase();
    List<SQLiteStationModel> models = [];
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT ${MyConstainStationInfoDB.columnStationName}  " +
            "FROM ${MyConstainStationInfoDB.nameStationTable}  " +
            "WHERE ${MyConstainStationInfoDB.columnProvince}=?",
        ['$province']);
    for (var item in maps) {
      SQLiteStationModel model = SQLiteStationModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deleteStationAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(MyConstainStationInfoDB.nameStationTable);
      print('====> delete Station success');
    } catch (e) {}
  }

  ///*********************************************************************** */

//example
  Future<Null> insertDatebase(MastWorkListModel masterWorkListModel) async {
    Map<String, dynamic> maps = masterWorkListModel.toMap();

    print("#### insert ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        MyConstainWorklistDB.nameTable,
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<Null> insertDatebase2(MastWorkListModel masterWorkListModel) async {
    Map<String, dynamic> maps = masterWorkListModel.toMap();

    print("#### insert ${maps.values}");

    Database database = await connectedDatabase();
    try {
      database.insert(
        "TEST1",
        masterWorkListModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('######## insert database SQLite success');
    } catch (e) {}
  }

  Future<List<MastWorkListModel>> readDatabase2() async {
    Database database = await connectedDatabase();
    List<MastWorkListModel> models = [];
    List<Map<String, dynamic>> maps = await database.query("TEST1");

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<List<MastWorkListModel>> readDatabase() async {
    Database database = await connectedDatabase();
    List<MastWorkListModel> models = [];
    List<Map<String, dynamic>> maps =
        await database.query(MyConstainWorklistDB.nameTable);

    for (var item in maps) {
      MastWorkListModel model = MastWorkListModel.fromMap(item);
      models.add(model);
    }

    return models;
  }

  Future<Null> deleteSQLiteAll() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(MyConstainWorklistDB.nameTable);
      print('====> delete success');
    } catch (e) {}
  }

  Future<Null> updatePinCode(UserModel userModel) async {
    Map<String, dynamic> maps = userModel.toJson();
    Database database = await connectedDatabase();
    try {
      await database.update(MyConstainWorklistDB.nameTable, maps, where: '');
    } catch (e) {}
  }

  /************************** */
  Future<Null> dropDB() async {
    Database database = await connectedDatabase();
    try {
      await database.execute('DROP TABLE ${MyConstainWorklistDB.nameTable}');
    } catch (e) {
      print("#######  dropDB()  error r : " + e.toString());
    }
  }
} //class
